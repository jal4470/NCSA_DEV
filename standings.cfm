<!--- 
	FileName:	standings.cfm
	Created on: 08/13/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: Display Standings based on Division
	
MODS: mm/dd/yyyy - filastname - comments
05/20/2009 - aarnone - T:7761 - replacled teamname with function to format the team name.
5/24/2010 - b. cooper
9291-added game type L to queries
7/6/2010 B. Cooper
9466-removed mask over U7,U8 games.  recoded detail toggle to use jQuery
--->
 
<cfset mid = 4> 
<cfinclude template="_header.cfm">

<div id="contentText">

<CFIF isDefined("FORM.DIV")>
	<CFSET divSelected = FORM.DIV>
<CFELSE>
	<CFSET divSelected = 0>
</CFIF>

<cfoutput>
<H1 class="pageheading">NCSA Games Standings</H1>

<cfinvoke component="#SESSION.sitevars.cfcPath#Game" method="getGameDivisions" returnvariable="qGameDivs">
</cfinvoke>  

<form name="standing" action="standings.cfm" method="post">
	<label class="select_label" for="division_select">Which division would you like to see the standings for?</label>
	<div class="select_box">
		<SELECT id="division_select" name="div">
			<option value="0">Select a Division</option>
			<cfloop query="qGameDivs">
				<option value="#DIVISION#" <CFIF DIVISION EQ divSelected>selected</CFIF> >#DIVISION#</option>
			</cfloop>
		</SELECT>
	</div>
	<button type="submit" name="getGames" class="gray_btn select_btn">Enter</button>
	<!--- <input type="Submit" name="getGames" value="Enter"> --->
</form>
 
<CFIF divSelected NEQ 0>
	
	<CFQUERY name="DivTeams" datasource="#SESSION.DSN#">
		Select TEAM_ID, dbo.GetTeamName(T.Team_ID) AS TEAMNAME, StandingFactor 
		  from TBL_TEAM	T
		 Where Club_ID > 1 
		   and exists(Select 1 
		   				from V_Games 
					   where Division = <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.divSelected#">
						 and (game_type is null or game_type in ('',' ','Q','S','I','R','L','P')) 
				   		 and Home_TEAM_ID = T.TEAM_ID 
					  ) 
		union 
		Select TEAM_ID, dbo.GetTeamName(T.Team_ID) AS TEAMNAME, StandingFactor 
		  from TBL_TEAM	T
		 Where Club_ID > 1
		   and exists(Select 1 
		    		    from V_Games 
					   where Division = <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.divSelected#">
						 and (game_type is null or game_type in ('',' ','Q','S','I','R','L','P' )) 
						 and Visitor_TEAM_ID = T.TEAM_ID )
	</CFQUERY><!--- <cfdump var="#DivTeams#"> --->
	<CFSET ctTotalTeams = DivTeams.recordCount>
	
	<CFSET arrStandings = ArrayNew(2)>
	<!--- <CFSET arrGameDetails = []> --->

	<CFSET stGameDetails = structNew()>
	
	<CFLOOP query="DivTeams">
		<CFSET arrStandings[currentRow][1] = TEAM_ID>
		<CFSET arrStandings[currentRow][2] = TEAMNAME>
		<CFSET arrStandings[currentRow][3] = 0>  <!--- Game Played --->
		<CFSET arrStandings[currentRow][4] = 0>  <!--- Wins		--->
		<CFSET arrStandings[currentRow][5] = 0>  <!--- Loss		--->
		<CFSET arrStandings[currentRow][6] = 0>  <!--- Drawn		--->
		<CFSET arrStandings[currentRow][7] = 0>  <!--- Points 		--->
		<CFSET arrStandings[currentrow][8] = 0>  <!--- GF - Goals For		--->
		<CFSET arrStandings[currentRow][9] = 0>  <!--- GA - Goals Against	--->

		<CFIF len(trim(StandingFactor)) EQ 0>
			<CFSET standFact = 0>
		<CFELSE>
			<CFSET standFact = StandingFactor>
		</CFIF>
		<CFSET arrStandings[currentRow][10] = standFact>

		<CFSET stGameDetails[team_id] = structNew()>
		<!--- <CFSET stGameDetails[team_id].teamName =  TEAMNAME> --->
	</CFLOOP>

	<CFQUERY name="scores" datasource="#SESSION.DSN#">
		Select Home_TEAM_ID		, SCORE_HOME
			 , Visitor_TEAM_ID	, SCORE_VISITOR
			 , game_date		, game_time
			 , GAME_ID			, FieldAbbr,
			 game_type
		  from V_Games
		 Where Division = <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.divSelected#">
		   and SCORE_HOME is not Null 
		   and SCORE_VISITOR is not Null
		   and (game_type is null or game_type in ('',' ','Q','S','I','R','L','P' ) )
		 order by Home_TEAM_ID
	</CFQUERY> <!--- <cfdump var="#scores#"> --->
	

	<CFLOOP query="scores">
		<cfif game_type neq 'P'>
			<CFSET HScore = SCORE_HOME>
			<CFSET VScore = SCORE_VISITOR>
		<cfelse>
			<CFSET HScore = 0>
			<CFSET VScore = 0>
		</cfif>
		<!--- <CFIF mid(trim(divSelected), 2, 2) EQ "07" or mid(trim(divSelected), 2, 2) EQ "08"  >
			<CFSET HScore = 0>
			<CFSET VScore = 0>
		</CFIF> --->
		
		<CFSET HomeIndex    = 0>
		<CFSET VisitorIndex = 0>

		<cfloop from="1" to="#arrayLen(arrStandings)#" index="iTeam">
			<CFIF arrStandings[iTeam][1] EQ HOME_TEAM_ID>
				<CFSET HomeIndex = iTeam>
			</CFIF>
			<CFIF arrStandings[iTeam][1] EQ VISITOR_TEAM_ID>
				<CFSET VisitorIndex = iTeam>
			</CFIF>
		</cfloop>

		<CFSCRIPT>
			// Calculate Statistics
			If ( HScore > VScore and Game_type NEQ 'P')		// ---  HOME Side Won  ---
				{	HWin	= 1;
					HLoss	= 0;
					HDrawn	= 0;
					// New Rules. team wining by a margin of over 7 goals will be awarded 2 points
					if ( (HScore - VScore) > 7 )
					{	HPoints = 2;
					}else{
						HPoints	= 3;
					}
					VWin	= 0;
					VLoss	= 1;
					VDrawn	= 0;
					VPoints	= 0;
				}
			If ( HScore < VScore  and Game_type NEQ 'P')		// ---  VISITING Side Won  ---
				{	HWin	= 0;
					HLoss	= 1;
					HDrawn	= 0;
					HPoints	= 0;
					VWin	= 1;
					VLoss	= 0;
					VDrawn	= 0;
					// New Rules. team wining by a margin of over 7 goals will be awarded 2 points
					if ( (VScore - HScore) > 7 )
					{	VPoints	= 2;
					}else{
						VPoints = 3;
					}
				}
			If ( HScore == VScore  and Game_type NEQ 'P')		 // ---   Game Drawn   ---
				{	HWin	= 0;
					HLoss	= 0;
					HDrawn	= 1;
					HPoints	= 1;
					VWin	= 0;
					VLoss	= 0;
					VDrawn	= 1;
					VPoints	= 1;
				}
			if(game_type neq 'P')
			{
				// ---   standings HOME TEAM  ---
				arrStandings[HomeIndex][3] 		= arrStandings[HomeIndex][3]	 + 1;		 // Game Played, simple Accumulation
				arrStandings[HomeIndex][4] 		= arrStandings[HomeIndex][4]	 + HWin;	 // Wins
				arrStandings[HomeIndex][5] 		= arrStandings[HomeIndex][5]	 + HLoss;	 // Loss
				arrStandings[HomeIndex][6] 		= arrStandings[HomeIndex][6]	 + HDrawn;	 // Drawn
				arrStandings[HomeIndex][7] 		= arrStandings[HomeIndex][7]	 + HPoints;	 // Points
				arrStandings[HomeIndex][8] 		= arrStandings[HomeIndex][8]	 + HScore;	 // GF - Goals For
				arrStandings[HomeIndex][9] 		= arrStandings[HomeIndex][9]	 + VScore;	 // GA - Goals Against
				// ---   standings VISITING TEAM  ---
				arrStandings[VisitorIndex][3] 	= arrStandings[VisitorIndex][3]	 + 1;		 // Game Played, simple Accumulation
				arrStandings[VisitorIndex][4] 	= arrStandings[VisitorIndex][4]	 + VWin;	 // Wins
				arrStandings[VisitorIndex][5] 	= arrStandings[VisitorIndex][5]	 + VLoss;	 // Loss
				arrStandings[VisitorIndex][6] 	= arrStandings[VisitorIndex][6]	 + VDrawn;	 // Drawn
				arrStandings[VisitorIndex][7] 	= arrStandings[VisitorIndex][7]	 + VPoints;  // Points
				arrStandings[VisitorIndex][8] 	= arrStandings[VisitorIndex][8]	 + VScore;	 // GF - Goals For
				arrStandings[VisitorIndex][9] 	= arrStandings[VisitorIndex][9]	 + HScore;	 // GA - Goals Against
			}
			// -- game details HOME ---

			stGameDetails[Home_TEAM_ID][game_id]				= structNew();
			stGameDetails[Home_TEAM_ID][game_id].Game_Type 		= game_type;
			stGameDetails[Home_TEAM_ID][game_id].VteamID 		= Visitor_TEAM_ID;
			stGameDetails[Home_TEAM_ID][game_id].standings 		= arrStandings[VisitorIndex][2];
			stGameDetails[Home_TEAM_ID][game_id].Date   		= GAME_DATE;
			stGameDetails[Home_TEAM_ID][game_id].Time   		= GAME_TIME; 
			stGameDetails[Home_TEAM_ID][game_id].field  		= FieldAbbr;
			stGameDetails[Home_TEAM_ID][game_id].Hscore 		= SCORE_HOME;
			stGameDetails[Home_TEAM_ID][game_id].Vscore 		= SCORE_VISITOR;
			// -- game details VISITOR ---
			stGameDetails[Visitor_TEAM_ID][game_id]				= structNew();
			stGameDetails[Visitor_TEAM_ID][game_id].Game_type   = game_type;
			stGameDetails[Visitor_TEAM_ID][game_id].VteamID 	= Home_TEAM_ID;
			stGameDetails[Visitor_TEAM_ID][game_id].standings 	= arrStandings[HomeIndex][2];
			stGameDetails[Visitor_TEAM_ID][game_id].Date   		= GAME_DATE;
			stGameDetails[Visitor_TEAM_ID][game_id].Time  	 	= GAME_TIME; 
			stGameDetails[Visitor_TEAM_ID][game_id].field		= FieldAbbr;
			stGameDetails[Visitor_TEAM_ID][game_id].Hscore		= SCORE_VISITOR;
			stGameDetails[Visitor_TEAM_ID][game_id].Vscore		= SCORE_HOME;
		</CFSCRIPT>

	</CFLOOP>

	<!--- ------------------------------------------------------------
		//Initialize the sort array.
		//   Array will have the Points, and the Standing Array Index
	--->
	<CFLOOP from="1" to="#ctTotalTeams#" index="IDX">
		<CFSET SortedStandings[IDX][1] = arrStandings[IDX][7] + arrStandings[IDX][10]> <!--- Points --->
		<CFSET SortedStandings[IDX][2] = IDX>  <!---  Index of the Standings Array --->

		<!--- <cfset ctGameDetailTeams = ctTotalTeams * 3>
		<CFLOOP from="1" to="#ctGameDetailTeams#" index="IDX2">
			<CFSET SortedGamesDetails[IDX][IDX2][1] = IDX2 >
			<CFSET SortedGamesDetails[IDX][IDX2][2] = stGameDetails[IDX][IDX2].Date>
			<CFSET SortedGamesDetails[IDX][IDX2][3] = stGameDetails[IDX][IDX2].Time>
		</CFLOOP> --->
	</CFLOOP>
	
					 
	<!--- -------------------------------------------------------------------------
		 Sorting standing in the descending order of standing
	--->
	<CFLOOP from="1" to="#ctTotalTeams#" index="IDX">
		<CFLOOP from="#IDX#" to="#ctTotalTeams#" index="idx2">
			<CFSET SwapValues = 0>
			<CFIF len(trim(SortedStandings[IDX][1])) EQ 0>
				<CFSET SwapValues = 1>
			</CFIF>	

			<CFIF SwapValues EQ 0 AND SortedStandings[IDX][1] LT SortedStandings[Idx2][1]>
				<CFSET SwapValues = 1>
			</CFIF>
			<!---  When Points are TIED, position is based on 
					- Goals Difference
					- Goals For
			--->
			<CFIF SwapValues EQ 0 AND 
				( len(trim(SortedStandings[idx2][1])) )  AND 
				( SortedStandings[IDX][1] EQ SortedStandings[idx2][1] )> 
				<CFSET A1 = SortedStandings[IDX][2]>
				<CFSET A2 = SortedStandings[idx2][2]>
				<CFIF ( ( arrStandings[A1][8] - arrStandings[A1][9] )   LT  
						( arrStandings[A2][8] - arrStandings[A2][9] ) ) OR 
						( arrStandings[A1][8] LT arrStandings[A2][8] )  >
					<CFSET SwapValues = 1>
				</CFIF> 
			</CFIF>

			<CFIF SwapValues>
				<CFSET tPoints = SortedStandings[IDX][1]>
				<CFSET tIndex  = SortedStandings[IDX][2]>

				<CFSET SortedStandings[IDX][1] = SortedStandings[idx2][1]>
				<CFSET SortedStandings[IDX][2] = SortedStandings[idx2][2]>

				<CFSET SortedStandings[idx2][1] = tPoints>
				<CFSET SortedStandings[idx2][2] = tIndex>
			</CFIF>
		</CFLOOP>
	</CFLOOP>


	<h3 class="viewing_info"><span>Viewing:</span> #DIVSELECTED#</h3>

	<p style="margin-bottom: 20px;">Click on the Team name to display/hide the details of the played games.</p>

<div id="standings_wrapper" class="table_wrapper">
	<div class="container">
		<table id="standings_table" cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<thead>
			<tr>
				<th class="team_column no_icon">Team</th>
				<th><span class="no_mobile">Played</span><span class="mobile_only">GP</span></th>
				<th><span class="no_mobile">Win</span><span class="mobile_only">W</span></th>
				<th><span class="no_mobile">Loss</span><span class="mobile_only">L</span></th>
				<th><span class="no_mobile">Drawn</span><span class="mobile_only">D</span></th>
				<th><span class="no_mobile">Points</span><span class="mobile_only">P</span></th>
				<th>GF</th>
				<th>GA</th>
			</tr>
		</thead>
		<tbody>
			<cfloop from="1" to="#arrayLen(arrStandings)#" index="iTeam">
				<CFSET srtIdx = SortedStandings[iTeam][2]>
				<tr class="standings_row">
					<TD class=" team_column" nowrap>#arrStandings[srtIdx][2]#</TD>
					<TD nowrap>#arrStandings[srtIdx][3]#</TD>
					<TD nowrap>#arrStandings[srtIdx][4]#</TD>
					<TD nowrap>#arrStandings[srtIdx][5]#</TD>
					<TD nowrap>#arrStandings[srtIdx][6]#</TD>
					<TD nowrap>#arrStandings[srtIdx][7]#</TD>
					<TD nowrap>#arrStandings[srtIdx][8]#</TD>
					<TD nowrap>#arrStandings[srtIdx][9]#</TD>
		 		</tr>

		 		<!--- SCHEDULE OF RESULTS DROP DOWN --->
 				<tr class="hidden_row" style="display:none">
 					<td colspan="8" style="padding: 0;">
	 					<table class="results_table clearfix;" cellspacing="0" cellpadding="0">
	 						<thead class="no_mobile">
	 							<tr>
	 								<th>Opponent</th>
	 								<th>Game##</th>
	 								<th>Date</th>
	 								<th>Time</th>
	 								<th>GF</th>
	 								<th>GA</th>
	 							</tr>
	 						</thead>
	 						<tbody>
	 							<CFSET teamID = arrStandings[srtIdx][1]>
								<CFSET listGameOrd = ArrayToList( StructSort( stGameDetails[arrStandings[srtIdx][1]], "text", "ASC", "DATE" ) ) >
								<CFSET ctLOOP = 1>
								<CFLOOP list="#listGameOrd#" index="gid">
	 							<tr id="TRD#iTeam##ctLoop#" class="clearfix" #iif(stGameDetails[teamID][gid].game_type eq 'P',de('style="font-style:italic;"'),de(''))#>
	 								<td class="game_opponent"><span class="mobile_only">Opponent:</span> #repeatstring("&nbsp;",5)#  vs. #stGameDetails[teamID][gid].standings#  @  #stGameDetails[teamID][gid].field#</td>
	 								<td class="game_number"><span class="mobile_only">Game##:</span> #GID# #iif(stGameDetails[teamID][gid].game_type eq 'P',de('(P)'),de(''))#</td>
	 								<td class="game_date"><span class="mobile_only">Date:</span> #dateFormat(stGameDetails[teamID][gid].Date,"mm/dd/yy")#</td>
	 								<td class="game_time"><span class="mobile_only">Time:</span> #timeFormat(stGameDetails[teamID][gid].Time,"hh:mm tt")#</td>
	 								<td class="game_goals_for"><span class="mobile_only">Goals For:</span> #stGameDetails[teamID][gid].Hscore#</td>
	 								<td class="game_goals_against"><span class="mobile_only">Goals Against:</span> #stGameDetails[teamID][gid].Vscore#</td>
	 							</tr>
	 							<CFSET ctLOOP = ctLOOP + 1>
	 							</CFLOOP>
	 						</tbody>
	 					</table>
 					</td>
 				</tr>


<!--- 		<CFSET teamID = arrStandings[srtIdx][1]>
					<CFSET listGameOrd = ArrayToList( StructSort( stGameDetails[arrStandings[srtIdx][1]], "text", "ASC", "DATE" ) ) >
					<CFSET ctLOOP = 1>
					<CFLOOP list="#listGameOrd#" index="gid">
						<tr id="TRD#iTeam##ctLoop#" style="display:none">
							<td colspan="2" nowrap>
								 #repeatstring("&nbsp;",5)#  vs. #stGameDetails[teamID][gid].standings#  @  #stGameDetails[teamID][gid].field#
							</td>
							<td>(game## #GID#)</td>
							<td>#dateFormat(stGameDetails[teamID][gid].Date,"mm/dd/yy")#</td>
							<td>#timeFormat(stGameDetails[teamID][gid].Time,"hh:mm tt")#</td>
							<td></td>
							<td>
								#stGameDetails[teamID][gid].Hscore#
							</td>
							<td>
								#stGameDetails[teamID][gid].Vscore#
							</td>
						</TR>
						<CFSET ctLOOP = ctLOOP + 1>
					</CFLOOP> --->
			</CFLOOP>
		</tbody>
		</table>
	</div>
</div>

</CFIF>


</cfoutput>
</DIV>	
	

<script language="JavaScript" type="text/javascript" src="assets/jquery-1.4.min.js"></script>


<cfinclude template="_footer.cfm">

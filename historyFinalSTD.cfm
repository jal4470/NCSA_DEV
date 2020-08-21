<!--- 
	FileName:	homesite+\html\Default Template.htm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
	12/03/08 - aa - added spring and fall 08 history tables to cfswitch (cases: S08 & S07)
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<cfoutput>
<div id="contentText">


<CFIF isDefined("URL.SY") and len(trim(URL.SY))>
	<CFSET sy = URL.SY>
<CFELSEIF isDefined("FORM.SY") and len(trim(FORM.SY))>
	<CFSET sy = FORM.SY>
<CFELSE>
	<CFSET sy = "">
</CFIF>
	
<CFIF len(trim(VARIABLES.SY))>
	<CFSET swOldWay=1> 
	<cfswitch expression="#UCASE(VARIABLES.SY)#">
		<!--- 
		<CFCASE value="S02"> <CFSET season="Spring"> <CFSET year=2002> </CFCASE>
		<CFCASE value="F02"> <CFSET season="Fall">   <CFSET year=2002> <CFSET gametable="Games_Fall_2002"> <CFSET coachtable="CoachesTeams_Fall_2002"> </CFCASE> 
		--->
		<CFCASE value="S03"> 
			<CFSET season="Spring">
			<CFSET year=2003> 
			<CFSET gametable="Games_Spring_2003"> 
			<CFSET coachtable="CoachesTeams_Spring_2003"> 
		</CFCASE>
		<CFCASE value="F03"> 
			<CFSET season="Fall">  
			<CFSET year=2003> 
			<CFSET gametable="Games_Fall_2003">   
			<CFSET coachtable="CoachesTeams_Fall_2003">   
		</CFCASE>
		<CFCASE value="S04"> 
			<CFSET season="Spring">
			<CFSET year=2004> 
			<CFSET gametable="Games_Spring_2004"> 
			<CFSET coachtable="CoachesTeams_Spring_2004"> 
		</CFCASE>
		<CFCASE value="F04"> 
			<CFSET season="Fall">  
			<CFSET year=2004> 
			<CFSET gtmeaable="Games_Fall_2004">   
			<CFSET coachtable="CoachesTeams_Fall_2004">   
		</CFCASE>
		<CFCASE value="S05"> 
			<CFSET season="Spring">
			<CFSET year=2005> 
			<CFSET gametable="Games_Spring_2005"> 
			<CFSET coachtable="CoachesTeams_Spring_2005"> 
		</CFCASE>
		<CFCASE value="F05"> 
			<CFSET season="Fall">  
			<CFSET year=2005> 
			<CFSET gametable="Games_Fall_2005">   
			<CFSET coachtable="CoachesTeams_Fall_2005">   
		</CFCASE>
		<CFCASE value="S06"> 
			<CFSET season="Spring">
			<CFSET year=2006> 
			<CFSET gametable="Games_Spring_2006"> 
			<CFSET coachtable="CoachesTeams_Spring_2006"> 
		</CFCASE>
		<CFCASE value="F06"> 
			<CFSET season="Fall">  
			<CFSET year=2006> 
			<CFSET gametable="Games_Fall_2006">   
			<CFSET coachtable="CoachesTeams_Fall_2006">   
		</CFCASE>
		<CFCASE value="S07"> 
			<CFSET season="Spring">
			<CFSET year=2007> 
			<CFSET gametable="Games_Spring_2007"> 
			<CFSET coachtable="CoachesTeams_Spring_2007"> 
		</CFCASE>
		<CFCASE value="F07"> 
			<CFSET season="Fall">  
			<CFSET year=2007> 
			<CFSET gametable="Games_Fall_2007">   
			<CFSET coachtable="CoachesTeams_Fall_2007">   
		</CFCASE>
		<CFCASE value="S08"> 
			<CFSET season="Spring">
			<CFSET year=2008> 
			<CFSET gametable="Games_Spring_2008"> 
			<CFSET coachtable="CoachesTeams_Spring_2008"> 
		</CFCASE>
		<CFCASE value="F08"> 
			<CFSET season="Fall">  
			<CFSET year=2008> 
			<CFSET gametable="Games_Fall_2008">   
			<CFSET coachtable="CoachesTeams_Fall_2008">   
		</CFCASE>
		<!--- 
		<CFCASE value="S08"> <CFSET season="Spring"> <CFSET year=2008> <CFSET gametable="Games_Spring_2008"> <CFSET coachtable="CoachesTeams_Spring_2008"> </CFCASE>
		<CFCASE value="F08"> <CFSET season="Fall">   <CFSET year=2008> <CFSET gametable=""> 		</CFCASE> 
		--->
		<CFDEFAULTCASE> 
			<!--- use new standings --->
			<CFIF mid(UCASE(VARIABLES.SY),1,1) EQ "F">
				<CFSET season="Fall"> 
			<CFELSE>
				<CFSET season="Spring"> 
			</CFIF>
			<CFSET year = 20 & mid(VARIABLES.SY,4,2)> <!--- 2,2 ---> 
			<CFSET gametable="V_GAMES_History">  
			<CFSET swOldWay=0> 

			<!--- this way uses the new tables/views --->
			<!--- get the id for the selected SEASON --->
			<CFINVOKE component="#SESSION.siteVars.cfcPath#season" method="getSeasonInfo" returnvariable="qSeason">
				<CFINVOKEARGUMENT name="seasonYY" value="#year#"> 
				<CFINVOKEARGUMENT name="seasonSF" value="#UCASE(season)#">
			</CFINVOKE>
		



		</CFDEFAULTCASE>
	</cfswitch>
</CFIF>


<H1 class="pageheading">NCSA - Standings</H1>
<br>
<h2>Game Standings for: #VARIABLES.Season# #VARIABLES.year# </h2>

 

<CFSET SelDiv  = "">

<cfif isDefined("FORM.Division") AND len(trim(FORM.Division))>
	<CFSET selDiv = FORM.Division>
</cfif>


<CFIF isDefined("VARIABLES.gametable") AND len(trim(VARIABLES.gametable))>

	<CFIF swOldWay>
		<CFQUERY name="qDivisions" datasource="#SESSION.DSN#">
			Select distinct Division 
			  from #VARIABLES.gametable#
			ORDER BY DIVISION
		</CFQUERY> 
	<CFELSE>
		<CFQUERY name="qDivisions" datasource="#SESSION.DSN#">
			SELECT distinct Division 
			  FROM V_GAMES_HISTORY
			 WHERE SEASON_ID = #qSeason.SEASON_ID# 
			  ORDER BY DIVISION
		</CFQUERY> 
	</CFIF><!--- <cfdump var="#qDivisions#"> --->
	
	<!-- drop downs  -->
	<form action="historyFinalSTD.cfm" method="post">
	<INPUT type="Hidden" name="SY" value="#VARIABLES.SY#">
	<TABLE cellSpacing=0 cellPadding=5 width="100%" align=center border="0">
		<TR><TD><FONT color=blue><STRONG>Division</STRONG></FONT> &nbsp; 
				<SELECT name="Division" style="WIDTH: 144px"> 
					<OPTION value="0" selected>Select Division</OPTION>
					<CFLOOP query="qDivisions">
						<OPTION value="#Division#" <cfif Division EQ VARIABLES.selDiv>selected</cfif> >#Division#</OPTION>
					</CFLOOP>
				</SELECT>
				&nbsp; 
				<input type="Submit" name="enter" value="Enter">
	    	</TD>
			<TD align="center">
				<a href="history.cfm" >Back to History List</a>
	    	</TD>
		</TR>
	</TABLE>
	</form>

</CFIF>
 

<CFIF VARIABLES.selDiv GT 0>
	<!--- Find Teams under the selected division
		Gender		= Left(DivId, 1)
		TeamAge		= "U" & Mid(DivId, 2, 2)
		PlayLevel	= Right(DivId, 1) --->

	<CFIF swOldWay>
		<CFQUERY name="qCount" datasource="#SESSION.DSN#">
			Select Count(*) as totalTeams
			  from #VARIABLES.coachtable#
			 Where ID in 
					(Select Home from #VARIABLES.gametable# where Division = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.selDiv#"> ) 
			    or ID in
					(Select Visitor from #VARIABLES.gametable# where Division = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.selDiv#"> ) 
		</CFQUERY>
		<CFSET ctTotalTeams = qCount.totalTeams>
	<CFELSE>
		<CFQUERY name="qDivTeams" datasource="#SESSION.DSN#">
			Select TEAM_ID as ID, TEAMNAME, StandingFactor 
			  from TBL_TEAM	T
			 Where Club_ID > 1 
			   and exists(  Select 1 
			     			  from V_GAMES_HISTORY 
						     where Division = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.selDiv#">
							   and (type is null or type in ('',' ','P','Q','S','I','R')) 
					   		   and Home = T.TEAM_ID 
							   and season_id = #qSeason.SEASON_ID#  ) 
			union 
			Select TEAM_ID, TEAMNAME, StandingFactor 
			  from TBL_TEAM	T
			 Where Club_ID > 1
			   and exists(  Select 1 
				    		  from V_GAMES_HISTORY 
							 where Division = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.selDiv#">
							   and (type is null or type in ('',' ','P','Q','S','I','R' )) 
							   and Visitor = T.TEAM_ID 
							   and season_id = #qSeason.SEASON_ID#  )	
		</CFQUERY>
		<CFSET ctTotalTeams = qDivTeams.recordCount>
	</CFIF>

	<CFSET arrStandings = ArrayNew(2)>

	<!--- Get teams for the division and set up in the standings array --->
	<CFIF swOldWay>
		<CFQUERY name="qDivTeams" datasource="#SESSION.DSN#">
			Select Id, TeamName 
			  from #VARIABLES.coachtable#
			 Where ID in (Select Home 
			 				from #VARIABLES.gametable# 
						   where Division = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.selDiv#"> )
			    or ID in (Select Visitor 
							from #VARIABLES.gametable# 
						   where Division = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.selDiv#"> )
		</CFQUERY>
	<!--- ELSE NOT OLDWAY, uses results from query above that got the counts --->
	</CFIF>

	<CFLOOP query="qDivTeams">
		<CFSET arrStandings[currentRow][1] = ID>
		<CFSET arrStandings[currentRow][2] = TEAMNAME>
		<CFSET arrStandings[currentRow][3] = 0>  <!--- Game Played --->
		<CFSET arrStandings[currentRow][4] = 0>  <!--- Wins		--->
		<CFSET arrStandings[currentRow][5] = 0>  <!--- Loss		--->
		<CFSET arrStandings[currentRow][6] = 0>  <!--- Drawn		--->
		<CFSET arrStandings[currentRow][7] = 0>  <!--- Points 		--->
		<CFSET arrStandings[currentrow][8] = 0>  <!--- GF - Goals For		--->
		<CFSET arrStandings[currentRow][9] = 0>  <!--- GA - Goals Against	--->

 	</CFLOOP>

	<!--- Get the scores for the teams --->
	<CFIF swOldWay>
		<CFIF mid(VARIABLES.selDiv,2,2) EQ "08">
			<!--- 08 DIV Supress Scores--->
			<CFQUERY name="qScores" datasource="#SESSION.DSN#">
				Select 0 as HScore, 0 as VScore, Home, Visitor
				  from #VARIABLES.gametable# 
				 where Division = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.selDiv#"> 
				   and HScore is not Null 
				   and VScore is not Null
				   and (type is Null or type in ('',' ') ) 
			</CFQUERY> 
		<cfelse>
			<!--- NOT 08 DIV --->
			<CFQUERY name="qScores" datasource="#SESSION.DSN#">
				Select HScore, VScore, Home, Visitor
				  from #VARIABLES.gametable# 
				 where Division = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.selDiv#"> 
				   and HScore is not Null 
				   and VScore is not Null
				   and (type is Null or type in ('',' ') ) 
			</CFQUERY> 
		</CFIF>
		
	<CFELSE>
		<CFIF mid(VARIABLES.selDiv,2,2) EQ "08">
			<!--- 08 DIV Supress Scores--->
			<CFQUERY name="qScores" datasource="#SESSION.DSN#">
				Select Home,  0 as HScore, Visitor,  0 as Vscore
				  from V_GAMES_HISTORY
				 Where Division = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.selDiv#"> 
				   and HSCORE is not Null 
				   and VSCORE is not Null
				   and (type is null or type in ('',' ','P','Q','S','I','R' ) )
				   and season_id = #qSeason.SEASON_ID#  
				 order by Home
			</CFQUERY> 
		<cfelse>
			<!--- NOT 08 DIV --->
			<CFQUERY name="qScores" datasource="#SESSION.DSN#">
				Select Home,  HScore, Visitor,  Vscore
				  from V_GAMES_HISTORY
				 Where Division = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.selDiv#"> 
				   and HSCORE is not Null 
				   and VSCORE is not Null
				   and (type is null or type in ('',' ','P','Q','S','I','R' ) )
				   and season_id = #qSeason.SEASON_ID#  
				 order by Home
			</CFQUERY> 
		</CFIF>
	</CFIF>
	
	<CFLOOP query="qScores">
		<CFSET HScore = qScores.HScore>
		<CFSET VScore = qScores.VScore>

		<CFSET HomeIdx	  = 0>
		<CFSET VisitorIdx = 0>

	    <CFLOOP from="1" to="#arrayLen(arrStandings)#" index="Idx">
			<CFIF arrStandings[Idx][1] EQ Home>
				<CFSET HomeIndex = Idx>
			</CFIF>
			<CFIF arrStandings[Idx][1] EQ Visitor>
				<CFSET VisitorIndex = Idx>
			</CFIF>
		</CFLOOP>


		<CFSCRIPT>
			// Calculate Statistics
			If ( HScore > VScore )		// ---  HOME Side Won  ---
			{	HWin	= 1;
				HLoss	= 0;
				HDrawn	= 0;
				HPoints	= 3;
				VWin	= 0;
				VLoss	= 1;
				VDrawn	= 0;
				VPoints	= 0;
			}
			If ( HScore < VScore )		// ---  VISITING Side Won  ---
			{	HWin	= 0;
				HLoss	= 1;
				HDrawn	= 0;
				HPoints	= 0;
				VWin	= 1;
				VLoss	= 0;
				VDrawn	= 0;
				VPoints	= 3;
			}
			If ( HScore == VScore )		// ---   Game Drawn   ---
			{	HWin	= 0;
				HLoss	= 0;
				HDrawn	= 1;
				HPoints	= 1;
				VWin	= 0;
				VLoss	= 0;
				VDrawn	= 1;
				VPoints	= 1;
			}
			// Store Stats in the table
			// ---   HOME TEAM  ---
			arrStandings[HomeIndex][3] = arrStandings[HomeIndex][3] + 1;		// Game Played, simple Accumulation
			arrStandings[HomeIndex][4] = arrStandings[HomeIndex][4] + HWin;		// Wins
			arrStandings[HomeIndex][5] = arrStandings[HomeIndex][5] + HLoss;	// Loss
			arrStandings[HomeIndex][6] = arrStandings[HomeIndex][6] + HDrawn;	// Drawn
			arrStandings[HomeIndex][7] = arrStandings[HomeIndex][7] + HPoints;	// Points
			arrStandings[HomeIndex][8] = arrStandings[HomeIndex][8] + HScore;	// GF - Goals For
			arrStandings[HomeIndex][9] = arrStandings[HomeIndex][9] + VScore;	// GA - Goals Against
			// ---   VISITING TEAM  ---
			arrStandings[VisitorIndex][3] = arrStandings[VisitorIndex][3] + 1;		// Game Played, simple Accumulation
			arrStandings[VisitorIndex][4] = arrStandings[VisitorIndex][4] + VWin;	// Wins
			arrStandings[VisitorIndex][5] = arrStandings[VisitorIndex][5] + VLoss;	// Loss
			arrStandings[VisitorIndex][6] = arrStandings[VisitorIndex][6] + VDrawn;	// Drawn
			arrStandings[VisitorIndex][7] = arrStandings[VisitorIndex][7] + VPoints;// Points
			arrStandings[VisitorIndex][8] = arrStandings[VisitorIndex][8] + VScore;	// GF - Goals For
			arrStandings[VisitorIndex][9] = arrStandings[VisitorIndex][9] + HScore;	// GA - Goals Against
		</CFSCRIPT>
	</CFLOOP>

	<!--- ------------------------------------------------------------
		//Initialize the sort array.
		//   Array will have the Points, and the Standing Array Index
	--->
	<CFLOOP from="1" to="#ctTotalTeams#" index="IDX">
			<CFSET SortedStandings[Idx][1] = arrStandings[IDX][7]> <!--- Points --->
			<CFSET SortedStandings[IDX][2] = IDX>  <!---  Index of the Standings Array --->
	</CFLOOP>
		
	<!--- -------------------------------------------------------------------------
		 Sorting standing in the descending order 
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

	<br>
	<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
		<tr bgcolor="###SESSION.sitevars.tblHeading#">
			<TD> <FONT color=white> <b>Team 	</b></FONT> </TD>
			<TD> <FONT color=white> <b>Played 	</b></FONT> </TD>
			<TD> <FONT color=white> <b>Win 		</b></FONT> </TD>
			<TD> <FONT color=white> <b>Loss 	</b></FONT> </TD>
			<TD> <FONT color=white> <b>Drawn 	</b></FONT> </TD>
			<TD> <FONT color=white> <b>Points 	</b></FONT> </TD>
			<TD> <FONT color=white> <b>GF 		</b></FONT> </TD>
			<TD> <FONT color=white> <b>GA 		</b></FONT> </TD>
		</tr>
		<cfloop from="1" to="#arrayLen(arrStandings)#" index="iTeam">
			<CFSET srtIdx = SortedStandings[iTeam][2]>
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,iTeam)#">
				<TD class="tdUnderLine" nowrap>#arrStandings[srtIdx][2]#</TD>
				<TD class="tdUnderLine" nowrap>#arrStandings[srtIdx][3]#</TD>
				<TD class="tdUnderLine" nowrap>#arrStandings[srtIdx][4]#</TD>
				<TD class="tdUnderLine" nowrap>#arrStandings[srtIdx][5]#</TD>
				<TD class="tdUnderLine" nowrap>#arrStandings[srtIdx][6]#</TD>
				<TD class="tdUnderLine" nowrap>#arrStandings[srtIdx][7]#</TD>
				<TD class="tdUnderLine" nowrap>#arrStandings[srtIdx][8]#</TD>
				<TD class="tdUnderLine" nowrap>#arrStandings[srtIdx][9]#</TD>
	 		</tr>
		</CFLOOP>
	</table>
</CFIF>  
	
	
</cfoutput>
</div>
<cfinclude template="_footer.cfm">

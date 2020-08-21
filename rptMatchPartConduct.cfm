<!--- 
	FileName:	rptMatchPartConduct.cfm
	Created on: 05/11/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

05/11/09 - aa - new report Ticket# 7633
05/26/09 - aa - T:7785 - changes based on feedback
06/16/17 - mgreenberg - report mods: updated datepicker.
--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Participant Conduct Report </H1>
<!--- <br> <h2>yyyyyy </h2> --->

<!--- -- #34 - 10 - 7633 - PARTICIPANT CONDUCT REPORT
Logic: for all games within defined range for which a match report is filed, checks to see if Referee selected one of the 
	3 options for Conduct of Officials, Players and Spectators other than Excellent (any report other than “Excellent” 
	default option) and produces a report detailing data below for those match reports showing a condition of Good, 
	Fair or Poor for these 3 questions
Filters: Date Range, all flights or select one, option to select single game number, 3 categories of participants (option 
	to select one), participant conduct (good, fair, poor)(option to select one)
Output: Game # (link to view) report, flight, date, time, referee name, Type of Participant, Participant Conduct, Home and 
	Visitor Teams
Sorts: Referee/Date/Time, Date/Time, Game #, Flight, Type of Participant, Participant Conduct
	Defaults are First Date of season to current date (option to select specific start and end date), All Divisions 
	(option to select one), All Participants (option to select one), All types of Participant Conduct (option to select 
	one) and default sort is Date/Time

 --->

<cfif isDefined("FORM.WeekendFrom")>
	<cfset WeekendFrom = dateFormat(FORM.WeekendFrom,"mm/dd/yyyy") > 
<cfelse>
	<cfset WeekendFrom = dateFormat(session.currentseason.startdate,"mm/dd/yyyy") > 
</CFIF>

<cfif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo   = dateFormat(FORM.WeekendTo,"mm/dd/yyyy") >
<cfelse>
	<cfset WeekendTo   = dateFormat(session.currentseason.enddate,"mm/dd/yyyy") >
</CFIF>

<cfif isDefined("FORM.gameID") AND isNumeric(FORM.gameID)>
	<cfset gameID = FORM.gameID>
<cfelse>
	<cfset gameID = "">
</cfif>

<cfif isDefined("FORM.gameDiv")>
	<cfset gameDiv = FORM.gameDiv>
<cfelse>
	<cfset gameDiv = "">
</cfif>

<cfif isDefined("FORM.participant")>
	<cfset participant = FORM.participant>
<cfelse>
	<cfset participant = "">
</cfif>

<cfif isDefined("FORM.conduct")>
	<cfset conduct = FORM.conduct>
<cfelse>
	<cfset conduct = "">
</cfif>

<cfif isDefined("FORM.sortBy")>
	<cfset sortBy = FORM.sortBy>
<cfelse>
	<cfset sortBy = "date">
</cfif>

<cfset errMsg = "">

<cfif isDefined("FORM.GO")>
	<!--- filter crtieria endtered, zero out single game value --->
	<cfset gameID = "">
<cfelseif isDefined("FORM.GOSINGLE")>
	<!--- single game search, zero out filter values --->
	<cfset RefID = 0>
	<cfset GameFieldID = 0>
	<cfset gameDiv = "">
	<cfset sortBy = "ref">
</cfif> 

<cfif isDefined("FORM.GO") OR isDefined("FORM.GOSINGLE") >
	<cfset swContinue = true>
	<CFIF isDefined("FORM.GOSINGLE") and not isNumeric(VARIABLES.gameID)>
		<cfset swContinue = false>
		<cfset errMsg = "Game number must be a valid number.">
	</CFIF>

	<cfif swContinue>
		<cfquery name="qGamesPlayed" datasource="#SESSION.DSN#">
			SELECT G.GAME_ID, G.Division, G.game_date, G.game_time, G.game_type, G.refReportSbm_yn,
				   (SELECT LastName + ', ' + FirstName FROM TBL_CONTACT WHERE contact_id = G.RefID) AS REF_name,
				   G.HOME_TEAMNAME, G.VISITOR_TEAMNAME,  G.virtual_teamName,
				   R.conductOfficials, R.conductPlayers, R.conductSpectators
			  FROM tbl_referee_RPT_header R    INNER JOIN V_GAMES_all G	 ON G.GAME_ID = R.GAME_ID
			<cfif isDefined("FORM.GOSINGLE")>
				WHERE G.GAME_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.gameID#">
			<cfelse>
				WHERE  
			 		<cfswitch expression="#participant#">
						<cfcase value="officials">	
							R.ConductOfficials  <cfif len(trim(conduct))> = '#variables.conduct#' <cfelse> <> 'E' </cfif>
						</cfcase>
						<cfcase value="players">	
							R.ConductPlayers    <cfif len(trim(conduct))> = '#variables.conduct#' <cfelse> <> 'E' </cfif>
						</cfcase>
						<cfcase value="spectators">	
							R.ConductSpectators <cfif len(trim(conduct))> = '#variables.conduct#' <cfelse> <> 'E' </cfif>
						</cfcase>
						<cfdefaultcase>
							(  ConductOfficials  <cfif len(trim(conduct))> = '#variables.conduct#' <cfelse>	<> 'E' </cfif>
							OR ConductPlayers    <cfif len(trim(conduct))> = '#variables.conduct#' <cfelse>	<> 'E' </cfif>
							OR ConductSpectators <cfif len(trim(conduct))> = '#variables.conduct#' <cfelse> <> 'E' </cfif>
							)
						</cfdefaultcase>
					</cfswitch>
					AND (	  G.game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendFrom#">
						  AND G.game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendTo#">
						)
					AND ( G.game_type is null or G.game_type = '' or G.game_type = 'L') 	
					<cfif len(trim(gameDiv))>
						AND G.Division = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.gameDiv#">
					</cfif>
				</cfif>
				ORDER BY
					<cfswitch expression="#VARIABLES.sortBy#">
						<cfcase value="game"> G.game_id </cfcase>
						<cfcase value="div">  G.Division, G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24')  </cfcase>
						<cfcase value="ref">  REF_name,   G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24')  </cfcase>
						<cfcase value="cond"> 
					 		<cfswitch expression="#participant#">
								<cfcase value="officials">	R.ConductOfficials,  </cfcase>
								<cfcase value="players">	R.ConductPlayers, 	 </cfcase>
								<cfcase value="spectators">	R.ConductSpectators, </cfcase>
								<cfdefaultcase> R.ConductOfficials, R.ConductPlayers, R.ConductSpectators, </cfdefaultcase>
							</cfswitch>
							G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24')  
						</cfcase>
						<cfdefaultcase>  <!--- date --->  G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24')  </cfdefaultcase>
					</cfswitch> 
		</cfquery>
	</cfif>
</cfif>


<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrRatings1">
	<cfinvokeargument name="listType" value="RATINGS1"> 
</cfinvoke> 

<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<FORM name="Games" action="rptMatchPartConduct.cfm"  method="post">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%" >
	<TR><TD align="left">
			<B>From</B> &nbsp;
				<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
			#repeatString("&nbsp;",3)#
			<B>To</B> &nbsp;
				<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">

			#repeatString("&nbsp;",3)#
			<b>Division</b>
				<cfquery name="qAllDivs" datasource="#SESSION.DSN#">
					select distinct division from v_games WHERE division <> '' order by division
				</cfquery>
				<SELECT name="gameDiv"> 
					<OPTION value="" >Select All</OPTION>
					<CFLOOP query="qAllDivs">
						<OPTION value="#division#" <cfif gameDiv EQ division >selected</cfif> >#division#</OPTION>
					</CFLOOP>
				</SELECT>
	
			
			</td>
		<td align="center">
			<B>Game Number </B> &nbsp;
				<input type="Text" name="gameID" value="#VARIABLES.gameID#" size="5">
				<br>(overrides all filters)
	 	</td>
	</tr>
	<tr><td>
			<b>Participant</b>
				<SELECT name="participant"> 
					<OPTION value="" >Select All</OPTION>
					<OPTION value="officials"  <cfif participant EQ "officials" >selected</cfif> > Officials  </OPTION>
					<OPTION value="players"    <cfif participant EQ "players" >selected</cfif> >   Players  </OPTION>
					<OPTION value="spectators" <cfif participant EQ "spectators" >selected</cfif> >Spectators  </OPTION>
				</SELECT>

			#repeatString("&nbsp;",3)#
			<b>Conduct</b>
				<SELECT name="conduct"> 
					<OPTION value="" >Select All</OPTION>
					<cfloop from="1" to="#arrayLen(arrRatings1)#" index="idx">
						<CFIF arrRatings1[idx][1] NEQ "E">
							<OPTION value="#arrRatings1[idx][1]#" <cfif conduct EQ arrRatings1[idx][1]>selected</cfif> >#arrRatings1[idx][2]#</OPTION>
						</CFIF>
					</cfloop>
				</SELECT>

			#repeatString("&nbsp;",3)#
			<b>Sort</b>
				<SELECT name="sortBy"> 
					<OPTION value="ref"   <cfif sortBy EQ "ref"  >selected</cfif> >Referee </OPTION>
					<OPTION value="date"  <cfif sortBy EQ "date" >selected</cfif> >Date    </OPTION>
					<OPTION value="game"  <cfif sortBy EQ "game" >selected</cfif> >Game ## </OPTION>
					<OPTION value="div"   <cfif sortBy EQ "div"  >selected</cfif> >Division</OPTION>
					<OPTION value="cond"  <cfif sortBy EQ "cond" >selected</cfif> >Conduct </OPTION>
				</SELECT>

			#repeatString("&nbsp;",3)#
			<input type="SUBMIT" name="Go"  value="Go" >  
		</td>
		<td align="center">
			<input type="SUBMIT" name="GoSingle"  value="Get Single Game" >  
		</td>
	</tr>

	<cfif len(trim(errMsg))>
		<tr><td colspan="2" align="center">
				<span class="red"><b>#VARIABLES.errMsg#</b></span>
			</td>
		</tr>
	</cfif>

</table>	
</FORM>

<cfset RecCountGrand	= 0>

<CFIF IsDefined("qGamesPlayed")>
	<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrgameStatus">
		<cfinvokeargument name="listType" value="GAMESTATUS"> 
	</cfinvoke> <!--- <cfdump var="#arrgameStatus#"> --->

	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TD width="08%">Game</TD>
			<TD width="08%">Div</TD>
			<TD width="10%">Date <br> Time</TD>
			<td width="20%">Referee</td>
			<td width="27%">Teams </td>
			<TD width="27%">Participant: Conduct</TD>
		</TR>
	</table>	
	
	<!--- <div style="overflow:auto; height:500px; border:1px ##cccccc solid;">  --->
	<div class="overflowbox" style="height:500px;">
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
	<cfset ctLoop = 0>
	<cfloop query="qGamesPlayed">
		<cfset ctLoop = ctLoop + 1>
		<cfset classValue = "class='tdUnderLine'">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctLoop)#">
			<TD width="08%" valign="top" #classValue# >
				<CFIF refReportSbm_yn EQ 'Y'>
					<a href="gameRefReportPrint.cfm?gid=#GAME_ID#" target="_blank"> <span class="red">#game_id#</span> </a>
				<CFELSE>
					#game_id#
				</CFIF>
				<br>
				<cfswitch expression="#game_type#">
					<cfcase value="C"><br><span class="red">SC</span></cfcase>
					<cfcase value="N"><br><span class="red">NL</span></cfcase>
					<cfcase value="F"><br><span class="red">Fr</span></cfcase>
				</cfswitch>
			</TD>
			<TD width="08%" valign="top" #classValue# >	#Division#	</TD>
			<TD width="10%" valign="top" #classValue# >	#dateFormat(game_date,"mm/dd/yy")# <br> #timeFormat(game_time,"hh:mm tt")#	</TD>
			<TD width="20%" valign="top" #classValue# >	#REF_name# 	</TD>
			<TD width="27%" valign="top" align="left" #classValue# >
					(H) #HOME_TEAMNAME#
				<br>(V) <cfif len(trim(VISITOR_TEAMNAME))>
							#VISITOR_TEAMNAME#
						<cfelseif len(trim(virtual_teamName))>
							#virtual_teamName#
						</cfif>
			</TD>

			<TD width="10%" valign="top" align="right" #classValue# >
			 	<cfswitch expression="#participant#">
					<cfcase value="officials">	Officials:	</cfcase>
					<cfcase value="players">	Players:	</cfcase>
					<cfcase value="spectators">	Spectators:	</cfcase>
					<cfdefaultcase>	<!--- all --->
							Officials:
						<br>Players:
						<br>Spectators:
					</cfdefaultcase>
				</cfswitch>
			</TD>

			<TD width="17%" valign="top" align="left" #classValue# >
			 	<cfswitch expression="#participant#">
					<cfcase value="officials">	
						<cfloop from="1" to="#arrayLen(arrRatings1)#" index="idx">
							<CFIF arrRatings1[idx][1] EQ conductOfficials >#arrRatings1[idx][2]#</CFIF>
						</cfloop>
					</cfcase>
					<cfcase value="players">	
						<cfloop from="1" to="#arrayLen(arrRatings1)#" index="idx">
							<CFIF arrRatings1[idx][1] EQ conductPlayers >#arrRatings1[idx][2]#</CFIF>
						</cfloop>
					</cfcase>
					<cfcase value="spectators">	
						<cfloop from="1" to="#arrayLen(arrRatings1)#" index="idx">
							<CFIF arrRatings1[idx][1] EQ conductSpectators >#arrRatings1[idx][2]#</CFIF>
						</cfloop>
					</cfcase>
					<cfdefaultcase>	<!--- all --->
						<!--- officials --->
							<cfloop from="1" to="#arrayLen(arrRatings1)#" index="idx">
								<CFIF arrRatings1[idx][1] EQ conductOfficials >#arrRatings1[idx][2]#</CFIF>
							</cfloop>
						<br><!--- players --->
							<cfloop from="1" to="#arrayLen(arrRatings1)#" index="idx">
								<CFIF arrRatings1[idx][1] EQ conductPlayers >#arrRatings1[idx][2]#</CFIF>
							</cfloop>
						<br><!--- spectators --->
							<cfloop from="1" to="#arrayLen(arrRatings1)#" index="idx">
								<CFIF arrRatings1[idx][1] EQ conductSpectators >#arrRatings1[idx][2]#</CFIF>
							</cfloop>
					</cfdefaultcase>
				</cfswitch>
			</TD>
		</TR>
		<cfset RecCountGrand = RecCountGrand + 1 >
	</cfloop>
	</table>
	</DIV>
	<TABLE cellSpacing=0 cellPadding=5 width="100%" border=0>
		<tr bgcolor="##CCE4F1">
			<td colspan="6" align="center">
				<b> Total between #WeekendFrom# and #WeekendTo# = #RecCountGrand# </b>
			</td>
		</tr>
	</table>
</CFIF>

</cfoutput>
</div>


<cfsavecontent variable="cf_footer_scripts">
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=WeekendFrom],input[name=WeekendTo]').datepicker();
		
		
	});
</script>
</cfsavecontent>

<cfinclude template="_footer.cfm">






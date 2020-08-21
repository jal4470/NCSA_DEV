<!--- 
	FileName:	rptMatchTeamLateSts.cfm
	Created on: 05/11/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

05/11/09 - aa - new report Ticket# 7632
05/26/09 - aa - T:7785 - changes based on feedback
06/16/17 - mgreenberg - report mods: updated datepicker.
--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Team Late Status Report </H1>
<!--- <br> <h2>yyyyyy </h2> --->

<!--- -- #33 - 9 - 7632 - TEAM LATE STATUS REPORT
Logic: for all games within defined range for which a match report is filed, checks to see if Referee selected any status 
	other than default for the 4 issues related to teams’ timeliness and produces a report detailing data below for 
	those match reports showing a condition of Home team not ready within designated time (checked), Visitor Team not 
	ready within designated time (checked), Home team on time (selected NO), Visiting Team on time (selected NO)
Filters: Date Range, all flights or select one, option to select single game number, Team Late Status (option to select one)
Output: Game # (link to view) report, flight, date, time, referee name, Team Late Status, Team which was late, how late 
		(or blank if not indicated)
Sorts: Referee/Date/Time, Date/Time, Game #, Flight
Defaults are First Date of season to current date (option to select specific start and end date), All Divisions (option to 
	select one), All Team Late Status indications and default sort is Date/Time


	select game_id, IsOnTime_Home, IsOnTime_Visitor
	  from TBL_REFEREE_RPT_HEADER
	where IsOnTime_Home = 0
		OR 	IsOnTime_Visitor = 0
	  AND filters...
	order by...

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

<cfif isDefined("FORM.whoLate")>
	<cfset whoLate = FORM.whoLate>
<cfelse>
	<cfset whoLate = "">
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
				   R.FieldCond,
				   IsOnTime_Home,    HowLate_Home, 
				   IsOnTime_Visitor, HowLate_Visitor
			  FROM tbl_referee_RPT_header R    INNER JOIN V_GAMES_all G	 ON G.GAME_ID = R.GAME_ID
			<cfif isDefined("FORM.GOSINGLE")>
					WHERE G.GAME_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.gameID#">
			<cfelse>
			 WHERE  <cfif whoLate EQ "G1">	
				 	    (  R.IsOnTime_Home <> 1 	)			
					<cfelseif whoLate EQ "H1">	
				 	    (  R.IsOnTime_Visitor <> 1  )	
					<cfelseif whoLate EQ "G">	
				 	    (  R.fieldcond LIKE '%G%' 	)		
					<cfelseif whoLate EQ "H">
				 	    (  R.fieldcond LIKE '%H%' 	)		
					<cfelse> 
				 	    ( 	(  R.IsOnTime_Home <> 1   OR R.IsOnTime_Visitor <> 1  )
						 OR (  R.fieldcond LIKE '%G%' OR R.fieldcond LIKE '%H%'   )
						)
					</cfif>
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
					<cfdefaultcase>  <!--- date --->  G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24')  </cfdefaultcase>
				</cfswitch> 
		</cfquery>
	</cfif>
</cfif>

<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<FORM name="Games" action="rptMatchTeamLateSts.cfm"  method="post">
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
			<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrRatings1">
				<cfinvokeargument name="listType" value="FIELDCOND"> 
			</cfinvoke> 
			<b>Late</b>
				<SELECT name="whoLate"> 
					<OPTION value="" >Select All</OPTION>
					<OPTION value="G1"  <cfif whoLate EQ "G1" >selected</cfif> >Home team is late	 </OPTION>
					<OPTION value="H1"  <cfif whoLate EQ "H1" >selected</cfif> >Visiting team is late</OPTION>
					<cfloop from="1" to="#arrayLen(arrRatings1)#" index="idx">
						<CFIF arrRatings1[idx][1] EQ "G" OR  arrRatings1[idx][1] EQ "H" >
							<OPTION value="#arrRatings1[idx][1]#" <cfif whoLate EQ arrRatings1[idx][1]>selected</cfif> >#arrRatings1[idx][2]#</OPTION>
						</CFIF> 
					</cfloop>
				</SELECT>

			#repeatString("&nbsp;",3)#
			<b>Sort</b>
				<SELECT name="sortBy"> 
					<OPTION value="ref"   <cfif sortBy EQ "ref"  >selected</cfif> >Referee</OPTION>
					<OPTION value="date"  <cfif sortBy EQ "date" >selected</cfif> >Date   </OPTION>
					<OPTION value="game"  <cfif sortBy EQ "game" >selected</cfif> >Game ##</OPTION>
					<OPTION value="div"   <cfif sortBy EQ "div"  >selected</cfif> >Division</OPTION>
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
	<table cellspacing="0" cellpadding="0" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TD width="08%">Game</TD>
			<TD width="08%">Div</TD>
			<TD width="10%">Date <br> Time</TD>
			<td width="20%">Referee</td>
			<td width="27%">Teams </td>
			<TD width="27%">Who was late</TD>
		</TR>
	</table>	
	<div class="overflowbox" style="height:500px;">
	<table cellspacing="0" cellpadding="2" align="left" border="0" width="100%"  >
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
			<TD width="27%" valign="top" #classValue# align="left">
					(H) #HOME_TEAMNAME#
				<br>(V) <cfif len(trim(VISITOR_TEAMNAME))>
							#VISITOR_TEAMNAME#
						<cfelseif len(trim(virtual_teamName))>
							#virtual_teamName#
						</cfif>
			</TD>
			<TD width="27%" valign="top" #classValue# >
					<CFIF IsOnTime_Home EQ 0> 
						Home team is late
						<cfif len(trim(HowLate_Home)) GT 0> 
							by #HowLate_Home# minutes.
						</CFIF> 
					</cfif>
					<CFIF findNoCase("G",FieldCond) GT 0 > 
						- Home team not ready to play within the designated time.
					</cfif>
				<br>	
					<CFIF IsOnTime_Visitor EQ 0>
						Visiting team is late
						<cfif len(trim(HowLate_Visitor)) GT 0>
					 		by #HowLate_Visitor# minutes.
						</cfif>
					</cfif>	
					<CFIF findNoCase("H",FieldCond) GT 0 > 
						- Visiting team not ready to play within the designated time.
					</cfif>
			</TD>
		</TR>
		<cfset RecCountGrand = RecCountGrand + 1 >
	</cfloop>
	</table>
	</DIV>
	<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
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






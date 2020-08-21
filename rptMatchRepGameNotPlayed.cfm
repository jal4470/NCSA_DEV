<!--- 
	FileName:	rptMatchRepGameNotPlayed.cfm
	Created on: 05/11/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

05/11/09 - aa - new report Ticket# 7629
05/26/09 - aa - T:7785 - changes based on feedback
06/16/17 - mgreenberg - report mods: updated datepicker.
--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<!--- <br> <h2>yyyyyy </h2> --->

<!--- 30 - MATCH REPORTS INDICATING GAME NOT PLAYED
Logic: for all games within defined range for which a match report is filed, checks to see if Referee selected 
	one of the 4 drop down choices of Not Played due to *** (any report other than “Game Played” default 
	option) and produces a report detailing data below for those match reports showing a comment
Filters: Date Range, all flights or select one, option to select single game number, Reason not played (option 
	to select one)
Output: Game # (link to view) report, flight, date, time, referee name, Reason not played, Home and Visitor Team
Sorts: Referee/Date/Time, Date/Time, Game #, Flight, Reason not played
Defaults are First Date of season to current date (option to select specific start and end date), All Divisions 
	(option to select one), All Reasons not played and default sort is Date/Time


 --->


<cfif isDefined("FORM.op")>
	<cfset op = FORM.op > 
<cfelseif isDefined("URL.op")>
	<cfset op = URL.op > 
<cfelse>
	<cfset op = 0 > 
</CFIF>

<cfif isDefined("form.WeekendFrom") and form.WeekendFrom NEQ "">
	<cfset WeekendFrom = dateformat(form.WeekendFrom,"mm/dd/yyyy") > 
<cfelseif isDefined("url.WeekendFrom") and url.WeekendFrom NEQ "">
	<cfset WeekendFrom = url.WeekendFrom>
<cfelse>
	<cfset WeekendFrom = dateformat(session.currentseason.startdate,"mm/dd/yyyy") > 
</CFIF>

<cfif isDefined("form.WeekendTo") and form.WeekendTo NEQ "">
	<cfset WeekendTo   = dateformat(form.WeekendTo,"mm/dd/yyyy") >
<cfelseif isDefined("url.WeekendTo") and url.WeekendTo NEQ "">
	<cfset WeekendTo = url.WeekendTo>
<cfelse>
	<cfset WeekendTo   = dateformat(session.currentseason.enddate,"mm/dd/yyyy") >
</CFIF>

<cfif isDefined("form.gameStatus") and form.gameStatus NEQ "">
	<cfset gameStatus = form.gameStatus>
<cfelseif isDefined("url.gameStatus") and url.gameStatus NEQ "">
	<cfset gameStatus = url.gameStatus>
<cfelse>
	<cfset gameStatus = "">
</cfif>

<cfif isDefined("form.gameDiv") and form.gameDiv NEQ "">
	<cfset gameDiv = form.gameDiv>
<cfelseif isDefined("url.gameDiv") and url.gameDiv NEQ "">
	<cfset gameDiv = url.gameDiv>
<cfelse>
	<cfset gameDiv = "">
</cfif>

<cfif isDefined("form.gameID") and form.gameID NEQ "" AND isNumeric(form.gameID)>
	<cfset gameID = form.gameID>
<cfelseif isDefined("url.gameID") and url.gameID NEQ "" and isNumeric(url.gameID)>
	<cfset gameID = url.gameID>
<cfelse>
	<cfset gameID = "">
</cfif>

<cfif isDefined("form.sortBy") and form.sortBy NEQ "">
	<cfset sortBy = form.sortBy>
<cfelseif isDefined("url.sortBy") and url.sortBy NEQ "">
	<cfset sortBy = url.sortBy>
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
		<cfquery name="qGamesNotPlayed" datasource="#SESSION.DSN#">
			SELECT G.GAME_ID, G.Division, G.game_date, G.game_time, G.game_type,
				   G.HOME_TEAMNAME, G.VISITOR_TEAMNAME,  G.virtual_teamName,
				   G.RefID, G.refReportSbm_yn,
				   (SELECT LastName + ', ' + FirstName FROM TBL_CONTACT WHERE contact_id = G.RefID) AS REF_name,
				   R.GameSts
			  FROM tbl_referee_RPT_header R 
						INNER JOIN V_GAMES_all G	 ON G.GAME_ID = R.GAME_ID
			 WHERE R.GameSts <> 'P'
			 	<cfif isDefined("FORM.GOSINGLE")>
					AND G.GAME_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.gameID#">
				<cfelse>
					AND (	  G.game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendFrom#">
						  AND G.game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendTo#">
						)
					AND ( G.game_type is null or G.game_type = '' or G.game_type = 'L') 	
					<cfif len(trim(gameDiv))>
						AND G.Division = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.gameDiv#">
					</cfif>
					<cfif len(trim(GameStatus))>
						AND R.GameSts = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.GameStatus#">
					</cfif>
				</cfif>
			<cfif Session.MenuRoleID EQ 28 OR Session.MenuRoleID EQ 27 OR Session.MenuRoleID EQ 26 OR Session.MenuRoleID EQ 25>

				and (G.home_club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#"> or G.visitor_club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#">)
			</cfif>
			ORDER BY
				<cfswitch expression="#VARIABLES.sortBy#">
					<cfcase value="game"> G.game_id </cfcase>
					<cfcase value="div">  G.Division, G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24')  </cfcase>
					<cfcase value="ref">  REF_name,   G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24')  </cfcase>
					<cfcase value="rsn">  R.GameSts,  G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24')  </cfcase>
					<cfdefaultcase>  G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24')  </cfdefaultcase>
				</cfswitch> 
		</cfquery>
	</cfif>
</cfif>

<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">
	NCSA - Match Reports Indicating Game Not Played
	<cfif isDefined("qGamesNotPlayed") AND qGamesNotPlayed.RecordCount GT 0>
		<input id="printBtn" type="button" value="Print Report" />
	</cfif>
</H1>

<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<FORM name="Games" action="rptMatchRepGameNotPlayed.cfm"  method="post">
<input type="hidden" id="op" name="op" value="#op#" />
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%" >
	<TR><TD align="left">
			<B>From</B> &nbsp;
				<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
			#repeatString("&nbsp;",3)#
			<B>To</B> &nbsp;
				<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">

			#repeatString("&nbsp;",10)#
			<b>Sort</b>
				<SELECT name="sortBy"> 
					<OPTION value="ref"   <cfif sortBy EQ "ref"  >selected</cfif> >Referee</OPTION>
					<OPTION value="date"  <cfif sortBy EQ "date" >selected</cfif> >Date   </OPTION>
					<OPTION value="game"  <cfif sortBy EQ "game" >selected</cfif> >Game ##</OPTION>
					<OPTION value="div"   <cfif sortBy EQ "div"  >selected</cfif> >Division</OPTION>
					<OPTION value="rsn"   <cfif sortBy EQ "rsn"  >selected</cfif> >Reason</OPTION>
				</SELECT>


		</td>
		<td align="center">
			<B>Game Number </B> &nbsp;
				<input type="Text" name="gameID" value="#VARIABLES.gameID#" size="5">
				<br>(overrides all filters)
	 	</td>
	</tr>
	<tr><td><b>Division</b>
				<cfquery name="qAllDivs" datasource="#SESSION.DSN#">
					select distinct division from v_games WHERE division <> '' order by division
				</cfquery>
				<SELECT name="gameDiv"> 
					<OPTION value="" >Select All</OPTION>
					<CFLOOP query="qAllDivs">
						<OPTION value="#division#" <cfif gameDiv EQ division >selected</cfif> >#division#</OPTION>
					</CFLOOP>
				</SELECT>
	
			#repeatString("&nbsp;",3)#
			<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrGameStatus">
				<cfinvokeargument name="listType" value="GAMESTATUS"> 
			</cfinvoke> 
			<b>Reason</b>
			<SELECT name="GameStatus" > 
				<OPTION value="" >Select All</OPTION>
				<cfloop from="1" to="#arrayLen(arrGameStatus)#" index="ix">
					<CFIF arrGameStatus[ix][1] NEQ "P">
						<OPTION value="#arrGameStatus[ix][1]#" <cfif GameStatus EQ arrGameStatus[ix][1]>selected</cfif> >#arrGameStatus[ix][2]#</OPTION>
					</CFIF>
				</cfloop>
			</SELECT>


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

<CFIF IsDefined("qGamesNotPlayed")>
	<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrgameStatus">
		<cfinvokeargument name="listType" value="GAMESTATUS"> 
	</cfinvoke> <!--- <cfdump var="#arrgameStatus#"> --->

	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TD width="10%">Game</TD>
			<TD width="10%">Div</TD>
			<TD width="10%">Date <br> Time</TD>
			<td width="20%">Referee</td>
			<td width="20%">Not Played <br> Reason</td>
			<TD width="30%">Teams</TD>
		</TR>
	</table>	
	
	<!--- <div style="overflow:auto; height:500px; border:1px ##cccccc solid;">  --->
	<div class="overflowbox" style="height:500px;">
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
	<cfset ctLoop = 0>
	<cfloop query="qGamesNotPlayed">
		<cfset ctLoop = ctLoop + 1>
		<cfset classValue = "class='tdUnderLine'">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctLoop)#">
			<TD width="10%" valign="top" #classValue# >
			<cfif op EQ "1">
			#game_id#
			<cfelse>
				<CFIF refReportSbm_yn EQ 'Y'>
					<a href="gameRefReportPrint.cfm?gid=#GAME_ID#" target="_blank"> <span class="red">#game_id#</span> </a>
				<CFELSE>
					#game_id#
				</CFIF>
			</cfif>
				<br>
				<cfswitch expression="#game_type#">
					<cfcase value="C"><br><span class="red">SC</span></cfcase>
					<cfcase value="N"><br><span class="red">NL</span></cfcase>
					<cfcase value="F"><br><span class="red">Fr</span></cfcase>
				</cfswitch>
			</TD>
			<TD width="10%" valign="top" #classValue# >
				#Division#
			</TD>
			<TD width="10%" valign="top" #classValue# >
					#dateFormat(game_date,"mm/dd/yy")# 
				<br>#timeFormat(game_time,"hh:mm tt")#
			</TD>
			<TD width="20%" valign="top" #classValue# >
				#REF_name# 
			</TD>
			<TD width="20%" valign="top" align="left" #classValue# >
				<!--- #GameSts# -  --->
				<cfloop from="1" to="#arrayLen(arrGameStatus)#" index="ix">
					<cfif GameSts EQ arrGameStatus[ix][1]>
						#arrGameStatus[ix][2]#
						<cfbreak>
					</cfif>
				</cfloop>	
			</TD>
			<TD width="30%" valign="top" #classValue# >
				(H) #Home_TeamName#  
				<br>(V) 
					<cfif len(trim(Visitor_TeamName))>
						#Visitor_TeamName# 
					<cfelse>
						#Virtual_TeamName#
					</cfif>
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
<cfoutput>
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=WeekendFrom],input[name=WeekendTo]').datepicker();

		$("##printBtn").click(function () {
		window.open('rptMatchRepGameNotPlayed_PDF.cfm?WeekendFrom=#WeekendFrom#&WeekendTo=#WeekendTo#&gameDiv=#gameDiv#&gameID=#gameID#&sortBy=#sortBy#');
		});
	});
	</script>
</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">






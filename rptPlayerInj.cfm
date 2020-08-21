<!--- 
	FileName:	rptPlayerInj.cfm
	Created on: 05/06/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

05/01/09 - aa - new report Ticket# 7627
05/26/09 - aa - T:7785 - changes based on feedback
06/16/17 - mgreenberg - report mods: updated datepicker.
--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Player Injury Report</H1>
<!--- <br> <h2>yyyyyy </h2> --->


<!--- 28 PLAYER INJURY REPORT
Logic: for all games within defined range for which a match report is filed, 
		checks to see if a player injury is reported and produces a report detailing data below for those match reports showing an injury
Filters: Date Range, all flights or select one
Output: Game # (link to view) report, flight, date, time, player name, pass #, team name, nature of injury, referee name
Sorts: Referee/Date/Time, Date/Time, Team Name/Date, Game #, Flight 
	????????	   
		SELECT  R.referee_rpt_detail_ID, R.referee_rpt_header_ID, R.game_id, 
				R.serial_no, R.eventType, R.PlayerName, R.PassNo, R.teamid, R.misconduct_ID, 
				R.createDate, R.createdBy, R.updateDate, R.updatedBy
				T.TEAMNAME, H.refID,
		  FROM  tbl_referee_RPT_detail R 
		  			INNER JOIN TBL_TEAM T ON T.team_id = R.teamid
					INNER JOIN TBL_REFEREE_RPT_HEADER H ON H.referee_rpt_header_ID = R.referee_rpt_header_ID
					INNER JOIN TBL_CONTACT C ON H.refID = C.contact_id
		 WHERE  R.eventType = 2 


 --->


<cfif isDefined("FORM.op")>
	<cfset op = FORM.op > 
<cfelseif isDefined("URL.op")>
	<cfset op = URL.op > 
<cfelse>
	<cfset op = 0 > 
</CFIF>

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

<cfif isDefined("FORM.gameDiv")>
	<cfset gameDiv = FORM.gameDiv>
<cfelse>
	<cfset gameDiv = "">
</cfif>


<cfif isDefined("FORM.sortBy")>
	<cfset sortBy = FORM.sortBy>
<cfelse>
	<cfset sortBy = "date">
</cfif>

<cfset errMsg = "">

<cfif isDefined("FORM.GO")>
	<cfquery name="qPlayerInjury" datasource="#SESSION.DSN#">
		SELECT  R.referee_rpt_detail_ID, R.referee_rpt_header_ID, 
				R.game_id, G.game_date, G.GAME_TIME, G.DIVISION, G.GAME_TYPE, 
				R.serial_no, R.eventType, R.PlayerName, R.PassNo, R.teamid, R.misconduct_ID, 
				(SELECT TEAMNAME FROM TBL_TEAM WHERE TEAM_ID = R.teamid) as TEAM_NAME,
				H.contact_id_referee,
				(SELECT LastName + ', ' + FirstName FROM TBL_CONTACT WHERE contact_id = g.Refid) AS REF_name
		  FROM  tbl_referee_RPT_detail R 
					INNER JOIN TBL_REFEREE_RPT_HEADER H ON H.referee_rpt_header_ID = R.referee_rpt_header_ID
		  			INNER JOIN V_GAMES_all G				ON G.game_id = R.game_id
		 WHERE  R.eventType = 2 
			AND (	  G.game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendFrom#">
				  AND G.game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendTo#">
				)
			<cfif len(trim(gameDiv))>
				AND G.Division = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.gameDiv#">
			</cfif>
			<cfif Session.MenuRoleID EQ 28 OR Session.MenuRoleID EQ 27 OR Session.MenuRoleID EQ 26 OR Session.MenuRoleID EQ 25>

				and (G.home_club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#"> or G.visitor_club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#">)
			</cfif>
		 ORDER BY 
				<cfswitch expression="#VARIABLES.sortBy#">
					<cfcase value="team"> TEAM_NAME, G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24'), R.game_id, R.serial_no </cfcase>
					<cfcase value="game"> G.game_id, R.serial_no  </cfcase>
					<cfcase value="div">  G.Division, G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24'), R.game_id, R.serial_no  </cfcase>
					<cfcase value="ref">  REF_name, G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24'), R.game_id, R.serial_no  </cfcase>
					<cfdefaultcase>  G.game_date,  dbo.formatDateTime(G.GAME_TIME,'HH:MM 24'), R.game_id, R.serial_no </cfdefaultcase>
				</cfswitch> 
	</cfquery>
</cfif>


<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrInjury">
	<cfinvokeargument name="listType" value="INJURY"> 
</cfinvoke> 

<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<FORM name="players" action="rptPlayerInj.cfm"  method="post">
<input type="hidden" id="op" name="op" value="#op#" />
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
	
			#repeatString("&nbsp;",3)#
			<b>Sort</b>
				<SELECT name="sortBy"> 
					<OPTION value="ref"   <cfif sortBy EQ "ref"  >selected</cfif> >Referee</OPTION>
					<OPTION value="date"  <cfif sortBy EQ "date" >selected</cfif> >Date   </OPTION>
					<OPTION value="team" <cfif sortBy EQ "team">selected</cfif> >Team  </OPTION>
					<OPTION value="game"  <cfif sortBy EQ "game" >selected</cfif> >Game ##</OPTION>
					<OPTION value="div"   <cfif sortBy EQ "div"  >selected</cfif> >Division</OPTION>
				</SELECT>
			<input type="SUBMIT" name="Go"  value="Go" >  
	
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

<CFIF IsDefined("qPlayerInjury")>
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TD width="07%">Game</TD>
			<TD width="05%">Div</TD>
			<TD width="08%">Date <br> Time</TD>
			<TD width="20%">Player <br> Pass ##</TD>
			<!--- <td width="10%">Pass ##</td> --->
			<td width="19%">Team</td>
			<td width="20%">Injury</td>
			<td width="21%">Referee</td>
		</TR>
	</table>	
	<!--- <div style="overflow:auto; height:500px; border:1px ##cccccc solid;">  --->
	<div class="overflowbox" style="height:500px;">
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
	<cfset ctLoop = 0>
	<cfloop query="qPlayerInjury">
		<cfset ctLoop = ctLoop + 1>
		<cfset classValue = "class='tdUnderLine'">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctLoop)#">
			<TD width="07%" valign="top" #classValue# >
			<cfif op EQ "1">
			#game_id#
			<cfelse>
				<a href="gameRefReportPrint.cfm?gid=#GAME_ID#" target="_blank"> <span class="red">#game_id#</span> </a>
			</cfif>
				<br>
				<cfswitch expression="#game_type#">
					<cfcase value="C"><br><span class="red">SC</span></cfcase>
					<cfcase value="N"><br><span class="red">NL</span></cfcase>
					<cfcase value="F"><br><span class="red">Fr</span></cfcase>
				</cfswitch>
			</TD>
			<TD width="05%" valign="top" #classValue# >
				#Division#			
			</TD>
			<TD width="08%" valign="top" #classValue# >
				#dateFormat(game_date,"mm/dd/yy")# 
				<br>#timeFormat(game_time,"hh:mm tt")# 
			</TD>
			<TD width="20%" valign="top" #classValue# >
				#PlayerName# <br> #repeatstring("&nbsp;",3)# #PassNo#	 		
			</TD>
			<!--- <TD width="10%" valign="top" #classValue# >
				#PassNo#			
			</TD> --->
			<TD width="20%" valign="top" align="left" #classValue# >
				#TEAM_NAME#	&nbsp;		
			</TD>
			<TD width="20%" valign="top" align="left" #classValue# >
				<cfloop from="1" to="#arrayLen(arrInjury)#" index="iJ">
					<cfif arrInjury[iJ][1] EQ MisConduct_ID>
						<font class="data2">#arrInjury[iJ][2]#</font>
					</cfif>
				</cfloop>	&nbsp;	
			</TD>
			<TD width="20%" valign="top" #classValue# >
				#REF_name# 			
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






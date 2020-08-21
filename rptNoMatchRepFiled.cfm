<!--- 
	FileName:	rptNoMatchRepFiled.cfm
	Created on: 05/04/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

05/01/09 - aa - new report Ticket# 7626
06/16/17 - mgreenberg - report mods: updated datepicker. 
--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<!--- <br> <h2>yyyyyy </h2> --->


<!--- 27 NO MATCH REPORT BUT SCORE REPORTED DISCREPANCY REPORT
Logic: for all games within defined range for which a score is entered, 
		checks to see if a match report is filed and 
		produces a report detailing results only if a score exists but no match report is filed
Filters: Date Range, all flights or select one, option to select single game number
Output: Game # (link to view) report, flight, date, time, field, home team, visitor team, referee,  division commissioner reported score

		SELECT G.GAME_ID, G.Division, G.game_date, G.game_time, G.fieldAbbr,
			   G.HOME_TEAMNAME, G.VISITOR_TEAMNAME, G.RefID, C.FirstName, C.LastName,
			   G.SCORE_HOME, G.SCORE_VISITOR
		  FROM V_GAMES G INNER JOIN TBL_CONTACT C ON G.refID = C.contact_id
		 WHERE RefReportSbm <> 'Y'
		   AND (  G.SCORE_HOME IS NOT NULL  AND  G.SCORE_VISITOR  IS NOT NULL )
 --->

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
		<cfquery name="qScoreDiscrep" datasource="#SESSION.DSN#">
			SELECT G.GAME_ID, G.Division, G.game_date, G.game_time, G.fieldAbbr, G.game_Type,
				   G.HOME_TEAMNAME, G.VISITOR_TEAMNAME, 
				   G.RefID, (SELECT LastName + ', ' + FirstName FROM TBL_CONTACT WHERE contact_id = G.RefID) AS REF_name,
				   G.RefReportSbm_yn, G.SCORE_HOME, G.SCORE_VISITOR
			  FROM V_GAMES_all G 
			 WHERE G.RefReportSbm <> 'Y'
			   AND (  G.SCORE_HOME IS NOT NULL  AND  G.SCORE_VISITOR  IS NOT NULL )
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
				</cfif>
			ORDER BY
				<cfswitch expression="#VARIABLES.sortBy#">
					<cfcase value="field"> G.FIELDABBR, G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24')  </cfcase>
					<cfcase value="game">  G.game_id </cfcase>
					<cfcase value="div">   G.Division, G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24')  </cfcase>
					<cfcase value="ref">   REF_name, G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24')  	</cfcase>
					<cfdefaultcase>  G.game_date, G.FIELDABBR, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24') </cfdefaultcase>
				</cfswitch> 
		</cfquery>
	</cfif>
</cfif>

<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>
<div id="contentText">

<H1 class="pageheading">
	NCSA - No Match Report But Score Reported Discrepancy Report
	<cfif isDefined("qScoreDiscrep") AND qScoreDiscrep.RecordCount GT 0>
		<input id="printBtn" type="button" value="Print Report" />
	</cfif>
</H1>

<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<FORM name="Games" action="rptNoMatchRepFiled.cfm"  method="post">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%" >
	<TR><TD align="left">
			<B>From</B> &nbsp;
				<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
			#repeatString("&nbsp;",3)#
			<B>To</B> &nbsp;
				<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
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
			<b>Sort</b>
				<SELECT name="sortBy"> 
					<OPTION value="ref"   <cfif sortBy EQ "ref"  >selected</cfif> >Referee</OPTION>
					<OPTION value="date"  <cfif sortBy EQ "date" >selected</cfif> >Date   </OPTION>
					<OPTION value="field" <cfif sortBy EQ "field">selected</cfif> >Field  </OPTION>
					<OPTION value="game"  <cfif sortBy EQ "game" >selected</cfif> >Game ##</OPTION>
					<OPTION value="div"   <cfif sortBy EQ "div"  >selected</cfif> >Division</OPTION>
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

<CFIF IsDefined("qScoreDiscrep")>
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TD width="07%">Game</TD>
			<TD width="05%">Div</TD>
			<TD width="08%">Date <br> Time</TD>
			<TD width="20%">PlayField</TD>
			<TD width="30%">Teams</TD>
			<td width="15%">Referee</td>
			<!--- <td width="07%">Ref Score</td> --->
			<td width="15%">DC Score</td>
		</TR>
	</table>	
	
	<!--- <div style="overflow:auto; height:500px; border:1px ##cccccc solid;">  --->
	<div class="overflowbox" style="height:500px;">
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
	<cfset ctLoop = 0>
	<cfloop query="qScoreDiscrep">
		<cfset ctLoop = ctLoop + 1>
		<cfset classValue = "class='tdUnderLine'">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctLoop)#">
			<TD width="07%" valign="top" #classValue# >
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
			<TD width="05%" valign="top" #classValue# >
				#Division#
			</TD>
			<TD width="08%" valign="top" #classValue# >
					#dateFormat(game_date,"mm/dd/yy")# 
				<br>#timeFormat(game_time,"hh:mm tt")#
			</TD>
			<TD width="20%" valign="top" #classValue# >
				&nbsp;#fieldAbbr#
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
			<TD width="20%" valign="top" #classValue# >
				#REF_name# 
			</TD>
			<!--- <TD width="07%" valign="top" align="left" #classValue# >
				#FullTimeScore_Home# - #FullTimeScore_Visitor#
			</TD> --->
			<TD width="10%" valign="top" align="left" #classValue# >
				#SCORE_HOME# - #SCORE_VISITOR#
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
			window.open('rptNoMatchRepFiled_PDF.cfm?WeekendFrom=#WeekendFrom#&WeekendTo=#WeekendTo#&gameDiv=#gameDiv#&gameID=#gameID#&sortBy=#sortBy#');
		});
	});
	</script>
</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">






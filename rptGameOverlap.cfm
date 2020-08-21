<!--- 
	FileName:	rptGameOverlap.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
05/28/09 - aarnone - #7311 printer friendly
07/20/17 - apinzone (27024) - Added date filtering


NOTE! - changes to this page may also have to be included into rptGameOverlapPDF.cfm
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
	<style type="text/css">
	</style>
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<cfoutput>
<div id="contentText">

<cfif isDefined("FORM.overlapMinutes")>
	<cfset overlapMinutes = FORM.overlapMinutes>
<cfelse>
	<cfset overlapMinutes = 60>
</cfif>

<cfif isDefined("FORM.sortOrder")>
	<cfset sortBy = FORM.sortOrder>
<cfelse>
	<cfset sortBy = "DATE">
</cfif>

<cfif isDefined("form.WeekendFrom")>
	<cfset WeekendFrom = form.WeekendFrom>
<cfelse>
	<cfset WeekendFrom = "">
</cfif>

<cfif isDefined("form.WeekendTo")>
	<cfset WeekendTo = form.WeekendTo>
<cfelse>
	<cfset WeekendTo = "">
</cfif>


<H1 class="pageheading">NCSA - Overlapping Games</H1>
<h2 style="margin-bottom:10px;">Difference of 
	<cfswitch expression="#overlapMinutes#">
		<cfcase value="60">  1 Hour </cfcase>
		<cfcase value="75">  1 Hour 15 Minutes </cfcase>
		<cfcase value="90">  1 Hour 30 Minutes </cfcase>
		<cfcase value="105"> 1 Hour 45 Minutes </cfcase>
		<cfcase value="120"> 2 Hours </cfcase>
	</cfswitch>
	or less.

</h2>


<cfswitch expression="#UCASE(sortBy)#">
	<cfcase value="DATE">  <cfset orderByClause = "GAME_DATE, FIELDABBR, dbo.formatDateTime(GAME_TIME,'HH:MM 24')"> </cfcase>
	<cfcase value="FIELD"> <cfset orderByClause = "FIELDABBR, GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24')"> </cfcase>
	<cfdefaultcase>		   <cfset orderByClause = "GAME_DATE, FIELDABBR, dbo.formatDateTime(GAME_TIME,'HH:MM 24')"> </cfdefaultcase>
</cfswitch>

	<CFQUERY name="qGetgames" datasource="#SESSION.DSN#">	
		select GAME_ID, GAME_DATE, GAME_TIME, DIVISION, 
			   FIELDNAME, FIELDABBR, 
			   HOME_TEAMNAME,  VISITOR_TEAMNAME, Home_CLUB_ID, Visitor_CLUB_ID 
		  from V_Games
		 Where (FIELDABBR <> '' or FIELDABBR is not Null)
	 	   and field_ID NOT in  (select Field_id from TBL_FIELD where CLUB_ID = 1)
		   and HScore is Null 
		   and VScore is Null
		 Order by  #preserveSingleQuotes(orderByClause)#
	</CFQUERY><!--- GAME_DATE, FIELDABBR, GAME_TIME --->
	
	<cfif listFind(SESSION.CONSTANT.CUROLES, SESSION.MENUROLEID) GT 0>
		<cfquery name="qGetgames" dbtype="query">
			SELECT * FROM qGetgames	
			  WHERE Home_CLUB_ID    = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.USER.CLUBID#">
			     OR Visitor_CLUB_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.USER.CLUBID#">
		</cfquery> 
	</cfif>

	<cfset PrvFieldAbbr	= "">
	<cfset PrvGameDate  = "">
	<cfset PrvGameTime  = "">
	<cfset PrvGame		= 0>
	<cfset PrvGameDiv	= "">
	<cfset PrvHomeTeam	    = "">
	<cfset PrvVisitorTeam	= "">
	<cfset PrvGameTimeInMin = 0>
	<CFSET PRV_gameDateTime = 0>
	<cfset gTimeInMin = 0>
	<cfset count = 0>

<section id="formElements">
	<div class="container">
		<form id="filterForm" action="" method="post">
			<div class="inline_input">
				<label>From:</label>
				<INPUT class="datepicker" name="WeekendFrom" value="#WeekendFrom#" size="9">
			</div>

			<div class="inline_input">
				<label>To:</label>
				<INPUT class="datepicker" name="WeekendTo" value="#WeekendTo#" size="9">
			</div>

			<div class="inline_input">
				<label>Overlap Time:</label>
				<select name="overlapMinutes">
					<option value="60" <cfif overlapMinutes EQ 60> selected </cfif> >1 Hour</option>
					<option value="75" <cfif overlapMinutes EQ 75> selected </cfif> >1 Hr 15 Min</option>
					<option value="90" <cfif overlapMinutes EQ 90> selected </cfif> >1 Hr 30 Min</option>
					<option value="105" <cfif overlapMinutes EQ 105> selected </cfif> >1 Hr 45 Min</option>
					<option value="120" <cfif overlapMinutes EQ 120> selected </cfif> >2 Hours</option>
				</select>
			</div>

			<div class="inline_input">
				<label>Sort By:</label>
				<select name="sortOrder">
					<option value="DATE" <cfif sortBy EQ "DATE">selected</cfif> >Game Date</option>
					<option value="FIELD" <cfif sortBy EQ "FIELD">selected</cfif> >Field</option>
				</select>
			</div>
		
			<div class="filter_submit">
				<input type="submit" name="go" value="Go">&nbsp;&nbsp;
				<input type="submit" name="printme" value="Printer Friendly">
			</div>
		</form>
	</div>
</section>

<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD width="11%">Game		</TD>
		<TD width="14%">Date/Time		</TD>
		<TD width="20%">PlayField	</TD>
		<TD width="05%">Div			</TD>
		<TD width="25%">Home Team	</TD>
		<TD width="25%">Visitor Team</TD>
	</TR>
</table>

<div style="overflow:auto;height:300px;border:1px ##cccccc solid;">
	<table cellspacing="0" cellpadding="4" align="left" border="0" width="98%">
	<CFLOOP query="qGetgames">
		<cfif PrvFieldAbbr NEQ FIELDABBR OR PrvGameDate NEQ GAME_DATE>
 			<cfset PrvFieldAbbr	= FIELDABBR>
			<cfset PrvGameDate  = dateFormat(GAME_DATE,"mm/dd/yyyy")>
			<cfset PrvGameTime  = timeFormat(GAME_TIME,"hh:mm tt")>
			<cfset PrvGame		= GAME_ID>
			<cfset PrvGameDiv	= DIVISION>
			<cfset PrvHomeTeam	    = HOME_TEAMNAME>
			<cfset PrvVisitorTeam	= VISITOR_TEAMNAME>
			<cfset PrvGameTimeInMin = gTimeInMin>
			<CFSET PRV_gameDateTime = PrvGameDate & " " & PrvGameTime>
		<CFELSE>
			<CFSET gameDateTime = dateFormat(GAME_DATE,"mm/dd/yyyy") & " " & timeFormat(GAME_TIME,"hh:mm tt")>
			<CFSET PrintIt = "">
			<cfset TimeDiffMinutes = ABS(dateDiff("n",gameDateTime, PRV_gameDateTime))>

			<CFIF TimeDiffMinutes LTE overlapMinutes>
				<cfset PrintIt = "Y">
			</CFIF>
			
			<CFIF Trim(PrintIt) EQ "Y">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,count)#">
					<TD width="11%" align="center">#PrvGame#	</TD>
					<TD width="14%">#PrvGameDate# #PrvGameTime#</TD>
					<TD width="20%">#PrvFieldAbbr#</TD>
					<TD width="05%">#PrvGameDiv#</TD>
					<TD width="25%">#PrvHomeTeam#</TD>
					<TD width="25%">#PrvVisitorTeam#</TD>
				</TR>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,count)#">
					<TD align="center">#GAME_ID#			</TD>
					<TD>#dateFormat(GAME_DATE,"mm/dd/yyyy")# #timeFormat(GAME_TIME,"hh:mm tt")#</TD>
					<TD>#FieldAbbr#</TD>
					<TD>#DIVISION#</TD>
					<TD>#Home_Teamname#</TD>
					<TD>#Visitor_Teamname#</TD>
				</TR>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,count)#">
					<TD class="tdUnderLine" align="right"> <strong>Overlap by : </strong> </TD>
					<TD class="tdUnderLine" align="left" colspan="5">
						<cfset numHours = TimeDiffMinutes \ 60 >	 
						<cfset numMins  = TimeDiffMinutes - ( numHours * 60 )>	
						<strong> #numHours# hours #numMins# min. </strong>   
						<!---#TimeDiffMinutes# #GapHours# hrs and #GapMinutes# ---> 
					</TD>
				</TR>
				<CFSET count = Count + 1>
			</CFIF>
			
			<cfset PrvFieldAbbr	= FIELDABBR>
			<cfset PrvGameDate  = dateFormat(GAME_DATE,"mm/dd/yyyy")>
			<cfset PrvGameTime  = timeFormat(GAME_TIME,"hh:mm tt")>
			<cfset PrvGame		= GAME_ID>
			<cfset PrvGameDiv	= DIVISION>
			<cfset PrvHomeTeam	    = HOME_TEAMNAME>
			<cfset PrvVisitorTeam	= VISITOR_TEAMNAME>
			<cfset PrvGameTimeInMin = gTimeInMin>
			<CFSET PRV_gameDateTime = PrvGameDate & " " & PrvGameTime>
		</cfif>
	</CFLOOP>	
</table>
</div>

<p><strong>Total Overlaps = #Count#</strong></p>

</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">
<cfoutput>
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('.datepicker').datepicker();

		// $('[name=go]').click(submitFilters("rptGameOverlap.cfm"));
		// $('[name=printme]').click(submitFilters("rptGameOverlapPDF.cfm"));

		$('[name=go]').click(function(){ submitFilters("rptGameOverlap.cfm") });
		$('[name=printme]').click(function(){ submitFilters("rptGameOverlapPDF.cfm") });

		function submitFilters(action) {
			$("##filterForm").submit(function(){
				$(this).attr("action", action);
				action == "rptGameOverlapPDF.cfm" ? $(this).attr("target", "_blank") : $(this).attr("target", "");
				return true;
			});
		}
	});
</script>
</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">
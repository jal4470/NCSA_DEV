<!--- 
	FileName:	rptPendingTBSgames.cfm
	Created on: 02/20/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
	
MODS: mm/dd/yyyy - filastname - comments
05/19/09 - aarnone - #7311 added printer friendly
07/20/17 - apinzone (27024) - Added filtering of dates and tbs types

	NOTE! - changes to this page may also have to be included into rptPendingTBSgamesPDF.cfm

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
	<style type="text/css">
		.overflowbox { height: 450px; }
		@media print { .overflowbox { height: auto; overflow:visible; } }
	</style>
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<cfoutput>
<div id="contentText">


<H1 class="pageheading">NCSA - Pending TBS Games</H1>


<!---
	LOCAL VARIABLES
-------------------------------------------->
<CFIF isDefined("FORM.SORTORDER")>
	<CFSET sortBy = FORM.SORTORDER>
<CFELSE>
	<CFSET sortBy = "">
</CFIF>

<CFIF isDefined("FORM.FIELDNAME")>
	<CFSET fieldname = FORM.FIELDNAME>
<CFELSE>
	<CFSET fieldname = "">
</CFIF>

<CFSWITCH expression="#UCASE(VARIABLES.sortBy)#">
	<CFCASE value="FIELD">
		<CFSET orderByClause = " FIELDNAME, GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') ">
	</CFCASE>
	<CFCASE value="DIV">
		<CFSET orderByClause = " division_id, GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') ">
	</CFCASE>
	<CFCASE value="HTEAM">
		<CFSET orderByClause = " HOME_TEAMNAME, GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') ">
	</CFCASE>
	<CFCASE value="VTEAM">
		<CFSET orderByClause = " VISITOR_TEAMNAME, GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') ">
	</CFCASE>
	<cfdefaultcase>
		<CFSET orderByClause = " GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') ">
	</cfdefaultcase>
</CFSWITCH>

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

<!---
	TEAM DATA
-------------------------------------------->
<cfquery name="qTeams" datasource="#SESSION.DSN#">
	select GAME_ID, GAME_DATE, GAME_TIME, FIELDNAME, division_id, VISITOR_TEAMNAME, HOME_TEAMNAME,
			Home_CLUB_ID, Visitor_CLUB_ID 
	  from V_GAMES 
	 where field_ID in 
	 				(select Field_id 
					   from TBL_FIELD 
					  where CLUB_ID = 1)
	   and ( game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#"> and
	   		 game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#"> )
	   <cfif isdefined('fieldname') and len(trim(fieldname))>
	   		and fieldname = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.fieldname#">
	   </cfif>
	ORDER BY #preserveSingleQuotes(VARIABLES.orderByClause)#
</cfquery>

<!---
	LIMIT RESULTS TO LOGGED IN USERS CLUB
-------------------------------------------->
<cfif listFind(SESSION.CONSTANT.CUROLES, SESSION.MENUROLEID) GT 0>
	<cfquery name="qTeams" dbtype="query">
		SELECT * FROM qTeams	
		  WHERE Home_CLUB_ID    = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.USER.CLUBID#">
		     OR Visitor_CLUB_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.USER.CLUBID#">
	</cfquery> 
</cfif>

<!---
	BUILD LIST OF AVAILABLE FIELDNAMES (TBS TYPES)
-------------------------------------------->
<cfquery name="tbsTypes" datasource="#SESSION.DSN#">
	select distinct fieldname
	from V_GAMES
	where field_ID in (select Field_id from TBL_FIELD where CLUB_ID = 1)
</cfquery>

<!---
	PAGE BODY
------------------------------------------------>
<section id="formElements">
	<div class="container">
		<form action="rptPendingTBSgames.cfm" method="post" style="display:inline-block;">

			<div class="inline_input">
				<label>From:</label>
				<INPUT class="datepicker" name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
			</div>

			<div class="inline_input">
				<label>To:</label>
				<INPUT class="datepicker" name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
			</div>

			<div class="inline_input">
				<label>TBS Type:</label>
				<select name="fieldname">
					<option value="">All</option>
					<cfloop query="tbsTypes">
						<option value="#fieldname#" <cfif fieldname EQ variables.fieldname>selected</cfif> > #fieldname#</option> 
					</cfloop>
				</select>
			</div>

			<div class="inline_input">
				<label>Sort By:</label>
				<select name="sortOrder">
					<option value="DATE" <cfif sortBy EQ "DATE">selected</cfif> >Game Date</option>
					<option value="FIELD" <cfif sortBy EQ "FIELD">selected</cfif> >Field</option>
					<option value="DIV" <cfif sortBy EQ "DIV">selected</cfif> >Division</option>
					<option value="HTEAM" <cfif sortBy EQ "HTEAM">selected</cfif> >Home Team</option>
					<option value="VTEAM" <cfif sortBy EQ "VTEAM">selected</cfif> >Visitor Team</option>
				</select>
			</div>

			<div class="filter_submit">
				<INPUT id="printBtn" type="Submit" name="getTBS" value="Go">
			</div>
		</form>

		<form id="printForm" name="printForm" method="post" action="rptPendingTBSgamesPDF.cfm" target="_blank" style="display:inline-block;float:right">
				<input type="hidden" name="WeekendFrom" value="#VARIABLES.WeekendFrom#">
				<input type="hidden" name="WeekendTo" value="#VARIABLES.WeekendTo#">
				<input type="hidden" name="sortBy" value="#sortBy#">
				<input type="Submit" name="printme" value="Printer Friendly">
		</form> 

	</div>
</section>

<table cellspacing="0" cellpadding="4" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD width="10%">Game ID</TD>
		<TD width="15%">Game DateTime</TD>
		<TD width="14%">Field Name</TD>
		<TD width="10%">Division</TD>
		<TD width="24%">Home Team</TD>
		<TD width="27%">Visitor Team</TD>
	</tr>
</table>

<div style="overflow:auto;height:300px;border:1px ##cccccc solid;">
	<table cellspacing="0" cellpadding="4" align="left" border="0" width="98%">
	<CFLOOP query="qTeams">
		<tr  bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
			<TD class="tdUnderLine" width="09%" valign="top">&nbsp; #GAME_ID#</TD>
			<TD class="tdUnderLine" width="16%" valign="top">&nbsp; #dateFormat(GAME_DATE,"mm/dd/yy")# @ #timeFormat(GAME_TIME,"hh:mm tt")#</TD>
			<TD class="tdUnderLine" width="15%" valign="top">&nbsp; #FIELDNAME# </TD>
			<TD class="tdUnderLine" width="10%" valign="top">&nbsp; #division_id# </TD>
			<TD class="tdUnderLine" width="25%" valign="top">&nbsp; #HOME_TEAMNAME# </TD>
			<TD class="tdUnderLine" width="25%" valign="top">&nbsp; #VISITOR_TEAMNAME# </TD>
		</tr>
	</CFLOOP>
	</table>
</div>


</cfoutput>
</div><!---//contentText--->

<cfsavecontent variable="cf_footer_scripts">
<cfoutput>
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('.datepicker').datepicker();		
	});
</script>
</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">


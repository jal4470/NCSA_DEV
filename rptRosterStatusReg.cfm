
 
<cfset mid = 0> <!--- optional =menu id ---> 

<cfif isdefined("form.showMissingRoster")>
	<cfset showMissingRoster = form.showMissingRoster>
<cfelse>
	<cfset showMissingRoster = "">
</cfif>

<cfif isdefined("form.sort")>
	<cfset sort = form.sort>
<cfelse>
	<cfset sort = "team_id">
</cfif>

<cfif isdefined("form.order")>
	<cfset order = form.order>
<cfelse>
	<cfset order = "asc">
</cfif>

<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Status of Roster Uploaded(Registration Season)</H1>

<CFIF isDefined("FORM.PRINTME")>

	<!--- This will pop up a window that will display the page in a pdf --->
	<cfset qString = "showMissingRoster=#showMissingRoster#&sort=#form.sort#&order=#form.order#">	
<!--- 	<script> window.location.href = 'rptTeamCreatedSeason_PDF.cfm?#qString#'; </script>  --->
	<cflocation url="rptRosterStatusReg_PDF.cfm?#qString#">
<CFELSEIF isDefined("FORM.EXPORT")>

	<!--- This will pop up a window that will display the page in a pdf --->
	<cfset qString = "showMissingRoster=#showMissingRoster#&sort=#form.sort#&order=#form.order#">
<!--- 	<script> window.location.href = 'rptRosterStatus_csv.cfm?#qString#'; </script>  --->
	<cflocation url="rptRosterStatusReg_csv.cfm?#qString#">
</CFIF>


<cfif isDefined("FORM.GO") >


		<CFQUERY name="registeredTeams" datasource="#SESSION.DSN#">
		SELECT 
			   T.team_id, T.teamName, CASE WHEN r.team_id is not null then 'Y' else 'N' end as RosterStatus,roster_id
		FROM    tbl_team T  LEFT JOIN tbl_roster r on r.team_id = t.team_id
		WHERE T.season_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.regseason.id#">
			AND T.playLevel <> 'R'
		<cfif showMissingRoster eq 1>
			AND 
			  r.content is null 
		<cfelseif showMissingRoster eq 0 >
			AND 
			  r.content is not null
		</cfif>

	</CFQUERY>	

</cfif>

<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<FORM name="Games" action="#cgi.script_name#"  method="post">
	<input name="sort" type="hidden" value="team_id">
	<input name="order" type="hidden" value="asc">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%" >
	
	<tr><td><b>Teams</b>

				<SELECT name="showMissingRoster"> 
					<OPTION value="" #iif(showMissingRoster eq "",de("selected=selected"),de(""))# >Select All</OPTION>
					<OPTION value="0" #iif(showMissingRoster eq 0,de("selected=selected"),de(""))#>Teams with Roster Uploaded</OPTION>
					<OPTION value="1" #iif(showMissingRoster eq 1,de("selected=selected"),de(""))# >Teams with NO Roster Uploaded</OPTION>
				</SELECT>
			<input type="SUBMIT" name="Go"  value="Go" >  
			<input type="Submit" name="printme" value="Printer Friendly">
			<input type="Submit" name="Export" value="Export">
		</td>

	</tr>

</table>	
</FORM>

<CFIF IsDefined("registeredTeams")>
	<table id="resultTable" class="table1 tablesorter" cellspacing="0" cellpadding="3" border="0" width="100%">
		<thead>
		<tr>
			<th data-sort="team_id"  data-order="asc">Team Number</th>
			<th  data-sort="teamName"  data-order="asc">Team Name</th>
			<th  data-sort="content"  data-order="asc">Uploaded</th>
		</tr>
		</thead>
		<tbody>
	<cfloop query="registeredTeams">
		<tr>
			<td>
				<cfif roster_id neq "">
					<a target="_blank" title="click to view roster" href="rosterView.cfm?roster_id=#roster_id#">#team_id#</a>
				<cfelse>
					#team_id#
				</cfif>	
			</td>
			<td>#teamName#</td>
			<td>#RosterStatus#</td>
		</tr>
	</cfloop>
	</tbody>
	</table>
</CFIF>

</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">
<cfoutput>
<script language="JavaScript" type="text/javascript" src="assets/jquery.tablesorter.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=WeekendFrom],input[name=WeekendTo]').datepicker();
		
			$("th").click(function(){
				//console.log($(this).data('sort'));
				$('input[name=sort]').val($(this).data('sort'));
				//console.log($(this).data('order'));
				$('input[name=order]').val($(this).data('order'));
				if($(this).data('order') == 'asc')
					$(this).data('order','desc');
				else
					$(this).data('order','asc');
				
			});
		$('##resultTable').tablesorter();
	});
</script>
</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">






<!--- 
	FileName:	rptClubRefs.cfm
	Created on: 2/11/2011
	Created by: bcooper@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>
<div id="contentText">






<H1 class="pageheading">NCSA - Referee Contacts not through NCSA Club</H1>
<!--- <br><h2>yyyyyy </h2> 
<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">--->


<CFIF isDefined("FORM.workingSeason")>
	<cfset workingSeason = trim(FORM.workingSeason)>
<CFELSE>
	<cfset workingSeason = "">
</CFIF>

<CFQUERY name="qWorkingSeasons" datasource="#SESSION.DSN#">
	SELECT SEASON_ID, SEASON_YEAR, SEASON_SF, 
		   CURRENTSEASON_YN, REGISTRATIONOPEN_YN
	  FROM TBL_SEASON 
	ORDER BY SEASON_ID desc
</CFQUERY>

<FORM action="rptClubRefs.cfm" method="post">
<table cellspacing="0" cellpadding="3" align="center" border="0" width="99%">
	<TR>
		<TD valign="bottom">
			<b>Season:</b>	
				<SELECT name="workingSeason" >
					<CFLOOP query="qWorkingSeasons">
						<CFSET curr = "">
						<CFSET reg = "">
						<CFIF CURRENTSEASON_YN EQ 'Y'>
							<CFSET curr = "(current)">
						</CFIF> 
						<CFIF REGISTRATIONOPEN_YN EQ 'Y'>
							<CFSET reg = "(registration)">
						</CFIF> 
						<option value="#season_id#" <cfif VARIABLES.workingSeason EQ season_id>selected</cfif> >#SEASON_YEAR# #SEASON_SF# #curr# #reg# </option>
					</CFLOOP>
				</SELECT>
		</td>
	</TR>
	
	<TR>
		<TD>
			<INPUT type="Submit" name="getRefs" value="Get Referees">
		</TD>
	</TR>
</table>
</FORM>

<CFIF isDefined("FORM.getRefs")>
	<cfquery name="qGetRefs" datasource="#SESSION.DSN#">
		select c.lastname, c.firstname, cl.club_name from tbl_contact c
		inner join xref_contact_role cr
		on c.contact_id=cr.contact_id
		inner join tbl_club cl
		on c.club_Id=cl.club_id
		where cr.role_id=25
		and cr.season_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#workingSeason#">
		and (cr.club_id <> 1 or c.club_id <> 1)
	</cfquery>
</CFIF>
<script language="JavaScript" type="text/javascript" src="assets/jquery-1.4.2.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery.tablesorter.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('##refTable').tablesorter({
			sortList:[[1,0],[0,0]]
		});
	});
</script>
	
<cfif isDefined("qGetRefs") AND qGetRefs.RECORDCOUNT>
	<b>Number of Refs: #qGetRefs.RECORDCOUNT# </b>
	<table class="table1" cellspacing="0" cellpadding="2" border="0" width="100%" id="refTable">
		<thead>
			<tr>
				<th>
					Name
				</th>
				<th>
					Club
				</th>
			</tr>
		</thead>
		<tbody>
		<cfloop query="qGetRefs">
			<tr>
				<td>#lastname#, #firstname#</td>
				<td>#club_name#</td>
			</tr>
		</cfloop>
		</tbody>
	</table>
	
</cfif>





</cfoutput>
</div>
<cfinclude template="_footer.cfm">

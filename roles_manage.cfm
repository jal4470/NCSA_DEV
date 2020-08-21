<!--- 
	FileName:	roles_manage.cfm
	Created on: 3/17/2010
	Created by: bcooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Manage Roles</H1>
<br> <!--- <h2>yyyyyy </h2> --->

<!--- get all roles --->
<cfquery datasource="#session.dsn#" name="getRoles">
	select role_id, roledisplayname
	from tlkp_role
	where role_id <> 61
	order by roledisplayname
</cfquery>



<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD>&nbsp;</TD>
		<TD>&nbsp;</TD>
		<TD>Name</TD>
	</tr>
	<CFLOOP query="getRoles">
		<tr>
			<TD align="left" class="tdUnderLine" style="white-space:nowrap;">
				<a href="roles_menu_manage.cfm?role_id=#role_id#">Menus</a>
			</TD>
			<TD align="left" class="tdUnderLine" style="white-space:nowrap;">
				<a href="roles_report_manage.cfm?role_id=#role_id#">Report Types</a>
			</TD>
			<TD class="tdUnderLine" align="left"> #roledisplayname# </TD>
		</tr>
	</CFLOOP>
</table>


</cfoutput>
</div>
<cfinclude template="_footer.cfm"> 

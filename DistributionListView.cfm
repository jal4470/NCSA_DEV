<cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock>
 <!--- validate login --->
<cfmodule template="_checkLogin.cfm">
 
<cfstoredproc procedure="p_run_dl" datasource="#reports_dsn#">
	<cfprocparam cfsqltype="CF_SQL_INTEGER" type="In" value="#url.dli#">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="Out" variable="SQL">
</cfstoredproc>

<cfquery datasource="#reports_dsn#" name="contacts">
#preservesinglequotes(SQL)#
</cfquery>
<!---  --->
<!--- <cfdump var="#contact_ids#"><cfabort> --->
<!--- <cfdump var="#contacts.columnlist#"> --->

<!---  --->
<cfset colList = arrayToList(contacts.GetColumnNames())>

<cfsavecontent variable="out">
<table border="1">
<tr>
<cfloop list="#colList#" index="i">
	<td><cfoutput>#i#</cfoutput></td>
</cfloop>
</tr>
<cfloop query="contacts">
  <TR>
<cfloop list="#colList#" index="j">
	<Cfset value = contacts["#j#"]>
	<td><cfoutput>#value#</cfoutput></td>
</cfloop>
  </TR>
</cfloop>
</table>
</cfsavecontent>
<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="inline; filename=contacts.xls"> 
<cfoutput>#out#</cfoutput> 
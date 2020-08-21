

<!--- Security --->
<cfinclude template="_secureme.cfm">



<cfif isdefined("url.txtName")>
	<cfset txtName = url.txtName>
<cfelseif isdefined("form.txtName")>
	<cfset txtName = form.txtName>
<cfelse>
	<cfset txtName = "">
</cfif>

<cfif isdefined("url.txtDesc")>
	<cfset txtDesc = url.txtDesc>
<cfelseif isdefined("form.txtDesc")>
	<cfset txtDesc = form.txtDesc>
<cfelse>
	<cfset txtDesc = "">
</cfif>

<!--- add folder --->
<cfstoredproc datasource="#application.reports_dsn#" procedure="p_create_folder">
	<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@organization_id" value="#organization_id#" type="In">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@name" value="#txtName#" type="In">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@desc" value="#txtDesc#" type="In">
	<cfprocparam cfsqltype="CF_SQL_BIT" dbvarname="@editable" value="1" type="In">
	<cfprocparam cfsqltype="CF_SQL_BIT" dbvarname="@removable" value="1" type="In">
	<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@folder_id" variable="folder_id" type="Out">
</cfstoredproc>

<cflocation url="rptBldr_home.cfm?s=#securestring#" addtoken="No">
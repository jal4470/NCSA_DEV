
<cfinclude template="_checkLogin.cfm">

<cfset name=form.name>
<cfset public=form.public>

<cfif isdefined("form.chkAdminEdit")>
	<cfset adminEditable=form.chkAdminEdit>
<cfelse>
	<cfset adminEditable=false>
</cfif>

<cfif form.file NEQ "">
	<!--- upload file to temp folder --->
	<cffile action="UPLOAD" destination="#application.sitevars.tempPath#" nameconflict="MAKEUNIQUE" filefield="form.file">
	
	
	<!--- read file back into variable --->
	<cffile action="READBINARY" file="#application.sitevars.tempPath#\#cffile.serverfile#" variable="binContent">
	
	
	<cfstoredproc datasource="#session.dsn#" procedure="p_insert_form">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@name" type="In" value="#form.name#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@formType" type="In" value="1">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@filename" type="In" value="#replace(cffile.clientfilename," ","_","all")#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@extension" type="In" value="#cffile.clientfileext#">
		<cfprocparam cfsqltype="CF_SQL_LONGVARBINARY" dbvarname="@content" type="In" value="#bincontent#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@linkURI" type="In" null="Yes">
		<cfprocparam cfsqltype="CF_SQL_BIT" dbvarname="@active_flag" type="In" value="1">
		<cfprocparam cfsqltype="CF_SQL_BIT" dbvarname="@showInUI" type="In" value="0">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@group_id" type="In" value="0">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@contact_id" type="In" value="#session.user.contactid#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@form_id" type="Out" variable="form_id">
	</cfstoredproc>
	
	<cfset location="formsView.cfm?form_id=#form_id#">
	
	
	<!--- delete temp file --->
	<cffile action="DELETE" file="#application.sitevars.tempPath#\#cffile.serverfile#">
<cfelse>
	<cfset location=form.location>
</cfif>

<cfif public EQ 2>
	<cfset location_id=3>
<cfelse>
	<cfset location_id=4>
</cfif>

<!--- save menu entry --->
<cfinvoke
	component="#session.sitevars.cfcpath#.menu"
	method="addMenu"
	menu_name="#name#"
	location="#location#"
	parent_menu_id="#parent_menu_id#"
	isPublic="#public#"
	location_id="#location_id#"
	adminEditable="#adminEditable#"
	returnvariable="menu_id">
	
<cflocation url="menu_manage.cfm" addtoken="No">
	

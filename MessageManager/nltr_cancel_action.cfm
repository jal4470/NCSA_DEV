<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS UI Page		   			--->
<!------------------------------------->
<!---  Created:  10.10.2007 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 				--->
<!------------------------------------->

<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
	<cfset CRS_API_Path = application.MM_API_Path>
</cflock>

 
 <!--- validate login --->
 <cfmodule template="../_checkLogin.cfm">
 

<!----------------------->
<!--- Local variables --->
<!----------------------->
<cfif isdefined("form.message_id")>
	<cfset message_id  = form.message_id>
<cfelseif isdefined("url.message_id")>
	<cfset message_id = url.message_id>
<cfelse>
	<cfset message_id = "">	
</cfif>

<cfif isdefined("form.nextpage")>
	<cfset nextpage  = form.nextpage>
<cfelseif isdefined("url.nextpage")>
	<cfset nextpage = url.nextpage>
<cfelse>
	<cfset nextpage = "">	
</cfif>

<!-------------->
<!-------------->
<!--- Action --->
<!-------------->
<!-------------->
<cftry>
	<CFSTOREDPROC datasource="#dsn#" procedure="p_remove_message" returncode="YES" >
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#message_id#" DBVARNAME="@message_id">
	</CFSTOREDPROC>

	<cfcatch type="database">
		<cfoutput>ERROR,#cfcatch.message#: #cfcatch.detail#</cfoutput>
		<cfabort>
	</cfcatch>
	<cfcatch type="any">
		<cfdump var="#cfcatch#">
		<cfabort>
	</cfcatch>
</cftry>
<!---------------->
<!--- Redirect --->
<!---------------->
<CFIF nextpage IS NOT "">
	<cflocation url="#nextpage#" addtoken="no">
<CFELSE>
	<cflocation url="nltr_home.cfm" addtoken="no">
</CFIF>

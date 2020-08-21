<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   		--->
<!------------------------------------->
<!---  Created:  10.24.2006 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 10.26.2006	--->
<!------------------------------------->

 
 <!--- validate login --->
 <cfmodule template="../_checkLogin.cfm">
 
<!--- Set Application variables --->

<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
	<cfset CRS_API_Path = application.MM_API_Path>
</cflock>

<!----------------------->
<!--- Local variables --->
<!----------------------->
<cfif isdefined("form.message_id")>
	<cfset message_id  = form.message_id>
<cfelseif isdefined("url.message_id")>
	<cfset message_id = url.message_id>
<cfelse>
	<CF_ERROR error="Message is not defined.">
</CFIF>

<!----------------------->
<!--- call newsletter gateway --->
<!----------------------->

<CFSCRIPT>
emailBlastData = structNew();
emailBlastData.message_id = "#message_id#";
emailBlastData.timeout = 10000;
status = SendGatewayMessage("NewsEmailer", emailBlastData);
</CFSCRIPT>

<!---------------->
<!--- Get data --->
<!---------------->


<cftry>
	<CFSTOREDPROC datasource="#dsn#" procedure="p_set_message_sent_date" returncode="YES">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#message_id#" DBVARNAME="@message_id">
	</CFSTOREDPROC>
	<!---------------->
<!--- Redirect --->
<!---------------->
<cfset msg = "Message Has Been Qeued">
<cflocation url="nltr_view_sent.cfm?msg=#msg#">
	<cfcatch type="database">		
		<cfoutput>ERROR, #cfcatch.nativeErrorCode#,#cfcatch.detail#,#cfcatch.message#</cfoutput>
		<cfabort>
	</cfcatch>
	<cfcatch type="any">
		<cfdump var="#cfcatch#">
		<cfabort>
	</cfcatch>
</cftry>




 
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
<cfstoredproc procedure="p_set_message_test_mode" datasource="#application.dsn#">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#message_id#" DBVARNAME="@message_id">
	<cfprocparam type="in" cfsqltype="CF_SQL_BIT" dbvarname="@test_mode_flag" value=0> 
</cfstoredproc>

<!--- <CFSCRIPT>
emailBlastData = structNew();
emailBlastData.message_id = "#message_id#";
emailBlastData.timeout = 10000;
status = SendGatewayMessage("NewsEmailer", emailBlastData);
</CFSCRIPT> --->

<!---------------->
<!--- Get data --->
<!---------------->

<cfinclude template="sendMessage.cfm">

<!--- Redirect --->
<!---------------->
<cfset msg = "Message Has Been Sent">
<cflocation url="index.cfm?msg=#msg#">



<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS UI Page		   			--->
<!------------------------------------->
<!---  Created:  10.10.2007 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 				
1/15/2009 -- J.Lechuga increase timeout to handle large batches
--->
<!------------------------------------->
<cfsetting requesttimeout="600">

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
<cfstoredproc procedure="p_set_message_test_mode" datasource="#application.dsn#">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#message_id#" DBVARNAME="@message_id">
	<cfprocparam type="in" cfsqltype="CF_SQL_BIT" dbvarname="@test_mode_flag" value='1'> 
</cfstoredproc>

<!--- <CFSCRIPT>
emailBlastData = structNew();
emailBlastData.message_id = "#message_id#";
emailBlastData.timeout = 10000;
status = SendGatewayMessage("NewsEmailer", emailBlastData);
</CFSCRIPT> --->

       <!--------- <cfset logFileName = DateFormat(now(), "YYYYMMDD") & "_" & TimeFormat(now(), "HHmmss") & "_" & #CFEvent.Data.message_id# & ".txt" />
        <cffile action="write" file="E:\Inetpub\securewwwroot\products\communitypass\log\#logFileName#" output="Component	ID	Description	Date/Time	Code" addnewline="yes" />
        
        -------------------------------->
		<!--- INSERT FIRST ENTRY				--->
		<!----------------------------------------->
        <cfstoredproc  datasource="#application.dsn#" procedure="P_INSERT_MESSAGE_GATEWAY_LOG">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@Message_id" value="#message_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Component" value="Newsletter">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Description" value="Begin Transaction">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Error_Code" value="0">
		</cfstoredproc>
      	<!---------  <cffile action="append" file="E:\Inetpub\securewwwroot\products\communitypass\log\#logFileName#" output="Newsletter	#CFEvent.Data.message_id#	Begin Transaction	#DateFormat(now(), "MM/DD/YYYY")# - #TimeFormat(now(), "HH:mm ss")#	0" addnewline="yes" />


	-------------------------------->
		<!--- GET MESSAGE METADATA				--->
		<!----------------------------------------->
	
   		<cfinclude template="sendMessage.cfm">
	


<!---------------->
<!--- Get data --->
<!---------------->

<cfset msg = "Message Has Been Sent">
<!--- <cftry>
	<CFSTOREDPROC datasource="#dsn#" procedure="p_set_message_sent_date" returncode="YES">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#message_id#" DBVARNAME="@message_id">
	</CFSTOREDPROC>
	<!---------------->
<!--- Redirect --->
<!---------------->

	<cfcatch type="database">		
		<cfoutput>ERROR, #cfcatch.nativeErrorCode#,#cfcatch.detail#,#cfcatch.message#</cfoutput>
		<cfabort>
	</cfcatch>
	<cfcatch type="any">
		<cfdump var="#cfcatch#">
		<cfabort>
	</cfcatch>
</cftry> --->




<CFSET next_page="Step4.cfm?msg=#urlencodedformat(msg)#&message_id=#message_id#">


<cflocation url="#next_page#" addtoken="no">

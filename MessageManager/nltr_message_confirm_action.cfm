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

<cfif isdefined("form.submit")>
	<cfset submit  = form.submit>
<cfelseif isdefined("url.submit")>
	<cfset submit = url.submit>
<cfelse>
	<cfset submit = "">	
</cfif>



<!------------------->
<!--- Validations --->
<!------------------->
<cfset error = "">

<!--- Required fields --->

<cfif message_id IS "">
	<CF_ERROR error="Message is required">	
</cfif>

<CFIF submit IS "Save Draft">
	<CFSET next_page="index.cfm">
<CFELSEIF submit IS "Send">
	<CFSET next_page="nltr_message_send_action.cfm">
<CFELSEIF submit IS "Send2">
	<CFSET next_page="nltr_message_send_action.cfm">
<CFELSEIF submit IS "Edit">
	<CFSET next_page="nltr_new_message.cfm">
<CFELSE>
	<CFSET next_page="index.cfm">
</CFIF>


<!---------------->
<!--- Redirect --->
<!---------------->


<cflocation url="#next_page#?message_id=#message_id#" addtoken="no">

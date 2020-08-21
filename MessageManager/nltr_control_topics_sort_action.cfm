<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   		--->
<!------------------------------------->
<!---  Created:  11.14.2007 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 				--->
<!------------------------------------->

 
 <!--- validate login --->
 <cfmodule template="../_checkLogin.cfm">
 
<!--- Set Application variables --->
<cfif not isdefined("application.dsn")>
	<cfinclude template="application.cfm">
</cfif>
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
	<cfset CRS_API_Path = application.CRS_API_Path>
	<cfset site_title = application.site_title>
</cflock>

<!--- Security --->
<cfinclude template="_secureme.cfm">

<!--------------------------->
<!--- Set local variables --->
<!--------------------------->
<cfif isdefined("form.form_question_id")>
	<cfset form_question_id = form.form_question_id>
<cfelseif isdefined("url.form_question_id")>
	<cfset form_question_id = url.form_question_id>
<cfelse>
	<cfset form_question_id = "">
</cfif>

<cfif isdefined("form.newattrseq")>
	<cfset newattrseq = form.newattrseq>
<cfelseif isdefined("url.newattrseq")>
	<cfset newattrseq = url.newattrseq>
<cfelse>
	<cfset newattrseq = "">
</cfif>

<!------------------>
<!--- Validation --->
<!------------------>
<cfif form_question_id EQ "">
	<cf_error error="System error: cannot find topic question.">
</cfif>

<cfif newattrseq EQ "">
	<cf_error error="System error: cannot determine sort list contents.">
</cfif>

<!-------------------------->
<!--- Create sort string --->
<!-------------------------->
<cfset seq_list = "">
<cfloop from="1" to="#ListLen(newattrseq)#" index="i">
	<cfset seq_list = ListAppend(seq_list,"#i#=#ListGetAt(newattrseq,i)#",",")>
</cfloop>

<!---------------->
<!--- Call API --->
<!---------------->
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/ResequenceNewsletterTopics.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="form_question_id" TYPE="FormField" VALUE="#form_question_id#">
		<CFHTTPPARAM NAME="seq_list" TYPE="FormField" VALUE="#seq_list#">
	</CFHTTP>

	<cfif cfhttp.filecontent CONTAINS "HTTP/1.0 404 Object Not Found">
		<cfthrow message="Error page not found">
	</cfif>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<!--- Set variables based on API output --->
<cfset status = getToken(cfhttp.filecontent, 1, ",")>
<cfif trim(status) NEQ "SUCCESS">
	<cf_error session_id="#session_id#" error="#error#" code="#returncode#" UI_page="activity_change_action.cfm">
</cfif>

<!---------------->
<!--- Redirect --->
<!---------------->
<cfset msg = "Topics sorted successfully.">
<cflocation url="nltr_control_topics.cfm?s=#securestring#&msg=#msg#">

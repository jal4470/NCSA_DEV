<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   		--->
<!------------------------------------->
<!---  Created:  10.24.2006 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 10.26.2006	--->
<!------------------------------------->

<!--- Set Application variables --->
<cfif not isdefined("application.dsn")>
	<cfinclude template="application.cfm">
</cfif>
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
	<cfset site_title = application.site_title>
</cflock>

<!--- Security --->
<cfinclude template="_secureme.cfm">

<cfif isdefined("form.form_question_choice_id")>
	<cfset form_question_choice_id = form.form_question_choice_id>
<cfelseif isdefined("url.form_question_choice_id")>
	<cfset form_question_choice_id = url.form_question_choice_id>
<cfelse>
	<cfset form_question_choice_id = "">
</cfif>


<!---------------->
<!--- Get data --->
<!---------------->
<cftry>
	<CFSTOREDPROC datasource="#dsn#" procedure="p_get_nltr_topic_recipient_list" returncode="YES">
		<CFPROCRESULT NAME="getTopicList" RESULTSET="1">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#organization_id#" DBVARNAME="@organization_id">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#form_question_choice_id#" DBVARNAME="@form_question_choice_id">
	</CFSTOREDPROC>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<CFTRY>
	<CFINVOKE component="#application.CRS_CFC_Path#GetForm" method="GetChoice" returnvariable="GetChoice">
		<cfinvokeargument name="form_question_choice_id" value="#form_question_choice_id#">
	</CFINVOKE>
	<CFCATCH type="any">
		<CF_ERROR error="Cannot get Choice.">			
	</CFCATCH>			
</CFTRY>
<CFIF GetChoice.recordcount GT 0>
	<CFSET fqc_desc = "#GetChoice.choice_short_desc#">
</CFIF>

<!--- Filename --->
<cfset filename = "topic_recipient_list_" & DateFormat(Now(),"yyyymmdd") & TimeFormat(Now(),"HHmmss") & ".xls">

<!--- Carriage return character --->
<cfset CR = Chr(13) & Chr(10)>

<!----------------->

<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="filename=#Filename#">


<table border="1" cellspacing="0" cellpadding="0" width="100%">
	<CFOUTPUT>
	<tr>
		<td colspan="5"><b>#fqc_desc# Subscribers</b></td>
	</tr>
	</CFOUTPUT>
	<tr>
		<td width="200"><b>Name</b></td>
		<td><b>Email</b></td>
		<td width="150"><b>Status</b></td>
		<td width="175"><b>Date Created</b></td>
		<td width="175"><b>Last Update</b></td>
	</tr>
	<CFOUTPUT>
	<CFLOOP QUERY="getTopicList">
	<tr>
		<td>#lname#, #fname#</td>
		<td>#email#</td>
		<td>#status#</td>
		<td>#DATEFORMAT(datecreated,"MM/DD/YYYY")# - #TIMEFORMAT(datecreated,"h:mm tt")#</td>
		<td>#DATEFORMAT(last_update,"MM/DD/YYYY")# - #TIMEFORMAT(last_update,"h:mm tt")#</td>
	</tr>
	</CFLOOP>
	</CFOUTPUT>
</table>
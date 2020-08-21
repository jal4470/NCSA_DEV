<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS UI Page		   			--->
<!------------------------------------->
<!---  Created:  02.07.2003 by		--->
<!---	         Phil Rogers		--->
<!---
MODIFICATIONS
9/14/2009 P WATERS
- Replaced "Family Info" with "Account Info"
									--->
<!------------------------------------->

<!--- Set Application variables --->
<cfif not isdefined("application.dsn")>
	<cfinclude template="application.cfm">
</cfif>
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
	<cfset CRS_API_Path = application.CRS_API_Path>
</cflock>

<!--- Security --->
<cfinclude template="_secureme.cfm">

<!----------------------->
<!--- Local variables --->
<!----------------------->

<!--- Form fields --->
<cfif isdefined("form.rpg_email")>
	<cfset rpg_email  = form.rpg_email>
<cfelseif isdefined("url.rpg_email")>
	<cfset rpg_email = url.rpg_email>	
<cfelse>
	<cfset rpg_email = "">	
</cfif>

<cfif isdefined("form.primary_address")>
	<cfset primary_address = form.primary_address>
<cfelseif isdefined("url.primary_address")>
	<cfset primary_address = url.primary_address>
<cfelse>
	<cfset primary_address = "">
</cfif>

<cfif isdefined("form.primary_city")>
	<cfset primary_city = form.primary_city>
<cfelseif isdefined("url.primary_city")>
	<cfset primary_city = url.primary_city>
<cfelse>
	<cfset primary_city = "">
</cfif>

<cfif isdefined("form.primary_state")>
	<cfset primary_state = form.primary_state>
<cfelseif isdefined("url.primary_state")>
	<cfset primary_state = url.primary_state>
<cfelse>
	<cfset primary_state = "">
</cfif>

<cfif isdefined("form.primary_zip5")>
	<cfset primary_zip5 = form.primary_zip5>
<cfelseif isdefined("url.primary_zip5")>
	<cfset primary_zip5 = url.primary_zip5>
<cfelse>
	<cfset primary_zip5 = "">
</cfif>

<cfif isdefined("form.topic_choice_id")>
	<cfset topic_choice_id = form.topic_choice_id>
<cfelseif isdefined("url.topic_choice_id")>
	<cfset topic_choice_id = url.topic_choice_id>
<cfelse>
	<cfset topic_choice_id = "">
</cfif>

<cfif isdefined("form.form_question_choice_id")>
	<cfset form_question_choice_id = form.form_question_choice_id>
<cfelseif isdefined("url.form_question_choice_id")>
	<cfset form_question_choice_id = url.form_question_choice_id>
<cfelse>
	<cfset form_question_choice_id = "">
</cfif>

<cfif isdefined("form.searchterm")>
	<cfset searchterm = form.searchterm>
<cfelseif isdefined("url.searchterm")>
	<cfset searchterm = url.searchterm>
<cfelse>
	<cfset searchterm = "">
</cfif>

<cfif isdefined("form.start_record")>
	<cfset start_record = form.start_record>
<cfelseif isdefined("url.start_record")>
	<cfset start_record = url.start_record>
<cfelse>
	<cfset start_record = "">
</cfif>

<cfif isdefined("form.end_record")>
	<cfset end_record = form.end_record>
<cfelseif isdefined("url.end_record")>
	<cfset end_record = url.end_record>
<cfelse>
	<cfset end_record = "">
</cfif>


<!------------------->
<!------------------->
<!--- Validations --->
<!------------------->
<!------------------->
<!--- Initialize error variable --->
<cfset error = "">

<!--------------------->
<!--- Hidden fields --->
<!--------------------->
<cfif organization_id EQ "">
	<cf_error error="A system error has occured - cannot determine next page. Please report this error to the site administrator immediately.">
</cfif>

<!----------------------->
<!--- Required fields --->
<!----------------------->
<cfif rpg_email EQ "">
	<cfset error = error & "<li>Required field email cannot be blank.">
</cfif>

<cfif primary_address EQ "">
	<cfset error = error & "<li>Required field address cannot be blank.">
</cfif>

<cfif primary_city EQ "">
	<cfset error = error & "<li>Required field city cannot be blank.">
</cfif>

<cfif primary_state EQ "">
	<cfset error = error & "<li>Required field state cannot be blank.">
</cfif>

<cfif primary_zip5 EQ "">
	<cfset error = error & "<li>Required field zip cannot be blank.">
</cfif>

<!------------------------>
<!--- Incorrect Length --->
<!------------------------>
<cfif len(primary_zip5) NEQ 5>
	<cfset error = error & "<li>Zip must be five digits long.">
</cfif>

<!----------------------->
<!--- Type conversion --->
<!----------------------->
<cfif NOT isnumeric(primary_zip5)>
	<cfset error = error & "<li>Zip must be numeric.">
</cfif>

<!---------------------------->
<!--- Miscellaneous errors --->
<!---------------------------->
<cfinclude template="../UDF_IsValidEmail.cfm">
<cfif IsValidEmail(rpg_email) EQ 0>
	<cfset error = error & "<li>Invalid email format.">
</cfif>

<!--------------------------------->
<!--------------------------------->
<!--- If errors, display errors --->
<!--------------------------------->
<!--------------------------------->
<cfif error NEQ "">
	<cf_error error="#error#">
</cfif>

<!---------------->
<!--- Get data --->
<!---------------->
<cftry>
	<cfquery name="getFamilyInfo" datasource="#dsn#">
	SELECT FAMILY_NAME,
	       RPG_ID,
	       RPG_FNAME,
	       RPG_LNAME,
	       PRIMARY_PHONE
	  FROM V_FAMILY
	 WHERE FAMILY_ID = <CFQUERYPARAM VALUE="#FAMILY_ID#">
	</cfquery>

	<cfif getfamilyInfo.RecordCount EQ 0>
		<cf_error error="System error: cannot locate family data.">
	<cfelse>
		<cfset family_name = getFamilyInfo.family_name>
		<cfset rpg_id = getFamilyInfo.rpg_id>
		<cfset rpg_fname = getFamilyInfo.rpg_fname>
		<cfset rpg_lname = getFamilyInfo.rpg_lname>
		<cfset primary_phone = getFamilyInfo.primary_phone>
	</cfif>

	<!--- Retrieve topic choice form_id --->
	<cfquery name="getFormID" datasource="#dsn#">
	SELECT FORM_ID
	  FROM V_FORM
	 WHERE ORGANIZATION_ID = <CFQUERYPARAM VALUE="#ORGANIZATION_ID#">
	   AND FORM_TYPE_ID = 3
	</cfquery>

	<cfif getFormID.RecordCount EQ 0>
		<cf_error error="System error: Cannot find topic form. Please report this error to the site administrator immediately.">
	<cfelse>
		<cfset form_id = getFormID.form_id>
	</cfif>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<!-------------->
<!-------------->
<!--- Action --->
<!-------------->
<!-------------->

<!--------------------------->
<!--------------------------->
<!--- Update Account Info --->
<!--------------------------->
<!--------------------------->
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/UpdateFamilyInfo.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="family_id" TYPE="FormField" VALUE="#family_id#">
		<CFHTTPPARAM NAME="family_name" TYPE="FormField" VALUE="#family_name#">
		<CFHTTPPARAM NAME="rpg_email" TYPE="FormField" VALUE="#rpg_email#">
		<CFHTTPPARAM NAME="rpg_fname" TYPE="FormField" VALUE="#rpg_fname#">
		<CFHTTPPARAM NAME="rpg_lname" TYPE="FormField" VALUE="#rpg_lname#">
		<CFHTTPPARAM NAME="primary_address" TYPE="FormField" VALUE="#primary_address#">
		<CFHTTPPARAM NAME="primary_city" TYPE="FormField" VALUE="#primary_city#">
		<CFHTTPPARAM NAME="primary_state" TYPE="FormField" VALUE="#primary_state#">
		<CFHTTPPARAM NAME="primary_zip5" TYPE="FormField" VALUE="#primary_zip5#">
		<CFHTTPPARAM NAME="primary_phone" TYPE="FormField" VALUE="#primary_phone#">
	</CFHTTP>

	<cfif cfhttp.filecontent CONTAINS "HTTP/1.0 404 Object Not Found">
		<cfthrow message="Error page not found">
	</cfif>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<cfset status = getToken(cfhttp.filecontent, 1, ",")>
<cfif trim(status) NEQ "SUCCESS">
	<cfset returncode = trim(getToken(cfhttp.filecontent, 2, ","))>
	<cfset error = trim(getToken(cfhttp.filecontent, 3, ","))>
	<cf_error error="#error#" code="#returncode#" UI_page="news_retuser_action.cfm">
</cfif>

<!---------------------------->
<!---------------------------->
<!--- Record topic choices --->
<!---------------------------->
<!---------------------------->
<!--- Create form transaction --->
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/CreateFormTransaction.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="form_id" TYPE="FormField" VALUE="#form_id#">
		<CFHTTPPARAM NAME="family_id" TYPE="FormField" VALUE="#family_id#">
	</CFHTTP>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<cfset status = getToken(cfhttp.filecontent, 1, ",")>
<cfif trim(status) EQ "SUCCESS">
	<cfset form_transaction_id = getToken(cfhttp.filecontent, 2, ",")>
<cfelse>
	<cfset returncode = trim(getToken(cfhttp.filecontent, 2, ","))>
	<cfset error = trim(getToken(cfhttp.filecontent, 3, ","))>
	<cf_error error="#error#" code="#returncode#" UI_page="news_retuser_action.cfm">
</cfif>

<!--- Create form transaction individual --->
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/CreateFormTransactionIndividual.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="form_transaction_id" TYPE="FormField" VALUE="#form_transaction_id#">
		<CFHTTPPARAM NAME="individual_id" TYPE="FormField" VALUE="#rpg_id#">
	</CFHTTP>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<cfset status = getToken(cfhttp.filecontent, 1, ",")>
<cfif trim(status) EQ "SUCCESS">
	<cfset form_transaction_individual_id = getToken(cfhttp.filecontent, 2, ",")>
<cfelse>
	<cfset returncode = trim(getToken(cfhttp.filecontent, 2, ","))>
	<cfset error = trim(getToken(cfhttp.filecontent, 3, ","))>
	<cf_error error="#error#" code="#returncode#" UI_page="news_retuser_action.cfm">
</cfif>

<!--- Create form responses --->
<cfif topic_choice_id NEQ "">
<cfloop from="1" to="#ListLen(topic_choice_id)#" index="i">
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/CreateFormResponse.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="form_transaction_individual_id" TYPE="FormField" VALUE="#form_transaction_individual_id#">
		<CFHTTPPARAM NAME="form_question_choice_id" TYPE="FormField" VALUE="#ListGetAt(topic_choice_id,i)#">
	</CFHTTP>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<cfset status = getToken(cfhttp.filecontent, 1, ",")>
<cfif trim(status) EQ "SUCCESS">
	<cfset form_response_id = getToken(cfhttp.filecontent, 2, ",")>
<cfelse>
	<cfset returncode = trim(getToken(cfhttp.filecontent, 2, ","))>
	<cfset error = trim(getToken(cfhttp.filecontent, 3, ","))>
	<cf_error error="#error#" code="#returncode#" UI_page="news_retuser_action.cfm">
</cfif>

</cfloop>
</cfif>

<!--- Close form transaction --->
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/CloseFormTransaction.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="form_transaction_id" TYPE="FormField" VALUE="#form_transaction_id#">
	</CFHTTP>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<cfset status = getToken(cfhttp.filecontent, 1, ",")>
<cfif trim(status) NEQ "SUCCESS">
	<cfset returncode = trim(getToken(cfhttp.filecontent, 2, ","))>
	<cfset error = trim(getToken(cfhttp.filecontent, 3, ","))>
	<cf_error error="#error#" code="#returncode#" UI_page="news_retuser_action.cfm">
</cfif>

<!--- Disable unsubscribes --->
<cftry>
	<CFHTTP METHOD="POST" URL="#CRS_API_Path#/SetUnsubscribeStatus.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="organization_id" TYPE="FormField" VALUE="#organization_id#">
		<CFHTTPPARAM NAME="email" TYPE="FormField" VALUE="#rpg_email#">
		<CFHTTPPARAM NAME="status_id" TYPE="FormField" VALUE="0">
	</CFHTTP>

	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<cfset status = getToken(cfhttp.filecontent, 1, ",")>
<cfif trim(status) NEQ "SUCCESS">
	<cfset returncode = trim(getToken(cfhttp.filecontent, 2, ","))>
	<cfset error = trim(getToken(cfhttp.filecontent, 3, ","))>
	<cf_error error="#error#" code="#returncode#" UI_page="news_retuser_action.cfm">
</cfif>

<!---------------->
<!---------------->
<!--- Redirect --->
<!---------------->
<!---------------->

<CFIF form_question_choice_id IS NOT "">
	<cflocation url="nltr_subscribers_list.cfm?s=#securestring#&form_question_choice_id=#form_question_choice_id#&start_record=#start_record#&end_record=#end_record#" addtoken="No">
<CFELSEIF searchterm IS NOT "">
	<cflocation url="nltr_subscriber_search_action.cfm?s=#securestring#&searchterm=#searchterm#&start_record=#start_record#&end_record=#end_record#" addtoken="No">
<CFELSE>
	<cflocation url="nltr_subscribers.cfm?s=#securestring#" addtoken="No">
</CFIF>

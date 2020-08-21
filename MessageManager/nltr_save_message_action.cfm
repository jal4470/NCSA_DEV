<!--- --------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS UI Page		   			--->
<!------------------------------------->
<!---  Created:  10.10.2007 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 01.25.2008	--->
<!---  P.ROGERS						--->
<!---  topic_choice_str changed 	--->
<!---  to also support programs 	--->
<!---  calling new recipient    	--->
<!---  procedure					--->
<!---
MODIFICATIONS
2009-02-19, J. Oriente
- added "topic_choice_id_str" and "program_id_str" to create_message and update_message API calls. 
12/10/2009 P Waters
- Added processing of "Grades" checkboxes
- Added processing of "Exclude Waitlisted Flag" checkbox
12/15/2009 P WATERS
- Commented out validation to ensure that subject value is unique for organization
1/22/2010, J. Oriente
- added timeout of 10 minutes.									--->
<!------------------------------------->

<!--- 10 minute timeout. Added 1/22/2010 by J. Oriente. --->
<cfsetting requesttimeout="600">

 
 <!--- validate login --->
 <cfmodule template="../_checkLogin.cfm">
 
<!--- Set Application variables --->


<!--- Security --->

<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
	<cfset CRS_API_Path = application.mm_API_Path>
</cflock>
<!---<CFDUMP VAR="#FORM#"> <CFABORT>--->

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

<cfif isdefined("form.message_desc")>
	<cfset message_desc  = form.message_desc>
<cfelseif isdefined("url.message_desc")>
	<cfset message_desc = url.message_desc>
<cfelse>
	<cfset message_desc = "">	
</cfif>

<cfif isdefined("form.from_email_address")>
	<cfset from_email_address  = form.from_email_address>
<cfelseif isdefined("url.from_email_address")>
	<cfset from_email_address = url.from_email_address>
<cfelse>
	<cfset from_email_address = "">	
</cfif>

<cfif isdefined("form.from_email_alias")>
	<cfset from_email_alias  = form.from_email_alias>
<cfelseif isdefined("url.from_email_alias")>
	<cfset from_email_alias = url.from_email_alias>
<cfelse>
	<cfset from_email_alias = "">	
</cfif>

<cfif isdefined("form.replyto_email_address")>
	<cfset replyto_email_address  = form.replyto_email_address>
<cfelseif isdefined("url.replyto_email_address")>
	<cfset replyto_email_address = url.replyto_email_address>
<cfelse>
	<cfset replyto_email_address = "">	
</cfif>

<cfif isdefined("form.replyto_email_alias")>
	<cfset replyto_email_alias  = form.replyto_email_alias>
<cfelseif isdefined("url.replyto_email_alias")>
	<cfset replyto_email_alias = url.replyto_email_alias>
<cfelse>
	<cfset replyto_email_alias = "">	
</cfif>

<cfif isdefined("form.subject")>
	<cfset subject  = form.subject>
<cfelseif isdefined("url.subject")>
	<cfset subject = url.subject>
<cfelse>
	<cfset subject = "">	
</cfif>

<CFSET message_desc = subject>

<cfif isdefined("form.cc_emails")>
	<cfset cc_emails  = replace(form.cc_emails," ","","ALL")>
<cfelseif isdefined("url.cc_emails")>
	<cfset cc_emails = replace(url.cc_emails," ","","ALL")>
<cfelse>
	<cfset cc_emails = "">	
</cfif>

<cfif isdefined("form.bcc_emails")>
	<cfset bcc_emails  = replace(form.bcc_emails," ","","ALL")>
<cfelseif isdefined("url.bcc_emails")>
	<cfset bcc_emails = replace(url.bcc_emails," ","","ALL")>
<cfelse>
	<cfset bcc_emails = "">	
</cfif>

<cfif isdefined("form.html_copy")>
	<cfset html_copy  = form.html_copy>
<cfelseif isdefined("url.html_copy")>
	<cfset html_copy = url.html_copy>
<cfelse>
	<cfset html_copy = "">	
</cfif>

<cfif isdefined("form.text_copy")>
	<cfset text_copy  = form.text_copy>
<cfelseif isdefined("url.text_copy")>
	<cfset text_copy = url.text_copy>
<cfelse>
	<cfset text_copy = "">	
</cfif>

<cfif isdefined("form.track_opens_flag")>
	<cfset track_opens_flag  = form.track_opens_flag>
<cfelseif isdefined("url.track_opens_flag")>
	<cfset track_opens_flag = url.track_opens_flag>
<cfelse>
	<cfset track_opens_flag = 0>	
</cfif>

<cfif isdefined("form.exclude_waitlisted_flag")>
	<cfset exclude_waitlisted_flag  = form.exclude_waitlisted_flag>
<cfelseif isdefined("url.exclude_waitlisted_flag")>
	<cfset exclude_waitlisted_flag = url.exclude_waitlisted_flag>
<cfelse>
	<cfset exclude_waitlisted_flag = 0>	
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
<cfif not len(trim(EMAILTO))>
	<cfset error = error & "<li>Please Select Recipients</li>">
</cfif>
<cfif from_email_address EQ "">
	<cfset error = error & "<li>Please enter a From Email.</li>">
</cfif>

<cfif from_email_alias EQ "">
	<cfset error = error & "<li>Please enter From Alias.</li>">
</cfif>

<cfif subject EQ "">
	<cfset error = error & "<li>Please enter a Subject.</li>">
</cfif>

<cfif submit EQ "">
	<cfset error = error & "<li>There has been a technical error.</li>">
</cfif>

<cfif html_copy EQ "" AND text_copy EQ "">
	<cfset error = error & "<li>Please enter the Message Body.</li>">
</cfif>

<!--- Type conversion --->
<cfinclude template="UDF_isValidEmail.cfm">

<cfif NOT isValidEmail(from_email_address)>
	<cfset error = error & "<li>'#from_email_address#' is not a valid email address.</li>">
</cfif>

<CFIF replyto_email_address IS NOT "">
<cfif NOT isValidEmail(replyto_email_address)>
	<cfset error = error & "<li>'#replyto_email_address#' is not a valid email address.</li>">
</cfif>
</CFIF>

<cfif cc_emails NEQ "">
	<cfloop from="1" to="#ListLen(cc_emails,';')#" index="i">
		<cfset curr_email = Trim(ListGetAt(cc_emails,i,';'))>
		<cfif NOT isValidEmail(curr_email)>
			<cfset error = error & "<li>'#curr_email#' is not a valid email address.</li>">
		</cfif>
	</cfloop>
</cfif>

<cfif bcc_emails NEQ "">
	<cfloop from="1" to="#ListLen(bcc_emails,';')#" index="i">
		<cfset curr_email = Trim(ListGetAt(bcc_emails,i,';'))>
		<cfif NOT isValidEmail(curr_email)>
			<cfset error = error & "<li>'#curr_email#' is not a valid email address.</li>">
		</cfif>
	</cfloop>
</cfif>


 
<!---------------------------->
<!--- GET VALID PER CODES  --->
<!---------------------------->

<CFTRY>
	<CFINVOKE component="#CRS_API_Path#GetMessage" method="GetPerFields" returnvariable="perfields">
		<cfinvokeargument name="message_id" value="#message_id#">
	</CFINVOKE>
	<CFCATCH type="any">
		<cfdump var="#cfcatch#"><cfabort>		
	</CFCATCH>			
</CFTRY>

<CFSET validcodes = "">
<CFLOOP QUERY="perfields">
	<CFSET validcodes = validcodes & code & ",">
</CFLOOP>


<!---------------------------->
<!--- VALIDATE PER CODES  --->
<!---------------------------->


<CFIF html_copy IS NOT "">
	<CFSET perstring = "">
	<CFSET curindex = "0">
		<CFSET curblock = REFind("{![A-Z]+}", "#html_copy#",1,1)>
		<CFIF curblock.pos[1] GT 0>
		<CFSET curindex = "1">
			<CFLOOP CONDITION="#curindex# GT 0">
				<CFSET curblock=REFind("{![A-Z]+}", "#html_copy#",curindex,1)>
				<CFSET curindex = curblock.pos[1]>
				<CFSET curlen = curblock.len[1]>
				<CFIF curindex GT 0>
					<CFSET leftstart = curindex>
					<CFSET rightend = curlen>
					<CFSET curcode = Mid(html_copy,leftstart,rightend)>
					<CFIF LISTFIND(validcodes,curcode) EQ 0>
						<cf_error error="#curcode# is not a valid personalization code.">
					</CFIF>
					<CFIF perstring IS NOT "">
						<CFSET perstring = perstring & "," & "#Mid(html_copy,leftstart,rightend)#">
					<CFELSE>
						<CFSET perstring = "#Mid(html_copy,leftstart,rightend)#">
					</CFIF>
					<CFSET curindex = curindex + curlen + 1>
				<CFELSE>
					<CFSET curindex = "0">
				</CFIF>
			</CFLOOP>		
		</CFIF>
</CFIF>


<!-------------------------------------------->
<!--- CHECK FOR SPECIAL CHARACTERS IN COPY --->
<!-------------------------------------------->

<CFSET text_copy = html_copy>



<CFSET cntindex = "1">
<CFSET opcnt = 0>
<CFLOOP CONDITION="#cntindex# GT 0">
	<CFSET cntblock=Find("&lt;","#text_copy#",cntindex)>
	<CFIF cntblock GTE cntindex>
		<CFSET opcnt = opcnt + 1>
		<CFSET cntindex = cntblock + 1>
	<CFELSE>
		<CFSET cntindex = "0">
	</CFIF>
</CFLOOP>

<CFSET cntindex = "1">
<CFSET clcnt = 0>
<CFLOOP CONDITION="#cntindex# GT 0">
	<CFSET cntblock=Find("&gt;", "#text_copy#",cntindex)>
	<CFIF cntblock GTE cntindex>
		<CFSET clcnt = clcnt + 1>
		<CFSET cntindex = cntblock + 1>
	<CFELSE>
		<CFSET cntindex = "0">
	</CFIF>
</CFLOOP>	

<CFIF opcnt NEQ clcnt>
	<cf_error error="Your message cannot contain < or >.">
</CFIF>

<!--------------------->
<!--- Return errors --->
<!--------------------->
<cfif error NEQ "">
	<cf_error error="Please fix the following errors:<ul>#error#</ul>">
</cfif>


<!----------------------------------------->
<!--- REPLACE P TAGS WITH CHAR10 AND 13 --->
<!----------------------------------------->

<!--- \r\n --->

<CFSET carreturn = chr(13) & chr(10)>


<CFSET text_copy = "#replace(text_copy,"<p>",carreturn,"ALL")#">
<CFSET text_copy = "#replace(text_copy,"</p>",carreturn,"ALL")#">



<!----------------------->
<!--- PARSE TEXT COPY --->
<!----------------------->

<CFIF text_copy IS NOT "">
	<CFSET cutstring = "">
	<CFSET curindex = "0">
		<CFSET curblock = Find("<", "#text_copy#",1)>
		<CFIF curblock GT 0>
		<CFSET curindex = "1">
			<CFLOOP CONDITION="#curindex# GT 0">
				<CFSET curblock=Find("<", "#text_copy#",curindex)>
				<CFSET curindex = curblock>
				<CFSET curblockend=Find(">", "#text_copy#",curindex)>
				<CFIF curindex GT 0 AND curblockend GT 0>
					<CFSET leftstart = curindex>
					<CFSET rightend = (curblockend - leftstart) + 1>
					<CFSET cutstring = "#Mid(text_copy,leftstart,rightend)#">
					<CFSET text_copy = "#replace(text_copy,cutstring,"","ALL")#">
					<CFSET curindex = leftstart>
				<CFELSE>
					<CFSET curindex = "0">
				</CFIF>
			</CFLOOP>		
		</CFIF>
</CFIF>



<!-------------->
<!-------------->
<!--- determine direction --->
<!-------------->
<!-------------->

<CFIF submit IS "Save Draft">
	<CFSET next_page="index.cfm">
<CFELSEIF submit IS "Send">
	<CFSET next_page="nltr_message_confirm.cfm">
<CFELSE>
	<CFSET next_page="index.cfm">
</CFIF>


<!------------------------>
<!--- Determine action --->
<!------------------------>
<cfif message_id EQ "">
	<cfset action="add">
<cfelse>
	<cfset action="edit">
</cfif>

<!----------->
<!--- Add --->
<!----------->

<cfif action EQ "add">


	<cftry>
	<CFSTOREDPROC datasource="#dsn#" procedure="p_create_message" returncode="YES" >
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#message_desc#" DBVARNAME="@message_desc">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#from_email_address#" DBVARNAME="@from_email_address">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#from_email_alias#" DBVARNAME="@from_email_alias">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#replyto_email_address#" DBVARNAME="@replyto_email_address" NULL="#YesNoFormat(replyto_email_address EQ '')#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#replyto_email_alias#" DBVARNAME="@replyto_email_alias" NULL="#YesNoFormat(replyto_email_alias EQ '')#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#subject#" DBVARNAME="@subject">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#cc_emails#" DBVARNAME="@cc_emails" NULL="#YesNoFormat(cc_emails EQ '')#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#bcc_emails#" DBVARNAME="@bcc_emails" NULL="#YesNoFormat(bcc_emails EQ '')#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#html_copy#" DBVARNAME="@html_copy" NULL="#YesNoFormat(html_copy EQ '')#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#text_copy#" DBVARNAME="@text_copy" NULL="#YesNoFormat(text_copy EQ '')#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="#track_opens_flag#" DBVARNAME="@track_opens_flag">
		<cfprocparam type="IN" cfsqltype="CF_SQL_BIT" VALUE="1" DBVARNAME="@created_via_message_manager_flag">
		<CFPROCPARAM TYPE="OUT" CFSQLTYPE="CF_SQL_INTEGER" VARIABLE="message_id" DBVARNAME="@message_id">
	</CFSTOREDPROC>
	<cfset message_id = message_id>
	<cfcatch>
		<cfoutput>ERROR,#cfcatch.message#: #cfcatch.detail#</cfoutput><cfabort>
	</cfcatch>
</cftry>

</cfif>


<!------------>
<!--- Edit --->
<!------------>
<cfif action EQ "edit">
		
	<cftry>
	<cfif isdefined("exclude_waitlisted_flag")>
		<cfset exclude_waitlisted_flag = exclude_waitlisted_flag>
	<cfelse>
		<cfset exclude_waitlisted_flag = "0">
	</cfif>

	<CFSTOREDPROC datasource="#dsn#" procedure="p_update_message" returncode="YES" >
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#message_id#" DBVARNAME="@message_id">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#message_desc#" DBVARNAME="@message_desc">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#from_email_address#" DBVARNAME="@from_email_address">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#from_email_alias#" DBVARNAME="@from_email_alias">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#replyto_email_address#" DBVARNAME="@replyto_email_address" NULL="#YesNoFormat(replyto_email_address EQ '')#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#replyto_email_alias#" DBVARNAME="@replyto_email_alias" NULL="#YesNoFormat(replyto_email_alias EQ '')#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#subject#" DBVARNAME="@subject">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#cc_emails#" DBVARNAME="@cc_emails" NULL="#YesNoFormat(cc_emails EQ '')#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#bcc_emails#" DBVARNAME="@bcc_emails" NULL="#YesNoFormat(bcc_emails EQ '')#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#html_copy#" DBVARNAME="@html_copy" NULL="#YesNoFormat(html_copy EQ '')#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#text_copy#" DBVARNAME="@text_copy" NULL="#YesNoFormat(text_copy EQ '')#">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="#track_opens_flag#" DBVARNAME="@track_opens_flag">
	</CFSTOREDPROC>
 	<cfcatch>
		<cfoutput>ERROR,#cfcatch.message#: #cfcatch.detail#</cfoutput><cfabort>
	</cfcatch>
</cftry>

		
		

</cfif>
	<cftransaction>
	<cfstoredproc datasource="#dsn#" procedure="p_delete_message_contacts">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#message_id#">
	</cfstoredproc>
	<cfloop list="#form.contact#" index="i">
		<cfstoredproc datasource="#dsn#" procedure="p_insert_message_contact">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#message_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#i#">
		</cfstoredproc>  
	</cfloop>
	<cfstoredproc datasource="#dsn#" procedure="p_create_message_recipients">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#message_id#">
	</cfstoredproc>
	</cftransaction>
<!---------------->
<!--- Redirect --->
<!---------------->
<cflocation url="#next_page#?message_id=#message_id#" addtoken="no">

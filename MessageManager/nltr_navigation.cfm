
 
 <!--- validate login --->
 <cfmodule template="../_checkLogin.cfm">
 
<cfif isdefined("attributes.location")>
	<cfset location = attributes.location>
<cfelse>
	<cf_error error="Cannot determine location. Please report this error to the site administrator immediately.">
</cfif>


<!----------------------->
<!--- GET DATA		  --->
<!----------------------->

<CFTRY>
	<CFINVOKE component="#application.mm_api_path #getMessage" method="GetSentMessages"  clubid="#session.user.clubid#" returnvariable="getsent">
	</CFINVOKE>
	<CFCATCH type="any">
		<cfdump var="#cfcatch#" abort="true">	
	</CFCATCH>			
</CFTRY>

<CFTRY>
	<CFINVOKE component="#application.mm_api_path#getMessage" method="GetDraftMessages" contactid="#session.user.contactid#" returnvariable="getdrafts">
	</CFINVOKE>
	<CFCATCH type="any">
				<cfdump var="#cfcatch#" abort="true">		
	</CFCATCH>			
</CFTRY>

<CFTRY>
	<CFINVOKE component="#application.mm_api_path#getMessage" method="GetScheduledMessages"  contactid="#session.user.contactid#" returnvariable="getscheduled">
	</CFINVOKE>
	<CFCATCH type="any">
				<cfdump var="#cfcatch#" abort="true">			
	</CFCATCH>			
</CFTRY>

<table cellpadding="3" border="0" cellspacing="0" width="148">
	<CFOUTPUT>
	<CFIF location IS "newmessage">
	
	<tr>
		<td class="emailnavtopleftact"><img src="assets/icons/newmes.gif" alt="" width="21" height="17" border="0"></td>
		<td class="emailnavtoprightact"  onclick="location.href='Step1.cfm'">New</td>
	</tr>
	<tr>
		<td class="emailnavbotleft"><img src="assets/icons/draft2.gif" alt="" width="21" height="17" border="0"></td>
		<td class="emailnavbotright" onclick="location.href='index.cfm'">Drafts (#getdrafts.recordcount#)</td>
	</tr>
	<tr>
		<td class="emailnavbotleft"><img src="assets/icons/sent2.gif" alt="" width="21" height="17" border="0"></td>
		<td class="emailnavbotright" onclick="location.href='nltr_view_sent.cfm'">Sent (#getsent.recordcount#)</td>
	</tr>
	<tr>
		<td height="3" colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
	</tr>
	
	<CFELSEIF location IS "drafts">
	
	<tr>
		<td class="emailnavtopleftact"><img src="assets/icons/draft2.gif" alt="" width="21" height="17" border="0"></td>
		<td class="emailnavtoprightact">Drafts (#getdrafts.recordcount#)</td>
	</tr>
	<tr>
		<td class="emailnavbotleft"><img src="assets/icons/sent2.gif" alt="" width="21" height="17" border="0"></td>
		<td class="emailnavbotright" onclick="location.href='nltr_view_sent.cfm'">Sent (#getsent.recordcount#)</td>
	</tr>
	<tr>
		<td height="3" colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
	</tr>


	<CFELSEIF location IS "sent">
	
	<tr>
		<td class="emailnavtopleft"><img src="assets/icons/draft2.gif" alt="" width="21" height="17" border="0"></td>
		<td class="emailnavtopright" onclick="location.href='index.cfm'">Drafts (#getdrafts.recordcount#)</td>
	</tr>
	<tr>
		<td class="emailnavbotleftact"><img src="assets/icons/sent2.gif" alt="" width="21" height="17" border="0"></td>
		<td class="emailnavbotrightact">Sent (#getsent.recordcount#)</td>
	</tr>
	<tr>
		<td height="3" colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
	</tr>
	
	<CFELSEIF location IS "scheduled">
	
	<tr>
		<td class="emailnavtopleft"><img src="assets/icons/draft2.gif" alt="" width="21" height="17" border="0"></td>
		<td class="emailnavtopright" onclick="location.href='index.cfm'">Drafts (#getdrafts.recordcount#)</td>
	</tr>
	<tr>
		<td class="emailnavbotleft"><img src="assets/icons/sent2.gif" alt="" width="21" height="17" border="0"></td>
		<td class="emailnavbotright" onclick="location.href='nltr_view_sent.cfm'">Sent (#getsent.recordcount#)</td>
	</tr>
	<tr>
		<td height="3" colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
	</tr>


	
	<CFELSE>
	
	<tr>
		<td class="emailnavtopleftact"><img src="assets/icons/newmes.gif" alt="" width="21" height="17" border="0"></td>
		<td class="emailnavtoprightact" onclick="location.href='Step1.cfm'">New</td>
	</tr>
	<tr>
		<td class="emailnavbotleft"><img src="assets/icons/draft2.gif" alt="" width="21" height="17" border="0"></td>
		<td class="emailnavbotright" onclick="location.href='index.cfm'">Drafts (#getdrafts.recordcount#)</td>
	</tr>
	<tr>
		<td class="emailnavbotleft"><img src="assets/icons/sent2.gif" alt="" width="21" height="17" border="0"></td>
		<td class="emailnavbotright" onclick="location.href='nltr_view_sent.cfm'">Sent (#getsent.recordcount#)</td>
	</tr>
	<tr>
		<td height="3" colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
	</tr>
	</CFIF>
	</CFOUTPUT>
</table>
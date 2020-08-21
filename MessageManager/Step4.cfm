<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   		--->
<!------------------------------------->
<!---  Created:  10.24.2006 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 10.26.2006	
1/15/2009 -- J.Lechuga increase timeout to handle large batches
8/18/2010 - J.Lechuga revamped to display summary added light box to display recipients.
--->
<!------------------------------------->
<cfsetting requesttimeout="600">

 <cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock>
 <!--- validate login --->
 <cfmodule template="../_checkLogin.cfm">
 
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
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


<cfset email_to_string = "">
<cfset email_to_id_string = "">
<cfset email_coded_id_string = "">

<cfif isdefined("session.user.contactid")>
	<cfquery name="getDefaultTestUser" datasource="#application.dsn#">
		select email from tbl_contact where contact_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user.contactid#">
	</cfquery>
	<cfset default_test_email = getDefaultTestUser.email>
<cfelse>
	<cfset default_test_email = "">
</cfif>

<!---------------->
<!--- Get data --->
<!---------------->
<cftry>
		<cfquery name="getMessage" datasource="#dsn#">
		SELECT MESSAGE_DESC,
		       FROM_EMAIL_ADDRESS,
		       FROM_EMAIL_ALIAS,
		       REPLYTO_EMAIL_ADDRESS,
		       REPLYTO_EMAIL_ALIAS,
		       SUBJECT,
		       CC_EMAILS,
		       BCC_EMAILS,
		       HTML_COPY,
			   REPORT_ID
		  FROM V_MESSAGE
		 WHERE MESSAGE_ID = <CFQUERYPARAM VALUE="#MESSAGE_ID#">
		 </cfquery>
		 <cfquery name="getDistributionList" datasource="#reports_dsn#">
		    select distribution_list_name from tbl_distribution_list d  inner join tbl_report r on d.distribution_list_id = r.distribution_list_id
			where report_id = <CFQUERYPARAM VALUE="#getMessage.report_id#"> 
		 </cfquery>
		
		<cfset message_desc = getMessage.message_desc>
		<cfset from_email_address = getMessage.from_email_address>
		<cfset from_email_alias = getMessage.from_email_alias>
		<cfset replyto_email_address = getMessage.replyto_email_address>
		<cfset replyto_email_alias = getMessage.replyto_email_alias>
		<cfset subject = getMessage.subject>
		<cfset cc_emails = getMessage.cc_emails>
		<cfset bcc_emails = getMessage.bcc_emails>
		<cfset html_copy = getMessage.html_copy>

	<cfcatch>
		<cfdump var="#cfcatch#"><cfabort>
	</cfcatch>
</cftry>
<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" method="getSeedGroups" clubid="#SESSION.USER.CLUBID#" returnvariable="SeedGroups">
</cfinvoke>

<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" method="getSeeds" clubid="#SESSION.USER.CLUBID#" returnvariable="Seeds">
</cfinvoke>

<cftry>
	<CFSTOREDPROC datasource="#dsn#" procedure="p_get_nltr_edition_add_step3" returncode="YES">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#message_id#" DBVARNAME="@message_id">
	</CFSTOREDPROC>
	<cfcatch>
		<cfoutput>#cfcatch.message#: #cfcatch.detail#</cfoutput><cfabort>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>	

<!--- <cfquery name="getRecipientCnt" datasource="#dsn#">
select count(*) as recipient_cnt 
from tbl_message_recipient 
where message_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#message_id#">
</cfquery> --->

<cfquery name="getRecipients" datasource="#dsn#">
select c.username, c.email, c.firstName, c.LastName, case when seed_flag = 1 then 'Seed' else 'Contact' end as seed_type 
from tbl_message_recipient mr inner join tbl_contact c on c.contact_id = mr.contact_id
where mr.message_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#message_id#">
</cfquery>
<cfquery name="getSeeds" dbtype="query">
	select * from getRecipients where seed_type = 'Seed'
</cfquery>
<cfquery name="getContact" dbtype="query">
	select * from getRecipients where seed_type = 'Contact'
</cfquery>
<!--- <cfdump var="#getRecipients#"> --->
<CFSET toString = "">
<!--- <cfloop query="getRecipients">
<CFSET toString = toString & email>
</cfloop> --->

<!----------------->
<!--- Page body --->
<!----------------->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>

	<link rel="stylesheet" type="text/css" href="style.css" media="print,screen">
 	<link  href="_newsletter_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<link  href="_tooltip_style.css" type="text/css" media="print,screen" rel="stylesheet" > 
	<link  href="../ReportBuilder/_rptBldr_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<style>
		#lightbox {  
			display: none;
			position: absolute;
			top: 0%;
			left: 0%;
			width: 1000;
			height: 1000;
			background-color: black;
			z-index:1001;
			-moz-opacity: 0.6;
			opacity:.60;
			filter: alpha(opacity=60);
		 }  
		 /* Lightbox panel with some content */  
		#lightbox-panel {  
			display: none;
			position: absolute;
			top: 5%;
			left: 10%;
			width: 600px;
			height: 400px;
			padding: 16px;
			border: 5px solid silver;
			background-color: white;
			z-index:1002;
			overflow: auto;

		 }  
		 #lightbox1 {  
		display: none;
			position: absolute;
			top: 0%;
			left: 0%;
			width: 1000;
			height: 1000;
			background-color: black;
			z-index:1001;
			-moz-opacity: 0.6;
			opacity:.60;
			filter: alpha(opacity=60);
		 }  
		 /* Lightbox panel with some content */  
		#lightbox-panel1 {  
			display: none;
			position: absolute;
			top: 5%;
			left: 10%;
			width: 600px;
			height: 400px;
			padding: 16px;
			border: 5px solid silver;
			background-color: white;
			z-index:1002;
			overflow: auto;
		 }  
		 .msgBody{
		 border:1px black solid;
		 height:400px;
		 width:100%;
		 padding-left:10px;
		 background:white;
		 overflow:auto;
		 }
	</style>
	<script language="JavaScript" type="text/javascript" src="../ReportBuilder/assets/jquery-1.3.2.min.js"></script>

	 <script type="text/javascript">  
		  $(document).ready(function(){  
		 $("a#show-panel").click(function(){  
		 $("#lightbox, #lightbox-panel").fadeIn(300);  
		  })  
		 $("a#close-panel").click(function(){  
		  $("#lightbox, #lightbox-panel").fadeOut(300);  
		  })  
		  $("a#show-panel1").click(function(){  
		 $("#lightbox1, #lightbox-panel1").fadeIn(300);  
		  })  
		 $("a#close-panel1").click(function(){  
		  $("#lightbox1, #lightbox-panel1").fadeOut(300);  
		  })  
		  })  
	 </script>  
</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">
<cfhtmlhead text="<title>Message Manager Step 4</title>">
<CFINCLUDE TEMPLATE="assets/js/tooltip.js">

<!--- Header --->
<CFINCLUDE TEMPLATE="header_nltr.cfm">

<!--- BODY --->
<cfset stepnum=4>
<cfinclude template="tpl_rptBldr_head.cfm">
<table border="0" cellspacing="0" cellpadding="2" width="100%">
	<cfif isdefined("url.msg")><tr><td colspan="2" class="emailpropbar" ><cfoutput><strong>#url.msg#</strong></cfoutput></td></tr></cfif>
	<tr>
	<!--- 	<td style="padding-left: 15px; padding-top: 10px;" valign="top" width="150">
		
		<!--- LEFT NAVIGATION <CF_nltr_navigation location="newmessage">--->
		
		
		</td> --->
		<td style="padding-top:0px;padding-right: 10px;" valign="top">
		<table border="0" cellspacing="0" cellpadding="0" width="100%">

			<tr>
				<td class="emailpropbar" valign="top">
				
				<CFOUTPUT>
				<div id="mydiv1" style="display:block;padding:0px;margin:2px;width:100%;">
				<table border="0" cellspacing="2" cellpadding="3" width="100%">
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
					</tr>
					<tr>
						<td class="emailproplabel">From Email:</td>
						<td class="emailpropitem">#from_email_address#</td>
					</tr>
					<tr>
						<td class="emailproplabel">From Name:</td>
						<td class="emailpropitem">#from_email_alias#</td>
					</tr>
					<tr>
						<td class="emailproplabel">Subject:</td>
						<td class="emailpropitem" align="left">#subject#</td>
					</tr>
					<tr>
						<td class="emailtolabel" valign="top" width="150">Recipients:</td>
						<td class="emailpropitem" align="left" width="90%">
							<a  id="show-panel" href="##">(<cfoutput>#getContact.recordcount#</cfoutput>)Contact(s)</a>
							<cfif getSeeds.recordcount>
								&nbsp;<a  id="show-panel1" href="##">(<cfoutput>#getSeeds.recordcount#</cfoutput>)Seed(s)</a>
							</cfif>
							<div id="lightbox-panel">
							<h2>Contacts</h2>
							<p>
								<table cellpadding="2" border="1" cellspacing="0">
									<tr>
										<td><strong>User Name</strong></td>
										<td><strong>Email</strong></td>
										<td><strong>First Name</strong></td>
										<td><strong>Last Name</strong></td>
										<td><strong>Recipient Type</strong></td>
									</tr>
									<cfloop query="getContact">		
									<cfoutput>
									<tr>
										<td>#USERNAME#</td>
										<td>#EMAIL#</td>
										<td>#FIRSTNAME#</td>
										<td>#LASTNAME#</td>
										<td>#SEED_TYPE#</td>
									</tr>
									</cfoutput>
									</cfloop>
									</table>
									</p>
									<p align="center">
										<a id="close-panel" href="##">Close this window</a>
									</p>
								</div><!-- /lightbox-panel -->
								<div id="lightbox"> </div><!-- /lightbox -->
														
						<div id="lightbox-panel1">
							<h2>Seeds</h2>
							<p>
								<table cellpadding="2" border="1" cellspacing="0">
									<tr>
										<td><strong>User Name</strong></td>
										<td><strong>Email</strong></td>
										<td><strong>First Name</strong></td>
										<td><strong>Last Name</strong></td>
										<td><strong>Recipient Type</strong></td>
									</tr>
									<cfloop query="getSeeds">		
									<cfoutput>
									<tr>
										<td>#USERNAME#</td>
										<td>#EMAIL#</td>
										<td>#FIRSTNAME#</td>
										<td>#LASTNAME#</td>
										<td>#SEED_TYPE#</td>
									</tr>
									</cfoutput>
									</cfloop>
									</table>
									</p>
									<p align="center">
										<a id="close-panel1" href="##">Close this window</a>
									</p>
							</div><!-- /lightbox-panel -->
							<div id="lightbox1"> </div><!-- /lightbox -->
							
						</td>
					</tr>
					<tr>
						<td class="emailtolabel" valign="top" width="150">Distribution List:</td>
						<td class="emailpropitem" align="left" width="90%">
							<cfoutput>#getDistributionList.distribution_list_name#</cfoutput>
						</td>
					</tr>
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
					</tr>
				</table>
				</div>
				
				
				<div id="bottom" style="display:block;padding:0px;margin:2px;width:100%;">
				<table border="0" cellspacing="2" cellpadding="2" width="100%">
					<tr>
						<td class="emailpropitem" colspan="2"><div class="msgBody">#html_copy#</div></td>
					</tr>
					<tr>
						<td class="emailpropitem" colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="15" border="0"></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td style="padding-left:400px;">					
							<form method="post" action="Step4_DefineTestSeeds.cfm">	
								<input type="hidden" name="message_id" value="<cfoutput>#message_id#</cfoutput>">
						`		<input type="submit" value="Send Test Message" class="itemformbuttonleft">
							</form>
						</td>
					</tr>
				</table>
				</div>
				</CFOUTPUT>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>

		<form method="post" action="Step4_DefineLaunchSeeds.cfm">	
			<input type="hidden" name="message_id" value="<cfoutput>#message_id#</cfoutput>">
			<cfinclude template="tpl_rptBldr_foot.cfm">
		</form>
<!--- END BODY --->


</form>
</body>
</html>

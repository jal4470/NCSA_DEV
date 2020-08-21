
  <!---------  <cffile action="append" file="E:\Inetpub\securewwwroot\products\communitypass\log\#logFileName#" output="Newsletter	#CFEvent.Data.message_id#	Begin Transaction	#DateFormat(now(), "MM/DD/YYYY")# - #TimeFormat(now(), "HH:mm ss")#	0" addnewline="yes" />


-------------------------------->
<!--- GET MESSAGE METADATA				--->
<!----------------------------------------->

   
<cftry>

	<cfstoredproc  datasource="#application.dsn#" procedure="P_INSERT_MESSAGE_GATEWAY_LOG">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@Message_id" value="#message_id#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Component" value="Newsletter">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Description" value="Begin Transaction">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Error_Code" value="0">
	</cfstoredproc>

	   <cfquery name="GetMessageInfo" datasource="#application.dsn#">
		select a.message_id,
			   a.message_desc,
			   a.from_email_address,
			   a.from_email_alias,
			   a.replyto_email_address,
			   a.replyto_email_alias,
			   a.subject,
			   a.cc_emails,
			   a.bcc_emails,
			   cast(a.html_copy as varchar(max)) html_copy,
			   cast(a.text_copy as varchar(max)) text_copy,
			   a.scheduled_date,
			   a.sent_date,
			   a.confirmed_date,
			   a.track_opens_flag,
			   a.datecreated,
			   a.dateupdated,
			   a.status_id,
			   c.FirstName,
			   c.LastName,
			   mr.email
		  from v_message a inner join tbl_message_recipient mr with(nolock) on a.message_id = mr.message_id
		  inner join tbl_contact c with(nolock) on c.contact_id = mr.contact_id
		 where a.message_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#message_id#">
		 group by 
			    a.message_id,
			   a.message_desc,
			   a.from_email_address,
			   a.from_email_alias,
			   a.replyto_email_address,
			   a.replyto_email_alias,
			   a.subject,
			   a.cc_emails,
			   a.bcc_emails,
			   cast(a.html_copy as varchar(max)),
			   cast(a.text_copy as varchar(max)),
			   a.scheduled_date,
			   a.sent_date,
			   a.confirmed_date,
			   a.track_opens_flag,
			   a.datecreated,
			   a.dateupdated,
			   a.status_id,
			   c.FirstName,
			   c.LastName,
			   mr.email
	</cfquery>

	<cfmail to="#GetMessageInfo.email#"
		from="NCSA INFO <info@ncsanj.com>"
		replyto="#GetMessageInfo.replyto_email_address#"
		subject="#GetMessageInfo.subject#"
		type="HTML"
		query="GetMessageInfo">
		#replace(replace(replace(GetMessageInfo.html_copy,'{!EMAILADDRESS}',GetMessageInfo.email,'All'),'{!FNAME}',GetMessageInfo.FirstName,'All'),'{!LNAME}',GetMessageInfo.LastName,'All')#
	</cfmail>
	<CFSTOREDPROC datasource="#dsn#" procedure="p_set_message_sent_date" returncode="YES">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#message_id#" DBVARNAME="@message_id">
	</CFSTOREDPROC>

	<cfcatch type="any">
		<cfstoredproc  datasource="#application.dsn#" procedure="P_INSERT_MESSAGE_GATEWAY_LOG">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@Message_id" value="#message_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Component" value="Newsletter">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Description" value="Error on message data #CFCATCH.Detail#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Error_Code" value="1">
		</cfstoredproc>
		<cfinclude template="app_error_exception.cfm">
		<cfinclude template="errorPage.cfm">
	  </cfcatch>
</cftry>


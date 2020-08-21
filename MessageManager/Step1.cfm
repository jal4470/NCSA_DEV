<cfset reports_dsn = application.reports_dsn>
 <!--- validate login --->
 <cfmodule template="../_checkLogin.cfm">
<!----------------------->
<!--- Local variables --->
<!----------------------->
<cfset report_type_id = "">
<cfset context_id = "0">
<cfset context_value="">
<cfset subject = "">
<cfset from_email_address = "">
<cfset from_email_alias = "">
<cfset distribution_list_id = "">
<cfif isdefined("url.report_id")>
	<cfset report_id = url.report_id>

<cfelseif isdefined("form.report_id")>
	<cfset report_id = form.report_id>
<cfelse>
	<cfset report_id = "">
</cfif>
<cfif isdefined("url.message_id")>
	<cfset message_id = url.message_id>
<cfelse>
	<cfset message_id = "">
</cfif>
<cfquery name="getContact" datasource="#application.dsn#">
Select email as from_email_address, firstName + ' ' + lastName as from_email_alias from tbl_contact
where contact_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user.contactid#">
</cfquery>
<cfif getContact.recordcount>
		<cfset from_email_address = getContact.from_email_address>
	<cfset from_email_alias = getContact.from_email_alias>

</cfif>

<cfquery name="getMessageData" datasource="#application.dsn#">
		select distinct subject, from_email_address,from_email_alias,r.distribution_list_id,m.report_id, m.message_id
		from tbl_message m inner join  ncsa_reports..tbl_report r on m.report_id = r.report_id
		where m.report_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#iif(not len(trim(report_id)),de(0),de(report_id))#">
		or  m.message_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#iif(not len(trim(message_id)),de(0),de(message_id))#">
</cfquery>
<cfif getMessageData.recordcount>
	<cfset distribution_list_id = getMessageData.distribution_list_id>
	<cfset context_id = "0">
	<cfset context_value="">
	<cfset subject = getMessageData.subject>
	<cfif not len(trim(from_email_address))>
		<cfset from_email_address =getMessageData.from_email_address>
	</cfif>
	<cfif not len(trim(from_email_alias))>
		<cfset from_email_alias =getMessageData.from_email_alias>
	</cfif>
	
	<cfif len(trim(getMessageData.report_id))>
		<cfset report_id = getMessageData.report_id>
	</cfif>
	<cfif len(trim(getMessageData.message_id))>
		<cfset report_id = getMessageData.report_id>
	</cfif>
</cfif>
 
<!---------------->
<!--- Get data --->
<!---------------->
<cftry>
<!--- 	<cfquery datasource="#reports_dsn#" name="getReportTypes">
	  select distinct rt.report_type_id, rt.report_type_name
	  from tbl_view v inner join xref_report_type_view xrtv on v.view_id = xrtv.view_id inner join tbl_report_type rt on rt.report_type_id = xrtv.report_type_id
inner join ncsa2..xref_report_type_role rtr on rtr.report_type_id = xrtv.report_type_id
where exists (select 1 from ncsa2..xref_contact_role where role_id = rtr.role_id and contact_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user.contactid#">)
	</cfquery> --->
		<cfquery datasource="#reports_dsn#" name="getDistributionLists">
			select distinct distribution_list_id, distribution_list_name, allow_edits,dl.report_type_id
			from tbl_distribution_list dl inner join ncsa2..xref_report_type_role rtr on rtr.report_type_id = dl.report_type_id
where exists (select 1 from ncsa2..xref_contact_role where role_id = rtr.role_id and contact_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user.contactid#">)
		</cfquery>
		<cfif not len(trim(from_email_address)) or not len(trim("from_email_alias"))>
        <cfquery name="getDefaults" datasource="#application.dsn#">
		select _name, _value from tbl_global_vars where
		_name in ('from_email_address','from_email_alias')
		</cfquery>
			<cfloop query="getDefaults">
				<cfset "#_name#" = _value>
			</cfloop>
		</cfif>
		
		

	<cfcatch><cfdump var=#cfcatch#><cfabort>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<!----------------->
<!--- Page body --->
<!----------------->
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<link  href="../ReportBuilder/_rptBldr_style.css" type="text/css" media="print,screen" rel="stylesheet" >

</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">
<!--- <CFINCLUDE TEMPLATE="assets/js/tooltip.js"> --->
<cfhtmlhead text="<title>Message Manager Step 1</title>">
<CFINCLUDE TEMPLATE="header_nltr.cfm"> 
<cfoutput>
<!--- Declare form --->
<form method="post" action="step1_action.cfm">
<input type="hidden" name="report_Id" value="#report_id#">
<input type="hidden" name="contactid" value="#session.user.contactid#">
<input type="hidden" name="clubid" value="#session.user.clubid#">
<cfset stepnum=1>
<cfinclude template="tpl_rptBldr_head.cfm">

<div style="height: 15px; width: auto;"> </div>


<table border="0" cellspacing="0" cellpadding="4" width="100%">
	<tr><td colspan="2">To get started, complete the form below.</td></tr>
	<tr>	
		<td class="aeformlabel" width="200" valign="top">Subject:</td>
		<td class="aeformfield">
		<input type="text" id="subject" name="subject" value="#subject#">
		</td>
    </tr>
	<tr>	
		<td class="aeformlabel" width="200" valign="top">Replyto Email:</td>
		<td class="aeformfield">
		<input type="from_email" id="from_email" name="from_email" value="#from_email_address#">
		</td>
    </tr>
	<tr>	
		<td class="aeformlabel" width="200" valign="top">Replyto Name:</td>
		<td class="aeformfield">
		<input type="from_name" id="from_name" name="from_name" value="#from_email_alias#">
		</td>
    </tr>
	<cfif getDistributionLists.recordcount gt 1><tr><td colspan="2">Select a view from which to build your list of recipients</td></tr></cfif>
	<tr>
		<td class="aeformlabel" width="200" valign="top">View:</td>
		<td class="aeformfield">
		<cfif getDistributionLists.recordcount eq 1>
			#getDistributionLists.distribution_list_name#
		 	<input type="hidden" name="report_type_id" value="#getDistributionLists.distribution_list_id#">
		<cfelse>
			<select name="distribution_list_id" >
			<option value="">-- Select Distribution List --</option>
			<cfloop query="getDistributionLists">
				<option value="#distribution_list_id#"  <cfif getDistributionLists.distribution_list_id EQ variables.distribution_list_id> SELECTED</cfif>>#distribution_list_name#</option>
			</cfloop>
			</select>
		</cfif>
		</td>
	</tr>

	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
<cfinclude template="tpl_rptBldr_foot.cfm">
</form>


</html>
</cfoutput>

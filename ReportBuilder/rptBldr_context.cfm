
<cfset reports_dsn = application.reports_dsn>

<!----------------------->
<!--- Local variables --->
<!----------------------->
<cfif isdefined("url.report_id")>
	<cfset report_id = url.report_id>
<cfelseif isdefined("form.report_id")>
	<cfset report_id = form.report_id>
<cfelse>
	<cfset report_id = "">
</cfif>
<cfif isdefined("form.club_id")>
	<cfset club_id = form.club_id>
<cfelse>
	<cfset club_id = 0>
</cfif>
<!---------------->
<!--- Get data --->
<!---------------->
<cftry>
	<cfquery datasource="#reports_dsn#" name="getReportTypes">
	  select rt.report_type_id, rt.report_type_name from tbl_view v inner join xref_report_type_view xrtv on v.view_id = xrtv.view_id inner join tbl_report_type rt on rt.report_type_id = xrtv.report_type_id
	</cfquery>
		<cfquery datasource="#reports_dsn#" name="getReport">
		select a.report_type_id,
		       report_name,
			   report_desc,
			   context_value,
			   context_id
		  from tbl_report a
		  inner join tbl_report_type b
		  	on a.report_type_id=b.report_type_id
		 where report_id = <cfqueryparam value="#report_id#">
		</cfquery>
		<cfif getReport.recordcount>
			<cfset report_type_id = getReport.report_type_id>
			<cfset report_name = getReport.report_name>
			<cfset report_desc = getReport.report_desc>
			<cfset context_id = getReport.context_id>
			<cfset context_value = getReport.context_value>
			<cfset orgRestrict = 0>
		<cfelse>
			<cfset report_type_id = "">
			<cfset report_name = "">
			<cfset report_desc = "">
			<cfset context_id = "0">
			<cfset context_value="">
			<cfset club_id= 0>
			<cfset orgRestrict = 0>
			<cfset orgList = queryNew("club_id, club_name")>
		</cfif>
		<cfif not isdefined("from_email_address") or not isdefined("from_email_alias")>
        <cfquery name="getDefaults" datasource="#application.dsn#">
		select _name, _value from tbl_global_vars where
		_name in ('from_email_address','from_email_alias')
		</cfquery>
			<cfloop query="getDefaults">
				<cfset "#_name#" = _value>
			</cfloop>
		</cfif>
		
		
<!--- 		<cfset orgList = queryNew("organization_id, organization_desc")>
		<cfset actList = queryNew("activity_id, activity_desc")> --->
<!--- 	<cfif report_id NEQ "">


		<!--- set info based on context --->
		<cfif context_id EQ "1">
			<cfset account_id = context_value>
			<!--- define empty queries --->
			<cfset orgList = queryNew("organization_id, organization_desc")>
			<cfset actList = queryNew("activity_id, activity_desc")>
		<cfelseif context_id EQ "2">
			<cfset organization_id = context_value>
			<cfquery datasource="#application.dsn#" name="getContextInfo">
				select * from
					v_organization a
					inner join v_account b
						on a.parent_account_id = b.account_id
					where organization_id=#organization_id#
			</cfquery>
			<cfset account_id="#getContextInfo.account_id#">
			<cfquery datasource="#application.dsn#" name="orgList">
				select organization_id, organization_desc
				from v_organization
				where parent_account_id=#account_id#
				order by organization_desc
			</cfquery>
			<!--- define empty query --->
			<cfset actList = queryNew("activity_id, activity_desc")>
		<cfelseif context_id EQ "3">
			<cfset activity_id=context_value>
			<cfquery datasource="#application.dsn#" name="getContextInfo">
				select * from
					v_activity a
					inner join v_organization b
						on a.organization_id=b.organization_id
					inner join v_account c
						on b.parent_account_id = c.account_id
					where activity_id=#activity_id#
			</cfquery>
			<cfset organization_id="#getContextInfo.organization_id#">
			<cfset account_id="#getContextInfo.account_id#">
			<cfquery datasource="#application.dsn#" name="orgList">
				select organization_id, organization_desc
				from v_organization
				where parent_account_id=#account_id#
				order by organization_desc
			</cfquery>
			<cfquery datasource="#application.dsn#" name="actList">
				select activity_id, activity_desc
				from v_activity
				where organization_id=#organization_id#
				order by activity_desc
			</cfquery>

		</cfif>

	<cfelse> --->
<!--- 		<cfset report_type_id = "">
		<cfset report_name = "">
		<cfset report_desc = "">
		<cfset context_id = "4">
		<cfset context_value="">
		<cfset club_id= 0>
		<cfset orgList = queryNew("organization_id, organization_desc")>
		<cfset actList = queryNew("activity_id, activity_desc")> --->
	<!--- </cfif> --->
	<!--- <cfoutput>
	context_id:#context_id#<br>
	account_id:#account_id#<br>
	org_id:#organization_id#<br>
	activity_id:#activity_id#<br>
	</cfoutput> --->
	
<!--- 	<cfif orgRestrict>
		<!--- set organization, account to valuses from security --->
		<cfset organization_id=sec_organization_id>
		<cfset account_id=sec_account_id>
		<!--- get org, account names --->
		<cfquery datasource="#application.dsn#" name="getOrgActDesc">
			select a.organization_desc, b.name
			from v_organization a
			inner join v_account b
			on a.parent_account_id=b.account_id
			where a.organization_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#organization_id#">
		</cfquery>
		<!--- get activity list --->

	</cfif> --->

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
	<link  href="_rptBldr_style.css" type="text/css" media="print,screen" rel="stylesheet" >
<!--- 	<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
	<script language="JavaScript" type="text/javascript">
		var context_id;
		<cfif context_id NEQ "0">
			context_id=<cfoutput>#context_id#</cfoutput>;
		</cfif>
		$(document).ready(function()
		{
			<cfif report_id EQ "">
			//initialize dropdown boxes
			$("select[name=report_type_id] option:first").attr('selected','selected');
			$("select[name=club_id] option:first").attr('selected','selected');
			$("input[name=context_value]").val('');
			<cfif NOT orgRestrict>
				$("#clubRow").hide();
				//$("#actRow").hide();
			</cfif>

			</cfif>

			$("select[name=report_type_id]").change(function()
			{
				//get context_id
				context_id=$(this).find('option:selected').attr('context_id');

				if(context_id)
				{
					if(context_id == 4)
					{
						$("input[name=context_value]").val($('select[name=club_id] option:selected').attr('value'));
						$("#clubRow").show();
					}
					else if(context_id == 2)
					{
						$("input[name=context_value]").val($('select[name=organization_id] option:selected').attr('value'));
						$("#actRow").hide();
					}
					else if(context_id == 3)
					{
						$("input[name=context_value]").val($('select[name=activity_id] option:selected').attr('value'));
						<cfif orgRestrict>
							$("#actRow").show();
						</cfif>
					}
				}
				else
				{
					<cfif NOT orgRestrict>
						$("#orgRow").hide();
					</cfif>
					$("#actRow").hide();
				}
			});

			$("select[name=account_id]").change(function()
			{
				//switch on context_id
				if(context_id == 1)
					$("input[name=context_value]").val($('select[name=account_id] option:selected').attr('value'));
				else
				{
					if($('select[name=account_id] option:selected').attr('value') != '')
					{
						getOrganizations();
						$("#orgRow").show();
					}
					else
						$("#orgRow").hide();
				}
			});

			$("select[name=club_id]").change(function()
			{
				//switch on context_id
				if(context_id == 4)
					$("input[name=context_value]").val($('select[name=club_id] option:selected').attr('value'));
				else
				{
					if($('select[name=club_id] option:selected').attr('value') != '')
					{
						getActivities();
						$("#actRow").show();
					}
					else
						$("#actRow").hide();
				}
			});

			$("select[name=activity_id]").change(function()
			{
				//switch on context_id
				if(context_id == 3)
					$("input[name=context_value]").val($('select[name=activity_id] option:selected').attr('value'));
				else
				{
					//shouldn't really get here
				}
			});

		});

		function getOrganizations()
		{
			$.getJSON('asyncGetAccountOrganizations.cfm?',{account_id:$('select[name=account_id] option:selected').attr('value')},function(a)
			{
				$('select[name=organization_id] option:not(:first)').remove();
				//populate org dropdown
				for(x=0; x<a.data.recordcount; x++)
				{
					$('select[name=organization_id]').append('<option value="'+a.data.data.organization_id[x]+'">'+a.data.data.organization_desc[x]+'</option');
				}
			});
		}

		function getActivities()
		{
			$.getJSON('asyncGetOrgActivities.cfm?',{organization_id:$('select[name=organization_id] option:selected').attr('value')},function(a)
			{
				$('select[name=activity_id] option:not(:first)').remove();
				//populate org dropdown
				for(x=0; x<a.data.recordcount; x++)
				{
					$('select[name=activity_id]').append('<option value="'+a.data.data.activity_id[x]+'">'+a.data.data.activity_desc[x]+'</option');
				}
			});
		}
	</script> --->
</head>

<body>
<CFINCLUDE TEMPLATE="header_rptBldr.cfm">
<cfhtmlhead text="<title>Report Builder - Create Report</title>">
<div style="height:10px;width:auto;"> </div>

<cfoutput>
<!--- Declare form --->
<form method="post" action="rptBldr_context_action.cfm">
<input type="hidden" name="report_Id" value="#report_id#">

<cfset stepnum=1>
<cfinclude template="tpl_rptBldr_head.cfm">

<div style="height: 15px; width: auto;"> </div>


<table border="0" cellspacing="0" cellpadding="4" width="100%">
	<tr><td colspan="2">To get started, complete the form below.</td></tr>
	<tr>	
		<td class="aeformlabel" width="200" valign="top">Subject:</td>
		<td class="aeformfield">
		<input type="text" id="subject" name="subject">
		</td>
    </tr>
	<tr>	
		<td class="aeformlabel" width="200" valign="top">From Email:</td>
		<td class="aeformfield">
		<input type="from_email" id="from_email" value="#from_email_address#">
		</td>
    </tr>
	<tr>	
		<td class="aeformlabel" width="200" valign="top">From Name:</td>
		<td class="aeformfield">
		<input type="from_name" id="from_name" value="#from_email_alias#">
		</td>
    </tr>
	<tr><td colspan="2">Select a view from which to build your list of recipients</td></tr>
	<tr>
		<td class="aeformlabel" width="200" valign="top">View:</td>
		<td class="aeformfield">
		<select name="report_type_id">
		<option value="">-- Select Report Type --</option>
		<cfloop query="getReportTypes">
			<option value="#report_type_id#" context_id="#context_id#" <cfif getReportTypes.report_type_id EQ variables.report_type_id> SELECTED</cfif>>#report_type_name#</option>
		</cfloop>
		</select>
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

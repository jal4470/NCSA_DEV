<!----------------------------->
<!--- Application variables --->
<!----------------------------->
<cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock>

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

<!---------------->
<!--- Get data --->
<!---------------->
<cftry>
	<cfquery datasource="#reports_dsn#" name="getReportTypes">
	select report_type_id , report_type_name, context_id
	  from tbl_report_type
	</cfquery>
	
	<cfquery datasource="#application.dsn#" name="getAccounts">
		select account_id, name from tbl_account
		order by name
	</cfquery>

	<cfif report_id NEQ "">
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
		<cfset report_type_id = getReport.report_type_id>
		<cfset report_name = getReport.report_name>
		<cfset report_desc = getReport.report_desc>
		<cfset context_id = getReport.context_id>
		<cfset context_value = getReport.context_value>
		
		<!--- set info based on context --->
		<cfif context_id EQ "1">
			<cfset account_id = context_value>
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
		
	<cfelse>
		<cfset report_type_id = "">
		<cfset report_name = "">
		<cfset report_desc = "">
		<cfset context_id = "0">
		<cfset context_value="">
		<cfset account_id = "0">
		<cfset organization_id = "0">
		<cfset activity_id = "0">
		<cfset orgList = queryNew("organization_id, organization_desc")>
		<cfset actList = queryNew("activity_id, activity_desc")>
	</cfif>
	<!--- <cfoutput>
	context_id:#context_id#<br>
	account_id:#account_id#<br>
	org_id:#organization_id#<br>
	activity_id:#activity_id#<br>
	</cfoutput> --->

	<cfcatch><cfdump var=#cfcatch#><cfabort>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry>

<!----------------->
<!--- Page body --->
<!----------------->
<html>
<head>
	<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
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
			$("select[name=account_id] option:first").attr('selected','selected');
			$("select[name=organization_id] option:first").attr('selected','selected');
			$("select[name=activity_id] option:first").attr('selected','selected');
			$("input[name=context_value]").val('');
			$("#orgRow").hide();
			$("#actRow").hide();
			
			</cfif>
			
			$("select[name=report_type_id]").change(function()
			{
				//get context_id
				context_id=$(this).find('option:selected').attr('context_id');
				
				if(context_id)
				{
					if(context_id == 1)
					{
						$("input[name=context_value]").val($('select[name=account_id] option:selected').attr('value'));
						$("#orgRow").hide();
						$("#actRow").hide();
					}
					else if(context_id == 2)
					{
						$("input[name=context_value]").val($('select[name=organization_id] option:selected').attr('value'));
						$("#actRow").hide();
					}
					else if(context_id == 3)
						$("input[name=context_value]").val($('select[name=activity_id] option:selected').attr('value'));
				}
				else
				{
					$("#orgRow").hide();
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
			
			$("select[name=organization_id]").change(function()
			{
				//switch on context_id
				if(context_id == 2)
					$("input[name=context_value]").val($('select[name=organization_id] option:selected').attr('value'));
				else
				{
					if($('select[name=organization_id] option:selected').attr('value') != '')
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
			$.getJSON('asyncGetAccountOrganizations.cfm',{account_id:$('select[name=account_id] option:selected').attr('value')},function(a)
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
			$.getJSON('asyncGetOrgActivities.cfm',{organization_id:$('select[name=organization_id] option:selected').attr('value')},function(a)
			{
				$('select[name=activity_id] option:not(:first)').remove();
				//populate org dropdown
				for(x=0; x<a.data.recordcount; x++)
				{
					$('select[name=activity_id]').append('<option value="'+a.data.data.activity_id[x]+'">'+a.data.data.activity_desc[x]+'</option');
				}
			});
		}
	</script>
</head>
<cfoutput>
<b>Step 1: Create Report</b><hr>

<form method="post" action="rptBldr_context_action.cfm">
<input type="hidden" name="context_value" value="#context_value#">
<input type="hidden" name="report_Id" value="#report_id#">

<table border="0" cellspacing="0" cellpadding="3" width="648">
	
	<tr>
		<td align="right">Report Types</td>
		<td align="left">
			<select name="report_type_id">
			<option value="">-- Select Report Type --</option>
			<cfloop query="getReportTypes">
				<option value="#report_type_id#" context_id="#context_id#" <cfif getReportTypes.report_type_id EQ variables.report_type_id> SELECTED</cfif>>#report_type_name#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td align="right">Account</td>
		<td align="left">
			<select name="account_id">
			<option value="">-- Select Account --</option>
			<cfloop query="getAccounts">
				<option value="#account_id#" <cfif variables.account_id EQ getAccounts.account_id>SELECTED</cfif>>#name#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr id="orgRow" <cfif context_id LT 2>style="display:none;"</cfif>>
		<td align="right">Organization</td>
		<td align="left">
			<select name="organization_id">
			<option value="">-- Select Organization --</option>
			<cfloop query="orgList">
				<option value="#organization_id#" <cfif variables.organization_id EQ orgList.organization_id>SELECTED</cfif>>#organization_desc#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr id="actRow" <cfif context_id LT 3>style="display:none;"</cfif>>
		<td align="right">Activity</td>
		<td align="left">
			<select name="activity_id">
			<option value="">-- Select Activity --</option>
			<cfloop query="actList">
				<option value="#activity_id#" <cfif variables.activity_id EQ actList.activity_id>SELECTED</cfif>>#activity_desc#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<!--- <tr>
		<td align="right">Report Name</td>
		<td align="left"><input type="text" name="report_name" size="50" maxlength="255" value="#report_name#"></td>
	</tr>
	<tr>
		<td align="right">Description</td>
		<td align="left"><textarea name="report_desc" rows="4" cols="40">#report_desc#</textarea></td>
	</tr> --->
	<tr>
		<td align="right">&nbsp;</td>
		<td align="center"><cfif report_id NEQ ""><cfinclude template="tpl_rptBldr_jump_menu.cfm"></cfif><input type="submit" name="btnSave" value="Next"> <input type="submit" name="btnRun" value="Run"> <input type="button" name="cancel" value="Cancel" onclick="window.location='rptBldr_home.cfm';"></td>
	</tr>
	
</table>
</html>
</cfoutput>

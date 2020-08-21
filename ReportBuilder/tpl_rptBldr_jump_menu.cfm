<cfif isdefined("url.report_id")>
	<cfquery datasource="#application.reports_dsn#" name="getreportformat">
		select report_format_id from tbl_report
		where report_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.report_id#">
	</cfquery>
</cfif>
<!--- import jquery, then rename to jq so not to conflict with a possibly previously imported jquery --->

<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
<script language="JavaScript" type="text/javascript">
	
	var jjq=jQuery.noConflict();
	
	jjq(function(){
		jjq("select[name=selJumpMenu]").change(function(){
			//get page
			var page=jjq(this).find("option:selected").val();
			if(page != '')
			{
				//submit form
				document.forms[0].submit();
			}
		});
	});
	
</script>

<cfset jumpnum = 1>
<cfoutput>
	<select name="selJumpMenu">
		<option value="">-- Jump To Page --</option>
		
		<option value="context">#jumpnum#. Select Report</option><cfset jumpnum=jumpnum+1>
		
		<option value="format">#jumpnum#. Select Format</option><cfset jumpnum=jumpnum+1>
		
		<cfif isdefined("getreportformat") AND getreportformat.report_format_id EQ 4>
		<option value="design_format">#jumpnum#. Select Label Format</option><cfset jumpnum=jumpnum+1>
		</cfif>
		
		<cfif isdefined("getreportformat") AND getreportformat.report_format_id NEQ 4>
		<option value="cols">#jumpnum#. Select Columns</option><cfset jumpnum=jumpnum+1>
		</cfif>
		
		<cfif isdefined("getreportformat") AND getreportformat.report_format_id EQ 3>
		<option value="groups">#jumpnum#. Setup Report</option><cfset jumpnum=jumpnum+1>
		</cfif>
		
		<cfif isdefined("getreportformat") AND listfind("1,2",getreportformat.report_format_id) NEQ 0>
		<option value="totals">#jumpnum#. Select Totals</option><cfset jumpnum=jumpnum+1>
		</cfif>
		
		<cfif isdefined("getreportformat") AND listfind("1,2",getreportformat.report_format_id) NEQ 0>
		<option value="order">#jumpnum#. Order Columns</option><cfset jumpnum=jumpnum+1>
		</cfif>
		
		<option value="filters">#jumpnum#. Choose Filters</option><cfset jumpnum=jumpnum+1>
		
		<cfif isdefined("getreportformat") AND getreportformat.report_format_id EQ 2>
		<option value="groups">#jumpnum#. Choose Groups</option><cfset jumpnum=jumpnum+1>
		</cfif>
		
		<option value="display">#jumpnum#. Run Report</option><cfset jumpnum=jumpnum+1>
	</select>
</cfoutput>
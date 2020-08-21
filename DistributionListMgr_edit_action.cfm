<!--- Author: Joe Lechuga jlechuga@capturepoint.com
Purpose: Action Page of Distribution List Updates
Changes:
	J.Lechuga 5/26/2010 Initial Revision
	J.Lechuga 8/17/2010 Added Decode method to deserialize JSON Looped thru array returned to set correct values.
 --->
<!----------------------------->
<!--- Application variables --->
<!----------------------------->

<cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock>

 <!--- validate login --->
 <cfmodule template="_checkLogin.cfm">


	<cfstoredproc procedure="p_update_distribution_list" datasource="#reports_dsn#">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@distribution_list_id" value="#Form.distributionListId#">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@distribution_list_name" value="#Form.DISTRIBUTIONLISTNAME#">
		<cfprocparam type="in" cfsqltype="CF_SQL_BIT" dbvarname="@allow_edits" value="#iif(isdefined('form.CRITERIAEDIT'),de(1),de(0))#">
		<cfprocparam type="in" cfsqltype="CF_SQL_INTEGER" dbvarname="@report_type_id" value="#FORM.REPORT_TYPE_ID#">
		<cfprocparam type="in" cfsqltype="CF_SQL_INTEGER" dbvarname="@updated_by" value="#session.user.contactid#">
	</cfstoredproc>

	<cfstoredproc datasource="#reports_dsn#" procedure="p_clear_report_type_criteria">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#form.report_type_id#" DBVARNAME="@report_type_id">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@distribution_list_id" value="#Form.distributionListId#">
	</cfstoredproc>
	<cfinvoke
		component="json"
		method="decode"
		data="#form.SERIALIZEDCRITERIA#"
		returnvariable="critArray">

	<cfloop from="1" to="#ArrayLen(critArray)#" index="i">
				<cfif len(trim(critArray[i].view_col_id))>
				<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_set_report_type_criteria" >
					<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#form.report_type_id#" DBVARNAME="@report_type_id">
					<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#critArray[i].view_col_id#" DBVARNAME="@view_col_id">
					<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#critArray[i].operand_id#" DBVARNAME="@operand_id">
					<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#critArray[i].value#" DBVARNAME="@value">
					<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="" DBVARNAME="@view_col_value" null="yes">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@distribution_list_id" value="#Form.distributionListId#">
					<cfif StructKeyExists(critArray[i],"AllowEdits")>
					<cfprocparam type="in" cfsqltype="CF_SQL_BIT" dbvarname="@allow_edits" value="#critArray[i].AllowEdits#" >
					<cfelse>
					<cfprocparam type="in" cfsqltype="CF_SQL_BIT" dbvarname="@allow_edits" value="0" >
					</cfif>
					
					<cfprocparam type="in" cfsqltype="CF_SQL_INTEGER" dbvarname="@updated_by" value="#session.user.contactid#">
				</CFSTOREDPROC>
				</cfif>
	</cfloop>

	<cflocation url="DistributionListMgr.cfm">
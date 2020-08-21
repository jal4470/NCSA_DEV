<cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock>

 <!--- validate login --->
 <cfmodule template="_checkLogin.cfm">
 
 <cfset distribution_list_id = url.distlistid>
 
 	<cfstoredproc datasource="#reports_dsn#" procedure="p_delete_distribution_list">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@distribution_list_id" value="#distribution_list_id#">
	</cfstoredproc>
	
<cflocation url="DistributionListMgr.cfm">
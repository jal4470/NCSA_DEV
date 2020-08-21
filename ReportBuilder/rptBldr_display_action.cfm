



<cfif isdefined("form.seljumpmenu")>
	<cflocation url="rptBldr_#form.seljumpmenu#.cfm?report_id=#report_id#" addtoken="No">
</cfif>
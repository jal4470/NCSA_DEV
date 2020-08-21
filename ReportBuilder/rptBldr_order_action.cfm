<cfdump var=#form#>



<cfif isdefined("form.tree") and form.tree NEQ "">

	<!--- convert json object into cf structure --->
	<cfinvoke component="JSON" method="decode" data="#form.tree#" returnvariable="result" />

	<!--- <cfdump var=#result#> --->

	<!--- find the actual tree within the structure --->
	<cfset thetree = result>

	<!--- make list to store output --->
	<cfset treeList = "">


	<cfset processLinearTree(thetree)>


	<cfoutput>#treeList#</cfoutput>


	<cfinvoke
		component="#application.crs_cfc_path#.report"
		method="reorderColumns"
		tree="#treeList#">

</cfif>

<cfif isdefined("form.btnback")>
	<cflocation url="rptBldr_totals.cfm?report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.btnRun")>
	<cflocation url="rptBldr_display.cfm?report_id=#report_id#" addtoken="No">
<cfelseif isdefined("form.seljumpmenu") AND form.seljumpmenu NEQ "">
	<cflocation url="rptBldr_#form.seljumpmenu#.cfm?report_id=#report_id#" addtoken="No">
<cfelse>
	<cflocation url="rptBldr_filters.cfm?report_id=#report_id#" addtoken="No">
</cfif>





<cffunction access="private" name="processLinearTree">
	<cfargument name="tree" type="array" requred="yes">
	
	<cfloop index="i" from="1" to="#arraylen(arguments.tree)#">
		<cfset theNode = arguments.tree[i]>
		<cfset theID = mid(theNode,23,len(theNode)-22)>

		<cfset treelist = treelist & "#theID#:#i#&">

	</cfloop>
	
</cffunction>
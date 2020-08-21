<!------------------------------------------------
	MODIFICATIONS:
	07/10/2017 A.Pinzone (NCSA22821)
	-- Removed check against "noNested" (nesting support removal)
	-- Simplified handling of data and updated custom function processLinearTree
-------------------------------------------------->

<cfif isdefined("form.tree") and form.tree NEQ "">

	<!--- convert json object into cf structure --->
	<cfinvoke component="JSON" method="decode" data="#form.tree#" returnvariable="thetree" />

	<!--- make list to store output --->
	<cfset treeList = "">

	<!--- call function with top level --->
	<cfset processLinearTree(thetree)>

	<cfoutput>#treeList#</cfoutput>

	<cfinvoke
		component="#form.componentName#"
		method="#form.methodName#"
		tree="#treeList#">

</cfif>

<cflocation url="#form.redirectURL#">

<cffunction access="private" name="processTree">
	<cfargument name="tree" type="array" required="Yes">
	<cfargument name="parentNode" type="string" required="Yes" default="-1">

	<cfloop index="i" from="1" to="#arraylen(arguments.tree)#">
		<cfset theNode = arguments.tree[i]>
		<cfset theID = theNode.id>

		<!--- run stored proc to store node --->
		<cfoutput>setting ID #theID# under #arguments.parentNode# at level #i#<br></cfoutput>
		<cfset treelist = treelist & "#theID#:#arguments.parentNode#:#i#&">

		<!--- check for children --->
		<cfif isdefined("theNode.children")>
			<!--- recurse through children --->
			<cfset processTree(theNode.children,theNode.id)>
		</cfif>
	</cfloop>

</cffunction>

<cffunction access="private" name="processLinearTree">
	<cfargument name="tree" type="array" required="yes">
	
	<cfloop index="i" from="1" to="#arraylen(arguments.tree)#">

		<cfset treelist = treelist & "#arguments.tree[i]#&">

	</cfloop>
	
</cffunction>
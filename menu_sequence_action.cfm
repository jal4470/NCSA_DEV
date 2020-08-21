<!---
07/31/2017 - apinzone - 22821
-- Updated buildout of string based on plugin changes.
--->

<cfinvoke
	component="json"
	method="decode"
	data="#form.serialized#"
	returnvariable="objTree">
</cfinvoke>

<cfset processarray("",objTree)>

<cflocation url="menu_manage.cfm" addtoken="No">



<cffunction
	name="ProcessArray"
	access="private"
	returntype="any">
	<cfargument name="parent_id" type="string" required="Yes">
	<cfargument name="object" type="array" required="Yes">
	<cfset var count=0>
	<cfset var obj="">
	<cfset var objid="">
	
	<!--- loop over array --->
	<cfloop from="1" to="#arraylen(arguments.object)#" index="i">
		<cfset obj=arguments.object[i]>
		
		<cfset count=count + 1>
		<cfset objid=mid(obj.id,6,len(obj.id)-5)>
		
		<cfoutput>[menu:#objid#:#arguments.parent_id#:#count#]<br></cfoutput>
		<cfinvoke
			component="#session.sitevars.cfcpath#.menu"
			method="updateMenuSeq"
			menu_id="#objid#"
			seq="#count#"
			parent_menu_id="#arguments.parent_id#">
		
		<!--- if children, recurse --->
		<cfif structkeyexists(obj,"children")>
			<cfset ProcessArray(objid,obj.children)>
		</cfif>
		
	</cfloop>
	
</cffunction>
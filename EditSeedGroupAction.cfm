<cfdump var="#form#">


<cfset error = "">
<cfif isdefined("form.seed_group_id")>
	<cfset seed_group_id = form.seed_group_id>
<cfelse>
	<cflocation url="seed_list.cfm">
</cfif>
<cfif not len(trim(SeedGroupName))>
	<cfset error = "Please Provide a Seed Group Name" >
</cfif>
<cfif not isdefined("form.seeds") or not Len(trim(seeds))>
	<cfif len(trim(error))>
		<cfset Error = Error & '<br>'>
		
	</cfif>
	<cfset seeds = "">
</cfif>



<cfif not len(trim(error))>
<cfscript>
	st = structNew();
	st.seed_group_id=seed_group_id;
	st.seed_group_name = form.seedGroupName;
	st.seed_group_description = form.seedGroupDescription;
	st.seeds = seeds;
</cfscript>
<cfinvoke component="#SESSION.sitevars.cfcPath#Seeds" method="updateSeedGroups" argumentcollection="#st#" returnvariable="ret"></cfinvoke>
<!--- <cfdump var="#ret#"> --->
		<cflocation url="seed_list.cfm">

<cfelse>
<cfsavecontent variable="error">
<cfoutput><div style="color:red;font-weight:bold;">
#error#
</div>
</cfoutput>
</cfsavecontent>
<cflocation url="EditSeedGroup.cfm?error=#urlencodedformat(error)#&SeedGroupName=#urlencodedformat(form.seedGroupName)#&SeedGroupDescription=#urlencodedformat(form.SeedGroupDescription)#&Seeds=#seeds#">
</cfif>

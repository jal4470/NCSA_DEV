<cfdump var="#form#">


<cfset error = "">
<cfif not len(trim(SeedGroupName))>
	<cfset error = "Please Provide a Seed Group Name" >
</cfif>
<cfif not isdefined("seeds") or not Len(trim(seeds))>
	<cfif len(trim(error))>
		<cfset Error = Error & '<br>'>
		
	</cfif>
	<cfset error = Error & " You must select at least one seed from the list.">
	<cfset seeds = "">
</cfif>



<cfif not len(trim(error))>
<cfscript>
	st = structNew();
	st.seed_group_name = form.seedGroupName;
	st.seed_group_description = form.seedGroupDescription;
	st.seeds = form.seeds;
	st.clubid = session.user.clubid;
</cfscript>
<cfinvoke component="#SESSION.sitevars.cfcPath#Seeds" method="createSeedGroups" argumentcollection="#st#" returnvariable="ret"></cfinvoke>
<!--- <cfdump var="#ret#"> --->

	<cfif isdefined("form.AddAnother")>
		<cflocation url="AddSeedGroup.cfm">
	<cfelse>
		<cflocation url="seed_list.cfm">
	</cfif>

<cfelse>
<cfsavecontent variable="error">
<cfoutput><div style="color:red;font-weight:bold;">
#error#
</div>
</cfoutput>
</cfsavecontent>
<cflocation url="AddSeedGroup.cfm?error=#urlencodedformat(error)#&SeedGroupName=#urlencodedformat(form.seedGroupName)#&SeedGroupDescription=#urlencodedformat(form.SeedGroupDescription)#&Seeds=#seeds#">
</cfif>

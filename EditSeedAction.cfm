<cfset error = "">
<cfif not len(trim(SeedName))>
	<cfset error = "Please Provide a Seed Name" >
</cfif>
<cfif not Len(trim(seedEmail)) or not isValid("EMAIL",seedEmail)>
	<cfif len(trim(error))>
		<cfset Error = Error & '<br>'>
	</cfif>
	<cfset error = Error & " Please Provide a Valid Seed Email">
</cfif>

<cfif form.seedgroup EQ -1>
	<cfset seedgroup = "">
<cfelse>
	<cfset seedgroup = form.seedgroup>
</cfif>

<cfif not len(trim(error))>
	<cfscript>
		st = structNew();
		st.seed_id = form.SeedId;
		st.seed_name = form.seedname;
		st.seed_email = form.seedemail;
		st.seed_group_id = seedgroup;
		st.old_seed_group_id = form.OldSeedGroupId;
	</cfscript>
	
	<cfinvoke component="#SESSION.sitevars.cfcPath#Seeds" method="updateSeed" argumentcollection="#st#" returnvariable="ret"></cfinvoke>
	<!--- <cfdump var="#ret#"> --->
		<cflocation url="seed_list.cfm">
<cfelse>
<cfsavecontent variable="error">
<cfoutput><div style="color:red;font-weight:bold;">
#error#
</div>
</cfoutput>
</cfsavecontent>
<cflocation url="AddSeed.cfm?error=#urlencodedformat(error)#&SeedName=#form.seedName#&SeedEmail=#form.SeedEmail#&Seed_group_id=#form.seedgroup#">
</cfif>

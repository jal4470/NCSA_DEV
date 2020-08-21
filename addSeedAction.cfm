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
<cfif not len(trim(error))>
	<cfscript>
		st = structNew();
		st.seed_name = form.seedname;
		st.seed_email = form.seedemail;
		st.seed_group_id = form.seedgroup;
		st.clubid = session.user.clubid;
	</cfscript>
	<cfinvoke component="#SESSION.sitevars.cfcPath#Seeds" method="createSeed" argumentcollection="#st#" returnvariable="ret"></cfinvoke>
	<!--- <cfdump var="#ret#"> --->
	<cfif ret.seed_id lt 0>
		<cfsavecontent variable="error">
		<cfoutput><div style="color:red;font-weight:bold;">
			"Seed Already Exists"
		</div>
		</cfoutput>
		</cfsavecontent>
	<cfelse>
		<cfset error = "">
	</cfif>
	<cfif isdefined("form.AddAnother") or len(trim(error))>
		<cflocation url="AddSeed.cfm?error=#urlencodedformat(error)#&SeedName=#form.seedName#&SeedEmail=#form.SeedEmail#&Seed_group_id=#form.seedgroup#">
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
<cflocation url="AddSeed.cfm?error=#urlencodedformat(error)#&SeedName=#form.seedName#&SeedEmail=#form.SeedEmail#&Seed_group_id=#form.seedgroup#">
</cfif>

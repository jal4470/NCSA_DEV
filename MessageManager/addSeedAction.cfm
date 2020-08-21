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
	<cfif ret.seed_id gt 0>
		<cfif len(trim(form.seedList))>
			<cfset seedList = form.seedList & "," & ret.seed_id>
		<cfelse>
			<cfset seedList = ret.seed_id>
		</cfif>
		<cfset error = "">
	<cfelse>
		<cfsavecontent variable="error">
			<cfoutput><div style="color:red;font-weight:bold;">
			Seed already exists please select it from the seed list above
			</div>
			</cfoutput>
		</cfsavecontent>
	</cfif>
<cflocation url="#form.UrlLocation#?message_id=#message_id#&seedList=#urlencodedformat(seedList)#&seedGroupList=#urlencodedformat(form.seedGroupList)#&error=#urlencodedformat(error)#">
<cfelse>
<cfsavecontent variable="error">
<cfoutput><div style="color:red;font-weight:bold;">
#error#
</div>
</cfoutput>
</cfsavecontent>
<cflocation url="#form.UrlLocation#?error=#urlencodedformat(error)#&SeedName=#form.seedName#&SeedEmail=#form.SeedEmail#&Seed_group_id=#form.seedgroup#&message_id=#message_id#&seedList=#form.seedList#&seedGroupList=#form.seedGroupList#">
</cfif>

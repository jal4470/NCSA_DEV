<!---
Modifications:

08/02/2012 J. Rab
- Modified page to prevent duplicate seeds from appearing in the seedlist.
--->
<cfif isdefined("form.add")>
	<cfset previousList = StructNew()>
	<cfset filteredList = StructNew()>
	
	<cfquery name="getMessageSeeds" datasource="#application.dsn#">
		select EMAIL from tbl_message_recipient where message_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#message_id#"> and seed_flag = 1
	</cfquery>
	
	<cfloop query="getMessageSeeds">
		<cfset previousList_t = StructInsert(previousList,EMAIL,1)>
	</cfloop>
	
	<cfif isdefined("form.seedgroup") and len(trim(form.seedgroup))>
		<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" method="getMultiGroupSeeds" seedGroupList="#form.seedgroup#" returnvariable="sgSeeds">
		</cfinvoke>
		<cfdump var="#sgSeeds#">
		<cfloop query="sgSeeds">
			<cfset filteredList[seed_email] = 1>
		</cfloop>
		
		<cfdump var="#filteredList#">
	</cfif>
	
	<cfif isdefined("form.seeds") and len(trim(form.seeds))>
		<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" method="getMultiSeed" seedList="#form.seeds#" returnvariable="sSeeds">
		</cfinvoke>
		
		<cfloop query="sSeeds">
			<cfset filteredList[seed_email] = 1>
		</cfloop>
		
		<cfdump var="#filteredList#">
	</cfif>
	
	<cfloop collection="#filteredList#" item="seed_email">
		<cftry>
		<cfif NOT StructKeyExists(previousList,seed_email)>
			<cfstoredproc procedure="p_create_message_recipient" datasource="#application.dsn#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@message_id" type="In" value="#form.message_id#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@contact_id" type="In" value="#session.user.contactid#">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@email" type="In" value="#seed_email#">
				<cfprocparam  cfsqltype="CF_SQL_BIT" dbvarname="@seed_flag" type="In" value="1">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@message_recipient_id" type="Out" variable="message_recipient_id">
			</cfstoredproc>
		</cfif>
		<cfcatch>
		 	<cfmodule template="error.cfm" error="#cfcatch.message#:#cfcatch.detail#">
		</cfcatch>
		</cftry>
	</cfloop>
	
<cfelseif isdefined("form.remove") and isdefined("form.seedrecipients")>

<cfloop list="#form.SEEDRECIPIENTS#" index="i">
		<cfstoredproc procedure="p_remove_seed_recipient" datasource="#application.dsn#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@seed_recipient_id" type="In" value="#i#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@message_id" type="In" value="#form.message_id#">
		</cfstoredproc>
</cfloop>

</cfif>
<cflocation url="#form.ReturnUrl#?message_id=#form.message_id#">












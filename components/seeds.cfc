<!--- 
Author: Joe Lechuga
Date: 4/21/2010
Purpose: Component Used to Manage Seeds and Seed Groups

Modifications:

08/02/2012 J. Rab (TICKET NCSA11979)
- Modified seed retreival functionality
- When retreiving seeds for testing, hide non-grouped members from showing up
- Created new functions to retreive more specific seed data

 --->
<cfcomponent displayname="seeds">
	<!--- Main Query --->	
	<cffunction name="getSeedLists" access="public" returntype="query">
	<cfargument name="clubid" required="No"  default="1">
		<cfquery name="getSeedLists" datasource="#application.dsn#">
			select s.seed_id, s.seed_name, s.seed_email, sg.seed_group_id, sg.seed_group_name, sg.seed_group_description
			from tbl_seed s inner join xref_seed_seed_group xssg on s.seed_id = xssg.seed_id 
			right join tbl_seed_group sg on sg.seed_group_id = xssg.seed_group_id
			where 
			<cfif len(trim(arguments.clubid))>s.clubid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.clubid#"> and sg.clubid=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.clubid#"></cfif>
			order by sg.seed_group_name, s.seed_name
		</cfquery>
	   <cfreturn getSeedLists>
	</cffunction>
	<!--- Get Only Groups --->
   <cffunction name="getSeedGroups" access="public" returntype="query">
   <cfargument name="clubid" required="No" default="1">
   		<cfquery name="checkforDefault" datasource="#application.dsn#">
			select seed_group_id from tbl_seed_group where seed_group_name = 'Default'
			and  clubid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.clubid#">
		</cfquery>
		<cfif not checkforDefault.recordcount>
			<cfstoredproc procedure="p_insert_seed_group" datasource="#application.dsn#" returncode="Yes">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="In" value="Default"> 
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="In" value="Default Seed Group">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" type="In" value="#trim(arguments.clubid)#">
			</cfstoredproc>
		</cfif>
   		<cfquery name="getSeedGroups" datasource="#application.dsn#">
			select seed_group_id, seed_group_name, seed_group_description
			from tbl_seed_group
			where clubid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.clubid#">
		</cfquery>
   	
   		<cfreturn getSeedGroups>
   </cffunction>
   <!--- Get Specific Group --->
   <cffunction name="getSeedGroup" access="public" returntype="query">
   		<cfargument name="seedGroupId" type="numeric">
   		<cfquery name="getSeedGroup" datasource="#application.dsn#">
			select seed_group_id, seed_group_name, seed_group_description
			from tbl_seed_group
			where seed_group_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.seedGroupId#">
		</cfquery>
   		<cfreturn getSeedGroup>
   </cffunction>
   <cffunction name="getGroupSeeds" access="public" returntype="query">
   <cfargument name="seedGroupId" type="numeric">
   		<cfquery name="getGroupSeeds" datasource="#application.dsn#">
			select seed_id, seed_name, seed_email, clubid
			from tbl_seed s
			where exists(select 1 from xref_seed_seed_group where seed_id = s.seed_id and seed_group_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.seedGroupId#">)
		</cfquery>
   		<cfreturn getGroupSeeds>
   </cffunction>
   <cffunction name="getMultiGroupSeeds" access="public" returntype="query">
   <cfargument name="seedGroupList" type="any">
   		<cfquery name="getGroupSeeds" datasource="#application.dsn#">
			select seed_id, seed_name, seed_email, clubid
			from tbl_seed s
			where exists(select 1 from xref_seed_seed_group where seed_id = s.seed_id and seed_group_id in ( #arguments.seedGroupList#))
		</cfquery>
   		<cfreturn getGroupSeeds>
   </cffunction>
   <!--- Get Only Seeds --->
   <cffunction name="getSeeds" access="public" returntype="query">
   <cfargument name="clubid" required="Yes">
   		<cfquery name="getSeeds" datasource="#application.dsn#">
			select distinct s.seed_id, s.seed_name, s.seed_email, s.clubid
			from tbl_seed s
			where clubid = 1 
			and EXISTS (select xssg.seed_group_id from xref_seed_seed_group xssg where xssg.seed_id = s.seed_id)
		</cfquery>
   	
   		<cfreturn getSeeds>
   </cffunction>
   <!--- Get Only UNGROUPED Seeds --->
   <cffunction name="getUngroupedSeeds" access="public" returntype="query">
   <cfargument name="clubid" required="Yes">
   		<cfquery name="getUngroupedSeeds" datasource="#application.dsn#">
			select * from v_ungrouped_seeds
		</cfquery>
   	
   		<cfreturn getUngroupedSeeds>
   </cffunction>
   <!--- Get Specific Seed --->
   <cffunction name="getSeed" access="public" returntype="query">
   <cfargument name="seedId" type="numeric">
   		<cfquery name="getSeed" datasource="#application.dsn#">
			select s.seed_id, s.seed_name,s.seed_email,xssg.seed_group_id from 
			tbl_seed s inner join xref_seed_seed_group xssg on s.seed_id = xssg.seed_id
			where s.seed_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.seedId#">
		</cfquery>
   		<cfreturn getSeed>
   </cffunction>
   <!--- Get Specific Seed Regardless Of Group --->
   <cffunction name="getAnySeed" access="public" returntype="query">
   <cfargument name="seedId" type="numeric">
   		<cfquery name="getSeed" datasource="#application.dsn#">
			select s.seed_id, s.seed_name,s.seed_email from 
			tbl_seed s
			where s.seed_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.seedId#">
		</cfquery>
   		<cfreturn getSeed>
   </cffunction>
   <cffunction name="getMultiSeed" access="public" returntype="query">
   <cfargument name="SeedList" type="any">
   		<cfquery name="getSeed" datasource="#application.dsn#">
			select s.seed_id, s.seed_name,s.seed_email,xssg.seed_group_id from 
			tbl_seed s inner join xref_seed_seed_group xssg on s.seed_id = xssg.seed_id
			where s.seed_id in(#arguments.SeedList#)
		</cfquery>
   		<cfreturn getSeed>
   </cffunction>
   <!--- Add Seed --->
   <cffunction name="createSeed" access="public" returntype="struct">
   		<cfargument name="seed_name" type="any" required="Yes">
		<cfargument name="seed_email" type="any" required="Yes">
		<cfargument name="seed_group_id" type="numeric" required="Yes">
		<cfargument name="clubid" type="any" required="Yes">
		<cfset ret = structNew()>
			<cfstoredproc procedure="p_insert_seed" datasource="#application.dsn#" returncode="Yes">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="In" value="#arguments.seed_name#"> 
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="In" value="#arguments.seed_email#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" type="In" value="#trim(arguments.clubid)#">
			</cfstoredproc>
			<cfset ret.seed_id = cfstoredproc.statusCode>
			<cfif ret.seed_id gt 0>
				<cfstoredproc procedure="p_assign_seed_to_group" datasource="#application.dsn#" returncode="Yes"> 
		 			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="In" value="#cfstoredproc.statusCode#">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" type="In" value="#arguments.seed_group_id#">		
				</cfstoredproc>
				<cfset ret.status = cfstoredproc.statusCode>
			</cfif>
		<cfreturn ret>
   </cffunction>	
   <!--- Update Seed --->
   <!--- J. Rab - 08/02/2012 - Modified and able to edit non-grouped members --->
      <cffunction name="updateSeed" access="public" returntype="struct">
	  	<cfargument name="seed_id" type="any" required="Yes">
   		<cfargument name="seed_name" type="any" required="Yes">
		<cfargument name="seed_email" type="any" required="Yes">
		<cfargument name="seed_group_id">
		<cfargument name="old_seed_group_id">
		<cfset ret = structNew()>
		<cfif isDefined("arguments.old_seed_group_id") and arguments.old_seed_group_id NEQ "">
		<cfinvoke component="#SESSION.sitevars.cfcPath#Seeds" method="removeSeedFromGroup" seed_id="#arguments.seed_id#" seed_group_id="#arguments.old_seed_group_id#" returnvariable="ret"></cfinvoke>
		</cfif>
		<cfif isDefined("arguments.seed_group_id") and arguments.seed_group_id NEQ "">
		<cfinvoke component="#SESSION.sitevars.cfcPath#Seeds" method="assignSeedsToGroup" seed_id="#arguments.seed_id#" seed_group_id="#arguments.seed_group_id#" returnvariable="ret"></cfinvoke>
		</cfif>
			<cfstoredproc procedure="p_update_seed" datasource="#application.dsn#" returncode="Yes">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="In" value="#arguments.seed_id#"> 
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="In" value="#arguments.seed_name#"> 
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="In" value="#arguments.seed_email#">
			</cfstoredproc>
		<cfset ret.status = cfstoredproc.statusCode>
		
		<cfreturn ret>
   </cffunction>	
   <!--- Add Seed Groups --->
      <cffunction name="createSeedGroups" access="public" returntype="struct">
   		<cfargument name="seed_group_name" type="any" required="Yes">
		<cfargument name="seed_group_description" type="any" required="Yes">
		<cfargument name="seeds" type="any" required="Yes">
		<cfargument name="clubid" type="any" required="Yes">
		<cfset ret = structNew()>
			<cfstoredproc procedure="p_insert_seed_group" datasource="#application.dsn#" returncode="Yes">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="In" value="#arguments.seed_group_name#"> 
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="In" value="#arguments.seed_group_description#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" type="In" value="#trim(arguments.clubid)#">
			</cfstoredproc>
	
		<cfset ret.status = cfstoredproc.statusCode>
		<cfloop list="#seeds#" index="i">
			<cfscript>
				st = structNew();
				st.seed_id = i;
				st.seed_group_id = cfstoredproc.statusCode;
			</cfscript>
			<cfinvoke component="#SESSION.sitevars.cfcPath#Seeds" method="assignSeedsToGroup" argumentcollection="#st#" returnvariable="ret"></cfinvoke>
		</cfloop>
		<cfreturn ret>
   </cffunction>
   <!--- Update Seed groups --->
     <cffunction name="updateSeedGroups" access="public" returntype="struct">
	 	<cfargument name="seed_group_id" type="numeric" required="Yes">
   		<cfargument name="seed_group_name" type="any" required="Yes">
		<cfargument name="seed_group_description" type="any" required="Yes">
		<cfargument name="seeds" type="any" required="Yes">
		<cfset ret = structNew()>
			<cfstoredproc procedure="p_update_seed_group" datasource="#application.dsn#" returncode="Yes">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="In" value="#arguments.seed_group_id#"> 
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="In" value="#arguments.seed_group_name#"> 
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="In" value="#arguments.seed_group_description#">
			</cfstoredproc>
	
		<cfset ret.status = cfstoredproc.statusCode>	
		
		<cfinvoke component="#SESSION.sitevars.cfcPath#Seeds" method="removeAllSeeds" seed_group_id="#arguments.seed_group_id#" returnvariable="ret"></cfinvoke>
		<cfloop list="#seeds#" index="i">
			<cfscript>
				st = structNew();
				st.seed_id = i;
				st.seed_group_id = arguments.seed_group_id;
			</cfscript>
		
			<cfinvoke component="#SESSION.sitevars.cfcPath#Seeds" method="assignSeedsToGroup" argumentcollection="#st#" returnvariable="ret"></cfinvoke>
		</cfloop>
		<cfreturn ret>
   </cffunction>
   <!--- Associate Seeds to Groups --->
   <cffunction name="assignSeedsToGroup" access="public" returntype="struct">
   <cfargument name="seed_id" type="any" required="Yes">
   <cfargument name="seed_group_id" type="any" required="Yes">
   <cfset ret = StructNew()>
   			<cfstoredproc procedure="p_assign_seed_to_group" datasource="#application.dsn#" returncode="Yes"> 
		 		<cfprocparam cfsqltype="CF_SQL_INTEGER" type="In" value="#arguments.seed_id#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" type="In" value="#arguments.seed_group_id#">		
			</cfstoredproc>
			<cfset ret.status = cfstoredproc.statusCode>
			<cfreturn ret>
   </cffunction>
   <!--- Remove Seed Group --->
   <cffunction name="removeSeedGroup" access="public" returntype="struct">
   		<cfargument name="seed_group_id" type="any" required="Yes">
		<cfset ret = structNew()>
		<cfstoredproc procedure="p_delete_seed_group" datasource="#application.dsn#" returncode="Yes">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="In" value="#arguments.seed_group_id#">	
		</cfstoredproc>
		<cfset ret.status = cfstoredproc.statusCode>
		<cfreturn ret>
   </cffunction>
   <!--- Complete Remove Seed --->
   <cffunction name="removeSeed" access="public" returntype="struct">
   		<cfargument name="seed_id" type="any" required="Yes">
		<cfset ret = structNew()>
		<cfstoredproc procedure="p_delete_seed" datasource="#application.dsn#" returncode="Yes">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="In" value="#arguments.seed_id#">	
		</cfstoredproc>
		<cfset ret.status = cfstoredproc.statusCode>
		<cfreturn ret>
   </cffunction>
   <!--- Dissasociate seed but don't delete it --->
   <cffunction name="removeSeedFromGroup" access="public" returntype="struct">
   		<cfargument name="seed_id" type="any" required="Yes">
		<cfargument name="seed_group_id" type="any" required="Yes">
		<cfset ret = structNew()>
		<cfstoredproc procedure="p_remove_seed_from_group" datasource="#application.dsn#" returncode="Yes">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="In" value="#arguments.seed_id#">	
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="In" value="#arguments.seed_group_id#">	
		</cfstoredproc>
		<cfset ret.status = cfstoredproc.statusCode>
		<cfreturn ret>
   </cffunction>
   <!--- Remove all seeds for a given group --->
   <cffunction name="removeAllSeeds" access="public" returntype="struct">
   	<cfargument name="seed_group_id" required="Yes">
	<cfset ret = structNew()>
		<cfstoredproc procedure="p_remove_seeds_from_group" datasource="#application.dsn#" returncode="Yes">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="In" value="#arguments.seed_group_id#">	
		</cfstoredproc>
		<cfset ret.status = cfstoredproc.statusCode>
		<cfreturn ret>
   </cffunction>
</cfcomponent>

<!--- Author: Joe Lechuga
Date: 4/27/2010
Purpose: Action page to support seed group removals. When a group is removed the seeds attached are reassigned to the Default group if the default group does not have them already. --->
<cfif not isdefined("url.seedId")>
	<cflocation url="seed_list.cfm">
</cfif>
<cfscript>
	st = structNew();
	st.seed_id = url.seedId;
</cfscript>
<cfinvoke component="#SESSION.sitevars.cfcPath#Seeds" method="removeSeed" argumentcollection="#st#" returnvariable="ret"></cfinvoke>
<!--- <cfdump var="#ret#"> --->
<cflocation url="seed_list.cfm">
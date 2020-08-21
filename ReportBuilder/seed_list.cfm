<!--- Author: Joe Lechuga
Date: 4/21/2010
Purpose: Page that displays the Seed Lists and Groups with Edit/remove Links --->
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" method="getSeedLists" clubid="#session.user.clubid#" returnvariable="SeedList"></cfinvoke>
<cfoutput>
<script language="javascript">
function confirmation(url,msg) {
	var answer = confirm(msg)
	if (answer){
		window.location = url;
	}
}
</script>
<div id="contentText">
	<H1 class="pageheading">NCSA - Manage Seed Lists</H1>
	<br>
	<div><a href="addSeed.cfm">Add New Seed</a> | <a href="addSeedGroup.cfm">Add New Seed Group</a></div>
	<hr>
	<table cellpadding="2" cellspacing="0">
		
		<cfquery name="getSeedGroups" dbtype="query">
			select distinct Seed_Group_Name, Seed_group_description, Seed_group_id
			from SeedList
		</cfquery>
		<cfloop query="getSeedGroups">
<!--- 		<tr><th>&nbsp;</th> <th>Seed Group Name</th><th>Seed Group Description</th></tr> --->
		<tr>
			<td align="right">
			<cfif comparenocase(Seed_group_name,'Default')><a href="##" onclick="confirmation('RemoveSeedGroupAction.cfm?SeedGroupId=#Seed_Group_id#','Are you sure you want to remove #SEED_GROUP_NAME#?')">Remove</a>|</cfif><a href="EditSeedGroup.cfm?SeedGroupId=#Seed_Group_id#">Edit</a></td><td>#SEED_GROUP_NAME#</td><td>#SEED_GROUP_DESCRIPTION#</td></tr> 
		
				<cfquery name="getSeeds" dbtype="query">
					select distinct seed_name, seed_email,seed_id from
					SeedList where seed_group_id = #seed_group_id#
				</cfquery>
				
				<!---  <tr><th colspan="2">&nbsp;</th><th>Seed Name</th><th>Seed Email</th></tr> --->
				<cfif getSeeds.recordcount gte 1 and len(trim(getSeeds.seed_id))>
					<tr>
						<td colspan="3"><table align="center">
						<cfloop query="getSeeds">
						<tr><td style="padding-left:120px"><a href="EditSeed.cfm?SeedId=#Seed_id#&seedGroupId=#getSeedGroups.seed_group_id#">Edit</a>|<a href="##" onclick="confirmation('RemoveSeedAction.cfm?SeedId=#Seed_id#','Are You sure you want to remove this seed? By choosing to delete this seed it will be removed from all groups')">Remove</a><br><a href="##" onclick="confirmation('RemoveSeedFromGroupAction.cfm?SeedId=#Seed_id#&SeedGroupId=#getSeedGroups.seed_group_id#','Are you sure you want to remove this seed from the #getSeedGroups.seed_group_name# group?')">Remove From Group</a></td><td>#SEED_NAME#</td><td>#SEED_EMAIL#</td></tr>
						</cfloop>
						</table></td>
					</tr>	
				</cfif>
			
		</cfloop>
	</table>
	</cfoutput>
	<!--- <cfdump var="#SeedList#"> --->
</div>
<cfinclude template="_footer.cfm">

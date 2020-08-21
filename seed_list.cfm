<!--- Author: Joe Lechuga
Date: 4/21/2010
Purpose: Page that displays the Seed Lists and Groups with Edit/remove Links
Modifications:

08/02/2012 J. Rab
- Page modified and restyled
- New ungrouped section added at bottom of page
 --->
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" method="getSeedLists" clubid="#session.user.clubid#" returnvariable="SeedList"></cfinvoke>
<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" method="getUngroupedSeeds" clubid="#session.user.clubid#" returnvariable="getUngroupedSeeds"></cfinvoke>

<cfsavecontent variable="cfhtmlhead_content">
<script language="javascript">
function confirmation(url,msg) {
	var answer = confirm(msg)
	if (answer){
		window.location = url;
	}
}
</script>
<style>
table#seedGroups, table#ungroupedSeeds
{
	border-collapse: separate;
	border-color: #FFFFFF;
	border-style: solid;
	border-width: 1px;
	
	padding: 5px;
}
table#seedGroups th, table#ungroupedSeeds th
{
	background-color: #E8E8E8;
	text-align: left;
}
table#seedGroups td, table#seedGroups th, 
table#ungroupedSeeds td, table#ungroupedSeeds th
{
	padding: 5px;
}
table#seedGroups .seperator
{
	border-bottom-color: #CCCCCC;
	border-bottom-style: solid;
	border-bottom-width: 1px;
}
table.seeds
{
	border-collapse: collapse;
}
table#seedGroups th.lighter
{
	background-color: #F4F4F4;
}
h2
{
	margin-top: 20px;
	margin-bottom: 10px;
}
</style>
</cfsavecontent>
<cfhtmlhead text="#cfhtmlhead_content#">
<cfoutput>
<div id="contentText">
	<H1 class="pageheading">NCSA - Manage Seed Lists</H1>
	<br>
	<div><a href="addSeed.cfm">Add New Seed</a> | <a href="addSeedGroup.cfm">Add New Seed Group</a></div>
	<hr>
	
		
	<cfquery name="getSeedGroups" dbtype="query">
		select distinct Seed_Group_Name, Seed_group_description, Seed_group_id
		from SeedList
	</cfquery>
		
	<table id="seedGroups">
		<tr>
			<th>Action</th>
			<th>Group Description</th>
		</tr>
		<cfloop query="getSeedGroups">
		<tr>
			<td>
				<cfif comparenocase(Seed_group_name,'Default')><a href="##" onClick="confirmation('RemoveSeedGroupAction.cfm?SeedGroupId=#Seed_Group_id#','Are you sure you want to remove #SEED_GROUP_NAME#?')">Remove</a> | </cfif><a href="EditSeedGroup.cfm?SeedGroupId=#Seed_Group_id#">Edit</a>
			</td>
			<td>#SEED_GROUP_DESCRIPTION#</td>
		</tr>
			<cfquery name="getSeeds" dbtype="query">
				select distinct seed_name, seed_email,seed_id from
				SeedList where seed_group_id = #seed_group_id#
			</cfquery>
			<cfif getSeeds.recordcount gte 1 and len(trim(getSeeds.seed_id))>
			
		<tr>
			<td>&nbsp;</td>
			<th class="lighter">Seeds</th>
		</tr>
		<tr>
			<td class="seperator">&nbsp;</td>
			<td class="seperator">
				<table class="seeds">
				<cfloop query="getSeeds">
					<tr>
						<td>
							<a href="EditSeed.cfm?SeedId=#Seed_id#&seedGroupId=#getSeedGroups.seed_group_id#">Edit</a> | <a href="##" onClick="confirmation('RemoveSeedAction.cfm?SeedId=#Seed_id#','Are You sure you want to remove this seed? By choosing to delete this seed it will be removed from all groups')">Remove</a><br><a href="##" onClick="confirmation('RemoveSeedFromGroupAction.cfm?SeedId=#Seed_id#&SeedGroupId=#getSeedGroups.seed_group_id#','Are you sure you want to remove this seed from the #getSeedGroups.seed_group_name# group?')">Remove From Group</a>
						</td>
						<td>#SEED_NAME#</td>
						<td>#SEED_EMAIL#</td>
					</tr>
				</cfloop>
				</table>
			</td>
		</tr>
			</cfif>
		</cfloop>
	</table>
	
	<h2>Ungrouped Seeds</h2>
		
	<table id="ungroupedSeeds">
		<tr>
			<th>Action</th>
			<th>Seed Name</th>
			<th>Seed Email</th>
		</tr>
		<cfloop query="getUngroupedSeeds">
		<tr>
			<td>
				<a href="EditSeed.cfm?SeedId=#Seed_id#">Edit</a> | <a href="##" onClick="confirmation('RemoveSeedAction.cfm?SeedId=#Seed_id#','Are You sure you want to remove this seed? By choosing to delete this seed it will be removed from all groups')">Remove</a>
			</td>
			<td>#SEED_NAME#</td>
			<td>#SEED_EMAIL#</td>
		</tr>
		</cfloop>
	</table>

	<!--- <cfdump var="#SeedList#"> --->
</div>
	</cfoutput>
<cfinclude template="_footer.cfm">

<!--- Author: Joe Lechuga
Date: 4/21/2010
Purpose: Page to Add New Seed Groups --->

<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfif isdefined("url.SeedGroupId")>
	<cfset SeedGroupId = url.seedGroupId>
<cfelse>
	<cflocation url="seed_list.cfm">
</cfif>
<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" method="getSeedGroup" returnvariable="SeedGroupDetail" seedGroupId="#SeedGroupId#"></cfinvoke>
<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" method="getSeeds" clubid="#session.user.clubid#" returnvariable="Seeds"></cfinvoke>
<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" method="getGroupSeeds" returnvariable="GroupSeeds" seedGroupId="#SeedGroupId#"></cfinvoke>
<cfif isdefined('url.SeedGroupName')>
	<cfset seedGroupName = seedGroupName>
<cfelse>
	<cfset seedGroupName = SeedGroupDetail.seed_group_name>
</cfif>
<cfif isdefined('url.SeedGroupDescription')>
	<cfset seedGroupDescription = url.seedGroupDescription>
<cfelse>
	<cfset seedGroupDescription = SeedGroupDetail.seed_group_description>
</cfif>
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Edit Seed Group</H1>
<br>
<cfif isdefined('url.error') and len(trim(url.error))>
	<cfoutput>#urldecode(url.error)#</cfoutput>
</cfif>
<table>
	<form action="EditSeedGroupAction.cfm" method="post">
	<input type="Hidden" name="seed_group_id" value="#seedGroupId#">
	<cfif seedGroupId eq 1>
	<tr><td align="right">Seed Group Name:</td><td>#seedGroupName#<input type="hidden" name="SeedGroupName" value="#seedGroupName#"></td></tr>
	<tr><td align="right">Seed Group Description:</td><td>#seedGroupDescription#<input type="hidden" name="SeedGroupDescription"
	 value="#seedGroupDescription#"></td></tr>
	 <cfelse>
	<tr><td align="right">Seed Group Name:</td><td><input type="text" name="SeedGroupName" value="#seedGroupName#"></td></tr>
	<tr><td align="right">Seed Group Description:</td><td><input type="text" name="SeedGroupDescription"
	 value="#seedGroupDescription#"></td></tr>
	 </cfif>
	<tr>
	<td colspan="2" align="center"><small> To select Seeds to be added to this group hold down ctl+click on the desired seeds.</small><br>
	<select name="Seeds" multiple>
	<cfloop query="Seeds">
		<cfif isdefined("url.seeds") and listlen(url.seeds)>
			<cfloop list="#seeds#" index="i">
				<option value="#seed_id#" 
				<Cfif i eq Seed_id>
					selected
				</CFIF>>#Seed_name# - #Seed_email#
			</cfloop>
		<cfelse>	
		<option value="#seed_id#"
			<cfloop query="GroupSeeds">
				<cfif Seeds.seed_id eq seed_id>
					selected
				</cfif>
			</cfloop>
			>#Seeds.Seed_name# - #Seeds.Seed_email#
		</cfif>
	</cfloop>
	</select></td></tr>
	<tr><td colspan="2"><hr></td></tr>
	<tr><td colspan="2"><input type="Submit" name="Update" value="Update"><input type="Button" value="Cancel" onclick="window.location='seed_list.cfm'"></td></tr>
	</form>
</table></cfoutput>
</div>
<cfinclude template="_footer.cfm">

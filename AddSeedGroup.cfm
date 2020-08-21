<!--- Author: Joe Lechuga
Date: 4/21/2010
Purpose: Page to Add New Seed Groups --->

<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfif isdefined('SeedGroupName')>
	<cfset seedGroupName = seedGroupName>
<cfelse>
	<cfset seedGroupName = "">
</cfif>
<cfif isdefined('SeedGroupDescription')>
	<cfset seedGroupDescription = seedGroupDescription>
<cfelse>
	<cfset seedGroupDescription = "">
</cfif>
<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" method="getSeeds" clubid="#session.user.clubid#" returnvariable="Seeds"></cfinvoke>
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Add Seed Group</H1>
<br>
<cfif isdefined('url.error') and len(trim(url.error))>
	<cfoutput>#urldecode(url.error)#</cfoutput>
</cfif>
<table>
	<form action="AddSeedGroupAction.cfm" method="post">
	<tr><td align="right">Seed Group Name:</td><td><input type="text" name="SeedGroupName" value="#seedGroupName#"></td></tr>
	<tr><td align="right">Seed Group Description:</td><td><input type="text" name="SeedGroupDescription" value="#seedGroupDescription#"></td></tr>
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
			<option value="#seed_id#">#Seed_name# - #Seed_email#
		</cfif>
	</cfloop>
	</select></td></tr>
	<tr><td colspan="2"><hr></td></tr>
	<tr><td colspan="2"><input type="Submit" name="Add" value="Create"><input type="Submit" name="AddAnother" value="Create and Add Another"><input type="Button" value="Cancel" onclick="window.location='seed_list.cfm'"></td></tr>
	</form>
</table></cfoutput>
</div>
<cfinclude template="_footer.cfm">

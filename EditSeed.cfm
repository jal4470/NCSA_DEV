<!--- Author: Joe Lechuga
Date: 4/21/2010
Purpose: Page to Add New Seeds

08/02/2012 J. Rab
- Page modified to allow edits for Seeds without groups

--->


<cfif isdefined("url.SeedId")>
	<cfset seedId = url.seedId>
<cfelse>
	<cflocation url="seed_list.cfm">
</cfif>



<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" method="getSeedGroups" returnvariable="SeedGroups"></cfinvoke>
<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" method="getSeed" seedId="#seedId#" returnvariable="Seeds"></cfinvoke>

<cfif Seeds.RecordCount EQ 0>
	<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" 
		method="getAnySeed" seedId="#seedId#" returnvariable="Seeds"></cfinvoke>
</cfif>

<cfif isdefined("url.seedName")>
	<cfset seedName = url.seedName>
<cfelse>
	<cfset seedName = Seeds.seed_name>
</cfif>


<cfif isdefined("url.seedEmail")>
	<cfset seedEmail = url.seedEmail>
<cfelse>
	<cfset seedEmail = seeds.seed_email>
</cfif>
<cfif isdefined("url.seedGroupId")>
	<cfset seedGroupId = url.seedGroupId>
<cfelseif isDefined("seeds.seed_group_id")>
	<cfset seedGroupId = seeds.seed_group_id>
<cfelse>
	<cfset seedGroupId = "">
</cfif>



<cfoutput><div id="contentText">
<H1 class="pageheading">NCSA - Edit Seed</H1>
<br>
<cfif isdefined('url.error') and len(trim(url.error))>
	<cfoutput>#urldecode(url.error)#</cfoutput>
</cfif>
<table>
	<form action="EditSeedAction.cfm" method="post">
	<input type="hidden" name="SeedId" value="#seedId#">
	<input type="hidden" name="OldSeedGroupId" value="#seedGroupId#">
	<tr><td align="right">Seed Name:</td><td><input type="text" name="SeedName" value="#SeedName#"></td></tr>
	<tr><td align="right">Seed Email:</td><td><input type="text" name="SeedEmail"value="#SeedEmail#"></td></tr>
	<tr><td align="right">Seed Group:</td><td>
	<select name="SeedGroup">
			<cfif variables.seedGroupid EQ ""><option value="-1" selected="selected">-- No Group Selected --</option></cfif>
		<cfloop query="SeedGroups">
			<option value="#seed_group_id#" title="#seed_group_description#" <cfif seed_group_id eq variables.seedGroupid>Selected</cfif>>#seed_group_name#
		</cfloop>
	</select>
	</td></tr>
	<tr><td colspan="2"><hr></td></tr>
	<tr><td colspan="2"><input type="Submit" name="Update" value="Update"><input type="Button" value="Cancel" onclick="window.location='seed_list.cfm'"></td></tr>
	</form>
</table>
</div></cfoutput>
<cfinclude template="_footer.cfm">

<!--- Author: Joe Lechuga
Date: 4/21/2010
Purpose: Page to Add New Seeds--->



<cfif isdefined("url.seedName")>
	<cfset seedName = url.seedName>
<cfelse>
	<cfset seedName = "">
</cfif>


<cfif isdefined("url.seedEmail")>
	<cfset seedEmail = url.seedEmail>
<cfelse>
	<cfset seedEmail = "">
</cfif>


<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" method="getSeedGroups" returnvariable="SeedGroups"></cfinvoke>
<cfoutput><div id="contentText">
<H1 class="pageheading">NCSA - Add Seed</H1>
<br>
<cfif isdefined('url.error') and len(trim(url.error))>
	<cfoutput>#urldecode(url.error)#</cfoutput>
</cfif>
<table>
	<form action="AddSeedAction.cfm" method="post">
	<tr><td align="right">Seed Name:</td><td><input type="text" name="SeedName" value="#SeedName#"></td></tr>
	<tr><td align="right">Seed Email:</td><td><input type="text" name="SeedEmail"value="#SeedEmail#"></td></tr>
	<tr><td align="right">Seed Group:</td><td>
	<select name="SeedGroup">
		<cfloop query="SeedGroups">
			<option value="#seed_group_id#" title="#seed_group_description#" #iif(isdefined('url.seed_group_id') and seed_group_id eq url.seed_group_id, de('selected'),de(''))#>#seed_group_name#
		</cfloop>
	</select>
	</td></tr>
	<tr><td colspan="2"><hr></td></tr>
	<tr><td colspan="2"><input type="Submit" name="Add" value="Create"><input type="Submit" name="AddAnother" value="Create and Add Another"><input type="Button" value="Cancel" onclick="window.location='seed_list.cfm'"></td></tr>
	</form>
</table>
</div></cfoutput>
<cfinclude template="_footer.cfm">

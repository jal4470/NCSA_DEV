<cfif isdefined("url.seedList")>
	<cfset seedList = urldecode(url.seedList)>
<cfelse>
	<cfset seedList = "">
</cfif>
<cfif isdefined("url.seedGroupList")>
	<cfset seedGroupList = urldecode(url.seedGroupList)>
<cfelse>
	<cfset seedGroupList = "">
</cfif>
<cfset enableLaunch = 0>
<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" method="getSeedGroups" clubid="#SESSION.USER.CLUBID#" returnvariable="SeedGroups">
</cfinvoke>

<cfinvoke component="#SESSION.sitevars.cfcPath#seeds" method="getSeeds" clubid="#SESSION.USER.CLUBID#" returnvariable="Seeds">
</cfinvoke>
<cfquery name="getMessageSeeds" datasource="#dsn#">
	select * from tbl_message_recipient where message_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#message_id#"> and seed_flag = 1
</cfquery>
<cfif getMessageSeeds.recordcount>
	<cfset enableLaunch = 1>
</cfif>
<form method="post" action="Step4_AddSeedRecipients.cfm">
	<tr>
		<td align="right"><strong><u>Seed Group</u></strong><br> 
			<select name="SeedGroup" id="SeedGroup" onchange="setTextBoxValue('seedGroupList','SeedGroup');"  multiple="true">
				<cfoutput query="SeedGroups">
					<option value="#seed_group_id#"
					<cfif len(trim(SeedGroupList))>
						<cfloop list="#SeedGroupList#" index="j">
							<cfif j eq seed_group_id>
								selected
							</cfif>
						</cfloop>
					</cfif>> #seed_group_name# [#seed_group_description#]</option>
				</cfoutput>
			</select><br>And/Or</td>
			<td rowspan="2" width="3%"><input type="submit" name="add" value=">>"><br><input type="submit" name="remove" value="<<">
			</td>
			<td rowspan="2" width="60%">
				<strong><u>Recipients</u></strong><br>
				<select name="SeedRecipients" multiple size="28" style="width:300px;">
				<cfif isdefined('getMessageSeeds')>
					<cfoutput query="getMessageSeeds">
						<option value="#MESSAGE_RECIPIENT_ID#">#EMAIL#</option>
					</cfoutput>
				</cfif>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong><u>Seeds</u></strong><br> 
				<select name="Seeds" multiple="true" id="Seeds" onchange="setTextBoxValue('seedList','Seeds');">
				<cfoutput query="Seeds">
					<option value="#seed_id#"
				<cfif isdefined('seedList') and len(trim(seedList))>
					<cfloop list="#urldecode(seedList)#" index="i">
						<cfif i eq seed_id>Selected</cfif>
					</cfloop>
				</cfif>> #seed_name# [#seed_email#]</option>
				</cfoutput>
				</select>
			</td>
		</tr>
			<cfoutput>
				<input type="hidden" name="message_id" value="#message_id#">
				<input type="hidden" name="ReturnUrl" value="#cgi.script_name#">
			</cfoutput>
</form>    
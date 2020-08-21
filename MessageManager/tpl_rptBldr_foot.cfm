<cfif isdefined('url.report_id')>
	<cfset report_id = url.report_id>
<cfelse>
	<cfset report_id = "">
</cfif>
<cfif isdefined('url.message_id')>
	<cfset message_id = url.message_id>
<cfelseif isdefined('form.message_id')>
	<cfset message_id = form.message_id>
<cfelse>
	<cfset message_id = "">
</cfif>
<cfoutput>
	<table border="0" cellspacing="0" cellpadding="4" width="100%">
		<tr>
			<td class="mainsubhead" width="200">&nbsp;</td>
			<td class="mainsubhead">
				<div style="float:right;">
					<input type="button" name="cancel" value="Cancel" onclick="window.location='index.cfm';" class="itemformbuttonleft">
					<cfif stepnum neq 5>
						<input type="submit" name="btnSave" value="Next" class="itemformbuttonleft">
					</cfif>
				</div>
				<cfif stepnum NEQ 1>
					<cfif stepnum eq 3 and (isdefined("url.allowedits") and not url.allowedits)>
						<input type="button" onclick="window.location='Step#(stepnum-2)#.cfm?report_id=#report_id#&message_id=#message_id#'" name="btnBack" value="Back" class="itemformbuttonleft">
					<cfelse>
					<input type="button" onclick="window.location='Step#(stepnum-1)#.cfm?report_id=#report_id#&message_id=#message_id#'" name="btnBack" value="Back" class="itemformbuttonleft">
					</cfif>
				</cfif>
		<!--- 		<input type="submit" name="btnRun" value="Run" class="itemformbuttonleft"> --->
			</td>
		</tr>
	</table>
</cfoutput>
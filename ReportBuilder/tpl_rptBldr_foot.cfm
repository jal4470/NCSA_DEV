
<cfoutput>
	<table border="0" cellspacing="0" cellpadding="4" width="100%">
		<tr>
			<td class="mainsubhead" width="200">&nbsp;</td>
			<td class="mainsubhead">
				<div style="float:right;">
					<input type="button" name="cancel" value="Cancel" onclick="window.location='rptBldr_home.cfm';" class="itemformbuttonleft">
					<input type="submit" name="btnSave" value="Next" class="itemformbuttonleft">
				</div>
				<cfif stepnum NEQ 1>
					<input type="submit" name="btnBack" value="Back" class="itemformbuttonleft">
				</cfif>
				<input type="submit" name="btnRun" value="Run" class="itemformbuttonleft">
			</td>
		</tr>
	</table>
</cfoutput>
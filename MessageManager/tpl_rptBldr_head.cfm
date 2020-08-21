<cfoutput>
	<table border="0" cellspacing="0" cellpadding="4" width="100%">
		<tr>
			<td class="mainhead">
			
				<cfif stepnum NEQ 4 and stepnum NEQ 5>
					<div style="float:right;">
						<input type="submit" name="btnSave" value="Next" class="itemformbuttonleft">
					</div>
				</cfif>
				<cfif stepnum EQ 9><!--- display --->
					<div style="float:right;">
						<a class="itemformbuttonleft" href="rptBldr_context.cfm?report_id=#report_id#">Edit</a>
						<cfif getReport.report_format_id EQ 4>
							<a target="_blank" class="itemformbuttonleft" href="rptBldr_design_view.cfm?report_id=#report_id#">Print Labels</a>
						</cfif>
						<a class="itemformbuttonleft" href="rptBldr_export.cfm?report_id=#report_id#">Export</a>
					</div>
				</cfif>
				
			<!--- 	<cfif report_id NEQ "">
				<div style="float:right; margin-right:5px; padding-top:4px;">
					<cfinclude template="tpl_rptBldr_jump_menu.cfm">
				</div>
				</cfif> --->
				<cfif isdefined("url.allowedits") and not url.allowedits>
					<cfset stepnum = stepnum+1>
				</cfif>
				
				<cfswitch expression="#stepnum#">
					<cfcase value="1">
						Step 1: Getting Started
					</cfcase>
					<cfcase value="2">
						Step 2: Define Filters
					</cfcase>
					<cfcase value="3">
						Step 3: Create Message
					</cfcase>
					<cfcase value="4">
						Step 4: Summary
					</cfcase>
					<cfcase value="5">
						Step 5: Define Seeds
					</cfcase>
		<!--- 			<cfcase value="5">
						Step 5: Order Columns
					</cfcase> --->
					<cfcase value="6">
						Step <cfif getreport.report_format_id EQ 3>5<cfelseif getreport.report_format_id EQ 4>4<cfelse>6</cfif>: Define Filters
					</cfcase>
					<cfcase value="7">
						Step 7: Select Report Groups
					</cfcase>
					<cfcase value="8">
						Step 4: Setup Report
					</cfcase>
					<cfcase value="9">
						Report Results
					</cfcase>
					<cfcase value="10">
						Step 3: Select Label Format
					</cfcase>
				</cfswitch>
				<cfif isdefined("getReport") AND getreport.report_name NEQ "">- #getReport.report_name#</cfif>
				
			<!--- 	<cfif report_id NEQ "">
					<cfinclude template="tpl_rptBldr_save_report.cfm">
				</cfif> --->
			
			</td>
			
		</tr>
	</table>
</cfoutput>


<!--- <table border="0" cellspacing="0" cellpadding="4" width="100%">
	<tr>
		<td class="mainhead" width="50%">Step 2: Select Report Format<cfoutput query="getReport"><CFIF report_name IS NOT "">: </CFIF>#report_name#</cfoutput></td>
		<td class="mainhead" width="50%" align="right"><cfinclude template="tpl_rptBldr_save_report.cfm"></td>
	</tr>
</table> --->
<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS UI Page		   			--->
<!------------------------------------->
<!---  File: reporting_home.cfm	--->
<!---  Created:  02.07.2003 by		--->
<!---	         Phil Rogers		--->
<!---  Last Modified: 02.12.2003	--->
<!---  12/7/2006:
       - revamped Today's Activity section
	   - order report list alphabetically
	   - parent/child parameter alterations
       7/13/2007
	   - reinstated previously commented
	     out date calendar controls
       6/19/2008, J. Oriente
           - expanded multi-select box to 8 rows from 4
12/2/2009-b.cooper
- Add report builder link to right side
	   								--->
<!------------------------------------->

<!--- Set Application variables --->
<cfif not isdefined("application.dsn")>
	<cfinclude template="application.cfm">
</cfif>
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
	<cfset site_title = application.site_title>
</cflock>

<!--- Security --->

<cfinclude template="_secureme.cfm">

<!----------------------->
<!--- Local variables --->
<!----------------------->
<cfif isdefined("url.r")>
	<cfset r = url.r>
<cfelseif isdefined("form.r")>
	<cfset r = form.r>
<cfelse>
	<cfset r = "">
</cfif>

<cfif isdefined("url.parent_report_param_field")>
	<cfset parent_report_param_field = url.parent_report_param_field>
<cfelseif isdefined("form.parent_report_param_field")>
	<cfset parent_report_param_field = form.parent_report_param_field>
<cfelse>
	<cfset parent_report_param_field = "">
</cfif>

<cfif isdefined("url.parent_report_param_value")>
	<cfset parent_report_param_value = url.parent_report_param_value>
<cfelseif isdefined("form.parent_report_param_value")>
	<cfset parent_report_param_value = form.parent_report_param_value>
<cfelse>
	<cfset parent_report_param_value = "">
</cfif>

<cfif parent_report_param_value EQ 0>
	<cfset parent_report_param_field = "">
	<cfset parent_report_param_value = "">
</cfif>

<!------------------->
<!--- Validations --->
<!------------------->
<cfif parent_report_param_field NEQ "" AND parent_report_param_value EQ "">
	<cf_error error="System error: cannot deteremine parent parameter value.">
</cfif>

<cfif parent_report_param_value NEQ "" AND parent_report_param_field EQ "">
	<cf_error error="System error: cannot deteremine parent parameter field.">
</cfif>


<!---------------->
<!--- Get data --->
<!---------------->
<cftry>
	<!--- Today's activity --->

<!--- 
	<CFSTOREDPROC datasource="#dsn#" procedure="p_rep_todays_activity_new" returncode="YES">
		<CFPROCRESULT NAME="getRegistrationActivity" RESULTSET="1">
		<CFPROCRESULT NAME="getCatalogActivity" RESULTSET="2">
		<CFPROCRESULT NAME="getDonationActivity" RESULTSET="3">
		<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#organization_id#" DBVARNAME="@organization_id">
	</CFSTOREDPROC>
--->
	<!--- Report list --->
	<CFQUERY NAME="getreports" DATASOURCE="#application.dsn#">
	SELECT a.report_id, a.report_title
	  FROM tbl_report a, xref_organization_report b
	 WHERE a.status_id = 1
	   AND a.global_adm_flag = 0
	   AND a.report_id = b.report_id
	   AND b.organization_id = #organization_id#
	ORDER BY a.report_title
	</CFQUERY>

	<!--- Report selected --->
	<CFIF ISDEFINED("url.r")>
		<!--- Report details --->
		<CFQUERY NAME="getReportDetail" DATASOURCE="#application.dsn#">
		SELECT report_title,
		       file_name
		  FROM tbl_report
		 WHERE report_id = <CFQUERYPARAM VALUE="#url.r#">
		   AND status_id = 1
		</CFQUERY>

		<!--- Parameters --->
		<CFSTOREDPROC datasource="#dsn#" procedure="p_get_report_parameters" returncode="YES">
			<CFPROCRESULT NAME="getReportParamCounts" RESULTSET="1">
			<CFPROCRESULT NAME="getReportParams" RESULTSET="2">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#organization_id#" DBVARNAME="@organization_id">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#r#" DBVARNAME="@report_id">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#parent_report_param_field#" DBVARNAME="@parent_report_param_field" NULL="#YesNoFormat(parent_report_param_field EQ "")#">
			<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#parent_report_param_value#" DBVARNAME="@parent_report_param_value" NULL="#YesNoFormat(parent_report_param_value EQ "")#">
		</CFSTOREDPROC>
	</CFIF>

	<cfcatch>
		<cf_error error="#Replace(cfcatch.detail,'[Macromedia][SQLServer JDBC Driver][SQLServer]','')#. Please report this error to the site administrator.">
	</cfcatch>
</cftry>

<!------------------------------------------------->
<!--- GET ORGANIZATION LIST FOR MULTI USER ORGS --->
<!------------------------------------------------->
<CFIF rolelistStr CONTAINS ",#application.multi_user_role_id#,">
<CFTRY>
	<cfquery name="multiorgs" datasource="#application.dsn#">
		    select account_id,
		           organization_id,
		           organization_desc
		      from v_organization
		     where parent_account_id = #parent_account_id#
		       and status_id = 1
		       and multi_user_flag = 1
		  order by organization_desc
	</cfquery>
	<CFCATCH type="any">
		<CF_ERROR error="Cannot get multi orgs.">			
	</CFCATCH>			
</CFTRY>
</CFIF>

<!----------------->
<!--- Page body --->
<!----------------->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<cfoutput>
<head>
	<title>#site_title#</title>
	<link rel="stylesheet" type="text/css" href="style.css">
	<link href="#application.admin_URL#assets/calendar/CalendarControl.css" rel="stylesheet" type="text/css">
</head>
</cfoutput>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#E6E7E8">

<cfoutput>
<script src="#application.admin_URL#assets/calendar/CalendarControl.js" language="javascript"></script>
</cfoutput>

<CFINCLUDE TEMPLATE="header.cfm">

<!--- CONTROLS AND INTRO BOX --->
<table border="0" cellspacing="0" cellpadding="0" width="780">
	<tr>
		<td height="10"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="10"></td>
	</tr>
	<tr>
		<td width="780" valign="top" bgcolor="#E6E7E8">
		<table border="0" cellspacing="0" cellpadding="0" width="780">
			<tr>
				<td width="10"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
				<td width="770" valign="top">
				<table border="0" cellspacing="0" cellpadding="0" width="770">
					<tr>
						<td colspan="3" height="1" bgcolor="#636466"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
					</tr>
					<tr>
						<td width="1" bgcolor="#636466"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
						<td width="768">
						<table border="0" cellspacing="0" cellpadding="4" width="768" bgcolor="#FFFFFF">
							<tr>
								<td height="15" valign="middle" bgcolor="#6661A7" class="whitebold14" width="400">Reporting Home</td>
								<td height="15" valign="middle" bgcolor="#6661A7" class="whitebold14" width="368" align="right"><cfoutput>#organization_desc#</cfoutput></td>
							</tr>
						</table>
						<table border="0" cellspacing="0" cellpadding="0" width="768" bgcolor="#FFFFFF">
							<tr>
								<td height="10" colspan="7"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="10"></td>
							</tr>
							<tr>
								<td width="10"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="10" HEIGHT="1"></td>
								<td width="477" valign="top">
								<table border="0" cellspacing="0" cellpadding="2" width="477">
									<tr>
										<td valign="top" class="homehd">Report Generation</td>
									</tr>
									<tr>
										<td height="3"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="3"></td>
									</tr>
									<tr>
										<td valign="top" class="medcopyblack">
										<table border="0" cellspacing="0" cellpadding="2" width="400">
											<tr>
												<td width="100" align="right" class="medcopyblack">Select Report:</td>
												<td width="300">
												<form name="jump">
												<select name="menu" onChange="location=document.jump.menu.options[document.jump.menu.selectedIndex].value;" value="GO">
												<CFIF NOT(ISDEFINED("url.r"))><option value="">Report Templates</option></CFIF>
												<CFOUTPUT QUERY="getreports">
												<option value="reporting_home.cfm?r=#report_id#&s=#securestring#"<CFIF ISDEFINED("url.r") AND url.r EQ report_id> SELECTED</CFIF>>#report_title#</option>
												</CFOUTPUT>
												</select>
												</form>
												</td>
											</tr>
										</table>
										</td>
									</tr>
									<tr>
										<td height="15"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="15"></td>
									</tr>

									<!-------------------------->
									<!--- No report selected --->
									<!-------------------------->
									<cfif NOT isDefined("url.r")>
									<tr>
										<td height="200"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="200"></td>
									</tr>

									<!----------------------->
									<!--- Report selected --->
									<!----------------------->
									<cfelse>

									<!--- No parameters; redirect to report --->
									<cfif getReportParams.RecordCount EQ 0>
										<cflocation url="#getReportDetail.file_name#?s=#securestring#&organization_id=#organization_id#" ADDTOKEN="no">
									</cfif>
	
									<!--- Declare form --->
									<cfoutput>
									<FORM NAME="theForm" METHOD="post" ACTION="#getReportDetail.file_name#?s=#securestring#">
									</cfoutput>

									<!--- Report title --->
									<tr>
										<td valign="top" class="homehd"><cfoutput>#getReportDetail.report_title#</cfoutput></td>
									</tr>
									<tr>
										<td height="2"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="2"></td>
									</tr>

									<!--- Display parameters --->
									<tr>
										<td valign="top">
										<table border="0" cellspacing="0" cellpadding="2" width="400">
												<cfoutput query="getReportParams" group="report_param_id">

												<!--- Set class --->
												<cfif required_flag EQ 1>
													<cfset curclass = "red11">
												<cfelse>
													<cfset curclass = "medcopyblack">
												</cfif>
												
												<!--------------------------------->
												<!--- Display current parameter --->
												<!--------------------------------->
												<!--- Text --->
												<cfif object_type_id EQ 1>
												<tr>
													<td width="100" align="right" class="#curclass#">#param_name#</td>
													<td width="300" class="medgrey">
													<cfif data_type_id EQ 2 AND format_example IS "mm/dd/yyyy">
														<INPUT type="text" name="#data_field_name#" size="15" onfocus="showCalendarControl(this);" value="#prepop_value#">
													<cfelse>
														<INPUT type="text" name="#data_field_name#" size="15" value="#prepop_value#">
													</cfif>
													<cfif format_example IS NOT ""> #format_example#</cfif>
													</td>
												</tr>

												<!--- Select --->
												<cfelseif object_type_id EQ 4>
												<tr>
													<td width="100" align="right" class="#curclass#" valign="top">#param_name#</td>
													<td width="300">
													<cfif child_report_param_id NEQ "">
													<select name="#data_field_name#" onChange="document.location.href='reporting_home.cfm?s=#securestring#&r=#url.r#&parent_report_param_field=#data_field_name#&parent_report_param_value=' + document.theForm.#data_field_name#.value">
													<cfelse>
													<select name="#data_field_name#">
													</cfif>

													<!--- Default choice --->
													<cfif allow_all_flag EQ 1>
													<option value="0">All
													<cfelseif parent_report_param_field EQ "">
													<option value="">Select #param_name#
													</cfif>

													<!--- Output choices --->
													<cfoutput>
													<option value="#rec_id#"<cfif parent_report_param_field EQ data_field_name AND parent_report_param_value EQ rec_id> SELECTED</cfif>>#rec_name#
													</cfoutput> <!--- Inner --->
													</select>
													</td>
												</tr>
												
												<!--- Multi-Select --->
												<cfelseif object_type_id EQ 5>
												<tr>
													<td width="100" align="right" class="#curclass#" valign="top">#param_name#</td>
													<td width="300">
													<select name="#data_field_name#" MULTIPLE size="8">
													<cfoutput>
													<option value="#rec_id#">#rec_name#
													</cfoutput>
													</select>
													</td>
												</tr>
												
												</cfif> <!--- Object type --->
												
												</cfoutput> <!--- Outer --->

												<!--- Buttons --->
												<cfif getReportParamCounts.ttl_params EQ getReportParamCounts.curr_params>
												<tr>
													<td width="100" align="right" class="medcopyblack">&nbsp;</td>
													<td width="300"><input type="submit" name="submit" value="Run Report"></td>
												</tr>
												</cfif>

											</table>
											</FORM>
											</td>
										</tr>
										
										</td>
									</tr>
									
									<!--- Spacer --->
									<tr>
										<td height="100"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="100"></td>
									</tr>

									</cfif>

								</table>
								</td>
								<td width="10"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="10" HEIGHT="1"></td>
								<td width="1" bgcolor="#636466"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
								<td width="10"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="10" HEIGHT="1"></td>
								<td width="250" valign="top">
								
								
								<!----------------------------->
								<!--- toggle organizations  --->
								<!----------------------------->
								<CFSET current_view_org = #organization_id#>
								<CFIF rolelistStr CONTAINS ",#application.multi_user_role_id#,">
								<CFOUTPUT>
								<form method="post" action="toggle_organization_action.cfm?s=#securestring#">
								<input type="hidden" name="nextpage" value="reporting_home.cfm">
								</CFOUTPUT>
								<table border="0" cellspacing="0" cellpadding="2" width="250">
									<tr>
										<td valign="top" class="homehd">Change Organization</td>
									</tr>
									<tr>
										<td height="5"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="5"></td>
									</tr>
									<tr>
										<td class="grey10" valign="top">
										<select name="new_account_id">
										<option value="">Choose Organization
										<cfoutput query="multiorgs">
										<option value="#account_id#"<CFIF organization_id IS current_view_org> SELECTED</CFIF>>#LEFT(organization_desc,30)#</option>
										</cfoutput>
										</select>
										</td>
									</tr>
									<tr>
										<td height="2"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="2"></td>
									</tr>
									<tr>
										<td><input type="submit" name="submit" value="Change Organization"></td>
									</tr>
									<tr>
										<td height="2"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="2"></td>
									</tr>

								</table>
								</form>	
								</CFIF>
								<div style="height:10px;width:auto;"> </div>
								
								
								<!--- link to report builder --->
								<cfif listfind(rolelist,"69")>
									<cfoutput><a href="rptBldr_home.cfm?s=#securestring#">Report Builder</a></cfoutput>
								</cfif>
								
								
								<!------------------------------------>
								<!--- Todays Registration Activity --->
								<!------------------------------------>
<!--- add by J. Oriente on 2008-09-09 --->
<!--- Today's Registration Activity snapshot has been temporarily disabled as we implement a new snapshot technology with improved performance. --->
<!--- 
								<cfif getRegistrationActivity.transactions NEQ "">
								<cfoutput query="getRegistrationActivity">
								<table border="0" cellspacing="0" cellpadding="2" width="250">
									<tr>
										<td valign="top" class="homehd" colspan="2">Todays Registration Activity</td>
									</tr>
									<tr>
										<td width="175" class="grey11">Completed Transactions:</td>
										<td width="75" class="medcopyblack" align="right">#NumberFormat(transactions)#</td>
									</tr>
									<tr>
										<td height="1" colspan="2" align="center" valign="middle"><IMG SRC="assets/images/spcrblack.gif" ALT="" WIDTH="246" HEIGHT="1"></td>
									</tr>
									<tr>
										<td class="grey11">Individual Registrations:</td>
										<td class="medcopyblack" align="right">#NumberFormat(registrations)#</td>
									</tr>
									<tr>
										<td height="1" colspan="2" align="center" valign="middle"><IMG SRC="assets/images/spcrblack.gif" ALT="" WIDTH="246" HEIGHT="1"></td>
									</tr>
									<tr>
										<td class="grey11">Credit Card Revenue Received:</td>
										<td class="medcopyblack" align="right">$#DecimalFormat(cc_revenue)#</td>
									</tr>
									<tr>
										<td height="1" colspan="2" align="center" valign="middle"><IMG SRC="assets/images/spcrblack.gif" ALT="" WIDTH="246" HEIGHT="1"></td>
									</tr>
									<tr>
										<td class="grey11">Check Revenue Received:</td>
										<td class="medcopyblack" align="right">$#DecimalFormat(chk_revenue)#</td>
									</tr>
									<tr>
										<td height="1" colspan="2" align="center" valign="middle"><IMG SRC="assets/images/spcrblack.gif" ALT="" WIDTH="246" HEIGHT="1"></td>
									</tr>
									<tr>
										<td height="1" colspan="2" align="center" valign="middle"><IMG SRC="assets/images/spcrblack.gif" ALT="" WIDTH="246" HEIGHT="1"></td>
									</tr>
									<tr>
										<td height="25" colspan="2"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="25"></td>
									</tr>
								</table>
								</cfoutput>
								</cfif>

								<!------------------------------->
								<!--- Todays Catalog Activity --->
								<!------------------------------->
								<cfif getCatalogActivity.catalog_sessions NEQ "">
								<cfoutput query="getCatalogActivity">
								<table border="0" cellspacing="0" cellpadding="2" width="250">
									<tr>
										<td valign="top" class="homehd" colspan="2">Todays Catalog Activity</td>
									</tr>
									<tr>
										<td width="175" class="grey11">Completed Transactions:</td>
										<td width="75" class="medcopyblack" align="right">#NumberFormat(catalog_sessions)#</td>
									</tr>
									<tr>
										<td height="1" colspan="2" align="center" valign="middle"><IMG SRC="assets/images/spcrblack.gif" ALT="" WIDTH="246" HEIGHT="1"></td>
									</tr>
									<tr>
										<td class="grey11">Number of Products:</td>
										<td class="medcopyblack" align="right">#NumberFormat(catalog_products)#</td>
									</tr>
									<tr>
										<td height="1" colspan="2" align="center" valign="middle"><IMG SRC="assets/images/spcrblack.gif" ALT="" WIDTH="246" HEIGHT="1"></td>
									</tr>
									<tr>
										<td class="grey11">Revenue:</td>
										<td class="medcopyblack" align="right">$#DecimalFormat(catalog_revenue)#</td>
									</tr>
									<tr>
										<td height="1" colspan="2" align="center" valign="middle"><IMG SRC="assets/images/spcrblack.gif" ALT="" WIDTH="246" HEIGHT="1"></td>
									</tr>
									<tr>
										<td height="1" colspan="2" align="center" valign="middle"><IMG SRC="assets/images/spcrblack.gif" ALT="" WIDTH="246" HEIGHT="1"></td>
									</tr>
									<tr>
										<td height="25" colspan="2"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="25"></td>
									</tr>
								</table>
								</cfoutput>
								</cfif>

								<!-------------------------------->
								<!--- Todays Donation Activity --->
								<!-------------------------------->
								<cfif getCatalogActivity.catalog_sessions NEQ "">
								<cfoutput query="getDonationActivity">
								<table border="0" cellspacing="0" cellpadding="2" width="250">
									<tr>
										<td valign="top" class="homehd" colspan="2">Todays Donation Activity</td>
									</tr>
									<tr>
										<td width="175" class="grey11">Completed Donations:</td>
										<td width="75" class="medcopyblack" align="right">#NumberFormat(donation_sessions)#</td>
									</tr>
									<tr>
										<td height="1" colspan="2" align="center" valign="middle"><IMG SRC="assets/images/spcrblack.gif" ALT="" WIDTH="246" HEIGHT="1"></td>
									</tr>
									<tr>
										<td class="grey11">Revenue:</td>
										<td class="medcopyblack" align="right">$#DecimalFormat(donation_revenue)#</td>
									</tr>
									<tr>
										<td height="1" colspan="2" align="center" valign="middle"><IMG SRC="assets/images/spcrblack.gif" ALT="" WIDTH="246" HEIGHT="1"></td>
									</tr>
									<tr>
										<td height="1" colspan="2" align="center" valign="middle"><IMG SRC="assets/images/spcrblack.gif" ALT="" WIDTH="246" HEIGHT="1"></td>
									</tr>
									<tr>
										<td height="25" colspan="2"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="25"></td>
									</tr>
								</table>
								</cfoutput>
								</cfif>
--->
								</td>
								<td width="10"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="10" HEIGHT="1"></td>
							</tr>
							<tr>
								<td height="20" colspan="7"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="20"></td>
							</tr>
						</table>
						</td>
						<td width="1" bgcolor="#636466"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
					</tr>
					<tr>
						<td colspan="3" height="1" bgcolor="#636466"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="780">
	<tr>
		<td height="26" align="right"><IMG SRC="assets/images/cp_powered2.gif" ALT="" WIDTH="213" HEIGHT="26"></td>
	</tr>
</table>
</body>
</html>

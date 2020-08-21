<!----------------------------->
<!--- Application variables --->
<!----------------------------->
<!--- <cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock> --->


<!---------------->
<!--- Get data --->
<!---------------->
<!--- <cftry> --->
	<!--- get all saved reports --->
<!--- 	<cfquery datasource="#application.reports_dsn#" name="getReports">
		select * from tbl_report
		where saved_flag=1
	</cfquery>
 --->	
 
 <cfquery datasource="cp_reports" name="getReports">
		select * from tbl_report
		where saved_flag=1
	</cfquery>
 
	
<!--- <cfdump var=#getColumns#> --->

<!--- 	<cfcatch>
		<cfinclude template="cfcatch.cfm">
	</cfcatch>
</cftry> --->

<!----------------->
<!--- Page body --->
<!----------------->
<html>
	<cfoutput>
		<head>
			<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
			<script language="javascript" type="text/javascript" src="assets/jquery-impromptu.2.5.min.js"></script>
			<link rel="stylesheet" href="rptBldr.css">
			<script language="JavaScript" type="text/javascript">
				
				var jq=jQuery.noConflict();
				
				function deleteReport(report_id)
				{
					var promptText='<h3>Delete Report</h3>Are you sure you want to delete this report?<br><br>Name:'+jq("##report_"+report_id+" td:eq(2) a").text();
					
			
					var promptStates={
						state0:{
							html:promptText,
							focus:1,
							buttons:{
								Delete:true,
								Cancel:false
							},
							submit:function(r,o,f){
								if(r)
								{
									//send email ajax
									jq.ajax({
										cache:false,
										data:{
											report_id:report_id
										},
										dataType:'json',
										error:function(r, s, e){
											jq.prompt.goToState('failState');
										},
										success:function(d, s){
											if(d.status == 'success')
											{
												//remove row
												jq("##report_"+report_id).fadeOut(500,function(){jq(this).remove()});
												jq.prompt.goToState('successState');
											}
											else
												jq.prompt.goToState('failState');
										},
										type:'POST',
										url:'async_rptBldr_delete_action.cfm'
									});
									return false;
								}
							}
						},
						successState:{
							html:'<h3>Success</h3><p>The report has been deleted.</p>',
							buttons:{
								Ok:true
							}
						},
						failState:{
							html:'<h3>Failed</h3><p>The report could not be deleted.</p>',
							buttons:{
								Ok:true
							}
						}
					};
					
					jq.prompt.setDefaults({
						prefix: 'brownJqi',
						show: 'slideDown',
						overlayspeed:0.1,
						promptspeed:0.1
					}); 
					
					jq.prompt(promptStates);
					
				}
			</script>
		</head>
		<body>
			<div style="text-align:center;">
				<a href="rptBldr_context.cfm">Add</a>
			</div>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="50">
						ID
					</td>
					<td width="100" style="white-space:nowrap;">
						Action
					</td>
					<td width="300">
						Name
					</td>
					<td>
						Description
					</td>
				</tr>
				<cfloop query="getReports">
					<tr id="report_#report_id#">
						<td>
							#report_id#
						</td>
						<td style="white-space:nowrap;">
							<a href="rptBldr_context.cfm?report_id=#report_id#">Edit</a> | <a href="javascript:deleteReport(#report_id#);">Del</a>
						</td>
						<td>
							<a href="rptBldr_display.cfm?report_id=#report_id#">#report_name#</a>
						</td>
						<td>
							#report_desc#
						</td>
					</tr>
				</cfloop>
			</table>
		</body>
	</cfoutput>
</html>


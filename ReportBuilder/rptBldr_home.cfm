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
 
 <!--- get report folders --->
<cfquery datasource="#application.reports_dsn#" name="getFolders">
 	select * from tbl_folder
	order by display_col, seq
 </cfquery> 
 
 
 <cfquery datasource="#application.reports_dsn#" name="getReports">
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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<cfoutput>
		<head>
			<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
			<script language="javascript" type="text/javascript" src="assets/jquery-impromptu.2.5.min.js"></script>
			<script language="javascript" type="text/javascript" src="assets/jquery.contextmenu.r2.js"></script>
			<script language="javascript" type="text/javascript" src="assets/jquery-ui-1.7.2.sortable.min.js"></script>
			<script language="javascript" type="text/javascript" src="assets/jquery.json.js"></script>
			<script language="JavaScript" src="assets/jquery.fancybox/jquery.fancybox-1.2.1.js"></script>
			<script language="JavaScript" type="text/javascript" src="assets/jquery-validate/jquery.validate.js"></script>
			<link rel="stylesheet" href="assets/jquery.fancybox/jquery.fancybox.css" type="text/css" media="screen">
			<!--- <link rel="stylesheet" href="rptBldr.css"> --->
			<link  href="_rptBldr_style.css" type="text/css" media="print,screen" rel="stylesheet" >
		<link  href="assets/theme/jquery-ui-1.7.2.custom.css" type="text/css" media="print,screen" rel="stylesheet" >
			<script language="JavaScript" type="text/javascript">
				
				
				$(function(){
					
					//REPORT CONTEXT MENU
					$('.menuTrigger').contextMenu('reportMenu',{
						bindings:{
							'menuRun':function(t){
								//run report
								window.location='rptBldr_display.cfm?report_id='+$(t).attr('report_id');
							},
							'menuEdit':function(t){
								//edit report
								window.location='rptBldr_context.cfm?report_id='+$(t).attr('report_id');
							},
							'menuRename':function(t){
								//rename popup
								renameReport($(t).attr('report_id'));
							},
							'menuDelete':function(t){
								//prompt delete
								deleteReport($(t).attr('report_id'));
							},
							'menuExport':function(t){
								//export report
								window.location='rptBldr_export.cfm?report_id='+$(t).attr('report_id');
							}
						},
						eventTrigger:'click'
					});
					
					//SORTABLE FOLDERS
					$('.folderSortContainer').sortable({
						connectWith:'.folderSortContainer',
						distance:15,
						handle:'h3',
						//helper:'clone',
						placeholder:'sortPlaceholder',
						start:function(e,ui){
							//set height of placeholder
							$(ui.placeholder).css('height',$(ui.item).height());
						},
						update:function(e,ui){
							//create obj to serialize
							var s=new Array();
							$('.folderSortContainer').each(function(a){
								s[a]=new Array();
								$(this).find('.rptFolder').each(function(b){
									s[a][b]={
										folder_id:$(this).attr('folder_id'),
										col_id:$(this).parent().attr('id')
									};
								});
							});
							
							//serialize and send
							$.ajax({
								data:{json:$.toJSON(s)},
								dataType:'json',
								success:function(){
									//nothing to do here
								},
								type:'POST',
								url:'async_rptBldr_saveFolderOrder.cfm'
							});
						}
					}).disableSelection();
					
					//SORTABLE REPORTS
					$('.folderContainer').sortable({
						//containment:'parent',
						handle:'.dragGrip',
						items:'.reportContainer',
						connectWith:'.folderContainer',
						update:function(e,ui){
							
							var s=new Array();
							s[0]={};
							s[0].folder_id=$(ui.item).parent().parent().attr('folder_id');
							//loop over reports in folder
							s[0].reports=new Array();
							$('.rptFolder[folder_id='+s[0].folder_id+'] .reportContainer').each(function(i){
								s[0].reports[i]=$(this).find('.menuTrigger').attr('report_id');
							});
							
							//if sender is present in ui, serialize that too
							if(ui.sender)
							{
								s[1]={};
								s[1].folder_id=$(ui.sender).parent().attr('folder_id');
								//loop over reports in folder
								s[1].reports=new Array();
								$('.rptFolder[folder_id='+s[1].folder_id+'] .reportContainer').each(function(i){
									s[1].reports[i]=$(this).find('.menuTrigger').attr('report_id');
								});
							}
							
							
							
							//store to db
							$.ajax({
								data:{json:$.toJSON(s)},
								dataType:'json',
								success:function(){
									//nothing to do here
								},
								type:'POST',
								url:'async_rptBldr_saveReportOrder.cfm'
							});
						}
					});
					
					//SAVE REPORT POPUP
					$("##saveRptLink").fancybox({
						centerOnScroll:true,
						hideOnContentClick:false,
						frameWidth:600,
						frameHeight:200,
						itemArray:['one','two'],
						callbackOnStart:function(a){
							$('##fancy_inner iframe').css('display','none');
						},
						callbackOnShow:function(a,b){
							$(b).find('input[name=txtName]').val($('##saveRptPopup input[name=txtName]').val());
							$(b).find('input[name=txtDesc]').val($('##saveRptPopup input[name=txtDesc]').val());
							$(b).find('input[name=report_id]').val($('##saveRptPopup input[name=report_id]').val());
							$(b).find('select[name=selFolder] option[value='+$('##saveRptPopup select[name=selFolder] option:selected').val()+']').attr('selected','selected');
						}
					});
					
					//FOLDER EDIT POPUP
					$("##folderSettingsLink").fancybox({
						centerOnScroll:true,
						hideOnContentClick:false,
						frameWidth:600,
						frameHeight:175,
						itemArray:['one','two'],
						callbackOnStart:function(a){
							$('##fancy_inner iframe').css('display','none');
						},
						callbackOnShow:function(a,b){
							$(b).find('input[name=txtName]').val($('##folderSettingsPopup input[name=txtName]').val());
							$(b).find('input[name=folder_id]').val($('##folderSettingsPopup input[name=folder_id]').val());
							$(b).find('form[name=folderForm]').validate({
								rules:{
									txtName:{
										remote:{
											url:'async_validate_new_folder.cfm',
											type:'post',
											data:{
												organization_id:,
												folder_id:$(b).find('input[name=folder_id]').val()
											}
										},
										required:true
									}
								},
								messages:{
									txtName:{
										remote:'The folder name must be unique',
										required:'Folder name is required'
									}
								}
								
							});
						}
					});
					
					//FOLDER DELETE
					$('.rptFolder h3 .ui-icon-trash').click(function(){
						//confirm removal
						if(confirm('Are you sure you want to remove this folder?  All reports inside will be moved to the General Reports folder'))
						{
							$.ajax({
								cache:false,
								data:{
									folder_id:$(this).parent().parent().attr('folder_id')
								},
								dataType:'json',
								error:function(r, s, e){
								},
								success:function(d, s){
									//reload page
									window.location.reload();
									
								},
								type:'POST',
								url:'async_rptBldr_folder_remove.cfm'
							});
						}
					});
					
					//FOLDER EDIT
					$('.rptFolder h3 .ui-icon-wrench').click(function(){
						$('##folderSettingsPopup input[name=txtName]').val($.trim($(this).parent().text()));
						$('##folderSettingsPopup input[name=folder_id]').val($(this).parent().parent().attr('folder_id'));
						$('##folderSettingsLink').click();
					});
					
					
					
					
				});
				
				function renameReport(report_id)
				{
					//ajax get details
					$.ajax({
						data:{
							report_id:report_id
						},
						dataType:'json',
						success:function(obj){
							$('##saveRptPopup input[name=txtName]').val(obj.name);
							$('##saveRptPopup input[name=txtDesc]').val(obj.desc);
							$('##saveRptPopup option[value='+obj.folder_id+']').attr('selected','selected');
							$('##saveRptPopup input[name=report_id]').val(report_id);
							$('##saveRptLink').click();
						},
						type:'GET',
						url:'async_rptBldr_getReportDetails.cfm'
					});
				}
				function closeFancybox()
				{
					$.fn.fancybox.close();
				}
				
				function saveReport()
				{
					//get vars
					var name=$('##fancy_content input[name=txtName]').val();
					var desc=$('##fancy_content input[name=txtDesc]').val();
					var report_id=$('##fancy_content input[name=report_id]').val();
					var folder_id=$('##fancy_content select[name=selFolder] option:selected').val();
					$.ajax({
						cache:false,
						data:{
							report_id:report_id,
							name:name,
							description:desc,
							folder_id:folder_id
						},
						dataType:'json',
						error:function(r, s, e){
						},
						success:function(d, s){
							//reload page
							//window.location.reload();
							var cur_folder_id=$('.menuTrigger[report_id='+report_id+']').closest('.rptFolder').attr('folder_id');
							if(cur_folder_id != folder_id)
								$('.rptFolder[folder_id='+folder_id+'] .folderContainer').append($('.menuTrigger[report_id='+report_id+']').closest('.reportContainer'));
								
							$('.menuTrigger[report_id='+report_id+']').parent().find('.reportName').text(name);
							$('.menuTrigger[report_id='+report_id+']').parent().find('.reportDesc').text(desc);
						},
						type:'POST',
						url:'async_rptBldr_save_action.cfm'
					});
					
					//close box
					closeFancybox();
					
					
				}
				
				function saveFolder()
				{
				
				
					//validate form
					if($('##fancy_content form[name=folderForm]').valid())
					{
				
				
						//get vars
						var name=$('##fancy_content input[name=txtName]').val();
						var folder_id=$('##fancy_content input[name=folder_id]').val();
						$.ajax({
							cache:false,
							data:{
								name:name,
								folder_id:folder_id
							},
							dataType:'json',
							error:function(r, s, e){
							},
							success:function(d, s){
								//reload page
								window.location.reload();
								
							},
							type:'POST',
							url:'async_rptBldr_folder_edit_action.cfm'
						});
						
						//close box
						closeFancybox();
						
					}
				}
				
				function deleteReport(report_id)
				{
				
					var promptText='<h3>Delete Report</h3>Are you sure you want to delete this report?<br><br>Name:'+$("##report_"+report_id+" td:eq(1) a").text();
					
			
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
									$.ajax({
										cache:false,
										data:{
											report_id:report_id
										},
										dataType:'json',
										error:function(r, s, e){
											$.prompt.goToState('failState');
										},
										success:function(d, s){
											if(d.status == 'success')
											{
												//remove row
												$("##report_"+report_id).fadeOut(500,function(){$(this).remove()});
												$.prompt.goToState('successState');
											}
											else
												$.prompt.goToState('failState');
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
					
					$.prompt.setDefaults({
						prefix: 'brownJqi',
						show: 'slideDown',
						overlayspeed:0.1,
						promptspeed:0.1
					}); 
					
					$.prompt(promptStates);
					
					
					
				}
			</script>
			
		<script language="JavaScript1.3" type="text/javascript">
		function scbg(objRef, state) {
			objRef.style.backgroundColor = (1 == state) ? '##D3D8ED' : '##FFFFFF';
			return;
		}
		</script>
		<script language="JavaScript1.3" type="text/javascript">
		function scbg2(objRef, state) {
			objRef.style.backgroundColor = (1 == state) ? '##6661A7' : '##848BAF';
			return;
		}
		</script>
		<script language="JavaScript1.3" type="text/javascript">
		function scbg3(objRef, state) {
			objRef.style.backgroundColor = (1 == state) ? '##6661A7' : '##B0B1B3';
			return;
		}
		</script>
		</head>
</cfoutput>
<body>
<CFINCLUDE TEMPLATE="header_rptBldr.cfm">
<cfhtmlhead text="<title>Report Builder - Home</title>">
<div style="height:10px;width:auto;"> </div>
<cfoutput>

<table border="0" cellspacing="0" cellpadding="4" width="100%">
	<tr>
		<td class="mainhead" width="50%">Reports</td>
		<td class="mainhead" align="right" width="50%">
			<cfoutput>
				<input type="Button" class="itemformbuttonleft" onclick="location.href='rptBldr_folderAdd.cfm';" value="Add Folder">
				<input type="Button" class="itemformbuttonleft" onclick="location.href='rptBldr_context.cfm';" value="New Report">
			</cfoutput>
		</td>
	</tr>
</table>

<style type="text/css">
	.rptFolder{
		margin:10px;
		padding:2px 0;
	}
	.rptFolder h3.ui-state-active{
		margin:0px;
		padding:0px 5px;
		border:none;
		cursor:move;
	}
	.folderContainer{
		padding:5px;
	}
	.reportContainer{
		margin-bottom:10px;
	}
	.reportContainer .reportContainerHidden{
		display:none;
		font-size:.8em;
		margin-left:10px;
	}
	.menuTrigger{
		font-size:.8em;
		margin-right:5px;
		cursor:pointer;
	}
	.menuTrigger .ui-icon{
		float:left;
	}
	.sortPlaceholder{
		border:2px dashed gray;
		margin:10px;
	}
	.folderSortContainer{
		float:left;
		width:33%;
		min-height:50px;
	}
	##jqContextMenu .ui-icon{
		/*display:inline-block;
		vertical-align:bottom;*/
		float:left;
	}
	.rptFolder h3 .ui-icon{
		float:right;
		cursor:pointer;
		display:none;
	}
	.rptFolder h3:hover .ui-icon{
		display:block;
	}
	.dragGrip{
		float:right;
		cursor:move;
	}
	.reportName{
		margin-right:8px;
	}
	.reportDesc{
		font-size:.9em;
	}
</style>



<cfloop from="1" to="3" index="colnum">
	<div id="folderSortContainer#colnum#" class="folderSortContainer">
		<!--- get folders in column --->
		<cfquery dbtype="query" name="getColFolders">
			select * from getFolders
			where display_col=#colnum#
			order by seq
		</cfquery>
		<!--- loop over folders --->
		<cfloop query="getColFolders">
		<div class="rptFolder ui-corner-all ui-widget-content" folder_id="#getColFolders.folder_id#">
			<h3 class="ui-widget-header ui-state-active">
				<cfif removable>
					<span class="ui-icon ui-icon-trash" title="Delete"></span>
				</cfif>
				<cfif editable>
					<span class="ui-icon ui-icon-wrench" title="Edit"></span>
				</cfif>
				#getColFolders.name#
			</h3>
			<div class="folderContainer">
				<!--- loop over reports --->
				<cfquery dbtype="query" name="getFolderReports">
					select * from getReports
					where folder_id=#getColFolders.folder_id#
					order by seq
				</cfquery>
				<cfloop query="getFolderReports">
					<div class="reportContainer">
						<div>
							<div class="dragGrip"><span class="ui-icon ui-icon-grip-solid-horizontal"></span></div>
							<!--- <div style="float:right;">#dateformat(dateupdated,"m/d/yyyy")#</div> --->
							<span class="menuTrigger" report_id="#report_id#"><span class="ui-icon ui-icon-triangle-1-s"></span>Actions</span>
							<a class="reportName" title="Run report" href="rptBldr_display.cfm?report_id=#report_id#">#report_name#</a><span class="reportDesc">#report_desc#</span>
						</div>
						<!--- <div class="reportContainerHidden">
							
						</div> --->
					</div>
				</cfloop>
			</div>
		</div>
		</cfloop>
	</div>
</cfloop>



<div class="contextMenu" id="reportMenu">
	<ul>
		<!--- <li id="menuRun"><span class="ui-icon ui-icon-play"></span>Run</li> --->
		<li id="menuEdit"><span class="ui-icon ui-icon-wrench"></span>Edit</li>
		<li id="menuRename"><span class="ui-icon ui-icon-pencil"></span>Rename</li>
		<li id="menuDelete"><span class="ui-icon ui-icon-trash"></span>Delete</li>
		<li id="menuExport"><span class="ui-icon ui-icon-arrowreturnthick-1-e"></span>Export</li>
	</ul>
</div>


<a href="##saveRptPopup" id="saveRptLink" style="display:none;"></a>

<div id="saveRptPopup" style="display:none;">
	<h3>
		Save Report
	</h3>
	<input type="hidden" name="report_id">
	<table border="0" cellpadding="4" cellspacing="0" class="poptable">
		<tr>
			<td style="text-align:right; padding-bottom:5px;">
				<b>Name:</b>
			</td>
			<td>
				<input type="Text" name="txtName" value="" style="width:300px;">
			</td>
		</tr>
		<tr>
			<td style="text-align:right;">
				<b>Description:</b>
			</td>
			<td>
				<input type="Text" name="txtDesc" value="" style="width:300px;">
			</td>
		</tr>
		<tr>
			<td style="text-align:right;">
				<b>Folder:</b>
			</td>
			<td>
				<select name="selFolder">
					<cfloop query="getFolders">
						<option value="#folder_id#">#name#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
			<td style="padding-top:20px;">
				<input type="button" name="btnSave" value="Save" onclick="saveReport();"><input type="button" name="btnCancel" value="Cancel" onclick="closeFancybox();">
			</td>
		</tr>
	</table>
</div>


<a href="##folderSettingsPopup" id="folderSettingsLink" style="display:none;"></a>

<div id="folderSettingsPopup" style="display:none;">
	<h3>
		Rename Folder
	</h3>
	<form name="folderForm">
	<input type="hidden" name="folder_id">
	<table border="0" cellpadding="4" cellspacing="0" class="poptable">
		<tr>
			<td style="text-align:right; padding-bottom:5px;">
				<b>Name:</b>
			</td>
			<td>
				<input type="Text" name="txtName" value="" style="width:300px;">
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
			<td style="padding-top:20px;">
				<input type="button" name="btnSave" value="Save" onclick="saveFolder();"><input type="button" name="btnCancel" value="Cancel" onclick="closeFancybox();">
			</td>
		</tr>
	</table>
	</form>
</div>




<!--- <table border="0" cellspacing="0" cellpadding="0" class="generalTable">
	<tr>
		<th width="100">Action</th>
		<th width="300">Name</th>
		<th>Description</th>
		<th width="200">Last Update</th>
	</tr>
	<cfloop query="getReports">
	<tr id="report_#report_id#">
		<td><span class="bodylink"><a href="rptBldr_context.cfm?report_id=#report_id#" class="bodylink" title="Edit">Edit</a> | <a onclick="javascript:deleteReport(#report_id#);" class="bodylink" title="Delete">Del</a> | <a href="rptBldr_export.cfm?report_id=#report_id#" class="bodylink" title="Export">Export</a></span></td>
		<td><span class="bodylink"><a href="rptBldr_display.cfm?report_id=#report_id#" class="bodylink">#report_name#</a></span></td>
		<td><CFIF report_desc IS "">&nbsp;<CFELSE>#report_desc#</CFIF></td>
		<td>
			<cfif dateupdated NEQ "">
				#dateformat(dateupdated,"mm/dd/yyyy")#
			</cfif>
		</td>
	</tr>
	</cfloop>
</table> --->


<!--- End Requestors --->



</body>
</cfoutput>
</html>


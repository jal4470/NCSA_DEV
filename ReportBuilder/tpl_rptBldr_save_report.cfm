
<!--- get report name, desc --->
<cfquery datasource="#application.reports_dsn#" name="getReportName">
	select report_name, report_desc, saved_flag, folder_id from tbl_report
	where report_id=#report_id#
</cfquery>

<cfquery datasource="#application.reports_dsn#" name="getFolders">
	select folder_id, name
	from tbl_folder
	order by display_col, seq
</cfquery>




<!--- <input type="Button" name="btnSaveReport" value="Save" class="itemformbuttonleft"> --->

<a class="itemformbuttonleft" id="saveRptLink" href="#saveRptPopup">Save</a>
<span style="font-size:smaller; padding-right:5px; color:#BF4747;" id="rptSaveNotice">
<cfif getReportName.saved_flag EQ "0">
	*This report is not yet saved
</cfif>
</span>
<!--- import jquery, then rename to jq so not to conflict with a possibly previously imported jquery --->

<cfhtmlhead text="<script language=""JavaScript"" src=""assets/jquery.fancybox/jquery.fancybox-1.2.1.js""></script>">
<link rel="stylesheet" href="assets/jquery.fancybox/jquery.fancybox.css" type="text/css" media="screen">
<script language="JavaScript" type="text/javascript">
	
	
	$(function(){
		$("input[name=btnSaveReport]").click(saveReport);
		
		
			
		$("#saveRptLink").fancybox({
			centerOnScroll:true,
			hideOnContentClick:false,
			frameWidth:600,
			frameHeight:275,
			itemArray:['one','two'],
			callbackOnStart:function(a){
				$('#fancy_inner iframe').css('display','none');
			},
			callbackOnShow:function(a,b){
				$(b).find('input[name=txtName]').val($('#saveRptPopup input[name=txtName]').val());
				$(b).find('input[name=txtDesc]').val($('#saveRptPopup input[name=txtDesc]').val());
				$(b).find('select[name=selFolder] option[value='+$('#saveRptPopup select[name=selFolder] option:selected').val()+']').attr('selected','selected');
			}
		});
	});
	
	function closeFancybox()
	{
		$.fn.fancybox.close();
	}
	
	function saveReport()
	{
		//get vars
		var name=$('#fancy_content input[name=txtName]').val();
		var desc=$('#fancy_content input[name=txtDesc]').val();
		var folder_id=$('#fancy_content select[name=selFolder] option:selected').val();
		$.ajax({
			cache:false,
			data:{
				report_id:<cfoutput>#report_id#</cfoutput>,
				name:name,
				description:desc,
				folder_id:folder_id
			},
			dataType:'json',
			error:function(r, s, e){
				$('#rptSaveNotice').text('Report could not be saved').css('color','#BF4747').show();
				setTimeout('hideSaveNotice()',5000);
			},
			success:function(d, s){
				$('#rptSaveNotice').text('Report Saved!').css('color','#00bb00').show();
				setTimeout('hideSaveNotice()',5000);
				
				$('#saveRptPopup input[name=txtName]').attr('value',name);
				$('#saveRptPopup input[name=txtDesc]').attr('value',desc);
				$('#saveRptPopup select[name=selFolder] option[value='+folder_id+']').attr('selected','selected');
			},
			type:'POST',
			url:'async_rptBldr_save_action.cfm'
		});
		
		//close box
		closeFancybox();
		
		
	}
	
	function hideSaveNotice()
	{
		$('#rptSaveNotice').fadeOut(1000);
	}
</script>

<cfoutput>
	<div id="saveRptPopup" style="display:none;">
		<h3>
			Save Report
		</h3>
		
		<table border="0" cellpadding="4" cellspacing="0" class="poptable">
			<tr>
				<td style="text-align:right; padding-bottom:5px;">
					<b>Name:</b>
				</td>
				<td>
					<input type="Text" name="txtName" value="#getReportName.report_name#" style="width:300px;">
				</td>
			</tr>
			<tr>
				<td style="text-align:right;">
					<b>Description:</b>
				</td>
				<td>
					<input type="Text" name="txtDesc" value="#getReportName.report_desc#" style="width:300px;">
				</td>
			</tr>
			<tr>
				<td style="text-align:right;">
					<b>Folder:</b>
				</td>
				<td>
					<select name="selFolder">
						<cfloop query="getFolders">
							<option value="#folder_id#" <cfif getReportName.folder_id EQ getFolders.folder_id>selected="selected"</cfif>>#name#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td>
					&nbsp;
				</td>
				<td>
					<input type="button" name="btnSave" value="Save" onclick="saveReport();"><input type="button" name="btnCancel" value="Cancel" onclick="closeFancybox();">
				</td>
			</tr>
		</table>
	</div>
</cfoutput>
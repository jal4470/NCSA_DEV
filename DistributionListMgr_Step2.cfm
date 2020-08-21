<!--- Author: Joe Lechuga jlechuga@capturepoint.com
Purpose: Page 2 of Distribution List Creation
Changes:
	J.Lechuga 5/26/2010 Initial Revision
	J.Lechuga 8/17/2010 Added SerializeCriteria hidden input used to pass and identify data on post. Update SerializeCriteria function to include allow edits.

8/1/2017 - A.Pinzone - NCSA22821
-- Code cleanup & JS fixes.
 --->
<!----------------------------->
<!--- Application variables --->
<!----------------------------->
<cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock>

 <!--- validate login --->
 <cfmodule template="_checkLogin.cfm">
<!----------------------->
<!--- Local variables --->
<!----------------------->


<cfset report_type_id =form.reporttype>

<cfif isdefined("form.CriteriaEdits")>
	<cfset CriteriaEdit = 1>
<cfelse>
	<cfset CriteriaEdit = 0>
</cfif>

<!---------------->
<!--- Get data --->
<!---------------->
	<cfquery datasource="#reports_dsn#" name="getDateColumns">
	SELECT VIEW_COL_ID,
	       VIEW_COL_DISPLAY_LABEL
	  FROM v_report_columns
	 WHERE report_type_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_type_id#">
	   AND XTYPE IN (61,58)
	</cfquery>
	<cfquery name="getReportType" datasource="#reports_dsn#">
		select report_type_name from tbl_report_type where report_type_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report_type_id#">
	
	</cfquery>
	<!--- get all columns --->
	<cfquery datasource="#reports_dsn#" name="getColumns">
		select a.view_col_id,
			a.view_col_display_label,
			a.view_col_group_name,
			xtype,
			allow_lookup_flag
		from v_report_columns a
		where a.report_type_id = <cfqueryparam value="#report_type_id#">
		  and allow_select_flag = 1
		order by a.view_col_group_name,
			a.view_col_name
	</cfquery>
	
	<!--- get dynamic columns --->
	<cfquery datasource="#reports_dsn#" name="getDynamicCols">
		select b.view_id, b.view_name, b.view_name_fully_qualified, b.view_display_label, c.view_col_id, c.view_col_display_label, c.xtype, c.allow_lookup_flag
			from xref_report_type_view a
		inner join tbl_view b
			on a.view_id=b.view_id
		inner join tbl_view_column c
			on c.view_id=b.view_id
		where report_type_id=<cfqueryparam value="#report_type_id#">
			and view_type_id=2
	</cfquery>
	
	<!--- get operand values --->
	<cfquery datasource="#reports_dsn#" name="getOperands">
		select * from tlkp_operand
	</cfquery>
	
	<!--- get xtype categories --->
	<cfquery datasource="#reports_dsn#" name="getXtypes">
		select distinct xtype, dbo.convertXtypeToXtypeCategory(xtype) as category
		from tbl_view_column
	</cfquery>
	
	<cfquery datasource="#reports_dsn#" name="getDurations">
		select * from 
		v_date_range_options
		order by group_seq, item_seq
	</cfquery>
	
	<!--- set maximum characters in dropdown rows --->
	<cfset maxRowChars=40>

	<cfset date_view_col_id="">
	<cfset start_date="">
	<cfset end_date="">

<cfset mid = 4> 
<cfinclude template="_header.cfm">

<cfsavecontent variable="customCSS">
	<title>Distribution List Manager</title>
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#customCSS#">

<cfsavecontent variable="cf_footer_scripts">
	<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
	<script language="JavaScript" type="text/javascript" src="./ReportBuilder/assets/jquery.datepicker.min.js"></script>
	<script language="JavaScript" type="text/javascript" src="./ReportBuilder/assets/json.js"></script>
	<script language="JavaScript" type="text/javascript" src="./ReportBuilder/assets/jquery.selectboxes.min.js"></script>
	<script language="JavaScript" type="text/javascript">
	
	var currentLookup;
	
	$(document).ready(function()
	{
	
		$("select[name=duration]").change(function(){
			//get start and end dates
			$("input[name=start_date]").val($(this).find("option:selected").attr('startdate'));
			$("input[name=end_date]").val($(this).find("option:selected").attr('enddate'));
		});
		
		$("input[name=start_date], input[name=end_date]").change(function(){
			//select custom duration
			$("select[name=duration] option:first").attr('selected','selected');
		});
		$("a:contains('Remove')").hide();
		$("input[name=start_date], input[name=end_date]").datepicker();
		
		//add new filter row
		$("#addFilterLink").click(function(){
			//duplicate filter row
			$(this).parent().parent().before($("#base_criteriaRow").clone(true));
			$(this).parent().parent().prev().removeAttr('id');
			$(this).parent().parent().prev().find("input[type=text]").val('');
			$(this).parent().parent().prev().find("select[name=view_col_id] option:first").attr('selected','selected');
			$(this).parent().parent().prev().find("select[name=operand_id] option:first").attr('selected','selected');
			
			//show all operands
			showHideOperands($(this).parent().parent().prev().find("select[name=view_col_id]")[0]);
			$("a:contains('Remove')").show();
		});
		
		//column selected
		$("select[name=view_col_id]").change(function()
		{
			//call showHideOperands
			showHideOperands(this);
		});
		
		
		//next button clicked
		$("input[name=btnSubmit]").click(function()
		{
			$("input[name=btnClicked]").val('save');
			serializeCriteria();
		});
		
		//initially show/hide operands
		$("select[name=view_col_id]").each(function(){
			showHideOperands(this);
		});
		
		
		//trigger for lookup popup
		$(".lookupTrigger").click(function(e){
			triggerLookup(this, e);
		});
		
		
		//save lookup values
		$("#lookupPopup input[name=btnSave]").click(function(){
			//get values from all checked checkboxes and add to input box
			var valueString='';
			$("#lookupPopup input[type=checkbox]:checked").each(function(){
				if(valueString!= '')
					valueString=valueString+',';
				var thisVal = $(this).val();
				//find comma in string, if exists, surround with "
				if(thisVal.search(',') != -1)
				{
					thisVal='"'+thisVal+'"';
				}
				valueString=valueString+thisVal;
			});
			
			if(valueString != '')
			{
				//append to textbox
				var currentVal=$(currentLookup).parent().parent().find('input[type=text]').val();
				if(currentVal != '')
					currentVal=currentVal+',';
				$(currentLookup).parent().parent().find('input[type=text]').val(currentVal+valueString);
			}
			
			//close popup
			$("#lookupPopup").hide();
			
		});
		
		//cancel lookup
		$("#lookupPopup input[name=btnCancel]").click(function(){
			$("#lookupPopup").hide();
		});
		
		//remove criteria row
		$(".removeCriteriaRow").click(function(){
			//remove clicked row
			$(this).parent().parent().remove();
			var CRIndex = $(this).prevAll().length-1

			if(CRIndex == 1 )
			{
				$("a:contains('Remove')").hide();
			}
			else{
				$("a:contains('Remove')").show();
				}
		});
		
	});
	
	function showHideOperands(obj)
	{
		//obj is column dropdown that was changed
		
		
		<!--- build xtype category object --->
		var xtypeCat={
			<cfloop query="getXtypes">
				<cfoutput>#xtype#:'#category#'</cfoutput>
				<cfif currentRow NEQ recordcount>,</cfif>
			</cfloop>
		};
		
		
		//get xtype of obj
		var xtype=$(obj).find("option:selected").attr('xtype');
		var category=xtypeCat[xtype];
		
		var lookup=$(obj).find("option:selected").attr('allow_lookup_flag');
		
		var operandObj=$(obj).parent().next().find("select");
		var selectedValues=$(operandObj).selectedValues();
		$(operandObj).removeOption(/./);
		$("select[name=base_operand_id] option").each(function(){
			$(operandObj).addOption($(this).attr('value'),$(this).text());
		});
		
		$(operandObj).find("option[value="+selectedValues[0]+"]").attr('selected','selected');
		
		//hide operands
		if(category == 'N')//if xtype is number
		{
			//hide contains, does not contain, starts with
			$(operandObj).removeOption(['7','8','9','10','11']);
		}
		else if(category == 'D')//if xtype is date
		{
			//hide contains, does not contain, starts with
			$(operandObj).removeOption(['7','8','9','10','11']);
		}
		else if(category == 'T' && lookup == '0')//if xtype is text
		{
			//hide contains, does not contain, starts with
			$(operandObj).removeOption(['10','11']);
		}
		else if(lookup == '1')//if xtype is lookup
		{
			//hide contains, does not contain, starts with
			$(operandObj).removeOption(['3','4','5','6','7','8','9']);
		}
		
		//if the selected operand is now hidden, select the first one instead
		if($(operandObj).find("option[value="+selectedValues[0]+"]").length == 0)
		{
			$(operandObj).find("option:first").attr('selected','selected');
		}
		
		
		//show/hide lookup magnifier
		if(lookup == "1")
			$(obj).parent().parent().find(".lookupTrigger").css('visibility','visible');
		else
			$(obj).parent().parent().find(".lookupTrigger").css('visibility','hidden');
	}
	
	function triggerLookup(obj, e)
	{
		currentLookup=obj;
		
		//set img to spinner
		$(obj).attr('src','MessageManager/assets/images/loading.gif');
		
		//obj is the lookup image that was clicked
		var context_value='';
		var view_col_id=$(obj).parent().parent().find('select[name=view_col_id] option:selected').val();
		
		//get div html
		$.get('MessageManager/async_get_rptBldr_lookup_values.cfm',{
				context_value:context_value,
				view_col_id:view_col_id
			},
			function(a){
				$(obj).attr('src','MessageManager/assets/images/magnifier.gif');
				
				$("#lookupOptions").html(a);
				
				var offsetLeft = $(obj).position().left,
					offsetRight = ($(window).width() - (offsetLeft + $(obj).outerWidth())),
					offsetTop = $(obj).position().top + 20; // img height offset		
				
				//set popup position to mouse click position
				$('#lookupPopup').css({right:offsetRight,top:offsetTop}).show();
			},
			'html'
		);
		
	}
	
	function serializeCriteria()
	{
		//get criteria rows
		var criteria=new Array();
		$(".criteriaRow").each(function(i){
			var rowObj=new Object();
			rowObj.view_col_id=$(this).find("select[name=view_col_id] option:selected").val();
			rowObj.view_col_value=$(this).find("select[name=view_col_id] option:selected").attr('view_col_value');
			rowObj.operand_id=$(this).find("select[name=operand_id] option:selected").val();
			rowObj.value=$(this).find("input[type=text]").val();
			rowObj.AllowEdits=$(this).find("select[name=AllowEdits] option:selected").val();
			criteria[i]=rowObj;
		});
		
		$("input[name=serializedCriteria]").val($.toJSON(criteria));
		//document.forms[0].submit();
		
	}
	
	function submitFormAction()
	{
		//serialize form and submit
		serializeCriteria();
		return true;
	}



	</script>
</cfsavecontent>	

<div id="contentText">
	<H1 class="pageheading">Distribution List Manager Step 2</H1>
	<hr>
	
		<cfoutput>
		<form method="post" action="DistributionListMgr_action.cfm" onclick="return submitFormAction();">
		<input type="hidden" name="report_type_id" value="#report_type_id#">
		<input type="hidden" name="distributionListName" value="#form.DistributionListName#">
		<input type="hidden" name="CriteriaEdit" value="#CriteriaEdit#">
		<input type="Hidden" name="btnClicked">
		<input type="hidden" name="serializedCriteria">
		</cfoutput>
		<table border="0" cellspacing="0" cellpadding="3" width="848">
			<!--- Section label --->
			<!--- Spacer row --->
			<tr>
				 <cfoutput><td colspan="5">Filter criteria For Distribution List <strong><u>#form.DistributionListName#</u></strong> for the <strong><u>#getReportType.report_type_name#</u></strong> Report Type</td></cfoutput>
			</tr>
				<tr class="criteriaRow">
					<td>
						<!--- column select --->
						<select name="view_col_id" >
							<option value="" view_col_value="">-- None --</option>
							<cfoutput query="getColumns" group="view_col_group_name">
								<optgroup label="#view_col_group_name#">
									<cfoutput>
										<option value="#view_col_id#" xtype="#xtype#" view_col_value="" allow_lookup_flag="#allow_lookup_flag#">#left(view_col_display_label,maxRowChars)#</option>
									</cfoutput>
								</optgroup>
							</cfoutput>
							<cfoutput query="getDynamicCols">
								<!--- get columns --->
								<cfinvoke
									<!--- webservice="#application.crs_api_path#/report.cfc?wsdl" --->
									component="clients.ncsa.messagemanager.report"
									method="getDynamicViewData"
									view_Id="#view_id#"
									context_value="#getreport.context_value#"
									returnvariable="dynData">
								<cfif dyndata.recordcount GT 0>
									<optgroup label="#getDynamicCols.view_display_label#">
										<cfloop query="dyndata">
											<option value="#getdynamiccols.view_col_id#" view_col_value="#view_col_id#" xtype="#getdynamiccols.xtype#" allow_lookup_flag="#getdynamiccols.allow_lookup_flag#">
												<cfif len(view_col_display_label) GT maxRowChars>
													#left(view_col_display_label,maxRowChars/2)#...#right(view_col_display_label,maxRowChars/2)#
												<cfelse>
													#view_col_display_label#
												</cfif>
											</option>
										</cfloop>
									</optgroup>
								</cfif>
							</cfoutput>
						</select>
					</td>
					<td>
						<!--- operand select --->
						<select name="operand_id">
							<cfoutput query="getOperands">
								<option value="#operand_id#">#operand_desc#</option>
							</cfoutput>
						</select>
					</td>
					<td>
						<!--- value input --->
						<input type="text" name="value" size="40"><img class="lookupTrigger" src="MessageManager/assets/images/magnifier.gif" style="vertical-align:top; margin-left:3px; width:20px; cursor:pointer;"> <a href="javascript:void(0);" class="bodylink removeCriteriaRow">Remove</a> &nbsp;&nbsp;Allow Edits:<select name="AllowEdits"><option value="0">No</option><option value="1">Yes</option></select>
					</td>
				</tr>
			<!--- </cfif> --->
			<tr>
				<td colspan="3">
					<a id="addFilterLink" class="bodylink" href="javascript:void(0);">Add Filter</a>
				</td>
			</tr>
			<!--- Spacer row --->
			<tr>
				<td colspan="5"><hr/></td>
			</tr>
			<tr>
				<td colspan="5" align="center"><input type="Submit" value="Save"  ></td>
			</tr>
		</table>
		<!--- BUTTONS --->
		

		</form>
		
		<!--- used for cloning operand select.  IE cannot hide options, so must remove them and re-add as necessary --->
		<div style="display:none;">
		<select name="base_operand_id">
			<cfoutput query="getOperands">
				<option value="#operand_id#">#operand_desc#</option>
			</cfoutput>
		</select>
		</div>
		
		<!--- base criteriaRow: used for cloning when adding a new criteria row --->
		<div style="display:none;">
		<table>
			<tr id="base_criteriaRow" class="criteriaRow">
				<td>
					<!--- column select --->
					<select name="view_col_id" id="view_col_id">
						<option value="" view_col_value="">-- None --</option>
						<cfoutput query="getColumns" group="view_col_group_name">
							<optgroup label="#view_col_group_name#">
								<cfoutput>
									<option value="#view_col_id#" xtype="#xtype#" view_col_value="" allow_lookup_flag="#allow_lookup_flag#">#left(view_col_display_label,maxRowChars)#</option>
								</cfoutput>
							</optgroup>
						</cfoutput>
					
						<cfoutput query="getDynamicCols">
							<!--- get columns --->
							<cfinvoke
								<!--- webservice="#application.crs_api_path#/report.cfc?wsdl" --->
								component="clients.ncsa.messagemanager.report"
								method="getDynamicViewData"
								view_Id="#view_id#"
								context_value="#getreport.context_value#"
								returnvariable="dynData">
							
							<cfif dyndata.recordcount GT 0>
								<optgroup label="#getDynamicCols.view_display_label#">
									<cfloop query="dyndata">
										<option value="#getdynamiccols.view_col_id#" view_col_value="#view_col_id#" xtype="#getdynamiccols.xtype#" allow_lookup_flag="#getdynamiccols.allow_lookup_flag#">
											<cfif len(view_col_display_label) GT maxRowChars>
												#left(view_col_display_label,maxRowChars/2)#...#right(view_col_display_label,maxRowChars/2)#
											<cfelse>
												#view_col_display_label#
											</cfif>
										</option>
									</cfloop>
								</optgroup>
							</cfif>
						</cfoutput>
					</select>
				</td>
				<td>
					<!--- operand select --->
					<select name="operand_id">
						<cfoutput query="getOperands">
							<option value="#operand_id#">#operand_desc#</option>
						</cfoutput>
					</select>
				</td>
				<td>
					<!--- value input --->
					<input type="text" name="value" size="40"><img class="lookupTrigger" src="MessageManager/assets/images/magnifier.gif" style="vertical-align:top; margin-left:3px; width:20px; cursor:pointer;"> <a href="javascript:void(0);" id="RemoveLink" class="bodylink removeCriteriaRow">Remove</a>  &nbsp;&nbsp;Allow Edits:<select name="AllowEdits"><option value="0">No</option><option value="1">Yes</option></select>
				</td>
			</tr>
			</table>
		</div>
		
		<!--- popup for displaying lookup values --->
		<div id="lookupPopup" style="position:absolute; background-color:#aaaaaa; border:2px solid #666666; padding:10px; display:none;">
				<input type="Button" name="btnSave" value="Save"> <input type="button" name="btnCancel" value="Cancel">
				<div id="lookupOptions" style="margin-bottom:15px;">
			
			     </div>
		
		</div>
</DIV>

<cfinclude template="_footer.cfm">
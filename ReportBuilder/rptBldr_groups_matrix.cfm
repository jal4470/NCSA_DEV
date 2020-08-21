<!----------------------------->
<!--- Application variables --->
<!----------------------------->
<cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock>

<!--- Security --->
<cfinclude template="_secureme.cfm">

<!----------------------->
<!--- Local variables --->
<!----------------------->
<cfif isdefined("url.report_id")>
	<cfset report_id = url.report_id>
<cfelseif isdefined("form.report_id")>
	<cfset report_id = form.report_id>
<cfelse>
	<cfset report_id = "">
</cfif>


<!---------------->
<!--- Get data --->
<!---------------->
<!--- <cftry> --->
<cfquery datasource="#reports_dsn#" name="getReport">
	select report_name,
		report_type_id,
		context_value,
		report_format_id
	from tbl_report
	where report_id = <cfqueryparam value="#report_id#">
</cfquery>




<!--- get column list --->
<CFSTOREDPROC datasource="#reports_dsn#" procedure="p_get_report_columns_for_matrix" returncode="YES" >
	<CFPROCRESULT name="getRowGroups" RESULTSET="1">
	<CFPROCRESULT name="getColGroups" RESULTSET="2">
	<CFPROCRESULT name="getTotCols" RESULTSET="3">
	<CFPROCRESULT name="getRemainingCols" RESULTSET="4">
	<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#report_id#" DBVARNAME="@report_id">
</CFSTOREDPROC>
<!--- 
<cfdump var=#getRowGroups# expand="No" label="row groups">
<cfdump var=#getColGroups# expand="No" label="col groups">
<cfdump var=#gettotcols# expand="No" label="tot cols">
<cfdump var=#getremainingcols# expand="No" label="remaining columns">
 --->

<cfquery datasource="#reports_dsn#" name="getGroupFormats">
	select * from tlkp_report_group_format
</cfquery>


<!--- <cfdump var=#getdynamicCols#> --->
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
	<head>
		<link  href="_rptBldr_style.css" type="text/css" media="print,screen" rel="stylesheet" >
		<link  href="assets/theme/jquery-ui-1.7.2.custom.css" type="text/css" media="print,screen" rel="stylesheet" >
		<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
		<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.7.2.custom.min.js"></script>
		<script language="JavaScript" type="text/javascript" src="assets/json.js"></script>
		<script language="JavaScript" type="text/javascript">
			var currentCol;
			$(function(){
			
				//make things draggable
				$("#colHolder,#colGroupHolder,#rowGroupHolder,#totGroupHolder").sortable({
					connectWith:$("#colHolder,#colGroupHolder,#rowGroupHolder,#totGroupHolder"),
					forcePlaceholderSize:true,
					placeholder:'ui-state-highlight ui-corner-all',
					stop:recalculateFields
				}).disableSelection();
				$('#colGroupHolder,#rowGroupHolder').bind('sortreceive', function(event, ui) {
					if($(this).find('li').length > 3)
					{
						alert('You cannot drop more than 3 items here');
						$(ui.sender).sortable('cancel');
					}
					else
					{
						var props=$.parseJSON($(ui.item).attr('id'));
						//if xtype is date, popup date format selector
						if(props.xtypeCat == 'D')
						{
							currentCol=ui.item;
							popupDateDialog();
							
						}
					}
				});
				
				$('#totGroupHolder').bind('sortreceive', function(event, ui){
				
					var props=$.parseJSON($(ui.item).attr('id'));
					if(props.allow_aggr_flag == '1')
					{
						currentCol=ui.item;
						popupAggrDialog();
					}
				});
				
				$(".dateTrigger").click(function(){
					currentCol=$(this).parent();
					popupDateDialog();
				});
				
				$(".aggrTrigger").click(function(){
					currentCol=$(this).parent();
					popupAggrDialog();
				});
				
				$("#datePopup").dialog({
					autoOpen:false,
					buttons:{
						'Ok':function(){
							//close
							$(this).dialog('close');
						}
					},
					modal:true,
					title:'Group Dates By',
					close:function(){
						//save chosen value
						var props=$.parseJSON($(currentCol).attr('id'));
						props.report_group_format_id=$("#datePopup select option:selected").val();
						$(currentCol).attr('id',$.toJSON(props));
						
						recalculateFields();
					}
				});
				
				$("#aggrPopup").dialog({
					autoOpen:false,
					buttons:{
						'Ok':function(){
							//close
							$(this).dialog('close');
						}
					},
					modal:true,
					title:'Select Totals',
					close:function(){
						//save chosen value
						var props=$.parseJSON($(currentCol).attr('id'));
						props.count_flag=$("#aggrPopup input[value=count]").is(":checked");
						props.sum_flag=$("#aggrPopup input[value=sum]").is(":checked");
						props.avg_flag=$("#aggrPopup input[value=avg]").is(":checked");
						props.min_flag=$("#aggrPopup input[value=min]").is(":checked");
						props.max_flag=$("#aggrPopup input[value=max]").is(":checked");
						$(currentCol).attr('id',$.toJSON(props));
						
						recalculateFields();
					}
				});
				
			
			});
			
			function recalculateFields()
			{
				//recalculate fields
				var colFields=[];
				$("#colGroupHolder li").each(function(i){
					colFields[i]=$.parseJSON($(this).attr('id'));
				});
				$("input[name=col_fields]").val($.toJSON(colFields));
				var rowFields=[];
				$("#rowGroupHolder li").each(function(i){
					rowFields[i]=$.parseJSON($(this).attr('id'));
				});
				$("input[name=row_fields]").val($.toJSON(rowFields));
				var totFields=[];
				$("#totGroupHolder li").each(function(i){
					totFields[i]=$.parseJSON($(this).attr('id'));
				});
				$("input[name=tot_fields]").val($.toJSON(totFields));
			
			}
			
			function popupDateDialog()
			{
				var props=$.parseJSON($(currentCol).attr('id'));
				if(props.report_group_format_id)
					$("#datePopup select option[value="+props.report_group_format_id+"]").attr('selected','selected');
				else
					$("#datePopup select option:first").attr('selected','selected');
				//popup
				$("#datePopup").dialog('open');
			}
			
			function popupAggrDialog()
			{
				var props=$.parseJSON($(currentCol).attr('id'));
				if(props.count_flag)
					$("#aggrPopup input[value=count]").attr('checked','checked');
				else
					$("#aggrPopup input[value=count]").attr('checked','');
				if(props.sum_flag)
					$("#aggrPopup input[value=sum]").attr('checked','checked');
				else
					$("#aggrPopup input[value=sum]").attr('checked','');
				if(props.avg_flag)
					$("#aggrPopup input[value=avg]").attr('checked','checked');
				else
					$("#aggrPopup input[value=avg]").attr('checked','');
				if(props.min_flag)
					$("#aggrPopup input[value=min]").attr('checked','checked');
				else
					$("#aggrPopup input[value=min]").attr('checked','');
				if(props.max_flag)
					$("#aggrPopup input[value=max]").attr('checked','checked');
				else
					$("#aggrPopup input[value=max]").attr('checked','');
					
				$("#aggrPopup").dialog('open');
			}
		</script>
		
		<style type="text/css">
			.dragContainer{
				height:18px;
				margin:3px 3px 3px;
				padding:0.4em 0.4em 0.4em 1.5em;
				position:relative;
			}
			.dropZone{
				overflow-y:auto;
				overflow-x:hidden;
				list-style-type:none;
				margin:0;
				padding:0;
				width:60%;
			}
			.dragContainer span{
				margin-left:-1.3em;
				position:absolute;
			}
			.ui-state-highlight{
				height:18px;
				margin:3px 3px 3px;
				padding:0.4em 0.4em 0.4em 1.5em;
			}
			#colGroupHolder{
				background:#FF7F7F url('assets/images/colDropBG.gif') no-repeat center;
			}
			#rowGroupHolder{
				background:#7F7FFF url('assets/images/rowDropBG.gif') no-repeat center;
			}
			#totGroupHolder{
				background:#EEEEEE url('assets/images/totDropBG.gif') no-repeat center;
			}
			
			.dateTrigger,.aggrTrigger{
				cursor:pointer;
			}
		</style>

	</head>
	<body>
	
	<CFINCLUDE TEMPLATE="header_rptBldr.cfm">
	<cfhtmlhead text="<title>Report Builder - Setup Report</title>">
	<div style="height:10px;width:auto;"> </div>
	
	<cfoutput>
		<form method="post" action="rptBldr_groups_matrix_action.cfm?s=#securestring#">
		<input type="hidden" name="report_id" value="#report_id#">
	</cfoutput>
		
	
	<cfset stepnum=8>
	<cfinclude template="tpl_rptBldr_head.cfm">
	
		
		<input type="Hidden" name="row_fields">
		<input type="Hidden" name="col_fields">
		<input type="Hidden" name="tot_fields">
		<cfoutput>
			<table border="0" cellpadding="0" cellspacing="3">
				<tr>
					<td height="130"><img src="assets/images/matrixSample.gif"></td>
					<td valign="top">
						<ul id="colGroupHolder" class="dropZone ui-corner-all" style="height:130px; width:300px; border:1px solid gray;">
							<cfloop query="getColGroups">
								<li class="dragContainer ui-state-default ui-corner-all" id="{view_col_id:'#view_col_id#',view_col_value:'#view_col_value#',xtypeCat:'#xtype_cat#',report_group_format_id:'#report_group_format_id#',allow_aggr_flag:'#allow_aggr_flag#'}">
									<span class="ui-icon ui-icon-arrow-4"></span>#label#
									<cfif xtype_cat EQ "D">
										<span class="ui-icon ui-icon-clock dateTrigger" style="right:0; top:0"></span>
									</cfif>
									<cfif allow_aggr_flag EQ "1">
										<span class="ui-icon ui-icon-newwin aggrTrigger" style="right:0; top:0"></span>
									</cfif>
								</li>
							</cfloop>
						</ul>
					</td>
					<td valign="top" rowspan="2">
						<ul id="colHolder" class="dropZone ui-corner-all ui-widget-content" style="width:300px; border:1px solid gray; min-height:130px;">
							<!--- place available columns --->
							<cfloop query="getRemainingCols">
								<li class="dragContainer ui-state-default ui-corner-all" id="{view_col_id:'#view_col_id#',view_col_value:'#view_col_value#',xtypeCat:'#xtype_cat#',allow_aggr_flag:'#allow_aggr_flag#'}">
									<span class="ui-icon ui-icon-arrow-4"></span>#label#
									<cfif xtype_cat EQ "D">
										<span class="ui-icon ui-icon-clock dateTrigger" style="right:0; top:0"></span>
									</cfif>
									<cfif allow_aggr_flag EQ "1">
										<span class="ui-icon ui-icon-newwin aggrTrigger" style="right:0; top:0"></span>
									</cfif>
								</li>
							</cfloop>
						</ul>
					</td>
				</tr>
				<tr>
					<td valign="top">
						<ul id="rowGroupHolder" class="dropZone ui-corner-all" style="height:130px; width:300px; border:1px solid gray;">
							<cfloop query="getRowGroups">
								<li class="dragContainer ui-state-default ui-corner-all" id="{view_col_id:'#view_col_id#',view_col_value:'#view_col_value#',xtypeCat:'#xtype_cat#',report_group_format_id:'#report_group_format_id#',allow_aggr_flag:'#allow_aggr_flag#'}">
									<span class="ui-icon ui-icon-arrow-4"></span>#label#
									<cfif xtype_cat EQ "D">
										<span class="ui-icon ui-icon-clock dateTrigger" style="right:0; top:0"></span>
									</cfif>
									<cfif allow_aggr_flag EQ "1">
										<span class="ui-icon ui-icon-newwin aggrTrigger" style="right:0; top:0"></span>
									</cfif>
								</li>
							</cfloop>
						</ul>
					</td>
					<td valign="top">
						<ul id="totGroupHolder" class="dropZone ui-corner-all" style="height:130px; width:300px; border:1px solid gray;">
							<cfloop query="getTotCols">
								<li class="dragContainer ui-state-default ui-corner-all" id="{view_col_id:'#view_col_id#',view_col_value:'#view_col_value#',xtypeCat:'#xtype_cat#',allow_aggr_flag:'#allow_aggr_flag#',count_flag:#count_flag#,sum_flag:#sum_flag#,avg_flag:#avg_flag#,min_flag:#min_flag#,max_flag:#max_flag#}">
									<span class="ui-icon ui-icon-arrow-4"></span>#label#
									<cfif xtype_cat EQ "D">
										<span class="ui-icon ui-icon-clock dateTrigger" style="right:0; top:0"></span>
									</cfif>
									<cfif allow_aggr_flag EQ "1">
										<span class="ui-icon ui-icon-newwin aggrTrigger" style="right:0; top:0"></span>
									</cfif>
								</li>
							</cfloop>
						</ul>
					</td>
				</tr>
			</table>
		</cfoutput>
	
		<!--- BUTTONS --->
		
		<cfinclude template="tpl_rptBldr_foot.cfm">
		
		<cfoutput>
			<!--- popups --->
			<div id="datePopup">
				<select id="selDateFormat">
					<cfloop query="getgroupformats">
						<option value="#report_group_format_id#">#report_group_format_desc#</option>
					</cfloop>
				</select>
			</div>
			<div id="aggrPopup">
				<table>
					<tr>
						<td align="right">Count:</td>
						<td><input type="Checkbox" name="chkAggr" value="count"></td>
					</tr>
					<tr>
						<td align="right">Sum:</td>
						<td><input type="Checkbox" name="chkAggr" value="sum"></td>
					</tr>
					<tr>
						<td align="right">Average:</td>
						<td><input type="Checkbox" name="chkAggr" value="avg"></td>
					</tr>
					<tr>
						<td align="right">Largest Value:</td>
						<td><input type="Checkbox" name="chkAggr" value="max"></td>
					</tr>
					<tr>
						<td align="right">Smallest Value:</td>
						<td><input type="Checkbox" name="chkAggr" value="min"></td>
					</tr>
				</table>
			</div>
		</cfoutput>
	</body>
</html>


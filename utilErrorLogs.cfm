<!--- 
	FileName:	utilErrorLogs.cfm
	Created on: 10/10/2017
	Created by: rgonzalez@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<style>
	#error_table {
       table-layout: fixed;
       width: 100%; }
   
   #error_table tr {
       border: 1px solid #d1d1d1;
       border-radius: 2px 10px;
 
       padding: 5px;
       width: 100%; }
     #error_table tr:after {
       clear: both;
       content: '';
       display: block; }
   
    #error_table th {
       background: transparent;
       border-top: 1px solid #AEAEAE;
 
       text-transform: uppercase;
     }

     /*///////////////////////////////////
	  MODAL POPUP
	///////////////////////////////////*/
	.modal {
		background: #fff;
		border-radius: 2px 10px;
		margin: 0;
		max-width: 700px;
		overflow:hidden;
		padding: 20px;
		position: fixed;
		top: -100%; left: 50%;
		text-align: left;
		transform: translateX(-50%);
		-ms-transform: translateX(-50%);
		-webkit-transform: translateX(-50%);
		transition: .5s top ease;
		width: 90%;
		z-index: 1001; 
		font-size: 1.1em;}
	.modal.active {
		top: 15%; }

	.modal h2 {
		color: #9a8206;
		font-size: 1.2em;
		padding-bottom: 5px;
		text-transform: uppercase; }
	.modal h3 {
		color: #555;
		font-size: .875em; }

	.clearfix:after {
		content: " "; /* Older browser do not support empty content */
		visibility: hidden;
		display: block;
		height: 0;
		clear: both;
	}

	#error_close,#error_details{
		cursor: pointer;
	}

	.title{
		font-weight: bold;
		display: inline-block;
		width: 20%;
	}

	/*.table{
		display: block;
		width: 550px;
	}

	.table_row{
		display: block;
	}

	.table_cell{
		display: block;
		border-bottom: 1px solid;
		border-color: #cccccc;
		padding: 5px;
	}*/
	.ellipsis{
		overflow: hidden;
		text-overflow: ellipsis;
		-o-text-overflow: ellipsis;
		white-space: nowrap;
		width: 100%;
	}

	.short_text{
		display: inline-block;
	}

	.long_text{
		word-wrap: break-word;
		line-height: 1.3em;
		margin-left: 5%;
	}

	.divUnderlinePadding{
		border-bottom: 1px solid;
		border-color: #cccccc;
		padding: 5px 0;
	}

	.dataDiv{
		max-height: 480px;
		overflow: auto;
	}

	.columnHeader{
		text-align: center;
		display: inline-block;
		font-weight: bold;
		font-size: 1.1em;
	}

	.columnData{
		text-align: center;
		display: inline-block;
	}
</style>
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Error Message Logs </H1>

<cfif isDefined("FORM.WeekendFrom")>
	<cfset WeekendFrom = dateFormat(FORM.WeekendFrom,"mm/dd/yyyy") > 
<cfelse>
	<cfset WeekendFrom   = dateFormat(dateAdd("d",-1,now()),"mm/dd/yyyy") >
</cfif>

<cfif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo   = dateFormat(FORM.WeekendTo,"mm/dd/yyyy") >
<cfelse>
	<cfset WeekendTo   = dateFormat(now(),"mm/dd/yyyy") >
</cfif>

<cfif isDefined("FORM.sortBy")>
	<cfset sortBy = FORM.sortBy>
<cfelse>
	<cfset sortBy = "">
</cfif>

<cfset errMsg = "">

<cfif isDefined("FORM.GO")>
	<cfset weekendtoPlus1 = dateFormat(dateAdd("d",1,VARIABLES.WeekendTo),"mm/dd/yyyy") >
	<cfquery name="qErrorLogs" datasource="#SESSION.DSN#">
		SELECT error_log_id, contact_id, username, session_id, url, file_name, error_msg, error_detail, line_number, browser, datecreated
		FROM tbl_app_error_log
		WHERE (	datecreated >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#">
		AND datecreated <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.weekendtoPlus1#">
				)
		ORDER BY datecreated DESC
			<cfswitch expression="#VARIABLES.sortBy#">
				<cfcase value="contact_id">
					,contact_id ASC
				</cfcase>
				<cfcase value="username">
					,username ASC
				</cfcase>
				<cfcase value="url">
					,url ASC
				</cfcase>
				<cfcase value="file_name">
					,file_name ASC
				</cfcase>
				<cfdefaultcase>
					,datecreated DESC
				</cfdefaultcase>
			</cfswitch> 
	</cfquery>
</cfif>

<FORM name="errorlog" action="utilErrorLogs.cfm"  method="post">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%" >
	<TR><TD align="left">
			<B>From</B> &nbsp;
				<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9"> 
			#repeatString("&nbsp;",3)#
			<B>To</B> &nbsp;
				<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
			#repeatString("&nbsp;",3)#
			<b>Sort</b>
				<SELECT name="sortBy"> 
					<OPTION value="contact_id"  	<cfif sortBy EQ "contact_id" >	selected</cfif> >Contact ID   </OPTION>
					<OPTION value="username"		<cfif sortBy EQ "username" > 	selected</cfif> >Username</OPTION>
					<OPTION value="url"		<cfif sortBy EQ "url" > 		selected</cfif> >URL</OPTION>
					<!--- <OPTION value="file_name"   	<cfif sortBy EQ "file_name"  >	selected</cfif> >File Name</OPTION> --->
				</SELECT>

			#repeatString("&nbsp;",3)#
			<input type="SUBMIT" name="Go"  value="Go" >  
		</td>
	</tr>

	<cfif len(trim(errMsg))>
		<tr><td colspan="1" align="center">
				<span class="red"><b>#VARIABLES.errMsg#</b></span>
			</td>
		</tr>
	</cfif>

</table>	
</FORM>

<cfset ctLoop	= 0>

<CFIF IsDefined("qErrorLogs")>
	<cfif qErrorLogs.RecordCount GT 0>

		<div id="error_table" style="width: 100%;">
			<hr>
			<div>
				<div class="columnHeader" style="width:16%;">Date</div>
				<div class="columnHeader" style="width:12%;">Contact ID</div>
				<div class="columnHeader" style="width:18%;">Username</div>
    			<div class="columnHeader" style="width:26%;">URL</div>
   	 			<div class="columnHeader" style="width:26%;">Error Message</div>
			</div>
			
			<cfloop query="qErrorLogs">
				<cfset ctLoop = ctLoop + 1>
				<cfset classValue = "class='divUnderlinePadding'">

				<hr>
				<div style="width: 100%; padding-bottom: 10px;">
					<div class="file_name" style="display: none;">
						#file_name#
					</div>
					<div class="browser" style="display: none;">
						#browser#
					</div>
					<div class="detail" style="display: none;">
						#error_detail#
					</div>
					<div class="line_number" style="display: none;">
						#line_number#
					</div>
					<div class="date columnData" style="width:16%;">#dateFormat(datecreated,"mm/dd/yy")#  #timeFormat(datecreated,"hh:mm tt")#</div>
					<div class="contact_id columnData" style="width:12%;">#contact_id#</div>
					<div class="username columnData" style="width:18%;">#username#</div>
					<div class="url ellipsis columnData" style="width:26%;">
						#REPLACE(url,cgi.HTTP_HOST, "", "ALL")#
					</div>
					<div class="details ellipsis columnData" style="width:26%;">
						<a href="##" id="error_details">
							#error_msg#
						</a>
					</div>
				</div>
			</cfloop>
		</div>

		<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
			<tr bgcolor="##CCE4F1">
				<td colspan="6" align="center">
					<b> Total between #WeekendFrom# and #WeekendTo# = #ctLoop# </b>
				</td>
			</tr>
		</table>
	<cfelse>
		<p>No Records Found</p>
	</cfif>
</CFIF>

<div id="error_content" class="modal">
	<div id="modal_title" class="clearfix">
		<div style="float: left;">
			<h2>Error Details</h2>
		</div>
		<div style="float: right; font-size: 20px;">
			<span id="error_close" class="close_error_info"><i class="fa fa-times" aria-hidden="true"></i></span>
		</div>
	</div>
	
	<div>
		<hr>
	</div>

	<div class="dataDiv">
		<div class="divUnderlinePadding">
			<div class="title">Date:</div><div id="error_date" class="long_text"></div>
		</div>
		<div class="divUnderlinePadding">
			<div class="title">Contact ID:</div><div id="error_contact_id" class="long_text"></div>
		</div>
		<div class="divUnderlinePadding">
			<div class="title">Username:</div><div id="error_username" class="long_text"></div>
		</div>
		<div class="divUnderlinePadding">
			<div class="title">File Name:</div><div id="error_filename" class="long_text"></div>
		</div>
		<div class="divUnderlinePadding">
			<div class="title">Browser:</div><div id="error_browser" class="long_text"></div>
		</div>
		<div class="divUnderlinePadding">
			<div class="title">URL:</div><div id="error_url" class="long_text"></div>
		</div>
		<div class="divUnderlinePadding">
			<div class="title">Error Message:</div><div id="error_message" class="long_text"></div>
		</div>
		<div class="divUnderlinePadding">
			<div class="title">Line Number:</div><div id="error_line_number" class="long_text"></div>
		</div>
		<div class="divUnderlinePadding">
			<div class="title">Error Detail:</div><div id="error_detail" class="long_text"></div>
		</div>
	</div>
</div>

</cfoutput>
</div>

<div id="veil"></div>

<cfsavecontent variable="cf_footer_scripts">
	<cfoutput>
		<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
		<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
		<script language="JavaScript" type="text/javascript">
			$(function(){
				$('input[name=WeekendFrom],input[name=WeekendTo]').datepicker();
			});

		
			$(document).on('click', '##error_details, ##error_close, ##veil', function(event){
				event.preventDefault();
				if( $('##error_content').hasClass('active') ) {
					$('##error_date').html('');
					$('##error_contact_id').html('');
					$('##error_username').html('');
					$('##error_url').html('');
					$('##error_message').html('');
					$('##error_filename').html('');
					$('##error_browser').html('');
					$('##error_detail').html('');
					$('##error_line_number').html('');

					$('##error_content').removeClass('active');
					$('##veil').removeClass('active');
				}
				else {
					$('##error_date').html($(this).closest('div').siblings('div.date').text());
					$('##error_contact_id').html($(this).closest('div').siblings('div.contact_id').text());
					$('##error_username').html($(this).closest('div').siblings('div.username').text());
					$('##error_url').html($(this).closest('div').siblings('div.url').text());
					$('##error_message').html($(this).text());
					$('##error_filename').html($(this).closest('div').siblings('div.file_name').text());
					$('##error_browser').html($(this).closest('div').siblings('div.browser').text());
					$('##error_detail').html($(this).closest('div').siblings('div.detail').text());
					$('##error_line_number').html($(this).closest('div').siblings('div.line_number').text());

					$('##error_content').addClass('active');
					$('##veil').addClass('active');
				}
			});
		</script>
	</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">
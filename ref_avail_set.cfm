<!--- 
	FileName:	ref_avail.cfm
	Created on: 1/25/10
	Created by: bcooper@capturepoint.com
	
	Purpose: allows a ref to manage their availability through a calendar interface
	
MODS: mm/dd/yyyy - filastname - comments
05/31/2017 - A.Pinzone - Added new timepicker.
09/07/2017 - A.Pinzone (27455) - Updated jquery qtip to latest version. Fixed issue where timepicker was overwriting the database value. 
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 


<cftry>
	<cfif isdefined("url.day")>
		<cfset date=url.day>
	<cfelse>
		<cfthrow message="Date must be defined in url">
	</cfif>
	
	<cfparam name="ref_avail_id" default="">
	
	<cfif isdefined("url.ref_avail_id")>
		<cfset ref_avail_id=url.ref_avail_id>
	</cfif>

	<cfif isdefined("url.cid")>
		<cfset contact_id=url.cid>
	<cfelse>
		<cfset contact_id=session.user.contactid>
	</cfif>
	
	<!--- get contact info --->
	<cfinvoke component="#application.sitevars.cfcpath#.contact" method="getContactInfo" contactID="#contact_id#" returnvariable="contactinfo"></cfinvoke>

	
	
	<!--- check for form submit --->
	<cfif isdefined("form.btnCancel")>
		<cflocation url="ref_avail.cfm?cid=#contact_id#&month=#month(form.date)#&year=#year(form.date)#" addtoken="No">
	<cfelseif isdefined("form.btnSave") OR isdefined("form.btnSaveNext") OR isdefined("form.btnSavePrev")>
	
		<!--- validate --->
		<cfif not isdefined("form.avail")>
			<cfthrow message="Please pick an availability type">
		</cfif>
		
		
	
	
	
		<!--- switch on avail type --->
		<cfset availability=true>
		<cfswitch expression="#form.avail#">
			<cfcase value="full">
				<cfset startdate="">
				<cfset enddate="">
				<cfset inverseflag="0">
			</cfcase>
			<cfcase value="before">
				<cfset startdate="">
				<cfset enddate="#form.date# #form.time2#">
				<cfset inverseflag="0">
			</cfcase>
			<cfcase value="after">
				<cfset startdate="#form.date# #form.time1#">
				<cfset enddate="">
				<cfset inverseflag="0">
			</cfcase>
			<cfcase value="between">
				<cfset startdate="#form.date# #form.time1#">
				<cfset enddate="#form.date# #form.time2#">
				<cfset inverseflag="0">
			</cfcase>
			<cfcase value="around">
				<cfset startdate="#form.date# #form.time1#">
				<cfset enddate="#form.date# #form.time2#">
				<cfset inverseflag="1">
			</cfcase>
			<cfdefaultcase><!--- never --->
				<cfset startdate="">
				<cfset enddate="">
				<cfset inverseflag="1">
				
				<!--- if no notes, remove record --->
				<cfif form.notes EQ "">
					<cfstoredproc datasource="#application.dsn#" procedure="p_remove_ref_avail">
						<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@contact_id" value="#contact_id#">
						<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@date" value="#dateformat(form.date,"mm/dd/yyyy")#">
					</cfstoredproc>
					<cfset availability=false>
				</cfif>
			</cfdefaultcase>
		</cfswitch>
		
		<cfif availability>
			
			<!--- validate start/end date --->
			<cfif startdate NEQ "" AND enddate NEQ "">
				<cfif datecompare(startdate,enddate) GTE 0>
					<cfthrow message="Start time must be before end time">
				</cfif>
			</cfif>
	
		
		
			<cfif ref_avail_id NEQ "">
				<!--- update --->
				<cfstoredproc datasource="#application.dsn#" procedure="p_update_ref_avail">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@ref_avail_id" value="#ref_avail_id#">
					<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@date" value="#dateformat(form.date,"mm/dd/yyyy")#">
					<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@start_time" value="#startdate#" null="#yesnoformat(startdate EQ "")#">
					<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@end_time" value="#enddate#" null="#yesnoformat(enddate EQ "")#">
					<cfprocparam cfsqltype="CF_SQL_BIT" dbvarname="@inverse_flag" value="#inverseflag#">
					<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@notes" value="#form.notes#">
				</cfstoredproc>
			<cfelse>
				<!--- create --->
				<cfstoredproc datasource="#application.dsn#" procedure="p_create_ref_avail">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@contact_Id" value="#contact_id#">
					<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@date" value="#dateformat(form.date,"mm/dd/yyyy")#">
					<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@start_time" value="#startdate#" null="#yesnoformat(startdate EQ "")#">
					<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@end_time" value="#enddate#" null="#yesnoformat(enddate EQ "")#">
					<cfprocparam cfsqltype="CF_SQL_BIT" dbvarname="@inverse_flag" value="#inverseflag#">
					<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@notes" value="#form.notes#">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@ref_avail_id" variable="ref_avail_id" type="Out">
				</cfstoredproc>
			</cfif>
		</cfif>
		
		<cfif isdefined("form.btnSave")>
			<cfif isdefined("cookie.rapage")>
				<cflocation url="#cookie.rapage#?cid=#contact_id#&month=#month(form.date)#&year=#year(form.date)#" addtoken="No">
			<cfelse>
				<cflocation url="ref_avail.cfm?cid=#contact_id#&month=#month(form.date)#&year=#year(form.date)#" addtoken="No">
			</cfif>
		<cfelseif isdefined("form.btnSaveNext")>
			<cflocation url="ref_avail_set.cfm?cid=#contact_id#&day=#dateformat(dateadd("d",1,date),"mm-dd-yyyy")#" addtoken="No">
		<cfelse>
			<cflocation url="ref_avail_set.cfm?cid=#contact_id#&day=#dateformat(dateadd("d",-1,date),"mm-dd-yyyy")#" addtoken="No">
		</cfif>
		
	</cfif>
	
	
	
	<!--- get calendar dates --->
	<cfquery datasource="#application.dsn#" name="getRAGlobals">
		select
			dbo.f_get_global_var(19) as ref_avail_sd,
			dbo.f_get_global_var(20) as ref_avail_ed,
			dbo.f_get_global_var(21) as ref_avail_enabled
	</cfquery>
	
	
	<cfquery datasource="#application.dsn#" name="getAvail">
		select [date], start_time, end_time, notes, inverse_flag from tbl_ref_avail
		where contact_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#contact_id#">
		and datediff(d,[date],'#dateformat(date,"mm/dd/yyyy")#') = 0
	</cfquery>
	
	<cfif getAvail.recordcount GT 0>
		
		<!--- set form values --->
		<cfif getAvail.start_time EQ "" AND getAvail.end_time EQ "">
			<cfif getAvail.inverse_flag EQ "1">
				<cfset availtype="unavailable">
			<cfelse>
				<cfset availtype="full">				
			</cfif>
		<cfelseif getAvail.start_time EQ "">
			<cfset availtype="before">
		<cfelseif getAvail.end_time EQ "">
			<cfset availtype="after">
		<cfelseif getAvail.inverse_flag EQ "1">
			<cfset availtype="around">
		<cfelse>
			<cfset availtype="between">
		</cfif>
		
		<cfset starttime=timeformat(getAvail.start_time,"HH:nn")>
		<cfset endtime=timeformat(getAvail.end_time,"HH:nn")>
		<cfset notes=getAvail.notes>
		
	<cfelse>
		<!--- defaults --->
		<cfset availtype="unavailable">
		<cfset starttime="">
		<cfset endtime="">
		<cfset notes="">
	</cfif>
	
	
	<!--- get availability for this ref --->
	<cfquery datasource="#application.dsn#" name="getAvail">
		select *, dbo.f_get_ref_avail_desc(ref_avail_id) as avail_desc,
		dbo.f_get_ref_avail_status(ref_avail_id) as avail_status from tbl_ref_avail
		where contact_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#contact_id#">
		and datediff(d,date,'#dateformat(getRAGlobals.ref_avail_sd,"m/d/yyyy")#') <= 0
		and datediff(d,date,'#dateformat(getRAGlobals.ref_avail_ed,"m/d/yyyy")#') >= 0
	</cfquery>
	
	<!--- build availability struct --->
	<cfset stAvail=structnew()>
	<cfloop query="getAvail">
		<cfset thisdate=dateformat(getAvail.date,"mmddyyyy")>
		<cfset thisstruct=structnew()>
		<cfset thisstruct.ref_avail_id=getAvail.ref_avail_id>
		<cfset thisstruct.starttime=getAvail.start_time>
		<cfset thisstruct.endtime=getAvail.end_time>
		<cfset thisstruct.notes=getAvail.notes>
		<cfset thisstruct.desc=getAvail.avail_desc>
		<cfset thisstruct.status=getAvail.avail_status>
		<cfset stAvail["#thisdate#"]=thisstruct>
	</cfloop>

	<cfcatch>
		<cfinclude template="error.cfm">
	</cfcatch>
</cftry>

<cfsavecontent variable="custom_css">
<style type="text/css">
	#dateHead{
		font-weight:bold;
		margin-top:10px;
		margin-bottom:10px;
	}
	#contentText{
		float:left;
		width:450px;
	}
	#calendar{
		float:right;
		width:300px;
		font-size:.7em;
	}
	.day{
		height:30px;
		position:relative;
	}
	.daynbr{
		position:absolute;
		left:3px;
		bottom:3px;
	}
	#calendar table{
		border-bottom:1px solid black;
		border-right:1px solid black;
	}
	#calendar th{
		border-top:1px solid black;
		border-left:1px solid black;
		padding:2px;
	}
	#calendar td{
		width: 14%;
		border-top:1px solid black;
		border-left:1px solid black;
	}
	.disabled{
		background-color:#aaa;
	}
	.availNotes{
		display:none;
	}
</style>
<link rel="stylesheet" href="assets/wickedpicker/dist/wickedpicker.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<!--- jQuery --->
<cfsavecontent variable="cf_footer_scripts">
<script language="JavaScript" type="text/javascript" src="assets/wickedpicker/dist/wickedpicker.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery.maxlength.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/date.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery.qtip-3.0.3.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		var start_time = <cfif starttime neq ""><cfoutput>"#starttime#"</cfoutput><cfelse>"12:00"</cfif>,
				end_time = <cfif endtime neq ""><cfoutput>"#endtime#"</cfoutput><cfelse>"12:00"</cfif>,
				start_options = {now: start_time, title: 'Select Time', minutesInterval: 5},
				end_options = {now: end_time, title: 'Select Time', minutesInterval: 5};

		$('input[name=avail]').click(showTimes);

		$('input[name=time1]').wickedpicker(start_options);
		$('input[name=time2]').wickedpicker(end_options);
		
		$('input[name=time1],input[name=time2]').wickedpicker(function(d){
		
			//if both fields are filled, compare dates
			if($('input[name=time1]').val() != '' && $('input[name=time2]').val() != '')
			{
				var d1=Date.parse($('input[name=time1]').val());
				var d2=Date.parse($('input[name=time2]').val());
				if(d1.compareTo(d2) > 0)
				{
					//show error line
					$('#timeError').show();
					return false;
				}
				else
					$('#timeError').hide();
			}
		});
		
		//max length on notes textarea
		$('textarea[name=notes]').maxlength({
			'feedback' : '#charsleft span',
			'useInput' : true
		});
		
		showTimes();
		
		//add tooltips to calendar on right
		$('.day').not('.disabled').each(function(){
		
			if($(this).find('.availNotes').text() != '')
			{
				$(this).qtip({
					content:{
						prerender:true,
						text:$(this).find('.availNotes').text()
					},
					show:{
						delay:250,
						when:{
							event:'mouseover'
						}
					},
					hide:'mouseout',
					position:{
						corner:{
							target:'topMiddle',
							tooltip:'bottomMiddle'
						}
					},
					style:{
						name:'light',
						width:150,
						padding:10,
						border:{
							radius:5
						},
						tip:'bottomMiddle'
					}/*,
					api:{
						beforeShow:function(e){
							//change text to note text
							if($(e.target).find('.availNotes').text() != '')
								this.updateContent($(e.target).find('.availNotes').text());
							else
								return false;
						}
					}*/
				});
			}
		});
	});
	/*
	* Purpose: Shows/hides input boxes for time values based on which radio button is selected.  There are 2 time input boxes; one for time1 and one for time2.
	* 'Before' radio button triggers time2 and 'After' triggers time1.  'between' and 'before and after' trigger both.
	*/
	function showTimes()
	{
		//get value of radio box
		var type=$('input[name=avail]:checked').val();
		if(type == null)
			type='';
		
		switch(type){
			case '':
			case 'unavailable':
			case 'full':
				//hide boxes
				$('#timeContainer').hide();
			break;
			case 'before':
				//show one box
				$('input[name=time2]').show();
				$('#joiner,#beforeLabel,#afterLabel,input[name=time1]').hide();
				$('#timeContainer').show();
			break;
			case 'after':
				//show one box
				$('input[name=time1]').show();
				$('#joiner,#beforeLabel,#afterLabel,input[name=time2]').hide();
				$('#timeContainer').show();
			break;
			case 'between':
				//show both boxes
				$('input[name=time1],input[name=time2]').show();
				$('#beforeLabel,#afterLabel').hide();
				$('#joiner').show();
				$('#timeContainer').show();
			break;
			case 'around':
				//show both boxes
				$('input[name=time1],input[name=time2]').show();
				$('#joiner,#beforeLabel,#afterLabel').show();
				$('#timeContainer').show();
			break;
		}
	}
</script>
</cfsavecontent>

<cfoutput>

	<div id="contentText">
	
		<H1 class="pageheading">NCSA - Set Availability</H1>
		<h2>#contactinfo.firstname# #contactinfo.lastname# (#contact_id#)</h2>
		
		<div id="dateHead">
			#dateformat(date,"dddd, mm/dd/yyyy")#
		</div>
		<form method="post" name="theform">
			<input type="Hidden" name="date" value="#date#">
			I am available:
			<br>
			<input type="Radio" name="avail" value="unavailable" <cfif availtype EQ "unavailable">checked="checked"</cfif>> Never<br>
			<input type="Radio" name="avail" value="full" <cfif availtype EQ "full">checked="checked"</cfif>> All day<br>
			<input type="Radio" name="avail" value="before" <cfif availtype EQ "before">checked="checked"</cfif>> Before<br>
			<input type="Radio" name="avail" value="after" <cfif availtype EQ "after">checked="checked"</cfif>> After<br>
			<input type="Radio" name="avail" value="between" <cfif availtype EQ "between">checked="checked"</cfif>> Between<br>
			<input type="Radio" name="avail" value="around" <cfif availtype EQ "around">checked="checked"</cfif>> Before and After<br>
			<br>
			<div id="timeContainer" style="margin-top:10px;">
				<div>
				Click in box below to select time:
				</div>
				<span id="beforeLabel">Before </span><input type="text" name="time1" value="#starttime#" autocomplete="off"><span id="joiner"> and </span><span id="afterLabel">After </span><input type="text" name="time2" value="#endtime#" autocomplete="off">
			</div>
			<div id="timeError" style="display:none; color:red;">
				Please make sure end time is after start time
			</div>
			
			<div style="margin-top:10px;">
				Notes:<br>
				<textarea name="notes" style="width:312px; height:70px;">#notes#</textarea>
				<input type="Hidden" name="maxlength" value="100">
				<div id="charsleft">Characters left: <span></span></div>
			</div>
			
			<div style="margin-top:10px;">
				<cfif datediff("d",date,getRAGlobals.ref_avail_sd) LT 0>
				<input type="submit" name="btnSavePrev" value="&lt; Save &amp; Prev">
				</cfif>
				<input type="submit" name="btnCancel" value="Cancel">
				<input type="submit" name="btnSave" value="Save">
				<cfif datediff("d",date,getRAGlobals.ref_avail_ed) GT 0>
				<input type="submit" name="btnSaveNext" value="Save &amp; Next &gt;">
				</cfif>
			</div>
		</form>
	
		
	
	

	</div>
	<div id="calendar">
	
	
		<cfinclude template="tpl_ref_avail_legend.cfm">
		
		
		<!--- get first day of display --->
		<cfset dtSeaStart=getRAGlobals.ref_avail_sd>
		<cfset dtStart=dateadd("d",(dayofweek(dtSeaStart)-1)*-1,dtSeaStart)>
		
		
		<!--- get end day of display --->
		<cfset dtSeaEnd=getRAGlobals.ref_avail_ed>
		<cfset dtEnd=dateadd("d",7-dayofweek(dtSeaEnd),dtSeaEnd)>
		
		
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<th>
					S
				</th>
				<th>
					M
				</th>
				<th>
					T
				</th>
				<th>
					W
				</th>
				<th>
					t
				</th>
				<th>
					F
				</th>
				<th>
					S
				</th>
			</tr>
			<tr>
			<cfset dow=1>
			<cfset showmo=true>
			<cfloop condition="dtStart LTE dtEnd">
			
				<cfif structkeyexists(stAvail,"#dateformat(dtStart,"mmddyyyy")#")>
					<cfset bgclass=stAvail["#dateformat(dtStart,"mmddyyyy")#"].status>
					<cfif bgclass EQ "partialavail">
						<cfset desc=stAvail["#dateformat(dtStart,"mmddyyyy")#"].desc>
					<cfelse>
						<cfset desc="">
					</cfif>
				<cfelse>
					<cfset bgclass="unavail">
					<cfset desc="">
				</cfif>
			
			
				<cfif dow GT 7>
					</tr>
					<tr>
					<cfset dow=1>
				</cfif>
				<td>
					<div class="day #bgclass# monthno#month(dtStart) MOD 2# <cfif dtStart LT dtSeaStart OR dtStart GT dtSeaEnd>disabled</cfif>" date="#dateformat(dtStart,"mm/dd/yyyy")#">
						<div class="daynbr">#day(dtStart)#</div>
						<cfif showmo>
							<div class="monthlabel">
								#dateformat(dtStart,"mmm")#
							</div>
							<cfset showmo=false>
						</cfif>
						<div class="availNotes">#desc#</div>
						<div class="chosenIcon ui-icon ui-icon-check"></div>
					</div>
				</td>
				<cfset dtStart=dateadd("d",1,dtStart)>
				<cfset dow=dow+1>
				<cfif day(dtStart) EQ 1>
					<cfset showmo=true>
				</cfif>
			</cfloop>
			</tr>
		</table>
	
	
	</div>
	<div style="height:20px;"></div>
</cfoutput>
<cfinclude template="_footer.cfm">

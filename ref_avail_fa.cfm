<!--- 
	FileName:	ref_avail.cfm
	Created on: 1/25/10
	Created by: bcooper@capturepoint.com
	
	Purpose: allows a ref to manage their availability through a calendar interface
	
MODS: mm/dd/yyyy - filastname - comments
05/31/2017 - A.Pinzone - Replaced clockpick.js with wickedpicker.js
09/07/2017 - A.Pinzone (27455) - Updated jquery qtip to latest version. Fixed spelling issue.

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 



<cfif isdefined("url.cid")>
	<cfset contact_id=url.cid>
<cfelse>
	<cfset contact_id=session.user.contactid>
</cfif>

	<!--- get contact info --->
	<cfinvoke component="#application.sitevars.cfcpath#.contact" method="getContactInfo" contactID="#contact_id#" returnvariable="contactinfo"></cfinvoke>


<!--- get calendar dates --->
<cfquery datasource="#application.dsn#" name="getRAGlobals">
	select
		dbo.f_get_global_var(19) as ref_avail_sd,
		dbo.f_get_global_var(20) as ref_avail_ed,
		dbo.f_get_global_var(21) as ref_avail_enabled
</cfquery>


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
	.day .chosenIcon{
		display:none;
	}
	.day.chosen .chosenIcon{
		display:block;
		position:absolute;
		top:0px;
		right:0px;
		background-image:url('assets/themes/cupertino/images/ui-icons_4b8e0b_256x240.png');
	}
	.chosenIcon{
	
	}
	.disabled{
		background-color:#aaa;
	}
	.availNotes{
		display:none;
	}
</style>
<link rel="stylesheet" href="assets/themes/cupertino/jquery-ui-1.7.2.custom.css">
<link rel="stylesheet" href="assets/wickedpicker/dist/wickedpicker.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<cfsavecontent variable="cf_footer_scripts">
<script language="JavaScript" type="text/javascript" src="assets/wickedpicker/dist/wickedpicker.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery.maxlength.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery.qtip-3.0.3.min.js"></script>

<script language="JavaScript" type="text/javascript">
	$(function(){
		
		//show/hide time inputs when user selects availabilty radio button
		$('input[name=avail]').click(showTimes);
		
		//add clock picker tool to time input boxes
		$('input[name=time1],input[name=time2]').wickedpicker({
			now: "12:00",
			title: 'Select Time Available',
			minutesInterval: 5
		});
		
		//toggle class on days
		$('.day:not(.disabled)').click(function(){
			if($(this).hasClass('chosen'))
				$(this).removeClass('chosen');
			else
				$(this).addClass('chosen');
		});
		
		//submit form, serialize days
		$('form[name=theform]').submit(function(){
			//serialize days
			
			var arr=new Array();
			$('.day.chosen').each(function(i){
				arr.push($(this).attr('date'));
			});
			$('input[name=datelist]').val(arr.join(','));
			
		});
		
		$('#linkSelAll').click(function(){
			$('.day:not(.disabled)').addClass('chosen');
		});
		$('#linkClearAll').click(function(){
			$('.day:not(.disabled)').removeClass('chosen');
		});
		
		//max length on notes textarea
		$('textarea[name=notes]').maxlength({
			'feedback' : '#charsleft span',
			'useInput' : true
		});
		
		showTimes();
		
		
		//add tooltips to days on calendar that have notes
		$('.day').not('.disabled').each(function(){
		
			if($(this).find('.availNotes').text() != '')
			{
				$(this).qtip({
					content:{
						prerender:true,
						text:$(this).find('.availNotes').text()
					},
					show:{
						delay:500,
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
							console.log(e,this);
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
		<cfif getRAGlobals.ref_avail_enabled EQ "0">
			<h1>Calendar currently not available</h1>
		<cfelse>
	
			<H1 class="pageheading">NCSA - Availability - Multiple Day Entry</H1>
			<h2>#contactinfo.firstname# #contactinfo.lastname# (#contact_id#)</h2>
			<div style="margin:10px 0;">
			You may select only ONE of options below along with multiple dates, insert comment if desired, then click "SAVE" to apply to all checked dates. You must save for each option before proceeding to a different option.
			</div>
			
			<form method="post" action="ref_avail_fa_action.cfm" name="theform">
				<input type="Hidden" name="datelist">
				<input type="Hidden" name="contact_id" value="#contact_id#">
				I am available:
				<br>
				<input type="Radio" name="avail" value="unavailable" checked="checked"> Never<br>
				<input type="Radio" name="avail" value="full"> All day<br>
				<input type="Radio" name="avail" value="before"> Before<br>
				<input type="Radio" name="avail" value="after"> After<br>
				<input type="Radio" name="avail" value="between"> Between<br>
				<input type="Radio" name="avail" value="around"> Before and After<br>
				<br>
			<div id="timeContainer" style="margin-top:10px;">
				<div>
				Click in box below to select time:
				</div>
				<!--- time inputs.  toggled visible by selection of avail radio --->
				<span id="beforeLabel">Before </span><input type="text" name="time1" autocomplete="off"><span id="joiner"> and </span><span id="afterLabel">After </span><input type="text" name="time2" autocomplete="off">
			</div>
				
				<div style="margin-top:10px;">
					Notes:<br>
					<textarea name="notes" style="width:312px; height:70px;"></textarea>
					<input type="Hidden" name="maxlength" value="100">
					<div id="charsleft">Characters left: <span></span></div>
				</div>
				
				<div style="margin-top:10px;">
					<input type="submit" name="btnCancel" value="Cancel">
					<input type="submit" name="btnSave" value="Save">
				</div>
			</form>
			
			</div>
			
			<div id="calendar">
			
			
				<cfinclude template="tpl_ref_avail_legend.cfm">
				
				
				<a href="javascript:void(0);" id="linkSelAll">Select all</a> - <a href="javascript:void(0);" id="linkClearAll">deselect all</a>
				<!--- make clickable calendar for choosing dates to assign to --->
				
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
		</cfif>
</cfoutput>

<cfinclude template="_footer.cfm">

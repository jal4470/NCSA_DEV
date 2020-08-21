<!--- 
	FileName:	rptFinesListAll.cfm
	Created on: 02/26/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

5/22/2017 - apinzone 
-- removed old jquery, moved javascript to bottom of page and wrapped in cfsavecontent
-- added a row of blank <td> elements to tablesorter table to account for default sorting and prevent errors
8/14/2017 - apinzone - NCSA27024 
-- updated timepicker to use wickedpicker

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>


<style type="text/css" media="print">
	##masthead,##ticker,##leftMenu,##siteInfo,##calNav,##availNav{
		display:none;
	}
</style>


<div id="contentText">

<H1 class="pageheading">NCSA - Referee Availability</H1>
<br> <!--- <h2>yyyyyy </h2> --->



<!--- get season info --->
<cfinvoke component="#Application.sitevars.cfcpath#.season" method="getCurrentSeason" returnvariable="curSeason"></cfinvoke>

<cfquery datasource="#application.dsn#" name="getRAGlobals">
	select
		dbo.f_get_global_var(19) as ref_avail_sd,
		dbo.f_get_global_var(20) as ref_avail_ed,
		dbo.f_get_global_var(21) as ref_avail_enabled
</cfquery>


<cfif isdefined("url.type")>
	<cfset availtype=url.type>
<cfelse>
	<cfset availtype="allavail">
</cfif>

<cfif isdefined("url.comments")>
	<cfset commentType=url.comments>
<cfelse>
	<cfset commentType="all">
</cfif>

<cfif isdefined("url.cert")>
	<cfset cert=url.cert>
<cfelse>
	<cfset cert="">
</cfif>

<cfif isdefined("url.useseason")><!--- not used anymore --->

	
	<cfset datestart=curSeason.season_startdate>
	<cfset dateend=curSeason.season_enddate>
<cfelse>
	<cfif isdefined("url.datestart")>
		<cfset datestart=url.datestart>
	<cfelse>
		<cfset datestart=now()>
	</cfif>
	<cfif isdefined("url.dateend")>
		<cfset dateend=url.dateend>
	<cfelse>
		<cfset dateend=now()>
	</cfif>
</cfif>

<cfif isdefined("url.avail")>
	<cfset timetype=url.avail>
<cfelse>
	<cfset timetype="">
</cfif>


<cfif isdefined("url.time1")>
	<cfset starttime=url.time1>
<cfelse>
	<cfset starttime="">
</cfif>

<cfif isdefined("url.time2")>
	<cfset endtime=url.time2>
<cfelse>
	<cfset endtime="">
</cfif>

<cfset sqlstarttime=timeformat(starttime,"Hmm")>
<cfset sqlendtime=timeformat(endtime,"Hmm")>


<!--- get availability --->
<cfstoredproc datasource="#application.dsn#" procedure="p_get_ref_avail_rpt">
	<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@startdate" value="#datestart#">
	<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@enddate" value="#dateend#">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@availtype" value="#availtype#">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@commenttype" value="#commenttype#">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@timetype" value="#timetype#">
	<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@starttime" value="#sqlstarttime#" null="#yesnoformat(starttime EQ "")#">
	<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@endtime" value="#sqlendtime#" null="#yesnoformat(endtime EQ "")#">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@certified" value="#cert#">
	<cfprocresult name="getAvail" resultset="1">
</cfstoredproc>

<cfsavecontent variable="jqueryUI_CSS">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
	<link rel="stylesheet" href="assets/daterangepicker/css/ui.daterangepicker.css">
	<link rel="stylesheet" href="assets/wickedpicker/dist/wickedpicker.min.css">
	<style type="text/css">
		.ui-daterangepickercontain{
			font-size:9px;
		}
		.tblHeading{
			text-align:left;
		}
		.header{
			padding-right:20px;
			background-image:url(assets/images/bg.gif);
			background-repeat:no-repeat;
			background-position:right;
			cursor:pointer;
		}
		.headerSortUp{
			background-image:url(assets/images/asc.gif);
		}
		.headerSortDown{
			background-image:url(assets/images/desc.gif);
		}
		.availChip{
			float:left;
			display:block;
			width:1.2em;
			height:1.2em;
			margin-right:5px;
			-moz-border-radius:1em;
		}
		.fullavail{
			background-color:##6f6;
		}
		.partialavail{
			background-color:##ff6;
		}
		.unavail{
			background-color:##f66;
		}
	</style>
</cfsavecontent>
<cfhtmlhead text="#jqueryUI_CSS#">

<FORM name="theform" action="rptRefAvail.cfm"  method="GET">
<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
	<TR><td>
			<b>Type:</b>
			<select name="type">
				<option value="all" <cfif availtype EQ "all">selected="selected"</cfif>>All</option>
				<option value="full" <cfif availtype EQ "full">selected="selected"</cfif>>Full</option>
				<option value="partial" <cfif availtype EQ "partial">selected="selected"</cfif>>Partial</option>
				<option value="allavail" <cfif availtype EQ "allavail">selected="selected"</cfif>>Full And Partial</option>
				<option value="none" <cfif availtype EQ "none">selected="selected"</cfif>>None</option>
			</select>
			<b>Date Range:</b>
			<input type="Text" name="datestart" value="#dateformat(datestart,"mm/dd/yyyy")#">
			to
			<input type="Text" name="dateend" value="#dateformat(dateend,"mm/dd/yyyy")#">
			<INPUT type="Submit" value="Go">
		</td>
	</TR>
	<TR><td>
			<b>Comments:</b>
			<select name="comments">
				<option value="all" <cfif commentType EQ "all">selected="selected"</cfif>>All</option>
				<option value="y" <cfif commentType EQ "y">selected="selected"</cfif>>Comments</option>
				<option value="n" <cfif commentType EQ "n">selected="selected"</cfif>>No Comments</option>
			</select>
			<!--- <span class="note">(does not apply to 'no availability' type)</span> --->
		</td>
	</TR>
	<tr>
		<td>
			<b>Time Filter:</b>
			<select name="avail">
				<option value="">--Select--</option>
				<option value="before" <cfif timetype EQ "before">selected="selected"</cfif>>Before</option>
				<option value="after" <cfif timetype EQ "after">selected="selected"</cfif>>After</option>
				<option value="between" <cfif timetype EQ "between">selected="selected"</cfif>>Between</option>
			</select>
			<span id="timeContainer">
				<input type="text" name="time1" value="#starttime#" autocomplete="off"><span id="joiner"> and </span><input type="text" name="time2" value="#endtime#" autocomplete="off">
			</span>
			<br>
			<span class="note">(does not apply to 'all' or 'full' types)</span>
		</td>
	</tr>
	<tr>
		<td>
			<b>Referee Certified:</b>
			<select name="cert">
				<option value="">--Select--</option>
				<option value="Y" <cfif cert EQ "Y">selected="selected"</cfif>>Yes</option>
				<option value="N" <cfif cert EQ "N">selected="selected"</cfif>>No</option>
			</select>
		</td>
	</tr>
</table>

<table cellspacing="0" cellpadding="2" align="left" border="0" width="100%" id="availTable">
	<thead>
	<tr class="tblHeading">
		<th width="100">Name</th>
		<th width="35" align="center">Cert?</th>
		<th width="45">Date</th>
		<th>Availability</th>
		<th>Comments</th>
	</TR>
	</thead>
	<tbody>
	<cfif getAvail.recordcount GT 0>
	<CFLOOP query="getAvail">
		
		<!--- set bg color --->
		<cfset bgclass="#getAvail.avail_status#">

		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#" >
			<td class="tdUnderLine">#lastname#, #firstname# (#contact_id#)</td>
			<td align="center" class="tdUnderLine">#certified#</td>
			<td class="tdUnderLine">#dateformat(date,"m/d/yyyy")#</td>
			<td class="tdUnderLine"><span class="availChip #bgclass#"></span>#avail_desc#</td>
			<td class="tdUnderLine">#notes#</td>
		</tr>
	</CFLOOP>
	<cfelse>
		<tr>
			<td class="tdUnderLine"></td>
			<td class="tdUnderLine"></td>
			<td class="tdUnderLine"></td>
			<td class="tdUnderLine"></td>
			<td class="tdUnderLine"></td>
		</tr>
		<tr>
			<td colspan="5">No results found.</td>
		</tr>
	</cfif>
	</tbody>
</TABLE>
</FORM>

</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">

<!--- Time Adjustment for WickedPicker --->
<cfif isdefined("time1") and len(time1)>
	<cfset time1 = TimeFormat(time1, 'HH:nn')>
<cfelse>
	<cfset time1 = TimeFormat('12:00', 'HH:nn')>
</cfif>
<cfif isdefined("time2") and len(time2)>
	<cfset time2 = TimeFormat(time2, 'HH:nn')>
<cfelse>
	<cfset time2 = TimeFormat('12:00', 'HH:nn')>
</cfif>

<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery.tablesorter.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/daterangepicker/js/daterangepicker.jQuery.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/wickedpicker/dist/wickedpicker.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=datestart], input[name=dateend]').daterangepicker({
			presetRanges:[
				{
					text:'Today',
					dateStart:'today',
					dateEnd:'today'
				},
				{
					text:'Tomorrow',
					dateStart:'tomorrow',
					dateEnd:'tomorrow',
					separator:true
				},
				{
					text:'This Week',
					dateStart:function(){
						if(Date.today().day() == 0)
							return Date.today();
						return Date.today().moveToDayOfWeek(0,-1);
					},
					dateEnd:function(){
						if(Date.today().day() == 6)
							return Date.today();
						return Date.today().moveToDayOfWeek(6,1);
					}
				},
				{
					text:'Next Week',
					dateStart:function(){
						if(Date.today().day() == 0)
							return Date.today().add({days:7});
						return Date.today().add({days:7}).moveToDayOfWeek(0,-1);
					},
					dateEnd:function(){
						if(Date.today().day() == 6)
							return Date.today().add({days:7});
						return Date.today().add({days:7}).moveToDayOfWeek(6,1);
					},
					separator:true
				},
				{
					text:'This Month',
					dateStart:function(){return Date.today().moveToFirstDayOfMonth()},
					dateEnd:function(){return Date.today().moveToLastDayOfMonth()}
				},
				{
					text:'Next Month',
					dateStart:function(){return Date.today().add({months:1}).moveToFirstDayOfMonth()},
					dateEnd:function(){return Date.today().add({months:1}).moveToLastDayOfMonth()},
					separator:true
				},
				{
					text:'Current Availability Range',
					dateStart:'#dateformat(getRAGlobals.ref_avail_sd,"mm/dd/yyyy")#',
					dateEnd:'#dateformat(getRAGlobals.ref_avail_ed,"mm/dd/yyyy")#'
				},
				{
					text:'This Season',
					dateStart:'#dateformat(curSeason.season_startdate,"mm/dd/yyyy")#',
					dateEnd:'#dateformat(curSeason.season_enddate,"mm/dd/yyyy")#'
				}
			],
			presets:{
				specificDate:'Specific date',
				dateRange:'Date range'
			}
		});
		
		$('select[name=avail]').change(showTimes);
		
		
		$('input[name=time1]').wickedpicker({
			now: "<cfoutput>#time1#</cfoutput>",
			title: 'Select Time Available',
			minutesInterval: 5
		});

		$('input[name=time2]').wickedpicker({
			now: "<cfoutput>#time2#</cfoutput>",
			title: 'Select Time Available',
			minutesInterval: 5
		});
		
		showTimes();
		
		$('#availTable').tablesorter({
			headers:{
				3:{
					sorter:false
				}
			},
			sortList:[[2,0],[0,0]]
		});
		
	});
	
	
	function showTimes()
	{
		//get value of radio box
		var type=$('select[name=avail] option:selected').val();
		if(type == null)
			type='';
		
		switch(type){
			case '':
				//hide boxes
				$('#timeContainer').hide();
			break;
			case 'before':
				//show one box
				$('input[name=time2]').show();
				$('#joiner,input[name=time1]').hide();
				$('#timeContainer').show();
			break;
			case 'after':
				//show one box
				$('input[name=time1]').show();
				$('#joiner,input[name=time2]').hide();
				$('#timeContainer').show();
			break;
			case 'between':
			case 'around':
				//show both boxes
				$('input[name=time1],input[name=time2]').show();
				$('#joiner').show();
				$('#timeContainer').show();
			break;
		}
	}
</script>
</cfsavecontent>

<cfinclude template="_footer.cfm">

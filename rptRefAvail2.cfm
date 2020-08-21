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
-- updated default time for wickedpicker
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

<H1 class="pageheading">NCSA - Referee Weekend Availability</H1>
<br> <!--- <h2>yyyyyy </h2> --->


<cfif isdefined("url.timetype")>
	<cfset timetype=url.timetype>
<cfelse>
	<cfset timetype="before">
</cfif>

<cfif isdefined("url.time")>
	<cfset time=url.time>
<cfelse>
	<cfset time="12:00 pm">
</cfif>

<cfif isdefined("url.date")>
	<cfset date=url.date>
<cfelse>
	<cfset date=now()>
</cfif>

<cfif isdefined("url.cert")>
	<cfset cert=url.cert>
<cfelse>
	<cfset cert="">
</cfif>

<cfset sqltime=timeformat(time,"Hmm")>


<!--- get availability --->
<cfquery datasource="#application.dsn#" name="getAvail">
select ra.*, c.firstname, c.lastname, ri.certified_yn as certified from 
(select ref_avail_id, inverse_flag, notes, contact_id, date,
100 * DATEPART(HOUR, start_time) + DATEPART(MINUTE,start_time) as start_time,
100 * DATEPART(HOUR, end_time) + DATEPART(MINUTE,end_time) as end_time,
dbo.f_get_ref_avail_desc(ref_avail_id) as avail_desc,
dbo.f_get_ref_avail_status(ref_avail_id) as avail_status
from tbl_ref_avail) ra
inner join tbl_contact c
on ra.contact_id=c.contact_id
inner join tbl_referee_info ri
on c.contact_id=ri.contact_id
where
datediff(d,date,'#dateformat(date,"mm/dd/yyyy")#')=0
and
(
<cfif timetype EQ "before">
(inverse_flag=0 and end_time <= #sqltime#)
OR
(inverse_flag=1 and start_time <= #sqltime#)
<cfelse>
(inverse_flag=0 and start_time >= #sqltime#)
OR
(inverse_flag=1 and end_time >= #sqltime#)
</cfif>
)
<cfif cert EQ "Y">
and ri.certified_yn = 'Y'
<cfelseif cert EQ "N">
and ri.certified_yn = 'N'
</cfif>
</cfquery>

<cfsavecontent variable="jqueryUI_CSS">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
	<link rel="stylesheet" href="assets/wickedpicker/dist/wickedpicker.min.css">
	<style type="text/css">
	##ui-datepicker-div{
		font-size:10px;
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

<FORM name="theform" action="rptRefAvail2.cfm"  method="GET">
<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
	<TR><td>
			<b>Availability</b>
			<select name="timetype">
				<option value="before" <cfif timetype EQ "before">selected="selected"</cfif>>Before</option>
				<option value="after" <cfif timetype EQ "after">selected="selected"</cfif>>After</option>
			</select>
			<input type="text" name="time" value="#time#" autocomplete="off">
			<b>On</b>
			<input type="Text" name="date" value="#dateformat(date,"mm/dd/yyyy")#"><br>
			<b>Referee Certified:</b>
			<select name="cert">
				<option value="">--Select--</option>
				<option value="Y" <cfif cert EQ "Y">selected="selected"</cfif>>Yes</option>
				<option value="N" <cfif cert EQ "N">selected="selected"</cfif>>No</option>
			</select>
			<INPUT type="Submit" value="Go">
		</td>
	</TR>
</table>

<table cellspacing="0" cellpadding="2" align="left" border="0" width="100%" id="availTable">
	<thead>
	<tr class="tblHeading">
		<th width="100">Name</th>
		<th width="35" align="center">Cert?</th>
		<th>Date</th>
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
			<td>#lastname#, #firstname# (#contact_id#)</td>
			<td align="center">#certified#</th>
			<td>#dateformat(date,"m/d/yyyy")#</td>
			<td><span class="availChip #bgclass#"></span>#avail_desc#</td>
			<td>#notes#</td>
		</tr>
	</CFLOOP>
	<cfelse>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td colspan="4">
				No records to show
			</td>
		</tr>
	</cfif>
	</tbody>
</TABLE>
</FORM>

</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery.tablesorter.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/wickedpicker/dist/wickedpicker.min.js"></script>

<!--- Set time format to 24 hour clock for wickedpicker --->
<cfset time = TimeFormat(time, 'HH:nn')>
<script language="JavaScript" type="text/javascript">
	$(function(){
		
		$('input[name=date]').datepicker();

		$('input[name=time]').wickedpicker({
			now: "<cfoutput>#time#</cfoutput>",
			title: 'Select Time',
			minutesInterval: 5
		});

		
		$('#availTable').tablesorter({
			headers:{
				2:{
					sorter:false
				}
			},
			sortList:[[1,0],[0,0]]
		});
		
	});
</script>
</cfsavecontent>


<cfinclude template="_footer.cfm">

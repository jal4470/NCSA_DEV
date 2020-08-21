<!--- 
	FileName:	rptFinesListAll.cfm
	Created on: 02/26/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

5/22/2017 - apinzone - removed old jquery, moved javascript to bottom of page and wrapped in cfsavecontent
					 - added a row of blank <td> elements to tablesorter table to account for default sorting and prevent errors
					 
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">


<style type="text/css" media="print">
	##masthead,##ticker,##leftMenu,##siteInfo,##calNav,##availNav{
		display:none;
	}
</style>


<H1 class="pageheading">NCSA - Referee Availability Change Log</H1>
<br> <!--- <h2>yyyyyy </h2> --->



<cfset showReport=false>
<cfif isdefined("url.cid")>
	<cfset contact_id=url.cid>
<cfelse>
	<cfset contact_id="">
</cfif>

<cfif isdefined("url.date")>
	<cfset date=url.date>
<cfelse>
	<cfset date="">
</cfif>

<cfif isdefined("url.datechanged")>
	<cfset datechanged=url.datechanged>
<cfelse>
	<cfset datechanged="">
</cfif>

<cfif contact_id NEQ "" OR datechanged NEQ "">
	<cfset showReport=true>
</cfif>


<!--- get contacts --->
<cfquery datasource="#application.dsn#" name="getContacts">
	select distinct a.contact_id, b.firstname, b.lastname
	from tbl_ref_avail_log a
	inner join tbl_contact b
	on a.contact_id=b.contact_id
	order by lastname, firstname
</cfquery>


<cfif showReport>
	<!--- get report --->
	<cfquery datasource="#application.dsn#" name="getLog">
		select ref_avail_id, a.contact_id, date, notes, datechanged, action, 
		dbo.f_get_ref_avail_log_desc(start_time, end_time, inverse_flag) as avail_desc,
		dbo.f_get_ref_avail_log_desc(old_start_time, old_end_time, old_inverse_flag) as old_avail_desc,
		old_notes,
		b.firstname, b.lastname,
		c.certified_yn as certified
		from tbl_ref_avail_log a
		inner join tbl_contact b
		on a.contact_id=b.contact_id
		left join tbl_referee_info c
		on a.contact_id=c.contact_id
		where 1=1
		<cfif contact_id NEQ "">
			and a.contact_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#contact_id#">
		</cfif>
		<cfif date NEQ "" AND isdate(date)>
		and datediff(d,date,'#dateformat(date,"mm/dd/yyyy")#') = 0
		</cfif>
		<cfif datechanged NEQ "" AND isdate(datechanged)>
		and datediff(d,datechanged,'#dateformat(datechanged,"mm/dd/yyyy")#') <=0
		</cfif>
		order by datechanged desc
	</cfquery>
</cfif>

<cfsavecontent variable="jqueryUI_CSS">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
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

<FORM name="theform" action="rptRefAvailChange.cfm"  method="GET">
<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
	<TR><td>
			<b>Contact:</b>
			<select name="cid">
				<option value="">All</option>
				<!--- <option value="certified">Certified</option>
				<option value="noncert">Non-Certified</option> --->
				<cfloop query="getContacts">
					<option value="#contact_id#" <cfif getContacts.contact_id EQ variables.contact_id>selected="selected"</cfif>>#lastname#, #firstname#</option>
				</cfloop>
			</select>
			<b>Date:</b>
			<input type="Text" name="date" value="#dateformat(date,"mm/dd/yyyy")#" autocomplete="off">
			<b>Changed on or after:</b>
			<input type="Text" name="datechanged" value="#dateformat(datechanged,"mm/dd/yyyy")#" autocomplete="off">
			<INPUT type="Submit" name="Run" value="Go">
		</td>
	</TR>
</table>
</FORM>

<cfif showReport>
<table cellspacing="0" cellpadding="2" align="left" border="0" width="100%" id="availTable">
	<thead>
	<tr class="tblHeading">
		<th width="50">Contact</th>
		<th width="35" align="center">Cert?</th>
		<th>Date</th>
		<th>Prior Availability</th>
		<th>Prior Comments</th>
		<th>Availability</th>
		<th>Comments</th>
		<th>Date Changed</th>
		<!--- <th>Action</th> --->
	</TR>
	</thead>
	<tbody>
	<cfif getLog.recordcount GT 0>
	<CFLOOP query="getLog">
		

		<tr>
			<td class="tdUnderLine">#lastname#, #firstname#</td>
			<td align="center" class="tdUnderLine">#certified#</td>
			<td class="tdUnderLine">#dateformat(date,"m/d/yyyy")#</td>
			<td class="tdUnderLine">#old_avail_desc#</td>
			<td class="tdUnderLine">#old_notes#</td>
			<td class="tdUnderLine">#avail_desc#</td>
			<td class="tdUnderLine">#notes#</td>
			<td class="tdUnderLine">#dateformat(datechanged,"m/d/yyyy")# #timeformat(datechanged,"h:mm:ss tt")#</td>
			<!--- <td>#action#</td> --->
		</tr>
	</CFLOOP>
	<cfelse>
		<tr>
			<td class="tdUnderLine"></td>
			<td class="tdUnderLine"></td>
			<td class="tdUnderLine"></td>
			<td class="tdUnderLine"></td>
			<td class="tdUnderLine"></td>
			<td class="tdUnderLine"></td>
			<td class="tdUnderLine"></td>
			<td class="tdUnderLine"></td>
		</tr>
		<tr>
			<td colspan="7">
				No records to show
			</td>
		</tr>
	</cfif>
	</tbody>
</TABLE>
</cfif>

</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery.tablesorter.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=date],input[name=datechanged]').datepicker();
		
		$('#availTable').tablesorter({
			headers:{
				3:{
					sorter:false
				}
			},
			sortList:[[0,0],[2,0],[1,0]]
		});
		
	});
</script>
</cfsavecontent>

<cfinclude template="_footer.cfm">

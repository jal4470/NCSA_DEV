<!--- 
	FileName:	ref_avail.cfm
	Created on: 1/25/10
	Created by: bcooper@capturepoint.com
	
	Purpose: allows a ref to manage their availability through a calendar interface
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 


<!--- set page cookie --->
<cfset cookie.rapage="ref_avail_list.cfm">


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
				dbo.f_get_ref_avail_status(ref_avail_id) as avail_status
	 from tbl_ref_avail
	where contact_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#contact_id#">
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
	<cfset thisstruct.avail_desc=getAvail.avail_desc>
	<cfset thisstruct.avail_status=getAvail.avail_status>
	<cfset stAvail["#thisdate#"]=thisstruct>
</cfloop>



<cfoutput>

<!--- jQuery --->
<link rel="stylesheet" href="assets/themes/cupertino/jquery-ui-1.7.2.custom.css">
<script language="JavaScript" type="text/javascript" src="assets/jquery-1.4.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery.qtip-1.0.0-rc3.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('.daylabel').hover(function(){
			$(this).find('a').show();
		},
		function(){
			$(this).find('a').hide();
		});
	});
</script>

<style type="text/css">
	.day{
		margin-bottom:25px;
		margin-left:20px;
	}
	.disabled{
		color:##aaa;
		cursor:default;
	}
	##calendar{
		border-bottom:1px solid black;
		border-right:1px solid black;
	}
	##calendar th{
		border-top:1px solid black;
		border-left:1px solid black;
		padding:4px;
	}
	##calendar td{
		width: 14%;
		border-top:1px solid black;
		border-left:1px solid black;
	}
	.daylabel{
		font-size:1.2em;
		font-weight:bold;
		margin-left:-20px;
		margin-bottom:3px;
	}
	.daylabel a{
		font-size:.8em;
		display:none;
	}
	.monthlabel{
		font-size:1.5em;
		font-weight:bold;
		font-family:georgia,serif;
		margin-top:15px;
	}
	##calHead{
		font-size:1.5em;
		font-weight:bold;
		margin-bottom:10px;
		margin-top:20px;
	}
	##calNav{
		margin-bottom:5px;
	}
	.availNotes{
		font-style:italic;
		font-family:cursive;
	}
	.icon-notes{
		display:block;
		float:right;
		background-image:url('assets/themes/cupertino/images/ui-icons_444444_256x240.png');
	}
	.availChip{
		float:left;
		display:block;
		width:1.2em;
		height:1.2em;
		margin-right:5px;
		-moz-border-radius:1em;
	}
</style>
<style type="text/css" media="print">
	##masthead,##ticker,##leftMenu,##siteInfo,##calNav,##availNav{
		display:none;
	}
</style>


<div id="contentText">

<H1 class="pageheading"><div id="availNav" style="float:right;"><a href="ref_avail_fa.cfm?cid=#contact_id#">Multiple Day Entry</a> - <a href="ref_avail.cfm?cid=#contact_id#">Calendar</a></div><div style="float:left;">NCSA - Availability List</div><a href="javascript:print();" style="font-size:.6em;"><span style="float:left;margin-left:10px;" class="ui-icon ui-icon-print"></span>Print</a><div style="clear:both;"></div></H1>
<h2>#contactinfo.firstname# #contactinfo.lastname# (#contact_id#)</h2>



<!--- loop over season --->
<cfset curDate=getRAGlobals.ref_avail_sd>
<div class="monthlabel">
	#dateformat(curDate,"mmmm, yyyy")#
</div>
<cfloop condition="datediff(""d"",curDate,getRAGlobals.ref_avail_ed) GTE 0">
	<div class="day">
		<div class="daylabel">
			#dateformat(curDate,"ddd m/d")#
			<a href="ref_avail_set.cfm?cid=#contact_id#&day=#dateformat(curDate,"mm-dd-yyyy")#">edit</a>
		</div>
		<!--- get availability if exists --->
		<cfif structkeyexists(stAvail,"#dateformat(curDate,"mmddyyyy")#")>
			<cfset thisstruct=stAvail["#dateformat(curDate,"mmddyyyy")#"]>
			<cfset ref_avail_id=thisstruct.ref_avail_id>
			<cfset availText=thisstruct.avail_desc>
			<cfset notes=thisstruct.notes>
			<cfset bgclass=thisstruct.avail_status>
		<cfelse>
			<cfset ref_avail_id="">
			<cfset notes="">
			<cfset bgclass="unavail">
			<cfset availText="Never">
		</cfif>
		
		
		<div class="availText">
			<span class="availChip #bgclass#"></span>
			#availText#
		</div>
		<div class="availNotes">#notes#</div>
	</div>
	<cfset curDate=dateadd("d",1,curDate)>
	<cfif day(curDate) EQ 1>
		<div class="monthlabel">
			#dateformat(curDate,"mmmm, yyyy")#
		</div>
	</cfif>
</cfloop>



<div style="height:20px;"></div>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">

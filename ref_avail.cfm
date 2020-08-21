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

<cfif isdefined("url.month")>
	<cfset month=url.month>
<cfelse>
	<cfset month="">
</cfif>

<cfif isdefined("url.year")>
	<cfset year=url.year>
<cfelse>
	<cfset year="">
</cfif>

<cfif isdefined("url.cid")>
	<cfset contact_id=url.cid>
<cfelse>
	<cfset contact_id=session.user.contactid>
</cfif>

<!--- set page cookie --->
<cfset cookie.rapage="ref_avail.cfm">


<!--- get calendar dates --->
<cfquery datasource="#application.dsn#" name="getRAGlobals">
	select
		dbo.f_get_global_var(19) as ref_avail_sd,
		dbo.f_get_global_var(20) as ref_avail_ed,
		dbo.f_get_global_var(21) as ref_avail_enabled
</cfquery>

<cfif month EQ "" OR year EQ "">
	<cfif datediff("d",now(),getRAGlobals.ref_avail_sd) LTE 0 AND datediff("d",now(),getRAGlobals.ref_avail_ed) GTE 0>
		<cfset month=month(now())>
		<cfset year=year(now())>
	<cfelseif datediff("d",now(),getRAGlobals.ref_avail_sd) GT 0>
		<cfset month=month(getRAGlobals.ref_avail_sd)>
		<cfset year=year(getRAGlobals.ref_avail_sd)>
	<cfelse>
		<cfset month=month(getRAGlobals.ref_avail_ed)>
		<cfset year=year(getRAGlobals.ref_avail_ed)>
	</cfif>
</cfif>

<!--- get contact info --->
<cfinvoke component="#application.sitevars.cfcpath#.contact" method="getContactInfo" contactID="#contact_id#" returnvariable="contactinfo"></cfinvoke>




<cfset dtMoStart=createdate(year,month,1)>
<!--- get first day of display --->
<cfset dtStart=dateadd("d",(dayofweek(dtMoStart)-1)*-1,dtMoStart)>


<!--- get end day of display --->
<cfset dtEnd=dateadd("d",7-dayofweek(dateadd("d",-1,dateadd("m",1,createdate(year,month,1)))),dateadd("d",-1,dateadd("m",1,createdate(year,month,1))))>


<!--- get availability for this ref --->
<cfquery datasource="#application.dsn#" name="getAvail">
	select *, dbo.f_get_ref_avail_desc(ref_avail_id) as avail_desc from tbl_ref_avail
	where contact_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#contact_id#">
	and datediff(m,date,'#dateformat(dtMoStart,"m/d/yyyy")#') = 0
</cfquery>
<!--- <cfdump var=#getavail#> --->

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
	<cfif thisstruct.starttime EQ "" AND thisstruct.endtime EQ "">
		<cfif getAvail.inverse_flag>
			<cfset thisstruct.type="never">
		<cfelse>
			<cfset thisstruct.type="full">
		</cfif>
	<cfelseif thisstruct.starttime EQ "">
		<cfset thisstruct.type="before">
	<cfelseif thisstruct.endtime EQ "">
		<cfset thisstruct.type="after">
	<cfelse>
		<cfif getAvail.inverse_flag>
			<cfset thisstruct.type="outside">
		<cfelse>
			<cfset thisstruct.type="between">
		</cfif>
	</cfif>
	<cfset stAvail["#thisdate#"]=thisstruct>
</cfloop>



<cfoutput>

<!--- jQuery --->
<link rel="stylesheet" href="assets/themes/cupertino/jquery-ui-1.7.2.custom.css">
<script language="JavaScript" type="text/javascript" src="assets/jquery-1.4.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery.qtip-1.0.0-rc3.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		//add event listener to month dropdown to redirect page to proper month on change
		$('select[name=selMonth]').change(function(){
			var loc='ref_avail.cfm?cid=#contact_id#&'+$(this).find("option:selected").val();
			location.href=loc;
		});
		
		//add event listen to day blocks to redirect to edit page on click
		$('.day').not('.disabled').click(function(){
			var loc='ref_avail_set.cfm?cid=#contact_id#&day='+$(this).attr('date');
			if($(this).is('[ref_avail_id]'))
				loc=loc + '&ref_avail_id=' + $(this).attr('ref_avail_id');
			window.location=loc;
		})
		
		//add tooltips using jquery.qtip plugin for days that have notes.
		.each(function(){
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
</script>

<style type="text/css">
	.day{
		padding:4px;
		position:relative;
		cursor:pointer;
		word-wrap:break-word;
	}
	.disabled{
		color:##aaa;
		cursor:default;
	}
	##calendar{
		border-bottom:1px solid black;
		border-right:1px solid black;
		table-layout:fixed;
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
		vertical-align:top;
	}
	.daynbr{
		position:absolute;
		left:3px;
		bottom:3px;
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
	.icon-notes{
		display:block;
		float:right;
		background-image:url('assets/themes/cupertino/images/ui-icons_444444_256x240.png');
	}
	.availNotes{
		padding-left:15px;
		color:##66f;
	}
</style>
<style type="text/css" media="print">
	.day{
		min-height:75px;
	}
	##masthead,##ticker,##leftMenu,##siteInfo,##calNav,##availNav{
		display:none;
	}
</style>
<style type="text/css" media="screen">
	.day{
		overflow:hidden;
		height:75px;
	}
</style>


<div id="contentText">

<cfif getRAGlobals.ref_avail_enabled EQ "0">
	<h1>Calendar currently not available</h1>
<cfelse>
	
	<H1 class="pageheading"><div id="availNav" style="float:right;"><a href="ref_avail_fa.cfm?cid=#contact_id#">Multiple Day Entry</a> - <a href="ref_avail_list.cfm?cid=#contact_id#">List</a></div><div style="float:left;">NCSA - Manage Availability</div><a href="javascript:print();" style="font-size:.6em;"><span style="float:left;margin-left:10px;" class="ui-icon ui-icon-print"></span>Print</a><div style="clear:both;"></div></H1>
	<h2>#contactinfo.firstname# #contactinfo.lastname# (#contact_id#)</h2>
	
	
	<div id="calHead">
		#dateformat(dtMoStart,"mmmm, yyyy")#
	</div>
	<!--- legend --->
	<cfinclude template="tpl_ref_avail_legend.cfm">
	
	<div id="calNav">
		
		<!--- only show prev/next links if applicable --->
		<cfif NOT (month(dtMoStart) EQ month(getRAGlobals.ref_avail_sd) AND year(dtMoStart) EQ year(getRAGlobals.ref_avail_sd))>
			<div style="float:left;"><a href="ref_avail.cfm?cid=#contact_id#&month=#month(dateadd("m",-1,dtMoStart))#&year=#year(dateadd("m",-1,dtMoStart))#">&lt; Prev</a></div>
		</cfif>
		<cfif NOT (month(dtMoStart) EQ month(getRAGlobals.ref_avail_ed) AND year(dtMoStart) EQ year(getRAGlobals.ref_avail_ed))>
			<div style="float:right;"><a href="ref_avail.cfm?cid=#contact_id#&month=#month(dateadd("m",1,dtMoStart))#&year=#year(dateadd("m",1,dtMoStart))#">Next &gt;</a></div>
		</cfif>
		<div style="text-align:center;">
			<select name="selMonth" style="text-align:right;">
				<cfset dtloopstart=createdate(year(getRAGlobals.ref_avail_sd),month(getRAGlobals.ref_avail_sd),1)>
				<cfloop condition="datediff(""d"",dtloopstart,getRAGlobals.ref_avail_ed) GTE 0">
					<cfset loopmo=month(dtloopstart)>
					<cfset loopyr=year(dtloopstart)>
					<cfset dtloopstart=dateadd("m",1,dtloopstart)>
					<option value="month=#loopmo#&year=#loopyr#" <cfif loopmo EQ month AND loopyr EQ year>selected="selected"</cfif>>#monthasstring(loopmo)#, #loopyr#</option>
				</cfloop>
			</select>
		</div>
	</div>
	
	<table width="100%" cellpadding="0" cellspacing="0" id="calendar">
		<tr>
			<th>
				Sunday
			</th>
			<th>
				Monday
			</th>
			<th>
				Tuesday
			</th>
			<th>
				Wednesday
			</th>
			<th>
				Thursday
			</th>
			<th>
				Friday
			</th>
			<th>
				Saturday
			</th>
		</tr>
		<tr>
		<cfset dow=1>
		<cfloop condition="dtStart LTE dtEnd">
			<cfif dow GT 7>
				</tr>
				<tr>
				<cfset dow=1>
			</cfif>
			
			<!--- get availability if exists --->
			<cfif structkeyexists(stAvail,"#dateformat(dtStart,"mmddyyyy")#")>
				<cfset thisstruct=stAvail["#dateformat(dtStart,"mmddyyyy")#"]>
				<cfset ref_avail_id=thisstruct.ref_avail_id>
				<cfif thisstruct.type EQ "full">
					<cfset thisavail="full">
				<cfelseif thisstruct.type EQ "never">
					<cfset thisavail="none">
				<cfelse>
					<cfset thisavail="partial">
				</cfif>
				<cfset notes=thisstruct.notes>
				<cfset availText=thisstruct.desc>
			<cfelse>
				<cfset ref_avail_id="">
				<cfset thisavail="none">
				<cfset availText="">
				<cfset notes="">
			</cfif>
			
			<!--- set bg color --->
			<cfswitch expression="#thisavail#">
				<cfcase value="full">
					<cfset bgclass="fullavail">
				</cfcase>
				<cfcase value="partial">
					<cfset bgclass="partialavail">
				</cfcase>
				<cfdefaultcase>
					<cfif month(dtStart) NEQ month OR dtStart LT getRAGlobals.ref_avail_sd OR dtStart GT getRAGlobals.ref_avail_ed>
						<cfset bgclass="">
					<cfelse>
						<cfset bgclass="unavail">
					</cfif>
				</cfdefaultcase>
			</cfswitch>
			
			<td class="#bgclass#">
			
			
				<div class="day <cfif month(dtStart) NEQ month OR dtStart LT getRAGlobals.ref_avail_sd OR dtStart GT getRAGlobals.ref_avail_ed>disabled</cfif>" date="#dateformat(dtStart,"mm-dd-yyyy")#" <cfif ref_avail_id NEQ "">ref_avail_id="#ref_avail_id#"</cfif>>
					<div class="daynbr">#day(dtStart)#</div>
					<cfif notes NEQ "">
						<span class="ui-icon ui-icon-pencil icon-notes"></span>
					</cfif>
					<div class="availText">#availText#</div>
					<div class="availNotes">#notes#</div>
				</div>
			</td>
			<cfset dtStart=dateadd("d",1,dtStart)>
			<cfset dow=dow+1>
		</cfloop>
		</tr>
	</table>
	
	
	<div style="height:20px;"></div>

</cfif>
</cfoutput>
</div>
<cfinclude template="_footer.cfm">

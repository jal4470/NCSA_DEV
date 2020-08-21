
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 

<cftry>

	<cfif isdefined("form.btnCancel")>
		<cflocation url="ref_avail.cfm?cid=#form.contact_id#" addtoken="No">
	</cfif>
	
	<!--- validate --->
	<cfif not isdefined("form.avail")>
		<cfthrow message="Please pick an availability type">
	</cfif>
	<cfif form.datelist EQ "">
		<cfthrow message="Please pick at least one date">
	</cfif>
		
	<!--- get current availability for these dates --->
	<cfquery datasource="#application.dsn#" name="curAvail">
		select *, dbo.f_get_ref_avail_desc(ref_avail_id) as avail_desc from tbl_ref_avail
		where contact_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#form.contact_id#">
		and date in (#listqualify(form.datelist,"'")#)
		order by date
	</cfquery>
	
	
	<cfif isdefined("form.btnSave")>
		
		<cfset swContinue=false>
	
	
		<cfif curAvail.recordcount EQ 0>
		
			<cfset swContinue=true>
			
		</cfif>
	<cfelseif isdefined("form.btnConfirm")>
		<CFSET swContinue=true>
	</cfif>
	
	<cfif swContinue>
		<!--- filter datelist by what is NOT checked --->
		<cfif isdefined("form.chkDates")>
			<cfset filterlist=form.chkDates>
		<cfelse>
			<cfset filterlist="">
		</cfif>
		<cfloop query="curAvail">
			<cfif listfind(filterlist,"#dateformat(curAvail.date,"mm/dd/yyyy")#") EQ 0>
				<!--- remove from datelist --->
				<cfset form.datelist=listdeleteat(form.datelist,listfind(form.datelist,"#dateformat(curAvail.date,"mm/dd/yyyy")#"))>
			</cfif>
		</cfloop>
	
		<cfloop list="#form.datelist#" index="i">
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
					<cfset enddate="#i# #form.time2#">
					<cfset inverseflag="0">
				</cfcase>
				<cfcase value="after">
					<cfset startdate="#i# #form.time1#">
					<cfset enddate="">
					<cfset inverseflag="0">
				</cfcase>
				<cfcase value="between">
					<cfset startdate="#i# #form.time1#">
					<cfset enddate="#i# #form.time2#">
					<cfset inverseflag="0">
				</cfcase>
				<cfcase value="around">
					<cfset startdate="#i# #form.time1#">
					<cfset enddate="#i# #form.time2#">
					<cfset inverseflag="1">
				</cfcase>
				<cfdefaultcase>
					<cfset startdate="">
					<cfset enddate="">
					<cfset inverseflag="1">
				
					<!--- if no notes, remove record --->
					<cfif form.notes EQ "">
						<cfstoredproc datasource="#application.dsn#" procedure="p_remove_ref_avail">
							<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@contact_id" value="#contact_id#">
							<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@date" value="#dateformat(i,"mm/dd/yyyy")#">
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
				
				
				<!--- create --->
				<cfstoredproc datasource="#application.dsn#" procedure="p_create_ref_avail">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@contact_Id" value="#form.contact_id#">
					<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@date" value="#dateformat(i,"mm/dd/yyyy")#">
					<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@start_time" value="#startdate#" null="#yesnoformat(startdate EQ "")#">
					<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@end_time" value="#enddate#" null="#yesnoformat(enddate EQ "")#">
					<cfprocparam cfsqltype="CF_SQL_BIT" dbvarname="@inverse_flag" value="#inverseflag#">
					<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@notes" value="#form.notes#">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@ref_avail_id" variable="ref_avail_id" type="Out">
				</cfstoredproc>
			</cfif>
		</cfloop>
		
		<cflocation url="ref_avail_fa.cfm?cid=#form.contact_id#" addtoken="No">
	</cfif>

	<cfcatch>
		<cfinclude template="error.cfm">
	</cfcatch>

</cftry>
	
	<!--- get contact info --->
	<cfinvoke component="#application.sitevars.cfcpath#.contact" method="getContactInfo" contactID="#form.contact_id#" returnvariable="contactinfo"></cfinvoke>



<!--- display confirm page --->
<script language="JavaScript" type="text/javascript" src="assets/jquery-1.4.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('#linkSelAll').toggle(function(){
			$('input[name=chkDates]').attr('checked','checked');
		},
		function(){
			$('input[name=chkDates]').attr('checked','');
		});
	});
</script>
	
<cfoutput>

<div id="contentText">

<H1 class="pageheading">NCSA - Availability Fast Assign</H1>
<h2>#contactinfo.firstname# #contactinfo.lastname# (#contact_id#)</h2>


<h3 style="margin-top:20px;">
	Some of the days you picked currently have availability set.  
	Please check the days you would like to change.
</h3>

<form name="theform" method="post">
	<input type="Hidden" name="time1" value="#form.time1#">
	<input type="Hidden" name="time2" value="#form.time2#">
	<input type="Hidden" name="avail" value="#form.avail#">
	<input type="Hidden" name="datelist" value="#form.datelist#">
	<input type="Hidden" name="notes" value="#form.notes#">
	<input type="Hidden" name="contact_id" value="#form.contact_id#">
	
	<div>
		<a id="linkSelAll" href="javascript:void(0);">Select All</a>
	</div>
	<cfloop query="curAvail">
		<input type="Checkbox" name="chkDates" value="#dateformat(curAvail.date,"mm/dd/yyyy")#">#dateformat(curAvail.date,"m/d/yyyy")# - #curAvail.avail_desc#<br>
	</cfloop>
	
	<div style="height:20px;"></div>
	<input type="Button" value="Back" onclick="history.go(-1);">
	<input type="submit" name="btnCancel" value="Cancel">
	<input type="Submit" name="btnConfirm" value="Continue">
</form>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">

<!--- 
	FileName:	rptRefAssSum.cfm
	Created on: 03/03/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
04/17/09 - aarnone - report mods: default dates, league only games, sort, scroll bar.
5/25/2010 - B. Cooper
9293-modified query to use v_referees_all view instead of v_referees
06/16/17 - mgreenberg (TICKET NCSA22821) - report mods: updated datepicker and sorter. 
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 

<cfif isDefined("FORM.WeekendFrom")>
	<cfset WeekendFrom = dateFormat(FORM.WeekendFrom,"mm/dd/yyyy") > 
<cfelse>
	<cfset WeekendFrom = dateFormat(session.currentseason.startdate,"mm/dd/yyyy") > 
</CFIF>

<cfif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo   = dateFormat(FORM.WeekendTo,"mm/dd/yyyy") >
<cfelse>
	<cfset WeekendTo   = dateFormat(session.currentseason.enddate,"mm/dd/yyyy") >
</CFIF>

<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 

<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<cfoutput>
<div id="contentText">
<H1 class="pageheading">
	NCSA - Referee Assignment Summary 
	<cfif isDefined("form.getRefAss")>
		<input id="printBtn" type="button" value="Print Report" />
	</cfif>
</H1>
<!--- <h2>yyyyyy </h2> --->

<FORM name="RefAssSum" action="rptRefAssSum.cfm" method="post">
<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%" >
	<TR><TD align="right">
			<B>From</B> &nbsp;
			<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
			&nbsp;&nbsp;&nbsp;
			<B>To</B> &nbsp;
			<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
			&nbsp;&nbsp;&nbsp;
			<INPUT type="Submit" name="getRefAss" value="Go">
		</TD>
	</TR>
</table>
</FORM> <!--- End of Selection form --->

 
 

<CFIF isDEfined("FORM.getRefAss")>
	 
		<!--- orig ----
			SELECT xgo.Contact_id, xgo.game_official_type_id, co.FirstName, co.LastName, COUNT(*) as total_accepted
			  FROM XREF_GAME_OFFICIAL xgo 
			  			INNER JOIN TBL_CONTACT co ON co.CONTACT_ID = xgo.Contact_id
						INNER JOIN TBL_GAME  g  ON g.GAME_ID = xgo.GAME_ID
			 WHERE xgo.Ref_accept_YN = 'Y'
			   AND (	g.game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#"> 
					 AND g.game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#"> 
					)	
			 GROUP BY xgo.Contact_id, xgo.game_official_type_id, co.FirstName, co.LastName
			 ORDER BY co.LastName, co.FirstName, xgo.Contact_id, xgo.game_official_type_id
			-- ORDER BY xgo.Contact_id, xgo.game_official_type_id 
		--->
		<!--- counts of refs change ----
		 select DISTINCT vr.contact_id, vr.FirstName, vr.LastName,
				(select COUNT(*) from XREF_GAME_OFFICIAL xg1   
				  where xg1.Contact_id = vr.Contact_id 
				    and xg1.game_official_type_id = 1			
					and xg1.Ref_accept_YN = 'Y') 		as total_REF,
				(select COUNT(*) from XREF_GAME_OFFICIAL xg2   
				  where xg2.Contact_id = vr.Contact_id 
				    and xg2.game_official_type_id = 2 			
					and xg2.Ref_accept_YN = 'Y') 		as total_AR1,
				(select COUNT(*) from XREF_GAME_OFFICIAL xg3   
				  where xg3.Contact_id = vr.Contact_id 
				    and xg3.game_official_type_id = 3 			
					and xg3.Ref_accept_YN = 'Y') 		as total_AR2
		  from V_REFEREES vr 
		  			inner JOIN   XREF_GAME_OFFICIAL xgo ON vr.Contact_id = xgo.Contact_id
		  			inner JOIN  TBL_GAME  			g  ON g.GAME_ID = xgo.GAME_ID
		 WHERE vr.Certified = 'Y'
		   AND ( g.game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#"> 
		   		 AND  
				 g.game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#"> 
				)	
		 ORDER BY vr.LastName, vr.FirstName 
		 --->
	<cfstoredproc procedure="P_REP_REF_ASSIGNMENT_SUMMARY" datasource="#SESSION.DSN#">
		<cfprocparam type="in" cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#">
		<cfprocparam type="in" cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#">
		<cfprocresult name="qRefCounts" resultset="1">
	</cfstoredproc>	<!--- <cfdump var="#qRefCounts#"> --->

	<CFIF qRefCounts.RECORDCOUNT EQ 0>
		<span class="red"><b>There are no assignments for the date range #VARIABLES.WeekendFrom# - #VARIABLES.WeekendTo#</b></span>
	<CFELSE>
		<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
			<tr class="tblHeading">
				<TD width="39%">Referee </TD>
				<TD width="15%">Ref Count</TD>
				<TD width="15%">AR1 Count</TD>
				<TD width="14%">AR2 Count</TD>
				<TD width="17%">Total</TD>
			</TR>
		</table>
		
		<!--- <div style="overflow:auto; height:300px; border:1px ##cccccc solid;"> --->
		<div class="overflowbox" style="height:300px;">
		<table cellspacing="0" cellpadding="2" align="left" border="0" width="100%" >
			<cfset ctREF_GRANDTOTAL = 0>
			<cfset ctAR1_GRANDTOTAL = 0>
			<cfset ctAR2_GRANDTOTAL = 0>
			<cfset ctTotalForREF = 0>
			<cfset ctTotal_TOTAL = 0>
			<cfset ctTR = 0> 
			<CFLOOP query="qRefCounts">
				<cfset ctTR = ctTR + 1>
				<CFSET ctTotalForREF = total_REF + total_AR1 + total_AR2 >
				<cfset ctREF_GRANDTOTAL = ctREF_GRANDTOTAL + total_REF >
				<cfset ctAR1_GRANDTOTAL = ctAR1_GRANDTOTAL + total_AR1 >
				<cfset ctAR2_GRANDTOTAL = ctAR2_GRANDTOTAL + total_AR2 >
				<cfset ctTotal_TOTAL = ctTotal_TOTAL + ctTotalForREF >
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,VARIABLES.ctTR)#"> 
					<TD width="40%" valign="top" class="tdUnderLine">#LastName#, #FirstName# </TD>
					<TD width="15%" valign="top" class="tdUnderLine">#total_REF# </TD>
					<TD width="15%" valign="top" class="tdUnderLine">#total_AR1# </TD>
					<TD width="15%" valign="top" class="tdUnderLine">#total_AR2# </TD>
					<TD width="15%" valign="top" class="tdUnderLine">#ctTotalForREF# </TD>
				</TR>
			</CFLOOP>	
		</TABLE>
		</div>
		<table cellspacing="0" cellpadding="2" align="left" border="0" width="100%">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,VARIABLES.ctTR)#"> 
				<TD width="39%" valign="top" class="tdUnderLine"><b>Grand Totals</b> for #VARIABLES.ctTR# Refs </TD>
				<TD width="15%" valign="top" class="tdUnderLine"><b>#VARIABLES.ctREF_GRANDTOTAL# </b></TD>
				<TD width="15%" valign="top" class="tdUnderLine"><b>#VARIABLES.ctAR1_GRANDTOTAL# </b></TD>
				<TD width="14%" valign="top" class="tdUnderLine"><b>#VARIABLES.ctAR2_GRANDTOTAL# </b></TD>
				<TD width="17%" valign="top" class="tdUnderLine"><b>#VARIABLES.ctTotal_TOTAL#</b></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF> 	
	
</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">
<cfoutput>
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=WeekendFrom],input[name=WeekendTo]').datepicker();
		
		$("##printBtn").click(function () {
			window.open('rptRefAssSum_PDF.cfm?WeekendFrom=#WeekendFrom#&WeekendTo=#WeekendTo#');
		});
		
	});
</script>
</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">





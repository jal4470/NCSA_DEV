<!------------------------------
	MODIFICATIONS
	07/27/2017 - A.Pinzone - Ticket NCSA27024 
	-- Added date range
--------------------------------->

<!------------------------------>
<!--- SET UP LOCAL VARIABLES --->
<!------------------------------>

<CFSET clubID = SESSION.USER.CLUBID> 

<cfif isDefined("form.WeekendFrom") and form.WeekendFrom NEQ "">
	<cfset WeekendFrom = form.WeekendFrom>
<cfelseif isDefined("url.WeekendFrom") AND url.WeekendFrom NEQ "">
	<cfset WeekendFrom = url.WeekendFrom>
<cfelse>
	<cfset WeekendFrom = "">
</cfif>

<cfif isDefined("form.WeekendTo") and form.WeekendTo NEQ "">
	<cfset WeekendTo = form.WeekendTo>
<cfelseif isDefined("url.WeekendTo") AND url.WeekendTo NEQ "">
	<cfset WeekendTo = url.WeekendTo>
<cfelse>
	<cfset WeekendTo = "">
</cfif>

<!---------------->
<!--- GET DATA --->
<!---------------->

<!--- <CFQUERY name="qRefCounts" datasource="#SESSION.DSN#">

		 <!--- UPDATED QUERY WITH JOINS - J. RAB 7/30/2013 --->
		 SELECT		DISTINCT VR.contact_id, 
		 			VR.FirstName, 
		 			VR.LastName, 
		 			XG1.TOTAL_REF, 
		 			XG2.TOTAL_AR1, 
		 			XG3.TOTAL_AR2
		 FROM		V_REFEREES_ALL VR
		 LEFT JOIN	(	SELECT 		XG1.Contact_id, 
		 							COUNT(1) as TOTAL_REF 
		 				FROM 		XREF_GAME_OFFICIAL XG1
		 				INNER JOIN	TBL_GAME g ON g.GAME_ID = XG1.GAME_ID 
				  		WHERE 		XG1.game_official_type_id = 1 			
						AND			XG1.Ref_accept_YN = 'Y'
				   		AND 		(g.game_date BETWEEN <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#">  
				   									 AND <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#">)
						GROUP BY	XG1.Contact_id
					) XG1 ON XG1.CONTACT_ID = VR.contact_id
		 LEFT JOIN	(	SELECT 		XG2.Contact_id, 
		 							COUNT(1) as TOTAL_AR1 
		 				FROM 		XREF_GAME_OFFICIAL XG2
		 				INNER JOIN	TBL_GAME g ON g.GAME_ID = XG2.GAME_ID 
				  		WHERE 		XG2.game_official_type_id = 2 			
						AND			XG2.Ref_accept_YN = 'Y'
				   		AND 		(g.game_date BETWEEN <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#">  
				   									 AND <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#">)
						GROUP BY	XG2.Contact_id
					) XG2 ON XG2.CONTACT_ID = VR.contact_id
		 LEFT JOIN	(	SELECT 		XG3.Contact_id, 
		 							COUNT(1) as TOTAL_AR2 
		 				FROM 		XREF_GAME_OFFICIAL XG3
		 				INNER JOIN	TBL_GAME g ON g.GAME_ID = XG3.GAME_ID 
				  		WHERE 		XG3.game_official_type_id = 3 			
						AND			XG3.Ref_accept_YN = 'Y'
				   		AND 		(g.game_date BETWEEN <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#">  
				   									 AND <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#">)
						GROUP BY	XG3.Contact_id
					) XG3 ON XG3.CONTACT_ID = VR.contact_id
		 WHERE		VR.active_yn = 'Y'
		 AND		(XG1.TOTAL_REF + XG2.TOTAL_AR1 + XG3.TOTAL_AR2) > 0 -- Only get referees with assignments
		 --AND		VR.Certified = 'Y'
		 ORDER BY	VR.LASTNAME, VR.FirstName
		 
</CFQUERY>	<!--- <cfdump var="#qRefCounts#"> ---> --->

	<cfstoredproc procedure="P_REP_REF_ASSIGNMENT_SUMMARY" datasource="#SESSION.DSN#">
		<cfprocparam type="in" cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#">
		<cfprocparam type="in" cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#">
		<cfprocresult name="qRefCounts" resultset="1">
	</cfstoredproc>	<!--- <cfdump var="#qRefCounts#"> --->

<!---------------------------->
<!--- PRODUCE PDF DOCUMENT --->
<!---------------------------->

<cfdocument margintop=".25" marginbottom=".5" format="pdf" name="print_report" localUrl="yes">
	<cfoutput>
		<html>
			<head>
				<title>Report</title>
				<link rel="stylesheet" href="2col_leftNav.css?t=2" type="text/css" />
				<style>
					##contentText { margin: 0 !important;}
					##contentText table { font-family: Tahoma, Verdana,Arial,sans-serif; font-size: 11px !important;}
					h1.pageheading {font-family: Tahoma, Verdana,Arial,sans-serif; font-size: 18px; color: ##334d55;}
					.tblHeading
					{	background-color: ##3399CC;
						font-size: 12px;
						font-weight: bold;
						color:##ffffff;
					}
					h2 {
					font-size: 114%;
					color: ##006699;
					}
					h1, h2, h3, h4, h5, h6 {
					font-family: Tahoma, Verdana,Arial,sans-serif;
					margin: 0px;
					padding: 0px;
					}
					.dateRange {
						font-size: 12px;
						font-family: Tahoma, Verdana,Arial,sans-serif;
					}
				</style>
			</head>
			<body>
				<div id="contentText">
					<H1 class="pageheading">NCSA - Referee Assignment Summary Report</H1>
					<!--- <br> <h2>yyyyyy </h2> --->
							
					<CFIF qRefCounts.RECORDCOUNT EQ 0>
						<span class="red"><b>There are no assignments for the date range #VARIABLES.WeekendFrom# - #VARIABLES.WeekendTo#</b></span>
					<CFELSE>
						<p class="dateRange">From: #VARIABLES.WeekendFrom# &nbsp;&nbsp; To: #VARIABLES.WeekendTo#</p>
						<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
							<tr class="tblHeading">
								<TD width="39%">Referee </TD>
								<TD width="15%">Ref Count</TD>
								<TD width="15%">AR1 Count</TD>
								<TD width="14%">AR2 Count</TD>
								<TD width="17%">Total</TD>
							</TR>
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
							<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,VARIABLES.ctTR)#"> 
								<TD width="39%" valign="top" class="tdUnderLine"><b>Grand Totals</b> for #VARIABLES.ctTR# Refs </TD>
								<TD width="15%" valign="top" class="tdUnderLine"><b>#VARIABLES.ctREF_GRANDTOTAL# </b></TD>
								<TD width="15%" valign="top" class="tdUnderLine"><b>#VARIABLES.ctAR1_GRANDTOTAL# </b></TD>
								<TD width="14%" valign="top" class="tdUnderLine"><b>#VARIABLES.ctAR2_GRANDTOTAL# </b></TD>
								<TD width="17%" valign="top" class="tdUnderLine"><b>#VARIABLES.ctTotal_TOTAL#</b></TD>
							</TR>
						</TABLE>
					</CFIF>
	
				</div>
			</body>
		</html>
	</cfoutput>
</cfdocument>

<cfheader name="Content-Disposition" 
value="inline; filename=print_report.pdf">

<cfcontent type="application/pdf" variable="#toBinary(print_report)#">
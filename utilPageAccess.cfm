<!--- 
	FileName:	utilPageAccess.cfm
	Created on: 05/27/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

05/19/09 - aa - new report Ticket# 7584
--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Page Access </H1>
<!--- <br> <h2>yyyyyy </h2> --->

<cfif isDefined("FORM.WeekendFrom")>
	<cfset WeekendFrom = dateFormat(FORM.WeekendFrom,"mm/dd/yyyy") > 
<cfelse>
	<cfset WeekendFrom   = dateFormat(dateAdd("d",-1,now()),"mm/dd/yyyy") >
</cfif>

<cfif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo   = dateFormat(FORM.WeekendTo,"mm/dd/yyyy") >
<cfelse>
	<cfset WeekendTo   = dateFormat(now(),"mm/dd/yyyy") >
</cfif>

<cfif isDefined("FORM.sortBy")>
	<cfset sortBy = FORM.sortBy>
<cfelse>
	<cfset sortBy = "date">
</cfif>

<cfset errMsg = "">

<cfif isDefined("FORM.GO")>
	<cfset weekendtoPlus1 = dateFormat(dateAdd("d",1,VARIABLES.WeekendTo),"mm/dd/yyyy") >
	<cfquery name="qSiteAccess" datasource="#SESSION.DSN#">
		Select p.pageAccessLog_id, p.dt_access_date, p.user_id, p.session_id, p.ip_address, p.url, c.username, p.siteAccessLog_ID
		  FROM cpc_pageAccessLog p INNER JOIN tbl_Contact c ON c.contact_id = p.user_id
		 where (	p.dt_access_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#">
				AND p.dt_access_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.weekendtoPlus1#">
				)
		ORDER BY
				<cfswitch expression="#VARIABLES.sortBy#">
					<cfcase value="url">  p.url,		p.dt_access_date DESC , dbo.formatDateTime(p.dt_access_date,'HH:MM 24') DESC </cfcase>
					<cfcase value="ip">	  p.ip_address, p.dt_access_date DESC , dbo.formatDateTime(p.dt_access_date,'HH:MM 24') DESC </cfcase>
					<cfcase value="user"> c.username, 	p.dt_access_date DESC , dbo.formatDateTime(p.dt_access_date,'HH:MM 24') DESC </cfcase>
					<cfdefaultcase><!--- date --->   	p.dt_access_date DESC , dbo.formatDateTime(p.dt_access_date,'HH:MM 24') DESC </cfdefaultcase>
				</cfswitch> 
	</cfquery>
</cfif>

<FORM name="siteaccess" action="utilPageAccess.cfm"  method="post">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%" >
	<TR><TD align="left">
			<B>From</B> &nbsp;
				<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9" readonly> 
				<input type="Hidden" name="DOWfrom"  value="">
				&nbsp;  <cfset dpMM = datePart("m",VARIABLES.WeekendFrom)-1>
						<cfset dpYYYY = datePart("yyyy",VARIABLES.WeekendFrom)>
						<a href="javascript:show_calendar('siteaccess.WeekendFrom','siteaccess.DOWfrom','#dpMM#','#dpYYYY#');" 
							onmouseover="window.status='Date Picker';return true;" 
							onmouseout="window.status='';return true;"> 
							<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
						</a>
			#repeatString("&nbsp;",3)#
			<B>To</B> &nbsp;
				<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9" readonly>
				<input type="Hidden" name="DOWto"  value="">
				&nbsp;  <cfset dpMM = datePart("m",VARIABLES.WeekendTo)-1>
						<cfset dpYYYY = datePart("yyyy",VARIABLES.WeekendTo)>
						<a href="javascript:show_calendar('siteaccess.WeekendTo','siteaccess.DOWto','#dpMM#','#dpYYYY#');" 
							onmouseover="window.status='Date Picker';return true;" 
							onmouseout="window.status='';return true;"> 
							<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
						</a>

			#repeatString("&nbsp;",3)#
			<b>Sort</b>
				<SELECT name="sortBy"> 
					<OPTION value="date"  	<cfif sortBy EQ "date" >	selected</cfif> >Date   </OPTION>
					<OPTION value="url"		<cfif sortBy EQ "url" > 	selected</cfif> >URL</OPTION>
					<OPTION value="ip"		<cfif sortBy EQ "ip" > 		selected</cfif> >IP</OPTION>
					<OPTION value="user"   	<cfif sortBy EQ "user"  >	selected</cfif> >User</OPTION>
				</SELECT>

			#repeatString("&nbsp;",3)#
			<input type="SUBMIT" name="Go"  value="Go" >  
		</td>
	</tr>

	<cfif len(trim(errMsg))>
		<tr><td colspan="1" align="center">
				<span class="red"><b>#VARIABLES.errMsg#</b></span>
			</td>
		</tr>
	</cfif>

</table>	
</FORM>

<cfset ctLoop	= 0>

<CFIF IsDefined("qSiteAccess")>
	<table cellspacing="0" cellpadding="0" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TD width="15%">Access Date</TD>
			<TD width="15%">Username</TD>
			<TD width="20%">Session id </TD>
			<td width="20%">IP address</td>
			<td width="30%">URL</td>
		</TR>
	</table>	
	<div class="overflowbox" style="height:500px;">
	<table cellspacing="0" cellpadding="2" align="left" border="0" width="100%"  >
	<cfloop query="qSiteAccess">
		<cfset ctLoop = ctLoop + 1>
		<cfset classValue = "class='tdUnderLine'"> 
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctLoop)#">
			<TD width="15%" valign="top" > #dateFormat(dt_access_date,"mm/dd/yy")#  #timeFormat(dt_access_date,"hh:mm tt")#	</TD>
			<TD width="15%" valign="top" > #user_id# - #username#	</TD>
			<TD width="20%" valign="top" > #session_id#
				<!--- <a href="utilSessionPages.cfm?sid=#Session_id#&dt=#dateFormat(dt_access_date,"mm/dd/yy")#&lid=#siteAccessLog_id#" target="_blank">#session_id#</a> --->
			</TD>
			<TD width="20%" valign="top" > #ip_address#	</TD>
			<TD width="30%" valign="top" > #url#		</TD>
		</TR>
		<!--- <tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctLoop)#">
			<TD colspan="2" #classValue# >	&nbsp;	</TD>
			<TD colspan="3" valign="top" #classValue# >	#browser_info#		</TD>
		</TR> --->
		 
	</cfloop>
	</table>
	</DIV>
	<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
		<tr bgcolor="##CCE4F1">
			<td colspan="6" align="center">
				<b> Total between #WeekendFrom# and #WeekendTo# = #ctLoop# </b>
			</td>
		</tr>
	</table>
</CFIF>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">






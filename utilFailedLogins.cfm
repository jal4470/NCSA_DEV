<!--- 
	FileName:	utilFailedLogins.cfm
	Created on: 05/19/2009
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

<H1 class="pageheading">NCSA - Failed Log Ins </H1>
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
		Select dt_event_date, userid, session_id, remote_user, remote_host, user_agent, ip_address
		  from cpc_blockedFailedLog
  		 where (	dt_event_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendFrom#">
				AND dt_event_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#weekendtoPlus1#">
				)
		ORDER BY
			<cfswitch expression="#VARIABLES.sortBy#">
				<cfcase value="session"> session_id, dt_event_date DESC , dbo.formatDateTime(dt_event_date,'HH:MM 24') DESC </cfcase>
				<cfcase value="browser"> user_agent, dt_event_date DESC , dbo.formatDateTime(dt_event_date,'HH:MM 24') DESC </cfcase>
				<cfcase value="ip">	 	 ip_address, dt_event_date DESC , dbo.formatDateTime(dt_event_date,'HH:MM 24') DESC </cfcase>
				<cfcase value="user">    userID, 	 dt_event_date DESC , dbo.formatDateTime(dt_event_date,'HH:MM 24') DESC </cfcase>
				<cfdefaultcase><!--- date --->		 dt_event_date DESC , dbo.formatDateTime(dt_event_date,'HH:MM 24') DESC </cfdefaultcase>
			</cfswitch> 
	</cfquery>
</cfif>

<FORM name="siteaccess" action="utilFailedLogins.cfm"  method="post">
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
					<OPTION value="date"  	<cfif sortBy EQ "date">	   selected</cfif> >Date    </OPTION>
					<OPTION value="user"   	<cfif sortBy EQ "user">	   selected</cfif> >User	</OPTION>
					<OPTION value="session" <cfif sortBy EQ "session"> selected</cfif> >Session </OPTION>
					<OPTION value="ip"		<cfif sortBy EQ "ip"> 	   selected</cfif> >Ip		</OPTION>
					<OPTION value="browser" <cfif sortBy EQ "browser"> selected</cfif> >Browser </OPTION>
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
	<div class="overflowbox" style="height:500px;">
	<table cellspacing="0" cellpadding="2" align="left" border="0"   >
		<tr class="tblHeading">
			<TD>Access Date</TD>
			<TD>User </TD>
			<TD>Session id  </TD>
			<td>IP address</td>
			<td>Remote User</td>
			<td>Remote Host</td>
			<TD>Browser info </TD>
		</TR>
	<cfloop query="qSiteAccess">
		<cfset ctLoop = ctLoop + 1>
		<cfset classValue = "class='tdUnderLine'">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctLoop)#">
			<TD valign="top" #classValue# nowrap > &nbsp; #dateFormat(dt_event_date,"mm/dd/yy")#  #timeFormat(dt_event_date,"hh:mm tt")#	</TD>
			<TD valign="top" #classValue# nowrap > &nbsp; #userid#	    </TD>
			<TD valign="top" #classValue# nowrap > &nbsp; #session_id#  </TD>
			<TD valign="top" #classValue# nowrap > &nbsp; #ip_address#	</TD>
			<TD valign="top" #classValue# nowrap > &nbsp; #remote_user#	</TD>
			<TD valign="top" #classValue# nowrap > &nbsp; #remote_host#	</TD>
			<TD valign="top" #classValue# nowrap > &nbsp; #user_agent#	</TD>
		</TR>
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

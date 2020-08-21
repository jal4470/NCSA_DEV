<!--- 
	FileName:	refPublishAssignDate.cfm
	Created on: 01/15/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: this file will allow a user to set the date limit to which a referee can view assignments.
			 the RefAssignViewDateYN must be set to Y for the daye limit to be in effect, if it is N, then
			 the date limit is ignored and refs can see all assignments 
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<script language="JavaScript" src="DatePicker.js"></script>

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Set Publish Referee Assignment Date</H1>
<br> <!--- <h2>  </h2> --->

<CFIF isDefined("FORM.setDate")>
	<CFIF isDate(FORM.refPubAssDate)>
		<CFQUERY name="qUpdatePubAssDate" datasource="#SESSION.DSN#">
			UPDATE tbl_global_vars
			   SET _VALUE = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.refPubAssDate#">
			 WHERE _NAME = 'RefAssignViewDate'
		</CFQUERY>
	</CFIF>
</CFIF>

<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading"> <TD> &nbsp;	</TD> </tr>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#"> <!--- currentRow or counter --->
		<TD class="tdUnderLine" > 
			<CFQUERY name="qGetViewYN" datasource="#SESSION.DSN#">
				SELECT _VALUE  FROM tbl_global_vars	 WHERE _NAME = 'RefAssignViewDateYN'
			</CFQUERY>
			<br> The use of the referee assignment date is currently set to: <b>#qGetViewYN._VALUE#</b>
			<br>
			
			<CFQUERY name="qGetViewDate" datasource="#SESSION.DSN#">
				SELECT _VALUE   FROM tbl_global_vars  WHERE _NAME = 'RefAssignViewDate'
			</CFQUERY>
			<br> The date that referees can view assigments is up to: 
				<CFIF isDate(qGetViewDate._VALUE)>
					<CFSET refPubAssDate = dateFormat(qGetViewDate._VALUE,"mm/dd/yyyy")>
					<b>#refPubAssDate#</b> 
				<CFELSE>
					<CFSET refPubAssDate = "">
					<b>No Date Set</b>
				</CFIF>

			<br><br>
			<span class="red">
				<b> Currently, referees can 
				<CFIF qGetViewYN._VALUE EQ "Y" AND isDate(refPubAssDate)>
					view assignments up to #refPubAssDate#
				<CFELSEIF  qGetViewYN._VALUE EQ "Y" AND len(trim(refPubAssDate)) EQ 0>
					view all assignments
				<CFELSEIF  qGetViewYN._VALUE EQ "N"> 
					view all assignments
				</CFIF>
				.</b>
			</span>
		
		</TD>
	</tr>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#"> <!--- currentRow or counter --->
		<TD class="tdUnderLine" >  <br>
			<FORM name="pubAssDate" action="refPublishAssignDate.cfm"  method="post" id="pubAssDate" >
				<B>Set Date</B> &nbsp;
				<CFIF NOT isDate(refPubAssDate)>
					<CFSET refPubAssDate = dateFormat(now(),"mm/dd/yyyy")>
				</CFIF>
				<cfset dpMM = datePart("m",VARIABLES.refPubAssDate)-1>
				<cfset dpYYYY = datePart("yyyy",VARIABLES.refPubAssDate)>
				<INPUT name="refPubAssDate" value="#VARIABLES.refPubAssDate#" size="9" readonly onclick="javascript:show_calendar('pubAssDate.refPubAssDate','pubAssDate.setPubDate','#dpMM#','#dpYYYY#')"> 
				<input type="Hidden" name="setPubDate"  value="">
				&nbsp;
				<a href="javascript:show_calendar('pubAssDate.refPubAssDate','pubAssDate.setPubDate','#dpMM#','#dpYYYY#');" 
					onmouseover="window.status='Date Picker';return true;" 
					onmouseout="window.status='';return true;"> 
					<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
				</a>
				<input type="SUBMIT" name="setDate"  value="Set Date" >
			</FORM>
		</TD>
	</tr>
</table>	


</cfoutput>
</div>
<cfinclude template="_footer.cfm">

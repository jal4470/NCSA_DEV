<!--- 
	FileName:	seasonEdit.cfm
	Created on: 09/09/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->


<cfif isDefined("URL.season_id") AND len(trim(URL.season_id))>
	<CFSET season_ID = URL.season_id>
<cfelse>
	<cflocation url="seasonMaintenance.cfm">
</cfif>


<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<cfinclude template="_checkLogin.cfm">

<script language="JavaScript" src="DatePicker.js"></script>

<CFSET errMSG = "">

<CFQUERY name="GetSeason" datasource="#SESSION.DSN#">
	Select season_id, season_startDate, season_endDate, season_Sf 	
	  from tbl_season 
	 where  season_id = #VARIABLES.season_id#
</CFQUERY>

<CFIF GetSeason.recordCount>
	<CFSET SeasonStart = GetSeason.season_startDate>
	<CFSET SeasonEnd   = GetSeason.season_endDate>
	<CFSET SeasonSF    = GetSeason.season_SF>
<CFELSE>
	<CFSET SeasonStart = "">
	<CFSET SeasonEnd   = "">
	<CFSET SeasonSF    = "">
</CFIF>

<!--- ================================================================ --->
<CFIF isDefined("Form.SeasonStart") and isDefined("Form.SeasonEnd") and len(trim(Form.SeasonStart)) and len(trim(Form.SeasonEnd))>
	<CFSET SeasonId  = Form.SeasonId> 
	<CFSET SeasonYear = datePart("yyyy",Form.SeasonStart)>
	<CFSET SeasonSF	  = Form.SeasonSF>
	<CFIF SeasonSF EQ "SPRING">
		<CFSET seasonCode = "SPRING" & Mid(SeasonYear,3,2)>
	<CFELSE>
		<CFSET seasonCode = "FALL" & Mid(SeasonYear,3,2)>
	</CFIF>
	<CFSET season_startDate 	= Form.SeasonStart>
	<CFSET season_endDate 		= Form.SeasonEnd>
	<CFSET createdBy = Session.USER.ContactID>

	<CFQUERY name="qGetSeason" datasource="#SESSION.DSN#">
		Select Count(*) as SeasonCount 
		  from tbl_season 
		 Where seasonCode = '#seasonCode#'
		   and season_id <> #seasonId#
	</CFQUERY>

	<CFIF qGetSeason.SeasonCount>
		<CFSET errMsg = errMSG & " The Season " & seasonCode & " Already Exists!">
	<CFELSE>
		<cfstoredproc procedure="p_update_season" datasource="#SESSION.DSN#">
			<cfprocparam type="In"  dbvarname="@season_id" 			cfsqltype="CF_SQL_NUMERIC"  value="#SeasonID#">
			<cfprocparam type="In"  dbvarname="@season_year" 		cfsqltype="CF_SQL_NUMERIC"  value="#SeasonYear#">
			<cfprocparam type="In"  dbvarname="@season_SF"  		cfsqltype="CF_SQL_VARCHAR"  value="#SeasonSF#">
			<cfprocparam type="In"  dbvarname="@seasonCode" 		cfsqltype="CF_SQL_VARCHAR"  value="#seasonCode#">
			<cfprocparam type="In"  dbvarname="@season_startDate" 	cfsqltype="CF_SQL_DATE"     value="#season_startDate#">
			<cfprocparam type="In"  dbvarname="@season_endDate" 	cfsqltype="CF_SQL_DATE"     value="#season_endDate#">
			<cfprocparam type="In"  dbvarname="@createdBy" 			cfsqltype="CF_SQL_NUMERIC"  value="#createdBy#">
		</cfstoredproc>
	</CFIF>
<CFELSE>
	<CFSET errMsg = "Please provide a Start and End date for a season.">
</CFIF>
<!--- ================================================================ --->


<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - EDIT a Season</H1>
<br>

<CFIF len(trim(errMsg))>
	<span class="red">
		<b>#errMsg#</b>
		<br><CFIF isDefined("stValidFields.errorMessage")>
				#stValidFields.errorMessage#
			</CFIF>
	</span>
</CFIF>

<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD> &nbsp;	</TD>
	</tr>
	<tr><TD class="tdUnderLine" nowrap> 
			<form name="frmSeason" method="post" action="SeasonEdit.cfm?season_id=#season_id#">
			<table align="center" width="600">
				<tr><th>Season Start Date:</th> 
					<td><input size="9" name="SeasonStart" value="#SeasonStart#" readonly 
							onclick="javascript:show_calendar('frmSeason.SeasonStart');"> &nbsp;
						<a href="javascript:show_calendar('frmSeason.SeasonStart');" 
							onmouseover="window.status='Date Picker';return true;" 
							onmouseout="window.status='';return true;"> 
						<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
						</a><br><small>Date Format: mm/dd/yyyy</small></td>

					<th>Season End Date:</th> 
					<td><input size="9" name="SeasonEnd" value="#SeasonEnd#" readonly 
								onclick="javascript:show_calendar('frmSeason.SeasonEnd');"> &nbsp;
						<a href="javascript:show_calendar('frmSeason.SeasonEnd');" 
								onmouseover="window.status='Date Picker';return true;" 
								onmouseout="window.status='';return true;"> 
							<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
						</a><br><small>Date Format: mm/dd/yyyy</small></td>
					</td>
				</tr>
				<tr><td >&nbsp;		</td>
					<th align="right">Season Type:</th>
					<td  valign="center" colspan="2">  
						<select name="SeasonSF">
							<option value="SPRING" <cfif SeasonSF EQ "SPRING"> selected </cfif> >Spring</option>
							<option value="FALL"   <cfif SeasonSF EQ "FALL">   selected </cfif> >Fall  </option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<input type="hidden" name="SeasonId" value="#URL.Season_id#">
						<input type="submit" name="EditSeason" value="Update Season">
					</td>
				</tr>
			</table>
			</form>
		</TD>
	</tr>
</table>	
<cfinclude template="SeasonList.cfm">

</cfoutput>
</div>
<cfinclude template="_footer.cfm">

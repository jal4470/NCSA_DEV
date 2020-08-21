<!--- 
	FileName:	seasonMaintenance.cfm
	Created on: 09/08/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

8/14/2017 - apinzone - NCSA27024 
-- Added save content to move css to header.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<cfinclude template="_checkLogin.cfm">

<script language="JavaScript" src="DatePicker.js"></script>

<CFSET errMSG = "">


<!--- jquery for dates --->
<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<cfsavecontent variable="cf_footer_scripts">
	<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
	<script language="JavaScript" type="text/javascript">
		$(function(){
			$('.date').datepicker();
		});
	</script>
</cfsavecontent>



<cfoutput>
<div id="contentText">

<CFIF isDefined("Form.SeasonStart") and isDefined("Form.SeasonEnd") and len(trim(Form.SeasonStart)) and len(trim(Form.SeasonEnd))>
	<CFSET SeasonYear = datePart("yyyy",Form.SeasonStart)>
	<CFSET SeasonSF	  = Form.SeasonSF>
	<CFIF SeasonSF EQ "SPRING">
		<CFSET seasonCode = "SPRING" & Mid(SeasonYear,3,2)>
	<CFELSE>
		<CFSET seasonCode = "FALL" & Mid(SeasonYear,3,2)>
	</CFIF>

	<CFSET currentSeason_YN 	= "N">
	<CFSET registrationOpen_YN  = "N">
	<CFSET tempRegOpen_YN 		= "N">
	<CFSET season_startDate 	= Form.SeasonStart>
	<CFSET season_endDate 		= Form.SeasonEnd>

	<CFSET createdBy = Session.USER.ContactID>

	<CFQUERY name="qGetSeason" datasource="#SESSION.DSN#">
		Select Count(*) as SeasonCount from tbl_season Where seasonCode = '#seasonCode#'
	</CFQUERY>

	<CFIF qGetSeason.SeasonCount>
		<CFSET errMsg = errMSG & " The Season " & seasonCode & " Already Exists!">
	<CFELSE>
		<cfstoredproc procedure="p_insert_season" datasource="#SESSION.DSN#">
			<cfprocparam type="In"  dbvarname="@season_year" 		cfsqltype="CF_SQL_NUMERIC"  value="#SeasonYear#">
			<cfprocparam type="In"  dbvarname="@season_SF"  		cfsqltype="CF_SQL_VARCHAR"  value="#SeasonSF#">
			<cfprocparam type="In"  dbvarname="@seasonCode" 		cfsqltype="CF_SQL_VARCHAR"  value="#seasonCode#">
			<cfprocparam type="In"  dbvarname="@currentSeason_YN" 	cfsqltype="CF_SQL_VARCHAR"  value="#currentSeason_YN#">
			<cfprocparam type="In"  dbvarname="@registrationOpen_YN" cfsqltype="CF_SQL_VARCHAR" value="#registrationOpen_YN#">
			<cfprocparam type="In"  dbvarname="@tempRegOpen_YN" 	cfsqltype="CF_SQL_VARCHAR"  value="#tempRegOpen_YN#">
			<cfprocparam type="In"  dbvarname="@season_startDate" 	cfsqltype="CF_SQL_DATE"     value="#season_startDate#">
			<cfprocparam type="In"  dbvarname="@season_endDate" 	cfsqltype="CF_SQL_DATE"     value="#season_endDate#">
			<cfprocparam type="In"  dbvarname="@createdBy" 			cfsqltype="CF_SQL_NUMERIC"  value="#createdBy#">
			<cfprocparam type="Out" dbvarname="@season_id" 			cfsqltype="CF_SQL_NUMERIC"  variable="newSeasonID">
		</cfstoredproc>
		
		<CFIF isDefined("newSeasonID") AND newSeasonID>
			<CFSET errMsg = errMSG & " " & seasonCode & " was Created Successfully.">
		<CFELSE>
			<CFSET errMsg = errMSG & "There was an error processing your request.">
		</CFIF>
	
	</CFIF>
<CFELSE>
	<CFSET errMsg = errMSG & "Please provide a Start and End date for a season.">
</CFIF>

<H1 class="pageheading">NCSA - Create A Season</H1>
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
		<TD> &nbsp;
		</TD>
	</tr>

	<tr><TD class="tdUnderLine" nowrap> 
			<form name="frmSeason" method="post" action="seasonMaintenance.cfm">
			<table align="center" width="600" border="0">
				<tr><th>Season Start Date:</th> 
					<td><input size="9" name="SeasonStart" class="date">
							<br><small>Date Format: mm/dd/yyyy</small></td>
			
					<th>Season End Date:</th> 
					<td><input size="9" name="SeasonEnd" class="date">
							<br><small>Date Format: mm/dd/yyyy</small></td>
					</td>
				</tr>
				<tr >
					<td >&nbsp;
					</td>
					<th align="right">Season Type:</th>
					<td  valign="center" colspan="2">  
						<select name="SeasonSF">
							<option value="SPRING">Spring</option>
							<option value="FALL">Fall</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="2"><input type="submit" name="CreateSeason" value="Create Season"></td>
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

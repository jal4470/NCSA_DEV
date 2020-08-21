<!--- 
	FileName:	siteSetting.cfm
	Created on: 12/31/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: set values in global params table. which params get set is based on
			the url param passed (not its value, 1 means it was not tampered with) 
	
MODS: mm/dd/yyyy - filastname - comments
02/02/09 - AA - Added toggle for game change request
02/25/09 - AA - changed text for: EDITGAMEAUTHCLUB
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<!--- Was a SAVE button pressed? --->
<CFIF isDefined("FORM.SAVE_TBS") 
   or isDefined("FORM.SAVE_FLA") 
   or isDefined("FORM.SAVE_SCH") 
   or isDefined("FORM.SAVE_EGC") 
   or isDefined("FORM.SAVE_RVD") 
   or isDefined("FORM.SAVE_SRC") 
   or isDefined("FORM.SAVE_SRT")
   or isDefined("FORM.SAVE_STF") 
   or isDefined("FORM.SAVE_GCR") >
	<!--- <cfdump var="#FORM#"> --->

	<!--- Which one was pressed? What GLOBAL VAR are we looking for? --->
	<CFIF isDefined("FORM.SAVE_TBS")>  
		<cfset FindVar = "TBSOPEN">
	</CFIF>
	<CFIF isDefined("FORM.SAVE_FLA")>  
		<cfset FindVar = "APPEALOPEN">
	</CFIF>
	<CFIF isDefined("FORM.SAVE_SCH")>  
		<cfset FindVar = "ALLOWSCHEDDISPLAY">
	</CFIF>
	<CFIF isDefined("FORM.SAVE_EGC")>  
		<cfset FindVar = "EDITGAMEAUTHCLUB">
	</CFIF>
	<CFIF isDefined("FORM.SAVE_RVD")>  
		<cfset FindVar = "REFASSIGNVIEWDATEYN">
		<cfset NewRefPubAssDate  = FORM.refPubAssDate>
	</CFIF>
	<CFIF isDefined("FORM.SAVE_SRC")>  
		<cfset FindVar = "SHOWREGISTERCLUB">
	</CFIF>
	<CFIF isDefined("FORM.SAVE_SRT")>  
		<cfset FindVar = "SHOWREGISTERTEAM">
	</CFIF>	
	<CFIF isDefined("FORM.SAVE_STF")>  
		<cfset FindVar = "ShowTeamFlightingPublicLink">
	</CFIF>	
	<CFIF isDefined("FORM.SAVE_GCR")>  
		<cfset FindVar = "ShowGameChangeRequest">
	</CFIF>	
	
	<cfloop collection="#FORM#" item="iFrm">
		<!--- look for the value to be saved --->
		<cfif UCASE(listFirst(iFrm,"_")) EQ VARIABLES.FindVar>
			<cfset varNAME  = listFirst(iFrm,"_")>	
			<cfif ucase(listLast(iFrm,"_")) EQ "NEWVALUE">
				<cfset varValue = form[iFrm]>
				<cfbreak>
			</cfif>			
		</cfif>
	</cfloop>

	<cfinvoke component="#SESSION.SITEVARS.cfcPath#globalVars" method="UpdateGlobalVars" >
		<cfinvokeargument name="globalVarName"  value="#VARIABLES.varName#">
		<cfinvokeargument name="globalVarValue" value="#VARIABLES.varValue#">
	</cfinvoke>

	<CFIF isDefined("VARIABLES.NewRefPubAssDate") AND isDate(VARIABLES.NewRefPubAssDate)>
		<!--- update the date --->
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#globalVars" method="UpdateGlobalVars" >
			<cfinvokeargument name="globalVarName"  value="RefAssignViewDate">
			<cfinvokeargument name="globalVarValue" value="#VARIABLES.NewRefPubAssDate#">
		</cfinvoke>
	</CFIF>
	
	<!--- reset session vars for globalvars --->
	<CFINVOKE component="Application" method="onSessionStart">
	</CFINVOKE> 

</CFIF>

<cfif isdefined("form.SAVEREFAVAILCAL")>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#globalVars" method="UpdateGlobalVars" >
		<cfinvokeargument name="globalVarName"  value="RefAvailCalendarSD">
		<cfinvokeargument name="globalVarValue" value="#form.ref_avail_sd#">
	</cfinvoke>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#globalVars" method="UpdateGlobalVars" >
		<cfinvokeargument name="globalVarName"  value="RefAvailCalendarED">
		<cfinvokeargument name="globalVarValue" value="#form.ref_avail_ed#">
	</cfinvoke>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#globalVars" method="UpdateGlobalVars" >
		<cfinvokeargument name="globalVarName"  value="RefAvailCalendarEnabled">
		<cfinvokeargument name="globalVarValue" value="#form.ref_avail_enabled#">
	</cfinvoke>
</cfif>



<!--- Which Setting do we set ????
<cfswitch expression="#ucase(VARIABLES.siteSetting)#">
	<cfcase value="TE">		<cfset pageText = "Set TBS Entry for Clubs">		<cfset displayText = "TBS Entry">		<cfset globalVarName  = "TBSOpen"> 		<cfset swAllow = true>	</cfcase>
	<cfcase value="FA">		<cfset pageText = "Set Flight Appeals for Clubs">		<cfset displayText = "Flight Appeals">		<cfset globalVarName  = "AppealOpen">		<cfset swAllow = true>	</cfcase>
	<cfcase value="SD">		<cfset pageText = "Set Schedule Display for Public">		<cfset displayText = "Schedule Display">		<cfset globalVarName  = "AllowSchedDisplay">		<cfset swAllow = true>	</cfcase>
	<cfcase value="CE">		<cfset pageText = "Set Edit Game Schedule for Authorized Clubs">		<cfset displayText = "Auth Clubs Edit Game Sched">		<cfset globalVarName  = "EditGameAuthClub">		<cfset swAllow = true>	</cfcase>
	<cfcase value="RV">		<cfset pageText = "Referee Assignments Can be Viewed Through Date">		<cfset displayText = "Ref Assign View Date">		<cfset globalVarName  = "RefAssignViewDate">		<cfset swAllow = true>	</cfcase>
	<cfdefaultcase>		<cfset pageText = "No Setting can be set, access this page only thru menu options.">		<cfset displayText = "">	<cfset globalVarName  = "">		<cfset swAllow = false>	</cfdefaultcase>
</cfswitch>  --->




<link rel="stylesheet" href="assets/themes/cupertino/jquery-ui-1.7.2.custom.css">
<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/daterangepicker/js/jquery-ui-1.7.1.custom.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input.date').datepicker();
	});
</script>
<style type="text/css">
	##ui-datepicker-div{
		font-size:11px;
	}
</style>



<H1 class="pageheading">NCSA - Site Settings</H1>
<!--- <h2>yyyyyy </h2> --->
<br>
<br>

<cfinvoke component="#SESSION.sitevars.cfcpath#globalVars" method="getGlobalVars" returnvariable="qGlobalVariables">
</cfinvoke>

<form name="siteset" action="siteSetting.cfm" method="post">
	<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TD> Setting </TD>
			<TD> Current Value </TD>
			<TD> Change Value to </TD>
			<TD> Click to Save </TD>
			<!--- <TD> Variable name </TD> --->
		</tr>
		<cfset ctDisplayedRow = 0>
		<CFLOOP query="qGlobalVariables">
			<CFSET refAssignViewDate = "">
			<cfswitch expression="#ucase(_NAME)#">
				<cfcase value="TBSOPEN">
					<cfset swAllow     = true>
					<cfset displayText = "TBS Entry">
					<cfset pageText    = "When OPEN allows clubs access to TBS entry.">
					<cfset inputType   = "OC"> <!--- open/close --->
					<cfset buttonNAME  = "SAVE_TBS">
					<cfset buttonTXT   = "Save TBS">
				</cfcase>
				<cfcase value="APPEALOPEN">
					<cfset swAllow     = true>
					<cfset displayText = "Flight Appeals">
					<cfset pageText    = "When OPEN allows clubs to make flight appeals.">
					<cfset inputType   = "OC"> <!--- open/close --->
					<cfset buttonNAME  = "SAVE_FLA">
					<cfset buttonTXT   = "Save Appeal">
				</cfcase>
				<cfcase value="ALLOWSCHEDDISPLAY">
					<cfset swAllow     = true>
					<cfset displayText = "Schedule Display">
					<cfset pageText    = "When Y, allows schedule to be displayed to public.">
					<cfset inputType   = "YN"> <!--- yes/no --->
					<cfset buttonNAME  = "SAVE_SCH">
					<cfset buttonTXT   = "Save Schedule">
				</cfcase>
				<cfcase value="EDITGAMEAUTHCLUB">
					<cfset swAllow     = true>
					<!--- 
					<cfset displayText = "Auth Clubs Edit Game Sched">
					<cfset pageText    = "When Y, allows Authorized Clubs to edit game schedule.">
					 --->
					<cfset displayText = "Pre-season scheduling of Game Time/Field">
					<cfset pageText    = "When Y, makes menu item above active for all clubs (only authorized clubs can edit, all can view).">
					<cfset inputType   = "YN"> <!--- yes/no --->
					<cfset buttonNAME  = "SAVE_EGC">
					<!--- <cfset buttonTXT   = "Save Edit Game"> --->
					<cfset buttonTXT   = "Save Pre-Seas Game Sched">
				</cfcase>
				<cfcase value="REFASSIGNVIEWDATEYN">
					<!--- get the value for REFASSIGNVIEWDATE --->
					<CFQUERY name="qGetViewDate" datasource="#SESSION.DSN#">
						SELECT _VALUE 
						  FROM tbl_global_vars
						 WHERE _NAME = 'RefAssignViewDate'
					</CFQUERY>
					<CFIF isDate(qGetViewDate._VALUE)>
						<CFSET refAssignViewDate = dateFormat(qGetViewDate._VALUE,"mm/dd/yyyy")>
					<CFELSE>
						<CFSET refAssignViewDate = "No Date specified.">
					</CFIF>
					<cfset swAllow     = true>
					<cfset displayText = "Ref Assign View Date " & repeatString('&nbsp;',10) & "<br>Refs can view to: " & refAssignViewDate>
					<cfset pageText    = "When Y, Allows referees to view assignments through a specified date">
					<cfset inputType   = "Y"> <!--- yes/no --->
					<cfset buttonNAME  = "SAVE_RVD">
					<cfset buttonTXT   = "Save Ref Assign">
				</cfcase>
				<cfcase value="SHOWREGISTERCLUB">
					<cfset swAllow     = true>
					<cfset displayText = "Show Register Club">
					<cfset pageText    = "When Y, ""Register Club"" menu option under ""SEASONAL REGISTRATION"" is available to clubs. ">
					<cfset inputType   = "YN"> <!--- yes/no --->
					<cfset buttonNAME  = "SAVE_SRC">
					<cfset buttonTXT   = "Save Reg Club">
				</cfcase>
				<cfcase value="SHOWREGISTERTEAM">
					<cfset swAllow     = true>
					<cfset displayText = "Show Register Team">
					<cfset pageText    = "When Y, ""Register Team"" menu option under ""SEASONAL REGISTRATION"" is available to clubs. ">
					<cfset inputType   = "YN"> <!--- yes/no --->
					<cfset buttonNAME  = "SAVE_SRT">
					<cfset buttonTXT   = "Save Reg Team">
				</cfcase>
				<cfcase value="SHOWTEAMFLIGHTINGPUBLICLINK">
					<cfset swAllow     = true>
					<cfset displayText = "Show Team Flighting Public Link">
					<cfset pageText    = "When Y, ""Season Year Team Flighting"" link will appear on the left menu under the ""Parents"" link. ">
					<cfset inputType   = "YN"> <!--- yes/no --->
					<cfset buttonNAME  = "SAVE_STF">
					<cfset buttonTXT   = "Save Flight Link">
				</cfcase>
				<cfcase value="SHOWGAMECHANGEREQUEST">
					<cfset swAllow     = true>
					<cfset displayText = "Show Clubs Submit Game Change Request link">
					<cfset pageText    = "When Y, ""Submit Game Change Request"" link will appear on the left menu under the ""GAMES MANAGEMENT"" link. ">
					<cfset inputType   = "YN"> <!--- yes/no --->
					<cfset buttonNAME  = "SAVE_GCR">
					<cfset buttonTXT   = "Save Game Change Req Link">
				</cfcase>
				<cfdefaultcase>
					<cfset swAllow 	   = false>
					<cfset pageText    = "No Setting can be set, access this page only thru menu options.">
					<cfset displayText = "">
					<cfset inputType   = ""> 
					<cfset buttonNAME  = "">
					<cfset buttonTXT   = "">
				</cfdefaultcase>
			</cfswitch>		
			
			<CFIF swAllow>
				<cfset ctDisplayedRow = ctDisplayedRow + 1>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctDisplayedRow)#"> <!--- currentRow or counter --->
					<TD class="tdUnderLine">
						<b>#displayText#</b>
						<br>#pageText#
					</TD>
					<TD class="tdUnderLine">
						<b>#_VALUE#</b>
						<input type="Hidden" name="#_name#_origValue" value="#_VALUE#" > 
					</TD>
					<TD class="tdUnderLine" nowrap>
						<CFIF inputType EQ "OC">
							<cfset swButton = true>
							<select name="#_name#_newValue" >
								<option value="OPEN"  <cfif _VALUE EQ "OPEN">selected</cfif> >OPEN</option>
								<option value="CLOSE" <cfif _VALUE EQ "CLOSE">selected</cfif> >CLOSE</option>
							</select>
						<CFELSEIF inputType EQ "YN">
							<cfset swButton = true>
							<select name="#_name#_newValue" >
								<option value="Y" <cfif _VALUE EQ "Y">selected</cfif> >Yes</option>
								<option value="N" <cfif _VALUE EQ "N">selected</cfif> >No</option>
							</select>
						<CFELSEIF inputType EQ "Y">
							<cfset swButton = true>
							<select name="#_name#_newValue" >
								<option value="Y" <cfif _VALUE EQ "Y">selected</cfif> >Yes</option>
							</select>
						<CFELSE>
							<cfset swButton = false>
							&nbsp;
						</CFIF>
					
						<CFIF len(trim(VARIABLES.refAssignViewDate))>
							<CFIF isDate(VARIABLES.refAssignViewDate)>
								<cfset displayViewDate = dateFormat(VARIABLES.refAssignViewDate, "mm/dd/yyyy")>
							<CFELSE>
								<cfset displayViewDate = dateFormat(now(), "mm/dd/yyyy")>
							</CFIF>
							<cfset dpMM = datePart("m",VARIABLES.displayViewDate)-1>
							<cfset dpYYYY = datePart("yyyy",VARIABLES.displayViewDate)>
							<br><INPUT name="refPubAssDate" value="#VARIABLES.displayViewDate#" size="9" class="date"> 
								<input type="Hidden" name="setPubDate"  value=""><!--- 
							&nbsp;
							<a href="javascript:show_calendar('siteset.refPubAssDate','siteset.setPubDate','#dpMM#','#dpYYYY#');" 
								onmouseover="window.status='Date Picker';return true;" 
								onmouseout="window.status='';return true;"> 
								<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
							</a> --->
						</CFIF>
						&nbsp;&nbsp;&nbsp;
					
					</TD>
					<TD class="tdUnderLine">
						<cfif swButton>
							<input type="Submit" name="#buttonNAME#" value="#buttonTXT#" style="width:190px" >
						</cfif>
					</TD>
					<!--- <TD class="tdUnderLine">
						#_NAME# 
					</TD> --->
				</tr>
			</CFIF>
		</CFLOOP>
		<tr>
			<!--- ref avail calendar dates --->
			<cfquery datasource="#application.dsn#" name="getRefAvailInfo">
				select
					dbo.f_get_global_var(19) as ref_avail_sd,
					dbo.f_get_global_var(20) as ref_avail_ed,
					dbo.f_get_global_var(21) as ref_avail_enabled
			</cfquery>
			<TD class="tdUnderLine">
				<b>Referee Availability Calendar Dates</b>
				<br>Enable/disable referee availability calendar and select dates.
			</TD>
			<TD class="tdUnderLine">
				<b>#yesnoformat(getRefAvailInfo.ref_avail_enabled)#</b>
			</TD>
			<TD class="tdUnderLine" nowrap>
				<select name="ref_avail_enabled" >
					<option value="1" <cfif getRefAvailInfo.ref_avail_enabled EQ "1">selected="selected"</cfif> >Yes</option>
					<option value="0" <cfif getRefAvailInfo.ref_avail_enabled EQ "0">selected="selected"</cfif> >No</option>
				</select>
				<INPUT name="ref_avail_sd" value="#getRefAvailInfo.ref_avail_sd#" size="9" class="date">
				To
				<INPUT name="ref_avail_ed" value="#getRefAvailInfo.ref_avail_ed#" size="9" class="date">
			
				
				&nbsp;&nbsp;&nbsp;
			
			</TD>
			<TD class="tdUnderLine">
				<cfif swButton>
					<input type="Submit" name="SAVEREFAVAILCAL" value="Save Ref Availability Calendar" style="width:190px" >
				</cfif>
			</TD>
			<!--- <TD class="tdUnderLine">
				#_NAME# 
			</TD> --->
		</tr>
	</table>	
	<!--- <input type="Submit" name="Save" value="Save"> --->
</form> 


<!--- <br>
<br>
<cfquery name="qGlobVar" datasource="#SESSION.DSN#">
	SELECT * FROM TBL_GLOBAL_VARS
</cfquery> 
<cfdump var="#qGlobVar#">
 --->

<!--- 	<cfdump var="#qGlobalVariables#">	 --->


</cfoutput>
</div>
<cfinclude template="_footer.cfm">

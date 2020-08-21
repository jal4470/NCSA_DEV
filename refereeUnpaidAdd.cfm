<!--- 
	FileName:	refereeUnpaidAdd.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
03/09/09 - aarnone - changed to insert all unpaid refs, match report no longer updates xref_game_official
05/01/09 - aarnone - added check for numeric on amount. (25$ tested greater than 0)
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Referee Unpaid</H1>
 <!--- <br><h2>yyyyyy </h2> --->

<cfset swError = false>

<cfif isDefined("URL.msg")>
	<cfset errMsg  = URL.msg >
<cfelse>
	<cfset errMsg  = "" >
</cfif>

<CFIF isDefined("FORM.ADDUNPAID")>
	<cfif FORM.unPaidRefID LTE 0>
		<cfset swError = true>
		<cfset errMsg  = errMsg & "Pleas select the unpaid referee.<br> ">
	</cfif>
	<!--- <cfif FORM.RefAmountOwed LTE 0>
		<cfset swError = true>
		<cfset errMsg  = errMsg & "Amount owed is required.<br> ">
	</cfif> --->
	<cfif len(trim(FORM.RefAmountOwed)) EQ 0>
		<cfset swError = true>
		<cfset errMsg  = errMsg & "Amount owed is required.<br> ">
	<cfelseif NOT isNumeric(Trim(FORM.RefAmountOwed))>
		<cfset swError = true>
		<cfset errMsg  = errMsg & "Amount owed must be a number.<br> ">
	<cfelseif isNumeric(Trim(FORM.RefAmountOwed)) AND Trim(FORM.RefAmountOwed) LTE 0>
		<cfset swError = true>
		<cfset errMsg  = errMsg & "Amount owed must be a number greater than 0.<br> ">
	</cfif>

	
	<cfif len(trim(FORM.Comments)) LT 1>
		<cfset swError = true>
		<cfset errMsg  = errMsg & "Please enter the reason for being unpaid in the comment field below.<br> ">
	</cfif>
	<CFIF isDefined("FORM.RefPosition") and FORM.RefPosition LT 1>
		<cfset swError = true>
		<cfset errMsg  = errMsg & "Please select referee position from the drop down list below.<br>">
	</CFIF>

	<CFIF NOT swError>
		<CFIF isDefined("FORM.unPaidRefID") AND len(trim(FORM.unPaidRefID)) >
			<!--- <cfif FORM.unPaidRefID EQ FORM.refID>
					<!--- the selected REF is the Head ref --->
					<cfquery name="UpdGameOff" datasource="#SESSION.DSN#">
						Update XREF_GAME_OFFICIAL
						   set RefPaid_YN 	= 'N'
							 , RefPaid_AMT 	= 0
							 , RefAmountOwed  = <cfqueryParam cfsqltype="CF_SQL_INTEGER" value="#FORM.refAmountOwed#">
							 , RefPaidComment = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#Trim(FORM.Comments)#">
						 where Game_ID 		= <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.GameID#">
						   AND contact_id   = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.unPaidRefID#">
						   AND game_official_type_id = 1
					</cfquery> 
			<cfelseif FORM.unPaidRefID EQ FORM.ar1id>
					<!--- the selected REF is AR1 --->
					<cfquery name="UpdGameOff" datasource="#SESSION.DSN#">
						Update XREF_GAME_OFFICIAL
						   set RefPaid_YN 	= 'N'
							 , RefPaid_AMT 	= 0
							 , RefAmountOwed  = <cfqueryParam cfsqltype="CF_SQL_INTEGER" value="#FORM.refAmountOwed#">
							 , RefPaidComment = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#Trim(FORM.Comments)#">
						 where Game_ID 		= <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.GameID#">
						   AND contact_id   = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.unPaidRefID#">
						   AND game_official_type_id = 2
					</cfquery> 
			<cfelseif FORM.unPaidRefID EQ FORM.ar2id>
					<!--- the selected REF is AR2 --->
					<cfquery name="UpdGameOff" datasource="#SESSION.DSN#">
						Update XREF_GAME_OFFICIAL
						   set RefPaid_YN 	= 'N'
							 , RefPaid_AMT 	= 0
							 , RefAmountOwed  = <cfqueryParam cfsqltype="CF_SQL_INTEGER" value="#FORM.refAmountOwed#">
							 , RefPaidComment = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#Trim(FORM.Comments)#">
						 where Game_ID 		= <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.GameID#">
						   AND contact_id   = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.unPaidRefID#">
						   AND game_official_type_id = 3
					</cfquery> 
			<cfelse> --->
				<!--- the selected REF is someone not assigned to the game. --->
				
				<!--- 03/09/09 - changed to insert all unpaid refs, match report no longer updates xref_game_official --->
				<cfquery name="qAddUnPaidRef" datasource="#session.dsn#">
					INSERT into RefUnPaid
						( REFID, COMMENTS, RefGameDateUnpaid, RefPosition, RefAmountOwed,
						  STATUS, GAME, GDATE, GTIME, SEASONID,
						  FIELDID, FIELD, FIELDABBR, DIVISION, HOME, VISITOR,
						  ADDBYUSER, DATEADDED, TIMEADDED, 
						  UPDBYUSER, DATEUPDATED, TIMEUPDATED
						)
					VALUES 
						( <cfqueryParam cfsqltype="CF_SQL_INTEGER" value="#FORM.unPaidRefID#">
						, <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#Trim(FORM.Comments)#">
						, <cfqueryParam cfsqltype="CF_SQL_DATE"	   value="#dateFormat(FORM.dateRefed,"mm/dd/yyyy")#">
						, <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#FORM.RefPosition#">
						, <cfqueryParam cfsqltype="CF_SQL_INTEGER" value="#Trim(FORM.refAmountOwed)#">
						, <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="U" >
						, <cfqueryParam cfsqltype="CF_SQL_INTEGER" value="#FORM.gameID#">
						, <cfqueryParam cfsqltype="CF_SQL_DATE"	   value="#dateFormat(FORM.GameDate,"mm/dd/yyyy")#">
						, <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#dateFormat(FORM.GameDate,"mm/dd/yyyy")# #timeFormat(FORM.GameTime,"hh:mm tt")#">
						, <cfqueryParam cfsqltype="CF_SQL_INTEGER" value="#FORM.gameSeasonID#">
						, <cfqueryParam cfsqltype="CF_SQL_INTEGER" value="#FORM.fieldID#">
						, <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#FORM.FieldName#">
						, <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#FORM.FieldAbbr#">
						, <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#FORM.Division#">
						, <cfqueryParam cfsqltype="CF_SQL_INTEGER" value="#FORM.HteamID#">
						, <cfqueryParam cfsqltype="CF_SQL_INTEGER" value="#FORM.VteamID#">
						, <cfqueryParam cfsqltype="CF_SQL_INTEGER" value="#SESSION.USER.CONTACTID#">
						, getDate()
						, getDate()
						, <cfqueryParam cfsqltype="CF_SQL_INTEGER" value="#SESSION.USER.CONTACTID#">
						, getDate()
						, getDate()
						)
				</cfquery>
			<!--- </cfif> --->
			<cflocation url="refereeUnpaidAdd.cfm?msg='Unpaid request was added.'">
			
		</CFIF> <!--- END - IF isDefined("FORM.unPaidRefID") AND len(trim(FORM.unPaidRefID)) --->
	</CFIF>	<!--- END - if NOT swError --->
</CFIF>	<!--- END - IF isDefined("FORM.ADDUNPAID") --->


<CFIF isDefined("FORM.gameID") AND isNumeric(FORM.gameID)>
	<cfset gameID = FORM.gameID>
<CFELSE>
	<cfset gameID = "">
</CFIF>

<cfset gameDate = "">
<cfset gameTime = "">
<cfset gameSeasonID = ""> 
<cfset division = "">
<cfset fieldID = "">
<cfset fieldName = "">
<cfset fieldAbbr = "">
<cfset VteamName = "">
<cfset HteamName = "">
<cfset VteamID = "">
<cfset HteamID = "">
<cfset refID = "">
<cfset ar1id = "">
<cfset ar2id = "">
<cfset RefName = "">
<cfset AR1Name = "">
<cfset AR2Name = "">
<cfset refAcceptYN = "">
<cfset ar1AcceptYN = "">
<cfset ar2AcceptYN = "">
<cfset refPaidYN = "">
<cfset ar1PaidYN = "">
<cfset ar2PaidYN = "">
<cfset refPaidAmt = "">
<cfset ar1PaidAmt = "">
<cfset ar2PaidAmt = "">

<cfif isDefined("FORM.unPaidRefID")>
	<cfset unPaidRefID = FORM.unPaidRefID >
<cfelse>
	<cfset unPaidRefID = "">
</cfif>

<cfif isDefined("FORM.RefAmountOwed")>
	<cfset RefAmountOwed = FORM.RefAmountOwed >
<cfelse>
	<cfset RefAmountOwed = 0>
</cfif>

<cfif isDefined("FORM.Comments")>
	<cfset Comments = FORM.Comments >
<cfelse>
	<cfset Comments = "">
</cfif>

<cfif isDefined("FORM.RefPosition")>
	<cfset RefPosition = FORM.RefPosition >
<cfelse>
	<cfset RefPosition = "">
</cfif>

<cfif isDefined("FORM.dateRefed")>
	<cfset dateRefed = FORM.dateRefed >
<cfelse>
	<cfset dateRefed = dateFormat(now(),"mm/dd/yyyy")>
</cfif>

<CFIF gameID GT 0>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="getGameSchedule" returnvariable="qGameInfo">
		<cfinvokeargument name="gameID"		value="#VARIABLES.gameID#">  
	</cfinvoke>  <!--- <cfdump var="#qGameInfo#"> --->
</CFIF>

<CFIF isDefined("qGameInfo.recordCount") AND qGameInfo.recordCount GT 0>
	<cfset gameDate = dateFormat(qGameInfo.game_date,"mm/dd/yyyy")>
	<cfset gameTime = timeFormat(qGameInfo.game_time,"hh:mm tt")>
	<cfset division = qGameInfo.Division> 
	<cfset gameSeasonID = qGameInfo.SEASON_ID> 
	<cfset fieldID  = qGameInfo.field_ID> 
	<cfset fieldName = qGameInfo.fieldName> 
	<cfset fieldAbbr = qGameInfo.fieldAbbr> 
	<cfset VteamName = qGameInfo.Visitor_TeamName>
	<cfset VteamID   = qGameInfo.Visitor_Team_ID>
	<cfset HteamName = qGameInfo.Home_TeamName>
	<cfset HteamID   = qGameInfo.Home_Team_ID>

	<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="GetGameOfficial" returnvariable="qGameOfficials">
		<cfinvokeargument name="gameID"		value="#VARIABLES.gameID#">
	</cfinvoke> <!---  <cfdump var="#qGameOfficials#"> --->
 	
	<cfif qGameOfficials.RECORDCOUNT>
		<cfloop query="qGameOfficials">
			<cfswitch expression="#GAME_OFFICIAL_TYPE_ID#">
				<cfcase value="1"><!--- headref --->
					<cfset refID = CONTACT_ID >
					<cfset RefName = LASTNAME & ", " & FIRSTNAME >
					<!--- <cfset refAcceptYN = REF_ACCEPT_YN >    
					<cfset refPaidYN = REFPAID_YN >
					<cfset refPaidAmt = RefPaid_AMT > --->
				</cfcase>
				<cfcase value="2"><!--- Asst ref 1 --->
					<cfset ar1ID = CONTACT_ID >
					<cfset ar1Name = LASTNAME & ", " & FIRSTNAME >
					<!--- <cfset ar1AcceptYN = REF_ACCEPT_YN >
					<cfset ar1PaidYN = REFPAID_YN>
					<cfset ar1PaidAmt = RefPaid_AMT > --->
				</cfcase>
				<cfcase value="3"><!--- AssT ref 2 --->
					<cfset ar2ID = CONTACT_ID >
					<cfset ar2Name = LASTNAME & ", " & FIRSTNAME >
					<!--- <cfset ar2AcceptYN = REF_ACCEPT_YN >
					<cfset ar2PaidYN = REFPAID_YN >
					<cfset ar2PaidAmt = RefPaid_AMT > --->
				</cfcase>
			</cfswitch>
		
		</cfloop>
	</cfif>
<cfelseif isDefined("qGameInfo.recordCount") AND qGameInfo.recordCount EQ 0>
	<cfset errMsg = errMsg & "No game found for the Game number entered." >
</CFIF>

<FORM name="unpaidref" action="refereeUnpaidAdd.cfm" method="post">
<!--- <input type="Hidden" name="gameID" value="#VARIABLES.gameID#"> --->
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD colspan="5"> &nbsp;	</TD>
	</tr>
	<tr><TD colspan="5"> 
			<b>Enter Game Number:	</b>
			<input type="Text" name="gameID" value="#gameID#">
			<input type="Submit" name="GetGame" value="Get Game Info">
		</TD>
	</tr>
	<tr><TD colspan="5">
			<hr size="1">
		</TD>
	</tr>

	<cfif len(trim(errMsg))>
		<tr><TD colspan="5">
				<span class="red"><b>#errMsg#</b></span>
			</TD>
		</tr>
	</cfif>

	<cfif isDefined("qGameInfo") and qGameInfo.recordCount>
		<tr class="tblHeading">
			<td width="10%">Game</td>
			<td width="10%">Div</td>
			<td width="20%">Date/Time</td>
			<td width="40%">Teams</td>
			<td width="20%">Field</td>
		</tr>
		<tr><td>#gameID#</td>
			<td>#division#</td>
			<td>#gameDate# @ #gameTime#</td>
			<td>(H) #HteamName#
				<br>
				(V) #VteamName#
			</td>
			<td>#fieldAbbr#</td>
		</tr>
		
		<tr><td colspan="5">
				<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%">
					<tr class="tblHeading">
						<TD>Referee Name</TD>
						<TD>Position</TD>
						<TD>Accept/Declined</TD>
						<!--- <TD>Paid Y/N</TD>
						<TD>Amount</TD> --->
					</TR>
					<TR bgcolor="###setRowColor(SESSION.sitevars.altColors,0)#">
						<TD class="tdUnderLine">#RefName# &nbsp; </TD>
						<TD class="tdUnderLine">Referee	</TD>
						<TD class="tdUnderLine"><cfif refAcceptYN EQ "Y">
								<span class="green">Accepted</span>
							<cfelseif refAcceptYN EQ "N">
								<span class="red">Declined</span>
							<cfelse>
								no response
							</cfif>
						</TD>
						<!--- <TD class="tdUnderLine">#refPaidYN# &nbsp; </TD>
						<TD class="tdUnderLine">#refPaidAmt# &nbsp; </TD> --->
					</TR>
					<TR bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#">
						<TD class="tdUnderLine">#AR1Name# &nbsp; </TD>
						<TD class="tdUnderLine">Asst Ref 1 </TD>
						<TD class="tdUnderLine"><cfif ar1AcceptYN EQ "Y">
								<span class="green">Accepted</span>
							<cfelseif ar1AcceptYN EQ "N">
								<span class="red">Declined</span>
							<cfelse>
								no response
							</cfif>
						</TD>
						<!--- <TD class="tdUnderLine">#ar1PaidYN# &nbsp; </TD>
						<TD class="tdUnderLine">#ar1PaidAmt# &nbsp; </TD> --->
					</TR>
					<TR bgcolor="###setRowColor(SESSION.sitevars.altColors,0)#">
						<TD class="tdUnderLine">#AR2Name# &nbsp; </TD>
						<TD class="tdUnderLine">Asst Ref 2 </TD>
						<TD class="tdUnderLine"><cfif ar2AcceptYN EQ "Y">
								<span class="green">Accepted</span>
							<cfelseif ar2AcceptYN EQ "N">
								<span class="red">Declined</span>
							<cfelse>
								no response
							</cfif>
						</TD>
						<!--- <TD class="tdUnderLine">#ar2PaidYN# &nbsp; </TD>
						<TD class="tdUnderLine">#ar2PaidAmt# &nbsp; </TD> --->
					</TR>
				</table>
			</td>
		</tr>

		<input type="Hidden" name="gameDate" value="#VARIABLES.gameDate#">
		<input type="Hidden" name="gameTime" value="#VARIABLES.gameTime#">
		<input type="Hidden" name="gameSeasonID"  value="#VARIABLES.gameSeasonID#">
		<input type="Hidden" name="division" value="#VARIABLES.division#">
		<input type="Hidden" name="fieldID" value="#VARIABLES.fieldID#">
		<input type="Hidden" name="fieldAbbr" value="#VARIABLES.fieldAbbr#">
		<input type="Hidden" name="fieldName" value="#VARIABLES.fieldName#">
		<input type="Hidden" name="VteamName" value="#VARIABLES.VteamName#">
		<input type="Hidden" name="HteamName" value="#VARIABLES.HteamName#">
		<input type="Hidden" name="VteamID"   value="#VARIABLES.VteamID#">
		<input type="Hidden" name="HteamID"   value="#VARIABLES.HteamID#">
		<input type="Hidden" name="refID" value="#VARIABLES.refID#">
		<input type="Hidden" name="ar1id" value="#VARIABLES.ar1id#">
		<input type="Hidden" name="ar2id" value="#VARIABLES.ar2id#">
		<input type="Hidden" name="RefName" value="#VARIABLES.RefName#">
		<input type="Hidden" name="AR1Name" value="#VARIABLES.AR1Name#">
		<input type="Hidden" name="AR2Name" value="#VARIABLES.AR2Name#">
		


		<tr><td colspan="5"><hr size="1"> </td>
		</tr>
		<tr ><td  class="tdUnderLine" colspan="5" valign="top">
				<table width="100%" align="center" border="0" >
					<tr><td valign="top">
							<b>Game date to be Paid for:</b>
							<br>
							<input size="9" name="dateRefed" value="#VARIABLES.dateRefed#" readonly >
							<input size="3" name="DOW"  value="#DateFormat(VARIABLES.dateRefed,"ddd")#" disabled>
							&nbsp;  <cfset dpMM = datePart("m",VARIABLES.dateRefed)-1>
									<cfset dpYYYY = datePart("yyyy",VARIABLES.dateRefed)>
								<a href="javascript:show_calendar('unpaidref.dateRefed','unpaidref.DOW','#dpMM#','#dpYYYY#' );" 
										onmouseover="window.status='Date Picker';return true;" 
										onmouseout="window.status='';return true;"> 
									<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
								</a>
							<br><br>

							<CFIF SESSION.MENUROLEID EQ 25> <!--- 25=ref menu --->
								<input type="Hidden" name="unPaidRefID" value="#SESSION.USER.CONTACTID#">
							<cfelse>
								<!--- get referees --->
								<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo">
								</cfinvoke>
								<B>Select the unpaid Referee:</B>
								<br> <SELECT name="unPaidRefID" ID="RefID"> 
										<OPTION value="" ><b>Select the Unpaid Referee</b></OPTION>
										<cfloop query="qRefInfo"><!--- <cfif refId EQ CONTACT_ID>selected</cfif> --->
											<OPTION value="#CONTACT_ID#" <cfif CONTACT_ID EQ VARIABLES.unPaidRefID>selected</cfif> >#LASTNAME#, #FIRSTNAME#</OPTION>
										</cfloop>
									</SELECT>
								<br><br>
							</CFIF>

							<B>Referee Position:</B>
							<cfquery name="qRefPositions" datasource="#SESSION.DSN#">
								SELECT GAME_OFFICIAL_TYPE_ID, GAME_OFFICIAL_TYPE_NAME
								  FROM TLKP_GAME_OFFICIAL_TYPE
								 ORDER BY GAME_OFFICIAL_TYPE_ID
							</cfquery>
							<br> <SELECT name="RefPosition" ID="RefPos"> 
									<OPTION value="0" ><b>Select Position</b></OPTION>
									<cfloop query="qRefPositions">
										<OPTION value="#GAME_OFFICIAL_TYPE_ID#" <cfif GAME_OFFICIAL_TYPE_ID EQ VARIABLES.RefPosition>selected</cfif> >#GAME_OFFICIAL_TYPE_NAME#</OPTION>
									</cfloop>
								</SELECT>
							<br><br>
					
							<b>Amount Owed:</b>
							<br><input type="Text" name="refAmountOwed" value="#VARIABLES.refAmountOwed#">
						</td>
						<td valign="top">
							<b>Comments:</b>
							<br><TEXTAREA name="Comments"  rows=4 cols=60>#VARIABLES.Comments#</TEXTAREA>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr><TD colspan="5" align="center">
				<input type="Submit" name="AddUnPaid" value="Add Unpaid Ref">
			</TD>
		</tr>
	</cfif>
</table>	
</FORM>


	
	
</cfoutput>
</div>
<cfinclude template="_footer.cfm">

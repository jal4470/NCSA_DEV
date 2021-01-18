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


 <!--- <br><h2>yyyyyy </h2> --->

<cfset swError = false>

<cfif isDefined("URL.msg")>
	<cfset errMsg  = URL.msg >
<cfelse>
	<cfset errMsg  = "" >
</cfif>

<cfif isDefined("FORM.club_id")>
	<cfset clubID = FORM.club_id>
<cfelse>
	<cfset clubID = "0">
</cfif>	


<cfif isDefined("FORM.Season")>
	<cfset Season = FORM.Season>
<cfelse>

	<cfset Season = session.currentseason.id>
</cfif>


<cfif (isdefined("form.startDate") and len(trim(form.startDate))) and (isdefined("form.endDate") and len(trim(form.endDate)))>
	<cfset startDate = dateformat(form.startDate,'mm/dd/yyyy')>
	<cfset endDate = dateformat(form.endDate,'mm/dd/yyyy')>
<cfelse>
	<cfset startDate ="#dateformat(session.currentseason.StartDate,'mm/dd/yyyy')#">
	<cfset endDate = "#dateformat(session.currentseason.EndDate,'mm/dd/yyyy')#">
</cfif>




<!--- Get Club name list --->
<cfinvoke component="#SESSION.SITEVARS.cfcPath#registration" method="getRegisteredClubs" returnvariable="qClubs">
		<cfinvokeargument name="orderby" value="clubname">
</cfinvoke>

<!--- Get Team Age --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lTeamAges">
	<cfinvokeargument name="listType" value="TEAMAGES"> 
</cfinvoke>

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lPlayLevel">
	<cfinvokeargument name="listType" value="PLAYLEVEL"> 
</cfinvoke>
<CFINVOKE component="#SESSION.SITEVARS.cfcPath#team" method="getPreviousSeasonDivisions" returnvariable="lDivision"> <!--- Divisions --->

<cfquery name="getSeasons" datasource="#session.dsn#">
	select season_id,seasonCode, season_StartDate, season_EndDate
	from tbl_season
</cfquery>


<!--- <CFIF isDefined("FORM.gameID") AND isNumeric(FORM.gameID)>
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
</cfif> --->

<!--- <CFIF gameID GT 0>
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



	<cfif isDefined("qGameInfo") and qGameInfo.recordCount>
		<cfoutput>
		<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
<!--- 	<tr class="tblHeading">
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
	</cfif> --->
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
						<TD class="tdUnderLine">#ar1PaidYN# &nbsp; </TD>
						<TD class="tdUnderLine">#ar1PaidAmt# &nbsp; </TD>
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
		</cfoutput>
	</cfif>
</table>	


</FORM> --->

<CFIF ISDEFINED("FORM.GO") OR ISDEFINED("URL.GO")>
	<cfquery name="refUnPaidAdded" datasource="#SESSION.DSN#">
		select  r.id as unpaidRefId,
			r.RefPosition,
				r.REFID, co.FirstNAME, co.LastName,
				r.GAME,  r.GDATE,  r.GTIME, r.DIVISION, r.COMMENTS,
				r.FIELD, r.FIELDABBR, 
				dbo.getTeamName(r.HOME)    AS HomeTeamName,
				dbo.getTeamName(r.VISITOR) AS VisitorTeamName,
				r.RefAmountOwed, C.CLUB_NAME,
				r.FIELDID, 	th.Club_ID,
				r.RefGameDateUnpaid,  
				r.HOME, r.VISITOR,  r.SEASONID, r.STATUS, 
				r.DATEADDED, r.ADDBYUSER, r.TIMEADDED, 
				r.DATEUPDATED, r.UPDBYUSER, r.TIMEUPDATED
		  from  RefUnPaid r INNER JOIN TBL_TEAM TH 		ON TH.TEAM_ID = R.Home
							INNER JOIN TBL_CLUB C 		ON C.CLUB_ID = TH.CLUB_ID
							INNER JOIN TBL_CONTACT CO	ON CO.CONTACT_ID = R.REFID
		 where  r.seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Season#">
		 	<CFIF isDefined("clubID") AND clubID GT 1>
				and C.Club_Id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#clubID#">
			</CFIF>
			<!--- 11/1/2012 J. Rab --->
			<cfif (isDefined("StartDate") and isDate(StartDate)) and (isDefined("EndDate") and isDate(EndDate))>
				and cast(r.GTIME as date) between <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#variables.StartDate#"> and  <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#variables.EndDate#">
			</cfif>
			
			
		 ORDER BY C.CLUB_NAME, r.gDate DESC, r.gTime DESC
	</cfquery>  
	<!--- <cfdump var="#refUnPaidAdded#"> --->
</CFIF>

<cfsavecontent variable="custom_css">
  <link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
  <style>
  	 .dateRange{
  	 	width:100px;
  	 }
  	 .tblDateRange{
  	 	width:208px;
  	 	margin-left: 2%;
    	margin-top: -2px;
  	 }
  	 .question{
  	 	float:left;
  	 	margin-left:1%;
  	 	margin-right:1%;
  	 }
  	 .question-submit{
  	 	float: right;
    	margin-right: 10%;
    	margin-top: 2%;
    	width: 15%;
  	 }
  	 .addUnpaid{
  	 	margin-left:5%;
  	 }
  	 .unpaid-ref{
  	 	cursor:pointer;
  	 }
  	 .filterGroup{
  	 	margin-bottom:2%;
  	 	height: 40px;
  	 }
  	 .theMsg{
  	 	margin-left: 40%;
	    border: 1px solid #ddd;
	    height: 30px;
	    margin-right: 36%;
	    padding: 1%;
	    margin-bottom: 1%;
	    color: white;
	    background: #0ab126;
	    border-radius: 9px;
	    margin-top: 3%;
	    min-width:38%;
  	 }
  	 .searchGame{
  	 	    width: 39%;
		    padding-left: 1%;
		    padding-right: 1%;
		    padding-top: 1%;
		    height: 70px;
		    float: left;
		    border: 1px solid #ccc;
		    margin-top: 1%;
		    border-radius: 8px;
  	 }
  	 #add-error{
  	 	color:red;
  	 	font-weight: bold;
  	 	padding:1%;
  	 }
  	 #club_id{
  	 	min-width: 182px;
  	 }
  	</style>
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<cfoutput>
<div id="contentText">
<!--- Filters --->
	<H1 class="pageheading">NCSA - Referee Unpaid</H1>
	<div class="filterGroup">
	<FORM name="unpaidref" action="#CGI.SCRIPT_NAME#" method="post">
	<!--- <input type="Hidden" name="gameID" value="#VARIABLES.gameID#"> --->

		<div id="qClubs" class="question">
			<label for="clubs" style="display: block;"><b>Select a Club</b></label>
			<SELECT name="club_id" id="club_id">
				<option value="0">All Clubs</option>
				<cfloop query="qClubs">
					<option value="#CLUB_ID#" <CFIF CLUB_ID EQ ClubID>selected</CFIF> >#CLUB_NAME#</option>
				</cfloop>
			</SELECT>
		</div> 
		<div id="qSeason" class="question">
			<label for="Season" style="display: block;"><b>Select Season </b></label>
			<SELECT name="Season" id="Season">
				<CFLOOP query="#getSeasons#" >
					<OPTION value="#season_id#"  data-start-date="#dateformat(season_StartDate,'mm/dd/yyyy')#" data-end-date="#dateformat(season_EndDate,'mm/dd/yyyy')#"  <cfif Season_id EQ variables.season>selected</cfif> > #seasonCode# </OPTION>
				</CFLOOP>
			</SELECT>
		</div>
		<div  class="question">
			<table cellspacing="0" cellpadding="2" align="center" border="0" class="tblDateRange">
				<tr>
				
				<td>
					<label for="Season" style="display: block;"><b>Start Date</b></label> 
					<div><input type="text" name="StartDate" class="dateRange" value="#startDate#" /></div>
				</td>
				<td>
					<label for="Season" style="display: block;"><b>End Date</b></label>
					<div><input type="text" name="EndDate" class="dateRange" value="#endDate#" /></div>
				</td>
				</tr>
			</table>

		</div>
	
		<div id="qSubmit" class="question-submit">
			<input type="Submit" name="GO" value="GO">
			
			<!--- <input type="Submit" name="printme" value="Printer Friendly">
			<input type="Submit" name="Export" value="Export"> --->
		</div>
		</FORM>


	<FORM ACTION="RefereeUnPaidAddAdmin.cfm" method="post">	
		<div class="searchGame">
			<label for="Season" style="display: block;">
				<b>Game Id</b>
			</label>
			<input type="text" name="game_id" value="" maxlength="9" />
			<input type="Submit" name="AddUnPaid" class="addUnpaid" value="Add Unpaid Ref">
			<div id="add-error"></div>
		</div>
	</FORM>
	</div>
<!--- Results --->
		<cfif len(trim(errMsg))>
			<div class="theMsg">#errMsg#</div>
		</cfif>

		<cfif isdefined("refUnPaidAdded")>
			<div>
				<table class="result table" cacellspacing="0" cellpadding="2" align="center" border="0" width="100%">
					<tr class="tblHeading">
						<TH width="23%">Referee</TH>
						<TH width="06%">Pos</TH>
						<TH width="06%" >Owed</TH>	
						<TH width="06%">Game</TH>
						<TH width="24%"> Date/Time/Field</TH>
						<TH width="05%">Div</TH>
						<TH width="30%">Teams </TH>
					</tr>

				
				
				
					
				
					<CFIF refUnPaidAdded.RECORDCOUNT>
						<!--- <tr class="tblHeading">
							<TD colspan="8" align="left">#repeatString("&nbsp;",5)# Unassigned Referees <!--- ADDED Unpaid Referess ---> </TD>
						</tr> --->
						<cfset holdClubName = "">
						<cfloop query="refUnPaidAdded">
							
							<cfif holdClubName NEQ CLUB_NAME>
								<cfset holdClubName = CLUB_NAME>
								<TR bgcolor="##CCE4F1">
									<TD colspan="8" align="left"><B>#ucase(Club_Name)#</b></TD>
								</tr>
							</cfif>
							<cfif len(trim(Comments))>
								<cfset tdClass = "">
							<cfelse>
								<cfset tdClass = "class='tdUnderLine' ">
							</cfif>
							<cfset position = "">
							<cfswitch expression="#RefPosition#">
								<cfcase value="1"> <cfset position="Ref"> </cfcase>
								<cfcase value="2"> <cfset position="AR1"> </cfcase>
								<cfcase value="3"> <cfset position="AR2"> </cfcase>
							</cfswitch>
							<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#" class="unpaid-ref" data-game-id="#game#" data-amount-due="#refAmountOwed#" data-unpaid-ref-id="#unpaidRefId#" data-position="#position#" title="Edit unpaid id - #unpaidRefId#"> <!--- currentRow or counter --->
								<TD #tdClass# > #LastName#, #FirstNAME# </TD>
								<TD #tdClass# align="center"> 	 
										#position#
								</TD>
								<TD #tdClass# align="center"> #dollarFormat(RefAmountOwed)#		 </TD>
								<TD #tdClass#> #GAME#		 </TD>
								<TD #tdClass#> #dateFormat(RefGameDateUnpaid,"mm/dd/yyyy")# &nbsp; &nbsp; &nbsp; #timeFormat(GTIME,"hh:mm tt")#
											<br>#repeatString("&nbsp;",4)# #FieldAbbr#
								</TD>
								<TD #tdClass#> #Division#		 </TD>
								<TD #tdClass#> 
											 (H) #HomeTeamName#
										<br> (V) #VisitorTeamName#	
								</TD>
							</tr>
							<cfif len(trim(Comments))>
								<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
									<TD colspan="1" class="tdUnderLine">&nbsp;  </TD>
									<TD colspan="6" class="tdUnderLine" align="left"> Comments:  #Comments# </TD>
								</tr>
							</cfif>
						</cfloop>	
					</CFIF>
				</TABLE>
				</div>


		</cfif>
	</div>
	</cfoutput>

<cfsavecontent variable="cf_footer_scripts">
	<cfoutput>
		<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
		<script language="JavaScript" type="text/javascript">
			$(function(){


				$('.theMsg').fadeOut(4000);
				
				$('input[name=StartDate],input[name=EndDate]').datepicker();

				$(".unpaid-ref").click(function(){
					
					let _unpaid_id = $(this).data("unpaid-ref-id");
					let _game_id = $(this).data("game-id");
					let _amount_due = $(this).data("amount-due");
					let _position = $(this).data("position")
					let redirect_to = 'RefereeUnpaidEdit.cfm?unPaidRefID=' + _unpaid_id + '&gameId=' + _game_id + '&amount_due=' + _amount_due + "&position" + _position;
					//console.log(redirect_to);
					window.location.href = redirect_to;
				});

				$('input[name=AddUnPaid]').click(function(event){
					//event.preventDefault();

					//console.log($("input[name=game_id]").val().length);
					if($("input[name=game_id]").val().length == 0)
					{
						$("##add-error").empty().append("Please specify a Game Id");
						return;
					}
				});

				$( "select[name=Season]" ).change(function() {
				  	let _start_date = $(this).find('option:selected').data('start-date');
					let _end_date = $(this).find('option:selected').data('end-date');
				  	$("input[name=StartDate]").val(_start_date);
				  	$("input[name=EndDate]").val(_end_date);
				});

			});
		</script>
	</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">

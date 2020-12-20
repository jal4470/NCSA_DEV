<!--- 
	FileName:	gameReportEdit.cfm
	Created on: 04/23/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: allow the edit of a game report (aka match report aka referee report)
	
	NOTE!!!	Depending on the changes to this file, the following files may also require changes:
				gameRefReportPrint.cfm
				gameReportSubmit.cfm

MODS: mm/dd/yyyy - filastname - comments
7586?
05/20/2009 - aarnone - #7757 changed text
9/8/2014	-	J. Danz	-	15511 - added logic for input of Players Playing Up.
8/3/2017 - A. Pinzone - 22821 - rewrote play-up validation logic
 --->

<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>

<cfsavecontent variable="custom_css">
	<link rel="stylesheet" href="assets/themes/ui-1.8.5/cupertino/jquery-ui-1.8.5.custom.css">
	<style type="text/css">
		.limit_selects select {
			margin-right: 1%;
			width: 99%;
		}
	</style>
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<CFIF isDefined("URL.GID") AND isNumeric(URL.GID)>
	<CFSET gameID = URL.GID>
<CFELSEIF isDefined("FORM.GameID") AND isNumeric(FORM.GameID)>
	<CFSET gameID = FORM.GameID>
<CFELSE>
	<CFSET gameID = 0>
</CFIF>

<CFIF isDefined("URL.wef") AND isDate(URL.wef)><!--- WeekEnd FROM --->
	<CFSET wef = URL.wef>
<CFELSEIF isDefined("FORM.wef") AND isDate(FORM.wef)>
	<CFSET wef = FORM.wef>
<CFELSE>
	<CFSET wef = "">
</CFIF>
<CFIF isDefined("URL.wet") AND isDate(URL.wet)><!--- WeekEnd TO --->
	<CFSET wet = URL.wet>
<CFELSEIF isDefined("FORM.wet") AND isDate(FORM.wet)>
	<CFSET wet = FORM.wet>
<CFELSE>
	<CFSET wet = "">
</CFIF>
<CFIF isDefined("URL.rfid") AND isNumeric(URL.rfid)><!--- Referee ID --->
	<CFSET rfid = URL.rfid>
<CFELSEIF isDefined("FORM.rfid") AND isNumeric(FORM.rfid)>
	<CFSET rfid = FORM.rfid>
<CFELSE>
	<CFSET rfid = 0>
</CFIF>
<CFIF isDefined("URL.fid") AND isNumeric(URL.fid)><!--- Field ID --->
	<CFSET fid = URL.fid>
<CFELSEIF isDefined("FORM.fid") AND isNumeric(FORM.fid)>
	<CFSET fid = FORM.fid>
<CFELSE>
	<CFSET fid = 0>
</CFIF>
<CFIF isDefined("URL.gdv")><!--- game DIV --->
	<CFSET gdv = URL.gdv>
<CFELSEIF isDefined("FORM.gdv")>
	<CFSET gdv = FORM.gdv>
<CFELSE>
	<CFSET gdv = "">
</CFIF>
<CFIF isDefined("URL.sby")><!--- Sort BY --->
	<CFSET sby = URL.sby>
<CFELSEIF isDefined("FORM.sby")>
	<CFSET sby = FORM.sby>
<CFELSE>
	<CFSET sby = "">
</CFIF>

<cfset msg = "">

<!--- initialize MISCONDUCTS AND INJURIES to hold values while processing forms  --->
<cfset stMisconducts = structNew()>
<Cfloop from="1" to="10" index="ix">
	<cfset stMisconducts[ix] = structNew()>
	<cfset stMisconducts[ix].MISCONDUCT = "">
	<cfset stMisconducts[ix].MISCONPASSNO = "">
	<cfset stMisconducts[ix].MISCONPLAYERNAME = "">
	<cfset stMisconducts[ix].MISCONTEAM = "">
</CFLOOP>

<cfset stInjuries = structNew()>
<Cfloop from="1" to="10" index="ix">
	<cfset stInjuries[ix] = structNew()>
	<cfset stInjuries[ix].INJURY = "">
	<cfset stInjuries[ix].INJURYPASSNO = "">
	<cfset stInjuries[ix].INJURYPLAYERNAME = "">
	<cfset stInjuries[ix].INJURYTEAM = "">
</CFLOOP>
<!--- INIT PLAYUPS home and away to hold values for forms. --->
<cfset stPlayUpsHome = structNew("ordered", "numeric")>
<cfset stPlayUpsVisitor = structNew("ordered", "numeric")>
<cfloop from="1" to="18" index="ix">
	<cfset stPlayUpsHome[ix] = structNew()>
	<cfset stPlayUpsHome[ix].PLAYUPFROMHOME = "">
	<cfset stPlayUpsHome[ix].PLAYUPFROMOTHERHOME = "">
	<cfset stPlayUpsHome[ix].PLAYUPPLAYERNAMEHOME = "">
	<cfset stPlayUpsHome[ix].PLAYUPPASSNOHOME = "">
	<cfset stPlayUpsHome[ix].PLAYUPWITHHOME = "">

	<cfset stPlayUpsVisitor[ix] = structNew()>
	<cfset stPlayUpsVisitor[ix].PLAYUPFROMVISITOR = "">
	<cfset stPlayUpsVisitor[ix].PLAYUPFROMOTHERVISITOR = "">
	<cfset stPlayUpsVisitor[ix].PLAYUPPLAYERNAMEVISITOR = "">
	<cfset stPlayUpsVisitor[ix].PLAYUPPASSNOVISITOR = "">
	<cfset stPlayUpsVisitor[ix].PLAYUPWITHVISITOR = "">
</cfloop> 

<div id="contentText"> 
<H1 class="pageheading">NCSA - Edit Referee Match Report</H1>
<!--- <br><h2>for Game #VARIABLES.gameID#</h2>  --->

<CFIF isDefined("FORM") AND structCount(FORM)>

	<!--- validate form fields --->
	<cfset ctErrors = 0>
	<CFIF FORM.GAMESTATUS EQ "P">
		<cfif NOT ( len(trim(FORM.scoreHomeHT)) AND isNumeric(trim(FORM.scoreHomeHT)) )>
				<cfset ctErrors = ctErrors + 1>
				<cfset MSG = MSG & "Home team HALF time score is required and must be a number.<br>">
		</cfif>
		<cfif NOT ( len(trim(FORM.scoreVisitorHT)) AND isNumeric(trim(FORM.scoreVisitorHT)) )>
				<cfset ctErrors = ctErrors + 1>
				<cfset MSG = MSG & "Visiting team HALF time score is required and must be a number.<br>">
		</cfif>
		<cfif NOT ( len(trim(FORM.scoreHomeFT)) AND isNumeric(trim(FORM.scoreHomeFT)) )>
				<cfset ctErrors = ctErrors + 1>
				<cfset MSG = MSG & "Home team FULL time score is required and must be a number.<br>">
		</cfif>
		<cfif NOT ( len(trim(FORM.scoreVisitorFT)) AND isNumeric(trim(FORM.scoreVisitorFT)) )>
				<cfset ctErrors = ctErrors + 1>
				<cfset MSG = MSG & "Visiting team FULL time score is required and must be a number.<br>">
		</cfif>
	</CFIF>
	<cfif FORM.OnTimeHome EQ 0>
			<cfif NOT ( len(trim(FORM.HTHowLate)) AND isNumeric(FORM.HTHowLate) )>
				<cfset ctErrors = ctErrors + 1>
				<cfset MSG = MSG & "If Home team was late, then ""how late"" must be specified.<br>">
			</cfif>
	</cfif>
	<cfif FORM.OnTimeVisitor EQ 0>
			<cfif NOT ( len(trim(FORM.VTHowLate)) AND isNumeric(FORM.VTHowLate) )>
				<cfset ctErrors = ctErrors + 1>
				<cfset MSG = MSG & "If Visiting team was late, then ""how late"" must be specified.<br>">
			</cfif>
	</cfif>
	<!--- 9/8/2014 - jdanz - 15511 - added these error validations as they appear on the gameReportSubmit page. --->
	<cfif not isdefined("form.homeTeamPlayUps")>
		<cfset ctErrors = ctErrors + 1>
		<cfset msg = msg & "You must indicate if the home team had play ups.<br>">
	</cfif>
	<cfif not isdefined("form.visitorTeamPlayUps")>
		<cfset ctErrors = ctErrors + 1>
		<cfset msg = msg & "You must indicate if the visitor team had play ups.<br>">
	</cfif>
	<cfif isdefined("form.homeTeamPlayUps") AND form.homeTeamPlayUps EQ "1" AND form.homeTeamPlayUpCnt EQ "0">
		<cfset ctErrors = ctErrors + 1>
		<cfset msg = msg & "If the home team has play ups, you must select a number greater than zero.<br>">
	</cfif>
	<cfif isdefined("form.visitorTeamPlayUps") AND form.visitorTeamPlayUps EQ "1" AND form.visitorTeamPlayUpCnt EQ "0">
		<cfset ctErrors = ctErrors + 1>
		<cfset msg = msg & "If the visitor team has play ups, you must select a number greater than zero.<br>">
	</cfif>


	<!--- Look for Injuries --->
	<cfloop list="#FORM.FIELDNAMES#" index="ij">
			<cfif UCASE(listFirst(ij,"_")) EQ "INJURY">
				<cfset stInjuries[listLast(ij,"_")].INJURY 			 = evaluate(ij) >
			</cfif>
			<cfif UCASE(listFirst(ij,"_")) EQ "INJURYPASSNO">
				<cfset stInjuries[listLast(ij,"_")].INJURYPASSNO 	 = evaluate(ij) >
			</cfif>
			<cfif UCASE(listFirst(ij,"_")) EQ "INJURYPLAYERNAME">
				<cfset stInjuries[listLast(ij,"_")].INJURYPLAYERNAME = evaluate(ij) >
			</cfif>
			<cfif UCASE(listFirst(ij,"_")) EQ "INJURYTEAM">
				<cfset stInjuries[listLast(ij,"_")].INJURYTEAM		 = evaluate(ij) >
			</cfif>
	</cfloop>
	
	<cfif NOT structIsEmpty(stInjuries)>
			<!--- INJURY data was entered, were all 4 fields entered? --->
			<cfloop collection="#stInjuries#" item="ij">
				<cfset ctValues = 0>
				<cfif stInjuries[ij].INJURY GT 0> <!--- injury id --->
					<cfset ctValues = ctValues + 1> 
				</cfif> 	
				<cfif len(trim(stInjuries[ij].INJURYPASSNO)) GT 0> 
					<cfset ctValues = ctValues + 1> 
				</cfif>		
				<cfif len(trim(stInjuries[ij].INJURYPLAYERNAME)) GT 0> 
					<cfset ctValues = ctValues + 1> 
				</cfif>		
				<cfif stInjuries[ij].INJURYTEAM GT 0> <!--- team id --->
					<cfset ctValues = ctValues + 1> 
				</cfif>		

				<cfif ctValues GT 0 AND ctValues LT 4>
					<cfset ctErrors = ctErrors + 1>
					<cfset MSG = MSG & "Information may be missing from one or more of the INJURY entries.<br>">
					<cfbreak>
				</cfif>		
	
			</cfloop>
	</cfif>
	
	<!--- look for misconduct values that were entered --->
	<cfloop list="#FORM.FIELDNAMES#" index="iM">
			<cfif UCASE(listFirst(im,"_")) EQ "MISCONDUCT">
				<cfset stMisconducts[listLast(im,"_")].MISCONDUCT 		 = evaluate(iM) >
			</cfif>
			<cfif UCASE(listFirst(im,"_")) EQ "MISCONPASSNO">
				<cfset stMisconducts[listLast(im,"_")].MISCONPASSNO 	 = evaluate(iM) >
			</cfif>
			<cfif UCASE(listFirst(im,"_")) EQ "MISCONPLAYERNAME">
				<cfset stMisconducts[listLast(im,"_")].MISCONPLAYERNAME = evaluate(iM) >
			</cfif>
			<cfif UCASE(listFirst(im,"_")) EQ "MISCONTEAM">
				<cfset stMisconducts[listLast(im,"_")].MISCONTEAM		 = evaluate(iM) >
			</cfif>
	</cfloop> 
	
	<cfif NOT structIsEmpty(stMisconducts)>
			<!--- Misconduct data was entered were all 4 fields entered? --->
			<cfloop collection="#stMisconducts#" item="im">
				<cfset ctValues = 0>
				<cfif stMisconducts[im].MISCONDUCT GT 0> <!--- misconduct id --->
					<cfset ctValues = ctValues + 1> 
				</cfif> 
				<cfif len(trim(stMisconducts[im].MISCONPASSNO)) GT 0> 
					<cfset ctValues = ctValues + 1> 
				</cfif>	
				<cfif len(trim(stMisconducts[im].MISCONPLAYERNAME)) GT 0> 
					<cfset ctValues = ctValues + 1> 
				</cfif>	
				<cfif stMisconducts[im].MISCONTEAM GT 0> <!--- team id --->
					<cfset ctValues = ctValues + 1> 
				</cfif> 
				<cfif ctValues GT 0 AND ctValues LT 4>
					<cfset ctErrors = ctErrors + 1>
					<cfset MSG = MSG & "Information may be missing from one or more of the MISCONDUCT entries.<br>">
					<cfbreak>
				</cfif>		
			</cfloop>
	</cfif>
	
	<!--- look for HomePlayUp values that were entered --->
	<cfloop list="#FORM.FIELDNAMES#" index="iHPU">
		<cfif UCASE(listFirst(ihpu,"_")) EQ "PLAYUPFROMHOME">
			<cfset stPlayUpsHome[listLast(ihpu,"_")].PLAYUPFROMHOME 		 = evaluate(iHPU) >
		</cfif>
		<cfif UCASE(listFirst(ihpu,"_")) EQ "PLAYUPPASSNOHOME">
			<cfset stPlayUpsHome[listLast(ihpu,"_")].PLAYUPPASSNOHOME 	 = evaluate(iHPU) >
		</cfif>
		<cfif UCASE(listFirst(ihpu,"_")) EQ "PLAYUPPLAYERNAMEHOME">
			<cfset stPlayUpsHome[listLast(ihpu,"_")].PLAYUPPLAYERNAMEHOME = evaluate(iHPU) >
		</cfif>
		<cfif UCASE(listFirst(ihpu,"_")) EQ "PLAYUPWITHHOME">
			<cfset stPlayUpsHome[listLast(ihpu,"_")].PLAYUPWITHHOME		 = evaluate(iHPU) >
		</cfif>
		<cfif UCASE(listFirst(ihpu,"_")) EQ "PLAYUPFROMOTHERHOME">
			<cfset stPlayUpsHome[listLast(ihpu,"_")].PLAYUPFROMOTHERHOME		 = evaluate(iHPU) >
		</cfif>
	</cfloop> 

	<cfif NOT structIsEmpty(stPlayUpsHome)>

		<cfset homeCount = 1>
		<cfset recCount = 1>
		<cfif form.homeTeamPlayUpCnt NEQ 0>
			<cfset homeCount = form.homeTeamPlayUpCnt>
		
		<cfloop collection="#stPlayUpsHome#" item="ihpu">
			<cfset ctValues = 0>
			<cfif stPlayUpsHome[ihpu].PLAYUPFROMHOME GTE 0> <!--- play up from --->
				<cfset ctValues = ctValues + 1> 
			</cfif>  				
			<cfif len(trim(stPlayUpsHome[ihpu].PLAYUPPASSNOHOME)) GT 0> 
				<cfset ctValues = ctValues + 1> 
			</cfif>			 		
			<cfif len(trim(stPlayUpsHome[ihpu].PLAYUPPLAYERNAMEHOME)) GT 0> 
				<cfset ctValues = ctValues + 1> 
			</cfif>		 			
			<cfif stPlayUpsHome[ihpu].PLAYUPWITHHOME GT 0> <!--- team id --->
				<cfset ctValues = ctValues + 1> 
			</cfif>
			<cfif stPlayUpsHome[ihpu].PLAYUPFROMHOME EQ 0>

				<cfif len(trim(stPlayUpsHome[ihpu].PLAYUPFROMOTHERHOME)) GT 0> 
					<cfset ctValues = ctValues + 1> 
				</cfif> 

				<cfif ctValues NEQ 5 AND recCount LTE homeCount>
					<cfset ctErrors = ctErrors + 1>
					<cfset MSG = MSG & "Information may be missing from one or more of the Play Up Home entries.<br>">
					<cfbreak>
				</cfif>
			<cfelse>

				<cfif ctValues NEQ 4 AND recCount LTE homeCount>
					<cfset ctErrors = ctErrors + 1>
					<cfset MSG = MSG & "Information may be missing from one or more of the Play Up Home entries.<br>">
					<cfbreak>
				</cfif>
			</cfif>
			<cfset recCount = recCount + 1>
		</cfloop>
		</cfif>
	</cfif>

	<cfif NOT structIsEmpty(stPlayUpsHome)>

		<cfset homeCount = 1>
		<cfset recCount = 1>

		<cfif form.homeTeamPlayUpCnt NEQ 0>
			<cfset homeCount = form.homeTeamPlayUpCnt>
			<cfset hpuMessage = "">
			
			<cfloop from="1" to="#homeCount#" index="ihpu">
				<cfscript>
					hpuErrors = 0;
					hpuStatus = "";

					hPlayerName = stPlayUpsHome[ihpu].PLAYUPPLAYERNAMEHOME;
					hPassNumber = stPlayUpsHome[ihpu].PLAYUPPASSNOHOME;
					hPlayingWith = stPlayUpsHome[ihpu].PLAYUPWITHHOME;
					hPlayingFrom = stPlayUpsHome[ihpu].PLAYUPFROMHOME;
					hPlayingFromOther = stPlayUpsHome[ihpu].PLAYUPFROMOTHERHOME;

					// Set status based on playing from value.
					if ( hPlayingFrom EQ 0 ) {
						hpuStatus = "Other"; 
					}
					else if ( hPlayingFrom LT 0 ) {
						hpuErrors++; 
					}

					// Check that Pass Number was filled out.
					len(trim(hPassNumber)) LTE 0 ? hpuErrors++ : "";

					// Check that Player Name was filled out.
					len(trim(hPlayerName)) LTE 0 ? hpuErrors++ : "";

					// Check for a team id that player is playing up with.
					hPlayingWith LTE 0 ? hpuErrors++ : "";

					// Check for "Other" team name if PlayUpFromVisitor comes back as 0.
					if ( hpuStatus EQ "Other" ) {
						len(trim(hPlayingFromOther)) LTE 0 ? hpuErrors++ : "";
					}

					// Show errors if status is "Active", Errors exist and recCount LTE visitorCount
					if ( hpuErrors GT 0 AND recCount LTE homeCount ) {
						ctErrors++;
						hpuMessage = "Information may be missing from one or more of the Play Up Visitor entries.<br>";
					}

					recCount++;
				</cfscript>

			</cfloop>
			<cfset MSG = MSG & hpuMessage>
		</cfif>
	</cfif>

	<!--- look for VisitorPlayUp values that were entered --->
	<cfloop list="#FORM.FIELDNAMES#" index="iVPU">
		<cfif UCASE(listFirst(ivpu,"_")) EQ "PLAYUPFROMVISITOR">
			<cfset stPlayUpsVisitor[listLast(ivpu,"_")].PLAYUPFROMVISITOR 		 = evaluate(iVPU) >
		</cfif>
		<cfif UCASE(listFirst(ivpu,"_")) EQ "PLAYUPPASSNOVISITOR">
			<cfset stPlayUpsVisitor[listLast(ivpu,"_")].PLAYUPPASSNOVISITOR 	 = evaluate(iVPU) >
		</cfif>
		<cfif UCASE(listFirst(ivpu,"_")) EQ "PLAYUPPLAYERNAMEVISITOR">
			<cfset stPlayUpsVisitor[listLast(ivpu,"_")].PLAYUPPLAYERNAMEVISITOR = evaluate(iVPU) >
		</cfif>
		<cfif UCASE(listFirst(ivpu,"_")) EQ "PLAYUPWITHVISITOR">
			<cfset stPlayUpsVisitor[listLast(ivpu,"_")].PLAYUPWITHVISITOR		 = evaluate(iVPU) >
		</cfif>
		<cfif UCASE(listFirst(ivpu,"_")) EQ "PLAYUPFROMOTHERVISITOR">
			<cfset stPlayUpsVisitor[listLast(ivpu,"_")].PLAYUPFROMOTHERVISITOR		 = evaluate(iVPU) >
		</cfif>
	</cfloop> 

	<cfif NOT structIsEmpty(stPlayUpsVisitor)>

		<cfset visitorCount = 1>
		<cfset recCount = 1>

		<cfif form.visitorTeamPlayUpCnt NEQ 0>
			<cfset visitorCount = form.visitorTeamPlayUpCnt>
			<cfset vpuMessage = "">
			
			<cfloop from="1" to="#visitorCount#" index="ivpu">
				<cfscript>
					vpuErrors = 0;
					vpuStatus = "";

					vPlayerName = stPlayUpsVisitor[ivpu].PLAYUPPLAYERNAMEVISITOR;
					vPassNumber = stPlayUpsVisitor[ivpu].PLAYUPPASSNOVISITOR;
					vPlayingWith = stPlayUpsVisitor[ivpu].PLAYUPWITHVISITOR;
					vPlayingFrom = stPlayUpsVisitor[ivpu].PLAYUPFROMVISITOR;
					vPlayingFromOther = stPlayUpsVisitor[ivpu].PLAYUPFROMOTHERVISITOR;

					// Set status based on playing from value.
					if ( vPlayingFrom EQ 0 ) {
						vpuStatus = "Other"; 
					}
					else if ( vPlayingFrom LT 0 ) {
						vpuErrors++; 
					}

					// Check that Pass Number was filled out.
					len(trim(vPassNumber)) LTE 0 ? vpuErrors++ : "";

					// Check that Player Name was filled out.
					len(trim(vPlayerName)) LTE 0 ? vpuErrors++ : "";

					// Check for a team id that player is playing up with.
					vPlayingWith LTE 0 ? vpuErrors++ : "";

					// Check for "Other" team name if PlayUpFromVisitor comes back as 0.
					if ( vpuStatus EQ "Other" ) {
						len(trim(vPlayingFromOther)) LTE 0 ? vpuErrors++ : "";
					}

					// Show errors if status is "Active", Errors exist and recCount LTE visitorCount
					if ( vpuErrors GT 0 AND recCount LTE visitorCount ) {
						ctErrors++;
						vpuMessage = "Information may be missing from one or more of the Play Up Visitor entries.<br>";
					}

					recCount++;
				</cfscript>

			</cfloop>
			<cfset MSG = MSG & vpuMessage>
		</cfif>
	</cfif>

	<cfif ctErrors EQ 0>
			<!--- Passed validation, insert report... --->
			<!--- <cfdump var="#FORM#"> 
				con	<cfloop collection="#stMisconducts#" item="M"> <CFIF stMisconducts[m].MISCONDUCT GT 0> <br> MISC: #stMisconducts[m].MISCONPLAYERNAME# - #stMisconducts[m].MISCONPASSNO#   - #stMisconducts[m].MISCONTEAM# - #stMisconducts[m].MISCONDUCT# </CFIF> </cfloop>
				inj	<cfloop collection="#stInjuries#" item="j">    <CFIF stInjuries[j].INJURY GT 0> 		 <br> INJ: #stInjuries[j].INJURYPLAYERNAME# 	- #stInjuries[j].INJURYPASSNO# 		- #stInjuries[j].INJURYTEAM#    - #stInjuries[j].INJURY#		</CFIF>	</cfloop>
			--->
			<!--- LOG referee report header --->
			<cfstoredproc procedure="p_LOG_RefereeReportHeader" datasource="#SESSION.DSN#">
				<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@game_id"  value="#VARIABLES.GameID#">
				<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@username" value="#SESSION.USER.CONTACTID#">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@pagename" value="#CGI.Script_Name#">
			</cfstoredproc>
			<!--- LOG referee report detail --->
			<cfstoredproc procedure="p_LOG_RefereeReportDetail" datasource="#SESSION.DSN#">
				<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@game_id"  value="#VARIABLES.GameID#">
				<cfprocparam cfsqltype="CF_SQL_NUMERIC" dbvarname="@username" value="#SESSION.USER.CONTACTID#">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@pagename" value="#CGI.Script_Name#">
			</cfstoredproc>

			<!--- DELETE referee report detail --->
			<cfquery name="delRefRptDtl" datasource="#SESSION.DSN#">
				Delete from TBL_REFEREE_RPT_DETAIL Where Game_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
			</cfquery>
			<!--- DELETE referee report header --->
			<cfquery name="deleteRefRptHdr" datasource="#SESSION.DSN#">
				Delete from TBL_REFEREE_RPT_HEADER Where Game_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
			</cfquery>

			<!--- INSERT Referee report with changes --->
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#REPORT" method="AddRefReport" returnvariable="addReportValue">
				<cfinvokeargument name="formFields" value="#FORM#" >
				<cfinvokeargument name="contactID"  value="#SESSION.USER.CONTACTID#" >
				<cfinvokeargument name="stMisConducts"  value="#stMisconducts#" >
				<cfinvokeargument name="stInjuries" 	value="#stInjuries#" >
				<cfinvokeargument name="stPlayUpsHome" 	value="#stPlayUpsHome#" >
			  <cfinvokeargument name="stPlayUpsVisitor" 	value="#stPlayUpsVisitor#" >
			</cfinvoke>
	
			<cfif len(trim(addReportValue)) AND isNumeric(addReportValue) AND addReportValue GT 0>
				<cfset MSG = "This report was submitted successfully.">
				<cflocation url="refMatchReportView.cfm?swrept=1&gid=#VARIABLES.gameID#&wef=#VARIABLES.wef#&wet=#VARIABLES.wet#&rfid=#VARIABLES.rfid#&fid=#VARIABLES.fid#&gdv=#VARIABLES.gdv#&sby=#VARIABLES.sby#" >edit</a> 
			<CFELSE>
				<cfset MSG = addReportValue>
			</cfif> 
	</CFIF>
</cfif>


<cfinvoke component="#SESSION.SITEVARS.cfcPath#REPORT" method="getRefRPTHeader" returnvariable="qRefRptHeader">
	<cfinvokeargument name="gameID" value="#VARIABLES.gameID#" >
</cfinvoke> 
<cfif qRefRptHeader.RECORDCOUNT>
	<cfset refRptHeaderID 	= qRefRptHeader.referee_rpt_header_ID>
	<cfset RefereeID		= qRefRptHeader.REFEREEID >
	<cfset xrefGameOfficialID = qRefRptHeader.xref_game_official_id >
	<cfset StartTime		= timeFormat(qRefRptHeader.STARTTIME,"h:mm tt")>
	<cfset EndTime			= timeFormat(qRefRptHeader.ENDTIME,"h:mm tt")>
	<cfset AsstRef1writein	= qRefRptHeader.ASSISTANTREF1_WRITEIN >
	<cfset AsstRef2writein	= qRefRptHeader.ASSISTANTREF2_WRITEIN >
	<cfset AsstRefId1		= qRefRptHeader.contact_id_asstRef1 >
	<cfset AsstRefId2		= qRefRptHeader.contact_id_asstRef2 >
	<cfset Official4th		= qRefRptHeader.contact_id_official4th >
	<cfset scoreHomeHT		= qRefRptHeader.HalfTimeScore_Home >
	<cfset scoreVisitorHT	= qRefRptHeader.HalfTimeScore_Visitor >
	<cfset scoreHomeFT		= qRefRptHeader.FullTimeScore_Home >
	<cfset scoreVisitorFT	= qRefRptHeader.FullTimeScore_Visitor >
	<cfset Comments			= qRefRptHeader.Comments >
	<cfset SpectatorCount	= qRefRptHeader.spectatorCount >
	<cfset OnTimeHome 		= qRefRptHeader.IsOnTime_Home >
	<cfset OnTimeVisitor	= qRefRptHeader.IsOnTime_Visitor >
	<cfset HTHowLate		= qRefRptHeader.HowLate_Home >
	<cfset VTHowLate		= qRefRptHeader.HowLate_Visitor >
	<cfset PassesHome  		= qRefRptHeader.Passes_Home >	 
	<cfset PassesVisitor 	= qRefRptHeader.Passes_Visitor >  
	<cfset LineUpHome 		= qRefRptHeader.LineUP_Home >
	<cfset LineUpVisitor 	= qRefRptHeader.LineUP_Visitor >
	<cfset FieldCondition	= qRefRptHeader.fieldCond >
	<cfset FieldMarking		= qRefRptHeader.FieldMarking >
	<cfset GameSts 			= qRefRptHeader.GameSts>
	<cfset Weather 			= qRefRptHeader.weather >
	<cfset ConductOfficial 	= qRefRptHeader.conductOfficials >
	<cfset ConductPlayers 	= qRefRptHeader.ConductPlayers >
	<cfset conductSpectators = qRefRptHeader.conductSpectators >

	<cfif isdefined("form.homeTeamPlayUps") and len(trim(form.homeTeamPlayUps))>
		<cfset homeTeamPlayUps = form.homeTeamPlayUps>
	<cfelse>
		<cfset homeTeamPlayUps  = qRefRptHeader.homeTeamPlayUps>
	</cfif>

	<cfif isdefined("form.visitorTeamPlayUps") and len(trim(form.visitorTeamPlayUps))>
		<cfset visitorTeamPlayUps = form.visitorTeamPlayUps>
	<cfelse>
		<cfset visitorTeamPlayUps  = qRefRptHeader.visitorTeamPlayUps>
	</cfif>

	<cfif isdefined("form.homeTeamPlayUpCnt") and len(trim(form.homeTeamPlayUpCnt))>
		<cfset homeTeamPlayUpCnt = form.homeTeamPlayUpCnt>
	<cfelse>
		<cfset homeTeamPlayUpCnt  = qRefRptHeader.homeTeamPlayUpCnt>
	</cfif>

	<cfif isdefined("form.visitorTeamPlayUpCnt") and len(trim(form.visitorTeamPlayUpCnt))>
		<cfset visitorTeamPlayUpCnt = form.visitorTeamPlayUpCnt>
	<cfelse>
		<cfset visitorTeamPlayUpCnt  = qRefRptHeader.visitorTeamPlayUpCnt>
	</cfif>
	

	<cfset RefereeLastName  = "">
	<cfset RefereeName		= "">
	<cfset RefereePhone		= "">
	<cfset Grade			= "">
	<cfif len(trim(RefereeID))>
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo">
			<cfinvokeargument name="refereeID" value="#VARIABLES.RefereeID#">
		</cfinvoke>
		<CFIF qRefInfo.RECORDCOUNT>
			<cfset RefereeLastName	= qRefInfo.LastName >
			<cfset RefereeName		= qRefInfo.FirstName >
			<cfset Grade			= qRefInfo.Grade>
			<cfif len(trim(qRefInfo.phoneCell))>
				<cfset RefereePhone = "(c) " & qRefInfo.phoneCell>
			<cfelseif len(trim(qRefInfo.phoneHome))>
				<cfset RefereePhone = "(h) " & qRefInfo.phoneHome>
			<cfelseif len(trim(qRefInfo.phoneWork))>
				<cfset RefereePhone = "(w) " & qRefInfo.phoneWork>
			</cfif>
		</CFIF>
	</cfif>	

	<cfset AR1LastName	= "">
	<cfset AR1Name		= "">
	<cfset AR1Phone	= "">
	<cfset AR1Grade	= "">
	<cfif len(trim(AsstRefId1))>
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo1">
			<cfinvokeargument name="refereeID" value="#VARIABLES.AsstRefId1#">
		</cfinvoke>
		<CFIF qRefInfo1.RECORDCOUNT>
			<cfset AR1LastName	= qRefInfo1.LastName >
			<cfset AR1Name		= qRefInfo1.FirstName >
			<cfset AR1Grade		= qRefInfo1.Grade>
			<cfif len(trim(qRefInfo1.phoneCell))>
				<cfset AR1Phone = "(c) " & qRefInfo1.phoneCell>
			<cfelseif len(trim(qRefInfo1.phoneHome))>
				<cfset AR1Phone = "(h) " & qRefInfo1.phoneHome>
			<cfelseif len(trim(qRefInfo1.phoneWork))>
				<cfset AR1Phone = "(w) " & qRefInfo1.phoneWork>
			</cfif>
		</CFIF>
	</cfif>	

	<cfset AR2LastName	= "">
	<cfset AR2Name		= "">
	<cfset AR2Phone	= "">
	<cfset AR2Grade	= "">
	<cfif len(trim(AsstRefId2))>
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo2">
			<cfinvokeargument name="refereeID" value="#VARIABLES.AsstRefId2#">
		</cfinvoke>
		<CFIF qRefInfo2.RECORDCOUNT>
			<cfset AR2LastName	= qRefInfo2.LastName >
			<cfset AR2Name		= qRefInfo2.FirstName >
			<cfset AR2Grade		= qRefInfo2.Grade>
			<cfif len(trim(qRefInfo2.phoneCell))>
				<cfset AR2Phone = "(c) " & qRefInfo2.phoneCell>
			<cfelseif len(trim(qRefInfo2.phoneHome))>
				<cfset AR2Phone = "(h) " & qRefInfo2.phoneHome>
			<cfelseif len(trim(qRefInfo2.phoneWork))>
				<cfset AR2Phone = "(w) " & qRefInfo2.phoneWork>
			</cfif>
		</CFIF>
	</cfif>	


	<cfinvoke component="#SESSION.SITEVARS.cfcPath#REPORT" method="getRefRPTDetails" returnvariable="qRefRptDetails">
		<cfinvokeargument name="refRptHeaderID" value="#VARIABLES.refRptHeaderID#" >
	</cfinvoke>

	<cfquery name="qGameMisconducts" dbtype="query">
		Select PlayerName, EventType, PassNo, TeamID, MisConduct_ID
		  from qRefRptDetails
		 Where EventType = 1
	</cfquery> 

	<cfquery name="qGameInjuries" dbtype="query">
		Select PlayerName, EventType, PassNo, TeamID, MisConduct_ID
		  from qRefRptDetails
		 Where EventType = 2
	</cfquery> 
	<!--- 9/8/2014 - jdanz - 15511 - added the following query. --->
	<cfquery name="qPlayUps" dbtype="query">
		select PlayerName, EventType, PassNo, TeamID, MisConduct_ID, PlayUpFromOther
		from qRefRptDetails
		Where EventType = 3
	</cfquery>

	<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="getGameSchedule" returnvariable="qGameInfo">
		<cfinvokeargument name="gameID"		value="#VARIABLES.GameID#">
	</cfinvoke> 
	<cfif qGameInfo.RECORDCOUNT>
		<cfset GameDate		 = dateFormat(qGameInfo.game_date,"mm/dd/yyyy") >
		<cfset GameTime		 = timeFormat(qGameInfo.game_time,"hh:mm tt") >
		<cfset HomeScore	 = qGameInfo.Score_Home >
		<cfset VisitorScore	 = qGameInfo.Score_visitor >
		<cfset HomeTeam		 = qGameInfo.Home_TeamName >
		<cfset VisitorTeam	 = qGameInfo.Visitor_TeamName >
		<cfset HomeTeamID	 = qGameInfo.Home_Team_ID >
		<cfset VisitorTeamID = qGameInfo.Visitor_Team_ID >
		<cfset PlayField	 = qGameInfo.FIELD_ID >
		<cfset Division		 = qGameInfo.Division >
		<cfset FieldName 	 = qGameInfo.FIELDNAME>
		<cfset FieldAbbr 	 = qGameInfo.FIELDABBR>

		<cfset GameStartTime		= VARIABLES.GameTime >
		<cfset GameStartHour		= listFirst(VARIABLES.GameTime,":")>
		<cfset GameStartMinute		= Minute(VARIABLES.GameTime)>
		<cfset GameStartMeridian	= listLast(VARIABLES.GameTime," ")>
	
		<cfset GameEndTime		 	= DateAdd("n", 90, VARIABLES.GameTime)>
		<cfset GameEndTime		 	= timeFormat(variables.GameEndTime,"hh:mm tt") >
		<cfset GameEndHour			= listFirst(VARIABLES.GameEndTime,":")>
		<cfset GameEndMinute		= Minute(VARIABLES.GameEndTime)>
		<cfset GameEndMeridian		= listLast(VARIABLES.GameEndTime," ")>
	</cfif>

</cfif>

<!--- J.Danz 9-8-2014 NCSA15511 - get Play Up Teams with the next 2 queries. --->
	<cfquery datasource="#application.dsn#" name="getGame">
		select g.*, 
		dbo.f_get_team_age(ht.team_id) as home_team_age, 
		dbo.f_get_team_age(vt.team_id) as visitor_team_age,
		ascii(ht.playlevel) as home_flight,
		ascii(vt.playlevel) as visitor_flight,
		ht.playlevel as home_playlevel,
		vt.playlevel as visitor_playlevel,
		ht.gender as home_gender,
		vt.gender as visitor_gender
		from v_games_all g
		inner join tbl_team ht
		on g.home_team_id=ht.team_id
		inner join tbl_team vt
		on g.visitor_team_id=vt.team_id
		where game_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#VARIABLES.GameID#">
	</cfquery>
	<cfset teamAge=max(getGame.home_team_age,getGame.visitor_team_age)>
	<cfset HomeTeamClubID =getGame.Home_CLUB_ID>
	<cfset VisitorTeamClubID = getGame.Visitor_CLUB_ID>
    <!--- get teams available for play up --->
  <cfquery datasource="#application.dsn#" name="getPlayUpTeams">
    select team_id, club_id, dbo.getteamname(team_id) as teamname
    from tbl_team
    where club_id in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#HomeTeamClubID#">,<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#VisitorTeamClubID#">)
   	AND 
    (
    (dbo.f_get_team_age(team_id) < <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#teamAge#">
      AND playlevel <> 'P')
    OR (dbo.f_get_team_age(team_id) = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#teamAge#">
      AND dbo.f_is_level_lesser(<cfqueryparam cfsqltype="CF_SQL_CHAR" value="#getGame.home_playlevel#">,playlevel) = 1)
    OR (dbo.f_get_team_age(team_id) < <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#teamAge#">
      AND dbo.f_is_level_lesser(<cfqueryparam cfsqltype="CF_SQL_CHAR" value="#getGame.home_playlevel#">,playlevel) = 0)
    --OR teamage = 'U08'
    )
    AND playLevel <> 'R'
    AND season_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.currentseason.id#">
    <cfif getGame.home_gender EQ 'G'>
   	 AND gender = 'G'
    <cfelseif getGame.home_gender EQ 'B'>
    	AND gender = 'B'
    </cfif>
    order by teamname
  </cfquery>
<!--- J.Danz 9-8-2014 NCSA15511 - added the below to prepopulate forms given table data. --->
<cfif isDefined("qPlayUps")>
	<cfset homec = 1>
	<cfset visitc =1>
<cfloop query="qPlayUps">
	<cfif teamid eq homeTeamID>
		<cfset stPlayUpsHome[homec].PLAYUPFROMHOME = misconduct_ID>
		<cfset stPlayUpsHome[homec].PLAYUPFROMOTHERHOME = PlayUpFromOther>
		<cfset stPlayUpsHome[homec].PLAYUPPLAYERNAMEHOME = PlayerName>
		<cfset stPlayUpsHome[homec].PLAYUPPASSNOHOME = PassNo>
		<cfset stPlayUpsHome[homec].PLAYUPWITHHOME = teamid>
		<cfset homec = homec + 1>
	</cfif>
	<cfif teamid eq visitorTeamID>
		<cfset stPlayUpsVisitor[visitc].PLAYUPFROMVISITOR = misconduct_ID>
		<cfset stPlayUpsVisitor[visitc].PLAYUPFROMOTHERVISITOR = PlayUpFromOther>
		<cfset stPlayUpsVisitor[visitc].PLAYUPPLAYERNAMEVISITOR = PlayerName>
		<cfset stPlayUpsVisitor[visitc].PLAYUPPASSNOVISITOR = PassNo>
		<cfset stPlayUpsVisitor[visitc].PLAYUPWITHVISITOR = teamid>
		<cfset visitc = visitc + 1>
	</cfif>
</cfloop>
</cfif>

<!--- ============================================== --->
<cfquery name="qMisconducts" datasource="#SESSION.DSN#">
		SELECT Misconduct_ID, Misconduct_DESCR, Misconduct_EVENT
		  FROM TLKP_Misconduct
		 ORDER BY seq
</cfquery>
	
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrInjury">
	<cfinvokeargument name="listType" value="INJURY"> 
</cfinvoke>
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrWeather">
	<cfinvokeargument name="listType" value="WEATHER"> 
</cfinvoke> 
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrGameStatus">
	<cfinvokeargument name="listType" value="GAMESTATUS"> 
</cfinvoke> 
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrRatings1">
	<cfinvokeargument name="listType" value="RATINGS1"> 
</cfinvoke> 
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="stTimeParams">
	<cfinvokeargument name="listType" value="DDHHMMTT"> 
</cfinvoke> 

<FORM name="RefRpt" action="gameReportEdit.cfm"  method="post" >
	<input type="hidden" name="GameID"			value="#VARIABLES.gameID#"	>
	<input type="hidden" name="GameDate"		value="#VARIABLES.GameDate#" >
	<input type="hidden" name="xrefGameOfficialID"	value="#VARIABLES.xrefGameOfficialID#"	>
	<input type="hidden" name="AsstRefId1"		value="#VARIABLES.AsstRefId1#"	>
	<input type="hidden" name="AsstRefId2"		value="#VARIABLES.AsstRefId2#"	>

	<input type="hidden" name="wef"		value="#VARIABLES.wef#"	>
	<input type="hidden" name="wet"		value="#VARIABLES.wet#"	>
	<input type="hidden" name="rfid"	value="#VARIABLES.rfid#"	>
	<input type="hidden" name="fid"		value="#VARIABLES.fid#"	>
	<input type="hidden" name="gdv"		value="#VARIABLES.gdv#"	>
	<input type="hidden" name="sby"		value="#VARIABLES.sby#"	>

	<CFIF len(trim(MSG))>
		<span class="red">#MSG#</span>
	</CFIF>

	<span class="red"> Fields marked with * are required <br>- <b>Scroll to bottom of form to submit.</b> </span>

	<CFSET required = "<FONT color=red>*</FONT>" >
	<table cellspacing="0" cellpadding="5" align="center" border="0" style="table-layout:fixed;width:100%;"> 
		<tr class="tblHeading">
			<TD colspan="4">&nbsp;</td>
		</tr>
		<tr><TD colspan="4"><b>Game:</b> 		#VARIABLES.GameID#								#repeatString("&nbsp;",10)#
				<b>Date/Time:</b>   #VARIABLES.GameDate# - #VARIABLES.GameTime#		#repeatString("&nbsp;",10)#
	 			<b>Field:</b> 		#VARIABLES.FieldAbbr#
			</td>
		</tr>
		<tr><td colspan="4"><b>Division:</b>  #VARIABLES.Division#	 											#repeatString("&nbsp;",10)#
				<b>Home:</b> 	  #VARIABLES.HomeTeam# vs. <b>Visitor:</b> #VARIABLES.VisitorTeam#	#repeatString("&nbsp;",10)#
				<b>Score:</b> (H) #VARIABLES.HomeScore# - (V) #VARIABLES.VisitorScore#
			</TD>
		</TR>
		<TR><TD><b>Referee:</B> 
				#VARIABLES.RefereeLastName#, #VARIABLES.RefereeName# </TD><TD><b>USSF Referee Grade:</b> #VARIABLES.Grade#
				<!--- #repeatString("&nbsp;",10)# --->
	 	</TD><TD colspan="2"></TD></TR>
	 	<TR><TD>		
	 			<b>Asst Ref 1:</b>
				<cfif len(trim(AsstRefId1)) EQ 0 OR AsstRefId1 EQ 0>
					<input type="text" name="AsstRef1WriteIn" value="#VARIABLES.AsstRef1writein#" maxlength="100" >
				<cfelse>
					#VARIABLES.AR1LastName#, #VARIABLES.AR1Name#</TD><TD><b>USSF Referee Grade:</b> #VARIABLES.AR1Grade#
				</cfif>	
		</TD><TD></TD></TR>
	 	<TR><TD>
				<!--- #repeatString("&nbsp;",10)# --->
				<b>Asst Ref 2:</b> 
				<cfif len(trim(AsstRefId2)) eq 0 OR AsstRefId2 EQ 0>
					<input type="text" name="AsstRef2WriteIN" value="#AsstRef2writein#" maxlength="100" >
				<cfelse>
					#VARIABLES.AR2LastName#, #VARIABLES.AR2Name#</TD><TD><b>USSF Referee Grade:</b> #VARIABLES.AR2Grade#
				</cfif>	
			</TD><TD colspan="2"></TD>
		</TR>
	</table><!--- end top table --->

	<table cellspacing="2" cellpadding="5" align="left" border="0"  style="table-layout:fixed;width:100%;">
		<TR><TD><b>Game Played/cancelled?</b>
				<SELECT name="GameStatus" > 
					<cfloop from="1" to="#arrayLen(arrGameStatus)#" index="ix">
						<OPTION value="#arrGameStatus[ix][1]#" <cfif GameSts EQ arrGameStatus[ix][1]>selected</cfif> >#arrGameStatus[ix][2]#</OPTION>
					</cfloop>
				</SELECT>
				#repeatString("&nbsp;",10)#
				
				<b>Weather:</B>
				<SELECT name="Weather" class="TextEntry"  >
					<cfloop from="1" to="#arrayLen(arrWeather)#" index="idx">
						<OPTION value="#arrWeather[idx][1]#" <cfif Weather EQ arrWeather[idx][1]>selected</cfif> >#arrWeather[idx][2]#</OPTION>
					</cfloop>
				</SELECT>
			</td>
		</tr>
		<TR><TD><cfif qRefRptHeader.RECORDCOUNT>
					<!--- report was submitted, use report's time ---> 
					<cfset VARIABLES.StartHour	 	= listFirst(StartTime,":")>			 
					<cfset VARIABLES.StartMinute	= ListLast(listFirst(StartTime," "),":")>	
					<cfset VARIABLES.StartMeridian  = listLast(StartTime," ")>				
					<cfset VARIABLES.EndHour		= listFirst(EndTime,":")>				
					<cfset VARIABLES.EndMinute		= ListLast(listFirst(EndTime," "),":")>	
					<cfset VARIABLES.EndMeridian	= listLast(EndTime," ")>				
				<cfelseif isDefined("FORM") and StructCount(FORM) >
					<!--- form was submitted, use those values --->
					<cfset VARIABLES.StartHour	 	= FORM.StartHour>
					<cfset VARIABLES.StartMinute	= FORM.StartMinute>
					<cfset VARIABLES.StartMeridian  = FORM.StartMeridian>
					<cfset VARIABLES.endHour		= FORM.endHour>
					<cfset VARIABLES.endMinute	 	= FORM.endMinute>
					<cfset VARIABLES.endMeridian	= FORM.endMeridian>
				<cfelse>
					<!--- use Game start time plus 90 min til end --->
					<cfset VARIABLES.StartHour	 	= gameStartHour>
					<cfset VARIABLES.StartMinute	= gameStartMinute>
					<cfset VARIABLES.StartMeridian 	= gameStartMeridian>
					<cfset VARIABLES.EndHour		= gameEndHour>
					<cfset VARIABLES.EndMinute		= gameEndMinute>
					<cfset VARIABLES.EndMeridian	= gameEndMeridian>
				</cfif><!--- [#StartTime#][#EndTime#][#StartHour#][#StartMinute#][#StartMeridian#][#EndHour#][#EndMinute#][#EndMeridian#] --->
			
				#REQUIRED# <B>ACTUAL Start Time</B>
				<SELECT name="StartHour"> 
				    <CFLOOP list="#stTimeParams.hour#" index="iHr">
						<OPTION value="#iHr#" <cfif VARIABLES.StartHour EQ iHr>selected</cfif> >#iHr#</OPTION>
					</CFLOOP>
				</SELECT>
				<SELECT name="StartMinute"> 
					<CFLOOP list="#stTimeParams.min#" index="iMn">
						<OPTION value="#iMn#" <cfif VARIABLES.StartMinute EQ iMn>selected</cfif>  >#iMn#</OPTION>
					</CFLOOP>
				</SELECT>
				<SELECT name="StartMeridian">
					<CFLOOP list="#stTimeParams.tt#" index="iTT">
						<OPTION value="#iTT#" <cfif VARIABLES.StartMeridian EQ iTT>selected</cfif>  >#iTT#</OPTION>
					</CFLOOP>
				</SELECT>  
				#repeatString("&nbsp;",10)#
			
				#REQUIRED# <B>ACTUAL End Time</B>
				<SELECT name="EndHour"> 
				    <CFLOOP list="#stTimeParams.hour#" index="iHr">
						<OPTION value="#iHr#" <cfif VARIABLES.EndHour EQ iHr>selected</cfif> >#iHr#</OPTION>
					</CFLOOP>
				</SELECT>
				<SELECT name="EndMinute"> 
					<!--- <OPTION value="" selected>MN</OPTION> --->
					<CFLOOP list="#stTimeParams.min#" index="iMn">
						<OPTION value="#iMn#" <cfif VARIABLES.EndMinute EQ iMn>selected</cfif>  >#iMn#</OPTION>
					</CFLOOP>
				</SELECT>
				<SELECT name="EndMeridian">
					<CFLOOP list="#stTimeParams.tt#" index="iTT">
						<OPTION value="#iTT#" <cfif VARIABLES.EndMeridian EQ iTT>selected</cfif>  >#iTT#</OPTION>
					</CFLOOP>
				</SELECT>  
			</TD>
		</TR>

		<TR><td class="tdUnderLine">
				#repeatString("&nbsp;",10)#
				#REQUIRED#<B>Half-Time Score:</B> 
					(H)<input class="TextEntry" type=text name="scoreHomeHT"    value="#scoreHomeHT#" 	   size="2">
				  - (V)<input class="TextEntry" type=text name="scoreVisitorHT" value="#scoreVisitorHT#"  size="2">
				#repeatString("&nbsp;",10)#
				#REQUIRED#<B>Full-Time Score</B> 
					(H)<input class="TextEntry" type=text name="scoreHomeFT"	 value="#scoreHomeFT#"	   size="2">
				  - (V)<input class="TextEntry" type=text name="scoreVisitorFT" value="#scoreVisitorFT#"  size="2">
			</td>
		</TR>

		<tr>
			<td class="tdUnderLine">
				<cfsavecontent variable="custom_css">
					<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
				</cfsavecontent>
				<cfhtmlhead text="#custom_css#">

				<cfsavecontent variable="cf_footer_scripts">
				<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
				
				<script language="JavaScript" type="text/javascript">
					$(function(){
						//hide select
						$('select[name=homeTeamPlayUpCnt]').hide();
						$('select[name=visitorTeamPlayUpCnt]').hide();
						$('tr[id=playUpRow],tr[id^=PlayUpOnVisitorRow_],tr[id^=PlayUpOnHomeRow_],tr[id=playUpWarning]').hide();
						$('input[name^=PlayUpFromOtherVisitor_],input[name^=PlayUpFromOtherHome_]').hide();

						$('.homeTeamPlayUpCnt').slider({
							range:'min',
							value:#homeTeamPlayUpCnt#,
							min:0,
							max:18,
							step:1,
							slide:function(event,ui){
								$('select[name=homeTeamPlayUpCnt] option[value=' + ui.value + ']').attr('selected','selected');
								$('.homeTeamPlayUpCntLabel').text(ui.value);
								showHidePUTable();
							}
						});
						$('.visitorTeamPlayUpCnt').slider({
							range:'min',
							value:#visitorTeamPlayUpCnt#,
							min:0,
							max:18,
							step:1,
							slide:function(event,ui){
								$('select[name=visitorTeamPlayUpCnt] option[value=' + ui.value + ']').attr('selected','selected');
								$('.visitorTeamPlayUpCntLabel').text(ui.value);
								showHidePUTable();
							}
						});
						
						$('select[name^=PlayUpFromHome_],select[name^=PlayUpFromVisitor_]').change(showHideOtherInput);

						//hide sliders
						$('.playUpCnt').hide();
						
						$('input[name=homeTeamPlayUps],input[name=visitorTeamPlayUps]').click(showHideSliders);
						
						showHideSliders();
						$('select[name^=PlayUpFromHome_],select[name^=PlayUpFromVisitor_]').each(showHideOtherInput);
					});
					
					function showHideSliders(){
						if($('input[name=homeTeamPlayUps]:checked').val() == '1')
							$('input[name=homeTeamPlayUps]').closest('td').find('.playUpCnt').show();
						else
							$('input[name=homeTeamPlayUps]').closest('td').find('.playUpCnt').hide();
							
						if($('input[name=visitorTeamPlayUps]:checked').val() == '1')
							$('input[name=visitorTeamPlayUps]').closest('td').find('.playUpCnt').show();
						else
							$('input[name=visitorTeamPlayUps]').closest('td').find('.playUpCnt').hide();

						showHidePUTable();
					}

					function showHidePUTable() {
					var VisitorPU = parseInt($('.visitorTeamPlayUpCntLabel').text()),
					HomePU = parseInt($('.homeTeamPlayUpCntLabel').text()),
					VisitorChecked = $('input[name=visitorTeamPlayUps]:checked').val(),
					HomeChecked = $('input[name=homeTeamPlayUps]:checked').val(),
					VisitorCheckVal =$('input[name=visitorTeamPlayUps]').val(),
					HomeCheckVal =$('input[name=homeTeamPlayUps').val();

					//show/hide the entire table based on if there is values
					if (HomeChecked == 1 || VisitorChecked == 1) 
						$('tr[id=playUpRow],tr[id=playUpWarning]').show();
					else
						$('tr[id=playUpRow],tr[id=playUpWarning]').hide();
					
					//if homePlayUp radio is checked to yes show rows based on HomePU else hide all home rows
					if (HomeChecked == 1){
						//show/hide home rows based on value of HomePU
						for(var i = 1; i <= 18; i++){
							if(i <= HomePU)
								$('tr[id=PlayUpOnHomeRow_'+i+']').show();
							else
								$('tr[id=PlayUpOnHomeRow_'+i+']').hide();
						}
					} else {
						//else hide all the home rows
						$('tr[id^=PlayUpOnHomeRow_]').hide();
					}

					//if VisitorPlayUp radio is checked to yes show rows based on VisitorPU else hide all Visitor rows
					if (VisitorChecked == 1){
						//show/hide home rows based on value of VisitorPU
						for(var i = 1; i <= 18; i++){
							if(i <= VisitorPU)
								$('tr[id=PlayUpOnVisitorRow_'+i+']').show();
							else
								$('tr[id=PlayUpOnVisitorRow_'+i+']').hide();
						}
					}else {
						//else hide all the visitor rows
						$('tr[id^=PlayUpOnVisitorRow_]').hide();
					} 
					
				}

				function showHideOtherInput(){
					var el = $(this);
					var inp = el.next('input');
					inp.hide();

					if (el.val() == '0'){
						inp.show();

						}
				}
				</script>
				</cfsavecontent>

				<table border="0" cellpadding="0" cellspacing="0"  style="table-layout:fixed;width:100%;">
					<tr>
						<td width="50%" valign="top">
							#REQUIRED#<b>Did Home Team have Play Ups?</b>
							Yes<input type="radio" value="1" name="homeTeamPlayUps" <cfif homeTeamPlayUps EQ "1">checked="checked"</cfif>> No<input type="radio" value="0" name="homeTeamPlayUps" <cfif homeTeamPlayUps EQ "0">checked="checked"</cfif>>
							<div class="playUpCnt">
								<select name="homeTeamPlayUpCnt">
									<cfloop from="0" to="18" index="i">
										<option value="#i#" <cfif homeTeamPlayUpCnt EQ i>selected="selected"</cfif>>#i#</option>
									</cfloop>
								</select>
								#REQUIRED#<b>Use slider to indicate how many</b>
								<div class="homeTeamPlayUpCntLabel" style="font-size:1.2em; font-weight:bold; margin-bottom:5px;">#homeTeamPlayUpCnt#</div>
								<div class="homeTeamPlayUpCnt" style="width:50%;"></div>
							</div>
						</td>
						<td width="50%" valign="top">
							#REQUIRED#<b>Did Visitor Team have Play Ups?</b>
							Yes<input type="radio" value="1" name="visitorTeamPlayUps" <cfif visitorTeamPlayUps EQ "1">checked="checked"</cfif>> No<input type="radio" value="0" name="visitorTeamPlayUps" <cfif visitorTeamPlayUps EQ "0">checked="checked"</cfif>>
							<div class="playUpCnt">
								<select name="visitorTeamPlayUpCnt">
									<cfloop from="0" to="18" index="i">
										<option value="#i#" <cfif visitorTeamPlayUpCnt EQ i>selected="selected"</cfif>>#i#</option>
									</cfloop>
								</select>
								#REQUIRED#<b>Use slider to indicate how many</b>
								<div class="visitorTeamPlayUpCntLabel" style="font-size:1.2em; font-weight:bold; margin-bottom:5px;">#visitorTeamPlayUpCnt#</div>
								<div class="visitorTeamPlayUpCnt" style="width:50%;"></div>
							</div>						
						</td>
					</tr>
					<TR id="playUpWarning">
						<td>
						<span class="red">You must enter player data in PLAYERS PLAYING UP Data Entry Section Below</span>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<TR><td align="left" valign="top" class="tdUnderLine">
				<table cellpadding="2" cellspacing="2" border="0"  style="table-layout:fixed;width:100%;">
					<tr><td valign="top">
							<b>Overall Field Conditions:</b>
							<SELECT name="FieldMarking" >
								<cfloop from="1" to="#arrayLen(arrRatings1)#" index="idx">
									<OPTION value="#arrRatings1[idx][1]#" <cfif FieldMarking EQ arrRatings1[idx][1]>selected</cfif> >#arrRatings1[idx][2]#</OPTION>
								</cfloop>
							</SELECT>
						</td>
						<td align="left" valign="top">
							<cfif Len(Trim(FieldCondition))>
								<!--- we have a value, is it from the form "A,B,C" or the DB "ABC" --->
								<cfif listLen(FieldCondition) EQ 1 AND Len(Trim(FieldCondition)) GT 1>
									<!--- we have a string "ABC" that needs to be converted to a list --->
									<cfset lTemp = "">
									<cfloop from="1" to="#len(FieldCondition)#" index="ii">
										<cfset lTemp = listAppend(lTemp, Mid(FieldCondition, ii, 1), ",")>
									</cfloop>
									<cfset FieldCondition = lTemp>
								</cfif>
							</cfif>
							<b>Specifics:</b>(Check all that apply)
							<BR><input type="checkbox" NAME="fieldSpecifics" <cfif listFindNoCase(FieldCondition,"A") >checked</cfif> value="A"> <B>Inadequate field marking</B>
							<BR><input type="checkbox" NAME="fieldSpecifics" <cfif listFindNoCase(FieldCondition,"B") >checked</cfif> value="B"> <B>Missing Goal Nets</B>
							<BR><input type="checkbox" NAME="fieldSpecifics" <cfif listFindNoCase(FieldCondition,"C") >checked</cfif> value="C"> <B>Missing Corner Flags</B>
							<BR><input type="checkbox" NAME="fieldSpecifics" <cfif listFindNoCase(FieldCondition,"D") >checked</cfif> value="D"> <B>Dangerous Field Conditions</B>
						</td>
						<td>&nbsp;
							<BR><input type="checkbox" NAME="fieldSpecifics" <cfif listFindNoCase(FieldCondition,"E") >checked</cfif> value="E"> <B>No Game Ball and/or Substitute Game Ball</B>
							<BR><input type="checkbox" NAME="fieldSpecifics" <cfif listFindNoCase(FieldCondition,"F") >checked</cfif> value="F"> <B>Goals not secure</B>
							<BR><input type="checkbox" NAME="fieldSpecifics" <cfif listFindNoCase(FieldCondition,"G") >checked</cfif> value="G"> <B>Home team not ready to play within the designated time</B>
							<BR><input type="checkbox" NAME="fieldSpecifics" <cfif listFindNoCase(FieldCondition,"H") >checked</cfif> value="H"> <B>Visiting team not ready to play within the designated time</B>
						</td>
					</tr>
				</table>
			</TD>
		</TR>
		<TR><td align="left" class="tdUnderLine">
				<b>Was the Home team on the field on time?</B> &nbsp;
				<SELECT name="OnTimeHome"  >
					<OPTION value="1" <cfif OnTimeHome EQ "1">selected</cfif>  >Yes</OPTION>
					<OPTION value="0" <cfif OnTimeHome EQ "0">selected</cfif>  >No </OPTION>
				</SELECT>
				<B>How Late?</B><input type=text name="HTHowLate" value="#HTHowLate#" size="2" maxlength="3"  >(in Mins)
				<br>
				<b>Was the visiting team on the field on time?</b>
				<SELECT name="OnTimeVisitor"  >
					<OPTION value="1" <cfif OnTimeVisitor EQ "1">selected</cfif>  >Yes</OPTION>
					<OPTION value="0" <cfif OnTimeVisitor EQ "0">selected</cfif>  >No </OPTION>
				</SELECT>
				<B>How Late?</B><input type=text name="VTHowLate" value="#VTHowLate#"  size="2" maxlength="3"  >(in Mins)
			</TD>
		</TR>
		<TR><TD align="left" class="tdUnderLine">
				<b>Conduct of Officials: </b>
				<SELECT name="ConductOfficial"   > 
					<cfloop from="1" to="#arrayLen(arrRatings1)#" index="idx">
						<OPTION value="#arrRatings1[idx][1]#" <cfif ConductOfficial EQ arrRatings1[idx][1]>selected</cfif> >#arrRatings1[idx][2]#</OPTION>
					</cfloop>
				</SELECT>
				#repeatString("&nbsp;",7)#
				<b>of Players:</b>
				<SELECT name="ConductPlayers"   > 
					<cfloop from="1" to="#arrayLen(arrRatings1)#" index="idx">
						<OPTION value="#arrRatings1[idx][1]#" <cfif ConductPlayers EQ arrRatings1[idx][1]>selected</cfif> >#arrRatings1[idx][2]#</OPTION>
					</cfloop>
				</SELECT>
				#repeatString("&nbsp;",7)#
				<b>of Spectators:</b>
				<SELECT name="ConductSpectators"   > 
					<cfloop from="1" to="#arrayLen(arrRatings1)#" index="idx">
						<OPTION value="#arrRatings1[idx][1]#" <cfif ConductSpectators EQ arrRatings1[idx][1]>selected</cfif> >#arrRatings1[idx][2]#</OPTION>
					</cfloop>
				</SELECT>
				No.of Spectators <input type="text" name="SpectatorCount" value="#SpectatorCount#"  size="2"  maxlength="4" >Approx.
			</TD>
		</TR>

		<tr><td align="right" class="tdUnderLine">
				<table cellpadding="0" cellspacing="0" border="0"  style="table-layout:fixed;width:100%;">
					<tr><td align="left">
							<b>Player passes of the home team were received and checked</b> &nbsp; 
							<SELECT name="PassesHome"  > 
								<OPTION value="1" <cfif PassesHome EQ "1">selected</cfif>  >Yes</OPTION>
								<OPTION value="0" <cfif PassesHome EQ "0">selected</cfif>  >No </OPTION>
							</SELECT>
						</td>
						<td align="left">
							<b>Line up of home team enclosed, available</b>  
							<SELECT name="LineUpHome"   >
								<OPTION value="1" <cfif LineUpHome EQ "1">selected</cfif>  >Yes</OPTION>
								<OPTION value="0" <cfif LineUpHome EQ "0">selected</cfif>  >No </OPTION>
							</SELECT>
						</td>
					</tr>
					<tr><td align="left">
							<b>Player passes of the Visiting team were received and checked</b>
							<SELECT name="PassesVisitor"  > 
								<OPTION value="1" <cfif PassesVisitor EQ "1">selected</cfif>  >Yes</OPTION>
								<OPTION value="0" <cfif PassesVisitor EQ "0">selected</cfif>  >No </OPTION>
							</SELECT>
						</td>
						<td align="left">
							<b>Line up of visiting team enclosed, available</b>
							<SELECT name="LineUpVisitor"  > 
								<OPTION value="1" <cfif LineUpVisitor EQ "1">selected</cfif>  >Yes</OPTION>
								<OPTION value="0" <cfif LineUpVisitor EQ "0">selected</cfif>  >No </OPTION>
							</SELECT>
						</td>
					</tr>
				</table>
			</td>
		</tr>

		<tr><td class="tdUnderLine">
				<TABLE class="limit_selects" cellSpacing=0 cellPadding=2 width="100%" border=0  style="table-layout:fixed;width:100%;">
					<tr class="tblHeading">
						<td colspan=4>
							<b>MISCONDUCTS DURING THE GAME</b>
							<br>PLAYERS AND COACHES
						</td>
					</tr>
					<tr class="tblHeading">
						<td >(First & Last Name)</td>
						<td >Pass ##		</td>
						<td >Team		</td>
						<td >Misconduct	</td>
					</tr>
					<cfloop from="1" to="10" index="idx">
						<cfif idx LTE qGameMisconducts.RECORDCOUNT>
							<!--- We have MisConducts to list --->
							<tr><td><input type="text" name="misConPlayerName_#idx#" value="#qGameMisconducts.PlayerName[idx]#" size="17" maxlength="50" ></td>
								<td><input type="text" name="misConPassNo_#idx#"     value="#qGameMisconducts.PassNo[idx]#" 	size="8"  maxlength="15" ></td>
								<td><SELECT name="misConTeam_#idx#"   style="font-size:11px;" >
										<option value="0" selected>Select Team</option>
										<option value="#HomeTeamID#"	<cfif qGameMisconducts.TeamID[idx] EQ HomeTeamID>selected</cfif> >	  #HomeTeam#    </option>
										<option value="#VisitorTeamID#"	<cfif qGameMisconducts.TeamID[idx] EQ VisitorTeamID>selected</cfif> > #VisitorTeam# </option>
									</select>
								</td>
								<td><SELECT name="MisConduct_#idx#"  style="font-size:11px;" >
										<option value="0" selected>Select Misconduct</option>
										<cfloop query="qMisconducts">
											<option value="#Misconduct_ID#" <cfif qGameMisconducts.MisConduct_ID[idx] EQ Misconduct_ID>selected</cfif> >#UCase(Misconduct_DESCR)# - <b>#Misconduct_EVENT#</b></option>
										</cfloop>
									</select>
								</td>
							</tr>
						<cfelse>
							<!--- We need to display A BLANK miconduct entry line --->
							<tr><td><input type="text" name="misConPlayerName_#idx#" value="#stMisconducts[idx].MISCONPLAYERNAME#" size="17" maxlength="50" > </td>
								<td><input type="text" name="misConPassNo_#idx#"     value="#stMisconducts[idx].MISCONPASSNO#"	   size="8"  maxlength="15" > </td>
								<td><SELECT name="misConTeam_#idx#"  style="font-size:11px;">
										<option value="0" selected>Select Team</option>
										<option value="#HomeTeamID#"	<cfif stMisconducts[idx].MISCONTEAM EQ HomeTeamID>selected</cfif> > #HomeTeam#    </option>
										<option value="#VisitorTeamID#"	<cfif stMisconducts[idx].MISCONTEAM EQ VisitorTeamID>selected</cfif> > #VisitorTeam# </option>
									</select><!--- <cfif TeamID EQ HomeTeamID>selected</cfif> <cfif TeamID EQ VisitorTeamID>selected</cfif> --->
								</td>
								 <td><SELECT name="MisConduct_#idx#" style="font-size:11px;" >
										<option value="0"  selected>Select Misconduct</option>
										<cfloop query="qMisconducts">
											<option value="#Misconduct_ID#" <cfif stMisconducts[idx].MISCONDUCT EQ Misconduct_ID>selected</cfif> >#uCase(Misconduct_DESCR)# - <b>#Misconduct_EVENT#</b></option>
										</cfloop><!---  --->
									</select>
								</td>
							</tr>
						</cfif>
					</cfloop>
	
					<tr class="tblHeading">
						<td colspan=4> SERIOUS INJURIES DURING THE GAME (Describe injury details in comments) </td>
						</tr>
					<tr class="tblHeading">
						<td >Player <br> (First & Last Name)</td>
						<td >Pass ##		</td>
						<td >Team		</td>
						<td >Nature of Injury	</td>
					</tr>
					<cfloop from="1" to="10" index="idx">
						<CFIF idx LTE qGameInjuries.RECORDCOUNT>
							<!--- we have injuries to report on  --->
							<tr><td><input type="text" name="injuryPlayerName_#idx#" value="#qGameInjuries.PlayerName[idx]#" size="17" maxlength="50" > </td>
								<td><input type="text" name="injuryPassNo_#idx#"     value="#qGameInjuries.PassNo[idx]#" size="8" maxlength="15" >	</td>
								<td><SELECT name="injuryTeam_#idx#"  style="font-size:11px;">
										<option value="0" selected>Select Team</option>
										<option value="#HomeTeamID#"	<cfif qGameInjuries.TeamID[idx] EQ HomeTeamID>selected</cfif> > #HomeTeam#    </option>
										<option value="#VisitorTeamID#"	<cfif qGameInjuries.TeamID[idx] EQ VisitorTeamID>selected</cfif> > #VisitorTeam# </option>
									</select><!---   --->
								</td>
								<td><SELECT name="Injury_#idx#">
										<option value="0" selected>Select Injury</option>
										<cfloop from="1" to="#arrayLen(arrInjury)#" index="iJ">
											<option value="#arrInjury[iJ][1]#" <cfif arrInjury[iJ][1] EQ qGameInjuries.MisConduct_ID[idx]>selected</cfif> >#arrInjury[iJ][2]# - INJURY</option>
										</cfloop>
									</select>
								</td>
							</tr>
						<CFELSE>
							<!--- Display a blank Injury input row --->
							<tr><td><input type="text" name="injuryPlayerName_#idx#" value="#stInjuries[idx].INJURYPLAYERNAME#" size="17" maxlength="50" > </td>
								<td><input type="text" name="injuryPassNo_#idx#"     value="#stInjuries[idx].INJURYPASSNO#" size="8" maxlength="15" >	</td>
								<td><SELECT name="injuryTeam_#idx#"  style="font-size:11px;">
										<option value="0" selected>Select Team</option>
										<option value="#HomeTeamID#"	<cfif stInjuries[idx].INJURYTEAM EQ HomeTeamID>selected</cfif> > #HomeTeam#    </option>
										<option value="#VisitorTeamID#"	<cfif stInjuries[idx].INJURYTEAM EQ VisitorTeamID>selected</cfif> > #VisitorTeam# </option>
									</select><!---   --->
								</td>
								<td><SELECT name="Injury_#idx#">
										<option value="0" selected>Select Injury</option>
										<cfloop from="1" to="#arrayLen(arrInjury)#" index="iJ">
											<option value="#arrInjury[iJ][1]#" <cfif arrInjury[iJ][1] EQ stInjuries[idx].INJURY>selected</cfif> >#arrInjury[iJ][2]# - INJURY</option>
										</cfloop>
									</select>
								</td>
							</tr>
						</CFIF>
					</cfloop>
				</table>
			</td>
		</tr>
		<tr id="playUpRow"><td class="tdUnderLine">
			<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0  style="table-layout:fixed;width:100%;">
				<tr class="tblHeading">
					<td colspan=4> PLAYERS PLAYING UP - Using information from Match Day Form, enter Name and Pass ## of player playing up for each team in appropriate line; then select team playing up from - if "OTHER", type in team name as listed on Match Day Form.</td>
					</tr>
				<tr class="tblHeading">
					<td >Player <br> (First & Last Name)</td>
					<td >Pass ##		</td>
					<td >Team Playing With</td>
					<td >Team Playing Up From</td>
				</tr>
				<cfloop from="1" to="18" index="i">
				<tr id="PlayUpOnHomeRow_#i#">
					<td>#REQUIRED#<input type="text" name="PlayUpPlayerNameHome_#i#" <cfif trim(len(stPlayUpsHome[i].PLAYUPPLAYERNAMEHOME))>value="#stPlayUpsHome[i].PLAYUPPLAYERNAMEHOME#"<cfelse>value=""</cfif>  size="17" maxlength="50" ></td>
					<td>#REQUIRED#<input type="text" name="PlayUpPassNoHome_#i#" <cfif trim(len(stPlayUpsHome[i].PLAYUPPASSNOHOME))>value="#stPlayUpsHome[i].PLAYUPPASSNOHOME#"<cfelse>value=""</cfif> 	size="8" maxlength="15" ></td>
					<td>#homeTeam# <input type="hidden" name="PlayUpWithHome_#i#" value="#homeTeamID#"></td>
					<td>
						#REQUIRED#<select name="PlayUpFromHome_#i#">
								<option value="-1" <cfif stPlayUpsHome[i].PLAYUPFROMHOME EQ -1>selected="true"</cfif>>Select Team</option>
							<cfloop query="getPlayUpTeams">
								<cfif CLUB_ID EQ HomeTeamClubID>
									<option value="#team_id#" <cfif stPlayUpsHome[i].PLAYUPFROMHOME EQ team_id>selected="true"</cfif>>#teamname#</option>
								</cfif>
							</cfloop>
								<option value="0" <cfif stPlayUpsHome[i].PLAYUPFROMHOME EQ 0>selected="true"</cfif>>Other</option>
						</select>
						<input type="text" name="PlayUpFromOtherHome_#i#" <cfif trim(len(stPlayUpsHome[i].PLAYUPFROMOTHERHOME))>value="#stPlayUpsHome[i].PLAYUPFROMOTHERHOME#"<cfelse>value=""</cfif> size="25" maxlength="50" placeholder="Enter Team Name">
					</td>
				</tr>
				</cfloop>
				<cfloop from="1" to="18" index="i">
				<tr id="PlayUpOnVisitorRow_#i#">
					<td>#REQUIRED#<input type="text" name="PlayUpPlayerNameVisitor_#i#" <cfif trim(len(stPlayUpsVisitor[i].PLAYUPPLAYERNAMEVISITOR))>value="#stPlayUpsVisitor[i].PLAYUPPLAYERNAMEVISITOR#"<cfelse>value=""</cfif> size="17" maxlength="50" ></td>
					<td>#REQUIRED#<input type="text" name="PlayUpPassNoVisitor_#i#" <cfif trim(len(stPlayUpsVisitor[i].PLAYUPPASSNOVISITOR))>value="#stPlayUpsVisitor[i].PLAYUPPASSNOVISITOR#"<cfelse>value=""</cfif> 	size="8" maxlength="15" ></td>
					<td>#VisitorTeam# <input type="hidden" name="PlayUpWithVisitor_#i#" value="#VisitorTeamID#"></td>
					<td>
						#REQUIRED#<select name="PlayUpFromVisitor_#i#">
								<option value="-1" <cfif stPlayUpsVisitor[i].PLAYUPFROMVISITOR EQ -1>selected="true"</cfif>>Select Team</option>
							<cfloop query="getPlayUpTeams">
								<cfif CLUB_ID EQ VisitorTeamClubID>
									<option value="#team_id#" <cfif stPlayUpsVisitor[i].PLAYUPFROMVISITOR EQ team_id>selected="true"</cfif>>#teamname#</option>
								</cfif>
							</cfloop>
								<option value="0" <cfif stPlayUpsVisitor[i].PLAYUPFROMVISITOR EQ 0>selected="true"</cfif>>Other</option>
						</select>
						<input type="text" name="PlayUpFromOtherVisitor_#i#" <cfif trim(len(stPlayUpsVisitor[i].PLAYUPFROMOTHERVISITOR))>value="#stPlayUpsVisitor[i].PLAYUPFROMOTHERVISITOR#"<cfelse>value=""</cfif> size="25" maxlength="50" placeholder="Enter Team Name">
					</td>
				</tr>
				</cfloop>
			</TABLE>
		</td>
	</tr>
		<tr><td align="left" class="tdUnderLine">
				<b>Comments</b> <br> <TEXTAREA name="Comments" rows=10  cols=90 >#Trim(Comments)#</TEXTAREA>
			</td>
		</tr>
		<tr><td align="center">
				<span class="red">NOTE: Printed referee report with roster still needs to be mailed as before.</span>
				<br> <INPUT type="Button" name="SubmitReport" value="Submit"   onclick="GoSubmit('')"  >
					 <INPUT type="button" value="Back"	 name="Back"   onclick="GoBack()" ID="Button3">
			</td>
		</tr>
</table>

</FORM>
 
</cfoutput>
</div>
<cfinclude template="_footer.cfm">


<script language="javascript">
function GoBack()
{	history.go(-1);
}
function GoSubmit(param)
{	var Err = 0;
	var YN;
	//Err = ValidateField();
	//if (Err == "0")
	{	YN = confirm("Report Once submitted cannot be Edited. Proceed to submit (Y/N)");
		if (YN)
		{	self.document.RefRpt.SubmitReport.disabled = true;
			self.document.RefRpt.submit();
			return true;
		}
	}
	return false;
}
</script>



<!--- 
	FileName:	gameReportSubmit.cfm
	Created on: 10/21/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
	-----------------------------------------------------------------
	CHANGES to this file may have an impact on gameRefReportPrint.cfm
			which displays results from this page.
	-----------------------------------------------------------------
	
MODS: mm/dd/yyyy - filastname - comments
02/19/2009 - aarnone - redirected back to list of game after rport was submitted.
					 - removed refPaid and refAmount from being inserted. refs will now use claim unpaid fees page.
03/31/2009 - aarnone - fixed error wen adding misconds and inj when missing  value
04/03/2009 - aarnone - fixed visiting team fieldSpecifics value
04/07/2009 - aarnone - made ref print to go to a pop up page
05/20/2009 - aarnone - #7757 changed text
06/22/2012 - jrab - increase form input size from 10 to 15 for no of passes
08/26/2014 - jdanz - NCSA15511 - added logic to input data on play ups
05/25/2017 - apinzone - fixed js reference errors, updated jquery ui to 1.12.1, moved jquery ui css to header, moved all javascript to footer via "cf_footer_scripts" variable
08/14/2017 - apinzone - 22821 - Added logic to update the report if the report ID already exists. Fixes "back button editing".
 --->

<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Submit Game Report</H1>     <!--- <br> <h2>yyyyyy </h2> --->
<!--- <cfif isdefined("form") and structCount(FORM) >
	<cfdump var="#form#" abort="true">
</cfif> --->
<CFIF isDefined("URL.GID") AND isNumeric(URL.GID)>
	<CFSET gameID = URL.GID>
<CFELSEIF isDefined("FORM.gameID") AND isNumeric(FORM.gameID)>
	<CFSET gameID = FORM.gameID>
<CFELSE>
	<CFSET gameID = 0>
</CFIF>
<CFSET MSG = "">

<cfif not isdefined("HOMENOPARTICIPATECNT")>
	<cfset HOMENOPARTICIPATECNT = 0>
</cfif>
<cfif not isdefined("VISITORNOPARTICIPATECNT")>
	<cfset VISITORNOPARTICIPATECNT = 0>
</cfif>
<!--- initialize MISCONDUCTS AND INJURIES to hold values while processing forms  --->
<cfset stMisconducts = structNew()>
<Cfloop from="1" to="10" index="ix">
	<cfset stMisconducts[ix] = structNew()>
	<cfset stMisconducts[ix].MISCONDUCT = "">
	<cfset stMisconducts[ix].MISCONPASSNO = "">
	<cfset stMisconducts[ix].MISCONPLAYERNAME = "">
	<cfset stMisconducts[ix].MISCONTEAM = "">
</CFLOOP>	<!--- <cfdump var="#stMisconducts#">  --->

<cfset stInjuries = structNew()>
<Cfloop from="1" to="10" index="ix">
	<cfset stInjuries[ix] = structNew()>
	<cfset stInjuries[ix].INJURY = "">
	<cfset stInjuries[ix].INJURYPASSNO = "">
	<cfset stInjuries[ix].INJURYPLAYERNAME = "">
	<cfset stInjuries[ix].INJURYTEAM = "">
</CFLOOP>	<!--- <cfdump var="#stInjuries#">  --->

<cfset stPlayUpsHome = structNew()>
<cfset stPlayUpsVisitor = structNew()>
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

<cfset stNoParticipatesHome = structNew()>
<cfset stNoParticipatesVisitor = structNew()>
<cfloop from="1" to="18" index="ix">

	<cfset stNoParticipatesHome[ix] = structNew()>
	<cfset stNoParticipatesHome[ix].NoParticipateFROMHOME = "">
	<cfset stNoParticipatesHome[ix].NoParticipateFROMOTHERHOME = "">
	<cfset stNoParticipatesHome[ix].NoParticipatePLAYERNAMEHOME = "">
	<cfset stNoParticipatesHome[ix].NoParticipateTypeHome = "">
	<cfset stNoParticipatesHome[ix].NoParticipateWITHHOME = "">

	<cfset stNoParticipatesVisitor[ix] = structNew()>
	<cfset stNoParticipatesVisitor[ix].NoParticipateFROMVISITOR = "">
	<cfset stNoParticipatesVisitor[ix].NoParticipateFROMOTHERVISITOR = "">
	<cfset stNoParticipatesVisitor[ix].NoParticipatePLAYERNAMEVISITOR = "">
	<cfset stNoParticipatesVisitor[ix].NoParticipateTypeVisitor = "">
	<cfset stNoParticipatesVisitor[ix].NoParticipateWITHVISITOR = "">
</cfloop> 


<!--- <cfif isdefined("FORM")>
	<cfdump var="#form#">
</cfif> --->
<CFIF isDefined("FORM") AND structCount(FORM) and FORM.MODE EQ "Add">
<!--- <cfdump var="#form#" abort="true"> 	--->
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

	<cfif not isdefined("form.homeNoParticipate")>
		<cfset ctErrors = ctErrors + 1>
		<cfset msg = msg & "You must indicate if the home team had and players or coaches not participating.<br>">
	</cfif>
	<cfif not isdefined("form.visitorNoParticipate")>
		<cfset ctErrors = ctErrors + 1>
		<cfset msg = msg & "You must indicate if the visitor team had and players or coaches not participating.<br>">
	</cfif>
	<cfif isdefined("form.homeNoParticipate") AND form.homeNoParticipate EQ "1" AND form.homeNoParticipateCnt EQ "0">
		<cfset ctErrors = ctErrors + 1>
		<cfset msg = msg & "If the home team has players or coaches not participating, you must select a number greater than zero.<br>">
	</cfif>
	<cfif isdefined("form.visitorNoParticipate") AND form.visitorNoParticipate EQ "1" AND form.visitorNoParticipateCnt EQ "0">
		<cfset ctErrors = ctErrors + 1>
		<cfset msg = msg & "If the visitor team has players or coaches not participating, you must select a number greater than zero.<br>">
	</cfif>

	<cfif isdefined("form.HOMENOPARTICIPATE") AND form.HOMENOPARTICIPATE EQ "1" AND form.HOMENOPARTICIPATECNT EQ "0">
		<cfset ctErrors = ctErrors + 1>
		<cfset msg = msg & "Use the Slider to indicate total number of Home coaches and players on MDF and Roster not Participating.<br>">
		<cfset HOMENOPARTICIPATECNT = 0>
	<cfelseif isdefined("form.HOMENOPARTICIPATE") AND form.HOMENOPARTICIPATE EQ "1" AND form.HOMENOPARTICIPATECNT GTE 1>
		<cfset HOMENOPARTICIPATECNT = form.HOMENOPARTICIPATECNT>
	<cfelse>
		<cfset HOMENOPARTICIPATECNT = 0>
	</cfif>
	<cfif isdefined("form.VISITORNOPARTICIPATE") AND form.VISITORNOPARTICIPATE EQ "1" AND form.VISITORNOPARTICIPATECNT EQ "0">
		<cfset ctErrors = ctErrors + 1>
		<cfset msg = msg & "Use the Slider to indicate total number of Visitor coaches and players on MDF and Roster not Participating.<br>">
		<cfset VISITORNOPARTICIPATECNT = 0>
	<cfelseif  isdefined("form.VISITORNOPARTICIPATE") AND form.VISITORNOPARTICIPATE EQ "1" AND form.VISITORNOPARTICIPATECNT GTE 1>
		<cfset VISITORNOPARTICIPATECNT = form.VISITORNOPARTICIPATECNT>
	
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
	</cfloop> <!--- <cfdump var="#stInjuries#"> --->

	<cfif NOT structIsEmpty(stInjuries)>
		<!--- INJURY data was entered, were all 4 fields entered? --->
		<cfloop collection="#stInjuries#" item="ij">
			<cfset ctValues = 0>
			<cfif stInjuries[ij].INJURY GT 0> <!--- injury id --->
				<cfset ctValues = ctValues + 1> 
			</cfif> 			<!--- <BR>[#trim(stInjuries[ij].INJURY)#][#len(trim(stInjuries[ij].INJURY))#]-- --->
			<cfif len(trim(stInjuries[ij].INJURYPASSNO)) GT 0> 
				<cfset ctValues = ctValues + 1> 
			</cfif>				<!--- [#trim(stInjuries[ij].INJURYPASSNO)#][#len(trim(stInjuries[ij].INJURYPASSNO))#]-- --->
			<cfif len(trim(stInjuries[ij].INJURYPLAYERNAME)) GT 0> 
				<cfset ctValues = ctValues + 1> 
			</cfif>				<!--- [#trim(stInjuries[ij].INJURYPLAYERNAME)#][#len(trim(stInjuries[ij].INJURYPLAYERNAME))#]-- --->
			<cfif stInjuries[ij].INJURYTEAM GT 0> <!--- team id --->
				<cfset ctValues = ctValues + 1> 
			</cfif>		    	<!--- [#trim(stInjuries[ij].INJURYTEAM)#][#len(trim(stInjuries[ij].INJURYTEAM))#]-- --->
			<!--- =[#ctValues#] --->
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
			</cfif>  				<!--- <BR>[#trim(stMisconducts[im].MISCONDUCT)#][#len(trim(stMisconducts[im].MISCONDUCT))#]-- --->
			<cfif len(trim(stMisconducts[im].MISCONPASSNO)) GT 0> 
				<cfset ctValues = ctValues + 1> 
			</cfif>			 		<!--- [#trim(stMisconducts[im].MISCONPASSNO)#][#len(trim(stMisconducts[im].MISCONPASSNO))#]-- --->
			<cfif len(trim(stMisconducts[im].MISCONPLAYERNAME)) GT 0> 
				<cfset ctValues = ctValues + 1> 
			</cfif>		 			<!--- [#trim(stMisconducts[im].MISCONPLAYERNAME)#][#len(trim(stMisconducts[im].MISCONPLAYERNAME))#]-- --->
			<cfif stMisconducts[im].MISCONTEAM GT 0> <!--- team id --->
				<cfset ctValues = ctValues + 1> 
			</cfif> 				<!--- [#trim(stMisconducts[im].MISCONTEAM)#][#len(trim(stMisconducts[im].MISCONTEAM))#]-- --->
			<cfif ctValues GT 0 AND ctValues LT 4>
				<cfset ctErrors = ctErrors + 1>
				<cfset MSG = MSG & "Information may be missing from one or more of the MISCONDUCT entries.<br>">
				<cfbreak>
			</cfif>		
			<!--- =[#ctValues#] --->
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
			<cfset homeCount = listLast(form.homeTeamPlayUpCnt)>
		
		<!--- Misconduct data was entered were all 4 fields entered? --->
		<!--- <cfloop collection="#stPlayUpsHome#" item="ihpu"> --->
		<cfloop index="ihpu" from="1" to="#homeCount#">
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
			<cfset visitorCount = listLast(form.visitorTeamPlayUpCnt)>
		<!--- <cfloop collection="#stPlayUpsVisitor#" item="ivpu"> --->
		<cfloop index="ivpu" from="1" to="#visitorCount#">
			<cfset ctValues = 0>
			<cfif stPlayUpsVisitor[ivpu].PLAYUPFROMVISITOR GTE 0> <!--- play up from team id --->
				<cfset ctValues = ctValues + 1> 
			</cfif>  				
			<cfif len(trim(stPlayUpsVisitor[ivpu].PLAYUPPASSNOVISITOR)) GT 0> 
				<cfset ctValues = ctValues + 1> 
			</cfif>			 		
			<cfif len(trim(stPlayUpsVisitor[ivpu].PLAYUPPLAYERNAMEVISITOR)) GT 0> 
				<cfset ctValues = ctValues + 1> 
			</cfif>		 			
			<cfif stPlayUpsVisitor[ivpu].PLAYUPWITHVISITOR GT 0> <!--- team id --->
				<cfset ctValues = ctValues + 1> 
			</cfif> 				
			<cfif stPlayUpsVisitor[ivpu].PLAYUPFROMVISITOR EQ 0>

				<cfif len(trim(stPlayUpsVisitor[ivpu].PLAYUPFROMOTHERVISITOR)) GT 0> 
					<cfset ctValues = ctValues + 1> 
				</cfif> 

				<cfif ctValues NEQ 5 AND recCount LTE visitorCount>
					<cfset ctErrors = ctErrors + 1>
					<cfset MSG = MSG & "Information may be missing from one or more of the Play Up Visitor entries.<br>">
					<cfbreak>
				</cfif>
			<cfelse>

				<cfif ctValues NEQ 4 AND recCount LTE visitorCount>
					<cfset ctErrors = ctErrors + 1>
					<cfset MSG = MSG & "Information may be missing from one or more of the Play Up Visitor entries.<br>">
					<cfbreak>
				</cfif>
			</cfif>
			<cfset recCount = recCount + 1>
		</cfloop>
		</cfif>
	</cfif>

	<!--- ------------------------------------------------------------------------------------------------------- --->
		<!--- look for HomeNoParticipate values that were entered --->
	<cfloop list="#FORM.FIELDNAMES#" index="iHnp">
		<cfif UCASE(listFirst(ihnp,"_")) EQ "NOPARTICIPATEFROMHOME">
			<cfset stNoParticipatesHome[listLast(ihnp,"_")].NoParticipateFROMHOME 		 = evaluate(iHnp) >
		</cfif>
		<cfif UCASE(listFirst(ihnp,"_")) EQ "NOPARTICIPATETYPEHOME">
			<cfset stNoParticipatesHome[listLast(ihnp,"_")].NoParticipateTypeHome 	 = evaluate(iHnp) >
		</cfif>
		<cfif UCASE(listFirst(ihnp,"_")) EQ "NOPARTICIPATEPLAYERNAMEHOME">
			<cfset stNoParticipatesHome[listLast(ihnp,"_")].NoParticipatePLAYERNAMEHOME = evaluate(iHnp) >
		</cfif>
		<cfif UCASE(listFirst(ihnp,"_")) EQ "NOPARTICIPATEWITHHOME">
			<cfset stNoParticipatesHome[listLast(ihnp,"_")].NoParticipateWITHHOME		 = evaluate(iHnp) >
		</cfif>
		<cfif UCASE(listFirst(ihnp,"_")) EQ "NOPARTICIPATEFROMOTHERHOME">
			<cfset stNoParticipatesHome[listLast(ihnp,"_")].NoParticipateFROMOTHERHOME		 = evaluate(iHnp) >
		</cfif>
	</cfloop> 

	<cfif NOT structIsEmpty(stNoParticipatesHome)>
		<cfset homeCount = 1>
		<cfset recCount = 1>
		<cfif form.homeNoParticipateCnt NEQ 0>
			<cfset homeCount = listLast(form.homeNoParticipateCnt)>
		
		<!--- Misconduct data was entered were all 4 fields entered? --->
		<!--- <cfloop collection="#stNoParticipatesHome#" item="ihnp"> --->
		<cfloop index="ihnp" from="1" to="#homeCount#">
			<cfset ctValues = 0>
			<cfif stNoParticipatesHome[ihnp].NoParticipateFROMHOME GTE 0> <!--- play up from --->
				<cfset ctValues = ctValues + 1> 
			</cfif>  				
			<cfif stNoParticipatesHome[ihnp].NoParticipateTypeHome eq "Coach" or stNoParticipatesHome[ihnp].NoParticipateTypeHome eq "Player" > 
				<cfset ctValues = ctValues + 1> 
			<cfelseif len(trim(stNoParticipatesHome[ihnp].NoParticipatePLAYERNAMEHOME)) and not len(trim(stNoParticipatesHome[ihnp].NoParticipateTypeHome))>
				<cfset ctErrors = ctErrors + 1>
				<cfset MSG = MSG & "Please designate the Home Participant type.<br>">
				<cfbreak>
			</cfif>			 		
			<cfif len(trim(stNoParticipatesHome[ihnp].NoParticipatePLAYERNAMEHOME)) GT 0> 
				<cfset ctValues = ctValues + 1> 
			</cfif>		 			
			<cfif stNoParticipatesHome[ihnp].NoParticipateWITHHOME GT 0> <!--- team id --->
				<cfset ctValues = ctValues + 1> 
			</cfif>
			<cfset recCount = recCount + 1>
		</cfloop>
		</cfif>
	</cfif>

	<!--- look for VisitorNoParticipate values that were entered --->
	<cfloop list="#FORM.FIELDNAMES#" index="iVnp">
		<cfif UCASE(listFirst(ivnp,"_")) EQ "NOPARTICIPATEFROMVISITOR">
			<cfset stNoParticipatesVisitor[listLast(ivnp,"_")].NoParticipateFROMVISITOR 		 = evaluate(iVnp) >
		</cfif>
		<cfif UCASE(listFirst(ivnp,"_")) EQ "NOPARTICIPATETYPEVISITOR">
			<cfset stNoParticipatesVisitor[listLast(ivnp,"_")].NoParticipateTypeVisitor 	 = evaluate(iVnp) >
		</cfif>
		<cfif UCASE(listFirst(ivnp,"_")) EQ "NOPARTICIPATEPLAYERNAMEVISITOR">
			<cfset stNoParticipatesVisitor[listLast(ivnp,"_")].NoParticipatePLAYERNAMEVISITOR = evaluate(iVnp) >
		</cfif>
		<cfif UCASE(listFirst(ivnp,"_")) EQ "NOPARTICIPATEWITHVISITOR">
			<cfset stNoParticipatesVisitor[listLast(ivnp,"_")].NoParticipateWITHVISITOR		 = evaluate(iVnp) >
		</cfif>
		<cfif UCASE(listFirst(ivnp,"_")) EQ "NOPARTICIPATEFROMOTHERVISITOR">
			<cfset stNoParticipatesVisitor[listLast(ivnp,"_")].NoParticipateFROMOTHERVISITOR		 = evaluate(iVnp) >
		</cfif>
	</cfloop> 

	<cfif NOT structIsEmpty(stNoParticipatesVisitor)>
		<cfset visitorCount = 1>
		<cfset recCount = 1>
		<cfif form.visitorNoParticipateCnt NEQ 0>
			<cfset visitorCount = listLast(form.visitorNoParticipateCnt)>
		
		<!--- <cfloop collection="#stNoParticipatesVisitor#" item="ivnp"> --->
		<cfloop index="ivnp" from="1" to="#visitorCount#">
			<cfset ctValues = 0>
			<cfif stNoParticipatesVisitor[ivnp].NoParticipateFROMVISITOR GTE 0> <!--- play up from team id --->
				<cfset ctValues = ctValues + 1> 
			</cfif>  				 		

			<cfif  stNoParticipatesVisitor[ivnp].NoParticipateTypeVisitor eq "Coach" or stNoParticipatesVisitor[ivnp].NoParticipateTypeVisitor eq "Player" > 
				<cfset ctValues = ctValues + 1> 
			<cfelseif len(trim(stNoParticipatesVisitor[ivnp].NoParticipatePLAYERNAMEVisitor)) and not len(trim(stNoParticipatesVisitor[ivnp].NoParticipateTypeVisitor))>
				<cfset ctErrors = ctErrors + 1>
				<cfset MSG = MSG & "Please designate the Visitor Participant type.<br>">
				<cfbreak>
			</cfif>	
			<cfif len(trim(stNoParticipatesVisitor[ivnp].NoParticipatePLAYERNAMEVISITOR)) GT 0> 
				<cfset ctValues = ctValues + 1> 
			</cfif>		 			
			<cfif stNoParticipatesVisitor[ivnp].NoParticipateWITHVISITOR GT 0> <!--- team id --->
				<cfset ctValues = ctValues + 1> 
			</cfif> 				
			<cfset recCount = recCount + 1>
		</cfloop>
		</cfif>
	</cfif>

	<!--- Check if Report already submitted for this game --->
	<cfquery name="checkGameID" datasource="#Application.DSN#">
		select game_id
		from   tbl_referee_RPT_header
		where  game_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#gameID#">
	</cfquery>
	<cfif checkGameID.recordCount GT 0>
		<cfset reportExists = true>
	<cfelse>
		<cfset reportExists = false>
	</cfif>
	
	<!--- Passed validation, insert or update report... --->
	<cfif ctErrors EQ 0>
		<cfif reportExists EQ true>
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#REPORT" method="UpdateRefReport" returnvariable="updateReportValue">
				<cfinvokeargument name="formFields" value="#FORM#" >
				<cfinvokeargument name="contactID"  value="#SESSION.USER.CONTACTid#" >
				<cfinvokeargument name="stMisConducts"  value="#stMisconducts#" >
				<cfinvokeargument name="stInjuries" 	value="#stInjuries#" >
				<cfinvokeargument name="stPlayUpsHome" 	value="#stPlayUpsHome#" >
				<cfinvokeargument name="stPlayUpsVisitor" 	value="#stPlayUpsVisitor#" >
				<cfinvokeargument name="homeNoParticipateCnt" value="#homeNoParticipateCnt#">
				<cfinvokeargument name="visitorNoParticipateCnt" value="#visitorNoParticipateCnt#">
				<cfinvokeargument name="stNoParticipatesHome" 	value="#stNoParticipatesHome#" >
				<cfinvokeargument name="stNoParticipatesVisitor" 	value="#stNoParticipatesVisitor#" >
			</cfinvoke>

			<cfif len(trim(updateReportValue)) AND isNumeric(updateReportValue) AND updateReportValue GT 0>
				<cfset MSG = "This report was updated successfully.">
				<cflocation url="GameRefReportList.cfm?pg=#gameID#">
			<CFELSE>
				<cfset MSG = updateReportValue>
			</cfif> 
		<cfelse>
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#REPORT" method="AddRefReport" returnvariable="addReportValue">
				<cfinvokeargument name="formFields" value="#FORM#" >
				<cfinvokeargument name="contactID"  value="#SESSION.USER.CONTACTid#" >
				<cfinvokeargument name="stMisConducts"  value="#stMisconducts#" >
				<cfinvokeargument name="stInjuries" 	value="#stInjuries#" >
				<cfinvokeargument name="stPlayUpsHome" 	value="#stPlayUpsHome#" >
				<cfinvokeargument name="stPlayUpsVisitor" 	value="#stPlayUpsVisitor#" >
				<cfinvokeargument name="homeNoParticipateCnt" value="#homeNoParticipateCnt#">
				<cfinvokeargument name="visitorNoParticipateCnt" value="#visitorNoParticipateCnt#">
				<cfinvokeargument name="stNoParticipatesHome" 	value="#stNoParticipatesHome#" >
				<cfinvokeargument name="stNoParticipatesVisitor" 	value="#stNoParticipatesVisitor#" >
			</cfinvoke>

			<cfif len(trim(addReportValue)) AND isNumeric(addReportValue) AND addReportValue GT 0>
				<cfset MSG = "This report was submitted successfully.">
				<!--- <cflocation url="gameRefReportPrint.cfm?gid=#gameID#"> --->
				<cflocation url="GameRefReportList.cfm?pg=#gameID#">
			<CFELSE>
				<cfset MSG = addReportValue>
			</cfif> 
		</cfif><!--- Report exists? --->
	</cfif><!--- ctErrors --->
</CFIF>


<cfinvoke component="#SESSION.SITEVARS.cfcPath#REPORT" method="getRefRPTHeader" returnvariable="qRefRptHeader">
	<cfinvokeargument name="gameID" value="#VARIABLES.gameID#" >
</cfinvoke>  <!--- <cfdump var="#qRefRptHeader#"> --->

<cfif qRefRptHeader.RECORDCOUNT>
	<cfset Mode		= "EDIT">
	<cfset pageTitle	= "Edit Game Report" >
	<cfset btnVal		= "Update" >
	<cfset PrintBtnSts = "" >

	<cfset refRptHeaderID	= qRefRptHeader.referee_rpt_header_ID >
	<cfset GameSts			= qRefRptHeader.GameSts >
	<cfset scoreHomeHT		= qRefRptHeader.HalfTimeScore_Home >
	<cfset scoreVisitorHT	= qRefRptHeader.HalfTimeScore_Visitor >
	<cfset scoreHomeFT		= qRefRptHeader.FullTimeScore_Home >
	<cfset scoreVisitorFT	= qRefRptHeader.FullTimeScore_Visitor >
	<cfset OnTimeHome		= qRefRptHeader.IsOnTime_Home >
	<cfset OnTimeVisitor	= qRefRptHeader.IsOnTime_Visitor >
	<cfset HTHowLate		= qRefRptHeader.HowLate_Home >
	<cfset VTHowLate		= qRefRptHeader.HowLate_Visitor >
	<cfset LineUpHome		= qRefRptHeader.LineUP_Home >
	<cfset LineUpVisitor	= qRefRptHeader.LineUP_Visitor >
	<cfset PassesHome		= qRefRptHeader.Passes_Home >
	<cfset PassesVisitor	= qRefRptHeader.Passes_Visitor >
	<cfset Weather			= qRefRptHeader.weather >
	<cfset FieldCondition	= qRefRptHeader.fieldCond >
	<cfset FieldMarking		= qRefRptHeader.fieldMarking >
	<cfset SpectatorCount	= qRefRptHeader.spectatorCount >
	<cfset Comments			= qRefRptHeader.Comments >
	<cfset ConductOfficial	= qRefRptHeader.conductOfficials >
	<cfset ConductPlayers	= qRefRptHeader.conductPlayers >
	<cfset ConductSpectators = qRefRptHeader.conductSpectators >
	<cfset xrefGameOfficialID = qRefRptHeader.xref_game_official_id >
	<cfset RefPaid			= qRefRptHeader.refPaid_YN >
	<cfset RefAmount		= qRefRptHeader.refPaid_Amount >
	<cfset RefId			= qRefRptHeader.REFEREEID >
	<cfset AsstRefId1		= qRefRptHeader.contact_id_asstRef1 >
	<cfset AsstRefId2		= qRefRptHeader.contact_id_asstRef2 >
	<cfset AsstRef1			= qRefRptHeader.ASSISTANTREF1_WRITEIN >
	<cfset AsstRef2			= qRefRptHeader.ASSISTANTREF2_WRITEIN >
	<cfset Official4th		= qRefRptHeader.contact_id_official4th >
	<cfset Official4thLog	= qRefRptHeader.Official4thLog >
	<cfset RefereeDRoom		= qRefRptHeader.refereeDroom >
	<cfset PlayerDRoom		= qRefRptHeader.playerDroom >
	<cfset homeTeamPlayUps  = qRefRptHeader.homeTeamPlayUps>
	<cfset visitorTeamPlayUps  = qRefRptHeader.visitorTeamPlayUps>
	<cfset homeTeamPlayUpCnt  = qRefRptHeader.homeTeamPlayUpCnt>
	<cfset visitorTeamPlayUpCnt  = qRefRptHeader.visitorTeamPlayUpCnt>
	<!--- AssistantRef1_WriteIn, AssistantRef2_WriteIn  --->

	<cfset rptStartTime		= timeFormat(qRefRptHeader.STARTTIME,"hh:mm tt")>
	<cfset rptStartHour		= listFirst(VARIABLES.rptStartTime,":")>
	<cfset rptStartMinute	= Minute(VARIABLES.rptStartTime)>
	<cfset rptStartMeridian	= listLast(VARIABLES.rptStartTime," ")>

	<cfset rptEndTime		= timeFormat(qRefRptHeader.ENDTIME,"hh:mm tt")>
	<cfset rptEndHour		= listFirst(VARIABLES.rptEndTime,":")>
	<cfset rptEndMinute		= Minute(VARIABLES.rptEndTime)>
	<cfset rptEndMeridian	= listLast(VARIABLES.rptEndTime," ")>
		
	
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#REPORT" method="getRefRPTDetails" returnvariable="qRefRptDetails">
		<cfinvokeargument name="refRptHeaderID" value="#VARIABLES.refRptHeaderID#" >
	</cfinvoke><!--- <cfdump var="#qRefRptDetails#"> --->

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

	<cfquery name="qPlayUps" dbtype="query">
		select PlayerName, EventType, PassNo, TeamID, MisConduct_ID, PlayUpFromOther
		from qRefRptDetails
		Where EventType = 3
	</cfquery>
	<cfquery name="qNoParticipate" dbtype="query">
		select PlayerName, EventType, TeamID, MisConduct_ID, participantType
		from qRefRptDetails
		Where EventType = 4
	</cfquery>
	
<cfelse>
	<cfset Mode		= "ADD" >
	<cfset RefereeID	= "" >
	<cfset btnVal		= "Submit" >
	<cfset pageTitle	= "Submit Game Report" >
	<cfset DisplayOnly  = "" >
	<cfset Official4th = "none" >

	<cfset xrefGameOfficialID = 0 >
	<cfset RefID			= 0 >
	<cfset RefId			= 0 >
	<cfset AsstRefId1		= 0 >
	<cfset AsstRefId2		= 0 >
	<cfset Official4th		= "" >
	<cfset Official4thLog	= "" >
	<cfset RefereeDRoom		= "" >
	<cfset PlayerDRoom		= "" >

	<cfset StartTime		= "" >
	<cfset HTHowLate		= 0 >
	<cfset VTHowLate		= 0 >
	<cfset GameSts			= "" >
	<cfset scoreHomeHT		= "" >
	<cfset scoreVisitorHT	= "" >
	<cfset scoreHomeFT		= "" >
	<cfset scoreVisitorFT	= "" >
	<cfset OnTimeHome		= "" >
	<cfset OnTimeVisitor	= "" >
	<cfset HTHowLate		= "" >
	<cfset VTHowLate		= "" >
	<cfset LineUpHome		= "" >
	<cfset LineUpVisitor	= "" >
	<cfset PassesHome		= "" >
	<cfset PassesVisitor	= "" >
	<cfset Weather			= "" >
	<cfset FieldCondition	= "" >
	<cfset FieldMarking		= "" >
	<cfset SpectatorCount	= "" >
	<cfset Comments			= "" >
	<cfset ConductOfficial	= "" >
	<cfset ConductPlayers	= "" >
	<cfset ConductSpectators = "" >
	<cfset RefPaid			= "" >
	<cfset RefAmount		= "" >
	<cfset AsstRef1			= "" >
	<cfset AsstRef2			= "" >
	<cfset startTime		= "">
	<cfset StartHour		= "">
	<cfset StartMinute		= "">
	<cfset StartMeridian	= "">
	<cfset endTime			= "">
	<cfset endHour			= "">
	<cfset endMinute		= "">
	<cfset endMeridian		= "">
	<cfset homeTeamPlayUps  = "">
	<cfset visitorTeamPlayUps  = "">
	<cfset homeTeamPlayUpCnt  = "0">
	<cfset visitorTeamPlayUpCnt  = "0">
</cfif>

<CFIF xrefGameOfficialID EQ 0 >
	<cfquery name="qGetOfficialID" datasource="#SESSION.DSN#">
		Select xref_game_official_id 
		  from xref_Game_official
		 Where Game_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.gameID#">
		   AND game_official_type_id = 1
	</cfquery> <!--- <cfdump var="#qMisconducts#"> --->
	<cfset xrefGameOfficialID = qGetOfficialID.xref_game_official_id >
</CFIF>

<cfquery name="qMisconducts" datasource="#SESSION.DSN#">
	SELECT Misconduct_ID, Misconduct_DESCR, Misconduct_EVENT
	  FROM TLKP_Misconduct
	 ORDER BY MisConduct_Descr
</cfquery> <!--- <cfdump var="#qMisconducts#"> --->

<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="getGameSchedule" returnvariable="qGameInfo">
	<cfinvokeargument name="gameID"		value="#VARIABLES.GameID#">
</cfinvoke> <!--- <cfdump var="#qGameInfo#"> --->

<cfif qGameInfo.RECORDCOUNT>
	<cfset GameDate		= dateFormat(qGameInfo.game_date,"mm/dd/yyyy") >
	<cfset GameTime		= timeFormat(qGameInfo.game_time,"hh:mm tt") >
	<cfset HomeScore	= qGameInfo.Score_Home >
	<cfset VisitorScore	= qGameInfo.Score_visitor >
	<cfset HomeTeam		= qGameInfo.Home_TeamName >
	<cfset VisitorTeam	= qGameInfo.Visitor_TeamName >
	<cfset HomeTeamID	= qGameInfo.Home_Team_ID >
	<cfset VisitorTeamID = qGameInfo.Visitor_Team_ID >
	<cfset PlayField	 = qGameInfo.fieldAbbr >
	<cfset Division		 = qGameInfo.Division >
	<cfset RefID		 = qGameInfo.RefID >
	<cfset AsstRefID1	 = qGameInfo.AsstRefID1 >
	<cfset AsstRefID2	 = qGameInfo.AsstRefID2 >

	<cfset GameStartTime		= timeFormat(qGameInfo.Game_Time,"hh:mm tt") >
	<cfset GameStartHour		= listFirst(VARIABLES.GameStartTime,":")>
	<cfset GameStartMinute		= Minute(VARIABLES.GameStartTime)>
	<cfset GameStartMeridian	= listLast(VARIABLES.GameStartTime," ")>

	<cfset GameEndTime		 	= DateAdd("n", 90, qGameInfo.Game_Time)>
	<cfset GameEndTime		 	= timeFormat(variables.GameEndTime,"hh:mm tt") >
	<cfset GameEndHour			= listFirst(VARIABLES.GameEndTime,":")>
	<cfset GameEndMinute		= Minute(VARIABLES.GameEndTime)>
	<cfset GameEndMeridian		= listLast(VARIABLES.GameEndTime," ")>

<cfelse>
	<cfset GameDate		= "" >
	<cfset GameTime		= "" >
	<cfset HomeScore	= "" >
	<cfset VisitorScore	= "" >
	<cfset HomeTeam		= "" >
	<cfset VisitorTeam	= "" >
	<cfset HomeTeamID	= 0 >
	<cfset VisitorTeamID = 0 >
	<cfset PlayField	 = "" >
	<cfset Division		 = "" >
	<cfset RefID		 = 0 >
	<cfset AsstRefID1	 = 0 >
	<cfset AsstRefID2	 = 0 >
	<cfset GameStartTime	 = "" >
	<cfset GameEndTime		 = "" >
	<cfset GameStartHour	 = "" >
	<cfset GameStartMinute	 = "" >
	<cfset GameStartMeridian = "" >
	<cfset GameEndHour		 = "" >
	<cfset GameEndMinute	 = "" >
	<cfset GameEndMeridian	 = "" >
</cfif>
<!--- J.Danz 9-3-2014 NCSA15511 - get Play Up Teams with the next 3 queries. --->
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
  <!--- <cfquery datasource="#application.dsn#" name="getPlayUpTeams">
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
  </cfquery> --->
	<cfquery datasource="#application.dsn#" name="getPlayUpTeams">
	
		select team_id, club_id,dbo.getteamname(team_id) as teamname --, null as others_seq
		from tbl_team t
		where 
		club_id in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#HomeTeamClubID#">,<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#VisitorTeamClubID#">)
   			AND  playLevel not in('R','J','X')
			AND season_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#getGame.season_id#">
			AND team_id not in(#homeTeamID#,#visitorTeamID#) 
	</cfquery>

  <cfquery datasource="#application.dsn#" name="getNoParticipateTeams">
    select team_id, club_id, dbo.getteamname(team_id) as teamname
    from tbl_team
    where exists(select 1 from tbl_referee_rpt_header where (homeNoParticipateCnt > 0 or visitorNoParticipateCnt > 0) and team_id = tbl_team.team_id and game_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VARIABLES.GameID#">)
    AND season_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.currentseason.id#">

    order by teamname
  </cfquery>
<!--- J.Danz 8-26-2014 NCSA15511 - added the below to preponplate forms given table data. --->
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
<cfif isDefined("qNoParticipate")>
	<cfset homec = 1>
	<cfset visitc =1>
	<cfloop query="qNoParticipate">
		<cfif teamid eq homeTeamID>
			<cfset stNoParticipatesHome[homec].NoParticipateFROMHOME = misconduct_ID>
			<cfset stNoParticipatesHome[homec].NoParticipatePLAYERNAMEHOME = PlayerName>
			<cfset stNoParticipatesHome[homec].participantType = participantType>
			<cfset stNoParticipatesHome[homec].NoParticipateWITHHOME = teamid>
			<cfset homec = homec + 1>
		</cfif>
		<cfif teamid eq visitorTeamID>
			<cfset stNoParticipatesVisitor[visitc].NoParticipateFROMVISITOR = misconduct_ID>
			<cfset stNoParticipatesVisitor[visitc].NoParticipatePLAYERNAMEVISITOR = PlayerName>
			<cfset stNoParticipatesVisitor[visitc].participantType = participantType>
			<cfset stNoParticipatesVisitor[visitc].NoParticipateWITHVISITOR = teamid>
			<cfset visitc = visitc + 1>
		</cfif>
	</cfloop>
</cfif>


<!--- set form vars to previously entered values if form fails validation --->
<cfif isDefined("FORM.StartTime")>			<cfset StartTime = FORM.StartTime>		</cfif>
<cfif isDefined("FORM.HTHowLate")>			<cfset HTHowLate = FORM.HTHowLate>		</cfif>
<cfif isDefined("FORM.VTHowLate")>			<cfset VTHowLate = FORM.VTHowLate>		</cfif>
<cfif isDefined("FORM.GAMESTATUS")>			<cfset GameSts = FORM.GAMESTATUS>			</cfif>
<cfif isDefined("FORM.scoreHomeHT")>		<cfset scoreHomeHT = FORM.scoreHomeHT>	</cfif>
<cfif isDefined("FORM.scoreVisitorHT")>		<cfset scoreVisitorHT = FORM.scoreVisitorHT></cfif>
<cfif isDefined("FORM.scoreHomeFT")>		<cfset scoreHomeFT = FORM.scoreHomeFT>	</cfif>
<cfif isDefined("FORM.scoreVisitorFT")>		<cfset scoreVisitorFT = FORM.scoreVisitorFT></cfif>
<cfif isDefined("FORM.OnTimeHome")>			<cfset OnTimeHome = FORM.OnTimeHome>	</cfif>
<cfif isDefined("FORM.OnTimeVisitor")>		<cfset OnTimeVisitor = FORM.OnTimeVisitor>	</cfif>
<cfif isDefined("FORM.HTHowLate")>			<cfset HTHowLate = FORM.HTHowLate>		</cfif>
<cfif isDefined("FORM.VTHowLate")>			<cfset VTHowLate = FORM.VTHowLate>		</cfif>
<cfif isDefined("FORM.LineUpHome")>			<cfset LineUpHome = FORM.LineUpHome>	</cfif>
<cfif isDefined("FORM.LineUpVisitor")>		<cfset LineUpVisitor = FORM.LineUpVisitor>	</cfif>
<cfif isDefined("FORM.PassesHome")>			<cfset PassesHome = FORM.PassesHome>	</cfif>
<cfif isDefined("FORM.PassesVisitor")>		<cfset PassesVisitor = FORM.PassesVisitor>	</cfif>
<cfif isDefined("FORM.Weather")>			<cfset Weather = FORM.Weather>			</cfif>
<cfif isDefined("FORM.FieldCondition")>		<cfset FieldCondition = FORM.FieldCondition></cfif>
<cfif isDefined("FORM.FieldMarking")>		<cfset FieldMarking = FORM.FieldMarking></cfif>
<cfif isDefined("FORM.SpectatorCount")>		<cfset SpectatorCount = FORM.SpectatorCount></cfif>
<cfif isDefined("FORM.Comments")>			<cfset Comments = FORM.Comments>		</cfif>
<cfif isDefined("FORM.ConductOfficial")>	<cfset ConductOfficial = FORM.ConductOfficial>	</cfif>
<cfif isDefined("FORM.ConductPlayers")>		<cfset ConductPlayers = FORM.ConductPlayers>	</cfif>
<cfif isDefined("FORM.ConductSpectators")>	<cfset ConductSpectators = FORM.ConductSpectators></cfif>
<cfif isDefined("FORM.RefPaid")>			<cfset RefPaid = FORM.RefPaid>			</cfif>
<cfif isDefined("FORM.RefAmount")>			<cfset RefAmount = FORM.RefAmount>		</cfif>
<cfif isDefined("FORM.AsstRef1WriteIN")>	<cfset AsstRef1 = FORM.AsstRef1WriteIN>	</cfif>
<cfif isDefined("FORM.AsstRef2WriteIN")>	<cfset AsstRef2 = FORM.AsstRef2WriteIN>	</cfif>
<cfif isDefined("FORM.startTime")>			<cfset startTime = FORM.startTime>		</cfif>
<cfif isDefined("FORM.endTime")>			<cfset endTime = FORM.endTime>			</cfif>
<cfif isDefined("FORM.fieldSpecifics")>		<cfset FieldCondition = FORM.fieldSpecifics>		</cfif>
<cfif isDefined("FORM.homeTeamPlayUps")>		<cfset homeTeamPlayUps = FORM.homeTeamPlayUps>		</cfif>
<cfif isDefined("FORM.visitorTeamPlayUps")>		<cfset visitorTeamPlayUps = FORM.visitorTeamPlayUps>		</cfif>
<cfif isDefined("FORM.homeTeamPlayUpCnt")>		<cfset homeTeamPlayUpCnt = listLast(FORM.homeTeamPlayUpCnt)>		</cfif>
<cfif isDefined("FORM.visitorTeamPlayUpCnt")>		<cfset visitorTeamPlayUpCnt = listLast(FORM.visitorTeamPlayUpCnt)>		</cfif>
<cfif isDefined("FORM.homeTeamPlayUpCnt")>		<cfset homeNoParticipateCnt = listLast(FORM.homeNoParticipateCnt)>		</cfif>
<cfif isDefined("FORM.visitorTeamPlayUpCnt")>		<cfset visitorNoParticipateCnt = listLast(FORM.visitorNoParticipateCnt)>		</cfif>
<!--- 
<cfif isDefined("FORM.injury")>				<cfset injury = FORM.injury>				</cfif>
<cfif isDefined("FORM.injuryPassNO")>		<cfset injuryPassNO = FORM.injuryPassNO>	</cfif>
<cfif isDefined("FORM.injuryPlayerName")>	<cfset injuryPlayerName = FORM.injuryPlayerName>	</cfif>
<cfif isDefined("FORM.injuryTeam")>			<cfset injuryTeam = FORM.injuryTeam>		</cfif>
<cfif isDefined("FORM.misconduct")>			<cfset misconduct = FORM.misconduct>		</cfif>
<cfif isDefined("FORM.misconPassNO")>		<cfset misconPassNO = FORM.misconPassNO>	</cfif>
<cfif isDefined("FORM.misconPlayerName")>	<cfset misconPlayerName = FORM.misconPlayerName>	</cfif>
<cfif isDefined("FORM.misconTeam")>			<cfset misconTeam = FORM.misconTeam>		</cfif> 
--->




<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrGameStatus">
	<cfinvokeargument name="listType" value="GAMESTATUS"> 
</cfinvoke> 
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="stTimeParams">
	<cfinvokeargument name="listType" value="DDHHMMTT"> 
</cfinvoke> 
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrWeather">
	<cfinvokeargument name="listType" value="WEATHER"> 
</cfinvoke> 
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrRatings1">
	<cfinvokeargument name="listType" value="RATINGS1"> 
</cfinvoke> 
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrInjury">
	<cfinvokeargument name="listType" value="INJURY"> 
</cfinvoke> 
						
<FORM name="RefRpt" action="gameReportSubmit.cfm"  method="post" >
<input type="hidden" name="GameID"		value="#VARIABLES.gameID#"	>
<input type="hidden" name="GameDate"	value="#VARIABLES.GameDate#"	>
<input type="hidden" name="Mode"		value="#VARIABLES.Mode#"	>
<input type="hidden" name="xrefGameOfficialID"	value="#VARIABLES.xrefGameOfficialID#"	>
<input type="hidden" name="AsstRefId1"	value="#VARIABLES.AsstRefId1#"	>
<input type="hidden" name="AsstRefId2"	value="#VARIABLES.AsstRefId2#"	>

<!--- 
<input type="hidden" name="PageURL"		value="#PageURL#"	>
<input type="hidden" name="DivID"		value="#DivID#"		>
<input type="hidden" name="Weekend"		value="#Weekend#"	>
<input type="hidden" name="RefereeID"	value="#SelRefId#"	>
<input type="hidden" name="SortOrder"	value="#SortOrder#" >
<input type="hidden" name="SelBy"		value="#SelBy#" 	>
<input type="hidden" name="ClubID"		value="#SelClubID#" >
<input type="hidden" name="RefID"		value="#SelRefID#" >
<input type="hidden" name="ListType"	value="#ListType#" >
<input type="hidden" name="SelDivision"	value="#SelDivision#" >
<input type="hidden" name="SelWeekend"	value="#SelWeekend#" >
 --->



<CFIF len(trim(MSG))>
	<span class="red">#MSG#</span>
</CFIF>



<span class="red">
	Fields marked with * are required 
	<br>- <b>Scroll to bottom of form to submit.</b>
</span>
<CFSET required = "<FONT color=red>*</FONT>">
<table cellspacing="0" cellpadding="5" align="center" border="0"> 
	<tr class="tblHeading">
		<TD>&nbsp;</td>
	</tr>
	<tr><TD><b>Game:</b> 		#(GameID)#					#repeatString("&nbsp;",10)#
			<b>Date/Time:</b>   #GameDate# - #GameTime#		#repeatString("&nbsp;",10)#
 			<b>Field:</b> 		#(PlayField)#
		</td>
	</tr>
	<tr><td><b>Division:</b> #Division#	 								#repeatString("&nbsp;",10)#
			<b>Home:</b> 	 #HomeTeam# vs. <b>Visitor:</b> #VisitorTeam#	#repeatString("&nbsp;",10)#
			<b>Score:</b> (H) #HomeScore# - (V) #VisitorScore#
		</TD>
	</TR>
	<TR><TD><b>Referee:</B>
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo">
				<cfinvokeargument name="refereeID" value="#VARIABLES.refID#">
			</cfinvoke>
			<CFIF qRefInfo.RECORDCOUNT>
				#qRefInfo.LastName#, #qRefInfo.FirstName# &nbsp;&nbsp; <b>Grade:</b> #qRefInfo.Grade#
			</CFIF>
			#repeatString("&nbsp;",10)#

			<b>Asst Ref 1:</b>
			<cfif len(trim(AsstRefId1)) EQ 0 OR AsstRefId1 EQ 0>
				<input type="text" name="AsstRef1WriteIn" value="#AsstRef1#" maxlength="100" >
			<cfelse>
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo1">
					<cfinvokeargument name="refereeID" value="#VARIABLES.AsstRefId1#">
				</cfinvoke>
				<CFIF qRefInfo1.RECORDCOUNT>
					#qRefInfo1.LastName#, #qRefInfo1.FirstName# &nbsp;&nbsp; <b>Grade:</b> #qRefInfo1.Grade#
				</CFIF>
			</cfif>	
			#repeatString("&nbsp;",10)#

			<b>Asst Ref 2:</b> 
			<cfif len(trim(AsstRefId2)) eq 0 OR AsstRefId2 EQ 0>
				<input type="text" name="AsstRef2WriteIN" value="#AsstRef2#" maxlength="100" >
			<cfelse>
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo2">
					<cfinvokeargument name="refereeID" value="#VARIABLES.AsstRefId2#">
				</cfinvoke>
				<CFIF qRefInfo2.RECORDCOUNT>
					#qRefInfo2.LastName#, #qRefInfo2.FirstName# &nbsp;&nbsp; <b>Grade:</b> #qRefInfo2.Grade#
				</CFIF>
			</cfif>	
		</TD>
	</TR>
</table><!--- end top table --->
<!--- <div style="overflow:auto; height:500px; border:1px ##cccccc solid;"> --->
<table cellspacing="2" cellpadding="5" align="left" border="0" style="table-layout:fixed;width:100%;">
	<TR><TD>
			<b>Game Played/cancelled?</b>
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

	</TR>
	<TR><TD><cfif qRefRptHeader.RECORDCOUNT>
				<!--- report was submitted, use report's time --->
				<cfset StartHour	 = rptStartHour>
				<cfset StartMinute	 = rptStartMinute>
				<cfset StartMeridian = rptStartMeridian>
				<cfset EndHour		 = rptEndHour>
				<cfset EndMinute	 = rptEndMinute>
				<cfset EndMeridian	 = rptEndMeridian>
			<cfelseif isDefined("FORM") and StructCount(FORM) >
				<!--- form was submitted, use those values --->
				<cfset StartHour	 = FORM.StartHour>
				<cfset StartMinute	 = FORM.StartMinute>
				<cfset StartMeridian = FORM.StartMeridian>
				<cfset endHour		 = FORM.endHour>
				<cfset endMinute	 = FORM.endMinute>
				<cfset endMeridian	 = FORM.endMeridian>
			<cfelse>
				<!--- use Game start time plus 90 min til end --->
				<cfset StartHour	 = gameStartHour>
				<cfset StartMinute	 = gameStartMinute>
				<cfset StartMeridian = gameStartMeridian>
				<cfset EndHour		 = gameEndHour>
				<cfset EndMinute	 = gameEndMinute>
				<cfset EndMeridian	 = gameEndMeridian>
			</cfif>
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
	<TR><td>
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
			<table border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout:fixed;">
				<tr>
					<td width="50%" valign="top">
						#REQUIRED#<b>Did Home Team have Play Ups?</b>
						Yes <input type="radio" value="1" name="homeTeamPlayUps" data-value="1" <cfif homeTeamPlayUps EQ "1">checked="checked"</cfif>> 
						No<input type="radio" value="0" name="homeTeamPlayUps" data-value="0" <cfif homeTeamPlayUps EQ "0">checked="checked"</cfif>>
						<div class="playUpCnt">
							<select name="homeTeamPlayUpCnt">
								<cfloop from="0" to="18" index="i">
									<option value="#i#" <cfif homeTeamPlayUpCnt EQ i>selected="selected"</cfif>>#i#</option>
								</cfloop>
							</select>
							#REQUIRED#<b>Use dropdown to indicate how many</b>
							<!--- <div class="homeTeamPlayUpCntLabel" style="font-size:1.2em; font-weight:bold; margin-bottom:5px;">#homeTeamPlayUpCnt#</div> --->
							<div class="homeTeamPlayUpCnt" style="width:50%;margin:5% 0;"></div>
						</div>
					</td>


					
					<td width="50%" valign="top">
						#REQUIRED#<b>Did Visitor Team have Play Ups?</b>
						Yes<input type="radio" value="1" name="visitorTeamPlayUps" data-value="1" <cfif visitorTeamPlayUps EQ "1">checked="checked"</cfif>> 
						No<input type="radio" value="0" name="visitorTeamPlayUps" data-value="0" <cfif visitorTeamPlayUps EQ "0">checked="checked"</cfif>>
						<div class="playUpCnt">
							<select name="visitorTeamPlayUpCnt">
								<cfloop from="0" to="18" index="i">
									<option value="#i#" <cfif visitorTeamPlayUpCnt EQ i>selected="selected"</cfif>>#i#</option>
								</cfloop>
							</select>
							#REQUIRED#<b>Use Dropdown to indicate how many</b>
							<!--- <div class="visitorTeamPlayUpCntLabel" style="font-size:1.2em; font-weight:bold; margin-bottom:5px;">#visitorTeamPlayUpCnt#</div> --->
							<div class="visitorTeamPlayUpCnt" style="width:50%;margin:5% 0;"></div>
						</div>						
					</td>
					

				</tr>
				<TR id="playUpWarning"  class="warning">
					<td colspan="2">
					<span class="red">You must enter player data in PLAYERS PLAYING UP Data Entry Section Below</span>
					</td>
				</tr>

			</table>
			<table>
				<tr>
					<td width="50%" valign="top">
						<div >
							#REQUIRED#<b>Did Home Team have players on the roster or coaches on the MDF who did NOT participate?</b>
							Yes<input type="radio" value="1" name="homeNoParticipate" data-value="1" <cfif isdefined("homeNoParticipate") and homeNoParticipate EQ "1">checked="checked"</cfif>> No<input type="radio" value="0" name="homeNoParticipate" data-value="0" <cfif isdefined("homeNoParticipate") and  homeNoParticipate EQ "0">checked="checked"</cfif>>
							<div class="homeNoParticipateSection">
								<select name="homeNoParticipateCnt">
									<cfloop from="0" to="18" index="i">
										<option value="#i#" <cfif isdefined("homeNoParticipateCnt") and homeNoParticipateCnt EQ i>selected="selected"</cfif>>#i#</option>
									</cfloop>
								</select>
								#REQUIRED#<b>Use Dropdown to indicate how many</b>
								<!--- <div class="homeNoParticipateCntLabel" style="font-size:1.2em; font-weight:bold; margin-bottom:5px;">#HOMENOPARTICIPATECNT#</div> --->
								<div class="homeNoParticipateCnt" style="width:50%;margin:5% 0;"></div>
							</div>
						</div>
					</td>
					<td width="50%" valign="top"  >
						<div>
							#REQUIRED#<b>Did Visitor Team have players on the roster or coaches on the MDF who did NOT participate?</b>
							Yes<input type="radio" value="1" name="visitorNoParticipate" data-value="1" <cfif isdefined("visitorNoParticipate") and visitorNoParticipate EQ "1">checked="checked"</cfif>> No<input type="radio" value="0" name="visitorNoParticipate" data-value="0" <cfif isdefined("visitorNoParticipate") and  visitorNoParticipate EQ "0">checked="checked"</cfif>>
							<div class="visitorNoParticipateSection">
								<select name="visitorNoParticipateCnt">
									<cfloop from="0" to="18" index="i">
										<option value="#i#" <cfif isdefined("visitorNoParticipateCnt") and visitorNoParticipateCnt EQ i>selected="selected"</cfif>>#i#</option>
									</cfloop>
								</select>
								#REQUIRED#<b>Use Dropdown to indicate how many</b>
								<!--- <div class="visitorNoParticipateCntLabel" style="font-size:1.2em; font-weight:bold; margin-bottom:5px;">#visitorNoParticipateCnt#</div> --->
								<div class="visitorNoParticipateCnt" style="width:50%;margin:5% 0;"></div>
							</div>
						</div>
					</td>
				</tr>
				
				<TR id="noPartWarning">
					<td colspan="2">
					<span class="red">You must enter coach and player data in NOT PARTICIPATING IN GAME Data Entry Section Below.</span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<TR><td align="left" valign="top" class="tdUnderLine">
				<table cellpadding="2" cellspacing="2" border="0" style="table-layout:fixed;">
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
						<td>	 &nbsp;
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
			<b>Was the Home team on the field on time?</B>
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
	<tr><td align="left">
			<!--- <b>Referee Paid?</b>
			<SELECT class="TextEntry" name="RefPaid"   > 
				<OPTION value="Y" <cfif RefPaid EQ "Y">selected</cfif>  >Yes</OPTION>
				<OPTION value="N" <cfif RefPaid EQ "N">selected</cfif>  >No </OPTION>
			</SELECT>
			<b>Amount</b><input type="text" name="RefAmount" value="#RefAmount#" > --->
			
			<span class="red">Use the "Claim Unpaid Fees" page to submit any unpaid fees.</span>
			
		</td>
	</tr>
	<tr><td align="right" class="tdUnderLine">
			<table cellpadding="0" cellspacing="0" border="0" width="100%" style="table-layout:fixed;">
				<tr><td align="right">
						<b>Player passes of the home team were received and checked</b>
						<SELECT name="PassesHome"  > 
							<OPTION value="1" <cfif PassesHome EQ "1">selected</cfif>  >Yes</OPTION>
							<OPTION value="0" <cfif PassesHome EQ "0">selected</cfif>  >No </OPTION>
						</SELECT>
					</td>
					<td align="right">
						<b>Line up of home team enclosed, available</b>
						<SELECT name="LineUpHome"   >
							<OPTION value="1" <cfif LineUpHome EQ "1">selected</cfif>  >Yes</OPTION>
							<OPTION value="0" <cfif LineUpHome EQ "0">selected</cfif>  >No </OPTION>
						</SELECT>
					</td>
				</tr>
				<tr><td align="right">
						<b>Player passes of the Visiting team were received and checked</b>
						<SELECT name="PassesVisitor"  > 
							<OPTION value="1" <cfif PassesVisitor EQ "1">selected</cfif>  >Yes</OPTION>
							<OPTION value="0" <cfif PassesVisitor EQ "0">selected</cfif>  >No </OPTION>
						</SELECT>
					</td>
					<td align="right">
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
			<TABLE class="misconduct_table" cellSpacing="0" cellPadding="0" width="100%" border="0" style="table-layout:fixed;">
				<tr class="tblHeading">
					<td colspan=4><b>MISCONDUCTS DURING THE GAME</b></td>
					</tr>
				<tr class="tblHeading">
					<td >PLAYERS AND COACHES <br> (First & Last Name)</td>
					<td valign="bottom" >Pass ##		</td>
					<td valign="bottom" >Team		</td>
					<td valign="bottom" >Misconduct	</td>
				</tr>
				<CFIF isDefined("qGameMisconducts") AND qGameMisconducts.RECORDCOUNT>
					<cfloop query="qGameMisconducts">
						<cfset misconductID = Misconduct_ID>
						<tr><td><input type="text" name="misConPlayerName_#currentRow#" value="#PlayerName#"   size="17" maxlength="50" ></td>
							<td><input type="text" name="misConPassNo_#currentRow#"     value="#PassNo#" 	   size="8"  maxlength="15" >						</td>
							<td><SELECT name="misConTeam_#currentRow#"   style="font-size:11px;" >
									<option value="0" selected>Select Team</option>
									<option value="#HomeTeamID#"	<cfif TeamID EQ HomeTeamID>selected</cfif> > #HomeTeam#    </option>
									<option value="#VisitorTeamID#"	<cfif TeamID EQ VisitorTeamID>selected</cfif> > #VisitorTeam# </option>
								</select>
							</td>
							<td><SELECT name="MisConduct_#currentRow#"  style="font-size:11px;" >
									<option value="0" selected>Select Misconduct</option>
									<cfloop query="qMisconducts">
										<option value="#Misconduct_ID#" <cfif MisConductID EQ Misconduct_ID>selected</cfif> >#lCase(Misconduct_DESCR)# - #ucase(Misconduct_EVENT)#</option>
									</cfloop>
								</select>
							</td>
						</tr>
					</cfloop>
				<cfelse> 	
					<cfloop from="1" to="10" index="idx">
						<tr><td><input type="text" name="misConPlayerName_#idx#" value="#stMisconducts[idx].MISCONPLAYERNAME#" size="17" maxlength="50" > </td>
							<td><input type="text" name="misConPassNo_#idx#"     value="#stMisconducts[idx].MISCONPASSNO#" size="8" maxlength="15" >	</td>
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
									</cfloop>
								</select>
							</td>
						</tr>
					</cfloop>
				</CFIF>				
			</table>
		</td>
	</tr>
		<tr><td class="tdUnderLine">
			<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0 >
				<tr class="tblHeading">
					<td colspan=4> SERIOUS INJURIES DURING THE GAME (Describe injury details in comments) </td>
					</tr>
				<tr class="tblHeading">
					<td >Player <br> (First & Last Name)</td>
					<td >Pass ##		</td>
					<td >Team		</td>
					<td >Nature of Injury	</td>
				</tr>
				<CFIF isDefined("qGameInjuries") AND qGameInjuries.RECORDCOUNT>
					<cfloop query="qGameInjuries">
						<tr><td><input type="text" name="injuryPlayerName_#currentRow#" value="#PlayerName#"  size="17" maxlength="50" ></td>
							<td><input type="text" name="injuryPassNo_#currentRow#"     value="#PassNo#" 	   size="8" maxlength="15" >						</td>
							<td><SELECT name="injuryTeam_#currentRow#"   style="font-size:11px;" >
									<option value="0" selected>Select Team</option>
									<option value="#HomeTeamID#"	<cfif TeamID EQ HomeTeamID>selected</cfif> > #HomeTeam#    </option>
									<option value="#VisitorTeamID#"	<cfif TeamID EQ VisitorTeamID>selected</cfif> > #VisitorTeam# </option>
								</select>
							</td>
							<td><SELECT name="Injury_#currentRow#">
									<option value="0" selected>Select Injury</option>
									<cfloop from="1" to="#arrayLen(arrInjury)#" index="iJ">
										<option value="#arrInjury[iJ][1]#" <cfif arrInjury[iJ][1] EQ Misconduct_ID>selected</cfif> >#arrInjury[iJ][2]# - INJURY</option>
									</cfloop>
								</select>
							</td>
						</tr>
					</cfloop>
				<cfelse>
					<cfloop from="1" to="10" index="idx">
						<tr><td><input type="text" name="injuryPlayerName_#idx#" value="#stInjuries[idx].INJURYPLAYERNAME#" size="17" maxlength="50" > </td>
							<td><input type="text" name="injuryPassNo_#idx#"     value="#stInjuries[idx].INJURYPASSNO#" size="8" maxlength="15" >	</td>
							<td><SELECT name="injuryTeam_#idx#"  style="font-size:11px;">
									<option value="0" selected>Select Team</option>
									<option value="#HomeTeamID#"	<cfif stInjuries[idx].INJURYTEAM EQ HomeTeamID>selected</cfif> > #HomeTeam#    </option>
									<option value="#VisitorTeamID#"	<cfif stInjuries[idx].INJURYTEAM EQ VisitorTeamID>selected</cfif> > #VisitorTeam# </option>
								</select>
							</td>
							<td><SELECT name="Injury_#idx#">
									<option value="0" selected>Select Injury</option>
									<cfloop from="1" to="#arrayLen(arrInjury)#" index="iJ">
										<option value="#arrInjury[iJ][1]#" <cfif arrInjury[iJ][1] EQ stInjuries[idx].INJURY>selected</cfif> >#arrInjury[iJ][2]# - INJURY</option>
									</cfloop>
								</select>
							</td>
						</tr>
					</cfloop>
				</CFIF>				
			</table>
		</td>
	</tr>
	<tr id="playUpRow"><td class="tdUnderLine">
			<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0 >
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

	<tr id="NoParticipantRow">
		<td class="tdUnderLine">
			<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0 >
				<tr class="tblHeading">
					<td colspan=4> PLAYERS AND COACHES NOT PARTICIPATING - Using information you noted at game, enter Name and select whether player or coach for the team noted Player or Coach</td>
					</tr>
				<tr class="tblHeading">
					<td >Player <br> (First & Last Name)</td>
					<td >Select Player or Coach</td>
					<td >Team Affiliated with</td>
				</tr>

				<cfloop from="1" to="18" index="i">
				<tr id="NoParticipateOnHomeRow_#i#">
					<td>#REQUIRED#<input type="text" name="NoParticipatePlayerNameHome_#i#" <cfif trim(len(stNoParticipatesHome[i].NoParticipatePLAYERNAMEHOME))>value="#stNoParticipatesHome[i].NoParticipatePLAYERNAMEHOME#"<cfelse>value=""</cfif>  size="17" maxlength="50" >
					</td>
					<td>#REQUIRED#
						<select name="NoParticipateTypeHome_#i#">
							<option value="">Select Participant Type</option>
							<option value="Player" <cfif trim(len(stNoParticipatesHome[i].NoParticipateTypeHome)) and stNoParticipatesHome[i].NoParticipateTypeHome eq "Player" >selected</cfif>>Player</option>
							<option value="Coach" <cfif trim(len(stNoParticipatesHome[i].NoParticipateTypeHome)) and stNoParticipatesHome[i].NoParticipateTypeHome eq "Coach" >selected</cfif>>Coach</option>
						</select>
					</td>
					<td>#homeTeam# <input type="hidden" name="NoParticipateWithHome_#i#" value="#homeTeamID#"></td>
				</tr>
				</cfloop>
				<cfloop from="1" to="18" index="i">
				<tr id="NoParticipateOnVisitorRow_#i#">
					<td>#REQUIRED#<input type="text" name="NoParticipatePlayerNameVisitor_#i#" <cfif trim(len(stNoParticipatesVisitor[i].NoParticipatePLAYERNAMEVISITOR))>value="#stNoParticipatesVisitor[i].NoParticipatePLAYERNAMEVISITOR#"<cfelse>value=""</cfif> size="17" maxlength="50" ></td>
					<td>#REQUIRED#
						<select name="NoParticipateTypeVisitor_#i#">
							<option value="">Select Participant Type</option>
							<option value="Player" <cfif trim(len(stNoParticipatesVisitor[i].NoParticipateTypeVisitor)) and stNoParticipatesVisitor[i].NoParticipateTypeVisitor eq "Player" >selected</cfif>>Player</option>
							<option value="Coach"  <cfif trim(len(stNoParticipatesVisitor[i].NoParticipateTypeVisitor)) and stNoParticipatesVisitor[i].NoParticipateTypeVisitor eq "Coach" >selected</cfif>>Coach</option>
						</select></td>
					<td>#VisitorTeam# <input type="hidden" name="NoParticipateWithVisitor_#i#" value="#VisitorTeamID#"></td>
				</tr>
				</cfloop>
			</TABLE>
		</td>
	</tr>
	<tr><td align="left" class="tdUnderLine">
			<b>Comments - MUST include factual explanation of all Misconduct. </b> <br>
			<TEXTAREA name="Comments" rows=10  cols=80 >#Trim(Comments)#</TEXTAREA>
		</td>
	</tr>
	<tr><td align="center">
			<span class="red">NOTE: By clicking "Submit" and in lieu of signing documents, the Referee certifies (a) that the Referee checked and verified that the goals were secured as noted on the MDF; (b) that the information contained in the Referee Match Report is accurate and complete; and (c) that I will retain original documents from this game for a period of 3 months from game date or last play date of current season, whichever is later.</span>
			<br>
			<INPUT type="Button" name="SubmitReport" value="Submit"   onclick="GoSubmit('')"  >
			<INPUT type="button" value="Back"	 name="Back"   onclick="GoBack()" ID="Button3">
		</td>
	</tr>
</table>
<!--- </div>  --->
</FORM>
 
</cfoutput>
</div>

<cfsavecontent variable="jquery_ui_css">
	<link rel="stylesheet" href="assets/themes/ui-1.8.5/cupertino/jquery-ui-1.8.5.custom.css">
	<style type="text/css">
		.misconduct_table select {
			margin-right: 1%;
			width: 99%;
		}
		.homeNoParticipate{
			display:none;
			padding: 2% 0;
		}
		.visitorNoParticipate{
			display:none;
			padding: 2% 0;
		}
		select{
			margin:1%;
		} 
		body{
			font-size:1.1em;
		}
	</style>
</cfsavecontent>
<cfhtmlhead text="#jquery_ui_css#">


<cfsavecontent variable="cf_footer_scripts">
	<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
	<script language="JavaScript" type="text/javascript">
		$(function(){
			//hide select
			//$('select[name=homeTeamPlayUpCnt]').hide();
			//$('select[name=visitorTeamPlayUpCnt]').hide();
			$(".homeNoParticipate").hide();
			$(".visitorNoParticipate").hide();
			//$('select[name=homeNoParticipateCnt]').hide();
			//$('select[name=visitorNoParticipateCnt]').hide();
			$('tr[id=playUpRow],tr[id^=PlayUpOnVisitorRow_],tr[id^=PlayUpOnHomeRow_],tr[id=playUpWarning]').hide();
			$('tr[id=NoParticipantRow],tr[id^=NoParticipateOnVisitorRow_],tr[id^=NoParticipateOnHomeRow_],tr[id=NoParticipateWarning]').hide();
			$('input[name^=PlayUpFromOtherVisitor_],input[name^=PlayUpFromOtherHome_]').hide();
			$(".visitorNoParticipateCntLabel,.visitorNoParticipateCnt,.homeNoParticipateCntLabel,.homeNoParticipateCnt").hide();
			//$("#noPartWarning").hide();
			$(".playUpCnt").hide();
			$(".homeNoParticipateCnt,.homeNoParticipateSection").hide();
			$(".visitorNoParticipateCnt,.visitorNoParticipateSection").hide();

			showHidePUTable();
			showHideNPTable();
			$("input[name=visitorTeamPlayUps]").change(function(){
				if($(this).data("value"))
				{
					//$('select[name=visitorNoParticipateCnt]').show();
					$(".visitorNoParticipate").show();
				}
				else 
				{
					//$('select[name=visitorNoParticipateCnt]').hide();
					$(".visitorNoParticipate").hide();

				}
			});

			$("input[name=homeTeamPlayUps]").change(function(){
				if($(this).data("value"))
				{
				//	$('select[name=homeNoParticipateCnt]').show();
					$(".homeNoParticipate").show();
				}
				else 
				{
					//$('select[name=homeNoParticipateCnt]').hide();
					$(".homeNoParticipate").hide();
				}
			});
			
			$(document).on("change","input[name=homeNoParticipate]", function(){

				//console.log($(this).data("value"));
				if($(this).data("value"))
				{
					//console.log($(this).data("value"));
					$(".homeNoParticipateCnt,.homeNoParticipateSection").show();
					$(".homeNoParticipateCntLabel").show();
					$("#noPartWarning").show();
				} 
				else
				{
					$(".homeNoParticipateCnt,.homeNoParticipateSection").hide();
					$(".homeNoParticipateCntLabel").hide();
					$('select[name=homeNoParticipateCnt] option[value=0]').attr('selected','selected');
					if($(".visitorNoParticipateSection").is(":hidden"))
						$("#noPartWarning").hide();
					
				}
				showHideNPTable();
			});

			$(document).on("change","input[name=visitorNoParticipate]", function(){

				if($(this).data("value"))
				{
					//console.log($(this).data("value"));
					$(".visitorNoParticipateCnt,.visitorNoParticipateSection").show();
					$(".visitorNoParticipateCntLabel").show();
					$("#noPartWarning").show();
				}
				else
				{
					$(".visitorNoParticipateCnt,.visitorNoParticipateSection").hide();
					$(".visitorNoParticipateCntLabel").hide();
					$('select[name=visitorNoParticipateCnt] option[value=0]').attr('selected','selected')
					if($(".homeNoParticipateSection").is(":hidden"))
						$("#noPartWarning").hide();

				}
				showHideNPTable();
			});
			$('select[name=homeTeamPlayUpCnt]').change(function(){
				$('select[name=homeTeamPlayUpCnt] option[value=' + this.value + ']').attr('selected','selected');
				$('.homeTeamPlayUpCntLabel').text(this.value);
					showHidePUTable();
			});
			// $('.homeTeamPlayUpCnt').slider({
			// 	range:'min',
			// 	value:#homeTeamPlayUpCnt#,
			// 	min:0,
			// 	max:18,
			// 	step:1,
			// 	slide:function(event,ui){
			// 		$('select[name=homeTeamPlayUpCnt] option[value=' + ui.value + ']').attr('selected','selected');
			// 		$('.homeTeamPlayUpCntLabel').text(ui.value);
			// 		showHidePUTable();
			// 	}
			// });

			$('select[name=visitorTeamPlayUpCnt]').change(function(){
				$('select[name=visitorTeamPlayUpCnt] option[value=' + this.value + ']').attr('selected','selected');
				$('.visitorTeamPlayUpCntLabel').text(this.value);
					showHidePUTable();
			});

			// $('.visitorTeamPlayUpCnt').slider({
			// 	range:'min',
			// 	value:#visitorTeamPlayUpCnt#,
			// 	min:0,
			// 	max:18,
			// 	step:1,
			// 	slide:function(event,ui){
			// 		$('select[name=visitorTeamPlayUpCnt] option[value=' + ui.value + ']').attr('selected','selected');
			// 		$('.visitorTeamPlayUpCntLabel').text(ui.value);
			// 		showHidePUTable();
			// 	}
			// });



			$('select[name=homeNoParticipateCnt]').change(function(){
				$('select[name=homeNoParticipateCnt] option[value=' + this.value + ']').attr('selected','selected');
				$('.homeNoParticipateCntLabel').text(this.value);
					showHideNPTable();
			});
			// $('.homeNoParticipateCnt').slider({
			// 	range:'min',
			// 	value:#homeNoParticipateCnt#,
			// 	min:0,
			// 	max:18,
			// 	step:1,
			// 	slide:function(event,ui){
			// 		$('select[name=homeNoParticipateCnt] option[value=' + ui.value + ']').attr('selected','selected');
			// 		$('.homeNoParticipateCntLabel').text(ui.value);
			// 		showHideNPTable();
			// 	}
			// });
			$('select[name=visitorNoParticipateCnt]').change(function(){
				$('select[name=visitorNoParticipateCnt] option[value=' + this.value + ']').attr('selected','selected');
				$('.visitorNoParticipateCntLabel').text(this.value);
					showHideNPTable();
			});
			// $('.visitorNoParticipateCnt').slider({
			// 	range:'min',
			// 	value:#visitorNoParticipateCnt#,
			// 	min:0,
			// 	max:18,
			// 	step:1,
			// 	slide:function(event,ui){
			// 		$('select[name=visitorNoParticipateCnt] option[value=' + ui.value + ']').attr('selected','selected');
			// 		$('.visitorNoParticipateCntLabel').text(ui.value);
			// 		showHideNPTable();
			// 	}
			// });

			$('select[name^=PlayUpFromHome_],select[name^=PlayUpFromVisitor_]').change(showHideOtherInput);

			//hide sliders
			//$('.playUpCnt').hide();
			
			$('input[name=homeTeamPlayUps],input[name=visitorTeamPlayUps]').click(showHideSliders);
			
			//showHideSliders();
			$('select[name^=PlayUpFromHome_],select[name^=PlayUpFromVisitor_]').each(showHideOtherInput);

		});
		
		function showHideSliders(){
		
			if($('input[name=homeTeamPlayUps]:checked').val() == '1'){
				$('input[name=homeTeamPlayUps]').closest('td').find('.playUpCnt').show();
				//$(".homeNoParticipate").show();
			}
			else{
				$('input[name=homeTeamPlayUps]').closest('td').find('.playUpCnt').hide();
				$(".homeNoParticipate").hide();
			}
			if($('input[name=visitorTeamPlayUps]:checked').val() == '1')
			{
				$('input[name=visitorTeamPlayUps]').closest('td').find('.playUpCnt').show();
				$(".visitorNoParticipate").show();
			}
			else{
				$('input[name=visitorTeamPlayUps]').closest('td').find('.playUpCnt').hide();
				$(".visitorNoParticipate").hide();
			}

			if($('input[name=homeNoParticipate]:checked').val() == '1')
			{
				$(".homeNoParticipateCnt,.homeNoParticipateSection").show();
				$(".homeNoParticipateCntLabel").show();
			}
			else{
				$(".homeNoParticipateCnt,.homeNoParticipateSection").hide();
				$(".homeNoParticipateCntLabel").hide();
			}


			if($('input[name=visitorNoParticipate]:checked').val() == '1')
			{
				$(".visitorNoParticipateCnt,.visitorNoParticipateSection").show();
				$(".visitorNoParticipateCntLabel").show();
			}
			else{
				$(".visitorNoParticipateCnt,.visitorNoParticipateSection").hide();
				$(".visitorNoParticipateCntLabel").hide();
			}

			showHidePUTable();
			showHideNPTable();
		}

		function showHidePUTable() {
			var VisitorPU = parseInt($('select[name=visitorTeamPlayUpCnt] option:selected').text()),
			HomePU = parseInt($('select[name=homeTeamPlayUpCnt] option:selected').text()),
			VisitorChecked = $('input[name=visitorTeamPlayUps]:checked').val(),
			HomeChecked = $('input[name=homeTeamPlayUps]:checked').val(),
			VisitorCheckVal =$('input[name=visitorTeamPlayUps]').val(),
			HomeCheckVal =$('input[name=homeTeamPlayUps').val();
			console.log(HomeChecked);
			//show/hide the entire table based on if there is values
			if (HomeChecked == 1 || VisitorChecked == 1) 
				$('tr[id=playUpRow],tr[id=playUpWarning]').show();
			else{
				$('tr[id=playUpRow],tr[id=playUpWarning]').hide();
			}
			
			//if homePlayUp radio is checked to yes show rows based on HomePU else hide all home rows
			if (HomeChecked == 1){
				$('select[name=homeTeamPlayUpCnt]').parent().show();
				//show/hide home rows based on value of HomePU
				for(var i = 1; i <= 18; i++){
					if(i <= HomePU)
						$('tr[id=PlayUpOnHomeRow_'+i+']').show();
					else{
						$('tr[id=PlayUpOnHomeRow_'+i+']').hide();
					}
				}
			} else {
				//else hide all the home rows
				$('tr[id^=PlayUpOnHomeRow_]').hide();
				$('select[name=homeTeamPlayUpCnt]').val("0");
				//$('select[name=homeTeamPlayUpCnt] option[value=0]').attr('selected','selected');
			}

			//if VisitorPlayUp radio is checked to yes show rows based on VisitorPU else hide all Visitor rows
			if (VisitorChecked == 1){
				$('select[name=visitorTeamPlayUpCnt]').parent().show();
				//show/hide home rows based on value of VisitorPU
				for(var i = 1; i <= 18; i++){
					if(i <= VisitorPU)
						$('tr[id=PlayUpOnVisitorRow_'+i+']').show();
					else{
						$('tr[id=PlayUpOnVisitorRow_'+i+']').hide();
					}
				}
			}else {
				//else hide all the visitor rows
				$('tr[id^=PlayUpOnVisitorRow_]').hide();
				$('select[name=visitorTeamPlayUpCnt]').val("0");
			} 
			
		}

		function showHideNPTable() {
			var VisitorPU = parseInt($('select[name=visitorNoParticipateCnt] option:selected').text()),
			HomePU = parseInt($('select[name=homeNoParticipateCnt] option:selected').text()),
			VisitorChecked = $('input[name=visitorNoParticipate]:checked').val(),
			HomeChecked = $('input[name=homeNoParticipate]:checked').val(),
			VisitorCheckVal =$('input[name=visitorNoParticipate]').val(),
			HomeCheckVal =$('input[name=homeNoParticipate').val();
			//console.log(HomeChecked);
			//console.log(VisitorChecked);
			//show/hide the entire table based on if there is values
			if (HomeChecked == 1 || VisitorChecked == 1) 
				$('tr[id=NoParticipantRow],tr[id=noParticipateWarning]').show();
			else
				$('tr[id=NoParticipateRow],tr[id=noParticipateWarning]').hide();
			
			//if homePlayUp radio is checked to yes show rows based on HomePU else hide all home rows
			if (HomeChecked == 1){
				$('select[name=homeNoParticipateCnt]').parent().show();
				//show/hide home rows based on value of HomePU
				for(var i = 1; i <= 18; i++){
					if(i <= HomePU)
					{
						$('tr[id=NoParticipateOnHomeRow_'+i+']').show();
					}
					else
						$('tr[id=NoParticipateOnHomeRow_'+i+']').hide();
				}
			} else {
				//else hide all the home rows
				$('tr[id^=NoParticipateOnHomeRow_]').hide();
				$('select[name=homeNoParticipateCnt]').val("0");

			}

			//if VisitorNoParticipate radio is checked to yes show rows based on VisitorPU else hide all Visitor rows
			if (VisitorChecked == 1){
				$('select[name=visitorNoParticipateCnt]').parent().show();
				//show/hide home rows based on value of VisitorPU
				for(var i = 1; i <= 18; i++){
					if(i <= VisitorPU)
						$('tr[id=NoParticipateOnVisitorRow_'+i+']').show();
					else
						$('tr[id=NoParticipateOnVisitorRow_'+i+']').hide();
				}
			}else {
				//else hide all the visitor rows
				$('tr[id^=NoParticipateOnVisitorRow_]').hide();
				$('select[name=visitorNoParticipateCnt]').val("0");
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
</cfsavecontent>

<cfinclude template="_footer.cfm">
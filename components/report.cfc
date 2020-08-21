

<cfcomponent>
<CFSET DSN = SESSION.DSN>
<!--- MODIFCATIONS:
 J.Danz 8-26-2014 NCSA15511 - added additional selects and added additional columns to these reports to facilitate the reporting and storing of referee Play Up data. --->
<!--- ============================================
	functions:

============================================= --->


<!--- =================================================================== --->
<cffunction name="getRefRPTHeader" access="remote" returntype="query">
	<!--- --------
		10/21/08 - AArnone - get referee report header record for game specified
		
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#REPORT" method="getRefRPTHeader" returnvariable="qRefRptHeader">
			<cfinvokeargument name="gameID" value="#.#" >
		</cfinvoke>
	----- --->
	<cfargument name="gameID" type="numeric" required="yes" >

	<CFQUERY name="qGetRefRptHeader" datasource="#VARIABLES.DSN#">
			SELECT  referee_rpt_header_ID, xref_game_official_id,
                    (SELECT xgo.CONTACT_ID 
					   FROM XREF_GAME_OFFICIAL xgo
                      WHERE xgo.xref_game_official_id = rr.xref_game_official_id) AS RefereeID, 
					game_id, contact_id_asstRef1, contact_id_asstRef2, contact_id_official4th,
					fieldCond, fieldMarking, weather,
					IsOnTime_Home, HowLate_Home, IsOnTime_Visitor, HowLate_Visitor, startTime, endTime, 
					LineUP_Home, LineUP_Visitor, spectatorCount, 
					HalfTimeScore_Home, HalfTimeScore_Visitor, FullTimeScore_Home, FullTimeScore_Visitor, 
					Passes_Home, Passes_Visitor, 
					conductOfficials, conductPlayers, conductSpectators, 
					refereeDroom, playerDroom, Official4thLog,
					Comments, STARTTIME, ENDTIME,
					refPaid_YN, refPaid_Amount, GameSts, 
					createDate, createdBy, updateDate, updatedBy, 
					AssistantRef1_WriteIn, AssistantRef2_WriteIn, 
					homeTeamPlayUps, visitorTeamPlayUps, homeTeamPlayUpCnt, visitorTeamPlayUpCnt
			  FROM  tbl_referee_RPT_header rr
			 WHERE  Game_ID = #ARGUMENTS.gameID#
	</CFQUERY>
	<cfreturn qGetRefRptHeader>
</cffunction>


<!--- =================================================================== --->
<cffunction name="getRefRPTDetails" access="remote" returntype="query">
	<!--- --------
		10/21/08 - AArnone - get referee report Detail records for refRptHeaderID specified
		
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#REPORT" method="getRefRPTDetails" returnvariable="qRefRptDetails">
			<cfinvokeargument name="refRptHeaderID" value="#.#" >
		</cfinvoke>
		03/09/2009 - aarnone - removed ref amount and ref paid, these will now be insert thru "claim unpaid fees"
	----- --->
	<cfargument name="refRptHeaderID" type="numeric" required="yes" >

	<CFQUERY name="qGetRefRptDetail" datasource="#VARIABLES.DSN#">
		SELECT  referee_rpt_detail_ID, referee_rpt_header_ID, game_id, 
				serial_no, eventType, PlayerName, PassNo, teamid, 
        		misconduct_ID, 
				createDate, createdBy, updateDate, updatedBy, PlayUpFromOther, dbo.getteamname(misconduct_ID) as PlayUpFromTeamName
		  FROM  tbl_referee_RPT_detail
		 WHERE  referee_rpt_header_ID = #ARGUMENTS.refRptHeaderID#
	</CFQUERY>
	<cfreturn qGetRefRptDetail>
</cffunction>





<!--- =================================================================== --->
<cffunction name="AddRefReport" access="remote" returntype="string">
	<!--- --------
		10/22/08 - AArnone - ADD a referee report
		
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#REPORT" method="AddRefReport" returnvariable="xxxxxxxxx">
			<cfinvokeargument name="formFields" value="#FORM#" >
			<cfinvokeargument name="contactID"  value="#SESSION.USER.CONTACTid#" >
		</cfinvoke>
	
		02/19/2009 - aarnone - removed refPaid and refAmount from being inserted. refs will now use claim unpaid fees page.
		03/29/2009 - aarnone - if game is unplayed do not change value of played.
		03/31/2009 - aarnone - fixed error wen adding misconds and inj when missing, now uses structs to pass miconds and injs

	----- --->
	<cfargument name="formFields" type="struct"  required="yes" >
	<cfargument name="contactID"  type="numeric" required="yes" >
	<cfargument name="stMisConducts" type="struct" required="Yes" >
	<cfargument name="stInjuries" 	 type="struct" required="Yes" >
	<cfargument name="stPlayUpsHome" 	 type="struct" required="No" >
	<cfargument name="stPlayUpsVisitor" type="struct" required="No" >

	<cfif isDefined("ARGUMENTS.FORMFIELDS.ASSTREF1WRITEIN")>	<CFSET asstRef1WriteIn = trim(ARGUMENTS.FORMFIELDS.ASSTREF1WRITEIN)>  <cfelse> 		<cfset asstRef1WriteIn = ""> </cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.ASSTREF2WRITEIN")>	<CFSET asstRef2WriteIn = trim(ARGUMENTS.FORMFIELDS.ASSTREF2WRITEIN)>  <cfelse> 		<cfset asstRef2WriteIn = ""> </cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.ASSTREFID1")>			<CFSET ASSTREFID1 = trim(ARGUMENTS.FORMFIELDS.ASSTREFID1)>			<cfelse> 		<cfset ASSTREFID1 = "">		 </cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.ASSTREFID2")>			<CFSET ASSTREFID2 = trim(ARGUMENTS.FORMFIELDS.ASSTREFID2)>			<cfelse> 		<cfset ASSTREFID2 = "">		 </cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.FIELDSPECIFICS")>		<CFSET FieldCondition = trim(ARGUMENTS.FORMFIELDS.FIELDSPECIFICS)> 	<cfelse> 		<cfset fieldSpecifics = "">  </cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.COMMENTS")>			<CFSET comments = trim(ARGUMENTS.FORMFIELDS.COMMENTS)> 				<cfelse> 		<cfset comments = ""> 		 </cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.CONDUCTOFFICIAL")>	<CFSET conductOfficial = trim(ARGUMENTS.FORMFIELDS.CONDUCTOFFICIAL)>  <cfelse> 		<cfset conductOfficial = ""> </cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.CONDUCTPLAYERS")>		<CFSET conductPlayers = trim(ARGUMENTS.FORMFIELDS.CONDUCTPLAYERS)> 	<cfelse> 		<cfset conductPlayers = "">  </cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.CONDUCTSPECTATORS")> 	<CFSET conductSpectators = trim(ARGUMENTS.FORMFIELDS.CONDUCTSPECTATORS)> 	<cfelse> 	<cfset conductSpectators = ""> </cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.ENDHOUR")>			<CFSET endHour = trim(ARGUMENTS.FORMFIELDS.ENDHOUR)> 					<cfelse> 		<cfset endHour = ""> 		</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.ENDMERIDIAN")>		<CFSET endMeridian = trim(ARGUMENTS.FORMFIELDS.ENDMERIDIAN)> 			<cfelse> 		<cfset endMeridian = ""> 	</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.ENDMINUTE")>			<CFSET endMinute = trim(ARGUMENTS.FORMFIELDS.ENDMINUTE)> 				<cfelse> 		<cfset endMinute = ""> 		</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.FIELDMARKING")>		<CFSET fieldMarking = trim(ARGUMENTS.FORMFIELDS.FIELDMARKING)> 		<cfelse> 		<cfset fieldMarking = ""> 	</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.GAMEID")>				<CFSET gameID = trim(ARGUMENTS.FORMFIELDS.GAMEID)> 					<cfelse> 		<cfset gameID = ""> 		</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.GameDate")>			<CFSET GameDate = trim(ARGUMENTS.FORMFIELDS.GameDate)> 				<cfelse> 		<cfset GameDate = ""> 		</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.GAMESTATUS")>			<CFSET gameStatus = trim(ARGUMENTS.FORMFIELDS.GAMESTATUS)> 			<cfelse> 		<cfset gameStatus = ""> 	</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.HTHOWLATE")>			<CFSET htHowLate = trim(ARGUMENTS.FORMFIELDS.HTHOWLATE)> 				<cfelse> 		<cfset htHowLate = ""> 		</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.LINEUPHOME")>			<CFSET lineUpHome = trim(ARGUMENTS.FORMFIELDS.LINEUPHOME)> 			<cfelse> 		<cfset lineUpHome = ""> 	</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.LINEUPVISITOR")>		<CFSET lineUpVisitor = trim(ARGUMENTS.FORMFIELDS.LINEUPVISITOR)> 		<cfelse> 		<cfset lineUpVisitor = ""> 	</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.MODE")>				<CFSET mode = trim(ARGUMENTS.FORMFIELDS.MODE)> 						<cfelse> 		<cfset mode = ""> 			</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.ONTIMEHOME")>			<CFSET onTimeHome = trim(ARGUMENTS.FORMFIELDS.ONTIMEHOME)> 			<cfelse> 		<cfset onTimeHome = ""> 	</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.ONTIMEVISITOR")>		<CFSET onTimeVisitor = trim(ARGUMENTS.FORMFIELDS.ONTIMEVISITOR)> 		<cfelse> 		<cfset onTimeVisitor = ""> 	</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.PASSESHOME")>			<CFSET passesHome = trim(ARGUMENTS.FORMFIELDS.PASSESHOME)> 			<cfelse> 		<cfset passesHome = ""> 	</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.PASSESVISITOR")>		<CFSET passesVisitor = trim(ARGUMENTS.FORMFIELDS.PASSESVISITOR)> 		<cfelse> 		<cfset passesVisitor = ""> 	</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.SCOREHOMEFT")>		<CFSET scoreHomeFT = trim(ARGUMENTS.FORMFIELDS.SCOREHOMEFT)> 			<cfelse> 		<cfset scoreHomeFT = ""> 	</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.SCOREHOMEHT")>		<CFSET scoreHomeHT = trim(ARGUMENTS.FORMFIELDS.SCOREHOMEHT)> 			<cfelse> 		<cfset scoreHomeHT = ""> 	</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.SCOREVISITORFT")>		<CFSET scoreVisitorFT = trim(ARGUMENTS.FORMFIELDS.SCOREVISITORFT)> 	<cfelse> 		<cfset scoreVisitorFT = ""> </cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.SCOREVISITORHT")>		<CFSET scoreVisitorHT = trim(ARGUMENTS.FORMFIELDS.SCOREVISITORHT)> 	<cfelse> 		<cfset scoreVisitorHT = ""> </cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.SPECTATORCOUNT")>		<CFSET spectatorCount = trim(ARGUMENTS.FORMFIELDS.SPECTATORCOUNT)> 	<cfelse> 		<cfset spectatorCount = ""> </cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.STARTHOUR")>			<CFSET startHour = trim(ARGUMENTS.FORMFIELDS.STARTHOUR)> 				<cfelse> 		<cfset startHour = ""> 		</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.STARTMERIDIAN")>		<CFSET startMeridian = trim(ARGUMENTS.FORMFIELDS.STARTMERIDIAN)> 		<cfelse> 		<cfset startMeridian = ""> 	</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.STARTMINUTE")>		<CFSET startMinute = trim(ARGUMENTS.FORMFIELDS.STARTMINUTE)> 			<cfelse> 		<cfset startMinute = ""> 	</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.VTHOWLATE")>			<CFSET VThowLate = trim(ARGUMENTS.FORMFIELDS.VTHOWLATE)> 				<cfelse> 		<cfset VThowLate = ""> 		</cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.WEATHER")>			<CFSET weather = trim(ARGUMENTS.FORMFIELDS.WEATHER)> 					<cfelse> 		<cfset weather = ""> 		</cfif> 
	<cfif isDefined("ARGUMENTS.FORMFIELDS.xrefGameOfficialID")>	<CFSET xrefGameOfficialID = trim(ARGUMENTS.FORMFIELDS.xrefGameOfficialID)> <cfelse> 	<cfset xrefGameOfficialID = ""> </cfif> 
	<cfif isDefined("ARGUMENTS.FORMFIELDS.homeTeamPlayUps")><cfset homeTeamPlayups=arguments.formfields.homeTeamPlayUps><cfelse><cfset homeTeamPlayUps=0></cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.visitorTeamPlayUps")><cfset visitorTeamPlayUps=arguments.formfields.visitorTeamPlayUps><cfelse><cfset visitorTeamPlayUps=0></cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.homeTeamPlayUpCnt")><cfset homeTeamPlayUpCnt=arguments.formfields.homeTeamPlayUpCnt><cfelse><cfset homeTeamPlayUpCnt=0></cfif>
	<cfif isDefined("ARGUMENTS.FORMFIELDS.visitorTeamPlayUpCnt")><cfset visitorTeamPlayUpCnt=arguments.formfields.visitorTeamPlayUpCnt><cfelse><cfset visitorTeamPlayUpCnt=0></cfif>
	<CFIF NOT gameID GT 0>
		<!--- unlikely, but no game id was passed so do nothing and return --->
		<cfreturn "Error: No game id was passed.">
	</CFIF>

	<cfset StartTime = gameDate & " " & StartHour & ":" & StartMinute & " " & StartMeridian>
	<cfset EndTime   = gameDate & " " & EndHour   & ":" & EndMinute   & " " & EndMeridian>

	<!--- list of field specifics (conditions) needs to be converted from a list to a string. --->
	<cfset fieldCondSrting = "">
	<cfLoop list="#fieldSpecifics#" index="ix">
		<cfset fieldCondSrting = fieldCondSrting & ix>
	</cfloop>
	<cfset FieldCondition	= fieldCondSrting >

	<cfif len(trim(htHowLate)) EQ 0>		<cfset htHowLate = 0 >		</cfif>
	<cfif len(trim(VThowLate)) EQ 0>		<cfset VThowLate = 0 >		</cfif>
	<cfif len(trim(spectatorCount)) EQ 0>	<cfset spectatorCount = 0 >	</cfif>

	<cfif gameStatus NEQ "P" >
		<cfset HomeHTScore		= "" >
		<cfset VisitorHTScore	= "" >
		<cfset HomeFTScore		= "" >
		<cfset VisitorFTScore	= "" >
		<cfset FieldCondition	= "" >
	</cfif>

	<cfquery name="insertRefRptHdr" datasource="#VARIABLES.DSN#">
		Insert into tbl_referee_RPT_header
			   (game_id, 	xref_game_official_id,
			    StartTime, 	EndTime,  	GameSts,	
			    contact_id_asstRef1, 	contact_id_asstRef2,
			    AssistantRef1_WriteIn, 	AssistantRef2_WriteIn,  fieldCond, 	weather,
			    IsOnTime_Home, 	HowLate_Home, 	IsOnTime_Visitor, 	HowLate_Visitor,	
			    HalfTimeScore_Home, 	HalfTimeScore_Visitor, 	
			    FullTimeScore_Home, 	FullTimeScore_Visitor, 	Comments,		
			    Passes_Home, 	Passes_Visitor, 	LineUP_Home, 	LineUP_Visitor,
			    spectatorCount, 	fieldMarking, 	conductOfficials,	
			    conductPlayers, 	conductSpectators, 	
				homeTeamPlayUps, visitorTeamPlayUps, homeTeamPlayUpCnt, visitorTeamPlayUpCnt,
			    createDate, 	createdBy, 	updateDate, 	updatedBy)
 		Values (  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.xrefGameOfficialID#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.StartTime#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.EndTime#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.gameStatus#">
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.AsstRefId1#"		null="#yesNoFormat(NOT len(trim(VARIABLES.AsstRefId1)))#">
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.AsstRefId2#"		null="#yesNoFormat(NOT len(trim(VARIABLES.AsstRefId2)))#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.ASSTREF1WRITEIN#"  null="#yesNoFormat(NOT len(trim(VARIABLES.ASSTREF1WRITEIN)))#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.ASSTREF2WRITEIN#"  null="#yesNoFormat(NOT len(trim(VARIABLES.ASSTREF2WRITEIN)))#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.FieldCondition#"	null="#yesNoFormat(NOT len(trim(VARIABLES.FieldCondition)))#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.Weather#"			null="#yesNoFormat(NOT len(trim(VARIABLES.Weather)))#">
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.onTimeHome#">
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.HTHowLate#">
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.onTimeVisitor#">
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.VTHowLate#">
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.scoreHomeHT#"		null="#yesNoFormat(NOT len(trim(VARIABLES.scoreHomeHT)))#">
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.scoreVisitorHT#"	null="#yesNoFormat(NOT len(trim(VARIABLES.scoreVisitorHT)))#">
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.scoreHomeFT#"		null="#yesNoFormat(NOT len(trim(VARIABLES.scoreHomeFT)))#">
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.scoreVisitorFT#"	null="#yesNoFormat(NOT len(trim(VARIABLES.scoreVisitorFT)))#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.Comments#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.passesHome#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.passesVisitor#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.lineUpHome#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.lineUpVisitor#">
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.SpectatorCount#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.FieldMarking#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.ConductOfficial#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.ConductPlayers#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.ConductSpectators#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.homeTeamPlayUps#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.visitorTeamPlayUps#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.homeTeamPlayUpCnt#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.visitorTeamPlayUpCnt#">
				, getdate()
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">
				, getdate()
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">
				)
	</cfquery>

	<cfquery name="getReportID" datasource="#VARIABLES.DSN#">
		Select referee_RPT_header_ID
		  From TBL_REFEREE_RPT_HEADER
		 Where Game_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
	</cfquery>

	<CFIF getReportID.RECORDCOUNT>
		<CFSET refReportHdrID = getReportID.referee_RPT_header_ID>
	<CFELSE>
		<CFSET 	refReportHdrID = 0>
		<cfreturn "Error: No Referee Report was not submitted.">
	</CFIF>
	
	<!--- Flag report as submitted and whether the ref was paid or not --->
	<cfquery name="UpdGameOff" datasource="#VARIABLES.DSN#">
		Update XREF_GAME_OFFICIAL
		   set RefReportSbm_YN = 'Y'
		 where Game_ID 		= <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
		   AND game_official_type_id = 1
	</cfquery> 

	<!--- -------------------------------------------------------------- --->
	<!--- Process MISCONDUCTS ------------------------------------------ --->
	<cfset SerialNo = 0>
	<cfset EventType = 1> <!---  Type 1 = Misconduct	  --->
	<cfloop collection="#ARGUMENTS.stMisConducts#" item="iM">
		<CFIF ARGUMENTS.stMisconducts[iM].MISCONDUCT GT 0> 
			<cfset valPlayerName = ARGUMENTS.stMisconducts[iM].MISCONPLAYERNAME >
			<cfset valPassNo	 = ARGUMENTS.stMisconducts[iM].MISCONPASSNO >
			<cfset valTeam		 = ARGUMENTS.stMisconducts[iM].MISCONTEAM >
			<cfset valMisConduct = ARGUMENTS.stMisconducts[IM].MISCONDUCT >
			<cfset SerialNo   = SerialNo + 1>
			<!--- <br>MisConducts:<cfoutput>[#VARIABLES.EventType#][#VARIABLES.valPlayerName#][#VARIABLES.valPassNo#][#VARIABLES.valTeam#][#VARIABLES.valMisConduct#]</cfoutput> --->
			<cfquery name="insDetailMiscon" datasource="#VARIABLES.DSN#">
				Insert into TBL_Referee_RPT_Detail
					 ( referee_RPT_header_ID, Game_ID, Serial_No, EventType, 
					   PlayerName, PassNo, TeamId, MisConduct_ID,
					   CreateDate, CreatedBy, UpdateDate, UpDatedBy	
					 )
				 values 
					 ( <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.refReportHdrID#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.SerialNo#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.EventType#">
					 , <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valPlayerName#">
					 , <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valPassNo#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.valTeam#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.valMisConduct#">
					 , GetDate()
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">
					 , GetDate()
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">
					 )
			</cfquery>
		</CFIF>
	</cfloop>
	<!--- ----------------------------------------------------------- --->
	<!--- Process Injuries ------------------------------------------ --->
	<cfset EventType = 2 >	
	<cfloop collection="#ARGUMENTS.stInjuries#" item="iJ">
		<CFIF ARGUMENTS.stInjuries[iJ].INJURY GT 0>
			<cfset valPlayerName = ARGUMENTS.stInjuries[iJ].INJURYPLAYERNAME >
			<cfset valPassNo	 = ARGUMENTS.stInjuries[iJ].INJURYPASSNO >
			<cfset valTeam		 = ARGUMENTS.stInjuries[iJ].INJURYTEAM >
			<cfset valInjury	 = ARGUMENTS.stInjuries[iJ].INJURY >
			<cfset SerialNo   = SerialNo + 1>
			<!--- <br>INJURIES:<cfoutput>[#VARIABLES.EventType#][#VARIABLES.valPlayerName#][#VARIABLES.valPassNo#][#VARIABLES.valTeam#][#VARIABLES.valInjury#]</cfoutput> --->
			<cfquery name="insDetailInjury" datasource="#VARIABLES.DSN#">
				Insert into TBL_Referee_RPT_Detail
					( referee_RPT_header_ID, Game_ID, Serial_No, EventType,
					  PlayerName, PassNo, TeamId, MisConduct_ID,
					  CreateDate, CreatedBy, UpdateDate, UpDatedBy	
					)	
				values 
					 ( <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.refReportHdrID#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.SerialNo#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.EventType#">
					 , <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valPlayerName#">
					 , <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valPassNo#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.valTeam#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.valInjury#">
					 , GetDate()
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">
					 , GetDate()
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">
					 )
			</cfquery>
		</CFIF>	
	</cfloop>
	<!--- -------------------------------------------------------------- --->
	<!--- Process HOMETEAM PLAY UPS ------------------------------------------ --->
	<cfif isDefined("ARGUMENTS.STPLAYUPSHOME")>
	<cfset EventType = 3> <!---  Type 3=PlayUps	  --->
	<cfloop collection="#ARGUMENTS.stPlayUpsHome#" item="iM">
		<CFIF ARGUMENTS.stPlayUpsHome[iM].PLAYUPFROMHOME GTE 0> <!--- 0 is the value for "Other" --->
			<cfset valPlayerName = ARGUMENTS.stPlayUpsHome[iM].PLAYUPPLAYERNAMEHOME >
			<cfset valPassNo	 = ARGUMENTS.stPlayUpsHome[iM].PLAYUPPASSNOHOME >
			<cfset valTeam		 = ARGUMENTS.stPlayUpsHome[iM].PLAYUPWITHHOME >
			<cfset valPlayUpFrom = ARGUMENTS.stPlayUpsHome[iM].PLAYUPFROMHOME >
			<cfset valOtherName = ARGUMENTS.stPlayUpsHome[iM].PLAYUPFROMOTHERHOME >
			<cfset SerialNo   = SerialNo + 1>
			
			<cfquery name="insDetailPlayUpHome" datasource="#VARIABLES.DSN#">
				Insert into TBL_Referee_RPT_Detail
					 ( referee_RPT_header_ID, Game_ID, Serial_No, EventType, 
					   PlayerName, PassNo, TeamId, MisConduct_ID,
					   CreateDate, CreatedBy, UpdateDate, UpDatedBy, PlayUpFromOther	
					 )
				 values 
					 ( <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.refReportHdrID#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.SerialNo#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.EventType#">
					 , <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valPlayerName#">
					 , <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valPassNo#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.valTeam#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.valPlayUpFrom#">
					 , GetDate()
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">
					 , GetDate()
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">
					 , <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valOtherName#">
					 )
			</cfquery>
		</CFIF>
	</cfloop>
	</cfif>
	<!--- -------------------------------------------------------------- --->
	<!--- Process VISITINGTEAM PLAY UPS ------------------------------------------ --->
	<cfif isDefined("ARGUMENTS.STPLAYUPSVISITOR")>
	<cfset EventType = 3> <!---  Type 3=PlayUps	  --->
	<cfloop collection="#ARGUMENTS.stPlayUpsVisitor#" item="iM">
		<CFIF ARGUMENTS.stPlayUpsVisitor[iM].PLAYUPFROMVISITOR GTE 0> <!--- 0 is the value for "Other" --->
			<cfset valPlayerName = ARGUMENTS.stPlayUpsVisitor[iM].PLAYUPPLAYERNAMEVISITOR >
			<cfset valPassNo	 = ARGUMENTS.stPlayUpsVisitor[iM].PLAYUPPASSNOVISITOR >
			<cfset valTeam		 = ARGUMENTS.stPlayUpsVisitor[iM].PLAYUPWITHVISITOR >
			<cfset valPlayUpFrom = ARGUMENTS.stPlayUpsVisitor[iM].PLAYUPFROMVISITOR >
			<cfset valOtherName = ARGUMENTS.stPlayUpsVisitor[iM].PLAYUPFROMOTHERVISITOR >
			<cfset SerialNo   = SerialNo + 1>
			
			<cfquery name="insDetailPlayUpVisitor" datasource="#VARIABLES.DSN#">
				Insert into TBL_Referee_RPT_Detail
					 ( referee_RPT_header_ID, Game_ID, Serial_No, EventType, 
					   PlayerName, PassNo, TeamId, MisConduct_ID,
					   CreateDate, CreatedBy, UpdateDate, UpDatedBy, PlayUpFromOther	
					 )
				 values 
					 ( <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.refReportHdrID#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.SerialNo#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.EventType#">
					 , <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valPlayerName#">
					 , <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valPassNo#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.valTeam#">
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.valPlayUpFrom#">
					 , GetDate()
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">
					 , GetDate()
					 , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">
					 , <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valOtherName#">
					 )
			</cfquery>
		</CFIF>
	</cfloop>
	</cfif>

	<cfreturn VARIABLES.refReportHdrID>
</cffunction>



<!--- =================================================================== --->
<cffunction name="UpdateRefReport" access="remote" returntype="string">
	<!--- --------
		08/08/17 - APinzone - UPDATE a referee report
		
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#REPORT" method="UpdateRefReport" returnvariable="xxxxxxxxx">
			<cfinvokeargument name="formFields" value="#FORM#" >
			<cfinvokeargument name="contactID"  value="#SESSION.USER.CONTACTid#" >
		</cfinvoke>

	----- --->

	<cfargument name="formFields" type="struct"  required="yes" >
	<cfargument name="contactID"  type="numeric" required="yes" >
	<cfargument name="stMisConducts" type="struct" required="Yes" >
	<cfargument name="stInjuries" 	 type="struct" required="Yes" >
	<cfargument name="stPlayUpsHome" 	 type="struct" required="No" >
	<cfargument name="stPlayUpsVisitor" type="struct" required="No" >

	<cfscript>
		// Establish Variables from Form Fields
		asstRef1WriteIn = isDefined("ARGUMENTS.FORMFIELDS.ASSTREF1WRITEIN") ? trim(ARGUMENTS.FORMFIELDS.ASSTREF1WRITEIN) : "";
		asstRef2WriteIn = isDefined("ARGUMENTS.FORMFIELDS.ASSTREF2WRITEIN") ? trim(ARGUMENTS.FORMFIELDS.ASSTREF2WRITEIN) : "";
		ASSTREFID1 = isDefined("ARGUMENTS.FORMFIELDS.ASSTREFID1") ? trim(ARGUMENTS.FORMFIELDS.ASSTREFID1) : "";
		ASSTREFID2 = isDefined("ARGUMENTS.FORMFIELDS.ASSTREFID2") ? trim(ARGUMENTS.FORMFIELDS.ASSTREFID2) : "";
		FieldCondition = isDefined("ARGUMENTS.FORMFIELDS.FIELDSPECIFICS") ? trim(ARGUMENTS.FORMFIELDS.FIELDSPECIFICS) : "";
		comments = isDefined("ARGUMENTS.FORMFIELDS.COMMENTS") ? trim(ARGUMENTS.FORMFIELDS.COMMENTS) : "";
		conductOfficial = isDefined("ARGUMENTS.FORMFIELDS.CONDUCTOFFICIAL") ? trim(ARGUMENTS.FORMFIELDS.CONDUCTOFFICIAL) : "";
		conductPlayers = isDefined("ARGUMENTS.FORMFIELDS.CONDUCTPLAYERS") ? trim(ARGUMENTS.FORMFIELDS.CONDUCTPLAYERS) : "";
		conductSpectators = isDefined("ARGUMENTS.FORMFIELDS.CONDUCTSPECTATORS") ? trim(ARGUMENTS.FORMFIELDS.CONDUCTSPECTATORS) : "";
		endHour = isDefined("ARGUMENTS.FORMFIELDS.ENDHOUR") ? trim(ARGUMENTS.FORMFIELDS.ENDHOUR) : "";
		endMeridian = isDefined("ARGUMENTS.FORMFIELDS.ENDMERIDIAN") ? trim(ARGUMENTS.FORMFIELDS.ENDMERIDIAN) : "";
		endMinute = isDefined("ARGUMENTS.FORMFIELDS.ENDMINUTE") ? trim(ARGUMENTS.FORMFIELDS.ENDMINUTE) : "";
		fieldMarking = isDefined("ARGUMENTS.FORMFIELDS.FIELDMARKING") ? trim(ARGUMENTS.FORMFIELDS.FIELDMARKING) : "";
		gameID = isDefined("ARGUMENTS.FORMFIELDS.GAMEID") ? trim(ARGUMENTS.FORMFIELDS.GAMEID) : "";
		GameDate = isDefined("ARGUMENTS.FORMFIELDS.GameDate") ? trim(ARGUMENTS.FORMFIELDS.GameDate) : "";
		gameStatus = isDefined("ARGUMENTS.FORMFIELDS.GAMESTATUS") ? trim(ARGUMENTS.FORMFIELDS.GAMESTATUS) : "";
		htHowLate = isDefined("ARGUMENTS.FORMFIELDS.HTHOWLATE") ? trim(ARGUMENTS.FORMFIELDS.HTHOWLATE) : "";
		lineUpHome = isDefined("ARGUMENTS.FORMFIELDS.LINEUPHOME") ? trim(ARGUMENTS.FORMFIELDS.LINEUPHOME) : "";
		lineUpVisitor = isDefined("ARGUMENTS.FORMFIELDS.LINEUPVISITOR") ? trim(ARGUMENTS.FORMFIELDS.LINEUPVISITOR) : "";
		mode = isDefined("ARGUMENTS.FORMFIELDS.MODE") ? trim(ARGUMENTS.FORMFIELDS.MODE) : "";
		onTimeHome = isDefined("ARGUMENTS.FORMFIELDS.ONTIMEHOME") ? trim(ARGUMENTS.FORMFIELDS.ONTIMEHOME) : "";
		onTimeVisitor = isDefined("ARGUMENTS.FORMFIELDS.ONTIMEVISITOR") ? trim(ARGUMENTS.FORMFIELDS.ONTIMEVISITOR) : "";
		passesHome = isDefined("ARGUMENTS.FORMFIELDS.PASSESHOME") ? trim(ARGUMENTS.FORMFIELDS.PASSESHOME) : "";
		passesVisitor = isDefined("ARGUMENTS.FORMFIELDS.PASSESVISITOR") ? trim(ARGUMENTS.FORMFIELDS.PASSESVISITOR) : "";
		scoreHomeFT = isDefined("ARGUMENTS.FORMFIELDS.SCOREHOMEFT") ? trim(ARGUMENTS.FORMFIELDS.SCOREHOMEFT) : "";
		scoreHomeHT = isDefined("ARGUMENTS.FORMFIELDS.SCOREHOMEHT") ? trim(ARGUMENTS.FORMFIELDS.SCOREHOMEHT) : "";
		scoreVisitorFT = isDefined("ARGUMENTS.FORMFIELDS.SCOREVISITORFT") ? trim(ARGUMENTS.FORMFIELDS.SCOREVISITORFT) : "";
		scoreVisitorHT = isDefined("ARGUMENTS.FORMFIELDS.SCOREVISITORHT") ? trim(ARGUMENTS.FORMFIELDS.SCOREVISITORHT) : "";
		spectatorCount = isDefined("ARGUMENTS.FORMFIELDS.SPECTATORCOUNT") ? trim(ARGUMENTS.FORMFIELDS.SPECTATORCOUNT) : "";
		startHour = isDefined("ARGUMENTS.FORMFIELDS.STARTHOUR") ? trim(ARGUMENTS.FORMFIELDS.STARTHOUR) : "";
		startMeridian = isDefined("ARGUMENTS.FORMFIELDS.STARTMERIDIAN") ? trim(ARGUMENTS.FORMFIELDS.STARTMERIDIAN) : "";
		startMinute = isDefined("ARGUMENTS.FORMFIELDS.STARTMINUTE") ? trim(ARGUMENTS.FORMFIELDS.STARTMINUTE) : "";
		VThowLate = isDefined("ARGUMENTS.FORMFIELDS.VTHOWLATE") ? trim(ARGUMENTS.FORMFIELDS.VTHOWLATE) : "";
		weather = isDefined("ARGUMENTS.FORMFIELDS.WEATHER") ? trim(ARGUMENTS.FORMFIELDS.WEATHER) : "";
		xrefGameOfficialID = isDefined("ARGUMENTS.FORMFIELDS.xrefGameOfficialID") ? trim(ARGUMENTS.FORMFIELDS.xrefGameOfficialID) : "";
		homeTeamPlayups = isDefined("ARGUMENTS.FORMFIELDS.homeTeamPlayUps") ? arguments.formfields.homeTeamPlayUps : 0;
		visitorTeamPlayUps = isDefined("ARGUMENTS.FORMFIELDS.visitorTeamPlayUps") ? arguments.formfields.visitorTeamPlayUps : 0;
		homeTeamPlayUpCnt = isDefined("ARGUMENTS.FORMFIELDS.homeTeamPlayUpCnt") ? arguments.formfields.homeTeamPlayUpCnt : 0;
		visitorTeamPlayUpCnt = isDefined("ARGUMENTS.FORMFIELDS.visitorTeamPlayUpCnt") ? arguments.formfields.visitorTeamPlayUpCnt : 0;

		// If user gets here without a game id, return an error message.
		if ( gameID LTE 0 ) { return "Error: No game id was passed."; }

		// Format time
		StartTime = gameDate & " " & StartHour & ":" & StartMinute & " " & StartMeridian;
		EndTime   = gameDate & " " & EndHour   & ":" & EndMinute   & " " & EndMeridian;

		// Convert list of field conditions to a string.
		fieldCondString = "";
		for ( ix = 1; ix lte listLen(fieldSpecifics); ix++ ) { 
			fieldCondString = fieldCondString & ix; 
		}
		FieldCondition = fieldCondString;

		// Check for late values, default to 0
		if ( len(trim(htHowLate)) EQ 0      ) { htHowLate = 0;      }
		if ( len(trim(VThowLate)) EQ 0      ) { VThowLate = 0;      }
		if ( len(trim(spectatorCount)) EQ 0 ) { spectatorCount = 0; }

		// Reset scores / field condition if gameStatus not "P"
		if ( gameStatus NEQ "P" ) {
			HomeHTScore		= "";
			VisitorHTScore	= "";
			HomeFTScore		= "";
			VisitorFTScore	= "";
			FieldCondition	= "";
		}
	</cfscript>

	<cfquery name="insertRefRptHdr" datasource="#VARIABLES.DSN#">
	  UPDATE  	tbl_referee_RPT_header,
		 SET  	xref_game_official_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.xrefGameOfficialID#">,
			    StartTime = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.StartTime#">, 	
			    EndTime = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.EndTime#">,  	
			    GameSts = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.gameStatus#">,	
			    contact_id_asstRef1 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.AsstRefId1#" null="#yesNoFormat(NOT len(trim(VARIABLES.AsstRefId1)))#">, 	
			    contact_id_asstRef2 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.AsstRefId2#" null="#yesNoFormat(NOT len(trim(VARIABLES.AsstRefId2)))#">,
			    AssistantRef1_WriteIn = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.ASSTREF1WRITEIN#" null="#yesNoFormat(NOT len(trim(VARIABLES.ASSTREF1WRITEIN)))#">, 	
			    AssistantRef2_WriteIn = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.ASSTREF2WRITEIN#" null="#yesNoFormat(NOT len(trim(VARIABLES.ASSTREF2WRITEIN)))#">,  
			    fieldCond = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.FieldCondition#" null="#yesNoFormat(NOT len(trim(VARIABLES.FieldCondition)))#">, 	
			    weather = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.Weather#" null="#yesNoFormat(NOT len(trim(VARIABLES.Weather)))#">,
			    IsOnTime_Home = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.onTimeHome#">, 	
			    HowLate_Home = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.HTHowLate#">, 	
			    IsOnTime_Visitor = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.onTimeVisitor#">, 	
			    HowLate_Visitor = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.VTHowLate#">,	
			    HalfTimeScore_Home = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.scoreHomeHT#" null="#yesNoFormat(NOT len(trim(VARIABLES.scoreHomeHT)))#">, 	
			    HalfTimeScore_Visitor = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.scoreVisitorHT#" null="#yesNoFormat(NOT len(trim(VARIABLES.scoreVisitorHT)))#">, 	
			    FullTimeScore_Home = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.scoreHomeFT#" null="#yesNoFormat(NOT len(trim(VARIABLES.scoreHomeFT)))#">, 	
			    FullTimeScore_Visitor = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.scoreVisitorFT#" null="#yesNoFormat(NOT len(trim(VARIABLES.scoreVisitorFT)))#">, 	
			    Comments = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.Comments#">,		
			    Passes_Home = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.passesHome#">, 	
			    Passes_Visitor = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.passesVisitor#">, 	
			    LineUP_Home = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.lineUpHome#">, 	
			    LineUP_Visitor = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.lineUpVisitor#">,
			    spectatorCount = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.SpectatorCount#">, 	
			    fieldMarking = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.FieldMarking#">, 	
			    conductOfficials = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.ConductOfficial#">,	
			    conductPlayers = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.ConductPlayers#">, 	
			    conductSpectators = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.ConductSpectators#">, 	
				homeTeamPlayUps = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.homeTeamPlayUps#">, 
				visitorTeamPlayUps = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.visitorTeamPlayUps#">, 
				homeTeamPlayUpCnt = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.homeTeamPlayUpCnt#">, 
				visitorTeamPlayUpCnt = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.visitorTeamPlayUpCnt#">,	
			    updateDate = getdate(), 	
			    updatedBy = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">
	   WHERE  game_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
	</cfquery>

	<cfquery name="getReportID" datasource="#VARIABLES.DSN#">
		SELECT referee_RPT_header_ID
		  FROM TBL_REFEREE_RPT_HEADER
		 WHERE Game_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
	</cfquery>

	<CFIF getReportID.RECORDCOUNT>
		<CFSET refReportHdrID = getReportID.referee_RPT_header_ID>
	<CFELSE>
		<CFSET 	refReportHdrID = 0>
		<cfreturn "Error: No Referee Report was not submitted.">
	</CFIF>
	
	<!--- Flag report as submitted and whether the ref was paid or not --->
	<cfquery name="UpdGameOff" datasource="#VARIABLES.DSN#">
		UPDATE XREF_GAME_OFFICIAL
		   SET RefReportSbm_YN = 'Y'
		 WHERE Game_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
		   AND game_official_type_id = 1
	</cfquery>

	<!---
		PROCESS MISCONDUCTS
	---------------------------------------------->
	<cfset SerialNo = 0>
	<cfset EventType = 1> <!---  Type 1 = Misconduct	  --->
	<cfloop collection="#ARGUMENTS.stMisConducts#" item="iM">
		<CFIF ARGUMENTS.stMisconducts[iM].MISCONDUCT GT 0> 
			<cfset valPlayerName = ARGUMENTS.stMisconducts[iM].MISCONPLAYERNAME >
			<cfset valPassNo	 = ARGUMENTS.stMisconducts[iM].MISCONPASSNO >
			<cfset valTeam		 = ARGUMENTS.stMisconducts[iM].MISCONTEAM >
			<cfset valMisConduct = ARGUMENTS.stMisconducts[IM].MISCONDUCT >
			<cfset SerialNo   = SerialNo + 1>
			<!--- <br>MisConducts:<cfoutput>[#VARIABLES.EventType#][#VARIABLES.valPlayerName#][#VARIABLES.valPassNo#][#VARIABLES.valTeam#][#VARIABLES.valMisConduct#]</cfoutput> --->
			<cfquery name="insDetailMiscon" datasource="#VARIABLES.DSN#">
			  UPDATE    TBL_Referee_RPT_Detail
				 SET    referee_RPT_header_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.refReportHdrID#">,
						Serial_No = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.SerialNo#">, 
						EventType = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.EventType#">, 
						PlayerName = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valPlayerName#">, 
						PassNo = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valPassNo#">, 
						TeamId = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.valTeam#">, 
						MisConduct_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.valMisConduct#">,
						UpdateDate = GetDate(), 
						UpDatedBy = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">
			   WHERE    Game_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
			</cfquery>
		</CFIF>
	</cfloop>

	<!---
		PROCESS INJURIES
	---------------------------------------------->
	<cfset EventType = 2 >	
	<cfloop collection="#ARGUMENTS.stInjuries#" item="iJ">
		<CFIF ARGUMENTS.stInjuries[iJ].INJURY GT 0>
			<cfset valPlayerName = ARGUMENTS.stInjuries[iJ].INJURYPLAYERNAME >
			<cfset valPassNo	 = ARGUMENTS.stInjuries[iJ].INJURYPASSNO >
			<cfset valTeam		 = ARGUMENTS.stInjuries[iJ].INJURYTEAM >
			<cfset valInjury	 = ARGUMENTS.stInjuries[iJ].INJURY >
			<cfset SerialNo   = SerialNo + 1>
			<!--- <br>INJURIES:<cfoutput>[#VARIABLES.EventType#][#VARIABLES.valPlayerName#][#VARIABLES.valPassNo#][#VARIABLES.valTeam#][#VARIABLES.valInjury#]</cfoutput> --->
			<cfquery name="insDetailInjury" datasource="#VARIABLES.DSN#">
			  UPDATE    TBL_Referee_RPT_Detail
				 SET    referee_RPT_header_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.refReportHdrID#">, 
			 			Serial_No = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.SerialNo#">, 
			 			EventType = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.EventType#">,
					  	PlayerName = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valPlayerName#">, 
					  	PassNo = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valPassNo#">, 
					  	TeamId = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.valTeam#">, 
					  	MisConduct_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.valInjury#">,
					  	UpdateDate = GetDate(), 
					  	UpDatedBy = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">
			   WHERE    Game_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
			</cfquery>
		</CFIF>	
	</cfloop>

	<!---
		PROCESS HOME TEAM PLAY UPS
	---------------------------------------------->
	<cfif isDefined("ARGUMENTS.STPLAYUPSHOME")>
	<cfset EventType = 3> <!---  Type 3=PlayUps	  --->
	<cfloop collection="#ARGUMENTS.stPlayUpsHome#" item="iM">
		<CFIF ARGUMENTS.stPlayUpsHome[iM].PLAYUPFROMHOME GTE 0> <!--- 0 is the value for "Other" --->
			<cfset valPlayerName = ARGUMENTS.stPlayUpsHome[iM].PLAYUPPLAYERNAMEHOME >
			<cfset valPassNo	 = ARGUMENTS.stPlayUpsHome[iM].PLAYUPPASSNOHOME >
			<cfset valTeam		 = ARGUMENTS.stPlayUpsHome[iM].PLAYUPWITHHOME >
			<cfset valPlayUpFrom = ARGUMENTS.stPlayUpsHome[iM].PLAYUPFROMHOME >
			<cfset valOtherName = ARGUMENTS.stPlayUpsHome[iM].PLAYUPFROMOTHERHOME >
			<cfset SerialNo   = SerialNo + 1>
			
			<cfquery name="insDetailPlayUpHome" datasource="#VARIABLES.DSN#">
		      UPDATE    TBL_Referee_RPT_Detail 
			     SET    referee_RPT_header_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.refReportHdrID#">, 
						Serial_No = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.SerialNo#">, 
						EventType = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.EventType#">, 
						PlayerName = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valPlayerName#">, 
						PassNo = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valPassNo#">, 
						TeamId = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.valTeam#">, 
						MisConduct_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.valPlayUpFrom#">,
						UpdateDate = GetDate(), 
						UpDatedBy = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">, 
						PlayUpFromOther = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valOtherName#">
		       WHERE    Game_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
			</cfquery>
		</CFIF>
	</cfloop>
	</cfif>

	<!---
		PROCESS VISITOR TEAM PLAY UPS
	---------------------------------------------->
	<cfif isDefined("ARGUMENTS.STPLAYUPSVISITOR")>
	<cfset EventType = 3> <!---  Type 3=PlayUps	  --->
	<cfloop collection="#ARGUMENTS.stPlayUpsVisitor#" item="iM">
		<CFIF ARGUMENTS.stPlayUpsVisitor[iM].PLAYUPFROMVISITOR GTE 0> <!--- 0 is the value for "Other" --->
			<cfset valPlayerName = ARGUMENTS.stPlayUpsVisitor[iM].PLAYUPPLAYERNAMEVISITOR >
			<cfset valPassNo	 = ARGUMENTS.stPlayUpsVisitor[iM].PLAYUPPASSNOVISITOR >
			<cfset valTeam		 = ARGUMENTS.stPlayUpsVisitor[iM].PLAYUPWITHVISITOR >
			<cfset valPlayUpFrom = ARGUMENTS.stPlayUpsVisitor[iM].PLAYUPFROMVISITOR >
			<cfset valOtherName = ARGUMENTS.stPlayUpsVisitor[iM].PLAYUPFROMOTHERVISITOR >
			<cfset SerialNo   = SerialNo + 1>
			
			<cfquery name="insDetailPlayUpVisitor" datasource="#VARIABLES.DSN#">
			  UPDATE    TBL_Referee_RPT_Detail
			     SET    referee_RPT_header_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.refReportHdrID#">, 
					    Serial_No = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.SerialNo#">, 
					    EventType = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.EventType#">, 
					    PlayerName = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valPlayerName#">, 
					    PassNo = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valPassNo#">, 
					    TeamId = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.valTeam#">, 
					    MisConduct_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.valPlayUpFrom#">,
					    CreateDate = GetDate(), 
					    CreatedBy = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">, 
					    UpdateDate = GetDate(), 
					    UpDatedBy = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">, 
					    PlayUpFromOther = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.valOtherName#">
			   WHERE    Game_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameID#">
			</cfquery>
		</CFIF>
	</cfloop>
	</cfif>

</cffunction>



<!--- =================================================================== 
<cffunction name="XXXXXXXXXXX" access="remote" returntype="string">
	<!--- --------
		MM/DD/YY - AArnone - xxxxxxxxxxxxxxxxxxxxxxxxxxxx
		
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#REPORT" method="XXXXXXXXXXXXXX" returnvariable="xxxxxxxxx">
			<cfinvokeargument name="AAAAAAAAA" value="#CCCCCCCCCC#" >
			<cfinvokeargument name="BBBBBBBBB" value="#DDDDDDDDDD#" >
		</cfinvoke>
	----- --->
	<cfargument name="AAAAAAAAA" type="struct"  required="yes" >
	<cfargument name="BBBBBBBBB"  type="numeric" required="yes" >

	<cfreturn VARIABLES.ZZZZZZ>
</cffunction>--->




<!--- -----------------------------------
	  end component report.cfc
------------------------------------ --->

</cfcomponent>
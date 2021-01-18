<!--- 
	FileName:	gamesUploadUtil.cfm
	Created on: 12/19/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
02/24/09 - aarnone - changed gametime validation to require AM or PM
12/27/2020 - J LECHUGA - Added Game type to upload process
--->

<cfsetting RequestTimeout = "500"> 

<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">  

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Games Upload Utility</H1>
<!--- <h2>yyyyyy </h2> --->


<CFIF isDefined("FORM.CANCEL")>
	<cflocation url="loginHome.cfm?rid=#SESSION.MENUROLEID#">
</CFIF>

<CFSET destinationPath = ExpandPath("\uploads")>
<CFSET errorFilePath   = destinationPath & "\uploadGamesError.csv">
<!--- <cfdump var="#errorFilePath#" abort="true"> --->

<!--- [#destinationPath#] <br> [#errorFilePath#] --->

<cfset ttvalues = "AM,PM">

<CFIF isDefined("FORM.file_to_be_uploaded") AND len(trim(file_to_be_uploaded))>
	<!--- ------------------------------------------------------------------------
		STEP 1: upload selected file, read it and load records into temp table
	-------------------------------------------------------------------------- --->
	<cftry>
		<cffile action="upload"				
				destination="#destinationPath#"
				nameConflict="overwrite"	
				fileField="Form.file_to_be_uploaded">
		<cfcatch><cfdump var="#cfcatch#" abort="true"></cfcatch>
	</cftry>
			<!--- [[[<cfdump var="#cffile#">]]] 
					struct: SERVERDIRECTORY  E:\Inetpub\virtualwwwroot\v3\uploads  
							SERVERFILE 		 test2.xls  --->
<!--- 	<cfdump var="#FORM#" abort="true"> --->
	<cffile action="READ" 
			file="#cffile.SERVERDIRECTORY#\#cffile.SERVERFILE#" 
			variable="fileStuff">

	<cfset Delims = "#chr(13)#" & "#chr(10)#"> 	
	<cfset ctLoop = 0>

	<!--- Delete previously loaded GAMES --->
	<CFQUERY name="qDeleteGameUpload" datasource="#SESSION.DSN#"> 
		DELETE FROM tbl_game_upload
	</CFQUERY>
	<!--- set up Vars and Counters --->
	<cfset errMSG = "">
	<cfset ctUpdate = 0>
	<cfset ctInsert = 0>
	<cfset ctError = 0>
	<cfset ctErrRecs = 0>
	
	<!--- Create Error File --->
	<CFSET tempfile = errorFilePath >
	<CFSET output = "">
	<CFSET output = "Num,Div,Date,Time,Field,Visitor,TeamV,Home,TeamH,Type,Error comments" />
	<CFFILE ACTION="WRITE" FILE="#tempfile#" OUTPUT="#output#" nameconflict="OVERWRITE"  />

	<cfloop list="#fileStuff#" index="irec" delimiters="#delims#">
		<CFIF ctLoop LT 1>
			<!--- First REC is the Header record, skip this record BUT make sure it is correct
				  values s/b: "Num,Div,Date,Time,Field,Visitor,TeamV,Home,TeamH" --->
			<cfset ctLoop = ctLoop + 1>		
			<CFIF UCASE(trim(listGetAt(irec,1))) NEQ "NUM" >
				<CFSET swErr = true>
				<cfset ctError = ctError + 1>
				<cfset errMSG = errMSG & ctLoop & " - First Column heading is not ''NUM'' check file.<br>">
				<cfbreak> <!--- exit loop, dont go any further with this file --->
			<CFELSE>
				<CFSET numCols = listLen(irec,",")>
			</CFIF> 	
		<CFELSE>
			<!--- Header OK, check next record, Validate it --->		
			<cfset ctLoop = ctLoop + 1>
			<!--- <cfdump var="#listLen("Num,Div,Date,Time,Field,Visitor,TeamV,Home,TeamH,Type",",")#" abort="true"> --->
			<cfif listLen(iRec) EQ numCols> <!--- The file should have 10 columns --->
				<CFSET swErr = false>
				<!--- set vars w/values from current record read --->
				<cfset gameNO    	 = trim(listGetAt(irec,1))>
				<cfset division  	 = trim(listGetAt(iRec,2))>
				<cfset field     	 = trim(listGetAt(iRec,5))> 
				<cfset gameDate  	 = trim(listGetAt(iRec,3))>
				<cfset gameTime  	 = trim(listGetAt(iRec,4))>
				<cfset teamVisit 	 = trim(listGetAt(iRec,6))>
				<cfset teamVisitName = trim(listGetAt(iRec,7))>
				<cfset teamHome  	 = trim(listGetAt(iRec,8))>
				<cfset teamHomeName  = trim(listGetAt(iRec,9))>
				<cfset type  		 = trim(listGetAt(iRec,10))>
				<!--- validate --->
				<CFIF NOT isNumeric(gameNO) and len(trim(gameNO)) GT 0>
					<CFSET swErr = true>
					<cfset ctError = ctError + 1>			<!--- <br> <b>bad gameNo!!!!!!! 1 </b> --->
					<cfset errMSG = errMSG &  ctLoop & " - " & gameNo & " - bad gameNo <br>">
					<CFSET output = "#iRec#,bad gameNo">
					<CFFILE ACTION="APPEND" FILE="#tempfile#" OUTPUT="#output#" />
				</CFIF>
				<CFIF (NOT len(trim(type)) or len(trim(type)) gt 1)>
					<CFSET swErr = true>
					<cfset ctError = ctError + 1>			<!--- <br> <b>bad gameNo!!!!!!! 1 </b> --->
					<cfset errMSG = errMSG &  ctLoop & " - " & gameNo & " - please supply a valid game type<br>">
					<CFSET output = "#iRec#,bad game type">
					<CFFILE ACTION="APPEND" FILE="#tempfile#" OUTPUT="#output#" />
				</CFIF>
				<CFIF NOT isNumeric(teamHome) and len(trim(teamHome)) GT 0>
					<CFSET swErr = true>
					<cfset ctError = ctError + 1>			<!--- <br> <b>bad teamNO!!!!!!!! 2 </b> --->
					<cfset errMSG = errMSG &  ctLoop & " - " & gameNo & " - bad H team<br>">
					<CFSET output = "#iRec#,bad Home Team">
					<CFFILE ACTION="APPEND" FILE="#tempfile#" OUTPUT="#output#" />
				<CFELSE>
					<!--- CHECK for VALID Home team/club ID --->
					<CFQUERY name="qGetHomeClubID" datasource="#SESSION.DSN#">
						SELECT club_id FROM tbl_team WHERE team_id = #teamHome#
					</CFQUERY> 
					<cfif qGetHomeClubID.RECORDCOUNT EQ 0>
						<CFSET swErr = true>
						<cfset ctError = ctError + 1>			<!--- <br> <b>bad time!!!!!! 5 </b> --->
						<cfset errMSG = errMSG &  ctLoop & " - " & teamHome & " - home Team ID may not be valid <br>">
						<CFSET output = "#iRec#,Home Team ID may not be valid">
						<CFFILE ACTION="APPEND" FILE="#tempfile#" OUTPUT="#output#" />
					</cfif>
				</CFIF>

				<CFIF NOT isNumeric(teamVisit) and len(trim(teamVisit)) GT 0>
					<CFSET swErr = true>
					<cfset ctError = ctError + 1>			<!--- <br> <b>bad V team!!!!!!!!! 3 </b> --->
					<cfset errMSG = errMSG &  ctLoop & " - " & gameNo & " - bad V team<br>">
					<CFSET output = "#iRec#,bad Visitors Team">
					<CFFILE ACTION="APPEND" FILE="#tempfile#" OUTPUT="#output#" />
				<CFELSE>
					<!--- CHECK for VALID Visiting team/club ID --->
					<CFQUERY name="qGetVisitorClubID" datasource="#SESSION.DSN#">
						SELECT club_id FROM tbl_team WHERE team_id = #teamVisit#
					</CFQUERY> 
					<cfif qGetVisitorClubID.RECORDCOUNT EQ 0>
						<CFSET swErr = true>
						<cfset ctError = ctError + 1>			<!--- <br> <b>bad time!!!!!! 5 </b> --->
						<cfset errMSG = errMSG &  ctLoop & " - " & teamVisit & " - visitor Team ID may not be valid <br>">
						<CFSET output = "#iRec#,Visitors Team ID may not be Valid">
						<CFFILE ACTION="APPEND" FILE="#tempfile#" OUTPUT="#output#" />
					</cfif>
				</CFIF>
				
				<cfif NOT isDate(gameDate) and len(trim(gameDate)) GT 0>
					<CFSET swErr = true>
					<cfset ctError = ctError + 1>			<!--- <br> <b>bad date!!!!!!!! 4 </b> --->
					<cfset errMSG = errMSG &  ctLoop & " - " & gameNo & " - bad date<br>">
					<CFSET output = "#iRec#,bad Date">
					<CFFILE ACTION="APPEND" FILE="#tempfile#" OUTPUT="#output#" />
				<CFELSE>
					<cfset gameDate = Dateformat(gameDate,"mm/dd/yyyy")>
				</cfif>
				
				<CFIF NOT isNumericDate(gameTime) and len(trim(gameTime)) GT 0>
					<CFSET swErr = true>
					<cfset ctError = ctError + 1>			<!--- <br> <b>bad time!!!!!! 5 </b> --->
					<cfset errMSG = errMSG &  ctLoop & " - " & gameNo & " - bad time<br>">
					<CFSET output = "#iRec#,bad Time">
					<CFFILE ACTION="APPEND" FILE="#tempfile#" OUTPUT="#output#" />
				<CFELSE>
					<!--- Check to see if AM/PM is included --->
						<!--- <CFIF gameNO LT '1021'>
							<br> #gameNo# [<cfdump var="#gameTime#">] [#listLast(gameTime," ")#] [#right(gameTime,2)#] --->

				<CFIF listFindNoCase(ttvalues, right(trim(gameTime),2) ) EQ 0>
					<CFSET swErr = true>
					<cfset ctError = ctError + 1>			<!--- <br> <b>bad time!!!!!! 5 </b> --->
					<cfset errMSG = errMSG &  ctLoop & " - " & gameNo & " - bad time no AM/PM<br>">
					<CFSET output = "#iRec#,bad Time">
					<CFFILE ACTION="APPEND" FILE="#tempfile#" OUTPUT="#output#" />
				<CFELSE>
					<cfset gameTime = GameDate & " " & TimeFormat(gameTime,"hh:mm tt")> 
				</CFIF>

						<!--- <cfelse>
							<cfbreak>	
						</CFIF>
						 --->					

					<!--- <cfif len(listLast(gameTime,":")) GT 2>
						<!--- <cfset gameTime = mid(gametime,1,len(gameTime)-1)> --->
						<!--- <cfset gameTime = listFirst(gametime,":") &":"& listFirst(listlast(gameTime,":")," ")> --->
						<CFSET gameTime = REReplace(gametime,"[A-Z a-z]","","ALL")>
	                
					</cfif>
					<!--- add AM/PM accordingly --->
					<CFIF listFirst(gametime,":") GTE 9 AND listFirst(gametime,":") LTE 11 >
						<CFSET gameTime = gametime & " AM">
					<CFELSE>
						<CFSET gameTime = gametime & " PM">
					</CFIF>
					<cfset gameTime = GameDate & " " & TimeFormat(gameTime,"hh:mm tt")> --->
				
				</cfif>
				
				<!--- Check for valid field abbr --->
				<CFQUERY name="qGetField" datasource="#SESSION.DSN#">
					SELECT field_id FROM tbl_field WHERE fieldAbbr = '#field#'
				</CFQUERY>
				<CFIF qGetField.recordCount EQ 0>
					<CFSET swErr = true>
					<cfset ctError = ctError + 1>			<!--- <br> <b>bad time!!!!!! 5 </b> --->
					<cfset errMSG = errMSG &  ctLoop & " - " & field & " - field abbr may not be valid <br>">
					<CFSET output = "#iRec#,Field Abbrv may not be valid">
					<CFFILE ACTION="APPEND" FILE="#tempfile#" OUTPUT="#output#" />
				</CFIF>

				<CFIF NOT swErr>
					<!--- Changed to only INSERT because we DELETE all the rows up above --->
					<CFQUERY name="qInsertGameUpload" datasource="#SESSION.DSN#">
							INSERT tbl_game_upload
							  ( gameCode		, division		, field
							  , gameDate		, gameTime
							  , HomeTeamID	, VisitorTeamID
							  , createDate	, createdBy,game_type , HomeTeamName, VisitorTeamName)
							VALUES
							  ( <cfqueryparam value="#trim(gameNO)#" 	cfsqltype="CF_SQL_VARCHAR"   null="#yesNoFormat(NOT(len(trim(gameNO))))#">
							  , <cfqueryparam value="#trim(division)#" 	cfsqltype="CF_SQL_VARCHAR"   null="#yesNoFormat(NOT(len(trim(division))))#">
							  , <cfqueryparam value="#trim(field)#" 	cfsqltype="CF_SQL_VARCHAR"   null="#yesNoFormat(NOT(len(trim(field))))#">
							  , <cfqueryparam value="#trim(gameDate)#" 	cfsqltype="CF_SQL_DATE"      null="#yesNoFormat(NOT(len(trim(gameDate))))#">
							  , <cfqueryparam value="#trim(gameTime)#"  cfsqltype="CF_SQL_TIMESTAMP" null="#yesNoFormat(NOT(len(trim(gameTime))))#">
							  , <cfqueryparam value="#trim(teamHome)#" 	cfsqltype="CF_SQL_INTEGER"   null="#yesNoFormat(NOT(len(trim(teamHome))))#">
							  , <cfqueryparam value="#trim(teamVisit)#" cfsqltype="CF_SQL_INTEGER"   null="#yesNoFormat(NOT(len(trim(teamVisit))))#">
							  , <cfqueryparam value="#now()#" 		cfsqltype="CF_SQL_TIMESTAMP" >
							  , <cfqueryparam value="#SESSION.USER.CONTACTID#" cfsqltype="CF_SQL_INTEGER"   >
							  , <cfqueryparam value="#type#" cfsqltype="CF_SQL_CHAR"  null="#yesNoFormat(NOT(len(trim(type))))#" >
							  , <cfqueryparam value="#teamHomeName#" cfsqltype="CF_SQL_CHAR"  null="#yesNoFormat(NOT(len(trim(teamHomeName))))#" >
							  , <cfqueryparam value="#teamVisitName#" cfsqltype="CF_SQL_CHAR"  null="#yesNoFormat(NOT(len(trim(teamVisitName))))#" >
							  ) 
					</CFQUERY> 
					<cfset ctInsert = ctInsert + 1>
				<CFELSE>
					<cfset ctErrRecs = ctErrRecs + 1>
				</CFIF>

			<cfelse>
				<CFSET swErr = true>
				<cfset ctError = ctError + 1>			<!--- <br> <b>bad gameNo!!!!!!! 1 </b> --->
				<cfset errMSG = errMSG &  ctLoop & " - ????? - not enough columns in ths record <br>">
			</cfif>
		</CFIF> 
	</cfloop>
	
	<!--- DEBUG --
	<CFQUERY name="qGameUpload" datasource="#SESSION.DSN#">
		select * from tbl_game_upload WHERE gameCode < '1021'
	</CFQUERY> 
	<cfloop query="qGameUpload">
		<br>#GAMECODE# - #GAMETIME# --- #TIMEFORMAT(GAMETIME,"hh:mm tt")#
	</cfloop> --->

</CFIF>


<CFIF isDefined("FORM.perform_game_insert")>
	<!--- ---------------------------------------------------------------------------------------
		STEP 2: Process games loaded to the temp table, User has decided to load the games....
	----------------------------------------------------------------------------------------- --->
	<CFQUERY name="qCtGameUpload" datasource="#SESSION.DSN#">
		select * FROM tbl_game_upload
	</CFQUERY>
	
	<!--- This cfc process the tbl_game_upload and inserts into TBL_GAME and XREF_GAME_TEAM --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="uploadGames" returnvariable="uploadMSG">
	</cfinvoke>
	<br>
	<br>
	<br> <span class="red"> <b>#uploadMSG#</b> </span> 
</CFIF>
 



<CFSET swUpload = true>

<cfquery name="qIsUploadOK" datasource="#SESSION.DSN#">
	Select season_id, seasonCode, upload_games_yn 
	  from tbl_season 
	 where currentSeason_yn = 'Y'
</cfquery> <!--- <cfdump var="#qIsUploadOK#"> --->

<CFIF qIsUploadOK.upload_games_yn NEQ "Y">
	<span class="red">
		<b>The Games Upload Functionality has not been turned on for this season, to turn it on go to SEASON SETTINGS / CREATE/EDIT SEASONS  on the menu screen</b>
	</span>
	<CFSET swUpload = false>
</CFIF>

<CFIF swUpload>


	<!--- ------------------------------------------------------------------------------------------------------- --->
	<form name="gamesUploadutility" action="gamesUploadUtil.cfm" enctype="multipart/form-data" method="post">
		<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
			<tr><TD colspan="2" align="right"> 
					<a href="gamesUploadDisplay.cfm">Click here to see the loaded games.</a>
				</TD>
			</tr>
			<tr class="tblHeading">
				<TD colspan="2"> For Current Season: #SESSION.currentSeason.SF# #SESSION.currentSeason.YEAR# &nbsp;</TD>
			</tr>
			<tr><td class="tdUnderLine" align="right">
					<b>Step 1:</b> Game File to Upload:
				</td>
				<td class="tdUnderLine" align="left">
					<input name="file_to_be_uploaded" type="file" size="70" />
					&nbsp;
					<input name="clear_upload" type="reset" value="Clear" />
				</td>
			</tr>
			<tr><td class="recordlabel" align="right">&nbsp;</td>
				<td class="recordred" align="left">
					<input name="cancel" type="submit" value="Cancel" />
					&nbsp;
					<input name="perform_upload" type="submit" value="Upload Game File" onclick="validate();" />
				</td>
			</tr>
		</table>
		<!--- ------------------------------------------------------------------------------------------------------- --->
		<CFIF isDefined("FORM.file_to_be_uploaded") AND len(trim(file_to_be_uploaded))>
			<CFSET totalRecsToBeLoaded = ctloop - 1>
			<table cellpadding="5" cellspacing="0" border="1">
				<tr><td align="right">  Total Recs on File:</td>
					<td align="right">  #totalRecsToBeLoaded#</td>
					<td>				(NOT including header)</td>
				</tr>
				<tr><td align="right">  Total Error Recs:</td>
					<td align="right">  #ctErrRecs#</td>
					<td>				Total records with errors that were not loaded</td>
				</tr>
				<tr><td align="right">  Total Recs Inserted:</td>
					<td align="right">  #ctInsert#</td>
					<td>				Total records on file that were inserted. (new records)</td>
				</tr>
				<!--- <tr><td align="right">Total Recs Updated:</td>
					<td align="right">#ctUpdate#</td>
					<td>Total records on file that were updated. (existing records)</td>
				</tr> --->
				<CFQUERY name="qCtGameUpload" datasource="#SESSION.DSN#">
					select * FROM tbl_game_upload
				</CFQUERY> 
				<tr><td align="right">  Count on Table</td>
					<td align="right">  #qCtGameUpload.recordCount#</td>
					<td>				Total number of records in the games upload table. </td>
				</tr>
				<tr><td align="right">  Total Errors:</td>
					<td align="right">  #ctError#</td>
					<td>				Records can have more than one error</td>
				</tr>
			</table>
			<CFIF len(trim(errMsg))>
				<div style="overflow:auto; height:250px; border:1px ##cccccc solid;">
					<br> <b>Records with errors.....</b> 
					<br> <b>RecNo - GameNo - Comment</b>
					<br> #errMSG#
				</div>
				<a href="#SESSION.SITEVARS.HOMEHTTP#\uploads\uploadGamesError.csv">DownLoad Error File</a>
			</CFIF>
			<br>
			<br><b>Step 2:</b> 
			<CFIF totalRecsToBeLoaded EQ qCtGameUpload.recordCount>
				Proceed to load games? 
				<input name="perform_game_insert" type="submit" value="Load Games to Database" />
			<CFELSE>
				Proceed to load #qCtGameUpload.recordCount# good games out of #totalRecsToBeLoaded# found on spreadsheet? 
				<input name="perform_game_insert" type="submit" value="Load #qCtGameUpload.recordCount# good Games to Database" />
			</CFIF>
			
		</CFIF>
	</form>
</CFIF>


<script language="javascript">
	function	validate()
	{	if (document.upload_form.file_to_be_uploaded.value == '')
		{	alert('Please choose a file to upload');		}
		else
		{	document.upload_form.submit();		}
	}
</script>



</cfoutput>
</div>
<cfinclude template="_footer.cfm">




 
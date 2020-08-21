<cfsetting enablecfoutputonly="yes">

<!--- 
	FileName:	gameSchedulepdf.cfm
	Created on: 05/28/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: Display game schedule/scores based on parameter:
			gameSchedule.cfm?by=tm = by TEAM
			gameSchedule.cfm?by=cl = by CLUB 		(default case)
			gameSchedule.cfm?by=dv = by DIVISION
			gameSchedule.cfm?by=fl = by FIELD
			gameSchedule.cfm?by=dt = by DATE
			gameSchedule.cfm?by=nn = by nonNCSA ????
	
MODS: mm/dd/yyyy - filastname - comments

09/08/2017 - apinzone (27455) - Updated step 4 to use cfspreadsheet, exporting to XLS instead of CSV. 

NOTE!!! Changes to this file may also need to be applied to gameSchedule.cfm
 --->
 
<!--- <cfinclude template="cfudfs.cfm"> ---> 
<!--- <cfinclude template="_checkLogin.cfm"> public page, login not needed--->

<cfset output_csv = "">

<CFIF isDefined("URL.BY")>
	<CFSET schedBY = URL.BY>
<CFELSE>
	<CFSET schedBY = "">
</CFIF>

<CFIF isDefined("URL.TID")>
	<CFSET teamIDselected = URL.TID>
<CFELSE>
	<CFSET teamIDselected = 0>
</CFIF>

<CFIF isDefined("URL.CID")>
	<CFSET clubIDselected = URL.CID>
<CFELSE>
	<CFSET clubIDselected = 0>
</CFIF>

<CFIF isDefined("URL.DIV")>
	<CFSET divSelected = URL.DIV>
<CFELSE>
	<CFSET divSelected = 0>
</CFIF>

<CFIF isDefined("URL.FROM")>
	<CFSET dateSelectedFrom = URL.FROM>
<CFELSE>
	<CFSET dateSelectedFrom = 0>
</CFIF>

<CFIF isDefined("URL.TO")>
	<CFSET dateSelectedTo = URL.TO>
<CFELSE>
	<CFSET dateSelectedTo = 0>
</CFIF>

<CFIF isDefined("URL.FID")>
	<CFSET fieldSelected = URL.FID>
<CFELSE>
	<CFSET fieldSelected = 0>
</CFIF>


<cfset printerFriendlyHeader = "">
<cfset printerFriendlyData	 = "">

<CFSWITCH expression="#VARIABLES.schedBY#">
	<CFCASE value="tm"><!--- BY TEAM --->
		<CFSET h1text = "by Team">
	</CFCASE>
	<CFCASE value="dv"><!--- BY DIVISION --->
		<CFSET h1text = "by Division">
	</CFCASE>
	<CFCASE value="fl"><!--- BY FIELD --->
		<CFSET h1text = "by Field">
	</CFCASE>
	<CFCASE value="dt"><!--- BY DATE --->
		<CFSET h1text = "by Date">
	</CFCASE>
	<CFCASE value="nn"><!--- BY NON NCSA --->
		<CFSET h1text = "by NON NCSA games">
	</CFCASE>
	<cfdefaultcase><!--- BY CLUB --->
		<CFSET h1text = "by Club">
	</cfdefaultcase>
</CFSWITCH>



<!--- use query instead of session because it is a public page --->
<CFQUERY name="qGetSchedDisplay" datasource="#SESSION.DSN#">
	SELECT _VALUE
	  FROM TBL_GLOBAL_VARS
	 WHERE _NAME = 'AllowSchedDisplay'
</CFQUERY>
<CFSET swDisplaySched = qGetSchedDisplay._VALUE>

<CFIF swDisplaySched EQ "N" >
	<span class="red"><b>The schedule is currently not available.</b></span>
<cfelse>

	<CFSWITCH expression="#VARIABLES.schedBY#">
		<CFCASE value="tm"><!--- BY TEAM --->
			<CFIF isDefined("VARIABLES.teamIDselected") AND teamIDselected GT 0>
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="teamID"  value="#VARIABLES.teamIDselected#">
					<cfinvokeargument name="notLeague" value="">
					<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
				</cfinvoke>  
			</CFIF>
		</CFCASE>

		<CFCASE value="dv"><!--- BY DIVISION --->
			<CFIF isDefined("VARIABLES.divSelected") AND divSelected GT 0 >
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="division" value="#VARIABLES.divSelected#">
					<cfinvokeargument name="notLeague" value="N">
					<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
				</cfinvoke>  <!--- <cfinvokeargument name="date" 	  value="#FORM.DATE#"> --->
			</CFIF>	
		</CFCASE>
	
		<CFCASE value="fl"><!--- BY FIELD --->
			<CFIF isDefined("VARIABLES.fieldSelected") AND fieldSelected GT 0 >
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="fieldID" value="#VARIABLES.fieldSelected#">
					<cfinvokeargument name="notLeague" value="">
					<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
				</cfinvoke>  
			</CFIF>	
		</CFCASE>
	
		<CFCASE value="dt"><!--- BY DATE --->
			<CFIF isDefined("VARIABLES.dateSelectedFrom") AND dateSelectedFrom GT 0 >
				<CFSET fromDate = dateSelectedFrom>
				<CFSET toDate   = 0>
				<CFIF dateSelectedTo GT 0>
					<CFIF dateSelectedTo GT dateSelectedFrom>
						<CFSET toDate   = dateSelectedTo>
					</CFIF>
				</CFIF>	
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="fromDate" value="#VARIABLES.fromDate#">
					<cfinvokeargument name="toDate"   value="#VARIABLES.toDate#">
					<cfinvokeargument name="notLeague" value="">
				</cfinvoke> 
			</CFIF>	
		</CFCASE>
	
		<CFCASE value="nn"><!--- BY NON NCSA --->
			<CFIF isDefined("VARIABLES.dateSelectedFrom") AND dateSelectedFrom GT 0 >
				<CFSET fromDate = dateSelectedFrom>
				<CFSET toDate   = 0>
				<CFIF dateSelectedTo GT 0>
					<CFIF dateSelectedTo GT dateSelectedFrom>
						<CFSET toDate   = dateSelectedTo>
					</CFIF>
				</CFIF>	
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="fromDate" value="#VARIABLES.fromDate#">
					<cfinvokeargument name="toDate"   value="#VARIABLES.toDate#">
					<cfinvokeargument name="notLeague" value="Y">
				</cfinvoke> 
				<cfquery name="qGames" dbtype="query">
					SELECT * FROM qGames
					ORDER BY GAME_TYPE
				</cfquery>
			</CFIF>	
		</CFCASE>
	
		<cfdefaultcase><!--- BY CLUB --->
			<CFIF isDefined("VARIABLES.clubIDselected") AND clubIDselected GT 0>
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="clubID"  value="#VARIABLES.clubIDselected#">
					<cfinvokeargument name="notLeague" value="">
					<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
				</cfinvoke>  
			</CFIF>
		</cfdefaultcase>
	</CFSWITCH> 
</CFIF><!--- IF swDisplaySched EQ "N"  --->

<CFIF isDefined("qGames") AND qGames.RECORDCOUNT>

	<!---------------------------------------->
	<!--- STEP 1: FILTER INITIAL RECORDSET --->
	<!---------------------------------------->

	<cfquery name="qGames2" dbtype="query">
		SELECT 	DIVISION,
						FIELDABBR,
						GAME_DATE,
						GAME_TIME,
						GAME_ID,
						GAME_TYPE,
						HOME_TEAMNAME,
						REF_ACCEPT_YN,
						SCORE_HOME,
						SCORE_VISITOR,
						VIRTUAL_TEAMNAME,
						VISITOR_TEAMNAME
		FROM 	qGames
	</cfquery>

	<!-------------------------------------------------------->
	<!--- STEP 2: ALTER RECORDSET DATA TO MATCH FORMATTING --->
	<!-------------------------------------------------------->

	<cfloop query="qGames2">

		<!--- CUSTOM DATE FORMAT --->
		
		<cfset qGames2[ "GAME_DATE" ][ qGames2.currentRow ] = UCASE(DATEFORMAT(qGames2["GAME_DATE"][qGames2.currentRow],"ddd")) & " " & DATEFORMAT(qGames2["GAME_DATE"][qGames2.currentRow],"mm/dd/yy") & " " & TIMEFORMAT(qGames2["GAME_TIME"][qGames2.currentRow],"hh:mm tt") />

		<!--- CUSTOM VISTOR/VIRTUAL TEAM NAME --->

		<CFIF len(trim(Visitor_TeamName)) AND len(trim(Virtual_TeamName)) EQ 0>
			<cfset qGames2[ "Visitor_TeamName" ][ qGames2.currentRow ] = Visitor_TeamName>
		<CFELSE><!--- state cup or non league game --->
			<cfset qGames2[ "Visitor_TeamName" ][ qGames2.currentRow ] = Virtual_TeamName>
		</CFIF>

		<!--- CUSTOM REFEREE ACCEPTED OUTPUT --->

		<cfset qGames2[ "Ref_accept_YN" ][ qGames2.currentRow ] = iif(qGames2[ "Ref_accept_YN" ][ qGames2.currentRow ] EQ "Y", DE("Accepted"), DE("N")) />

		<!--- CUSTOM GAME TYPE OUTPUT --->

		<cfswitch expression="#qGames2[ 'game_type' ][ qGames2.currentRow ]#">
			<cfcase value="F"><cfset qGames2[ 'game_type' ][ qGames2.currentRow ] = "Friendly"></cfcase>
			<cfcase value="C"><cfset qGames2[ 'game_type' ][ qGames2.currentRow ] = "State Cup"></cfcase>
			<cfcase value="P"><cfset qGames2[ 'game_type' ][ qGames2.currentRow ] = "Playoff"></cfcase>
			<cfcase value="N"><cfset qGames2[ 'game_type' ][ qGames2.currentRow ] = "Non League"></cfcase>
			<cfdefaultcase><cfset qGames2[ 'game_type' ][ qGames2.currentRow ] = ""></cfdefaultcase>
		</cfswitch>

	</cfloop>

	<!---------------------------------------------------------------->
	<!--- STEP 3: APPLY FINAL FILTER TO THE COLUMN LIST FOR OUTPUT --->
	<!---------------------------------------------------------------->

	<cfquery name="qGames3" dbtype="query">
		SELECT 	DIVISION,
						FIELDABBR,
						GAME_DATE,
						GAME_ID,
						GAME_TYPE,
						HOME_TEAMNAME,
						REF_ACCEPT_YN,
						SCORE_HOME,
						SCORE_VISITOR,
						VISITOR_TEAMNAME
		FROM 	qGames2
	</cfquery>

	<!-------------------------------------->
	<!--- STEP 4: CONVERT QUERY TO EXCEL --->
	<!-------------------------------------->
	<cfscript>
		xls = SpreadsheetNew();

		// Header Row
		SpreadsheetAddRow(xls, "Division, Field Name, Date/Time, Game##, Game Type, Home Team, Referee, Home Score, Visitor Score, Visitor Team");
		
		// Add Games
		SpreadsheetAddRows(xls, qGames3);

		// Format Date/Time Column
		SpreadsheetFormatColumn(xls, {dataformat="ddd mm/dd/yy hh:mm AM/PM"}, 3);

		// Format Header Row -- Putting this last because the bold attribute tends to leak
		SpreadsheetFormatRow(xls, {bold=TRUE, alignment="center"}, 1);

		// Set column widths
		SpreadSheetSetColumnWidth(xls,1,8);
		SpreadSheetSetColumnWidth(xls,2,21);
		SpreadSheetSetColumnWidth(xls,3,21);
		SpreadSheetSetColumnWidth(xls,4,8.5);
		SpreadSheetSetColumnWidth(xls,5,11.5);
		SpreadSheetSetColumnWidth(xls,6,25);
		SpreadSheetSetColumnWidth(xls,7,8.5);
		SpreadSheetSetColumnWidth(xls,8,12);
		SpreadSheetSetColumnWidth(xls,9,13);
		SpreadSheetSetColumnWidth(xls,10,27);
	</cfscript>

	<!------------------------------->
	<!--- STEP 5: OUTPUT XLS DATA --->
	<!------------------------------->
	<cfheader name="Content-Disposition" value="attachment;filename=gameSchedule.xls"> 
	<cfcontent type="application/vnd.ms-excel" variable="#SpreadsheetReadBinary( xls )#">

</CFIF>
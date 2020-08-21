<!--- 
	FileName:	globalVars.cfc
	Created on: 08/18/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: this file will process TBL_GLOBAL_VARS
	
MODS: mm/dd/yyyy - filastname - comments

 --->


<cfcomponent>
<CFSET DSN = SESSION.DSN>

<!--- =================================================================== --->
<cffunction name="getGlobalVars" access="public" returntype="query">
	<!--- --------
		08/18/08 - AArnone - New function: returns values from TBL_GLOBAL_VARS
	----- --->
	<cfquery name="qGlobVars" datasource="#VARIABLES.DSN#">
		SELECT ID, _NAME, _VALUE  FROM tbl_global_vars ORDER BY ID
	</cfquery>

	<cfreturn qGlobVars>
</cffunction>

<!--- =================================================================== --->
<cffunction name="UpdateGlobalVars" access="public" >
	<cfargument name="globalVarName"  required="Yes" type="string">
	<cfargument name="globalVarValue" required="Yes" type="string">
	<!--- --------
		01/07/09 - AArnone - New function: UPDATES TBL_GLOBAL_VARS
	----- --->
	<cfquery name="qGlobVars" datasource="#VARIABLES.DSN#">
		UPDATE tbl_global_vars
		   SET _VALUE = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.globalVarValue#">
		 WHERE _NAME  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.globalVarName#">
	</cfquery>

</cffunction>

<!--- =================================================================== --->
<cffunction name="getGlobalValue" access="public" returntype="string">
	<cfargument name="globalVarName" required="Yes" type="string">
	<!--- --------
		12/31/08 - AArnone - New function: returns a value from TBL_GLOBAL_VARS
	----- --->
	<cfquery name="qGlobalValue" datasource="#VARIABLES.DSN#">
		SELECT _VALUE  
		  FROM tbl_global_vars
		 WHERE _NAME = <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.globalVarName#">
	</cfquery>
	
	<cfif qGlobalValue.recordCount EQ 1>
		<cfset GlobalValue = qGlobalValue._VALUE >
	<cfelse>
		<cfset GlobalValue = "There was either NO value for this parm OR more than one was found. Value cannot be determined.">
	</cfif>
	
	<cfreturn GlobalValue>
</cffunction>

<!--- =================================================================== --->
<cffunction name="getListX" access="public" returntype="any">
	<!--- --------
		09/09/08 - AArnone - returns list OR arrays of valid values for a given type. used in dropdowns.
						old asp site had arrays set up ahead of time. This method will get values
						when called upon.
		05/20/09 - aarnone - T:7758 - expanded list of injuries
		
				<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="xxx">
					<cfinvokeargument name="listType" value=" ---type--- "> 
				</cfinvoke> 
				valid types so far:
						TEAMAGES 
						PLAYLEVEL
						TBSLIST 
						ADMINFEES 
						GAMETYPE 
						PLAYGROUP 
						FINESTATUS 
						REFRPTEVENT 
						RATINGS1 
						RATINGS2 
						APPEALSTATUS 
						FIELDCOND 
						WEATHER 
						INJURY 
						GAMESTATUS 
						CLUBSTATES 
						PLAYHOURS
						DDHHMMTT

	----- --->
	<cfargument name="listType" required="Yes" type="string">
	
	<cfswitch expression="#ucase(ARGUMENTS.listType)#">
		<cfcase value="TEAMAGES">
			<cfset returnX = "U07,U08,U09,U10,U11,U12,U13,U14,U15,U16,U17,U18,U19">
		</cfcase>
		<cfcase value="PLAYLEVEL">
			<cfset returnX = "P,A,B,C,D,E,F,G,H,I,J,R,X">
		</cfcase>
		<cfcase value="TBSLIST">
			<cfset returnX = "TBS(H),TBS(V),TBS(B),TBS(L),TBS(SC),TBS(F),TBS(R),MBOS">
		</cfcase>
		<cfcase value="ADMINFEES">
			<cfset returnX = "None,Late Schedule,Late TBS,Others,Own Referee">
		</cfcase>
		<cfcase value="PLAYHOURS">
			<cfset returnX = "9:00:00 AM,10:00:00 AM,11:00:00 AM,12:00:00 PM,1:00:00 PM,2:00:00 PM,3:00:00 PM,4:00:00 PM,5:00:00 PM,6:00:00 PM,7:00:00 PM,8:00:00 PM">
		</cfcase>
		<cfcase value="DDHHMMTT">
			<CFSET ddhhmmtt = structNew()>
			<CFSET ddhhmmtt.day = "SAT,SUN">
			<CFSET ddhhmmtt.hour = "1,2,3,4,5,6,7,8,9,10,11,12">
			<CFSET ddhhmmtt.min = "00,15,30,45">
			<CFSET ddhhmmtt.tt = "AM,PM">
			<cfset returnX = ddhhmmtt>
		</cfcase>
		<cfcase value="GAMETYPE">
			<CFSCRIPT>
				// 10/6/08 - old values, new values below...
				//GameTypeArray = arrayNew(2);
				//GameTypeArray[1][1] = "";
				//GameTypeArray[1][2] = ""; // "League"
				//GameTypeArray[1][3] = ""; // "leag"
				//GameTypeArray[2][1] = "P";
				//GameTypeArray[2][2] = "Play Off";
				//GameTypeArray[2][3] = "POFF";
				//GameTypeArray[3][1] = "F";
				//GameTypeArray[3][2] = "Friendly";
				//GameTypeArray[3][3] = "FRND";
				//GameTypeArray[4][1] = "Q";
				//GameTypeArray[4][2] = "Quarter Final";
				//GameTypeArray[4][3] = "QFNL";
				//GameTypeArray[5][1] = "S";
				//GameTypeArray[5][2] = "Semi-Final";
				//GameTypeArray[5][3] = "SFNL";
				//GameTypeArray[6][1] = "I";
				//GameTypeArray[6][2] = "Final";
				//GameTypeArray[6][3] = "FNL";
				//GameTypeArray[7][1] = "C";
				//GameTypeArray[7][2] = "State Cup";
				//GameTypeArray[7][3] = "SC";
				//GameTypeArray[8][1] = "R";
				//GameTypeArray[8][2] = "Premier Cup";
				//GameTypeArray[8][3] = "PC";
				GameTypeArray = arrayNew(2);
				GameTypeArray[1][1] = "L";
				GameTypeArray[1][2] = "League";
				GameTypeArray[1][3] = "";
				GameTypeArray[2][1] = "F";
				GameTypeArray[2][2] = "Friendly";
				GameTypeArray[2][3] = "FRND";
				GameTypeArray[3][1] = "C";
				GameTypeArray[3][2] = "State Cup";
				GameTypeArray[3][3] = "SC";
				GameTypeArray[4][1] = "N";
				GameTypeArray[4][2] = "Non League";
				GameTypeArray[4][3] = "NonLg";
				GameTypeArray[5][1] = "P";
				GameTypeArray[5][2] = "Play Off";
				GameTypeArray[5][3] = "POFF";
				returnX = GameTypeArray;
			</CFSCRIPT>
		</cfcase>
		<cfcase value="PLAYGROUP">
			<CFSCRIPT>
				PlayGroupArray = arrayNew(2);
				PlayGroupArray[1][1] = "";
				PlayGroupArray[1][2] = "";
				PlayGroupArray[2][1] = "W";
				PlayGroupArray[2][2] = "White";
				PlayGroupArray[3][1] = "B";
				PlayGroupArray[3][2] = "Blue";
				returnX = PlayGroupArray;				
			</CFSCRIPT>
		</cfcase>
		<cfcase value="FINESTATUS">
			<CFSCRIPT>
				FineStatus = arrayNew(2);
				FineStatus[1][1] = "P";
				FineStatus[1][2] = "Paid";
				FineStatus[2][1] = "I";
				FineStatus[2][2] = "Invoiced";
				FineStatus[3][1] = "W";
				FineStatus[3][2] = "Waived";
				FineStatus[4][1] = "D";
				FineStatus[4][2] = "Deleted";
				FineStatus[5][1] = "";
				FineStatus[5][2] = "";
				FineStatus[6][1] = "E";
				FineStatus[6][2] = "Appealed";
				FineStatus[7][1] = "U";
				FineStatus[7][2] = "Unpaid";
				returnX = FineStatus;				
			</CFSCRIPT>
		</cfcase>
		<cfcase value="REFRPTEVENT">
			<CFSCRIPT>
				RefRptEvent = arrayNew(2);
				RefRptEvent[1][1] = "1";
				RefRptEvent[1][2] = "Cautioned";
				RefRptEvent[2][1] = "2";
				RefRptEvent[2][2] = "Sent off";
				returnX = RefRptEvent;				
			</CFSCRIPT>
		</cfcase>
		<cfcase value="RATINGS1">
			<CFSCRIPT>
				Ratings1 = ArrayNew(2);
				Ratings1[1][1] = "E"; 
				Ratings1[1][2] = "Excellent";
				Ratings1[2][1] = "G"; 
				Ratings1[2][2] = "Good";
				Ratings1[3][1] = "F"; 
				Ratings1[3][2] = "Fair";
				Ratings1[4][1] = "P"; 
				Ratings1[4][2] = "Poor";
				returnX = Ratings1;				
			</CFSCRIPT>
		</cfcase>
		<cfcase value="RATINGS2">
			<CFSCRIPT>
				gRatings2 = ArrayNew(2);
				gRatings2[1][1] = "S";
				gRatings2[1][2] = "Satisfactory";
				gRatings2[2][1] = "U";
				gRatings2[2][2] = "UnSatisfactory";
				returnX = gRatings2;				
			</CFSCRIPT>
		</cfcase>
		<cfcase value="APPEALSTATUS">
			<CFSCRIPT>
				AppealStsArray = arrayNew(2);
				AppealStsArray[1][1] = "P";
				AppealStsArray[1][2] = "Pending";
				AppealStsArray[2][1] = "A";
				AppealStsArray[2][2] = "Accepted";
				AppealStsArray[3][1] = "R";
				AppealStsArray[3][2] = "Rejected";
				returnX = AppealStsArray;				
			</CFSCRIPT>
		</cfcase>
		<cfcase value="FIELDCOND">
 			<CFSCRIPT>
				FieldCondition = arrayNew(2);
				FieldCondition[1][1] = "A";
				FieldCondition[1][2] = "Inadequate field marking";
				FieldCondition[2][1] = "B";
				FieldCondition[2][2] = "Missing Goal Nets";
				FieldCondition[3][1] = "C";
				FieldCondition[3][2] = "Missing Corner Flags";
				FieldCondition[4][1] = "D";
				FieldCondition[4][2] = "Dangerous Field Conditions";
				FieldCondition[5][1] = "E";
				FieldCondition[5][2] = "No Game Ball and/or Substitute Game Ball";
				FieldCondition[6][1] = "F";
				FieldCondition[6][2] = "Goals not secure";
				FieldCondition[7][1] = "G";
				FieldCondition[7][2] = "Home team not ready to play within the designated time";
				FieldCondition[8][1] = "H";
				FieldCondition[8][2] = "Visiting team not ready to play within the designated time";
				returnX = FieldCondition;				
			</CFSCRIPT>
		</cfcase>
		<cfcase value="WEATHER">
			<CFSCRIPT>
				Weather = arrayNew(2);
				Weather[1][1] = "D";
				Weather[1][2] = "Dry";
				Weather[2][1] = "S";
				Weather[2][2] = "Snow";
				Weather[3][1] = "R";
				Weather[3][2] = "Rain";
				Weather[4][1] = "N";
				Weather[4][2] = "Sunny";
				Weather[5][1] = "O";
				Weather[5][2] = "Overcast";
				Weather[6][1] = "T";
				Weather[6][2] = "Thunder";
				returnX = Weather;				
			</CFSCRIPT>
		</cfcase>
		<cfcase value="INJURY">
			<!--- REPLACED 6/9/2009 BY B. Cooper with db lookup --->
			
			<cfinvoke
				component="injury"
				method="getInjuries"
				returnvariable="injuries">
				
				<cfset Injury=arraynew(2)>
				<cfloop query="injuries">
					<cfset Injury[currentRow][1]=injury_id>
					<cfset Injury[currentRow][2]=injury_desc>
				</cfloop>
				
				<cfset returnX=Injury>
		
			<!--- this is for ticket:7758, originally had the following...
				Injury[1][1] = 1;
				Injury[1][2] = "Tripped";
				Injury[2][1] = 2;
				Injury[2][2] = "Slipped";
			 --->			
			<!--- <CFSCRIPT>
				Injury = arrayNew(2);
				Injury[1][1]  = 1;
				Injury[1][2]  = "Head injury, ambulance called";
				Injury[2][1]  = 2;
				Injury[2][2]  = "Head injury, ambulance not called";
				Injury[3][1]  = 3;
				Injury[3][2]  = "Lower body/leg injury, ambulance called";
				Injury[4][1]  = 4;
				Injury[4][2]  = "Lower body/leg injury, ambulance not called";
				Injury[5][1]  = 5;
				Injury[5][2]  = "Torso injury, ambulance called";
				Injury[6][1]  = 6;
				Injury[6][2]  = "Torso injury, ambulance not called";
				Injury[7][1]  = 7;
				Injury[7][2]  = "Any part of arm injury, ambulance called";
				Injury[8][1]  = 8;
				Injury[8][2]  = "Any part of arm injury, ambulance not called";
				Injury[9][1]  = 9;
				Injury[9][2]  = "Medical condition unrelated to play, ambulance called";
				Injury[10][1] = 10;
				Injury[10][2] = "Other injury, ambulance called";
				Injury[11][1] = 11;
				Injury[11][2] = "Other injury, ambulance not called";
				Injury[12][1] = 12;
				Injury[12][2] = "Other injury, details unknown";
				returnX = Injury;
			</CFSCRIPT> --->

		</cfcase>
		<cfcase value="GAMESTATUS">
			<CFSCRIPT>
				GameSts = arrayNew(2);
				GameSts[1][1] = "P";
				GameSts[1][2] = "Played";
				GameSts[2][1] = "W";
				GameSts[2][2] = "Not played due to weather";
				GameSts[3][1] = "N";
				GameSts[3][2] = "Teams-noshow";
				GameSts[4][1] = "H";
				GameSts[4][2] = "Home Team - noshow";
				GameSts[5][1] = "V";
				GameSts[5][2] = "Visiting Team - noshow";
				returnX = GameSts;				
			</CFSCRIPT>
		</cfcase>
		<cfcase value="CLUBSTATES">
			<CFSCRIPT>
				ClubStatesArray = arrayNew(2);
				ClubStatesArray[1][1] = "NJ";
				ClubStatesArray[1][2] = "New Jersey";
				ClubStatesArray[2][1] = "NY";
				ClubStatesArray[2][2] = "New York";
				ClubStatesArray[3][1] = "CT";
				ClubStatesArray[3][2] = "Connecticut";
				ClubStatesArray[4][1] = "PA";
				ClubStatesArray[4][2] = "Pennsylvania";
				returnX = ClubStatesArray;				
			</CFSCRIPT>
		</cfcase>
		<cfdefaultcase>
			<CFSET returnX = "Incorrect listtype used:[" & ucase(ARGUMENTS.listType) & "] check against cfc values.">
		</cfdefaultcase>
	</cfswitch>
	<cfreturn returnX>
</cffunction>
	



</cfcomponent>
 
<cfcomponent>
<CFSET DSN = SESSION.DSN>

<!--- =================================================================== --->
<cffunction name="insertFine" access="public">
	<!--- --------
		10/02/08 - AArnone - 
		01/30/09 - fixed error caused by extra comma after season_id
	----- --->
	<cfargument name="SeasonID" 	type="numeric" required="Yes"> 
	<cfargument name="gameID" 		type="numeric" required="No" default="0"> 
	<cfargument name="clubID" 		type="numeric" required="Yes">
	<cfargument name="TeamID" 		type="numeric" required="No">
	<cfargument name="fineTypeID" 	type="numeric" required="Yes">
	<cfargument name="Status" 		type="string"  required="Yes"	>
	<cfargument name="Amount" 		type="string" required="No" default="0">
	<cfargument name="Comments"  	type="string"  required="Yes">
	<cfargument name="contactID" 	type="numeric" required="Yes">
	<cfargument name="AppealAllowedYN" type="string" required="No" default="Y">
	<cfargument name="CheckNo" 		type="string"  required="No" default=""	>
	<cfargument name="CheckRcvDate" type="string"  required="No" default=""	>
	
	<CFIF isDate(ARGUMENTS.CheckRcvDate)>
		<cfset newCheckRcvDate = dateFormat(ARGUMENTS.CheckRcvDate,"mm/dd/yyyy")>
	<CFELSE>
		<cfset newCheckRcvDate = "">
	</CFIF>
	
<!--- 	<CFIF isNumeric(ARGUMENTS.Amount)>
		<CFSET VARIABLES.amount = ARGUMENTS.Amount>
	<CFELSE>
		<CFSET VARIABLES.amount = "">
	</CFIF> --->
	<CFQUERY name="getFines" datasource="#SESSION.DSN#">
		Select Amount from TLKP_Fine_Type Where FINETYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.fineTypeId#">
	</CFQUERY>
	<cfset variables.amount = getFines.amount>
	
	<CFQUERY name="qInsertFine" datasource="#VARIABLES.DSN#">
		delete from tbl_fines 
			where game_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.gameID#"> 
			and fineType_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.fineTypeID#">;
		Insert into TBL_FINES
			( GAME_ID   	  ,	SEASON_ID
			, Club_Fined_id   , Team_Fined_id   
			, fineType_ID	  , AMOUNT
			, FineDateCreated , FineTimeCreated
			, Status  		  , Comments
			, AppealAllowed_YN
			, CheckNo		, CheckRcvDate
			, createdBy  	, createDate
			, UpdatedBy  	, UpdatedDate
		 	) 
		Values 
			( <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.gameID#"	 null="#YesNoFormat(NOT LEN(TRIM(ARGUMENTS.gameID)))#">
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.SeasonID#">
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.clubID#" >
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.TeamID#"	 null="#YesNoFormat(NOT LEN(TRIM(ARGUMENTS.TeamID)))#">
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.fineTypeID#">
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.Amount#"	 null="#yesNoFormat(NOT len(trim(VARIABLES.Amount)))#">
			, <cfqueryparam cfsqltype="CF_SQL_DATE"	   value="#dateFormat(now(),"mm/dd/yyyy")#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#dateFormat(now(),"mm/dd/yyyy")# #timeFormat(now(),"hh:mm:ss tt")#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.Status#"    null="#YesNoFormat(NOT LEN(TRIM(ARGUMENTS.Status)) )#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.Comments#"  null="#YesNoFormat(NOT LEN(TRIM(ARGUMENTS.Comments)) )#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.AppealAllowedYN#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.CheckNo#" 	 null="#yesNoFormat(NOT len(trim(ARGUMENTS.CheckNo)))#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#newCheckRcvDate#"	 null="#yesNoFormat(NOT len(trim(VARIABLES.newCheckRcvDate)))#">
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.contactID#">
			, <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#now()#">
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#ARGUMENTS.contactID#">
			, <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#now()#">
			);
	</CFQUERY>

</cffunction>


<!--- =================================================================== --->
<cffunction name="updateFine" access="public">
	<!--- 10/13/08 - AArnone - 	----- --->
	<cfargument name="fineID" 		type="numeric" 	required="Yes"> 
	<cfargument name="gameID" 		type="numeric" 	required="Yes"> 
	<cfargument name="clubID" 		type="numeric" 	required="Yes">
	<cfargument name="TeamID" 		type="numeric" 	required="Yes">
	<cfargument name="fineTypeID" 	type="numeric"  required="Yes">
	<cfargument name="Amount" 		type="string" 	required="Yes"> 
	<cfargument name="Status" 		type="string" 	required="Yes"	>
	<cfargument name="CheckNo" 		type="string" 	required="no" default=""> 	
	<cfargument name="Comments"  	type="string"   required="Yes">
	<cfargument name="CheckRcvdDate" type="string"    required="No" default="">
	<cfargument name="contactID" 	type="numeric"  required="Yes">
	<cfargument name="AppealAllowedYN" type="string" required="No" default="Y">
	
	<CFIF isNumeric(ARGUMENTS.Amount)>
		<CFSET VARIABLES.amount = ARGUMENTS.Amount>
	<CFELSE>
		<CFSET VARIABLES.amount = "">
	</CFIF>
	
	<CFQUERY name="qUpdateFine" datasource="#VARIABLES.DSN#">
		Update TBL_Fines
		   set Game_ID		 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.gameID#" 		null="#yesNoFormat(NOT len(trim(ARGUMENTS.gameID)))#">
			 , Club_Fined_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.clubID#" 		null="#yesNoFormat(NOT len(trim(ARGUMENTS.clubID)))#">
			 , Team_Fined_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.TeamID#" 		null="#yesNoFormat(NOT len(trim(ARGUMENTS.TeamID)))#">
			 , FineType_Id	 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.fineTypeID#" 	null="#yesNoFormat(NOT len(trim(ARGUMENTS.fineTypeID)))#">
			 , Amount		 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.Amount#" 		null="#yesNoFormat(NOT len(trim(VARIABLES.Amount)))#">
			 , Status		 = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.Status#" 		null="#yesNoFormat(NOT len(trim(ARGUMENTS.Status)))#">
			 , CheckNo		 = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.CheckNo#" 	null="#yesNoFormat(NOT len(trim(ARGUMENTS.CheckNo)))#">
			 , Comments		 = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.Comments#" 	null="#yesNoFormat(NOT len(trim(ARGUMENTS.Comments)))#">
			 , UpdatedDate	 = <cfqueryparam cfsqltype="CF_SQL_VARCHAR"	value="#dateFormat(now(),"mm/dd/yyyy")# #timeFormat(now(),"hh:mm:ss")#">
			 , CheckRcvDate	 = <cfqueryparam cfsqltype="CF_SQL_DATE"    value="#dateFormat(ARGUMENTS.CheckRcvdDate,"mm/dd/yyyy")#" null="#yesNoFormat(NOT len(trim(ARGUMENTS.CheckRcvdDate)))#">
			 , updatedBy	 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.contactID#">
			 , AppealAllowed_YN	= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.AppealAllowedYN#" null="#yesNoFormat(NOT len(trim(ARGUMENTS.AppealAllowedYN)))#">
		 Where FINE_Id  = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.fineID#">
	</CFQUERY>
</cffunction>


<!--- =================================================================== --->
<cffunction name="createNewFine" access="public">
	<!--- --------
		8/31/18 - R. Gonzalez - Ticket NCSA27455 - Create new fines without checking any existing fines
	----- --->
	<cfargument name="SeasonID" 	type="numeric" required="Yes"> 
	<cfargument name="gameID" 		type="numeric" required="No" default="0"> 
	<cfargument name="clubID" 		type="numeric" required="Yes">
	<cfargument name="TeamID" 		type="numeric" required="No">
	<cfargument name="fineTypeID" 	type="numeric" required="Yes">
	<cfargument name="Status" 		type="string"  required="Yes"	>
	<cfargument name="Amount" 		type="string" required="No" default="0">
	<cfargument name="Comments"  	type="string"  required="Yes">
	<cfargument name="contactID" 	type="numeric" required="Yes">
	<cfargument name="AppealAllowedYN" type="string" required="No" default="Y">
	<cfargument name="CheckNo" 		type="string"  required="No" default=""	>
	<cfargument name="CheckRcvDate" type="string"  required="No" default=""	>
	
	<CFIF isDate(ARGUMENTS.CheckRcvDate)>
		<cfset newCheckRcvDate = dateFormat(ARGUMENTS.CheckRcvDate,"mm/dd/yyyy")>
	<CFELSE>
		<cfset newCheckRcvDate = "">
	</CFIF>
	
	<CFQUERY name="getFines" datasource="#SESSION.DSN#">
		Select Amount from TLKP_Fine_Type Where FINETYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.fineTypeId#">
	</CFQUERY>
	<cfset variables.amount = getFines.amount>
	
	<CFQUERY name="qInsertFine" datasource="#VARIABLES.DSN#">
		INSERT INTO TBL_FINES
			( GAME_ID   	  ,	SEASON_ID
			, Club_Fined_id   , Team_Fined_id   
			, fineType_ID	  , AMOUNT
			, FineDateCreated , FineTimeCreated
			, Status  		  , Comments
			, AppealAllowed_YN
			, CheckNo		, CheckRcvDate
			, createdBy  	, createDate
			, UpdatedBy  	, UpdatedDate
		 	) 
		VALUES 
			( <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.gameID#"	 null="#YesNoFormat(NOT LEN(TRIM(ARGUMENTS.gameID)))#">
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.SeasonID#">
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.clubID#" >
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.TeamID#"	 null="#YesNoFormat(NOT LEN(TRIM(ARGUMENTS.TeamID)))#">
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.fineTypeID#">
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.Amount#"	 null="#yesNoFormat(NOT len(trim(VARIABLES.Amount)))#">
			, <cfqueryparam cfsqltype="CF_SQL_DATE"	   value="#dateFormat(now(),"mm/dd/yyyy")#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#dateFormat(now(),"mm/dd/yyyy")# #timeFormat(now(),"hh:mm:ss tt")#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.Status#"    null="#YesNoFormat(NOT LEN(TRIM(ARGUMENTS.Status)) )#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.Comments#"  null="#YesNoFormat(NOT LEN(TRIM(ARGUMENTS.Comments)) )#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.AppealAllowedYN#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.CheckNo#" 	 null="#yesNoFormat(NOT len(trim(ARGUMENTS.CheckNo)))#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#newCheckRcvDate#"	 null="#yesNoFormat(NOT len(trim(VARIABLES.newCheckRcvDate)))#">
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.contactID#">
			, <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#now()#">
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#ARGUMENTS.contactID#">
			, <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#now()#">
			);
	</CFQUERY>

</cffunction>



<cffunction name="getFines" access="public" returntype="query">
	<cfargument name="FineStatus" type="string" required="Yes"> 
	<cfargument name="clubID" 	  type="numeric" required="Yes"> 
	<cfargument name="seasonID" type="numeric" required="No">
	<!--- 11/1/2012 J. Rab --->
	<cfargument name="sortBy" type="numeric" required="No">
	<cfargument name="sortType" type="string" required="No">
	<cfargument name="StartDate" type="date" required="No">
	<cfargument name="EndDate" type="date" required="No">
	<!--- 10/13/08 - AArnone -  --->
	
	<cfswitch expression="#ucase(ARGUMENTS.FineStatus)#">
		<cfcase value="P">
			<cfset SelCriteria = " and Status = 'P'" >
		</cfcase>
		<cfcase value="U">	 
			<cfset SelCriteria = " and (Status in ('U', '', '') or Status is Null ) " >
		</cfcase>
		<cfcase value="I">	
			<cfset SelCriteria = " and Status = 'I'" >
		</cfcase>
		<cfcase value="W">
			<cfset SelCriteria = " and Status = 'W'" >
		</cfcase>
		<cfcase value="D">
			<cfset SelCriteria = " and Status = 'D'" >
		</cfcase>
		<cfcase value="E">
			<cfset SelCriteria = " and Status = 'E'" >
		</cfcase>
		<cfcase value="A">
			<cfset SelCriteria = "" >
		</cfcase>
		<cfdefaultcase>
			<cfset SelCriteria = " and ( Status not in ('I' , 'D') or Status is Null)" >
		</cfdefaultcase>
	</cfswitch>
	
	<!--- 11/1/2012 J. Rab --->
	<cfif isDefined("arguments.sortBy")>
		<cfswitch expression="#arguments.sortBy#">
		<cfcase value="1">
		<cfset sortByExpression = "Order by Fine_ID " & arguments.sortType>
		</cfcase>
		<cfcase value="2">
		<cfset sortByExpression = "Order by Game_ID " & arguments.sortType>
		</cfcase>
		<cfcase value="3">
		<cfset sortByExpression = "Order by Club_Name " & arguments.sortType>
		</cfcase>
		<cfcase value="4">
		<cfset sortByExpression = "Order by TeamName " & arguments.sortType>
		</cfcase>
		<cfcase value="5">
		<cfset sortByExpression = "Order by Description " & arguments.sortType>
		</cfcase>
		<cfcase value="6">
		<cfset sortByExpression = "Order by AddByUser " & arguments.sortType>
		</cfcase>
		<cfcase value="7">
		<cfset sortByExpression = "Order by FineDateCreated " & arguments.sortType>
		</cfcase>
		<cfcase value="8">
		<cfset sortByExpression = "Order by Amount " & arguments.sortType>
		</cfcase>
		<cfcase value="9">
		<cfset sortByExpression = "Order by Status " & arguments.sortType>
		</cfcase>
		<cfdefaultcase>
		<cfset sortByExpression = "Order by Club_Name, TeamName">
		</cfdefaultcase>
		</cfswitch>
	<cfelse>
		<cfset sortByExpression = "Order by Club_Name, TeamName">
	</cfif>
	<!--- 
	Amount, 	status, 	comments, 	checkNo, 	game_id,	Club_fined_id,	Team_fined_id,	
	FineType_ID,	FineDateCreated,	FineTimeCreated,	updateddate,	checkRcvDate,	createdBy,	
	updatedBy,	appealAllowed_YN,	Description,	division_id,	game_date,	game_time,	fieldName,	
	HOME_TEAM_ID,	VISITOR_TEAM_ID,	Club_name,	teamName,
	 --->
	<CFQUERY name="getFined" datasource="#VARIABLES.DSN#">
		SELECT fine_ID,  Status, Game_ID,
			   Description, Amount,  Comments,
			   Club_Fined_ID, Club_Name,
			   Team_Fined_ID, TeamName,
			   FineDateCreated, CreatedBy, AddByUser
		  from V_Fines
		 Where 0=0
			<CFIF isDefined("ARGUMENTS.clubID") AND ARGUMENTS.clubID GT 1>
				and Club_Fined_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.clubID#">
			</CFIF>
			<cfif isdefined("arguments.seasonID")>
				and season_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.seasonID#">
			</cfif>
			<!--- 11/1/2012 J. Rab --->
			<cfif isDefined("arguments.StartDate") and isDefined("arguments.EndDate")>
				and FineDateCreated >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.StartDate#"> and FineDateCreated <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.EndDate#">
			</cfif>
			#preserveSingleQuotes(SelCriteria)#
			
		<!--- 11/1/2012 J. Rab --->
		#sortByExpression#
	</CFQUERY>

	<cfreturn getFined>

</cffunction> 



<cffunction name="getFineInfo" access="public" returntype="query">
	<cfargument name="FineID" 	  type="numeric" required="Yes"> 
	<!--- 10/13/08 - AArnone -  --->
	<CFQUERY name="qGetFineInfo" datasource="#VARIABLES.DSN#">
		SELECT Club_Fined_ID,   Club_Name,
			   Team_Fined_ID,   TeamName,
			   FineType_Id,     Amount,
			   FineDateCreated, FineTimeCreated,
			   Status,          Comments, 
			   CheckNo,   		FINE_ID,
			   AppealAllowed_YN,  Description,
			   Game_ID, 		game_date,
			   game_time,		division_id,
			   HOME_TEAM_ID,	VISITOR_TEAM_ID
		  FROM V_Fines
		 Where FINE_ID = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.FineID#">
	</CFQUERY>	
	<cfreturn qGetFineInfo>

</cffunction> 


<cffunction name="getOpStmntID" access="public" returntype="query">
	<!--- 10/27/08 - AArnone -  --->
	<CFQUERY name="getOperStmnt" datasource="#VARIABLES.DSN#">
		Select OP_STMNT_ID, STMTDATE, TITLE
		  from tbl_operatingstatement
		 Order by StmtDate Desc
	</CFQUERY>	
	<cfreturn getOperStmnt>
</cffunction> 




<cffunction name="getBalShID" access="public" returntype="query">
	<!--- 10/27/08 - AArnone -  --->
	<CFQUERY name="qGetBalShID" datasource="#VARIABLES.DSN#">
		Select BALANCESHEETID, STATEMENTDATE, title 
		  from tbl_balanceSheet
		 Order by STATEMENTDATE Desc
	</CFQUERY>	
	<cfreturn qGetBalShID>
</cffunction> 

 
 	
<!--- --------------------------
	End component fineFees	
--------------------------- --->
 </cfcomponent>	




<cfcomponent>
<CFSET DSN = SESSION.DSN>

<!--- 
	  01/05/09 - AArnone - modified updateField
	  01/10/12 - J. Rab - Added new function to only display fields based on club logged in
 --->


<!--- =================================================================== --->
<cffunction name="getAllFields" access="public" returntype="query">
	<!--- --------
		09/12/08 - AArnone - Returns ALL fields
	MODS	
		12/22/08 - aa - added request_yn <> 'y' to eliminate requested fields from the list of all fields
	----- --->
	<cfargument name="orderBy"	type="string"  required="no" default="id">
	
	<cfswitch expression="#UCASE(ARGUMENTS.orderBy)#">
		<cfcase value="NAME">
			<CFSET orderBy = "order by FIELDNAME">
		</cfcase>
		<cfcase value="ABBRV">
			<CFSET orderBy = "order by FIELDABBR">
		</cfcase>
		<cfdefaultcase>
			<CFSET orderBy = "order by FIELD_ID">
		</cfdefaultcase>
	</cfswitch>
	
	<CFQUERY name="qGetDirs" datasource="#VARIABLES.DSN#">
		SELECT FIELD_ID, FIELDABBR, FIELDNAME, 
			   ADDRESS, CITY, STATE, ZIPCODE, DIRECTIONS,
			   FIELDSIZE, FIELDSIZECOMMENT, LIGHTS_YN, TURF_TYPE,
			   Day1, Day1TimeFrom, day1TimeTo, day1comment,
			   Day2, Day2TimeFrom, day2TimeTo, day2comment,
			   exceptions, Active_YN, REQUEST_YN, APPROVED
		  FROM TBL_FIELD 
		 WHERE REQUEST_YN <> 'Y'  
		    OR REQUEST_YN IS NULL
		  #orderBy#
	</CFQUERY>

	<cfreturn qGetDirs>
</cffunction>

<!--- =================================================================== --->
<cffunction name="getAllFieldDropDown" access="public" returntype="struct">
	<!--- --------
		10/01/08 - AArnone - Returns a structure with 2 query result sets 1 with all fields minus TBS fields, other with TBS fields
	----- --->
	<cfset stFieldResults = structNew()>
	<CFQUERY name="qRegFields" datasource="#VARIABLES.DSN#">
		Select FIELD_ID, FieldName, FieldAbbr
		  FROM TBL_FIELD
		 Where FieldAbbr is not NULL
		   and ACTIVE_YN = 'Y'
		 Order by FieldAbbr
	</CFQUERY>
	<cfset stFieldResults.regFields = qRegFields>
	
	<CFQUERY name="qTBSfields" datasource="#VARIABLES.DSN#">
		SELECT F.field_id, F.fieldAbbr, F.fieldName
		  FROM TBL_FIELD F  INNER JOIN XREF_CLUB_FIELD xcf ON xcf.field_id = F.field_id
		 WHERE XCF.CLUB_ID = 1
		  and f.Active_YN = 'Y'
	</CFQUERY>
	<cfset stFieldResults.tbsFields = qTBSfields>

	<cfreturn stFieldResults>
</cffunction>

<!--- =================================================================== --->
<cffunction name="getAllFieldDropDownPerClub" access="public" returntype="struct">
	<!--- --------
		01/10/2012 	-	J. Rab	-	Added new Component function to get fields based on specific club instead of all fields
	----- --->
	<cfargument name="clubID"	type="numeric" required="no" >
	
	<cfset stFieldResults = structNew()>
	<CFQUERY name="qRegFields" datasource="#VARIABLES.DSN#">
		SELECT xcf.club_id,xcf.field_id, f.field_id, f.fieldAbbr, f.fieldName
		  FROM xref_club_field xcf inner join tbl_field f on (f.field_id = xcf.field_id)
		  where xcf.club_id = #Arguments.clubID#
			 and f.FieldAbbr is not NULL
			   and f.ACTIVE_YN = 'Y'
			 Order by f.FieldAbbr
	</CFQUERY>
	<cfset stFieldResults.regFields = qRegFields>
	
	<CFQUERY name="qTBSfields" datasource="#VARIABLES.DSN#">
		SELECT F.field_id, F.fieldAbbr, F.fieldName
		  FROM TBL_FIELD F  INNER JOIN XREF_CLUB_FIELD xcf ON xcf.field_id = F.field_id
		 WHERE XCF.CLUB_ID = 1
		  and f.Active_YN = 'Y'
	</CFQUERY>
	<cfset stFieldResults.tbsFields = qTBSfields>

	<cfreturn stFieldResults>
</cffunction>

<!--- =================================================================== --->
<cffunction name="getFields" access="public" returntype="query">
	<!--- --------
		08/11/08 - AArnone - New function: Returns a list of fields
	----- --->
	<cfargument name="clubID"	type="numeric" required="no" >
	<cfargument name="orderBy"	type="string"  required="no" default="id">
	
	<cfswitch expression="#UCASE(ARGUMENTS.orderBy)#">
		<cfcase value="CLUB">
			<CFSET orderBy = "order by c.CLUB_NAME, f.FIELDNAME">
		</cfcase>
		<cfcase value="NAME">
			<CFSET orderBy = "order by f.FIELDNAME">
		</cfcase>
		<cfcase value="ABBRV">
			<CFSET orderBy = "order by f.FIELDABBR">
		</cfcase>
		<cfdefaultcase>
			<CFSET orderBy = "order by f.FIELD_ID">
		</cfdefaultcase>
	</cfswitch>

	<CFIF isDefined("ARGUMENTS.clubID") and ARGUMENTS.clubID GT 0>
		<CFSET andClubid = " AND C.CLUB_ID = " & ARGUMENTS.clubID >
	<CFELSE>
		<CFSET andClubid = " AND C.CLUB_ID <> 1" >
	</CFIF>
	
	<CFQUERY name="qGetFields" datasource="#VARIABLES.DSN#">
		SELECT f.FIELD_ID, f.FIELDABBR, f.FIELDNAME, f.CITY, 
			   f.APPROVED, f.REQUEST_YN, f.LIGHTS_YN, f.TURF_TYPE, 
			   c.CLUB_ID, c.CLUB_NAME, xcf.active_yn
		  From XREF_CLUB_FIELD xcf
					INNER JOIN TBL_CLUB  C ON C.CLUB_ID = xcf.CLUB_ID
					INNER JOIN TBL_FIELD F ON F.FIELD_ID = xcf.FIELD_ID
		 WHERE F.ACTIVE_YN = 'Y'
		   AND XCF.ACTIVE_YN = 'Y'
		  #andClubid#
		  #orderBy#
	</CFQUERY>

	<cfreturn qGetFields>
</cffunction>

<!--- =================================================================== --->
<cffunction name="getClubPrimaryFields" access="public" returntype="query">
	<!--- --------
		08/11/08 - AArnone - New function: Returns a list of fields where the club id passed is the primary club
	----- --->
	<cfargument name="clubID"	type="numeric" required="no" >
	<cfargument name="orderBy"	type="string"  required="no" default="id">
	
	<cfswitch expression="#UCASE(ARGUMENTS.orderBy)#">
		<cfcase value="CLUB">
			<CFSET orderBy = "order by c.CLUB_NAME, f.FIELDNAME">
		</cfcase>
		<cfcase value="NAME">
			<CFSET orderBy = "order by f.FIELDNAME">
		</cfcase>
		<cfcase value="ABBRV">
			<CFSET orderBy = "order by f.FIELDABBR">
		</cfcase>
		<cfdefaultcase>
			<CFSET orderBy = "order by f.FIELD_ID">
		</cfdefaultcase>
	</cfswitch>

	<CFIF isDefined("ARGUMENTS.clubID") and ARGUMENTS.clubID GT 0>
		<CFSET andClubid = " AND F.CLUB_ID = " & ARGUMENTS.clubID >
	<CFELSE>
		<CFSET andClubid = " AND F.CLUB_ID <> 1" >
	</CFIF>
	
	<CFQUERY name="qGetPrimaryFields" datasource="#VARIABLES.DSN#">
		SELECT f.FIELD_ID, f.FIELDABBR, f.FIELDNAME, f.CITY, 
			   f.APPROVED, f.REQUEST_YN, f.LIGHTS_YN, f.TURF_TYPE, 
			   c.CLUB_ID, c.CLUB_NAME, xcf.active_yn
		  From TBL_FIELD F
				INNER JOIN TBL_CLUB  C ON C.CLUB_ID = f.CLUB_ID
				INNER JOIN XREF_CLUB_FIELD xcf ON xcf.FIELD_ID = F.FIELD_ID
		 WHERE F.ACTIVE_YN = 'Y'
		   AND XCF.ACTIVE_YN = 'Y'
		  #andClubid#
		  #orderBy#
	</CFQUERY>

	<cfreturn qGetPrimaryFields>
</cffunction>

<!--- =================================================================== --->
<cffunction name="getRequestedFields" access="public" returntype="query">
	<!--- --------
		11/12/08 - AArnone - New function: Returns a list of fields that were requested by a club
	----- --->
	<cfargument name="clubID"	type="numeric" required="no" >
	<cfargument name="orderBy"	type="string"  required="no" default="id">
	
	<cfswitch expression="#UCASE(ARGUMENTS.orderBy)#">
		<cfcase value="NAME">
			<CFSET orderBy = "order by F.FIELDNAME">
		</cfcase>
		<cfcase value="ABBRV">
			<CFSET orderBy = "order by f.FIELDABBR">
		</cfcase>
		<cfcase value="CLUBABBR">
			<CFSET orderBy = "order by c.CLUBABBR, f.FIELDABBR">
		</cfcase>
		<cfdefaultcase>
			<CFSET orderBy = "order by FIELD_ID">
		</cfdefaultcase>
	</cfswitch>

	<CFIF isDefined("ARGUMENTS.clubID") and ARGUMENTS.clubID GT 0>
		<CFSET andClubid = " AND C.CLUB_ID = " & ARGUMENTS.clubID >
	<CFELSE>
		<CFSET andClubid = " AND C.CLUB_ID <> 1" >
	</CFIF>
	
	<CFQUERY name="qGetRequestedFields" datasource="#VARIABLES.DSN#">
		SELECT f.FIELD_ID, f.FIELDABBR, f.FIELDNAME, f.CITY, 
			   f.APPROVED, f.REQUEST_YN, f.LIGHTS_YN, f.TURF_TYPE, 
			   c.CLUB_NAME, c.CLUBABBR, 
			   xcf.active_yn, f.APPROVED, f.REQUEST_YN
		  From XREF_CLUB_FIELD xcf
					INNER JOIN TBL_CLUB  C ON C.CLUB_ID = xcf.CLUB_ID
					INNER JOIN TBL_FIELD F ON F.FIELD_ID = xcf.FIELD_ID
		 WHERE F.REQUEST_YN = 'Y'
		  #andClubid#
		  #orderBy#
	</CFQUERY>

	<cfreturn qGetRequestedFields>
</cffunction>



	

<!--- =================================================================== --->
<cffunction name="getDirections" access="public" returntype="query">
	<!--- --------
		08/11/08 - AArnone - New function: Returns the directions for a given field

	<cfinvoke component="#SESSION.SITEVARS.cfcPath#FIELD" method="getDirections" returnvariable="qField">
		<cfinvokeargument name="fieldID" value="#.#">
	</cfinvoke>
	----- --->
	<cfargument name="fieldID"	type="numeric" required="no" >
	
	<CFQUERY name="qGetDirs" datasource="#VARIABLES.DSN#">
		SELECT FIELD_ID, FIELDABBR, FIELDNAME, 
			   ADDRESS, CITY, STATE, ZIPCODE, DIRECTIONS,
			   FIELDSIZE, FIELDSIZECOMMENT, LIGHTS_YN, TURF_TYPE,
			   Day1, Day1TimeFrom, day1TimeTo, day1comment,
			   Day2, Day2TimeFrom, day2TimeTo, day2comment,
			   exceptions, Active_YN, REQUEST_YN, APPROVED, CLUB_ID
		  From TBL_FIELD 
		 WHERE FIELD_ID = #ARGUMENTS.fieldID#
	</CFQUERY>

	<cfreturn qGetDirs>
</cffunction>
	
	

<!--- =================================================================== --->
<cffunction name="getRegFields" access="public" returntype="query">
	<cfargument name="clubID"	type="numeric" required="no" >
	<!--- 09/11/08 - AArnone - returns reg fields
	----- --->
	<CFQUERY name="qRegfields" datasource="#VARIABLES.DSN#">
		SELECT xcf.club_id,
			   xcf.active_yn as active_Club_filed_YN, 
			   f.Active_YN as active_field_YN,
			   f.field_id, f.fieldAbbr, f.fieldName,f.Approved
		  FROM xref_club_field xcf INNER JOIN tbl_field f ON f.Field_id = xcf.Field_id
		 WHERE xcf.club_id = #ARGUMENTS.clubID#
	</CFQUERY>

	<cfreturn qRegfields>
</cffunction>


<!--- =================================================================== --->
<cffunction name="getRegFieldCount" access="public" returntype="struct">
	<cfargument name="clubID"	type="numeric" required="no" >
	<!--- 09/17/08 - AArnone - returns counts of reg fields
	----- --->
	<CFSET stRegFieldCounts = structNew()>
	<CFSET stRegFieldCounts.total = 0 >
	<CFSET stRegFieldCounts.approved = 0>

	<cfinvoke method="getRegFields"  returnvariable="qGetFields">
		<cfinvokeargument name="clubID" value="#trim(ARGUMENTS.clubID)#"> 
	</cfinvoke> 

	<CFSET stRegFieldCounts.total = qGetFields.RECORDCOUNT >

	<CFIF qGetFields.RECORDCOUNT>
		<CFQUERY name="qApproved" dbtype="query">
			SELECT field_id
			  FROM qGetFields
			 WHERE active_Club_filed_YN = 'Y'
		</CFQUERY>
		<CFSET stRegFieldCounts.approved = qApproved.RECORDCOUNT >
	</CFIF>

	<cfreturn stRegFieldCounts>
</cffunction>


<!--- =================================================================== --->
<cffunction name="approvefield" access="public" >
	<cfargument name="fieldID"	type="numeric" required="no" >
	<!--- 09/12/08 - AArnone - sets active to "Y"
	----- --->
	<CFQUERY name="qAppField" datasource="#VARIABLES.DSN#">
		Update TBL_FIELD
		   set Approved = 'Y'
		 Where Field_ID = #ARGUMENTS.fieldID#
	</CFQUERY>
</cffunction>

<!--- =================================================================== --->
<cffunction name="insertField" access="public" >
	<!--- 09/11/08 - AArnone - 
	----- --->
	<cfargument name="FieldAbbr"	 type="string" required="yes">
	<cfargument name="Field"		 type="string" required="yes">
	<cfargument name="address"		 type="string" required="yes">
	<cfargument name="city"			 type="string" required="yes">
	<cfargument name="state"		 type="string" required="yes">
	<cfargument name="Zip"		 	 type="string" required="yes">
	<cfargument name="directions"	 type="string" required="yes">
	<cfargument name="fieldSize"	 type="string" required="yes">
	<cfargument name="fieldSizeComment" type="string" required="yes">
	<cfargument name="lightsYN" 	 type="string" required="Yes">
	<cfargument name="turfType" 	 type="string" required="Yes">
	<cfargument name="day1"			 type="string" required="yes">
	<cfargument name="day1TimeFrom"	 type="string" required="yes">
	<cfargument name="day1TimeTo"	 type="string" required="yes">
	<cfargument name="day1Comments"	 type="string" required="yes">
	<cfargument name="day2"			 type="string" required="yes">
	<cfargument name="day2TimeFrom"  type="string" required="yes">
	<cfargument name="day2TimeTo"	 type="string" required="yes">
	<cfargument name="day2Comments"	 type="string" required="yes">
	<cfargument name="exceptions"	 type="string" required="yes">
	<cfargument name="activeYN"		 type="string" required="yes">
	<cfargument name="ContactID"	 type="numeric" required="yes">
	<cfargument name="Approved"		 type="string" required="yes">
	<cfargument name="ClubId"		 type="numeric" required="yes">
	<cfargument name="requestYN"	 type="string" required="yes">

	<cfstoredproc procedure="p_insert_field" datasource="#VARIABLES.DSN#">
 		<cfprocparam dbvarname="@fieldAbbr" 	cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.FieldAbbr#"> 
		<cfprocparam dbvarname="@fieldName" 	cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.Field#">
		<cfprocparam dbvarname="@address" 		cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.address#">
		<cfprocparam dbvarname="@city" 			cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.city#">
		<cfprocparam dbvarname="@state" 		cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.state#">
		<cfprocparam dbvarname="@zipcode" 		cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.Zip#">
		<cfprocparam dbvarname="@directions" 	cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.directions#">
		<cfprocparam dbvarname="@fieldSize" 	cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.fieldSize#">
		<cfprocparam dbvarname="@fieldSizeComment" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.fieldSizeComment#">
		<cfprocparam dbvarname="@lightsYN" 	 	cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.lightsYN#">
		<cfprocparam dbvarname="@turfType" 	 	cfsqltype="CF_SQL_VARCHAR"	  value="#ARGUMENTS.turfType#">
		<cfprocparam dbvarname="@day1" 			cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.day1#">
		<cfprocparam dbvarname="@day1TimeFrom" 	cfsqltype="CF_SQL_TIMESTAMP"  value="#ARGUMENTS.day1TimeFrom#">
		<cfprocparam dbvarname="@day1TimeTo" 	cfsqltype="CF_SQL_TIMESTAMP"  value="#ARGUMENTS.day1TimeTo#">
		<cfprocparam dbvarname="@day1Comment" 	cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.day1Comments#">
		<cfprocparam dbvarname="@day2" 			cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.day2#">
		<cfprocparam dbvarname="@day2TimeFrom" 	cfsqltype="CF_SQL_TIMESTAMP"  value="#ARGUMENTS.day2TimeFrom#">
		<cfprocparam dbvarname="@day2TimeTo" 	cfsqltype="CF_SQL_TIMESTAMP"  value="#ARGUMENTS.day2TimeTo#">
		<cfprocparam dbvarname="@day2Comment" 	cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.day2Comments#">
		<cfprocparam dbvarname="@exceptions" 	cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.exceptions#">
		<cfprocparam dbvarname="@Active_YN" 	cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.activeYN#">
		<cfprocparam dbvarname="@CreatedBy" 	cfsqltype="CF_SQL_NUMERIC" 	  value="#ARGUMENTS.ContactID#">
		<cfprocparam dbvarname="@Approved" 		cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.Approved#" null="#YesNoFormat(NOT(len(ARGUMENTS.Approved)))#">
		<cfprocparam dbvarname="@club_id" 		cfsqltype="CF_SQL_NUMERIC" 	  value="#ARGUMENTS.ClubId#">
		<cfprocparam dbvarname="@request_YN" 	cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.requestYN#" null="#YesNoFormat(NOT(len(ARGUMENTS.requestYN)))#">
	</cfstoredproc>  

</cffunction>
	

<!--- =================================================================== --->
<cffunction name="UpdateField" access="public" >
	<!--- 09/11/08 - AArnone - 
		  01/05/09 - AArnone - Added Field Abbr to P_UPDATE_FIELD.
	----- --->
	<cfargument name="FieldID"			type="numeric" required="yes">
	<cfargument name="Field"			type="string" required="yes">
	<cfargument name="FieldAbbr"		type="string" required="yes">
	<cfargument name="address"			type="string" required="yes">
	<cfargument name="city"				type="string" required="yes">
	<cfargument name="state"			type="string" required="yes">
	<cfargument name="Zip"				type="string" required="yes">
	<cfargument name="directions"		type="string" required="yes">
	<cfargument name="fieldSize"		type="string" required="yes">
	<cfargument name="fieldSizeComment"	type="string" required="yes">
	<cfargument name="lightsYN" 	 type="string" required="Yes">
	<cfargument name="turfType" 	 type="string" required="Yes">
	<cfargument name="day1"				type="string" required="yes">
	<cfargument name="day1TimeFrom"		type="string" required="yes">
	<cfargument name="day1TimeTo"		type="string" required="yes">
	<cfargument name="day1Comments"		type="string" required="yes">
	<cfargument name="day2"				type="string" required="yes">
	<cfargument name="day2TimeFrom"		type="string" required="yes">
	<cfargument name="day2TimeTo"		type="string" required="yes">
	<cfargument name="day2Comments"		type="string" required="yes">
	<cfargument name="exceptions"		type="string" required="yes">
	<cfargument name="ContactID"		type="numeric" required="yes">


	<cfstoredproc procedure="p_update_field" datasource="#VARIABLES.DSN#">
		<cfprocparam dbvarname="@field_id" 		cfsqltype="CF_SQL_NUMERIC"   value="#ARGUMENTS.FieldID#">
		<cfprocparam dbvarname="@fieldName" 	cfsqltype="CF_SQL_VARCHAR"   value="#ARGUMENTS.Field#">
		<cfprocparam dbvarname="@fieldAbbr" 	cfsqltype="CF_SQL_VARCHAR"   value="#ARGUMENTS.FieldAbbr#">
		<cfprocparam dbvarname="@address" 		cfsqltype="CF_SQL_VARCHAR"   value="#ARGUMENTS.address#">
		<cfprocparam dbvarname="@city" 			cfsqltype="CF_SQL_VARCHAR"   value="#ARGUMENTS.city#">
		<cfprocparam dbvarname="@state" 		cfsqltype="CF_SQL_VARCHAR"   value="#ARGUMENTS.state#">
		<cfprocparam dbvarname="@zipcode" 		cfsqltype="CF_SQL_VARCHAR"   value="#ARGUMENTS.Zip#">
		<cfprocparam dbvarname="@directions" 	cfsqltype="CF_SQL_VARCHAR"   value="#ARGUMENTS.directions#">
		<cfprocparam dbvarname="@fieldSize" 	cfsqltype="CF_SQL_VARCHAR"   value="#ARGUMENTS.fieldSize#">
		<cfprocparam dbvarname="@fieldSizeComment" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.fieldSizeComment#">
		<cfprocparam dbvarname="@lightsYN" 	 	cfsqltype="CF_SQL_VARCHAR" 	  value="#ARGUMENTS.lightsYN#">
		<cfprocparam dbvarname="@turfType" 	 	cfsqltype="CF_SQL_VARCHAR"	  value="#ARGUMENTS.turfType#">
		<cfprocparam dbvarname="@day1" 			cfsqltype="CF_SQL_VARCHAR"   value="#ARGUMENTS.day1#">
		<cfprocparam dbvarname="@day1TimeFrom" 	cfsqltype="CF_SQL_TIMESTAMP" value="#ARGUMENTS.day1TimeFrom#">
		<cfprocparam dbvarname="@day1TimeTo" 	cfsqltype="CF_SQL_TIMESTAMP" value="#ARGUMENTS.day1TimeTo#">
		<cfprocparam dbvarname="@day1Comment" 	cfsqltype="CF_SQL_VARCHAR"   value="#ARGUMENTS.day1Comments#">
		<cfprocparam dbvarname="@day2" 			cfsqltype="CF_SQL_VARCHAR"   value="#ARGUMENTS.day2#">
		<cfprocparam dbvarname="@day2TimeFrom" 	cfsqltype="CF_SQL_TIMESTAMP" value="#ARGUMENTS.day2TimeFrom#">
		<cfprocparam dbvarname="@day2TimeTo" 	cfsqltype="CF_SQL_TIMESTAMP" value="#ARGUMENTS.day2TimeTo#">
		<cfprocparam dbvarname="@day2Comment" 	cfsqltype="CF_SQL_VARCHAR"   value="#ARGUMENTS.day2Comments#">
		<cfprocparam dbvarname="@exceptions" 	cfsqltype="CF_SQL_VARCHAR"   value="#ARGUMENTS.exceptions#">
		<cfprocparam dbvarname="@UpdatedBy" 	cfsqltype="CF_SQL_NUMERIC"   value="#ARGUMENTS.ContactID#">
	</cfstoredproc>  

	<!--- <cfreturn qFieldID> --->
</cffunction>
		

<!--- =================================================================== --->
<cffunction name="removeFieldFromClub" access="public" >
	<!--- 09/12/08 - AArnone - disassociates a field from a club
	----- --->
	<cfargument name="ClubID"	type="numeric" required="yes">
	<cfargument name="FieldID"	type="numeric" required="yes">

	<CFQUERY name="removefield" datasource="#VARIABLES.DSN#"> 
		Delete XREF_CLUB_FIELD
		 Where Club_ID  = #ARGUMENTS.ClubID#
		   and Field_ID = #ARGUMENTS.FieldID#
	</CFQUERY>
</cffunction>






<!--- =================================================================== --->

<cffunction name="mapFieldToClub" access="public" >
	<!--- 09/16/08 - AArnone - associates a field(s) to a club
	----- --->
	<cfargument name="clubID"   type="numeric" required="Yes">
	<cfargument name="fieldIDs" type="string" required="Yes">

	<CFLOOP list="#ARGUMENTS.fieldIDs#" index="iFid">
		<CFQUERY name="qFindMapping" datasource="#VARIABLES.DSN#">
			SELECT FIELD_ID
			  From XREF_CLUB_FIELD
			 WHERE CLUB_ID  = #ARGUMENTS.clubID# 
			   AND FIELD_ID = #iFid#
		</cfquery>
		
		<CFIF qFindMapping.recordCount>
			<cfquery name="qFindMapping" datasource="#VARIABLES.DSN#">
				UPDATE XREF_CLUB_FIELD
				   SET ACTIVE_YN = 'Y'
				 WHERE CLUB_ID  = #ARGUMENTS.clubID# 
				   AND FIELD_ID = #iFid#
			</cfquery>
		<CFELSE>
			<cfquery name="qFindMapping" datasource="#VARIABLES.DSN#">
				INSERT INTO XREF_CLUB_FIELD
					(CLUB_ID, FIELD_ID, ACTIVE_YN)
				VALUES
					(#ARGUMENTS.clubID#, #iFid#, 'Y')
			</cfquery>
		</CFIF>
	</CFLOOP>

</cffunction>
<!--- =================================================================== --->
<cffunction name="mapRemoveFieldFromClub" access="public" >
	<!--- 09/16/08 - AArnone - disassociates a field(s) FROM a club
	----- --->
	<cfargument name="clubID"   type="numeric" required="Yes">
	<cfargument name="fieldIDs" type="string" required="Yes">

	<CFLOOP list="#ARGUMENTS.fieldIDs#" index="iFid">
		<cfquery name="qFindMapping" datasource="#VARIABLES.DSN#">
			DELETE XREF_CLUB_FIELD
			 WHERE CLUB_ID  = #ARGUMENTS.clubID# 
			   AND FIELD_ID = #iFid#
		</cfquery>
	</CFLOOP>


</cffunction>



<!--- =================================================================== --->
<cffunction name="getAssignedClubs" access="public" returntype="query">
	<!--- 09/26/08 - AArnone - returns Primary club and clubs mapped to a field
	----- --->
	<cfargument name="fieldID" type="string" required="Yes">
	<CFQUERY name="qGetFields" datasource="#VARIABLES.DSN#">
		SELECT c.Club_id, c.CLUB_NAME, c.CLUBABBR
		  From XREF_CLUB_FIELD xcf
					INNER JOIN TBL_CLUB  C ON C.CLUB_ID = xcf.CLUB_ID
					INNER JOIN TBL_FIELD F ON F.FIELD_ID = xcf.FIELD_ID
		 WHERE f.FIELD_ID = #ARGUMENTS.fieldID#
		   AND XCF.ACTIVE_YN = 'Y'
	</CFQUERY>
 	<cfreturn qGetFields>
</cffunction>




<!--- =================================================================== --->
<cffunction name="getAssignorFields" access="public" returntype="query">
	<!--- --------
		11/04/08 - AArnone - New function: Returns a list of fields assigned to a referee assignor
	----- --->
	<cfargument name="AssignorContactID"	type="numeric" required="no" >
	<cfargument name="orderBy"	type="string"  required="no" default="id">
	
	<cfswitch expression="#UCASE(ARGUMENTS.orderBy)#">
		<cfcase value="NAME">
			<CFSET orderBy = "order by FIELDNAME">
		</cfcase>
		<cfcase value="ABBRV">
			<CFSET orderBy = "order by FIELDABBR">
		</cfcase>
		<cfdefaultcase>
			<CFSET orderBy = "order by FIELD_ID">
		</cfdefaultcase>
	</cfswitch>

	<CFIF isDefined("ARGUMENTS.AssignorContactID") and ARGUMENTS.AssignorContactID GT 0>
		<CFSET andContactID = " AND xaf.ASSIGNOR_CONTACT_ID = " & ARGUMENTS.AssignorContactID >
	<CFELSE>
		<CFSET andContactID = " AND xaf.ASSIGNOR_CONTACT_ID <> 1" >
	</CFIF>
	
	<CFQUERY name="qGetFields" datasource="#VARIABLES.DSN#">
		SELECT f.FIELD_ID, f.FIELDABBR, f.FIELDNAME, f.CITY
		  From XREF_ASSIGNOR_FIELD xaf
					INNER JOIN TBL_FIELD F ON F.FIELD_ID = xaf.FIELD_ID
		 WHERE F.ACTIVE_YN = 'Y'
		  #andContactID#
		  #orderBy#
	</CFQUERY>

	<cfreturn qGetFields>
</cffunction>
	

<!--- =================================================================== --->
<cffunction name="getAssignorFieldsUnassigned" access="public" returntype="query">
	<!--- --------
		11/04/08 - AArnone - New function: Returns a list of fields NOT assigned to ANY referee assignor
	----- --->
	<cfargument name="orderBy"	type="string"  required="no" default="id">
	<cfargument name="AssignorContactID"	type="numeric" required="no">
	
	<cfswitch expression="#UCASE(ARGUMENTS.orderBy)#">
		<cfcase value="NAME">
			<CFSET orderBy = "order by FIELDNAME">
		</cfcase>
		<cfcase value="ABBRV">
			<CFSET orderBy = "order by FIELDABBR">
		</cfcase>
		<cfdefaultcase>
			<CFSET orderBy = "order by FIELD_ID">
		</cfdefaultcase>
	</cfswitch>

	<CFQUERY name="qGetUnassinedFields" datasource="#VARIABLES.DSN#">
		SELECT f.FIELD_ID, f.FIELDABBR, f.FIELDNAME, f.CITY
		  From TBL_FIELD F 
		 WHERE f.FIELD_ID NOT IN 
		 		<cfif isDefined("ARGUMENTS.AssignorContactID") AND ARGUMENTS.AssignorContactID GT 0>
			 		(SELECT FIELD_ID FROM XREF_ASSIGNOR_FIELD where ASSIGNOR_CONTACT_ID = #ARGUMENTS.AssignorContactID#)
		 		<cfelse>
			 		(SELECT FIELD_ID FROM XREF_ASSIGNOR_FIELD)
				</cfif>		 
		   AND F.ACTIVE_YN = 'Y'
		   AND F.CLUB_ID <> 1
		  #orderBy#
	</CFQUERY>

	<cfreturn qGetUnassinedFields>
</cffunction>
	

<!--- =================================================================== --->

<cffunction name="mapFieldToRefAssignor" access="public" >
	<!--- 11/04/08 - AArnone - associates a field(s) to a Ref Assignor
	----- --->
	<cfargument name="assignorContactID"   type="numeric" required="Yes">
	<cfargument name="fieldIDs" type="string" required="Yes">

	<CFLOOP list="#ARGUMENTS.fieldIDs#" index="iFid">
		<cfquery name="qFindMapping" datasource="#VARIABLES.DSN#">
			INSERT INTO XREF_ASSIGNOR_FIELD
				( ASSIGNOR_CONTACT_ID, FIELD_ID )
			VALUES
				( #ARGUMENTS.assignorContactID#, #iFid# )
		</cfquery>
	</CFLOOP>
</cffunction>

<!--- =================================================================== --->
<cffunction name="mapRemoveFieldFromRefAssignor" access="public" >
	<!--- 11/04/08 - AArnone - disassociates a field(s) FROM a RefAssignor
	----- --->
	<cfargument name="assignorContactID"   type="numeric" required="Yes">
	<cfargument name="fieldIDs" type="string" required="Yes">

	<CFLOOP list="#ARGUMENTS.fieldIDs#" index="iFid">
		<cfquery name="qFindMapping" datasource="#VARIABLES.DSN#">
			DELETE XREF_ASSIGNOR_FIELD
			 WHERE ASSIGNOR_CONTACT_ID  = #ARGUMENTS.assignorContactID# 
			   AND FIELD_ID = #iFid#
		</cfquery>
	</CFLOOP>


</cffunction>


<!--- =================================================================== --->
<cffunction name="getFieldAvailability" access="public" returntype="query" >
	<!--- 12/23/08 - AArnone - get availability for a field for specified season
	----- --->
	<cfargument name="fieldID"  type="numeric" required="Yes">
	<cfargument name="seasonID" type="numeric" required="Yes">

	<cfquery name="getplayweeks" datasource="#VARIABLES.DSN#">
		SELECT x.PLAYWEEKEND_ID, 
			   x.SAT_AVAIL_YN, x.SAT_TIME_FROM, x.SAT_TIME_TO,
			   x.SUN_AVAIL_YN, x.SUN_TIME_FROM, x.SUN_TIME_TO,
			   pw.WEEK_NUMBER, pw.Day1_Date, pw.Day2_Date
		  FROM XREF_FIELD_WEEKEND x inner join tbl_playweekend pw ON pw.playweekend_ID = x.playweekend_id
		 WHERE x.FIELD_ID = #ARGUMENTS.fieldID#
		   AND x.SEASON_ID = #ARGUMENTS.seasonID#
		   order by pw.week_number
	</cfquery>
	
	<CFIF getPlayWeeks.RECORDCOUNT EQ 0>
		<!--- no playweeks was found for this field during the season provided, get the last season that was played --->
		<!--- <cfquery name="getMax" datasource="#VARIABLES.DSN#">
			SELECT MAX(SEASON_ID) as maxSeasonID
			  FROM XREF_FIELD_WEEKEND
			 WHERE FIELD_ID = #ARGUMENTS.fieldID#
		</cfquery>
		<CFIF getMax.recordCount AND len(trim(getMax.maxSeasonID)) >
			<!--- past season was found --->
			<cfquery name="getplayweeks" datasource="#VARIABLES.DSN#">
				SELECT x.PLAYWEEKEND_ID, 
					   x.SAT_AVAIL_YN, x.SAT_TIME_FROM, x.SAT_TIME_TO,
					   x.SUN_AVAIL_YN, x.SUN_TIME_FROM, x.SUN_TIME_TO,
					   pw.WEEK_NUMBER, pw.Day1_Date, pw.Day2_Date
				  FROM XREF_FIELD_WEEKEND x inner join tbl_playweekend pw ON pw.playweekend_ID = x.playweekend_id
				 WHERE x.FIELD_ID = #ARGUMENTS.fieldID#
				   AND x.SEASON_ID = #getMax.maxSeasonID#	
			</cfquery>
		<CFELSE> --->
			<!--- nothing was found, create an empty resultset --->
			<cfquery name="getplayweeks" datasource="#VARIABLES.DSN#">
				SELECT PLAYWEEKEND_ID, WEEK_NUMBER,
					   Day1_Date, Day2_Date,
					   NULL as SAT_AVAIL_YN, 
					   NULL as SAT_TIME_FROM, 
					   NULL as SAT_TIME_TO,
					   NULL as SUN_AVAIL_YN, 
					   NULL as SUN_TIME_FROM, 
					   NULL as SUN_TIME_TO
				  FROM TBL_PLAYWEEKEND
				 WHERE SEASON_ID = #ARGUMENTS.seasonID#	
				 order by week_number
			</cfquery>
		<!--- </CFIF> --->
	
	</CFIF>
		
	<cfreturn getplayweeks>

</cffunction>

<cffunction
	name="searchFields"
	description="Search fields for given name"
	access="public"
	returntype="query">
	<cfargument name="qry" type="string" required="Yes">
	
	<cfquery datasource="#application.dsn#" name="getFields">
		SELECT FIELD_ID, FIELDABBR, FIELDNAME, 
			a.ADDRESS, a.CITY, a.STATE, a.ZIPCODE, DIRECTIONS,
			FIELDSIZE, FIELDSIZECOMMENT, LIGHTS_YN, TURF_TYPE,
			Day1, Day1TimeFrom, day1TimeTo, day1comment,
			Day2, Day2TimeFrom, day2TimeTo, day2comment,
			exceptions, a.Active_YN, REQUEST_YN, APPROVED, b.club_name
		FROM TBL_FIELD a
		left join tbl_club b
		on a.club_id=b.club_id
		where fieldabbr like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#arguments.qry#%">
		or a.fieldname like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#arguments.qry#%">
		or a.address like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#arguments.qry#%">
		or a.city like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#arguments.qry#%">
	</cfquery>
	
	<cfreturn getFields>
	
</cffunction>

<cffunction
	name="mergeFields"
	access="public"
	description="merges multiple fields into one"
	returntype="boolean">
	<cfargument name="keepField" type="string" required="Yes">
	<cfargument name="deleteFieldList" type="string" required="Yes">
	
	<cfloop list="#arguments.deleteFieldList#" index="i">
		<cfstoredproc datasource="#application.dsn#" procedure="p_merge_fields">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@keepField" type="In" value="#arguments.keepField#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@delField" type="In" value="#i#">
		</cfstoredproc>
	</cfloop>
	
	<cfreturn true>
	
</cffunction>





<!--- ---------------------------------------------------
	  END Component field
---------------------------------------------------- --->
</cfcomponent>
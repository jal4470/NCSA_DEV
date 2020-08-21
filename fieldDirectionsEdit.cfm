<!--- 
	FileName:	fieldDirectionsEdit.cfm
	Created on: 09/11/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: This is used for BOTH editing an existing feild AND adding a new field
	
MODS: mm/dd/yyyy - filastname - comments
12/18/08 - AA - changed field size to drop down
			- changed how time was processed, day1&2 to SAT&SUN
01/05/09 - AA - Added Field Abbr to UPDATE FIELD.
		 - AA - commented out "txtDisabled" so values are editable during aproval
		 - AA - Removed DAY1 and DAY2 times - will now be done thru field availability
01/26/09 - AA - fieldAbbr limited to 20 chars.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfset errorMessage = "">

<CFIF listFindNoCase(SESSION.CONSTANT.CUROLES,SESSION.MENUROLEID)>
	<CFSET swClubUser = true>
<CFELSE>
	<CFSET swClubUser = false>
</CFIF>

<CFIF isdefined("URL.CID")>
	<CFSET clubID = URL.CID>
<CFELSEIF isDefined("FORM.clubID")>
	<CFSET clubID = FORM.clubID>
<CFELSE>
	<CFSET clubID = 0>
</CFIF>

<CFIF isdefined("URL.fid")>
	<CFSET fieldID = URL.fid>
<CFELSEIF isDefined("FORM.fieldID")>
	<CFSET fieldID = FORM.fieldID>
<CFELSE>
	<CFSET fieldID = 0>
</CFIF>

<CFIF isDefined("FORM.swAllowEdit")>
	<CFSET swAllowEdit = FORM.swAllowEdit>
<CFELSE>
	<CFSET swAllowEdit = false>
</CFIF>

<CFIF isdefined("URL.m")>
	<CFSET mode = UCASE(URL.m)>
<CFELSEIF isDefined("FORM.mode")>
	<CFSET mode = UCASE(FORM.mode)>
<CFELSE>
	<CFSET mode = "">
</CFIF>

<!--- initialize varaibles --->
<CFIF isDefined("FORM.DIRECTIONS")>		
	<CFSET DIRECTIONS = FORM.DIRECTIONS>
<CFELSE>
	<CFSET DIRECTIONS = "">
</CFIF>
<CFIF isDefined("FORM.EXCEPTIONS")>
	<CFSET EXCEPTIONS = FORM.EXCEPTIONS>
<CFELSE>
	<CFSET EXCEPTIONS = "">
</CFIF>
<CFIF isDefined("FORM.FIELD")>
	<CFSET FIELD = FORM.FIELD>
<CFELSE>
	<CFSET FIELD = "">
</CFIF>
<CFIF isDefined("FORM.FIELDABBR")>
	<CFSET FIELDABBR = FORM.FIELDABBR>
<CFELSE>
	<CFSET FIELDABBR = "">
</CFIF>
<CFIF isDefined("FORM.FIELDSIZE")>
	<CFSET FIELDSIZE = FORM.FIELDSIZE>
<CFELSE>
	<CFSET FIELDSIZE = "">
</CFIF>
<CFIF isDefined("FORM.FIELDSIZECOMMENT")>
	<CFSET FIELDSIZECOMMENT = FORM.FIELDSIZECOMMENT>
<CFELSE>
	<CFSET FIELDSIZECOMMENT = "">
</CFIF>

<CFIF isDefined("FORM.lights")>
	<CFSET lights = FORM.lights>
<CFELSE>
	<CFSET lights = "">
</CFIF>
<CFIF isDefined("FORM.turf")>
	<CFSET turf = FORM.turf>
<CFELSE>
	<CFSET turf = "">
</CFIF>

<CFIF isDefined("FORM.ACTIVE")>
	<CFSET ACTIVE = FORM.ACTIVE>
<CFELSE>
	<CFSET ACTIVE = "">
</CFIF>

<CFIF isDefined("FORM.ADDRESS")>
	<CFSET ADDRESS = FORM.ADDRESS>
<CFELSE>
	<CFSET ADDRESS = "">
</CFIF>
<CFIF isDefined("FORM.CITY")>
	<CFSET CITY = FORM.CITY>
<CFELSE>
	<CFSET CITY = "">
</CFIF>
<CFIF isDefined("FORM.STATE")>
	<CFSET STATE = FORM.STATE>
<CFELSE>
	<CFSET STATE = "">
</CFIF>
<CFIF isDefined("FORM.ZIP")>
	<CFSET ZIP = FORM.ZIP>
<CFELSE>
	<CFSET ZIP = "">
</CFIF>
<!--- Day 1 stuff --->
<CFIF isDefined("FORM.DAY1")>		
	<CFSET DAY1 = FORM.DAY1>				
<CFELSE>
	<CFSET DAY1 = "SUN">
</CFIF>
<CFIF isDefined("FORM.DAY1COMMENTS")>
	<CFSET DAY1COMMENTS = FORM.DAY1COMMENTS>
<CFELSE>
	<CFSET DAY1COMMENTS = "">
</CFIF>
		<!--- <CFIF isDefined("FORM.HOUR1TO")>	
			<CFSET HOUR1TO = FORM.HOUR1TO>			
		<CFELSE>
			<CFSET HOUR1TO = 09>
		</CFIF>
		<CFIF isDefined("FORM.MINUTE1TO")>	
			<CFSET MINUTE1TO = FORM.MINUTE1TO>		
		<CFELSE>
			<CFSET MINUTE1TO = 00>
		</CFIF>
		<CFIF isDefined("FORM.MERIDIAN1TO")>
			<CFSET MERIDIAN1TO = FORM.MERIDIAN1TO>	
		<CFELSE>
			<CFSET MERIDIAN1TO = "PM">
		</CFIF>
		<CFIF isDefined("FORM.Hour1From")>	
			<CFSET Hour1From = FORM.Hour1From>		
		<CFELSE>
			<CFSET Hour1From = 09>
		</CFIF>
		<CFIF isDefined("FORM.Minute1From")>
			<CFSET Minute1From = FORM.Minute1From>	
		<CFELSE>
			<CFSET Minute1From = 00>
		</CFIF>
		<CFIF isDefined("FORM.Meridian1From")>
			<CFSET Meridian1From = FORM.Meridian1From>
		<CFELSE>
			<CFSET Meridian1From = "AM">
		</CFIF> --->
<!--- Day 2 stuff --->
<CFIF isDefined("FORM.DAY2")>		
	<CFSET DAY2 = FORM.DAY2>				
<CFELSE>
	<CFSET DAY2 = "">
</CFIF>
<CFIF isDefined("FORM.DAY2COMMENTS")>
	<CFSET DAY2COMMENTS = FORM.DAY2COMMENTS>
<CFELSE>
	<CFSET DAY2COMMENTS = "">
</CFIF>
		<!--- <CFIF isDefined("FORM.HOUR2TO")>	
			<CFSET HOUR2TO = FORM.HOUR2TO>			
		<CFELSE>
			<CFSET HOUR2TO = "">
		</CFIF>
		<CFIF isDefined("FORM.MINUTE2TO")>	
			<CFSET MINUTE2TO = FORM.MINUTE2TO>		
		<CFELSE>
			<CFSET MINUTE2TO = "">
		</CFIF>
		<CFIF isDefined("FORM.MERIDIAN2TO")>
			<CFSET MERIDIAN2TO = FORM.MERIDIAN2TO>	
		<CFELSE>
			<CFSET MERIDIAN2TO = "">
		</CFIF>
		<CFIF isDefined("FORM.Hour2From")>	
			<CFSET Hour2From = FORM.Hour2From>		
		<CFELSE>
			<CFSET Hour2From = "">
		</CFIF>
		<CFIF isDefined("FORM.Minute2From")>
			<CFSET Minute2From = FORM.Minute2From>	
		<CFELSE>
			<CFSET Minute2From = "">
		</CFIF>
		<CFIF isDefined("FORM.Meridian2From")>
			<CFSET Meridian2From = FORM.Meridian2From>
		<CFELSE>
			<CFSET Meridian2From = 1>
		</CFIF> --->

<CFIF isDefined("FORM.primaryClubName")>
	<CFSET primaryClubName = FORM.primaryClubName>
<CFELSE>
	<CFSET primaryClubName = "">
</CFIF>

<CFIF isDefined("FORM.requestYN")>
	<CFSET requestYN = FORM.requestYN>
<CFELSE>
	<CFSET requestYN = "">
</CFIF>

<CFIF isDefined("FORM.approved")>
	<CFSET approved = FORM.approved>
<CFELSE>
	<CFSET approved = "">
</CFIF>




<CFIF (MODE EQ "EDIT" OR MODE EQ "APPROVE") AND STRUCTISEMPTY(FORM)>
	<!--- we are in EDIT mode and the form was not submitted, we are in for the first time in EDIT so get the FIELDS's info --->
	<cfinvoke component="#SESSION.SITEVARS.cfcpath#field" method="getDirections" returnvariable="getField">
		<cfinvokeargument name="fieldID" value="#VARIABLES.fieldID#">
	</cfinvoke>  
	<!--- <cfoutput>Day1			= [#getField.Day1#]
			<br>	Day1TimeFrom	= [#getField.Day1TimeFrom#]
			<br>	Day1TimeTo		= [#getField.Day1TimeTo#]
			<br>	Day1Comments	= [#getField.Day1Comment#]
			<br>	Day2			= [#getField.Day2#]
			<br>	Day2TimeFrom	= [#getField.Day2TimeFrom#]
			<br>	Day2TimeTo		= [#getField.Day2TimeTo#]
			<br>	Day2Comments	= [#getField.Day2Comment#]
			<br>	
	</cfoutput> --->
 
	<!--- set the vatiables based on the query --->
	<CFSCRIPT>
		ClubID			= getField.CLUB_ID;
		Field			= getField.FIELDNAME;
		Fieldabbr		= getField.FIELDABBR;
		Address			= getField.Address;
		City			= getField.City;
		State			= getField.State;
		Zip				= getField.ZIPCODE;
		Directions		= getField.Directions;
		Day1			= getField.Day1;
	//	Day1TimeFrom	= getField.Day1TimeFrom;
	//	Day1TimeTo		= getField.Day1TimeTo;
		Day1Comments	= getField.Day1Comment;
		Day2			= getField.Day2;
	//	Day2TimeFrom	= getField.Day2TimeFrom;
	//	Day2TimeTo		= getField.Day2TimeTo;
		Day2Comments	= getField.Day2Comment;
		Exceptions		= getField.Exceptions;
		FieldSize		= getField.FieldSize;
		FieldSizeComment = getField.FieldSizeComment;
		lights 			= getField.LIGHTS_YN;
		turf 			= getField.TURF_TYPE;
		Active			= getField.Active_YN;
		requestYN		= getField.REQUEST_YN;
		approved		= getField.APPROVED;
	//	// extract & fix times from the dates for HOURS, MINUTES, MERIDIAN
	//	// ----  Day 1 ---  From --------
	//	If ( LEN(TRIM(getField.Day1TimeFrom)) )  
	//	{	timex = timeFormat(getField.Day1TimeFrom,"hh:mm tt");
	//		Hour1From = numberformat(datepart("h",timex),"00");
	//		If (Hour1From > 12)
	//		{	Hour1From = numberformat(Hour1From - 12,"00");
	//		}
	//		If (Hour1From < 1)
	//		{	Hour1From = 12;
	//		}
	//		Minute1From	  = numberformat(datepart("n",timex),"00");
	//		Meridian1From = listLast(timex," ");
	//	}Else
	//	{	Hour1From		= 09;
	//		Minute1From		= 00;
	//		Meridian1From	= "AM";
	//	}
	//	// ----  Day 1 --- TO --------
	//	If ( LEN(TRIM(getField.Day1TimeTo)) )  
	//	{	timex = timeFormat(getField.Day1TimeTo,"hh:mm tt");
	//		Hour1To		= numberformat(datepart("h",timex),"00");
	//		If (Hour1To > 12)
	//		{	Hour1To = numberformat(Hour1To - 12,"00");
	//		}
	//		If (Hour1To < 1)
	//		{	Hour1To = 12;
	//		}
	//		Minute1To	= numberformat(datepart("n",timex),"00");
	//		Meridian1To = listLast(timex," ");
	//	}Else
	//	{	// --- To
	//		Hour1To			= 09;
	//		Minute1To		= 00;
	//		Meridian1To		= "PM";
	//	}
	//	// --- Day 2 ---  From -----------
	//	If ( LEN(TRIM(getField.Day2TimeFrom)) ) 
	//	{	timex = timeFormat(getField.Day2TimeFrom,"hh:mm tt");
	//		Hour2From	  = numberformat(datepart("h",timex),"00");
	//		If (Hour2From > 12)
	//		{	Hour2From = numberformat(Hour2From - 12,"00");
	//		}
	//		If (Hour2From < 1)
	//		{	Hour2From = 12;
	//		}
	//		Minute2From	  = numberformat(datepart("n",timex),"00");
	//		Meridian2From = listLast(timex," ");
	//	}Else
	//	{	Hour2From		= 09;
	//		Minute2From		= 00;
	//		Meridian2From	= "AM";
	//	}
	//	If ( LEN(TRIM(getField.Day2TimeTo)) )  
	//	{	// ---  TO
	//		timex = timeFormat(getField.Day2TimeTo,"hh:mm tt");
	//		Hour2To		= numberformat(datepart("h",timex),"00");
	//		If (Hour2To > 12)
	//		{	Hour2To = numberformat(Hour2To - 12,"00");
	//		}
	//		If (Hour2To < 1)
	//		{	Hour2To = 12;
	//		}
	//		Minute2To	= numberformat(datepart("n",timex),"00");
	//		Meridian2To	= listLast(timex," ");
	//	}Else
	//	{	// --- To
	//		Hour2To			= 09;
	//		Minute2To		= 00;
	//		Meridian2To		= "PM";
	//	}
	</CFSCRIPT>
	
<!--- <cfoutput>Hour1From[#Hour1From#]<br>Minute1From[#Minute1From#]<br>Meridian1From[#Meridian1From#]<br>Hour1To[#Hour1To#]<br>
Minute1To[#Minute1To#]<br>Meridian1To[#Meridian1To#]<br>Hour2From[#Hour2From#]<br>Minute2From[#Minute2From#]<br>
Meridian2From[#Meridian2From#]<br>Hour2To[#Hour2To#]<br>Minute2To[#Minute2To#]<br>Meridian2To[#Meridian2To#]<br>
</cfoutput> --->
	
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="getClubInfo" returnvariable="qClubinfo">
		<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
	</cfinvoke>
	<CFSET PrimaryClubName = qClubinfo.club_name>
	<CFSET PrimaryClubID   = qClubinfo.club_id>

	<CFIF listFind(SESSION.CONSTANT.CUROLES,SESSION.MENUROLEID) NEQ 0>
		<!--- club rep is logged in --->
		<CFIF primaryClubID EQ SESSION.USER.CLUBID>
			<CFSET swAllowEdit = TRUE>
		<CFELSE>
			<CFSET swAllowEdit = FALSE>
		</CFIF>
	<CFELSE>
		<CFSET swAllowEdit = TRUE>
	</CFIF> 
	
	
</CFIF>

<CFIF isDefined("FORM.ApproveField")>
	<!--- A P P R O V E --->
	<CFIF len(trim(FIELDABBR)) EQ 0>
		<CFSET errorMessage = "Field Abbreviation is required.">
	<cfelse>	
		<cfquery name="qApproveField" datasource="#SESSION.DSN#">
			UPDATE TBL_FIELD
			   SET APPROVED = 'Y'
			     , FIELDABBR  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FIELDABBR#">
				 , REQUEST_YN = 'N'
				 , ACTIVE_YN  = 'Y'
			 WHERE FIELD_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FieldID#">
		</cfquery>
		<!---  set the active flag 	 --->
		<CFQUERY name="setActive" datasource="#SESSION.DSN#">
			Update XREF_CLUB_FIELD	 			
			   set ACTIVE_YN = 'Y'
			 Where Field_ID  = #FieldID#		  
		</CFQUERY>

		<cfif swClubUser>
			<cflocation url="FieldRequestList.cfm?club">
		<cfelse>
			<cflocation url="FieldRequestList.cfm">
		</cfif>
	</CFIF>
</CFIF>

<CFIF isDefined("FORM.RejectField")>
	<!--- R E J E C T --->
	<cfquery name="qRejectField" datasource="#SESSION.DSN#">
		UPDATE TBL_FIELD
		   SET APPROVED = 'N'
		 WHERE FIELD_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FieldID#">
	</cfquery>
	<cfif swClubUser>
		<cflocation url="FieldRequestList.cfm?club">
	<cfelse>
		<cflocation url="FieldRequestList.cfm">
	</cfif>
</CFIF>

<CFIF isDefined("FORM.SaveChanges")>
	<!--- PROCESS THE FORM - SaveChanges was PRESSED --->
	<!--- validate FORM --->
	<CFINVOKE component="#SESSION.SITEVARS.cfcpath#formValidate" method="validateFields" returnvariable="stFormValues">
		<cfinvokeargument name="formFields" value="#FORM#">
	</CFINVOKE> 	<!--- <cfdump var="#stFormValues#">		 --->
	
	<CFIF stFormValues.Errors EQ 0>
		<!--- FORM FIELDS are VALID either ADD or INSERT based on MODE --->

		<!--- <CFSET Day1TimeFrom	= Trim(Hour1From) & ":" & Trim(Minute1From)	& " " & Trim(Meridian1From)>
		<CFSET Day1TimeTo	= Trim(Hour1To)	  & ":" & Trim(Minute1To)	& " " & Trim(Meridian1To)>
		<CFSET Day2TimeFrom	= Trim(Hour2From) & ":" & Trim(Minute2From)	& " " & Trim(Meridian2From)>
		<CFSET Day2TimeTo	= Trim(Hour2To)	  & ":" & Trim(Minute2To)	& " " & Trim(Meridian2To)> --->

		<!--- FIELD AVAILABILITY is now done in a seperate page and saved to a different table  --->
		<CFSET Day1TimeFrom	= "12:00 AM">
		<CFSET Day1TimeTo	= "12:00 AM">
		<CFSET Day2TimeFrom	= "12:00 AM">
		<CFSET Day2TimeTo	= "12:00 AM">

		<CFIF MODE EQ "ADD">
			<cfif swClubUser>
				<CFSET Approved  = " ">
			<cfelse>
				<CFSET Approved  = "Y">
			</cfif>
			<CFINVOKE component="#SESSION.SITEVARS.cfcpath#field" method="insertField">
					<cfinvokeargument name="FieldAbbr" 	value="#Trim(FieldAbbr)#">
					<cfinvokeargument name="Field" 		value="#Trim(Field)#">
					<cfinvokeargument name="address" 	value="#Trim(address)#">
					<cfinvokeargument name="city" 		value="#Trim(city)#">
					<cfinvokeargument name="state" 		value="#Trim(state)#">
					<cfinvokeargument name="Zip" 		value="#Trim(Zip)#">
					<cfinvokeargument name="directions" value="#Trim(directions)#">
					<cfinvokeargument name="fieldSize" 	value="#Trim(fieldSize)#">
					<cfinvokeargument name="fieldSizeComment" value="#Trim(fieldSizeComment)#">
					<cfinvokeargument name="lightsYN" 	value="#Trim(lights)#">
					<cfinvokeargument name="turfType" 	value="#Trim(turf)#">
					<cfinvokeargument name="day1" 			value="#Trim(day1)#">
					<cfinvokeargument name="day1TimeFrom" 	value="#Trim(day1TimeFrom)#">
					<cfinvokeargument name="day1TimeTo" 	value="#Trim(day1TimeTo)#">
					<cfinvokeargument name="day1Comments" 	value="#Trim(day1Comments)#">
					<cfinvokeargument name="day2" 			value="#Trim(day2)#">
					<cfinvokeargument name="day2TimeFrom" 	value="#Trim(day2TimeFrom)#">
					<cfinvokeargument name="day2TimeTo" 	value="#Trim(day2TimeTo)#">
					<cfinvokeargument name="day2Comments" 	value="#Trim(day2Comments)#">
					<cfinvokeargument name="exceptions"		value="#Trim(exceptions)#">
					<cfinvokeargument name="activeYN" 		value="#Trim(active)#">
					<cfinvokeargument name="ContactID" 		value="#Trim(Session.USER.ContactID)#">
					<cfinvokeargument name="Approved" 		value="#Trim(Approved)#">
					<cfinvokeargument name="ClubId" 		value="#Trim(ClubId)#">
			</CFINVOKE>
		</CFIF> <!--- IF MODE EQ "ADD" --->

		<CFIF MODE EQ "EDIT">
			<!--- LETS EDIT THE FIELD update the field info	 --->
			<CFINVOKE component="#SESSION.SITEVARS.cfcpath#field" method="updateField">
					<cfinvokeargument name="FieldID" 	value="#Trim(FieldID)#">
					<cfinvokeargument name="Field" 		value="#Trim(Field)#">
					<cfinvokeargument name="FieldAbbr" 	value="#Trim(FieldAbbr)#">
					<cfinvokeargument name="address" 	value="#Trim(address)#">
					<cfinvokeargument name="city" 		value="#Trim(city)#">
					<cfinvokeargument name="state" 		value="#Trim(state)#">
					<cfinvokeargument name="Zip" 		value="#Trim(Zip)#">
					<cfinvokeargument name="directions" value="#Trim(directions)#">
					<cfinvokeargument name="fieldSize" 	value="#Trim(fieldSize)#">
					<cfinvokeargument name="fieldSizeComment" value="#Trim(fieldSizeComment)#">
					<cfinvokeargument name="lightsYN" 	value="#Trim(lights)#">
					<cfinvokeargument name="turfType" 	value="#Trim(turf)#">
					<cfinvokeargument name="day1" 			value="#Trim(day1)#">
					<cfinvokeargument name="day1TimeFrom" 	value="#Trim(day1TimeFrom)#">
					<cfinvokeargument name="day1TimeTo" 	value="#Trim(day1TimeTo)#">
					<cfinvokeargument name="day1Comments" 	value="#Trim(day1Comments)#">
					<cfinvokeargument name="day2" 			value="#Trim(day2)#">
					<cfinvokeargument name="day2TimeFrom" 	value="#Trim(day2TimeFrom)#">
					<cfinvokeargument name="day2TimeTo" 	value="#Trim(day2TimeTo)#">
					<cfinvokeargument name="day2Comments" 	value="#Trim(day2Comments)#">
					<cfinvokeargument name="exceptions" 	value="#Trim(exceptions)#">
					<cfinvokeargument name="ContactID" 		value="#Trim(Session.USER.ContactID)#">
			</CFINVOKE>
			
			<cfif NOT swClubUser>
				<!--- APPROVE the field --->		  
				<CFINVOKE component="#SESSION.SITEVARS.cfcpath#field" method="approveField">
					<cfinvokeargument name="FieldID" 	value="#Trim(FieldID)#">
				</CFINVOKE>
				<!---  set the active flag 	 --->
				<CFQUERY name="setActive" datasource="#SESSION.DSN#">
					Update TBL_FIELD	 			
					   set ACTIVE_YN = '#active#'
					 Where Field_ID  = #FieldID#		  
				</CFQUERY>
				<CFQUERY name="setXrefActive" datasource="#SESSION.DSN#">
					Update XREF_CLUB_FIELD	 			
					   set ACTIVE_YN = '#active#'
					 Where Field_ID  = #FieldID#		  
				</CFQUERY>
			<CFELSE>
				<!--- club user, if editing a rejected request, update to pending --->
				<cfif requestYN EQ "Y" AND approved EQ "N">
					<cfquery name="qApproveField" datasource="#SESSION.DSN#">
						UPDATE TBL_FIELD
						   SET APPROVED = NULL
							 , REQUEST_YN = 'Y'
						 WHERE FIELD_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FieldID#">
					</cfquery>
				</cfif>
			</cfif> <!---  if NOT swClubUser  --->
		
			<CFSET errorMessage = "Changes saved.">
			
		</CFIF> <!--- IF MODE EQ "EDIT" --->


	</CFIF> <!--- IF stFormValues.Errors EQ 0 --->
</CFIF> <!--- IF isDefined("FORM.APPROVE") --->


<!--- get date/time values for dropDowns --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="ddhhmmtt">
	<cfinvokeargument name="listType" value="DDHHMMTT"> 
</cfinvoke>

<!--- get club States for dropDowns --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="states">
	<cfinvokeargument name="listType" value="CLUBSTATES"> 
</cfinvoke>
 

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Field Maintenance: 
	<CFIF MODE EQ "EDIT"> Edit Field </CFIF>
	<CFIF MODE EQ "ADD"> Add Field </CFIF>
	<CFIF MODE EQ "APPROVE"> Approve Field </CFIF>
</H1>

<!--- <CFIF MODE EQ "APPROVE">
	<cfset txtDisabled = "disabled">
<CFELSE> --->
	<cfset txtDisabled = "">
<!--- </CFIF>  --->
 
<FORM name="DirectionsMaintain" action="fieldDirectionsEdit.cfm"  method="post">
<input type="hidden" name="Mode" 			value="#Mode#">
<input type="hidden" name="ClubId" 			value="#ClubID#">
<input type="hidden" name="OriginalField"	value="#Field#">
<input type="hidden" name="FieldID" 		value="#FieldID#">
<input type="hidden" name="swAllowEdit"		value="#swAllowEdit#">
<input type="hidden" name="primaryClubName"	value="#primaryClubName#">
<input type="hidden" name="requestYN"		value="#requestYN#">
<input type="hidden" name="approved"		value="#approved#">

<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">
<table cellspacing="0" cellpadding="5" align="left" border="0" width="95%">
		<tr class="tblHeading">
			<TD width="75%"> &nbsp;	</TD>
			<TD width="25%"> &nbsp;	</TD>
		</tr>
		<CFIF isDefined("stFormValues.errorMessage")>
			<tr><td colspan="2" align="center">
					<span class="red"><b>#stFormValues.errorMessage#</b></span> 
				</td>
			</tr>
		</CFIF>
		<CFIF len(Trim(errorMessage))>
			<tr><td colspan="2" align="center">
					<span class="red"><b>#errorMessage#</b></span> 
				</td>
			</tr>
		</CFIF>
		<CFIF NOT swAllowEdit>
			<tr><td colspan="2" align="center">
					<span class="red"><b>Only the Primary club for this field may edit it.</b></span>
				</td>
			</tr>
			<cfset txtDisabled = "disabled"><!--- user clubid not fields primary club  --->
		</CFIF>

		<TR><TD><CFSET inputSize = 52>
				<table cellspacing="0" cellpadding="5" align="left" border="0">
								<TR><TD align="right">	<b>#required# Field	Name</b>				</TD>
									<TD><input maxlength="50" name="Field" value="#Field#" size="#inputSize#" #txtDisabled#>	
										<input type="Hidden" name="Field_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=Field name">
									</TD>
								</TR>
						
								<TR><TD align="right">	<b>#required# Field	Abbr</b>				</TD>
									<TD><CFIF swClubUser>
											<!--- club roles cannot edit field abbreviations --->
											#FieldAbbr#
											<input type="Hidden" name="FieldAbbr" value="#FieldAbbr#">
										<CFELSE>
											<input maxlength="20" name="FieldAbbr" value="#FieldAbbr#" size="#inputSize#" >	
											<input type="Hidden" name="FieldAbbr_ATTRIBUTES" value="type=FIELDABBRCHARS~required=1~FIELDNAME=Field Abbreviation">
										</CFIF> 
									</TD>
								</TR>
								<CFIF NOT swClubUser>
									<TR><TD align="right">	<b>Active? </b> 						</TD>
										<TD><select name="Active" #txtDisabled#>
												<option value="Y" <cfif Active EQ "Y">selected</cfif> >Yes</option>
												<option value="N" <cfif Active EQ "N">selected</cfif> >No </option>
											</select> <!--- <input maxlength="1" name="InActive" value="#InActive#" > (Leave it Blank for Active)  --->
										</TD>
									</TR>
								</CFIF>
								<TR><TD align="right">	<b>#required# Address </b>					</TD>
									<TD><input maxlength="100" name="Address" value="#Address#" size="#inputSize#" #txtDisabled#> 	
										<input type="Hidden" name="Address_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=Address">
									</TD>
								</TR>
								<TR><TD align="right">	<b> #required# City </b>					</TD>
									<TD><input maxlength="50" name="City" value="#City#" size="#inputSize#" #txtDisabled#>
										<input type="Hidden" name="City_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=City">
									</TD>
								</TR>
								<TR><TD align="right">	<b> #required# State</b>					</TD>
									<TD><select name="State" #txtDisabled#>
											<option value="">State</option>
											<cfloop from="1" to="#arrayLen(states)#" index="ist">
												<option value="#states[ist][1]#" <CFIF state EQ states[ist][1] >Selected</CFIF> >#states[ist][1]#</option>
											</cfloop>
										</select>
										<!--- <input maxlength="2" name="State" value="#State#"> --->
										<input type="Hidden" name="State_ATTRIBUTES" value="type=STATE~required=1~FIELDNAME=State">
											<b> #required# Zip code</b>
										<input maxlength="5" name="Zip" value="#Zip#" #txtDisabled#>
										<input type="Hidden" name="Zip_ATTRIBUTES" value="type=ZIPCODE~required=1~FIELDNAME=Zip Code">				
									</TD>
								</TR>
								<TR><TD align="right">	<b> #required# Field Size </b>	</TD>
									<TD><Select name="FieldSize"  #txtDisabled#>
											<OPTION value="" >Select Field Size:</OPTION>
											<OPTION value="L" <CFIF FieldSize eq "L">selected</CFIF> > Large (11 vs 11)</OPTION>
											<OPTION value="S" <CFIF FieldSize eq "S">selected</CFIF> > Small ( 8 vs 8) </OPTION>
											<OPTION value="B" <CFIF FieldSize eq "B">selected</CFIF> > Both			  </OPTION>
										</SELECT> 
										<input type="Hidden" name="FieldSize_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=FieldSize">
										<!--- 
										<input type="Radio" maxlength="1" name="FieldSize" value="L" <CFIF FieldSize eq "L">checked</CFIF> > Large (11 vs 11) &nbsp; &nbsp;
										<input type="Radio" maxlength="1" name="FieldSize" value="S" <CFIF FieldSize eq "S">checked</CFIF> > Small ( 8 vs 8)  &nbsp; &nbsp;
										<input type="Radio" maxlength="1" name="FieldSize" value="B" <CFIF FieldSize eq "B">checked</CFIF> > Both			&nbsp; &nbsp;	
										--->
									</TD>
								</TR>
								<TR><TD align="right">	<b> Field Size Comments	</b>				</TD>
									<TD><input maxlength="255" name="FieldSizeComment" value="#FieldSizeComment#" size="#inputSize#" #txtDisabled#>
									</TD>
								</TR>
								<TR><TD align="right">	<b>#required#  Lights	</b>				</TD>
									<TD><SELECT name="lights"  #txtDisabled#> 
											<OPTION value="" >Have Lights?</OPTION>
											<OPTION value="Y" <cfif lights EQ "Y">selected</cfif> >Yes</OPTION>
											<OPTION value="N" <cfif lights EQ "N">selected</cfif> >No</OPTION>
										</SELECT>
										<input type="Hidden" name="lights_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Lights">
										#repeatString("&nbsp;",15)#
										<b>#required#  Turf	</b>	
										<SELECT name="turf"  #txtDisabled#> 
											<OPTION value="" >Turf Type</OPTION>
											<OPTION value="Grass" 	   <cfif turf EQ "Grass">selected</cfif> >Grass</OPTION>
											<OPTION value="Artificial" <cfif turf EQ "Artificial">selected</cfif> >Artificial</OPTION>
										</SELECT>
										<input type="Hidden" name="turf_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Turf">
									</TD>
								</TR>
								<!--- DAY 1 ============================== 
								<TR><TD align="right">
										<b> Saturday Availability</b>
									</TD>
									<TD><input type="Hidden" name="Day1" value="SAT">
										<!--- <SELECT name="Day1"  #txtDisabled#> 
											<OPTION value="" selected>Day</OPTION>
											<CFLOOP list="#ddhhmmtt.DAY#" index="iD">  <OPTION value="#iD#" <CFIF Day1 EQ iD>selected</CFIF> >#iD#</OPTION>	</CFLOOP>
										</SELECT> --->
										<!--- ------------- From TIME -------------- --->
										<SELECT name="Hour1From"  #txtDisabled#> 
											<OPTION value="0" selected>hr</OPTION>
											<CFLOOP list="#ddhhmmtt.HOUR#" index="iH">  <OPTION value="#iH#" <CFIF Hour1From EQ iH>selected</CFIF> >#iH#</OPTION>	</CFLOOP>
										</SELECT>
										<SELECT name="Minute1From"  #txtDisabled#> 
											<OPTION value="0" selected>mn</OPTION>
											<CFLOOP list="#ddhhmmtt.MIN#" index="iM">	<OPTION value="#iM#" <CFIF Minute1From EQ iM>selected</CFIF> >#iM#</OPTION>	</CFLOOP>
										</SELECT>
										<SELECT name="Meridian1From"  #txtDisabled#> 
											<CFLOOP list="#ddhhmmtt.TT#" index="iT">	<OPTION value="#iT#" <CFIF Meridian1From EQ iT>selected</CFIF> >#iT#</OPTION>	</CFLOOP>
										</SELECT>
										<!--- ------------- TO TIME -------------- --->
										<b>till </b>
										<SELECT name="Hour1To"  #txtDisabled#> 
											<OPTION value="0" selected>hr</OPTION>
											<CFLOOP list="#ddhhmmtt.HOUR#" index="iH">  <OPTION value="#iH#" <CFIF Hour1To EQ iH>selected</CFIF> >#iH#</OPTION>	</CFLOOP>
										</SELECT>
										<SELECT name="Minute1To"  #txtDisabled#> 
											<OPTION value="0" selected>mn</OPTION>
											<CFLOOP list="#ddhhmmtt.MIN#" index="iM">	<OPTION value="#iM#" <CFIF Minute1To EQ iM>selected</CFIF> >#iM#</OPTION>	</CFLOOP>
										</SELECT>
										<SELECT name="Meridian1To"  #txtDisabled#> 
											<CFLOOP list="#ddhhmmtt.TT#" index="iT">	<OPTION value="#iT#" <CFIF Meridian1To EQ iT>selected</CFIF> >#iT#</OPTION>	</CFLOOP>
										</SELECT>
									</TD>
								</tr>
								============================ --->
								<TR><TD align="right"><b> Saturday Comments</b></TD>
									<TD><input maxlength="100" name="Day1Comments" value="#Day1Comments#" onchange="" size="#inputSize#"  #txtDisabled#></TD>
								</TR>
								
								<!---  DAY 2 ===================================== 
								<TR><TD align="right"><b> Sunday Availability </b> </TD>
									<TD><input type="Hidden" name="Day2" value="SUN">
										<!--- <SELECT name="Day2"  #txtDisabled#> 
											<OPTION value="" selected>Day</OPTION>
											<CFLOOP list="#ddhhmmtt.DAY#" index="iD">  <OPTION value="#iD#" <CFIF Day2 EQ iD>selected</CFIF> >#iD#</OPTION>	</CFLOOP>
										</SELECT> --->
										<!--- ------------- From TIME -------------- --->
										<SELECT name="Hour2From"  #txtDisabled#> 
											<OPTION value="0" selected>hr</OPTION>
											<CFLOOP list="#ddhhmmtt.HOUR#" index="iH">  <OPTION value="#iH#" <CFIF Hour2From EQ iH>selected</CFIF> >#iH#</OPTION>	</CFLOOP>
										</SELECT>
										<SELECT name="Minute2From"  #txtDisabled#> 
											<OPTION value="0" selected>mn</OPTION>
											<CFLOOP list="#ddhhmmtt.MIN#" index="iM">	<OPTION value="#iM#" <CFIF Minute2From EQ iM>selected</CFIF> >#iM#</OPTION>	</CFLOOP>
										</SELECT>
										<SELECT name="Meridian2From"  #txtDisabled#> 
											<CFLOOP list="#ddhhmmtt.TT#" index="iT">	<OPTION value="#iT#" <CFIF Meridian2From EQ iT>selected</CFIF> >#iT#</OPTION>	</CFLOOP>
										</SELECT>
										<!--- ------------- TO TIME -------------- --->
										<b>till </b>
										<SELECT name="Hour2To"  #txtDisabled#> 
											<OPTION value="0" selected>hr</OPTION>
											<CFLOOP list="#ddhhmmtt.HOUR#" index="iH">  <OPTION value="#iH#" <CFIF Hour2To EQ iH>selected</CFIF> >#iH#</OPTION>	</CFLOOP>
										</SELECT>
										<SELECT name="Minute2To"  #txtDisabled#> 
											<OPTION value="0" selected>mn</OPTION>
											<CFLOOP list="#ddhhmmtt.MIN#" index="iM">	<OPTION value="#iM#" <CFIF Minute2To EQ iM>selected</CFIF> >#iM#</OPTION>	</CFLOOP>
										</SELECT>
										<SELECT name="Meridian2To"  #txtDisabled#> 
											<CFLOOP list="#ddhhmmtt.TT#" index="iT">	<OPTION value="#iT#" <CFIF Meridian2To EQ iT>selected</CFIF> >#iT#</OPTION>	</CFLOOP>
										</SELECT>
									</TD>
								</tr>
								================================= --->
								<TR><TD align="right">	<b	>Sunday Comments</b>								</TD>
									<TD><input maxlength="100" name="Day2Comments" value="#Day2Comments#" size="#inputSize#"  #txtDisabled#>	</TD>
								</TR>
								<TR><TD align="right">	<b>	Limitations <br>/Exceptions</b>						</TD>
									<TD><input maxlength="200" name="Exceptions" value="#Exceptions#" size="#inputSize#"   #txtDisabled#>	</TD>
								</TR>
								<TR><TD align="right">	<b> #required# Directions	</b>					</TD>
									<TD><TEXTAREA  name="Directions" rows=12 cols=51 #txtDisabled#>#Directions#</TEXTAREA>	
										<input type="Hidden" name="Directions_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Directions">
									</TD>
								</TR>
				</table>
			</TD>
			<TD valign="top">
				<table cellspacing="0" cellpadding="5" align="left" border="0">
						<TR><TD align="left">
								<b>Primary Club: </b>
								<br>
								#PrimaryClubName#
							</TD>
						</TR>
						<TR><TD align="left">
								<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getAssignedClubs" returnvariable="qMappedClubs">
									<cfinvokeargument name="fieldID" value="#VARIABLES.fieldID#"> 
								</cfinvoke>
								<b>Assigned To Clubs:</b>
								<CFLOOP query="qMappedClubs">
									<br>#CLUB_NAME#
								</CFLOOP>
							</TD>
						</TR>
				</table>
			</TD>
		</TR>


		<TR align="center">
    		<TD colspan="2">
				<hr size="1">
				<CFIF swClubUser>
					<CFIF swAllowEdit>
						<INPUT type="submit" name="SaveChanges" value="Save Changes" >
					<CFELSE>	
						<span class="red"><b>Only the Primary club for this field may edit it.</b></span>
						<br>
					</CFIF>
				<CFELSE>
					<cfif mode eq "EDIT">
						<INPUT type="submit"  name="SaveChanges" value="Save Changes">
					</cfif>
					<cfif mode eq "APPROVE">
						<span class="red"><b>Field Abbreviation is required if approving.</b></span>
						<br>
						<INPUT type="submit"  name="ApproveField" value="Approve Field">
						<INPUT type="submit"  name="RejectField"  value="Reject Field">
					</cfif>
				</CFIF>
				<!--- <INPUT type="button" value="Back" onclick="history.back(-1)"> --->
			</TD>
		</TR>
</TABLE>

</FORM>	
	
	
	
	
</cfoutput>
</div>
<cfinclude template="_footer.cfm">

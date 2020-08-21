<!--- 
	FileName:	fieldDirectionsAdd
	Created on: 11/06/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: admin add a new field
	
MODS: mm/dd/yyyy - filastname - comments
	01/05/09 - AA - Removed DAY1 and DAY2 times - will now be done thru field availability

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">


<CFIF listFind(SESSION.CONSTANT.CUroles,SESSION.menuRoleID) GT 0>
	<cfset swClubUser = true>
	<cfset textHeading = "Request to Add a Field" >
<cfelse>
	<cfset swClubUser = false>
	<cfset textHeading = "Direction Maintenance" >
</CFIF>  

<CFIF isDefined("FORM.clubID")>
	<CFSET clubID = FORM.clubID>
<CFELSE>
	<CFSET clubID = SESSION.USER.CLUBID>
</CFIF>

<CFIF isDefined("FORM.fieldID")>
	<CFSET fieldID = FORM.fieldID>
<CFELSE>
	<CFSET fieldID = 0>
</CFIF>

<CFIF isDefined("FORM.swAllowEdit")>
	<CFSET swAllowEdit = FORM.swAllowEdit>
<CFELSE>
	<CFSET swAllowEdit = false>
</CFIF>


<CFIF isDefined("FORM.mode")>
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
					<CFSET HOUR1TO = "09"><!--- <CFSET HOUR1TO = 09> --->
				</CFIF>
				<CFIF isDefined("FORM.MINUTE1TO")>	
					<CFSET MINUTE1TO = FORM.MINUTE1TO>		
				<CFELSE>
					<CFSET MINUTE1TO = "00"><!--- <CFSET MINUTE1TO = 00> --->
				</CFIF>
				<CFIF isDefined("FORM.MERIDIAN1TO")>
					<CFSET MERIDIAN1TO = FORM.MERIDIAN1TO>	
				<CFELSE>
					<CFSET MERIDIAN1TO = "PM"><!--- <CFSET MERIDIAN1TO = "PM"> --->
				</CFIF>
				<CFIF isDefined("FORM.Hour1From")>	
					<CFSET Hour1From = FORM.Hour1From>		
				<CFELSE>
					<CFSET Hour1From = "09"><!--- <CFSET Hour1From = 09> --->
				</CFIF>
				<CFIF isDefined("FORM.Minute1From")>
					<CFSET Minute1From = FORM.Minute1From>	
				<CFELSE>
					<CFSET Minute1From = "00"><!--- <CFSET Minute1From = 00> --->
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
					<CFSET HOUR2TO = "09">
				</CFIF>
				<CFIF isDefined("FORM.MINUTE2TO")>	
					<CFSET MINUTE2TO = FORM.MINUTE2TO>		
				<CFELSE>
					<CFSET MINUTE2TO = "00">
				</CFIF>
				<CFIF isDefined("FORM.MERIDIAN2TO")>
					<CFSET MERIDIAN2TO = FORM.MERIDIAN2TO>	
				<CFELSE>
					<CFSET MERIDIAN2TO = "PM">
				</CFIF>
				<CFIF isDefined("FORM.Hour2From")>	
					<CFSET Hour2From = FORM.Hour2From>		
				<CFELSE>
					<CFSET Hour2From = "09">
				</CFIF>
				<CFIF isDefined("FORM.Minute2From")>
					<CFSET Minute2From = FORM.Minute2From>	
				<CFELSE>
					<CFSET Minute2From = "00">
				</CFIF>
				<CFIF isDefined("FORM.Meridian2From")>
					<CFSET Meridian2From = FORM.Meridian2From>
				<CFELSE>
					<CFSET Meridian2From = "AM">
				</CFIF> --->


<CFIF isDefined("FORM.APPROVE") OR isDefined("FORM.Request") >
	<!--- PROCESS THE FORM - APPROVE OR REQUEST was PRESSED --->
	<!--- validate FORM --->
	<CFINVOKE component="#SESSION.SITEVARS.cfcpath#formValidate" method="validateFields" returnvariable="stFormValues">
		<cfinvokeargument name="formFields" value="#FORM#">
	</CFINVOKE> 	<!--- <cfdump var="#stFormValues#">		 --->
	
	<CFIF stFormValues.Errors EQ 0>
		<!--- FORM FIELDS are VALID, ADD the field --->
		
		<!--- 
		<CFSET Day1TimeFrom	= Trim(Hour1From) & ":" & Trim(Minute1From)	& " " & Trim(Meridian1From)>
		<CFSET Day1TimeTo	= Trim(Hour1To)	  & ":" & Trim(Minute1To)	& " " & Trim(Meridian1To)>
		<CFSET Day2TimeFrom	= Trim(Hour2From) & ":" & Trim(Minute2From)	& " " & Trim(Meridian2From)>
		<CFSET Day2TimeTo	= Trim(Hour2To)	  & ":" & Trim(Minute2To)	& " " & Trim(Meridian2To)>
		--->
		<!--- FIELD AVAILABILITY is now done in a seperate page and saved to a different table  --->
		<CFSET Day1TimeFrom	= "12:00 AM">
		<CFSET Day1TimeTo	= "12:00 AM">
		<CFSET Day2TimeFrom	= "12:00 AM">
		<CFSET Day2TimeTo	= "12:00 AM">

		<CFIF isDefined("FORM.APPROVE")>
			<CFSET Approved = "Y">
			<CFSET isRequest = "N">
		<CFELSE>
			<!--- request --->
			<CFSET Approved  = " ">
			<CFSET isRequest = "Y">
			<cfset activeYN  = "N">
		</CFIF>

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
				<cfinvokeargument name="requestYN" 		value="#Trim(isRequest)#">
		</CFINVOKE>
		
		<CFIF swClubUser>
			<cflocation url="FieldList.cfm?club">
		<CFELSE>
			<cflocation url="FieldList.cfm">
		</CFIF>
		
		
		
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
<H1 class="pageheading">NCSA - #textHeading#</H1><!--- <h2>For #VARIABLES.clubName#</h2> --->

<FORM name="DirectionsMaintain" action="fieldDirectionsAdd.cfm"  method="post">
<input type="hidden" name="Mode" 			value="#Mode#">
<input type="hidden" name="OriginalField"	value="#Field#">
<input type="hidden" name="FieldID" 		value="#FieldID#">
<input type="hidden" name="swAllowEdit"		value="#swAllowEdit#">

<CFIF isDefined("stFormValues.errorMessage")>
	<span class="red"><b>#stFormValues.errorMessage#</b></span><br>
</CFIF>

<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">
<table cellspacing="0" cellpadding="5" align="left" border="0" width="95%">
	<tr class="tblHeading">
		<TD width="75%"> &nbsp;	</TD>
		<TD width="25%"> &nbsp;	</TD>
	</tr>
	<TR><TD><CFSET inputSize = 52>
			<table cellspacing="0" cellpadding="5" align="left" border="0">
				<CFIF swClubUser>
					<input type="Hidden" name="clubid" value="#SESSION.USER.CLUBID#">
				<cfelse>
					<TR><TD align="right">	<b>#required# Primary Club</b>				</TD>
						<td><cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubInfo" returnvariable="clubInfo">
								<cfinvokeargument name="DSN"     value="#SESSION.DSN#">
								<cfinvokeargument name="orderby" value="clubname">
							</cfinvoke>  <!--- <cfdump var="#clubInfo#"> --->
							<select name="clubid">
								<option value="0">Select a Club...</option>
								<CFLOOP query="clubInfo">
									<option value="#CLUB_ID#" <cfif variables.clubid EQ CLUB_ID>selected</cfif> >#CLUB_NAME#</option>
								</CFLOOP>
							</select> 
						</td>
					</TR>
				</CFIF>
					<TR><TD align="right">	<b>#required# Field	Name</b>				</TD>
						<TD><input maxlength="100" name="Field" value="#Field#" size="#inputSize#">	
							<input type="Hidden" name="Field_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=Field name">
						</TD>
					</TR>
				<CFIF swClubUser>
					<input type="Hidden" name="FieldAbbr" value="">	
					<input type="Hidden" name="Active"    value="N">	
				<CFELSE>
					<TR><TD align="right">	<b>#required# Field	Abbr</b>				</TD>
						<TD><input maxlength="100" name="FieldAbbr" value="#FieldAbbr#" size="#inputSize#">	
							<input type="Hidden" name="FieldAbbr_ATTRIBUTES" value="type=FIELDABBRCHARS~required=1~FIELDNAME=Field Abbreviation">
						</TD>
					</TR>
					<TR><TD align="right">	<b>Active? </b> 						</TD>
						<TD><select name="Active">
									<option value="Y">Yes</option>
									<option value="N">No </option>
							</select> <!--- <input maxlength="1" name="InActive" value="#InActive#" > (Leave it Blank for Active)  --->
						</TD>
					</TR>
				</CFIF>
					<TR><TD align="right">	<b>#required# Address </b>					</TD>
						<TD><input maxlength="100" name="Address" value="#Address#" size="#inputSize#"> 	
							<input type="Hidden" name="Address_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=Address">
						</TD>
					</TR>
					<TR><TD align="right">	<b> #required# City </b>					</TD>
						<TD><input maxlength="100" name="City" value="#City#" size="#inputSize#">
							<input type="Hidden" name="City_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=City">
						</TD>
					</TR>
					<TR><TD align="right">	<b> #required# State</b>					</TD>
						<TD><select name="State">
								<option value="">State</option>
								<cfloop from="1" to="#arrayLen(states)#" index="ist">
									<option value="#states[ist][1]#" <CFIF state EQ states[ist][1] >Selected</CFIF> >#states[ist][1]#</option>
								</cfloop>
							</select>
							<!--- <input maxlength="2" name="State" value="#State#"> --->
							<input type="Hidden" name="State_ATTRIBUTES" value="type=STATE~required=1~FIELDNAME=State">
							#repeatString("&nbsp;",15)#
							<b> #required# Zip code</b>
							<input maxlength="5" name="Zip" value="#Zip#">
							<input type="Hidden" name="Zip_ATTRIBUTES" value="type=ZIPCODE~required=1~FIELDNAME=Zip Code">				
						</TD>
					</TR>
					<TR><TD align="right">	<b> #required# Field Size </b>				</TD>
						<TD><Select name="FieldSize"  >
								<OPTION value="" selected >Select Field Size:</OPTION>
								<OPTION value="L" <CFIF FieldSize eq "L">selected</CFIF> > Large (11 vs 11)</OPTION>
								<OPTION value="S" <CFIF FieldSize eq "S">selected</CFIF> > Small ( 8 vs 8) </OPTION>
								<OPTION value="B" <CFIF FieldSize eq "B">selected</CFIF> > Both			  </OPTION>
							</SELECT> 
							<input type="Hidden" name="FieldSize_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=FieldSize">
							<!--- 
							<input type="Radio" maxlength="1" name="FieldSize" value="L" <CFIF FieldSize eq "L">checked</CFIF> > Large (11 vs 11) &nbsp; &nbsp;
							<input type="Radio" maxlength="1" name="FieldSize" value="S" <CFIF FieldSize eq "S">checked</CFIF> > Small ( 8 vs 8)  &nbsp; &nbsp;
							<input type="Radio" maxlength="1" name="FieldSize" value="B" <CFIF FieldSize eq "B">checked</CFIF> > Both			&nbsp; &nbsp;	
							<input type="Hidden" name="FieldSize_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Field Size">
							 --->
						</TD>
					</TR>
					<TR><TD align="right">	<b> Field Size Comments	</b>				</TD>
						<TD><input maxlength="255" name="FieldSizeComment" value="#FieldSizeComment#" size="#inputSize#">
						</TD>
					</TR>
					<TR><TD align="right">	<b>#required#  Lights	</b>				</TD>
						<TD><SELECT name="lights" > 
								<OPTION value="" selected>Have Lights?</OPTION>
								<OPTION value="Y" <cfif lights EQ "Y">selected</cfif> >Yes</OPTION>
								<OPTION value="N" <cfif lights EQ "N">selected</cfif> >No</OPTION>
							</SELECT>
							<input type="Hidden" name="lights_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Lights">
							#repeatString("&nbsp;",15)#
							<b>#required#  Turf	</b>	
							<SELECT name="turf" > 
								<OPTION value="" selected>Turf Type</OPTION>
								<OPTION value="Grass" <cfif turf EQ "Grass">selected</cfif> >Grass</OPTION>
								<OPTION value="Artificial" <cfif turf EQ "Artificial">selected</cfif> >Artificial</OPTION>
							</SELECT>
							<input type="Hidden" name="turf_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Turf">
						</TD>
					</TR>
					<!--- DAY 1  =============
					<TR><TD align="right">
							<b>Saturday Availability</b>
						</TD>
						<TD><input type="Hidden" name="Day1" value="SAT">
							<!--- <SELECT name="Day1" > 
								<OPTION value="" selected>Day</OPTION>
								<CFLOOP list="#ddhhmmtt.DAY#" index="iD">  <OPTION value="#iD#" <CFIF Day1 EQ iD>selected</CFIF> >#iD#</OPTION>	</CFLOOP>
							</SELECT> --->
							<!--- ------------- From TIME -------------- --->
							<SELECT name="Hour1From" > 
								<OPTION value="0" selected>hr</OPTION>
								<CFLOOP list="#ddhhmmtt.HOUR#" index="iH">  <OPTION value="#iH#" <CFIF Hour1From EQ iH>selected</CFIF> >#iH#</OPTION>	</CFLOOP>
							</SELECT>
							<SELECT name="Minute1From" > 
								<OPTION value="0" selected>mn</OPTION>
								<CFLOOP list="#ddhhmmtt.MIN#" index="iM">	<OPTION value="#iM#" <CFIF Minute1From EQ iM>selected</CFIF> >#iM#</OPTION>	</CFLOOP>
							</SELECT>
							<SELECT name="Meridian1From" > 
								<CFLOOP list="#ddhhmmtt.TT#" index="iT">	<OPTION value="#iT#" <CFIF Meridian1From EQ iT>selected</CFIF> >#iT#</OPTION>	</CFLOOP>
							</SELECT>
							<!--- ------------- TO TIME -------------- --->
							<b>till </b>
							<SELECT name="Hour1To" > 
								<OPTION value="0" selected>hr</OPTION>
								<CFLOOP list="#ddhhmmtt.HOUR#" index="iH">  <OPTION value="#iH#" <CFIF Hour1To EQ iH>selected</CFIF> >#iH#</OPTION>	</CFLOOP>
							</SELECT>
							<SELECT name="Minute1To" > 
								<OPTION value="0" selected>mn</OPTION>
								<CFLOOP list="#ddhhmmtt.MIN#" index="iM">	<OPTION value="#iM#" <CFIF Minute1To EQ iM>selected</CFIF> >#iM#</OPTION>	</CFLOOP>
							</SELECT>
							<SELECT name="Meridian1To" > 
								<CFLOOP list="#ddhhmmtt.TT#" index="iT">	<OPTION value="#iT#" <CFIF Meridian1To EQ iT>selected</CFIF> >#iT#</OPTION>	</CFLOOP>
							</SELECT>
						</TD>
					</tr>
					===================   --->
					<TR><TD align="right"><b>Saturday Comments</b></TD>
						<TD><input maxlength="100" name="Day1Comments" value="#Day1Comments#" onchange="" size="#inputSize#" ></TD>
					</TR>
					<!--- DAY 2 ======================== 
					<TR><TD align="right"><b> Sunday Availability </b> </TD>
						<TD><input type="Hidden" name="Day2" value="SUN">
							<!--- <SELECT name="Day2" > 
								<OPTION value="" selected>Day</OPTION>
								<CFLOOP list="#ddhhmmtt.DAY#" index="iD">  <OPTION value="#iD#" <CFIF Day2 EQ iD>selected</CFIF> >#iD#</OPTION>	</CFLOOP>
							</SELECT> --->
							<!--- ------------- From TIME -------------- --->
							<SELECT name="Hour2From" > 
								<OPTION value="0" selected>hr</OPTION>
								<CFLOOP list="#ddhhmmtt.HOUR#" index="iH">  <OPTION value="#iH#" <CFIF Hour2From EQ iH>selected</CFIF> >#iH#</OPTION>	</CFLOOP>
							</SELECT>
							<SELECT name="Minute2From" > 
								<OPTION value="0" selected>mn</OPTION>
								<CFLOOP list="#ddhhmmtt.MIN#" index="iM">	<OPTION value="#iM#" <CFIF Minute2From EQ iM>selected</CFIF> >#iM#</OPTION>	</CFLOOP>
							</SELECT>
							<SELECT name="Meridian2From" > 
								<CFLOOP list="#ddhhmmtt.TT#" index="iT">	<OPTION value="#iT#" <CFIF Meridian2From EQ iT>selected</CFIF> >#iT#</OPTION>	</CFLOOP>
							</SELECT>
							<!--- ------------- TO TIME -------------- --->
							<b>till </b>
							<SELECT name="Hour2To" > 
								<OPTION value="0" selected>hr</OPTION>
								<CFLOOP list="#ddhhmmtt.HOUR#" index="iH">  <OPTION value="#iH#" <CFIF Hour2To EQ iH>selected</CFIF> >#iH#</OPTION>	</CFLOOP>
							</SELECT>
							<SELECT name="Minute2To" > 
								<OPTION value="0" selected>mn</OPTION>
								<CFLOOP list="#ddhhmmtt.MIN#" index="iM">	<OPTION value="#iM#" <CFIF Minute2To EQ iM>selected</CFIF> >#iM#</OPTION>	</CFLOOP>
							</SELECT>
							<SELECT name="Meridian2To" > 
								<CFLOOP list="#ddhhmmtt.TT#" index="iT">	<OPTION value="#iT#" <CFIF Meridian2To EQ iT>selected</CFIF> >#iT#</OPTION>	</CFLOOP>
							</SELECT>
						</TD>
					</tr>
					============================== --->
					<TR><TD align="right">	<b> Sunday Comments</b>								</TD>
						<TD><input maxlength="100" name="Day2Comments" value="#Day2Comments#" size="#inputSize#" >	</TD>
					</TR>
					<TR><TD align="right">	<b>	Limitations/Exceptions</b>						</TD>
						<TD><input maxlength="200" name="Exceptions" value="#Exceptions#" size="#inputSize#"  >	</TD>
					</TR>
					<TR><TD align="right">	<b> #required# Directions	</b>					</TD>
						<TD><TEXTAREA  name="Directions" rows=12 cols=51>#Directions#</TEXTAREA>	
							<input type="Hidden" name="Directions_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Directions">
						</TD>
					</TR>
				</table>
			</TD>
		</TR>
		<TR align="center">
    		<TD colspan="2">
				<hr size="1">
				<CFIF swClubUser>
					<span class="red">New Fields are subjet to approval by NCSA.</span>
					<br>
					<br><INPUT type="submit" name="Request" value="Submit Request" >
				<CFELSE>
					<INPUT type="submit" name="Approve" value="Save" >
					<INPUT type="button" value="Back" onclick="history.back(-1)">
				</CFIF>
			</TD>
		</TR>
</TABLE>

</FORM>	
	
	
</cfoutput>
</div>
<cfinclude template="_footer.cfm">

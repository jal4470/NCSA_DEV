<!--- 
	FileName:	ClubAssignField.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
02/19/2009 - aarnone - swapped field name and abbr

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 

<cfoutput>
<div id="contentText">

<cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="getClubInfo" returnvariable="qClubs">
	<cfinvokeargument name="orderby" value="clubname">
</cfinvoke>


<CFIF isDefined("FORM.Clubselected")>
	<CFSET clubID = FORM.Clubselected>
<CFELSE>
	<CFSET clubID = 0>
</CFIF>


<CFIF isDefined("FORM.bAddField")>
	<CFIF isDefined("FORM.ADDFIELDIDS") AND listLen(FORM.ADDFIELDIDS) GT 0>
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="mapFieldToClub">
			<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
			<cfinvokeargument name="fieldIDs" value="#FORM.ADDFIELDIDS#">
		</cfinvoke> 
	</CFIF>
</CFIF>

<CFIF isDefined("FORM.bRemoveField")>
	<CFIF isDefined("FORM.remFieldIDs") AND listLen(FORM.remFieldIDs) GT 0>
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="mapRemoveFieldFromClub">
			<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
			<cfinvokeargument name="fieldIDs" value="#FORM.remFieldIDs#">
		</cfinvoke> 
	</CFIF>
</CFIF>


<cfset listClubFieldIDs = "">

<CFIF clubID GT 0>
	<!--- get the club's fields --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getFields" returnvariable="qClubFields">
		<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
		<cfinvokeargument name="orderBy" value="NAME">
	</cfinvoke>
	<CFIF qClubFields.recordCount>
		<cfset lstClubFieldIDs = valueList(qClubFields.FIELD_ID)>
	</CFIF>


	<!--- get all the OTHER fields  --->
	<CFQUERY name="qOtherFields" datasource="#SESSION.DSN#">
		SELECT FIELD_ID, FIELDABBR, FIELDNAME, CITY
		  From TBL_FIELD
		 WHERE ACTIVE_YN = 'Y'
		  <CFIF listLen(listClubFieldIDs)>
		  	AND FIELD_ID NOT IN (#listClubFieldIDs#)
		  </CFIF>
		  ORDER BY FIELDNAME
	</CFQUERY>

	
</CFIF>




<H1 class="pageheading">NCSA - Assign Fields to Club</H1>
<br><!--- <h2>Club Name </h2> --->

<form name="frmFieldMap" action="clubAssignField.cfm" method="post">
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="99%"  >
		<tr class="tblHeading">
			<TD> 	&nbsp; </TD>
		</tr>
		<TR><TD class="tdUnderLine" align="left">
				<b>Select a Club:</b>
				<Select name="Clubselected">
					<option value=0>Select a club</option>
					<CFLOOP query="qClubs">
						<option value="#CLUB_ID#" <CFIF CLUB_ID EQ clubID>selected</CFIF> >#CLUB_NAME#</option>
					</CFLOOP>
				</SELECT>
				<INPUT type="Submit" name="goClub" value=" Go ">
			</TD>
		</TR>
	
		<CFIF clubID>
			<tr><td> <span class="red">Hold the CTRL down to select muultiple fields.</span>
					
					<table cellspacing="0" cellpadding="0" align="left" border="0">
						<tr><td align="left" valign="top">
								<br><b>Fields Assigned to This Club:</b>
							</td>
							<td align="center" valign="top">
							</td>
							<td align="LEFT" valign="top">
								<br><b>All Other Fields:</b>
								<br>
							</td>
						</tr>
						<tr><td align="left" valign="top">
								<CFIF isDefined("qClubFields") AND qClubFields.RECORDCOUNT GT 0>
									<select name="remFieldIDs" size="30" multiple class="sizetext12" ><!--- (2 + qClubFields.RECORDCOUNT) --->
										<CFLOOP query="qClubFields">
											<CFSET fieldText =  FieldName & " [" & FIELDABBR & "]">
											<option value="#FIELD_ID#" title="#fieldText#" >#left(fieldText,49)#<CFIF len(fieldText) GT 49>...</CFIF><!--- [#FIELD_ID#] --->
										</CFLOOP>
									</select>
								<CFELSE>
									<select name="remFieldIDs" size="35" multiple >
										<option value="0" ><B>This club does not have any fields.</B> #RepeatString("&nbsp;",10)#
									</select>
								</CFIF>
							</td>
							<td align="center" valign="top">
								<br> 
								<br> Remove	
								<br> <input type="submit" name="bRemoveField" value=">>>>">
								<br> 
								<br> 
								<br> Add 	
								<br> <input type="submit" name="bAddField" value="<<<<">
							</td>
							<td align="right" valign="top">
								<CFIF isDefined("qOtherFields")>
									<select name="addFieldIDs" size="30" multiple class="sizetext12"><!--- #qOtherFields.RECORDCOUNT# --->
										<CFLOOP query="qOtherFields">
											<CFSET fieldText =  FieldName & " [" & FIELDABBR & "]">
											<option value="#FIELD_ID#" title="#fieldText#" >#left(fieldText,49)#<CFIF len(fieldText) GT 49>...</CFIF><!--- [#FIELD_ID#] --->
										</CFLOOP>
									</select>
								</CFIF>
							</td>
						</tr>
					</table>	
				</td>
			</tr>
		</CFIF>		
	</table>	


</form>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">

<!--- 
	FileName:	AssignorMapFields.cfm
	Created on: 11/04/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: maps fields to specific assignors
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 

<cfoutput>
<div id="contentText">

<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getRoleContacts" returnvariable="qAssignors">
	<cfinvokeargument name="roleID"   value="23">
	<cfinvokeargument name="seasonID" value="#SESSION.CURRENTSEASON.ID#">
</cfinvoke>


<CFIF isDefined("FORM.ContactIDselected")>
	<CFSET ContactIDselected = FORM.ContactIDselected>
<CFELSE>
	<CFSET ContactIDselected = 0>
</CFIF>


<CFIF isDefined("FORM.bAddField") OR isDefined("FORM.bAddAllFields")>
	<!--- if add all fields, replace list of field ids with resultset from query --->
	<CFIF isDefined("FORM.bAddAllFields")>
a		<!--- get all the OTHER fields  --->
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getAssignorFieldsUnAssigned" returnvariable="qOtherFields">
			<cfinvokeargument name="orderBy" value="NAME">
			<cfinvokeargument name="AssignorContactID" value="#VARIABLES.ContactIDselected#">
		</cfinvoke>
		<CFSET listAddFields = valuelist(qOtherFields.FIELD_ID)>
	<CFELSE>
b		<CFSET listAddFields = 	FORM.ADDFIELDIDS>
	</CFIF>
	<!--- add fields --->
	<CFIF listLen(VARIABLES.listAddFields) GT 0>
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="mapFieldToRefAssignor">
			<cfinvokeargument name="assignorContactID" value="#VARIABLES.ContactIDselected#">
			<cfinvokeargument name="fieldIDs" value="#VARIABLES.listAddFields#">
		</cfinvoke> 
	</CFIF>
</CFIF>

<CFIF isDefined("FORM.bRemoveField") OR  isDefined("FORM.bRemoveAllFields")>
	<!--- if remove all fields, replace list of field ids with resultset from query --->
	<CFIF isDefined("FORM.bRemoveAllFields")>
c		<!--- get the Contact's fields --->
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getAssignorFields" returnvariable="qAssignorFields">
			<cfinvokeargument name="AssignorContactID" value="#VARIABLES.ContactIDselected#">
			<cfinvokeargument name="orderBy" value="NAME">
		</cfinvoke>
		<CFSET listRemoveFields = valuelist(qAssignorFields.FIELD_ID)>
	<CFELSE>
d		<CFSET listRemoveFields = FORM.remFieldIDs>
	</CFIF>
	<!--- remove fields --->
	<CFIF listLen(VARIABLES.listRemoveFields) GT 0>
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="mapRemoveFieldFromRefAssignor">
			<cfinvokeargument name="assignorContactID" value="#VARIABLES.ContactIDselected#">
			<cfinvokeargument name="fieldIDs" value="#VARIABLES.listRemoveFields#">
		</cfinvoke> 
	</CFIF>
</CFIF>


<cfset lstAssignorFieldIDs = "">
<CFSET selectedNAME = "">
<CFIF ContactIDselected GT 0>
	<!--- get the Contact's fields --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getAssignorFields" returnvariable="qAssignorFields">
		<cfinvokeargument name="AssignorContactID" value="#VARIABLES.ContactIDselected#">
		<cfinvokeargument name="orderBy" value="NAME">
	</cfinvoke>
	<CFIF qAssignorFields.recordCount>
		<cfset lstAssignorFieldIDs = valueList(qAssignorFields.FIELD_ID)>
	</CFIF>


	<!--- get all the OTHER fields  --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getAssignorFieldsUnAssigned" returnvariable="qOtherFields">
		<cfinvokeargument name="orderBy" value="NAME">
		<cfinvokeargument name="AssignorContactID" value="#VARIABLES.ContactIDselected#">
	</cfinvoke>
	
	<!--- <CFQUERY name="qOtherFields" datasource="#SESSION.DSN#">
		SELECT FIELD_ID, FIELDABBR, FIELDNAME, CITY
		  From TBL_FIELD
		 WHERE ACTIVE_YN = 'Y'
		  <CFIF listLen(lstAssignorFieldIDs)>
		  	AND FIELD_ID NOT IN (#lstAssignorFieldIDs#)
		  </CFIF>
		  ORDER BY FIELDNAME
	</CFQUERY> --->

	<CFQUERY name="assignorNAme" dbtype="query">
		SELECT LastName + ', ' + FirstName AS ASSNR_NAME
		  FROM qAssignors
		 WHERE CONTACT_ID = #ContactIDselected#
	</CFQUERY>
	
	<cfset selectedNAME = assignorNAme.ASSNR_NAME>

</CFIF>



<H1 class="pageheading">NCSA - Assign Fields to a Referee Assignor</H1>
<br><!--- <h2>Club Name </h2> --->

<form name="frmFieldMap" action="AssignorMapFields.cfm" method="post">
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="99%"  >
		<tr class="tblHeading">
			<TD align="right"> <a href="assignorViewMappings.cfm" target="_blank">Display Field Assignments</a> 	&nbsp; </TD>
		</tr>
		<TR><TD class="tdUnderLine" align="left">
				<b>Select an Assignor:</b>
				<Select name="ContactIDselected">
					<option value=0>Select Assignor</option>
					<CFLOOP query="qAssignors">
						<option value="#CONTACT_ID#" <CFIF CONTACT_ID EQ ContactIDselected>selected</CFIF> >#LastName#, #FirstName#</option>
					</CFLOOP>
				</SELECT>
				<INPUT type="Submit" name="goAssignor" value=" Go ">
			</TD>
		</TR>
	
		<CFIF ContactIDselected>
			<tr><td> <span class="red">Hold the CTRL down to select muultiple fields.</span>
					
					<table cellspacing="0" cellpadding="0" align="left" border="0">
						<tr><td align="left" valign="top">
								<br>Fields Assigned to: <b> #selectedNAME#</b>
							</td>
							<td align="center" valign="top">
							</td>
							<td align="LEFT" valign="top">
								<br>All Fields Not Assigned to: <b> #selectedNAME#</b>
								<br>
							</td>
						</tr>
						<tr><td align="left" valign="top">
								<select name="remFieldIDs" size="25" multiple class="sizetext12" ><!--- (2 + qClubFields.RECORDCOUNT) --->
									<CFIF isDefined("qAssignorFields") AND qAssignorFields.RECORDCOUNT GT 0>
										<CFLOOP query="qAssignorFields">
											<CFSET fieldText = "[" & FIELDABBR & "] " & FieldName>
											<option value="#FIELD_ID#" title="#fieldText#" >#left(fieldText,40)#<CFIF len(fieldText) GT 40>...</CFIF><!--- [#FIELD_ID#] --->
										</CFLOOP>
									<CFELSE>
										<option value="0" ><B>This Assignor does not have any fields.</B> #RepeatString("&nbsp;",10)#
									</CFIF>
								</select>
							</td>
							<td align="center" valign="top">
								<br> 
								<br> &nbsp;Remove &nbsp; <br> <input type="submit" name="bRemoveField" value="&nbsp; > &nbsp;">
								<br> <br> 
								<br> &nbsp;Add    &nbsp; <br> <input type="submit" name="bAddField"    value="&nbsp; < &nbsp;">
								<br> <br>
								<br> <br> 
								<br> <br> 
								<br> <br> 
								<br> &nbsp;Remove ALL&nbsp; <br> <input type="submit" name="bRemoveAllFields" value=">>>">
								<br> <br> 
								<br> &nbsp;Add ALL  &nbsp;	<br> <input type="submit" name="bAddAllFields"    value="<<<">
							</td>
							<td align="right" valign="top">
								<select name="addFieldIDs" size="25" multiple class="sizetext12"><!--- #qOtherFields.RECORDCOUNT# --->
									<CFIF isDefined("qOtherFields") AND qOtherFields.RECORDCOUNT GT 0>
										<CFLOOP query="qOtherFields">
											<CFSET fieldText = "[" & FIELDABBR & "] " & FieldName>
											<option value="#FIELD_ID#" title="#fieldText#" >#left(fieldText,40)#<CFIF len(fieldText) GT 40>...</CFIF><!--- [#FIELD_ID#] --->
										</CFLOOP>
									<CFELSE>
										<option value="0" ><B>This Assignor has been assigned to ALL fields.</B> #RepeatString("&nbsp;",10)#
									</CFIF>
								</select>
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

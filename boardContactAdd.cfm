<!--- 
	FileName:	boardContactAdd.cfm
	Created on: 11/18/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: used to add board member 
	
MODS: mm/dd/yyyy - flastname - comments

 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfif isDefined("FORM.BACK")>
	<cflocation url="boardContactList.cfm">
</cfif>


<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Boardmember Add</H1>

<cfset swErrors = false>	
<cfset errMsg = "">

<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getRoleList" returnvariable="qRoles">
	<cfinvokeargument name="listRoleType" value="'SU','BU','SA','RA'">
</cfinvoke><!---  <cfdump var="#qRoles#"> --->
<cfset lRoleIDs = valueList(qRoles.ROLE_ID)>

<cfset useSeason = SESSION.CURRENTSEASON.ID>
<cfif isDefined("SESSION.regSeason.ID")>
	<cfset useSeason = SESSION.regSeason.ID>
</cfif>

<!--- get all contacts that have specific roles --->
<CFQUERY name="getcontactRoles" datasource="#SESSION.DSN#">
	select x.contact_id, x.xref_contact_role_id, c.FirstNAme, c.LastName, r.roleCode, r.role_id
	  from xref_contact_role x 
			INNER JOIN TBL_CONTACT c on c.CONTACT_ID = x.CONTACT_ID
			INNER JOIN TLKP_ROLE   r on r.role_id  = x.role_id  
	 where x.role_id IN (#VARIABLES.lRoleIDs#)
	   and x.season_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.useSeason#">
	   and x.active_yn = 'Y'
	ORDER BY c.LastName, c.FirstNAme
</CFQUERY> <!--- <cfdump var="#getcontactRoles#"> --->

<cfif isDefined("FORM.xrefContactRoleID")> 
	<cfset xrefContactRoleID = FORM.xrefContactRoleID>
<cfelse>
	<cfset xrefContactRoleID = "">
</cfif>

<cfif isDefined("FORM.ncsaTitle")> 
	<cfset ncsaTitle = trim(FORM.ncsaTitle)>
<cfelse>
	<cfset ncsaTitle = "">
</cfif>

<cfif isDefined("FORM.ncsaPhone")> 
	<cfset ncsaPhone = trim(FORM.ncsaPhone)>
<cfelse>
	<cfset ncsaPhone = "">
</cfif>

<cfif isDefined("FORM.ncsaFax")> 
	<cfset ncsaFax = trim(FORM.ncsaFax)>
<cfelse>
	<cfset ncsaFax = "">
</cfif>

<cfif isDefined("FORM.ncsaEmail")> 
	<cfset ncsaEmail = trim(FORM.ncsaEmail)>
<cfelse>
	<cfset ncsaEmail = "">
</cfif>

<cfif isDefined("FORM.SAVE")>
	<cfinvoke component="#SESSION.sitevars.cfcPath#formValidate" method="validateFields" returnvariable="stValidFields">
		<cfinvokeargument name="formFields" value="#FORM#">
	</cfinvoke>  <!--- <cfdump var="#stValidFields#"> --->
	
	<CFIF stValidFields.errors>
		<cfset swErrors = true>	
	</CFIF>
	
	<CFIF NOT swErrors>
		<CFQUERY name="getSpecificContactRole" dbtype="query">
			select contact_id, role_id
			  from getcontactRoles
			 where xref_contact_role_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.xrefContactRoleID#">
		</CFQUERY> 
	
		<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="insertBoardMemberInfo" returnvariable="boardMemberID">
			<cfinvokeargument name="RoleID" 	value="#getSpecificContactRole.role_id#">
			<cfinvokeargument name="sequence"		   value="99">
			<cfinvokeargument name="ncsaPhone"		   value="#FORM.ncsaPhone#">
			<cfinvokeargument name="ncsaFax"		   value="#FORM.ncsaFax#">
			<cfinvokeargument name="ncsaEmail"		   value="#FORM.ncsaEmail#">
			<cfinvokeargument name="ncsaTitle"		   value="#FORM.ncsaTitle#">
			<cfinvokeargument name="ContactID" 	value="#getSpecificContactRole.contact_id#">
		</cfinvoke>
 
		<cfif len(trim(boardMemberID)) AND boardMemberID GT 0>
			<cflocation url="boardContactList.cfm">
		<cfelse>
			<cfset swErrors = true>	
			<cfset errMsg = "Boardmember was not added, please try again.">
		</cfif>
	</CFIF>
</cfif>


	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>">

<form action="boardContactAdd.cfm" method="post">

<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD colspan="2">
		 	Add a Boardmember:
		</TD>
	</tr>
		<cfif swErrors>
			<TR><TD colspan="2" align="center" class="red">
					<b>Please correct the following errors and submit again.</b>
					<br>
					#stValidFields.errorMessage#
					#errMsg#
				</td>
			</TR>
		</cfif>
	<TR><TD align="right" width="20%"><b>Select a contact/role:</b></TD>
		<TD><select  name="xrefContactRoleID" >
				<option value="0" >select User/Role</option>
				<cfloop query="getcontactRoles">
				<option value="#xref_contact_role_id#" <cfif xrefContactRoleID EQ xref_contact_role_id>selected</cfif>   >[#xref_contact_role_id#] #LastName#, #FirstNAme# - #roleCode#</option>
				</cfloop>
			</select>
		</TD>
	</TR>
	<TR><TD align="right">#required# <b>NCSA Title</b></TD>
		<TD><input type="Text"  maxlength="50" name="ncsaTitle" value="#ncsaTitle#" >
			<input type="Hidden" name="ncsaTitle_ATTRIBUTES" 	value="type=GENERIC~required=1~FIELDNAME=NCSA Title">	
		</TD>
	</TR>
	<TR><TD align="right">#required# <b>NCSA Phone</b><br>999-999-9999</TD>
		<TD><input type="Text"  maxlength="20" name="ncsaPhone" value="#ncsaPhone#" >
			<input type="Hidden" name="ncsaPhone_ATTRIBUTES" 	value="type=PHONE~required=1~FIELDNAME=NCSA Phone">	
		</TD>
	</TR>
	<TR><TD align="right"><b>NCSA Fax</b><br>999-999-9999</TD>
		<TD><input type="Text"  maxlength="20" name="ncsaFax" 	value="#ncsaFax#" >
			<input type="Hidden" name="ncsaFax_ATTRIBUTES" 		value="type=PHONE~required=0~FIELDNAME=NCSA Fax">	
		</TD>
	</TR>
	<TR><TD align="right">#required# <b>NCSA Email</b></TD>
		<TD><input type="Text"  maxlength="50" name="ncsaEmail" value="#ncsaEmail#" >
			<input type="Hidden" name="ncsaEmail_ATTRIBUTES" 	value="type=EMAIL~required=1~FIELDNAME=NCSA Email">	
		</TD>
	</TR>
	<tr><td>&nbsp;		</td>
		<td><input type="Submit" name="Save"  value="Save">
			<input type="Submit" name="Back"  value="Back">
		</td>
	</tr>
</table>
</form>  	

</div>
</cfoutput>
<cfinclude template="_footer.cfm">







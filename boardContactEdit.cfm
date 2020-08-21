<!--- 
	FileName:	boardContactEdit.cfm
	Created on: 11/17/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: used to edit the board member's contact info
	
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
<H1 class="pageheading">NCSA - Boardmember Edit</H1>
<!--- <h2>yyyyyy </h2> --->



<CFIF isDefined("URL.BMID") AND isNumeric(URL.BMID)>
	<cfset bmID = URL.BMID >
<cfelseif isDefined("FORM.boardMemberID") AND isNumeric(FORM.boardMemberID)>
	<cfset bmID = FORM.boardMemberID >
<cfelse>
	<cfset bmID = 0 >
</CFIF>


<cfif isDefined("FORM.DEACTIVATE")>
	<cfquery name="qDeactivateBoardMember" datasource="#SESSION.DSN#">
		UPDATE TBL_BOARDMEMBER_INFO
		   SET ACTIVE_YN = 'N'
		     , SEQUENCE  = 99
		 WHERE BOARDMEMBER_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.BOARDMEMBERID#">
	</cfquery>
	<cflocation url="boardContactList.cfm">
</cfif>

<cfif isDefined("FORM.ACTIVATE")>
	<cfquery name="qActivateBoardMember" datasource="#SESSION.DSN#">
		UPDATE TBL_BOARDMEMBER_INFO
		   SET ACTIVE_YN = 'Y'
		     , SEQUENCE = 99
		 WHERE BOARDMEMBER_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.BOARDMEMBERID#">
	</cfquery>
	<cflocation url="boardContactList.cfm">
</cfif>




<CFIF isDefined("FORM.SAVE")>
	<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="updateBoardMemberInfo">
		<cfinvokeargument name="boardMemberID" value="#FORM.boardMemberID#">
		<cfinvokeargument name="sequence"	   value="#FORM.sequence#">
		<cfinvokeargument name="ncsaPhone"	   value="#FORM.ncsaPhone#">
		<cfinvokeargument name="ncsaFax"	   value="#FORM.ncsaFax#">
		<cfinvokeargument name="ncsaEmail"	   value="#FORM.ncsaEmail#">
		<cfinvokeargument name="ncsaTitle"	   value="#FORM.ncsaTitle#">
	</cfinvoke>

	<cflocation url="boardContactList.cfm">
	
</CFIF>







<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="getBoardMemberInfo" returnvariable="boardMems">
	<cfinvokeargument name="DSN" value="#SESSION.DSN#">
	<cfinvokeargument name="boardMemberID" value="#VARIABLES.bmID#">
</cfinvoke>  <!--- <cfdump var="#boardMems#"> --->

<cfif boardMems.recordCount>
	<cfset contactID = boardMems.CONTACT_ID >
	<!--- <cfset xcrID	 = boardMems.XREF_CONTACT_ROLE_ID > --->
	<cfset sequence	 = boardMems.sequence >
	<cfset firstName = boardMems.FIRSTNAME >
	<cfset lastName	 = boardMems.LASTNAME >
	<cfset ncsaEmail = boardMems.NCSAEMAIL >
	<cfset ncsaFax	 = boardMems.NCSAFAX >
	<cfset ncsaPhone = boardMems.NCSAPHONE >
	<cfset ncsaTitle = boardMems.TITLE >
	<cfset activeYN  = boardMems.ACTIVE_YN >
<cfelse>
	<cfset contactID = "" >
	<!--- <cfset xcrID	 = "" > --->
	<cfset sequence	 = "" >
	<cfset firstName = "" >
	<cfset lastName	 = "" >
	<cfset ncsaEmail = "" >
	<cfset ncsaFax	 = "" >
	<cfset ncsaPhone = "" >
	<cfset ncsaTitle = "" >
	<cfset activeYN  = "" >
</cfif>



	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>">
<form action="boardContactEdit.cfm" method="post">
<input type="Hidden" name="boardMemberID" value="#VARIABLES.bmID#">
<input type="Hidden" name="sequence" 	  value="#VARIABLES.sequence#">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD colspan="2">
		 	Edit Boardmember: #LastName#, #FirstName# 	
		</TD>
	</tr>
	<TR><TD align="right" width="20%"><b>Name:</b></TD>
		<TD>#LastName#, #FirstName#
			<cfif activeYN EQ "Y">
				- <span class="green"><b>ACTIVE</b></span>
			<cfelse>
				- <span class="red"><b>NOT Active</b></span>
			</cfif>
		</TD>
		
	</TR>
	<TR><TD align="right"><b>NCSA Title</b></TD>
		<TD><input type="Text"  maxlength="50" name="ncsaTitle" 	value="#ncsaTitle#" >
			<input type="Hidden" name="ncsaTitle_ATTRIBUTES" value="type=GENERIC~required=0~FIELDNAME=NCSA Title">	
		</TD>
	</TR>
	<TR><TD align="right"><b>NCSA Phone</b><br> 999-999-9999</TD>
		<TD><input type="Text"  maxlength="20" name="ncsaPhone" 	value="#ncsaPhone#" >
			<input type="Hidden" name="ncsaPhone_ATTRIBUTES" value="type=PHONE~required=0~FIELDNAME=NCSA Phone">	
		</TD>
	</TR>
	<TR><TD align="right"><b>NCSA Fax</b><br> 999-999-9999</TD>
		<TD><input type="Text"  maxlength="20" name="ncsaFax" 	value="#ncsaFax#" >
			<input type="Hidden" name="ncsaFax_ATTRIBUTES" value="type=PHONE~required=0~FIELDNAME=NCSA Fax">	
		</TD>
	</TR>
	<TR><TD align="right"><b>NCSA Email</b></TD>
		<TD><input type="Text"  maxlength="50" name="ncsaEmail"  size="40"	value="#ncsaEmail#" >
			<input type="Hidden" name="ncsaEmail_ATTRIBUTES" value="type=EMAIL~required=0~FIELDNAME=NCSA Email">	
		</TD>
	</TR>
	<tr><td colspan="2"  >
			<CFIF activeYN EQ "Y">
				<input type="Submit" name="DEACTIVATE"  value="Make Inactive">
			<CFELSE>
				<input type="Submit" name="ACTIVATE"  	value="Make Active">
			</CFIF>
			&nbsp;&nbsp;
			<input type="Submit" name="Save"    value="Save Changes">
			&nbsp;&nbsp;
			<input type="Submit" name="Back"    value="Back to List">
		</td>
	</tr>
</table>
</form>  	

</div>
</cfoutput>
<cfinclude template="_footer.cfm">



 

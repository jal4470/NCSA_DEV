<!--- 
	FileName:	fineTypeProcess.cfm
	Created on: 09/22/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>

<CFSET amount = "">
<CFSET description = "">
<CFSET action = "">
<CFSET msg = "">
<CFSET fineTypeID = 0>

<CFIF isDefined("FORM.BACK")>
	<CFLOCATION url="fineTypeList.cfm">
</CFIF>
			
<CFIF IsDefined("FORM.FineTypeId")>
	<CFSET fineTypeID = FORM.FineTypeId>	
	<CFQUERY name="getFineType" datasource="#SESSION.DSN#">
		SELECT DESCRIPTION, Amount
		FROM TLKP_Fine_Type
		WHERE FINETYPE_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.fineTypeID#">
	</CFQUERY>
	<CFSET amount = getFineType.Amount>
	<CFSET description = getFineType.DESCRIPTION>
</CFIF>	

<CFIF IsDefined("FORM.ADD")>	<!--- ====== ADD ====== --->
	<CFSET title = "Fine Type ADD">
	<cfset Action = "ADD">
	<CFIF isDefined("FORM.AMOUNT") AND LEN(TRIM(FORM.AMOUNT)) AND isDefined("FORM.Description") AND LEN(TRIM(FORM.Description))>
		<CFSET amount = FORM.AMOUNT>
		<CFSET description = FORM.Description>
		<CFIF isNumeric(FORM.AMOUNT)>
			<CFQUERY name="addFineType" datasource="#SESSION.DSN#">
				Insert into TLKP_Fine_Type
					( Amount, DESCRIPTION )
				values
					( <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#VARIABLES.amount#">
					, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.Description#">
					)
			</CFQUERY>
			<CFLOCATION url="fineTypeList.cfm">
		<CFELSE>
			<CFSET msg = "Amount must be numeric, no dollar signs, letters or other characters.">
		</CFIF>
	<CFELSE>
		<CFSET msg = "Amount and Description are both required.">
	</CFIF>
</CFIF>

<CFIF IsDefined("FORM.EDIT")>	<!--- ====== EDIT ====== --->
	<CFSET title = "Fine Type Edit">
	<cfset Action = "EDIT">
	<CFIF isDefined("FORM.AMOUNT") AND LEN(TRIM(FORM.AMOUNT)) AND isDefined("FORM.Description") AND LEN(TRIM(FORM.Description))>
		<CFSET amount = FORM.AMOUNT>
		<CFSET description = FORM.Description>
		<CFIF isNumeric(FORM.AMOUNT)>
			<CFIF getFineType.DESCRIPTION NEQ description OR getFineType.Amount NEQ Amount>
				<CFQUERY name="updateFineType" datasource="#SESSION.DSN#">
					UPDATE TLKP_Fine_Type
					   SET DESCRIPTION = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.Description#">
						 , Amount	   = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.amount#">
					 WHERE FINETYPE_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.fineTypeID#">
				</CFQUERY>
				<CFLOCATION url="fineTypeList.cfm">
			</CFIF>
		<CFELSE>
			<CFSET msg = "Amount must be numeric, no dollar signs, letters or other characters.">
		</CFIF>
	<CFELSE>
		<CFSET msg = "Amount and Description are both required.">
	</CFIF>
</CFIF>

<CFIF IsDefined("FORM.DELETE")>	<!--- ====== DELETE ====== --->
	<CFSET title = "Fine Type Delete">
	<cfset Action = "DELETE">
	<cfset msg = "Click Delete to delete this fine type.">
	<CFIF isDefined("FORM.ACTION") AND FORM.ACTION EQ "DELETE">
		<CFQUERY name="updateFineType" datasource="#SESSION.DSN#">
			Delete From TLKP_Fine_Type
			 Where FINETYPE_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.fineTypeID#">
		</CFQUERY>
		<CFLOCATION url="fineTypeList.cfm">
	</CFIF>
</CFIF>


<div id="contentText">
<H1 class="pageheading">NCSA - #title#</H1>
<br> <!--- <h2>yyyyyy </h2> --->
<FORM action="fineTypeProcess.cfm"  method="post">
<input type="Hidden" name="action" value="#action#">
<input type="Hidden" name="fineTypeID" value="#fineTypeID#">
<table cellspacing="0" cellpadding="5" align="LEFT" border="0" width="80%">
	<CFIF len(Trim(msg))>
		<tr><TD colspan="2" align="center"><span class="red"><b>#msg#</b></span> </TD>
		</tr>
	</CFIF>
	<tr class="tblHeading">
		<TD colspan="2"> &nbsp; </TD>
	</tr>
	<tr><TD align="right" width="30%"> <b>Fine Amount:</b>		</TD>
		<TD align="left" width="70%"> 
			<input type="Text" name="amount" value="#variables.amount#">
		</TD>
	</tr>
	<tr><TD align="right"> <b>Description:</b>		</TD>
		<TD align="left">
			<input type="Text" name="Description" value="#variables.Description#" size="85">
		</TD>
	</tr>
	<tr><TD colspan="3" align="center">
			<CFswitch expression="#ACTION#">
				<cfcase value="ADD"> <input type="SUBMIT" name="ADD" value="Add">  </cfcase>
				<cfcase value="EDIT"><input type="SUBMIT" name="EDIT" value="Save"></cfcase>
				<cfcase value="DELETE"><input type="SUBMIT" name="DELETE" value="Delete"></cfcase>
			</CFSWITCH>
			<input type="SUBMIT" name="BACK" value="Back">
		</TD>
	</tr>
</table>	
</FORM>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">



<!--- 
	FileName:	ContactRequestDisplay.cfm
	Created on: 10/30/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

9/12/2012 - J. Rab - After a user is approved, set to active as well.

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Approve Contact Request</H1>
<!--- <br> <h2>yyyyyy </h2> --->

<cfset errMsg = "">


<CFIF isDefined("FORM.BACK")>
	<cflocation url="contactRequestList.cfm">
</CFIF>

<CFIF isDefined("FORM.ApproveContact")>
	<!--- <cfquery name="qAppContact" datasource="#SESSION.DSN#">
		UPDATE TBL_CONTACT
		   SET APPROVE_YN = 'Y'
		 WHERE CONTACT_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.contactSelected#">
	</cfquery> --->
	<!--- this was a requested contact that was Approved, only the info needs to be updated  --->
	<cfquery name="updateRequestContact" datasource="#SESSION.DSN#">
				UPDATE TBL_CONTACT
				   SET FIRSTNAME  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.FirstName#" >
					 , LASTNAME   = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.LastName#">
					 , ADDRESS 	  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.Address#">
					 , CITY 	  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.Town#">
					 , STATE 	  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.State#">
					 , ZIPCODE	  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.Zip#">
					 , PHONEHOME  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.HPhone#">
					 , PHONEWORK  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.WPhone#">
					 , PHONECELL  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.CPhone#">
					 , PHONEFAX	  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.Fax#">
					 , EMAIL 	  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.Email#">
					 , APPROVE_YN = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="Y" >
					 , ACTIVE_YN = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="Y" >
					 , UPDATEDATE = GETDATE()
					 , UPDATEDBY  = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.USER.CONTACTID#">
			 	 WHERE CONTACT_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.contactSelected#">
	</cfquery>
	<cflocation url="contactRequestList.cfm">
	<!--- <cflocation url="contactEdit.cfm?c=#FORM.contactSelected#"> --->
</CFIF>

<CFIF isDefined("FORM.ApproveReferee")>
	<cfquery name="qAppContact" datasource="#SESSION.DSN#">
		UPDATE TBL_CONTACT
		   SET APPROVE_YN = 'Y'
		     , ACTIVE_YN  = 'Y'
		 WHERE CONTACT_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.contactSelected#">
	</cfquery>
	<cfquery name="qAppContact" datasource="#SESSION.DSN#">
		UPDATE XREF_CONTACT_ROLE
		   SET active_yn = 'Y'
		 WHERE contact_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.contactSelected#">
		   AND role_id = 25
	</cfquery>
	<!--- <cflocation url="contactRequestList.cfm"> --->
	<cflocation url="contactEdit.cfm?c=#FORM.contactSelected#">
</CFIF>

<CFIF isDefined("FORM.RejectContact")>
	<cfif isDefined("FORM.rejectComment") AND len(trim(FORM.rejectComment)) GT 0>
		<cfquery name="qAppContact" datasource="#SESSION.DSN#">
			UPDATE TBL_CONTACT
			   SET APPROVE_YN = 'N'
			     , REJECT_COMMENT = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.rejectComment#">
			 WHERE CONTACT_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.contactSelected#">
		</cfquery>
		<cflocation url="contactRequestList.cfm">

	<cfelse>	
		<cfset errMsg = "Rejection Comments are required when rejecting.">
	</cfif>
	
	
</CFIF>

<CFIF isDefined("URL.c") AND len(trim(URL.c))>
	<CFSET contactSelected = URL.c>
<CFELSEIF isDefined("FORM.contactSelected")>
	<CFSET contactSelected = FORM.contactSelected>
<CFELSE>
	<CFSET contactSelected = 0>
</CFIF>

<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getContactInfo" returnvariable="qContactInfo">
	<cfinvokeargument name="contactID" value="#VARIABLES.contactSelected#">
</cfinvoke>

<CFSET FirstName = qContactInfo.FirstName>
<CFSET LastName  = qContactInfo.LastName>
<CFSET Address 	 = qContactInfo.Address>
<CFSET Town 	 = qContactInfo.City>
<CFSET State 	 = qContactInfo.State>
<CFSET Zip 		 = qContactInfo.ZipCode>
<CFSET HPhone 	 = qContactInfo.PhoneHome>
<CFSET CPhone 	 = qContactInfo.PhoneCell>
<CFSET WPhone 	 = qContactInfo.PhoneWork>
<CFSET Fax 		 = qContactInfo.PhoneFax>
<CFSET Email 	 = qContactInfo.Email>
<CFSET rejectComment = qContactInfo.REJECT_COMMENT>

<!--- Referees can request to be added, follow the regular contact info process?? --->
<CFQUERY name="getRefereeInfo" datasource="#SESSION.DSN#">
	SELECT  RI.certified_yn,	RI.grade, 
			RI.StateRegisteredIn, RI.birth_date,
			RI.certified_1st_year, RI.Ref_level, RI.Additional_ref_info,
			XCR.xref_contact_role_ID
	FROM    xref_contact_role XCR LEFT JOIN tbl_referee_info RI ON RI.contact_ID = XCR.contact_ID
	WHERE   XCR.role_id = 25 
	AND 	XCR.contact_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.contactSelected#">
</CFQUERY>	<!--- cfdump var="#getRefereeInfo#">	 --->

<!--- <cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="getRefereeInfo">
			<cfinvokeargument name="refereeID" value="#variables.contactSelected#">
</cfinvoke>	<!--- <cfdump var="#qRefInfo#"><cfinvokeargument name="xrefContactRoleID" value="#VARIABLES.RefereeID#"> --->
<CFIF getRefereeInfo.RECORDCOUNT EQ 0 and isDefined("SESSION.REGSEASON.ID")>
	<!--- they maybe a requested referee for the reg season 			<cfinvokeargument name="xrefContactRoleID" value="#VARIABLES.RefereeID#">--->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="getRefereeInfo">
			<cfinvokeargument name="refereeID" value="#variables.contactSelected#">
			<cfinvokeargument name="seasonID" value="#SESSION.REGSEASON.ID#">
	</cfinvoke>	<!--- <cfdump var="#qRefInfo#"> --->
</CFIF>
<CFIF getRefereeInfo.RECORDCOUNT>
	<CFQUERY name="getAddlInfo" datasource="#SESSION.DSN#">
		SELECT 
	</CFQUERY>
</CFIF> --->


	
<!--- ============================================================================================= --->
<form name="frmContact" action="ContactRequestDisplay.cfm" method="post">
	<input type="Hidden" name="contactSelected" value="#VARIABLES.contactSelected#">	
	<!--- <CFIF getRefereeInfo.RECORDCOUNT>
		<input type="Hidden" name="xrefContactRoleID" value="#getRefereeInfo.xref_contact_role_ID#">	
	</CFIF> --->
	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>">
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="100%">

		<CFIF len(trim(errMsg))>
			<tr><TD colspan="2"> &nbsp; <span class="red"><b>#errMsg#</b></span> </TD>
			</tr>
		</CFIF>

		<tr class="tblHeading">
			
			<TD width="50%"> &nbsp;	 Requested Contact's Info </TD>
			<TD >&nbsp; </TD>

		</tr>

		<!--- <CFIF swUpdateRequestOnly><!--- rejected request back for editing ---> --->
			<CFSET swShowRoles = FALSE>	
			<CFSET swShowLoginPW = FALSE>	
			<CFSET swBoardMember = FALSE>	
		<!--- <CFELSE>
			<CFSET swShowRoles = TRUE>	
			<CFSET swShowLoginPW = TRUE>	
		</CFIF>		 --->
		
		<cfinclude template="contactForm_inc.cfm">
		<!--- 
		<TR><TD align="right"> <b>First Name:</b></TD>	<TD> #FirstName# 	</TD>		</TR>
		<TR><TD align="right"><b>Last Name:</b></TD>	<TD> #LastName#	</TD>		</TR>
		<TR><TD align="right"><b>Address:</b></TD>		<TD> #Address#  	</TD>		</TR>
		<TR><TD align="right"><b>Town:</b></TD>			<TD> #Town# 	</TD>		</TR>
		<TR><TD align="right"> <b>State:</b></TD>		<TD> #State#	</TD>		</TR>
		<TR><TD align="right"> <b>Zip:</b></TD>			<TD> #Zip# 	</TD>		</TR>
		<TR><TD align="right"><b>Home Phone:</b></TD>	<TD> #HPhone#	</TD>		</TR>
		<TR><TD align="right"><b>Cell Phone:</b></TD>	<TD> #CPhone#	</TD>		</TR>
		<TR><TD align="right"> <b>Work Phone:</b></TD>	<TD> #WPhone#	</TD>		</TR>
		<TR><TD align="right"><b>Fax:</b></TD>			<TD> #Fax#	</TD>		</TR>
		<TR><TD align="right"><b>EMail:</b></TD>		<TD> #EMail#	</TD>		</TR> --->

		<CFIF getRefereeInfo.RECORDCOUNT>
		<tr><TD colspan="2"> 
				<table>
		 		<TR><TD align="center" colspan="2"><br> <b>Referee Specific Info:</b></TD>
				<TR><TD align="right"><b>Date Of Birth:</b></TD>		<TD> #dateFormat(getRefereeInfo.birth_date,"mm/dd/yyyy")#</TD>
				<TR><TD align="right"><b>Grade:</b></TD>				<TD> #getRefereeInfo.grade#</TD>
				<TR><TD align="right"><b>State Registered In:</b></TD>	<TD> #getRefereeInfo.StateRegisteredIn#</TD>
				<TR><TD align="right"><b>Certified:</b></TD>			<TD> #getRefereeInfo.certified_yn#</TD>
				<TR><TD align="right"><b>Year First Certified:</b></TD>	<TD> #getRefereeInfo.certified_1st_year#</TD>
				<TR><TD align="right"><b>Additional Info:</b></TD>		<TD> #getRefereeInfo.Additional_ref_info#</TD>
				</table>
			</TD>
		</tr>
		</CFIF>

		<tr><td colspan="2"><hr></td>
		</tr>

		
		<tr><td colspan="2">
				<table>
					<TR><TD align="right"><b>Rejection Comments:</b> <br> <span class="red">required if rejecting.</span></TD>
						<TD><TEXTAREA name="rejectComment" rows=3  cols=50>#Trim(rejectComment)#</TEXTAREA>
						</TD>
					</TR>

					<tr><td colspan="2" align="center">
							<CFIF getRefereeInfo.RECORDCOUNT>
								<input type="submit" name="ApproveReferee" value="Approve">
							<CFELSE>
								<input type="submit" name="ApproveContact" value="Approve">
							</CFIF>
							&nbsp; &nbsp;
							<input type="submit" name="RejectContact" value="Reject">
							 &nbsp; &nbsp;
							<input type="submit" name="Back" value="Back">
							<br>
							<br> 
							<span class="red">(Approving a contact will also take you to the approved contact's edit page.)</span> 
						</td>
					</tr>				
				</table>
			</td>
		</tr>

		
					
	</table>
</form>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">

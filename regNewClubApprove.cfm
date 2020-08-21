<!--- 
	FileName:	regNewClubApprove.cfm
	Created on: 09/08/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: if the club is approved, this page will insert the club into TBL_CLUB, create the first user (president) along
			with the login and password that is assigned.
	
MODS: mm/dd/yyyy - filastname - comments
07/18/2016 - R. Gonzalez - Added form updComment value check to force a comment update
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">  

<CFSET errMsg = "">
<CFSET swShowFORM = TRUE>

<CFIF isDefined("FORM.updComment") AND isDefined("FORM.clubID")>
	<!--- Update the comments with most recent comments from this page. --->
	<cfinvoke component="#SESSION.sitevars.cfcPath#registration" method="updateClubComments" returnvariable="testingout2">
		<cfinvokeargument name="ClubID" value="#FORM.CLUBID#">
		<cfinvokeargument name="Comment" value="#form.comments#">
	</cfinvoke>  
</CFIF>

<CFIF isDefined("FORM.REJECT")>
	<cflocation url="regNewClubReject.cfm?id=#FORM.CLUBID#">
</CFIF>
<CFIF isDefined("FORM.DELETE")>
	<cflocation url="regNewClubDelete.cfm?id=#FORM.CLUBID#">
</CFIF>


<CFIF isDefined("FORM.SAVE")>
	<cfinvoke component="#SESSION.sitevars.cfcPath#formValidate" method="validateFields" returnvariable="stValidFields">
		<cfinvokeargument name="formFields" value="#FORM#">
	</cfinvoke>  <!--- <cfdump var="#stValidFields#"> --->

	<CFIF stValidFields.errors>
		<CFSET errMsg = "Please correct the following errors and submit again.">
	<CFELSE> <!--- process the club --->
		<!--- check if usernam exists.... --->
		<CFQUERY name="qGetUserName" datasource="#SESSION.DSN#">
			SELECT USERNAME 
			  FROM TBL_CONTACT
			 WHERE USERNAME = <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#FORM.LOGIN#">
		</CFQUERY>
		
		<CFIF qGetUserName.RECORDCOUNT>
			<CFSET errMsg = #FORM.LOGIN# & " already exists for another user, please use a different user id.">
		<CFELSE>
			<!--- insert club.... --->
			<cfif isDefined("SESSION.REGSEASON")>
				<cfset applyToSeasonID = SESSION.REGSEASON.ID >
			<cfelse>
				<cfset applyToSeasonID = SESSION.CURRENTSEASON.ID >
			</cfif>
			
			<cfinvoke component="#SESSION.SITEVARS.CFCPATH#Club" method="approveNewClubRequest" returnvariable="stClubIns">
				<cfinvokeargument name="newClubID" value="#FORM.CLUBID#">
				<cfinvokeargument name="seasonID" value="#VARIABLES.applyToSeasonID#">
				<cfinvokeargument name="contactID" value="#SESSION.USER.CONTACTID#">
			</cfinvoke> <!--- [inserted club = <cfdump var="#stClubIns#">] --->

			<CFIF stClubIns.ClubID>
				<!--- club was inserted --->
				<CFSET insertedClubID = stClubIns.clubID>
				<!--- insert contact.... --->
				<cfinvoke component="#SESSION.SITEVARS.CFCPATH#Contact" method="insertContact" returnvariable="contactID">
					<cfinvokeargument name="username"  value="#FORM.LOGIN#">
					<cfinvokeargument name="password"  value="#FORM.password#">
					<cfinvokeargument name="firstName" value="#FORM.presFname#">
					<cfinvokeargument name="lastName"  value="#FORM.presLname#">
					<cfinvokeargument name="address"   value="#FORM.presAddress#">
					<cfinvokeargument name="city"	   value="#FORM.presTown#">
					<cfinvokeargument name="state"	   value="#FORM.presState#">
					<cfinvokeargument name="zipcode"   value="#FORM.presZip#">
					<cfinvokeargument name="phoneHome" value="#FORM.homePhone#">
					<cfinvokeargument name="phoneWork" value="#FORM.workPhone#">
					<cfinvokeargument name="phoneCell" value="#FORM.cellPhone#">
					<cfinvokeargument name="phoneFax"  value="#FORM.Fax#">
					<cfinvokeargument name="email"	   value="#FORM.email#">
					<cfinvokeargument name="active_yn" value="Y">
					<cfinvokeargument name="createdBy" value="#SESSION.USER.CONTACTID#">
					<cfinvokeargument name="club_id"   value="#VARIABLES.insertedClubID#">
					<cfinvokeargument name="editContactID" value="0">
				</cfinvoke>	<!--- [inserted CONTACT = <cfdump var="#VARIABLES.contactID#">] --->
 
			
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="setContactRoleList">
					<cfinvokeargument name="contact_id" value="#contactID#">
					<cfinvokeargument name="season_id" value="#variables.applyToSeasonID#">
					<cfinvokeargument name="role_list" value="#SESSION.CONSTANT.ROLEIDCLUBPRES#">
				</cfinvoke>
			
			
				<!--- Update ClubRegRequest Table --->
				<CFQUERY name="qUpdClubRegReq" datasource="#SESSION.DSN#">
					UPDATE TBL_ClubRegRequest
					   SET status = 'A'
					     , updateDate = getDate()
						 , updatedBy  = #SESSION.USER.CONTACTID#
					 WHERE ID = #FORM.CLUBID#
				</CFQUERY>
				<!--- GET CLUB INFO --->
				<!--- Update the comments with most recent comments from this page. --->
				<cfinvoke component="#SESSION.sitevars.cfcPath#registration" method="updateClubComments" returnvariable="testingout">
					<cfinvokeargument name="ClubID" value="#FORM.CLUBID#">
					<cfinvokeargument name="Comment" value="#form.comments#">
				</cfinvoke>  

				<CFSET errMsg = "Club: " & FORM.CLUBNAME & " has been approved.">
				<CFSET swShowFORM = FALSE>
			<CFELSE>
				<CFSET errMsg = "ERROR: " & stClubIns.Message >
			</CFIF>
		</CFIF>
	</CFIF>
</CFIF>

<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - New Club Registration</H1>
<br>
<h2>For Club: #FORM.CLUBNAME# </h2>

<CFIF len(trim(errMsg))>
	<span class="red">
			<b>#errMsg#</b>
			<br><CFIF isDefined("stValidFields.errorMessage")>
					#stValidFields.errorMessage#
				</CFIF>
	</span>
</CFIF>




<CFIF swShowFORM>
	<form action="regNewClubApprove.cfm" method="post">
		<input type="Hidden" name="clubID"		value="#FORM.clubID#">
		<input type="Hidden" name="clubName"	value="#FORM.clubName#">
		<input type="Hidden" name="presFname"	value="#FORM.presFname#">
		<input type="Hidden" name="presLname"	value="#FORM.presLname#">
		<input type="Hidden" name="homePhone"	value="#FORM.homePhone#">
		<input type="Hidden" name="cellPhone"	value="#FORM.cellPhone#">
		<input type="Hidden" name="Fax"			value="#FORM.Fax#">
		<input type="Hidden" name="workPhone"	value="#FORM.workPhone#">
		<input type="Hidden" name="email"		value="#FORM.email#">
		<input type="Hidden" name="presAddress" value="#FORM.presAddress#">
		<input type="Hidden" name="presTown"	value="#FORM.presTown#">
		<input type="Hidden" name="presState"	value="#FORM.presState#">
		<input type="Hidden" name="presZip"		value="#FORM.presZip#">
		<input type="Hidden" name="comments" value="#FORM.COMMENTS#">

	<table cellspacing="0" cellpadding="5" align="LEFT" border="0" width="50%">
		<tr class="tblHeading">
			<td colspan="2"> &nbsp; President Info:</td>
		</tr>
		<TR><td width="18%" align="right"> <b>Name: </b>	</TD>
			<td >#FORM.presFname# #FORM.presLname#</TD>
		</TR>
		<tr><td align="right" valign="top"> <b>Phone ##s: </b>		</TD>
			<td>
				<table>
					<TR><td align="right"> <b>Home: </b></TD>
						<td>#FORM.HOMEPHONE#</TD>
						<td align="right"> <b>Cell: </b>		</TD>
						<td >#FORM.CELLPHONE#			</TD>
					</TR>
					<TR><td align="right"><b>Fax</b>:</b>	</TD>
						<td >#FORM.FAX#			</TD>
						<td align="right"><b>Work: </b> </td>
						<td>	#FORM.WORKPHONE#			</TD>
					</TR>
				</table>
			</td>
		</tr>
		<TR><td align="right">  <b>EMail:</b>		</TD>
			<td > #FORM.EMAIL# </TD>
		</TR>
		<tr class="tblHeading">
			<td colspan="2"> &nbsp; Assign Login name and password:</td>
		</tr>
		<TR><td align="right"> <b>User Id: </b>	</TD>
			<td><input type="text"   name="login" value="">
				<input type="Hidden" name="login_ATTRIBUTES" value="type=generic~required=1~FIELDNAME=User ID">
			</TD>
		</TR>
		<TR><td align="right"> <b>Password: </b>	</TD>
			<td><input type="text"   name="password" value="">
				<input type="Hidden" name="password_ATTRIBUTES" value="type=generic~required=1~FIELDNAME=Password">
			</TD>
		</TR>
		<tr ><td colspan="2" align="center"  >
				<br><INPUT type="Button" name="goback" value="<< Back" onclick="history.go(-1)">
					&nbsp; &nbsp;
					<INPUT type="submit" name="SAVE" value="Save">
				</TD>
			</tr>
	</table>	
	</form>
</CFIF>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">

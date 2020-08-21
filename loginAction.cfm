<!--- 
	FileName:	loginAction.cfm
	Created on: 08/18/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: this file will process the values passed by login.cfm. If the values are invalid, go back to the login page
	
MODS: mm/dd/yyyy - filastname - comments
	12/03/2008 - aarnone - added allowSchedule_YN to user session structure.
	05/27/2009 - aarnone - T:7584 - WriteLoginLogRecord  returns a value for siteAccessLogID which will be saved in SESSION,
							it will be used to tie page access rows to a single login session
	8/8/2011 - Joe Lechuga -  added logic to determine if any roles, assigned to the logged in user, apply to the edit schedule priviledge
 --->

<!--- initialize data --->
<CFSETTING enablecfoutputonly="true" showdebugoutput="false">
<cfset data = {}>

<CFIF IsDefined("FORM.uname") AND len(trim(FORM.uname))> 
	<CFSET uname = trim(FORM.uname) >
<CFELSE>
	<!--- <cflocation url="login.cfm?msg=Please enter a user name and password."> --->
	<cfset data.STATUS = "Error">
	<cfset data = serializeJSON(data)>
	<cfoutput>#data#</cfoutput>
	<cfabort>
</CFIF>

<CFIF IsDefined("FORM.pword") AND len(trim(FORM.pword))> 
	<CFSET pword = trim(FORM.pword) >
<CFELSE>
	<!--- <cflocation url="login.cfm?msg=Please enter a user name and password."> --->
	<cfset data.STATUS = "Error">
	<cfset data = serializeJSON(data)>
	<cfoutput>#data#</cfoutput>
	<cfabort>
</CFIF>
 
 
<!--- form variables are present, lets see if values entered are valid ---> 

<!--- Session("ValidUser")	= "0"
Session("Loginclub_id")	= 0
Session("LoginName")	= " "
Session("roleType")	= "  "
Session("ProfileDesc")	= " "
Session("ValidSession")	= "1"
Session("AllowGameEdit") = "N" --->


<!--- IF SelectedroleType = "" THEN --->
	<CFSET allowLogin 	   = "NO">
<!--- ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
	<!--- First Time in --->
	<CFSET ctMatchingRoles = 0>

	
	<!--- SELECT from tbl_contact	 --->
	<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="getLIcontact"  returnvariable="qGetContact">
		<cfinvokeargument name="uname" value="#trim(VARIABLES.uname)#"> 
		<cfinvokeargument name="pword" value="#trim(VARIABLES.pword)#"> 
	</cfinvoke> 
	
	<CFIF qGetContact.recordCount>
		<!--- found a match - login valid, but can user login?		 --->
		<CFSET foundContactID = qGetContact.CONTACT_ID>
		<CFSET foundclubid    = qGetContact.Club_Id>
		
		<!--- is login valid for current season? --->
		<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="ValidContactSeason" returnvariable="qContactSeason">
			<cfinvokeargument name="contactID" value="#foundContactID#">
			<cfinvokeargument name="seasonID"  value="#SESSION.CURRENTSEASON.ID#">
		</cfinvoke>

		<CFIF qContactSeason.recordCount>
			<!--- user found in CURR season and is allowed to next step... --->
			<CFSET allowLogin = "YES">
			<CFSET foundSeasonID = SESSION.CURRENTSEASON.ID>
		<CFELSE>
			<!--- user NOT found in CURR season, check the REG season... --->
			<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="ValidContactSeason" returnvariable="qContactREGSeason">
				<cfinvokeargument name="contactID" value="#foundContactID#">
				<cfinvokeargument name="seasonID"  value="#SESSION.REGSEASON.ID#">
			</cfinvoke>

			<CFIF qContactREGSeason.recordCount>
				<!--- user found in REG seasonand is allowed to next step... --->
				<CFSET allowLogin = "YES">
				<CFSET foundSeasonID = SESSION.REGSEASON.ID>
			<CFELSE>
				<!--- user NOT found in REG season, check Past seasons... --->
				<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="ValidContactSeason" returnvariable="qContactPREVSeason">
					<cfinvokeargument name="contactID" value="#foundContactID#">
					<cfinvokeargument name="seasonID"  value="#SESSION.REGSEASON.ID#">
					<cfinvokeargument name="lRoleID"  value="26,27,28">
				</cfinvoke>
				
				<CFIF qContactPREVSeason.recordCount>
					<!--- 
					user found in PAST season, but see if there is someone else in the position...
					loop roles to see if they are taken by a current contact use the first season as the season to use
					 --->
					<CFSET foundSeasonID = qContactPREVSeason.season_id>
					<CFLOOP query="qContactPREVSeason">
						<CFIF SEASON_ID EQ foundSeasonID>
							<!---  see if the role is already used by a more current contact --->
							<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="ValidRoleSeasonClub" returnvariable="qMatchRole">
								<cfinvokeargument name="roleID"   value="#ROLE_ID#">
								<cfinvokeargument name="seasonID" value="#VARIABLES.foundseasonID#">
								<cfinvokeargument name="club_id"   value="#VARIABLES.foundclub_id#">
							</cfinvoke>
							
							<CFIF qMatchRole.RECORDCOUNT>
								<!---  A matching role was found, this means that there is a more current user in that role --->
								<CFSET ctMatchingRoles = ctMatchingRoles + 1 >
							</CFIF>
						</CFIF>
					</CFLOOP>
		
					<CFIF ctMatchingRoles GT 0>
						<CFSET allowLogin = "NO">
					<CFELSE>
						<CFSET allowLogin = "YES">
					</CFIF>
				</CFIF>
				
			</CFIF>
			
		</CFIF>
		
	</CFIF>
	
???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? --->

<CFIF isDefined("SESSION.CURRENTSEASON.ID")>
	<CFSET currentSeasonID = SESSION.CURRENTSEASON.ID >
<CFELSE>
	<CFSET currentSeasonID = 0 >
</CFIF>
<CFIF isDefined("SESSION.REGSEASON.ID")>
	<CFSET regSeasonID = SESSION.REGSEASON.ID >
<CFELSE>
	<CFSET regSeasonID = 0 >
</CFIF>
<!--- 
[<cfdump var="#VARIABLES.uname#">]
[<cfdump var="#VARIABLES.pword#">]
[<cfdump var="#VARIABLES.currentSeasonID#">]
[<cfdump var="#VARIABLES.regSeasonID#">] 
--->
	<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="VerifyLogin" returnvariable="stLogin">
		<cfinvokeargument name="uname" value="#trim(VARIABLES.uname)#"> 
		<cfinvokeargument name="pword" value="#trim(VARIABLES.pword)#"> 
		<cfinvokeargument name="seasonID" value="#VARIABLES.currentSeasonID#"> 
		<cfinvokeargument name="REGseasonID" value="#VARIABLES.regSeasonID#"> 
	</cfinvoke> 

<!--- [<cfdump var="#stLogin#">] --->




<CFIF NOT stLogin.allowYN>
	<!--- NO MATCH - Failed login attempt --->
	<cfinvoke component="#SESSION.sitevars.cfcpath#site" method="WriteFailedLoginLogRecord">
		<cfinvokeargument name="UserID" 	value="#VARIABLES.uname#">
		<cfinvokeargument name="SessionID" 	value="#SESSION.SESSIONID#">
		<cfinvokeargument name="REMOTEUSER" value="#CGI.REMOTE_USER#">
		<cfinvokeargument name="REMOTEHOST" value="#CGI.REMOTE_HOST#">
		<cfinvokeargument name="USERAGENT" 	value="#CGI.HTTP_USER_AGENT#">
		<cfinvokeargument name="REMOTEADDR" value="#CGI.REMOTE_ADDR#">
	</cfinvoke>
	
	<!--- <CFLOCATION url="login.cfm?msg=User name and/or password is not valid."> --->
	<cfset data.STATUS = "Error">
	<cfset data = serializeJSON(data)>
	<cfoutput>#data#</cfoutput>
	<cfabort>
</CFIF>
	




<CFIF stLogin.qContactInfo.RECORDCOUNT>
	<CFSET rowsFound = stLogin.qContactInfo.RECORDCOUNT>
	<!--- Joe Lechuga - 8/8/2011 - added logic to determine if any roles, assigned to the logged in user, apply to the edit schedule priviledge --->
	<cfquery dbtype="query" name="checkIfAllowdToSchedule">
		select count(*) as AllowedSched_Count from stLogin.qContactInfo where ALLOWSCHEDULE_YN = 'Y'
	</cfquery>
	<cfif len(trim(checkIfAllowdToSchedule.AllowedSched_Count))>
		<cfset allowSchedule_YN = 'Y'>
	<cfelse>
		<cfset allowSchedule_YN = 'N'>
	</cfif>
	
	<!--- WriteLoginLogRecord() --->

	<CFSET ContactID	 = stLogin.qContactInfo.Contact_ID>
	<CFSET FirstName	 = stLogin.qContactInfo.FirstName>
	<CFSET LastName		 = stLogin.qContactInfo.LastName>
	<CFSET ContactRoleID = stLogin.qContactInfo.XREF_CONTACT_ROLE_ID>
	<CFSET roleID	 	 = stLogin.qContactInfo.role_id>
	<CFSET roleType 	 = stLogin.qContactInfo.roleType>
	<CFSET RoleCode		 = stLogin.qContactInfo.RoleCode>
	<CFSET clubid		 = stLogin.qContactInfo.club_id>
	<CFSET clubName		 = stLogin.qContactInfo.club_Name>
	<CFSET AllowScheduleYN = allowSchedule_YN>
	<CFSET AllowGameEdit = stLogin.qContactInfo.Allow_game_edit>

	<cfset stROLE = structNew()>

	<CFIF rowsFound EQ 1 >
		<CFSET stRole[VARIABLES.ROLEID] = VARIABLES.RoleCode>


		<!--- == START only 1 role == --->
		<!--- <CFSWITCH expression="#roleType#">
			<CFCASE value="CU">				<CFSET ProfileDesc	= "Club Representative">			</CFCASE>	
			<CFCASE value="SU">				<CFSET ProfileDesc	= "Super User">			</CFCASE>	
			<CFCASE value="BU">				<CFSET ProfileDesc	= "Board Member">			</CFCASE>	
			<CFCASE value="RA">				<CFSET ProfileDesc	= "Referee Assignor">			</CFCASE>	
			<CFCASE value="RF">				<CFSET ProfileDesc	= "Referee">			</CFCASE>	
		</CFSWITCH>  --->

		<cfif roleType eq "CU">
			<!--- OPEN REG, CLUB INFO --->
			<!--- sql	= "Select ID, RegSubmit, InfoUpdated, TermsAccepted, Club, ClubInfoUpd, BondInfoUpd " & _
					  "	 from V_CLUBINFO			 " & _ 
					  " Where ID = " & club_id 	  	
				set rs = objConn.Execute(sql) --->
																
			<!--- If rs.BOF and rs.EOF then  
				Session("ClubInfoId") = ""
				Session("UserId")	  = ""
				Session("Password")	  = ""
				Session("Mode")		  = ""
				Session("RegSubmit")	= ""
				Session("InfoUpdated")	= ""
				Session("ClubInfoUpd")	= ""
				Session("BondInfoUpd")	= ""
				Session("TermsAccepted")= ""
				Session("ClubRegistered") = ""
			 else
				<!--- season open reg --->
				<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
					<CFSET SESSION.OPENCLUBREG = structNew()>
					<CFSET SESSION.OPENCLUBREG.ClubInfoId	 = rs("ID").value
					<CFSET SESSION.OPENCLUBREG.Mode			 = "MODIFY"
					<CFSET SESSION.OPENCLUBREG.RegSubmit	 = rs("RegSubmit").value
					<CFSET SESSION.OPENCLUBREG.InfoUpdated	 = rs("InfoUpdated").value
					<CFSET SESSION.OPENCLUBREG.ClubInfoUPd	 = rs("ClubInfoUpd").value
					<CFSET SESSION.OPENCLUBREG.BondInfoUPd	 = rs("BondInfoUpd").value
					<CFSET SESSION.OPENCLUBREG.TermsAccepted = rs("TermsAccepted").value
					<CFSET SESSION.OPENCLUBREG.ClubName		 = rs("Club").value
				</CFLOCK>
			End If --->
		</cfif>

		<!--- Response.Redirect("Menu.asp")
		'== END only 1 role ================================================================================== --->

	<CFELSE>
	<!--- 
		<CFSET roleIDList = "">
		<CFSET roleCodeList = "">
		
		<CFLOOP query="stLogin.qContactInfo">
			<cfset roleIDList = listAppend(roleIDList, trim(ROLE_ID), ",")>			
			<!--- omit "COACH" --->
			<CFIF NOT trim(ROLECODE) EQ "COACH">
				<cfset RoleCodeList = listAppend(RoleCodeList, trim(ROLECODE), ",")>			
			</CFIF>
		</CFLOOP>
		<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
			<CFSET SESSION.User.roleIDList	  = VARIABLES.roleIDList>
			<CFSET SESSION.User.lRoleCode	  = VARIABLES.RoleCodeList>
			<CFSET SESSION.User.RoleType	  = "">
		</CFLOCK> 
	--->
		<CFLOOP query="stLogin.qContactInfo">
			<CFSET stRole[trim(ROLE_ID)] = trim(ROLECODE)>
		</CFLOOP>

	</CFIF>

	<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
		<CFSET SESSION.User = STRUCTNEW()>
		<CFSET SESSION.User.ContactID	  = VARIABLES.contactID>
		<CFSET SESSION.User.ContactRoleID = VARIABLES.ContactRoleID>
		<CFSET SESSION.User.uname		  = trim(VARIABLES.uname)> 
		<CFSET SESSION.User.pword		  = trim(VARIABLES.pword)> 
		<CFSET SESSION.User.fname		  = VARIABLES.FirstName>
		<CFSET SESSION.User.lname		  = VARIABLES.LastName>
		<CFSET SESSION.User.AllowGameEdit = VARIABLES.AllowGameEdit>
		<CFSET SESSION.User.AllowScheduleYN = VARIABLES.AllowScheduleYN>
		<CFSET SESSION.User.validUser	  = 1>
		<!--- <CFSET SESSION.User.RoleType	  = VARIABLES.roleType> --->
		<!---  <CFSET SESSION.User.lRoleCode	  = VARIABLES.RoleCode> --->
		<CFSET SESSION.User.Clubid		  = VARIABLES.clubid>
		<CFSET SESSION.User.ClubName	  = VARIABLES.clubName>
		<!--- <CFIF qContactInfo.active_yn EQ "N"> Session("NewClub") = "Y" <CFELSE> Session("NewClub") = "" </CFIF>  	--->
		<CFSET SESSION.User.stRole = structCopy(stRole)>
	</CFLOCK> 


	<!--- log successful login --->
	<cfinvoke component="#SESSION.sitevars.cfcpath#site" method="WriteLoginLogRecord" returnvariable="siteAccessLogID">
		<cfinvokeargument name="UserID" 	value="#VARIABLES.uname#">
		<cfinvokeargument name="SessionID" 	value="#SESSION.SESSIONID#">
		<cfinvokeargument name="REMOTEADDR" value="#CGI.REMOTE_ADDR#">
		<cfinvokeargument name="browserInfo" value="#CGI.HTTP_USER_AGENT#">
	</cfinvoke>

	<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
		<CFSET SESSION.User.siteAccessLogID = VARIABLES.siteAccessLogID>
	</CFLOCK> 

	<!--- NOTE!!! NOTE!!! NOTE!!!
		  check session variables to see if they exist. LOGOUT should crush some struct values 
		  and they will have to be recreated here.
	--->
	<cfset keyList = listSort(structKeyList(SESSION.USER.stRole),"numeric","asc")>
	<CFIF listLen(keyList) EQ 1>
		<!--- only ONE role --->
		<!--- <CFLOCATION url="loginHome.cfm?rid=#keyList#"> --->
		<cfset data.STATUS = "Success">
		<cfset data.keyList = keyList>
		<cfset data.redirect = "loginHome.cfm?rid=" & keyList>
		<cfset data = serializeJSON(data)>
		<cfoutput>#data#</cfoutput>
		<cfabort>
	<CFELSE>
		<!--- has MANY roles --->
		<!--- <CFLOCATION url="loginHome.cfm"> --->
		<cfset data.STATUS = "Success">
		<cfset data.redirect = "loginHome.cfm">
		<cfset data = serializeJSON(data)>
		<cfoutput>#data#</cfoutput>
		<cfabort>
	</CFIF>
		
<CFELSE>
	<!--- NO MATCH - Failed login attempt....... --->
	<cfinvoke component="#SESSION.sitevars.cfcpath#site" method="WriteFailedLoginLogRecord">
		<cfinvokeargument name="UserID" 	value="#VARIABLES.uname#">
		<cfinvokeargument name="SessionID" 	value="#SESSION.SESSIONID#">
		<cfinvokeargument name="REMOTEUSER" value="#CGI.REMOTE_USER#">
		<cfinvokeargument name="REMOTEHOST" value="#CGI.REMOTE_HOST#">
		<cfinvokeargument name="USERAGENT" 	value="#CGI.HTTP_USER_AGENT#">
		<cfinvokeargument name="REMOTEADDR" value="#CGI.REMOTE_ADDR#">
	</cfinvoke>
	<!--- <CFLOCATION url="login.cfm?msg=There was no matching log in information."> --->
	<cfset data.STATUS = "Error">
	<cfset data = serializeJSON(data)>
	<cfoutput>#data#</cfoutput>
	<cfabort>
</CFIF>








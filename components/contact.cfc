

<cfcomponent>
<CFSET DSN = SESSION.DSN>
		<!--- ===================== 
		functions: 
			getBoardMemberInfo
			getLIcontact
			ValidContactSeason
			ValidRoleSeasonClub
			SeasonContactInfo
			VerifyLogin
			getClubContacts
			changePW
			deleteXrefContactRole
			insertContactRole
			getClubContactRoleX
		========================= --->

<!--- =================================================================== --->
<cffunction name="getBoardMemberInfo" access="public" returntype="query">
	<!--- --------
		08/07/08 - AArnone - New function: getBoardMemberInfo Returns a list of board members
	----- --->
	<cfargument name="dsn"		 type="string"  required="Yes">
	<!--- <CFARGUMENT name="xrefContactRoleID" type="numeric" required="no" default=0> --->
	<CFARGUMENT name="RoleID"		 type="numeric" required="no" default=0>
	<CFARGUMENT name="ContactID"	 type="numeric" required="no" default=0>
	<CFARGUMENT name="boardMemberID" type="numeric" required="no" default=0>
	
	<CFQUERY name="qBoardMemInfo" datasource="#VARIABLES.DSN#">
		SELECT  DISTINCT 
				bmi.boardmember_id, 
				bmi.sequence, 
				bmi.NCSA_Phone 		AS ncsaPhone, 
				bmi.NCSA_Fax   		AS ncsaFax, 
				bmi.NCSA_Email 		AS ncsaEmail,
				bmi.NCSA_Title		AS Title,
				bmi.Active_YN,
				r.roleDisplayName 	AS Role, 	
				r.roleType,
				c.CONTACT_ID,
				c.FirstName, c.LastName, 
				c.address, 	 c.city, 
				c.state, 	 c.zipcode, 
				c.phoneHome			AS contactPhoneHome,
				c.phoneWork			AS contactPhoneWork,
				c.phoneCell			AS contactPhoneCell,
				c.phoneFax			AS contactPhoneFax,
				c.email				AS contactEmail
		FROM 	tbl_BoardMember_info bmi 
				INNER JOIN xref_contact_role xcr ON xcr.contact_ID = bmi.contact_ID AND xcr.role_id = bmi.role_id
				INNER JOIN tbl_contact c ON c.contact_id = xcr.contact_id 
				INNER JOIN tlkp_role r ON r.role_id = xcr.role_id
				where 1=1
		<cfif isDefined("ARGUMENTS.RoleID") AND ARGUMENTS.RoleID GT 0>
			AND xcr.role_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.RoleID#"> 
		</cfif>
		<cfif isDefined("ARGUMENTS.ContactID") AND ARGUMENTS.ContactID GT 0>
			AND xcr.contact_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#"> 
		</cfif>
		<cfif isDefined("ARGUMENTS.boardMemberID") AND ARGUMENTS.boardMemberID GT 0>
			AND bmi.boardmember_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.boardMemberID#"> 
		</cfif>
		ORDER BY bmi.sequence 
	</CFQUERY>
		<!--- FROM 	tbl_BoardMember_info bmi 
					INNER JOIN xref_contact_role xcr ON xcr.xref_contact_role_ID = bmi.xref_contact_role_ID 
					INNER JOIN tbl_contact c		 ON c.contact_id = xcr.contact_id 
					INNER JOIN tlkp_role r			 ON r.role_id = xcr.role_id
		where xcr.season_id = (select season_id from tbl_season where currentSeason_YN = 'Y') --->



	
	<cfreturn qBoardMemInfo>
</cffunction>



<!--- =================================================================== --->
<cffunction name="updateBoardMemberInfo" access="public" >
	<!--- --------
		11/11/08 - AArnone - updates board member's NCSA specific info
	----- --->
	<CFARGUMENT name="boardMemberID" type="numeric" required="yes">
	<CFARGUMENT name="sequence"		 type="numeric" required="no">
	<CFARGUMENT name="ncsaPhone"	 type="string" required="yes" >
	<CFARGUMENT name="ncsaFax"		 type="string" required="yes" >
	<CFARGUMENT name="ncsaEmail"	 type="string" required="yes" >
	<CFARGUMENT name="ncsaTitle"	 type="string" required="yes" >
	
	<cfstoredproc procedure="p_update_boardmember_info" datasource="#VARIABLES.DSN#" returncode="Yes">
		<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@boardmember_id" value="#ARGUMENTS.boardMemberID#"> 
		<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@sequence" 	   value="#ARGUMENTS.sequence#"> 
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@NCSA_Phone"     value="#ARGUMENTS.ncsaPhone#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@NCSA_Fax"	   value="#ARGUMENTS.ncsaFax#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@NCSA_Email"	   value="#ARGUMENTS.ncsaEmail#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@NCSA_Title"	   value="#ARGUMENTS.ncsaTitle#">
	</cfstoredproc>

</cffunction>

	
<!--- =================================================================== --->
<cffunction name="insertBoardMemberInfo" access="public" returntype="numeric">
	<!--- --------
		11/11/08 - AArnone - Inserts board member's NCSA specific info
		12/15/08 - aa - replacred xrefContactRoleID with RoleID and ContactID
	----- --->
	<!--- <CFARGUMENT name="xrefContactRoleID" type="numeric" required="no" default=0> --->
	<CFARGUMENT name="RoleID" 		 type="numeric" required="yes">
	<CFARGUMENT name="sequence"		 type="numeric" required="no">
	<CFARGUMENT name="ncsaPhone"	 type="string" required="yes" >
	<CFARGUMENT name="ncsaFax"		 type="string" required="yes" >
	<CFARGUMENT name="ncsaEmail"	 type="string" required="yes" >
	<CFARGUMENT name="ncsaTitle"	 type="string" required="yes" >
	<CFARGUMENT name="ContactID" 	 type="numeric" required="YES">
	
	<cfstoredproc procedure="p_insert_boardmember_info" datasource="#VARIABLES.DSN#" returncode="Yes">
		<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@role_ID" 		value="#ARGUMENTS.RoleID#"> 
		<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@sequence" 	   value="#ARGUMENTS.sequence#"> 
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@NCSA_Phone"     value="#ARGUMENTS.ncsaPhone#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@NCSA_Fax"	   value="#ARGUMENTS.ncsaFax#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@NCSA_Email"	   value="#ARGUMENTS.ncsaEmail#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@NCSA_Title"	   value="#ARGUMENTS.ncsaTitle#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@contact_ID" 		value="#ARGUMENTS.ContactID#"> 
		<cfprocparam type="Out" cfsqltype="CF_SQL_NUMERIC" dbvarname="@boardmember_id" variable="boardMemberID">
	</cfstoredproc>
	
	<cfReturn boardMemberID>

</cffunction>


	
<!--- =================================================================== --->
<cffunction name="getLIcontact" access="public" returntype="query">
	<!--- --------
		08/19/08 - AArnone - New function: getLIcontact returns contact info based on login values
	----- --->
	<CFARGUMENT name="uname" required="Yes" type="string" default="">
	<CFARGUMENT name="pword" required="Yes" type="string" default="">

	<CFQUERY name="qLIcontact" datasource="#VARIABLES.DSN#">
		SELECT CONTACT_ID, USERNAME, Club_Id
		  FROM TBL_CONTACT
		 WHERE USERNAME = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.uname#">
		   AND PASSWORD = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.pword#">
	</CFQUERY>

	<cfreturn qLIcontact>
</cffunction>
	

<!--- =================================================================== --->
<cffunction name="ValidContactSeason" access="public" returntype="query">
	<!--- --------
		08/19/08 - AArnone - New function: ValidContactSeason 
							returns contact info based on contact id and season id, the list of role ids is optional
	----- --->
	<CFARGUMENT name="contactID" required="Yes" type="numeric" default=0>
	<CFARGUMENT name="seasonID"  required="Yes" type="numeric" default=0>
	<CFARGUMENT name="lRoleID"   required="No"  type="string"  default="">

	<CFQUERY name="qValidConSeas" datasource="#VARIABLES.DSN#">
		SELECT xref_contact_role_ID, role_id, season_id
		  FROM xref_contact_role
		 WHERE contact_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.contactID#">
		   AND season_id  = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.seasonID#">
			<CFIF isDefined("ARGUMENTS.lRoleID") and len(trim(ARGUMENTS.lRoleID)) GT 1>
				AND role_id in (<cfqueryparam cfsqltype="CF_SQL_VARCHAR" list="Yes" value="#ARGUMENTS.lRoleID#">)
			<CFELSEIF isDefined("ARGUMENTS.lRoleID") and len(trim(ARGUMENTS.lRoleID)) EQ 1>
				AND role_id = (<cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.lRoleID#">)
			</CFIF>
	</CFQUERY>

	<cfreturn qValidConSeas>

</cffunction>

<!--- =================================================================== --->
<cffunction name="ValidPastContactSeason" access="public" returntype="query">
	<!--- --------
		01/20/09 - AArnone - New function: ValidPastContactSeason 
							returns contact info based on contact id 
									and any season older than season passed in
									 and the list of role ids
	----- --->
	<CFARGUMENT name="contactID" required="Yes" type="numeric" default=0>
	<CFARGUMENT name="seasonID"  required="Yes" type="numeric" default=0>
	<CFARGUMENT name="lRoleID"   required="No"  type="string"  default="">

	<CFQUERY name="qValidPastConSeas" datasource="#VARIABLES.DSN#">
		SELECT xref_contact_role_ID, role_id, season_id, club_id
		  FROM xref_contact_role
		 WHERE contact_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.contactID#">
		   AND season_id  < <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.seasonID#">
			<CFIF isDefined("ARGUMENTS.lRoleID") and len(trim(ARGUMENTS.lRoleID)) GT 1>
				AND role_id in (<cfqueryparam cfsqltype="CF_SQL_VARCHAR" list="Yes" value="#ARGUMENTS.lRoleID#">)
			<CFELSEIF isDefined("ARGUMENTS.lRoleID") and len(trim(ARGUMENTS.lRoleID)) EQ 1>
				AND role_id = (<cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.lRoleID#">)
			</CFIF>
	</CFQUERY>

	<cfreturn qValidPastConSeas>

</cffunction>


<!--- =================================================================== --->
<cffunction name="ValidRoleSeasonClub" access="public" returntype="query">
	<!--- --------
		08/19/08 - AArnone - New function: ValidRoleSeasonClub 
							returns contact info based on role id and season id and club id
	----- --->
	<CFARGUMENT name="roleID"   required="Yes" type="numeric" default=0>
	<CFARGUMENT name="seasonID" required="Yes" type="numeric" default=0>
	<CFARGUMENT name="clubID"   required="Yes" type="numeric" default=0>

	<CFQUERY name="qValidRoleSeasClub" datasource="#VARIABLES.DSN#">
		SELECT xref_contact_role_ID, role_id, season_id
		  FROM xref_contact_role				
		 WHERE role_id 	  = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.roleID#"> 
		   AND season_id  > <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.seasonID#"> 
		   AND club_id    = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.clubID#"> 
	</CFQUERY>

	<cfreturn qValidRoleSeasClub>
</cffunction>

<!--- =================================================================== --->
<cffunction name="SeasonContactInfo" access="public" returntype="query">
	<!--- --------
		08/19/08 - AArnone - New function: SeasonContactInfo
							returns contact info based on contact id and season id 
		12/03/08 - AArnone - added CL.allowSchedule_YN to select.
	----- --->
	<CFARGUMENT name="seasonID"  required="Yes" type="numeric" default=0>
	<CFARGUMENT name="contactID" required="Yes" type="numeric" default=0>
	<CFARGUMENT name="roleID"    required="No"  type="string" default=0>

	<CFQUERY name="qGetContactSinfo" datasource="#VARIABLES.DSN#">
		SELECT co.CONTACT_ID,
				co.username,
				co.password,
				co.FirstName,
				co.LastName, 	
				tr.roleType, 	
				tr.roleDisplayName,  
				tr.RoleCode,		  
				cl.club_NAME,	
				cl.allowSchedule_YN,	  
				xcr.role_ID,		  
				xcr.club_id, 	 
				xcr.season_id,		  
				xcr.active_yn, 	 
				xcr.xref_contact_role_id,  
				xcr.Allow_game_edit   
		 FROM dbo.xref_contact_role xcr
				INNER JOIN tbl_contact co ON co.contact_id = xcr.contact_id and xcr.ACTIVE_YN = 'Y'
				INNER JOIN tbl_CLUB    cl ON cl.club_id = xcr.club_id
				INNER JOIN tlkp_role   tr ON tr.role_id = xcr.role_id
		 where xcr.season_id  =  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.seasonID#"> 
		   AND xcr.CONTACT_ID =  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.contactID#">
			<CFIF isDefined("ARGUMENTS.roleID") and ARGUMENTS.roleID GT 0>
				AND xcr.ROLE_ID in ( <cfqueryparam cfsqltype="CF_SQL_VARCHAR" list="Yes" value="#ARGUMENTS.roleID#"> )
			</CFIF>
    	   ORDER BY xcr.ROLE_ID  
	</CFQUERY>

	<cfreturn qGetContactSinfo>
</cffunction>



<!--- =================================================================== --->
<cffunction name="getContactInfo" access="public" returntype="query">
	<!--- 09/15/08 - AArnone - returns info for contact id passed
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo">
			<cfinvokeargument name="contactID" value="#.#">
		</cfinvoke>
	----- --->
	<CFARGUMENT name="contactID" required="Yes" type="numeric" default=0>

	<CFQUERY name="getuser" datasource="#VARIABLES.DSN#">
		Select Club_id, FirstName, LastName, Address, City, State, Zipcode, 
			   PhoneHome, PhoneCell, PhoneWork, PhoneFax, Email,
			   Active_Yn, username, password, APPROVE_YN, REJECT_COMMENT,pass_number
	      from tbl_contact 
		 where contact_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.contactID#">
	</CFQUERY>

	<cfreturn getuser>
</cffunction>





<!--- =================================================================== --->
<cffunction name="VerifyLogin" access="public" returntype="struct">
	<!--- --------
		08/20/08 - AArnone - New function: VerifyLogin
							returns info based on username and password
		01/20/09 - AArnone - fixed when looking back into past seasons
	----- --->
	<CFARGUMENT name="uname" required="Yes" type="string" default="">
	<CFARGUMENT name="pword" required="Yes" type="string" default="">
	<CFARGUMENT name="seasonID" required="Yes" type="numeric" default=0>
	<CFARGUMENT name="regSeasonID" required="Yes" type="numeric" default=0>
	<!--- [<cfdump var="#ARGUMENTS#">] --->
	<CFSET allowLogin 	   = false>
	<CFSET ctMatchingRoles = 0>
	<CFSET foundContactID  = 0>
	<CFSET foundclubid     = 0>
	<!--- SELECT from tbl_contact	 --->
	<cfinvoke method="getLIcontact"  returnvariable="qGetContact">
		<cfinvokeargument name="uname" value="#trim(ARGUMENTS.uname)#"> 
		<cfinvokeargument name="pword" value="#trim(ARGUMENTS.pword)#"> 
	</cfinvoke> 

	<CFIF qGetContact.recordCount>
		<!--- found a match - login valid, but can user login?		 --->
		<CFSET foundContactID = qGetContact.CONTACT_ID>
		<CFSET foundclubid    = qGetContact.Club_Id>
		<!--- is login valid for current season? --->
		<cfinvoke method="ValidContactSeason" returnvariable="qContactSeason">
			<cfinvokeargument name="contactID" value="#foundContactID#">
			<cfinvokeargument name="seasonID"  value="#ARGUMENTS.seasonID#">
		</cfinvoke>

		<CFIF qContactSeason.recordCount>
			<!--- user found in CURR season and is allowed to next step... --->
			<CFSET allowLogin = true>
			<CFSET foundSeasonID = SESSION.CURRENTSEASON.ID>
		<CFELSE>
			<!--- user NOT found in CURR season, check the REG season... --->
			<cfinvoke method="ValidContactSeason" returnvariable="qContactREGSeason">
				<cfinvokeargument name="contactID" value="#foundContactID#">
				<cfinvokeargument name="seasonID"  value="#ARGUMENTS.regSeasonID#">
			</cfinvoke>

			<CFIF qContactREGSeason.recordCount>
				<!--- user found in REG seasonand is allowed to next step... --->
				<CFSET allowLogin = true>
				<CFSET foundSeasonID = ARGUMENTS.regSeasonID>
			<CFELSE>
				<!--- user NOT found in REG season, check Past seasons... --->
				<cfinvoke method="ValidPastContactSeason" returnvariable="qContactPREVSeason">
					<cfinvokeargument name="contactID" value="#foundContactID#">
					<cfinvokeargument name="seasonID"  value="#ARGUMENTS.regSeasonID#">
					<cfinvokeargument name="lRoleID"  value="26,27,28">
				</cfinvoke>

				<CFIF qContactPREVSeason.recordCount>
					<!--- 
					user found in PAST season, but see if there is someone else in the position...
					loop roles to see if they are taken by a current contact use the first season as the season to use
					 --->
					<CFSET foundSeasonID = qContactPREVSeason.season_id>
					<CFSET foundclub_id = qContactPREVSeason.club_id>
					<CFLOOP query="qContactPREVSeason">
						<CFIF SEASON_ID EQ foundSeasonID>
							<!---  see if the role is already used by a more current contact --->
							<cfinvoke method="ValidRoleSeasonClub" returnvariable="qMatchRole">
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
						<CFSET allowLogin = false>
					<CFELSE>
						<CFSET allowLogin = true>
					</CFIF>
				</CFIF>
			</CFIF>
		</CFIF>
	</CFIF>
	
	<CFIF allowLogin >
		<!--- -- user passed all login checks --  --->
		<cfinvoke method="SeasonContactInfo" returnvariable="qContactInfo">
			<cfinvokeargument name="seasonID"  value="#VARIABLES.foundSeasonID#">
			<cfinvokeargument name="contactID" value="#VARIABLES.foundContactID#">
		<!--- <cfinvokeargument name="roleID"    value="#VARIABLES.#"> --->
		</cfinvoke>
	</CFIF>
	
	<CFSET stLoginInfo = structNew()>
	<CFSET stLoginInfo.contactid = VARIABLES.foundContactID>
	<CFSET stLoginInfo.allowYN   = VARIABLES.allowLogin>
	<CFIF isDefined("qContactInfo")>
		<CFSET stLoginInfo.qContactInfo = qContactInfo>
	<CFELSE>
		<CFSET stLoginInfo.qContactInfo = "">
	</CFIF>

	<cfreturn stLoginInfo>
</cffunction>


<!--- =================================================================== --->
<cffunction name="getClubContacts" access="public" returntype="query">
	<!--- --------
		09/03/08 - AArnone - returns all contacts for a club id
		12/03/08 - aarnone - added club name
	----- --->
	<CFARGUMENT name="clubID" required="Yes" type="numeric" default=0>

	<CFQUERY name="qAllContacts" datasource="#VARIABLES.DSN#">
<!---		Select co.contact_id, co.lastName, co.firstName, co.active_YN, 	co.Approve_YN,
				co.email, co.PHONEHOME, co.PHONEWORK, co.PHONECELL, co.PHONEFAX,
				cl.CLUB_NAME
		  from TBL_CONTACT co INNER JOIN TBL_CLUB cl ON cl.CLUB_ID = co.CLUB_ID
		 Where co.CLUB_ID = #ARGUMENTS.clubID#
		   And co.APPROVE_YN = 'Y'
		   
		 Order By co.lastName, co.firstname--->
<!--- J. Rab 9/10/2012 Added requirement that role must be assigned to display contact --->
		Select			contact_id, lastName, firstName, active_YN, Approve_YN,
						email, PHONEHOME, PHONEWORK, PHONECELL, PHONEFAX,
						CLUB_NAME, roll_assigned,
						pass_number
		FROM			v_contacts
		WHERE			CLUB_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.clubID#">
		AND				APPROVE_YN = 'Y'
		ORDER BY		lastName, firstname
	</CFQUERY>
<!--- 		Select contact_id, lastName, firstName, active_YN, 	Approve_YN,
				email, PHONEHOME, PHONEWORK, PHONECELL, PHONEFAX
		  from TBL_CONTACT
		 Where CLUB_ID = #ARGUMENTS.clubID#
		   And Active_YN = 'Y'
		 Order By lastName
 --->
	<cfreturn qAllContacts>
</cffunction>

<!--- =================================================================== --->
<cffunction name="getALLContacts" access="public" returntype="query">
	<!--- --------
		12/03/08 - AArnone - returns all contacts
	----- --->
	<CFQUERY name="qAllContacts" datasource="#VARIABLES.DSN#">
<!---		Select co.contact_id, co.lastName, co.firstName, co.active_YN, 	co.Approve_YN,
				co.email, co.PHONEHOME, co.PHONEWORK, co.PHONECELL, co.PHONEFAX,
				co.address, co.city, co.state, co.zipcode ,
				cl.CLUB_NAME
		  from TBL_CONTACT co INNER JOIN TBL_CLUB cl ON cl.CLUB_ID = co.CLUB_ID
		  Where co.APPROVE_YN = 'Y'
		 Order By co.lastName--->
<!--- J. Rab 9/10/2012 Added requirement that role must be assigned to display contact --->
		Select			contact_id,
						lastName,
						firstName,
						active_YN,
						Approve_YN,
						email,
						PHONEHOME,
						PHONEWORK,
						PHONECELL,
						PHONEFAX,
						address,
						city,
						state,
						zipcode ,
						CLUB_NAME,
						roll_assigned,
						pass_number
		FROM			v_contacts
		WHERE			APPROVE_YN = 'Y'
		AND				roll_assigned <> 0
		ORDER BY		lastName, firstname
	</CFQUERY>
		<!--- -- Where CLUB_ID = #ARGUMENTS.clubID#
		 --  And Active_YN = 'Y' --->

	<cfreturn qAllContacts>
</cffunction>


<!--- =================================================================== --->
<cffunction name="getClubRequestedContacts" access="public" returntype="query">
	<!--- --------
		10/30/08 - AArnone - returns all Requested contacts for a club id
 
			Approve_YN =  "Y"  = Approved
			Approve_YN =  "N"  = Rejected
			Approve_YN is NULL = Pending
		12/03/08 - aarnone - added club name
	----- --->
	<CFARGUMENT name="clubID" 	  required="NO" type="numeric" default=0>
	<CFARGUMENT name="ApproveSts" required="No" type="string" default="ALL">
<!--- Joe Lechuga - 7/15/2011 - Removed the following and replaced with a if condition directly in the SQL --->
<!--- 	<cfif isDefined("ARGUMENTS.clubID") AND ARGUMENTS.clubID GT 0>
		<cfset whereClub = " AND co.CLUB_ID = " & ARGUMENTS.clubID >
	<cfelse>
		<cfset whereClub = "" >
	</cfif> --->
<!--- Joe Lechuga - 7/15/2011 - Removed the following since we are returning all statuses--->	
<!--- 	<cfswitch expression="#UCASE(ARGUMENTS.ApproveSts)#">
		<cfcase value="APPROVED"> 
				<cfset whereApproved = " AND co.Approve_yn = 'Y' " > 
		</cfcase>
		<cfcase value="REJECTED">
				<cfset whereApproved = " AND co.Approve_yn = 'N' " > 
		</cfcase>
		<cfcase value="PENDING">
				<cfset whereApproved = " AND co.Approve_yn is NULL " > 
		</cfcase>
		<cfdefaultcase> <!--- ALL --->
				<cfset whereApproved = " " > 
		</cfdefaultcase>
	</cfswitch>	 --->
	<!---  --And co.Approve_YN #whereApproved# --->
	<CFQUERY name="qRequestedContacts" datasource="#VARIABLES.DSN#">
	<!---
		-- Removed and started using view (J. Rab)
		Select co.contact_id, co.lastName, co.firstName, co.active_YN, co.Approve_YN,
			   co.email, co.PHONEHOME, co.PHONEWORK, co.PHONECELL, co.PHONEFAX, 
			   co.club_id, cl.club_name, XCR.xref_contact_role_ID,  XCR.role_id, RO.roleDisplayName,
			   co.REJECT_COMMENT,
			   cl.CLUB_NAME,
			   case when co.approve_yn = 'Y' then 2 when co.approve_yn is null then 1 when co.approve_yn = 'N' then 3
			   end as sort_order
		  from TBL_CONTACT co INNER JOIN TBL_CLUB 		   cl  ON cl.CLUB_ID = co.CLUB_ID
						      LEFT JOIN  XREF_CONTACT_ROLE XCR ON XCR.contact_id = co.contact_id
						      LEFT JOIN  TLKP_ROLE 		   RO  ON RO.role_id = XCR.role_id
		 Where co.Active_YN = 'N'
		 
		 <cfif isDefined("ARGUMENTS.clubID") AND ARGUMENTS.clubID GT 0>
		  AND co.CLUB_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.clubID#"> 
		  </cfif>
		 Order By cl.CLUB_NAME, co.lastName, co.firstName
	--->
		
		SELECT		contact_id, lastName, firstName, active_YN, Approve_YN,
					email, PHONEHOME, PHONEWORK, PHONECELL, PHONEFAX, 
					club_id, club_name, xref_contact_role_ID,  role_id, roleDisplayName,
					REJECT_COMMENT, sort_order, current_status
		FROM 		v_contact_requests
		WHERE 		<!---ACTIVE_YN = 'N'---> current_status is not null
		<cfif isDefined("ARGUMENTS.clubID") AND ARGUMENTS.clubID GT 0>
		AND 		CLUB_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.clubID#"> 
		</cfif>
		ORDER BY	lastName, firstName, CLUB_NAME
	</CFQUERY>
		<!--- Select co.contact_id, co.lastName, co.firstName, co.active_YN, co.Approve_YN,
			   co.email, co.PHONEHOME, co.PHONEWORK, co.PHONECELL, co.PHONEFAX, 
			   co.club_id, cl.club_name
		  from TBL_CONTACT co INNER JOIN TBL_CLUB cl ON cl.CLUB_ID = co.CLUB_ID
		 Where co.Active_YN = 'N'
		 #whereApproved#
		 #whereClub#
		 Order By cl.CLUB_NAME, co.lastName --->


 
	
	<cfreturn qRequestedContacts>
</cffunction>




<!--- =================================================================== --->
<cffunction name="changePW" access="public" returntype="struct">
	<!--- --------
		09/04/08 - AArnone - changes the password for the contact id
	----- --->
	<CFARGUMENT name="contactID" required="Yes" type="numeric">
	<CFARGUMENT name="password"  required="Yes" type="string">

	<cfstoredproc procedure="p_set_password" datasource="#VARIABLES.DSN#" returncode="Yes">
		<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@contact_id" value="#ARGUMENTS.contactID#"> 
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@password"   value="#ARGUMENTS.password#">
	</cfstoredproc>

	<cfreturn cfstoredProc>
</cffunction>

<!--- =================================================================== --->
<cffunction name="deleteXrefContactRole" access="public" >
	<!--- --------
		09/04/08 - AArnone - deletes a specific contact role
	----- --->
	<CFARGUMENT name="contactROLEid" required="Yes" type="numeric">
	
	<CFQUERY name="qDelXRcontRole" datasource="#VARIABLES.DSN#">
		DELETE XREF_CONTACT_ROLE 
		 Where XREF_CONTACT_ROLE_ID = #ARGUMENTS.contactROLEid#
	</CFQUERY>
</cffunction>

<!--- =================================================================== --->
<cffunction name="updContactRoleNEW" access="public">
	<!--- --------
		09/04/08 - AArnone - update role with new contact id
	----- --->
	<CFARGUMENT name="contactID" required="Yes" type="numeric">
	<CFARGUMENT name="contactROLEid" required="Yes" type="numeric">

	<CFQUERY name="qUpdXRcontRole" datasource="#VARIABLES.DSN#">
		UPDATE XREF_CONTACT_ROLE
		   SET CONTACT_ID 			= #ARGUMENTS.contactID#
		 Where XREF_CONTACT_ROLE_ID = #ARGUMENTS.contactROLEid#
	</CFQUERY>

</cffunction>



<!--- =================================================================== --->
<cffunction name="insertContactRole" access="public" returntype="numeric" >
	<!--- --------
		09/04/08 - AArnone - INSERTs a new contact role mapping id
	----- --->
	<CFARGUMENT name="contactID" required="Yes" type="numeric">
	<CFARGUMENT name="roleID" 	 required="Yes" type="numeric">
	<CFARGUMENT name="ClubId" 	 required="Yes" type="numeric">
	<CFARGUMENT name="seasonID"  required="Yes" type="numeric">
	<CFARGUMENT name="activeYN"	 required="Yes" type="string">
	<CFARGUMENT name="allowGameEdit" required="Yes" type="string">

	<cfquery datasource="#application.dsn#" name="checkExistence">
		select * from xref_contact_role
		where contact_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.contactid#">
		and role_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.roleid#">
		and season_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.seasonid#">
		and active_yn='Y'
	</cfquery>
	
	<cfset xrefcontactroleid = 0>
	<cfif checkexistence.recordcount EQ 0>
		<cfstoredproc procedure="p_insert_contact_role" datasource="#VARIABLES.DSN#" returncode="Yes">
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@contact_id"	value="#ARGUMENTS.contactID#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@role_id"		value="#ARGUMENTS.roleID#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@club_id"		value="#ARGUMENTS.ClubId#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@season_id"	value="#ARGUMENTS.seasonID#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@active_yn"	value="#ARGUMENTS.activeYN#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@Allow_game_edit" value="#ARGUMENTS.allowGameEdit#">
			<cfprocparam type="Out" cfsqltype="CF_SQL_NUMERIC" dbvarname="@xref_contact_role_id" variable="xrefContactRoleID">
		</cfstoredproc>
		<!--- If a referee role is inserted, then a tbl_referee_info record is needed  --->
		<cfif ARGUMENTS.roleID EQ 25>
			<cfquery name="qGetRefinfoID" datasource="#SESSION.DSN#">
				SELECT REFEREE_INFO_ID FROM TBL_REFEREE_INFO WHERE CONTACT_ID = #ARGUMENTS.ContactID#
			</cfquery>
			<CFIF qGetRefinfoID.recordCount EQ 0>
				<cfinvoke method="insertRefereeInfo" returnvariable="refInfoID" >
					<cfinvokeargument name="refereeID" value="#ARGUMENTS.contactID#">
				</cfinvoke>
			</CFIF>			
		</cfif>
	</cfif>

	
	<cfreturn xrefContactRoleID>

</cffunction>



<!--- =================================================================== --->
<cffunction name="insertContact" access="public" >
	<!--- --------
		09/08/08 - AArnone - INSERTs a new contact AND does UPDATES with ROLE info if edit_contact_id is present 
		10/30/08 - AArnone - added "isRequestYN" logic
		01/13/09 - AArnone - added logic to insert into tbl_referee_info if referee is checked
	----- --->
	<CFARGUMENT name="username"	 required="Yes" type="string">
	<CFARGUMENT name="password"	 required="Yes" type="string">
	<CFARGUMENT name="firstName" required="Yes" type="string">
	<CFARGUMENT name="lastName"	 required="Yes" type="string">
	<CFARGUMENT name="address"	 required="Yes" type="string">
	<CFARGUMENT name="city"		 required="Yes" type="string">
	<CFARGUMENT name="state"	 required="Yes" type="string">
	<CFARGUMENT name="zipcode"	 required="Yes" type="string">
	<CFARGUMENT name="phoneHome" required="Yes" type="string">
	<CFARGUMENT name="phoneWork" required="Yes" type="string">
	<CFARGUMENT name="phoneCell" required="Yes" type="string">
	<CFARGUMENT name="phoneFax"  required="Yes" type="string">
	<CFARGUMENT name="email"	 required="Yes" type="string">
	<CFARGUMENT name="createdBy" required="Yes" type="numeric">
	<CFARGUMENT name="club_id"	 required="Yes" type="numeric">
	<CFARGUMENT name="editContactID" required="Yes" type="numeric">
	<CFARGUMENT name="isRequest" required="No" type="boolean">
	
	<CFIF UCASE(ARGUMENTS.username) EQ "NONE" >
		<CFSET VARIABLES.Username = "">
	<CFELSE>
		<CFSET VARIABLES.Username = TRIM(ARGUMENTS.username)>
	</CFIF>
	<CFIF UCASE(ARGUMENTS.password) EQ "NONE" >
		<CFSET VARIABLES.password  = "">
	<CFELSE>
		<CFSET VARIABLES.password  = TRIM(ARGUMENTS.password)>
	</CFIF>

	<cfif isDefined("ARGUMENTS.isRequest") and ARGUMENTS.isRequest>
		<cfset activeYN = "N">
		<cfset approveYN = "">
	<cfelse>
		<cfset activeYN = "Y">
		<cfset approveYN = "Y">
	</cfif>
	
	<cfstoredproc procedure="p_insert_contact" datasource="#VARIABLES.DSN#" returncode="Yes">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@username"	 value="#VARIABLES.username#" null="#YesNoFormat(NOT(len(VARIABLES.username)))#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@password"	 value="#VARIABLES.password#" null="#YesNoFormat(NOT(len(VARIABLES.password)))#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@firstName"	 value="#ARGUMENTS.firstName#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@lastName"	 value="#ARGUMENTS.lastName#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@address"		 value="#ARGUMENTS.address#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@city"		 value="#ARGUMENTS.city#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@state"		 value="#ARGUMENTS.state#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@zipcode"		 value="#ARGUMENTS.zipcode#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@phoneHome"	 value="#ARGUMENTS.phoneHome#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@phoneWork"	 value="#ARGUMENTS.phoneWork#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@phoneCell"	 value="#ARGUMENTS.phoneCell#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@phoneFax"	 value="#ARGUMENTS.phoneFax#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@email"		 value="#ARGUMENTS.email#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@active_yn"	 value="#VARIABLES.activeYN#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@createdBy"	 value="#ARGUMENTS.createdBy#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@club_id"		 value="#ARGUMENTS.club_id#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@edit_contact_id"  value="#ARGUMENTS.editContactID#">
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@approve_yn"	 value="#VARIABLES.approveYN#" null="#YesNoFormat(NOT(len(VARIABLES.approveYN)))#">
		<cfprocparam type="Out" cfsqltype="CF_SQL_NUMERIC" dbvarname="@contact_id"   variable="contactID">
	</cfstoredproc>
	
	
	<cfreturn contactID>

</cffunction>



<!--- =================================================================== --->
<cffunction name="updateContactInfo" access="public" >
	<!--- --------
		09/16/08 - AArnone - UPDATES contact info TBL_CONTACT ONLY
	----- --->
	<CFARGUMENT name="contactID" required="Yes" type="numeric">
	<CFARGUMENT name="firstName" required="Yes" type="string">
	<CFARGUMENT name="lastName"	 required="Yes" type="string">
	<CFARGUMENT name="address"	 required="Yes" type="string">
	<CFARGUMENT name="city"		 required="Yes" type="string">
	<CFARGUMENT name="state"	 required="Yes" type="string">
	<CFARGUMENT name="zipcode"	 required="Yes" type="string">
	<CFARGUMENT name="phoneHome" required="Yes" type="string">
	<CFARGUMENT name="phoneWork" required="Yes" type="string">
	<CFARGUMENT name="phoneCell" required="Yes" type="string">
	<CFARGUMENT name="phoneFax"  required="Yes" type="string">
	<CFARGUMENT name="email"	 required="Yes" type="string">
	<CFARGUMENT name="pass_number"	 required="No" type="string" default="">
	<CFARGUMENT name="createdBy" required="Yes" type="numeric">

		<cfstoredproc procedure="p_update_contact" datasource="#VARIABLES.DSN#" returncode="Yes">
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@contact_id"	 value="#ARGUMENTS.contactID#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@firstName"	 value="#ARGUMENTS.firstName#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@lastName"	 value="#ARGUMENTS.lastName#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@address"		 value="#ARGUMENTS.address#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@city"		 value="#ARGUMENTS.city#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@state"		 value="#ARGUMENTS.state#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@zipcode"		 value="#ARGUMENTS.zipcode#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@phoneHome"	 value="#ARGUMENTS.phoneHome#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@phoneWork"	 value="#ARGUMENTS.phoneWork#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@phoneCell"	 value="#ARGUMENTS.phoneCell#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@phoneFax"	 value="#ARGUMENTS.phoneFax#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@email"		 value="#ARGUMENTS.email#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@pass_number"	 value="#ARGUMENTS.pass_number#" null="#YesNoFormat(Not len(trim(arguments.pass_number)))#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@updatedBy"	 value="#ARGUMENTS.createdBy#">
			
		</cfstoredproc>

	<cfreturn cfstoredproc>

</cffunction>




<!--- =================================================================== --->
<cffunction name="updateALLContactInfo" access="public" description="same as updateContactInfo but also includes username">

	<CFARGUMENT name="editContactID" required="Yes" type="numeric">
	<CFARGUMENT name="clubID"		 required="Yes" type="numeric">
	<CFARGUMENT name="username"		 required="Yes" type="string">
	<CFARGUMENT name="firstName"	 required="Yes" type="string">
	<CFARGUMENT name="lastName"		 required="Yes" type="string">
	<CFARGUMENT name="address"		 required="Yes" type="string">
	<CFARGUMENT name="city"			 required="Yes" type="string">
	<CFARGUMENT name="state"		 required="Yes" type="string">
	<CFARGUMENT name="zipcode"		 required="Yes" type="string">
	<CFARGUMENT name="phoneHome"	 required="Yes" type="string">
	<CFARGUMENT name="phoneWork"	 required="Yes" type="string">
	<CFARGUMENT name="phoneCell"	 required="Yes" type="string">
	<CFARGUMENT name="phoneFax"		 required="Yes" type="string">
	<CFARGUMENT name="email"		 required="Yes" type="string">
	<CFARGUMENT name="upDatedBy"	 required="Yes" type="numeric">
	<CFARGUMENT name="active_yn"	 required="Yes" type="string">
	<!--- check if username exists in other contact--->
	<cfquery datasource="#application.dsn#" name="checkUsername">
		select * from tbl_contact
		where username=<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.username#">
		and contact_id <> <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.editContactID#">
		and username <> ''
	</cfquery>
	
	<cfif checkUsername.recordcount GT 0>
		<cfthrow message="Username already exists.  Please choose a different username to continue." detail="userError">
	</cfif>

	<!--- Joe Lechuga 7/15/2011 - Added active_yn  --->
	<!--- Joe Lechuga 7/15/2011 - Converted Update to Proc--->
	<cftry>
	
		<cfstoredproc procedure="p_update_all_contact" datasource="#VARIABLES.DSN#" returncode="Yes">
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@contact_id"	 value="#ARGUMENTS.EditcontactID#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@firstName"	 value="#ARGUMENTS.firstName#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@lastName"	 value="#ARGUMENTS.lastName#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@address"		 value="#ARGUMENTS.address#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@city"		 value="#ARGUMENTS.city#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@state"		 value="#ARGUMENTS.state#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@zipcode"		 value="#ARGUMENTS.zipcode#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@phoneHome"	 value="#ARGUMENTS.phoneHome#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@phoneWork"	 value="#ARGUMENTS.phoneWork#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@phoneCell"	 value="#ARGUMENTS.phoneCell#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@phoneFax"	 value="#ARGUMENTS.phoneFax#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@email"		 value="#ARGUMENTS.email#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@updatedBy"	 value="#ARGUMENTS.upDatedBy#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@username"		 value="#ARGUMENTS.username#" null="#YesNoFormat(NOT(len(ARGUMENTS.username)))#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@active_yn"		 value="#ARGUMENTS.active_yn#">
		</cfstoredproc>
<!--- 	<cfquery name="qUpdateALLContactInfo" datasource="#SESSION.DSN#">
		UPDATE TBL_CONTACT
		   SET USERNAME   = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.username#" null="#YesNoFormat(NOT(len(ARGUMENTS.username)))#">
		     , FIRSTNAME  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.firstName#" >
			 , LASTNAME   = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.lastName#">
			 , ADDRESS 	  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.address#">
			 , CITY 	  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.city#">
			 , STATE 	  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.state#">
			 , ZIPCODE	  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.zipcode#">
			 , PHONEHOME  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.phoneHome#">
			 , PHONEWORK  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.phoneWork#">
			 , PHONECELL  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.phoneCell#">
			 , PHONEFAX	  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.phoneFax#">
			 , EMAIL 	  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.email#">
			 , UPDATEDATE = GETDATE()
			 , UPDATEDBY  = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.upDatedBy#">
			 , ACTIVE_YN  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.active_yn#">
	 	 WHERE CONTACT_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.editContactID#">
	</cfquery> --->
	<cfcatch>
		<cfdump var="#cfcatch#">
	</cfcatch>
	</cftry>
</cffunction>		




<!--- =================================================================== --->
<cffunction name="getClubContactRoleX" access="public" returntype="query" >
	<!--- --------
		09/09/08 - AArnone - For a given CLUB, get all contacts of a given ROLE 
		08/01/2011 - Jlechuga - added filter to only bring back the active coaches.
	----- --->
	<CFARGUMENT name="clubid" required="Yes" type="numeric">
	<CFARGUMENT name="roleid" required="Yes" type="numeric">
	
	<CFQUERY name="getCoaches" datasource="#SESSION.DSN#">
		SELECT distinct co.CONTACT_ID, 
			   co.username,	   co.password,
			   co.FirstName,   co.LastName, 
			   tr.roleType,	   tr.roleDisplayName, 
			   xcr.role_ID,	   xcr.club_id,  xcr.active_yn
		       --	xcr.xref_contact_role_id,  -- causes dupes
		       --	xcr.Allow_game_edit 	AS AllowGameEdit
		  FROM xref_contact_role xcr INNER JOIN  tbl_contact co  ON co.contact_id = xcr.contact_id 
									 INNER JOIN  tlkp_role   tr  ON tr.role_id    = xcr.role_id
		 WHERE tr.role_id =  #ARGUMENTS.roleid#
		   AND xcr.club_id = #ARGUMENTS.clubid#
		   and co.active_yn = 'Y'
		 ORDER BY co.LastName
	</CFQUERY>
	<cfreturn getCoaches>

</cffunction>


<!--- =================================================================== --->
<cffunction name="getReferees" access="public" returntype="query" >
	<!--- --------
		10/14/08 - AArnone - get referee info
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo">
			<cfinvokeargument name="sortby" value="STATE">
			<cfinvokeargument name="refereeID" value="#.#">
		</cfinvoke>
	----- --->
	<cfargument name="sortby" 	 required="NO" type="string">
	<cfargument name="refereeID" required="NO" type="numeric" default="0">
	<!--- <cfargument name="contactId" required="NO" type="numeric" default="0"> --->
	<cfargument name="certifiedOnly" required="NO" type="string" >
	<cfargument name="activeOnly" required="NO" type="boolean" default="true">
	

	<CFQUERY name="getRefereeInfo" datasource="#SESSION.DSN#">
		select	a.contact_id,
				stateregisteredin, certified_yn, grade, birth_date, certified_1st_year, additional_Ref_info, ref_level, referee_info_id,
				b.firstname, b.lastname, b.username, b.phonework, b.email, b.phonecell, b.phonehome, b.address, b.city, 
				b.state, b.zipcode, b.phonefax, b.active_yn as contact_active, b.approve_yn, b.password
		from tbl_referee_info a
			inner join tbl_contact b
			on a.contact_id=b.contact_id
		where 1=1
		<cfif arguments.activeOnly>
			AND b.ACTIVE_YN = 'Y'
		</cfif>
		<cfif isDefined("ARGUMENTS.refereeID") AND ARGUMENTS.refereeID GT 0>
			AND a.contact_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.refereeID#"> 
		</cfif>
		<CFIF isDefined("ARGUMENTS.certifiedOnly") AND ARGUMENTS.certifiedOnly EQ "Y">
			AND certified_yn = 'Y'
		</CFIF>
		<CFIF isDefined("ARGUMENTS.SORTBY") AND ARGUMENTS.SORTBY EQ "STATE">
			ORDER BY stateregisteredin, b.LastName, b.FirstName
		<cfelse>
			order by b.lastname, b.firstname, b.username
		</CFIF>
	</CFQUERY>


	<cfreturn getRefereeInfo>

</cffunction>
				

<!--- =================================================================== --->
<cffunction name="getRequestedReferees" access="public" returntype="query" >
	<!--- --------
		11/17/08 - AArnone - get Requested referee info
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getRequestedReferees" returnvariable="qRefInfo">
		</cfinvoke>
	----- --->
	
	<CFQUERY name="getReqRefInfo" datasource="#SESSION.DSN#">
		SELECT distinct ri.contact_id,
				CO.ACTIVE_YN as Contact_ACTIVE,
				CO.APPROVE_YN,
				CO.FirstName, 		CO.LastName, 
				CO.phoneCell, 		CO.phoneWork, 
				CO.phoneHome, 		CO.phoneFax,
				CO.email, 			CO.UserName,
				RI.certified_yn,	RI.grade, 
				RI.StateRegisteredIn, RI.birth_date,
				RI.certified_1st_year, RI.Ref_level, 
				RI.referee_info_id
		FROM    tbl_referee_info RI
				INNER JOIN tbl_contact CO 
				ON CO.contact_id = RI.contact_id
		WHERE   CO.ACTIVE_YN = 'N'
		  AND   CO.APPROVE_YN = 'Y'
	 ORDER BY   CO.LastName, CO.FirstName
	</CFQUERY>
<!--- INNER JOIN dbo.tbl_contact      CO ON CO.contact_id = XCR.contact_id 
						LEFT  JOIN dbo.tbl_referee_info RI ON RI.Role_ID = XCR.role_ID AND RI.contact_ID = XCR.contact_ID	
						--->

	<cfreturn getReqRefInfo>

</cffunction>


<!--- =================================================================== --->
<cffunction name="updateRefereeInfo" access="public" >
	<!--- --------
		11/11/08 - AArnone - updates referee info
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="updateRefereeInfo" >
			<cfinvokeargument name="refInfoID" value="#.#">
			<cfinvokeargument name="CertYN"    value="#.#">
			<cfinvokeargument name="grade"     value="#.#">
			<cfinvokeargument name="StateReg"  value="#.#">
			<cfinvokeargument name="RefDOB"    value="#.#">
			<cfinvokeargument name="certYEAR"  value="#.#">
			<cfinvokeargument name="ncsaLevel" value="#.#">
			<cfinvokeargument name="additionalRefInfo" value="#.#">
		</cfinvoke>
	----- --->
	<cfargument name="refInfoID" required="yes" type="numeric">
	<cfargument name="CertYN" 	 required="yes" type="string">
	<cfargument name="grade" 	 required="yes" type="string">
	<cfargument name="StateReg"  required="yes" type="string">
	<cfargument name="RefDOB" 	 required="yes" type="date">
	<cfargument name="certYEAR"  required="yes" type="numeric">
	<cfargument name="ncsaLevel" required="yes" type="string">
	<cfargument name="additionalRefInfo" required="No" type="string">

	<cfstoredproc procedure="p_update_referee_info" datasource="#VARIABLES.DSN#" returncode="Yes">
		<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@referee_info_id"		value="#ARGUMENTS.refInfoID#" >
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@certified_yn"		value="#ARGUMENTS.CertYN#"    >
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@grade"				value="#ARGUMENTS.grade#"     >
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@StateRegisteredIn"	value="#ARGUMENTS.StateReg#"  >
		<cfprocparam type="In"  cfsqltype="CF_SQL_DATE"    dbvarname="@birth_date"			value="#ARGUMENTS.RefDOB#"    >
		<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@certified_1st_year" value="#ARGUMENTS.certYEAR#"  >
		<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@Ref_level"		   value="#ARGUMENTS.ncsaLevel#" >
	</cfstoredproc>

	<cfif isDefined("ARGUMENTS.additionalRefInfo")>
		<cfquery name="qGetRefinfoID" datasource="#SESSION.DSN#">
			UPDATE TBL_REFEREE_INFO 
			   SET additional_Ref_Info = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.additionalRefInfo#">
			 WHERE referee_info_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.refInfoID#">
		</cfquery>
	</cfif>
</cffunction>

	    
<!--- =================================================================== --->
<cffunction name="insertRefereeInfo" access="public"  returntype="numeric">
	<!--- --------
		11/11/08 - AArnone - inserts referee info
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="insertRefereeInfo" returnvariable="refInfoID" >
			<cfinvokeargument name="refereeID" value="#.#">
			<cfinvokeargument name="CertYN"    value="#.#">
			<cfinvokeargument name="grade"     value="#.#">
			<cfinvokeargument name="StateReg"  value="#.#">
			<cfinvokeargument name="RefDOB"    value="#.#">
			<cfinvokeargument name="certYEAR"  value="#.#">
			<cfinvokeargument name="ncsaLevel" value="#.#">
			<cfinvokeargument name="insertRefereeInfo" value="#.#">
		</cfinvoke>
	----- --->
	<cfargument name="RefereeID" 	required="yes" type="numeric">
	<cfargument name="CertYN" 	 	required="no"  type="string"  default="">
	<cfargument name="grade" 	 	required="no"  type="string"  default="">
	<cfargument name="StateReg"  	required="no"  type="string"  default="">
	<cfargument name="RefDOB" 	 	required="no"  type="date"    default="01/01/1900">
	<cfargument name="certYEAR"  	required="no"  type="numeric" default="0">
	<cfargument name="ncsaLevel" 	required="no"  type="string"  default="">
	<cfargument name="additionalRefInfo" required="no" type="string" default="">

	<!--- <cfprocparam type="In"  dbvarname="@xref_contact_role_ID" cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.RefereeID#"> --->
	<cfstoredproc procedure="p_insert_referee_info" datasource="#SESSION.DSN#">
		<cfprocparam type="In"  dbvarname="@certified_yn"		  cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.CertYN#">
		<cfprocparam type="In"  dbvarname="@grade"				  cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.Grade#">
		<cfprocparam type="In"  dbvarname="@StateRegisteredIn"	  cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.StateReg#">
		<cfprocparam type="In"  dbvarname="@birth_date"			  cfsqltype="CF_SQL_DATE"	 value="#ARGUMENTS.RefDOB#">
		<cfprocparam type="In"  dbvarname="@certified_1st_year"   cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.certYEAR#">
		<cfprocparam type="In"  dbvarname="@Ref_level"			  cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ncsaLevel#">
		<cfprocparam type="In"  dbvarname="@additionalRefInfo"	  cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.additionalRefInfo#">
		<cfprocparam type="In"  dbvarname="@contact_ID" 		  cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.RefereeID#">
		<cfprocparam type="Out" dbvarname="@referee_info_id"	  cfsqltype="CF_SQL_NUMERIC" variable="referee_info_id">
	</cfstoredproc> 
	<cfreturn referee_info_id>
	
</cffunction>


<!--- =================================================================== --->
<cffunction name="ContactExist" access="public" returntype="query" >
	<!--- --------
		09/10/08 - AArnone - For a given CLUB,season,role,contact; see if they exist
	----- --->
	<CFARGUMENT name="contactid" required="Yes" type="numeric">
	<CFARGUMENT name="roleid" 	 required="Yes" type="numeric">
	<CFARGUMENT name="clubid" 	 required="Yes" type="numeric">
	<CFARGUMENT name="seasonid"  required="Yes" type="numeric">
	
	<CFQUERY name="qContactExist" datasource="#SESSION.DSN#">
		SELECT xref_contact_role_id
		  FROM xref_contact_role
		 WHERE CONTACT_ID = #ARGUMENTS.contactid#
		   AND ROLE_ID    = #ARGUMENTS.roleid#
		   AND CLUB_ID	  = #ARGUMENTS.clubid#
		   AND SEASON_ID  = #ARGUMENTS.seasonid#
	</CFQUERY>
	<cfreturn qContactExist>

</cffunction>

<!--- =================================================================== --->
<cffunction name="getRoleList" access="public" returntype="query" >
	<!--- --------
		09/12/08 - AArnone - get a list of ROLES
	----- --->
	<CFARGUMENT name="listRoleType" required="No" type="string">
	
	<CFSET RoleWhereClause = "">
	<CFIF isDefined("ARGUMENTS.listRoleType") AND len(trim(ARGUMENTS.listRoleType))>
		<CFSET RoleWhereClause = " WHERE ROLETYPE IN (" & ARGUMENTS.listRoleType & ")">
	</CFIF>
	
	<CFQUERY name="getRoles" datasource="#SESSION.DSN#">
		Select Role_id, RoleType, RoleDisplayName 
		  from tlkp_role
		  #preserveSingleQuotes(RoleWhereClause)# 
		  order by roledisplayname
	</CFQUERY>
	<cfreturn getRoles>

</cffunction>


<!--- =================================================================== --->
<cffunction name="getContactRoles" access="public" returntype="query" >
	<!--- --------
		09/15/08 - AArnone - get all the roles for a CONTACT ID 
	----- --->
	<CFARGUMENT name="contactID" required="No" type="numeric">
	<CFARGUMENT name="seasonID" required="yes" type="numeric">
		
	<CFQUERY name="qGetcontactRoles" datasource="#SESSION.DSN#">
		select role_id, xref_contact_role_ID
		  from xref_contact_role 
		 where contact_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.contactID#" >
		   and active_yn = 'Y'
		   and season_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.seasonID#" > 
	</CFQUERY>
	<cfreturn qGetcontactRoles>

</cffunction>



<!--- =================================================================== --->
<cffunction name="getRoleContacts" access="public" returntype="query" >
	<!--- --------
		11/04/08 - AArnone - get all the contacts of a ROLE
	----- --->
	<CFARGUMENT name="roleID" required="yes" type="numeric">
	<CFARGUMENT name="seasonID" required="yes" type="numeric">
	
	<CFQUERY name="qGetRoleContacts" datasource="#SESSION.DSN#">
		select x.contact_id, c.FirstNAme, c.LastName
		  from xref_contact_role x INNER JOIN TBL_CONTACT c on c.CONTACT_ID = x.CONTACT_ID
		 where x.role_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.roleID#" >
		   and x.season_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.seasonID#" >
		   and x.active_yn = 'Y'
	</CFQUERY>
	<cfreturn qGetRoleContacts>

</cffunction>

<!--- =================================================================== --->
<cffunction name="searchContacts" access="public" returntype="query">
	<cfargument name="qry" type="string" required="Yes">
	
	<CFQUERY name="qAllContacts" datasource="#VARIABLES.DSN#">
		Select co.contact_id, co.lastName, co.firstName, co.active_YN, 	co.Approve_YN,
				co.email, co.PHONEHOME, co.PHONEWORK, co.PHONECELL, co.PHONEFAX,
				co.address, co.city, co.state, co.zipcode, c.club_name
		  from TBL_CONTACT co
		  left join tbl_club c
		  on co.club_id=c.club_id
		  where firstName + ' ' + lastName like  <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#arguments.qry#%">
		  or email like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#arguments.qry#%">
		 Order By co.lastName, co.firstName
	</CFQUERY>
		<!--- -- Where CLUB_ID = #ARGUMENTS.clubID#
		 --  And Active_YN = 'Y' --->

	<cfreturn qAllContacts>
</cffunction>


<cffunction
	name="mergeContacts"
	access="public"
	description="merges multiple contacts into one"
	returntype="boolean">
	<cfargument name="keepContact" type="string" required="Yes">
	<cfargument name="deleteContactList" type="string" required="Yes">
	
	<!--- <cfloop list="#arguments.deleteContactList#" index="i">
		<cfstoredproc datasource="#application.dsn#" procedure="p_merge_contacts">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@keepContact" type="In" value="#arguments.keepContact#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@delContact" type="In" value="#i#">
		</cfstoredproc>
	</cfloop> --->

	<cfstoredproc datasource="#application.dsn#" procedure="p_merge_contacts">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@keepContact" type="In" value="#arguments.keepContact#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@delContact" type="In" value="#arguments.deleteContactList#">
	</cfstoredproc>
	<cfreturn true>
	
</cffunction>

<cffunction
	name="setContactRoleList"
	access="public"
	description="Sets a list of roles for a user_id, season_id as provided. sets allow_game_edit to 0"
	returntype="any">
	<cfargument name="assignor_contact_id" type="string" required="Yes" default="0">
	<cfargument name="role_list" type="string" required="Yes">
	<cfargument name="contact_id" type="string" required="Yes">
	<cfargument name="season_id" type="string" required="Yes">

	<!--- get club id from contact table --->
	<cfset contactInfo=getContactInfo(arguments.contact_id)>
	<cfset club_id=contactInfo.club_id>
	
	<!--- get current contact roles --->
	<cfset currentRoles=getContactRoles(arguments.contact_id, arguments.season_id)>
	<cfset lsCurrentRoles=valuelist(currentroles.role_id)>
	
	<!--- get assignor_roles --->
	<cfif arguments.assignor_contact_id NEQ "0">
		<cfset assignorRoles=getAssignableRoleList(arguments.assignor_contact_id)>
	<cfelse>
		<cfset assignorRoles=getRoleList()>
	</cfif>
	<cfset lsAssignorRoles=valuelist(assignorRoles.role_id)>
	
	<!--- create struct to hold roles and role types --->
	<cfset stRoles=structnew()>
	<cfloop query="assignorRoles">
		<cfset stRoles["#assignorRoles.role_id#"] = assignorRoles.roleType>
	</cfloop>

	<!--- insert new roles --->
	<cfloop list="#arguments.role_list#" index="role_id">
		<cfif not listfindnocase(lsCurrentRoles,role_id) AND listfindnocase(lsAssignorRoles,role_id)>
			<cfif listfindnocase("su,bu,sa",stRoles["#role_id#"])>
				<cfset setClub_id="1">
			<cfelse>
				<cfset setClub_id=club_id>
			</cfif>
			<cfif listFind('26,27,28',role_id)>
				<cfset allow_game_edit = 1>
			<cfelse>
				<cfset allow_game_edit = 0>
			</cfif>
			<cfstoredproc datasource="#application.dsn#" procedure="p_insert_contact_role">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@contact_id" value="#arguments.contact_id#" type="In">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@role_id" value="#role_id#" type="In">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@club_id" value="#setClub_id#" type="In">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@season_id" value="#arguments.season_id#" type="In">
				<cfprocparam cfsqltype="CF_SQL_CHAR" dbvarname="@active_yn" value="Y" type="In">
				<cfprocparam cfsqltype="CF_SQL_BIT" dbvarname="@Allow_game_edit" value="#allow_game_edit#" type="In">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@xref_contact_role_id" variable="xref_contact_role_id" type="Out">
			</cfstoredproc>
		</cfif>
	</cfloop>
	
	<!--- remove roles --->
	<cfloop query="currentRoles">
		<cfif not listfindnocase(arguments.role_list,role_id) AND listfindnocase(lsAssignorRoles,role_id)>
			<cfset deletexrefcontactrole(xref_contact_role_ID)>
		</cfif>
	</cfloop>
	
	<!--- If a referee role was selected, then a tbl_referee_info record is needed  --->
	<cfif listFind(arguments.role_list,25) GT 0>
		<cfquery name="qGetRefinfoID" datasource="#SESSION.DSN#">
			SELECT REFEREE_INFO_ID FROM TBL_REFEREE_INFO WHERE CONTACT_ID = #arguments.contact_id#
			<!--- and season_id=#arguments.season_id#    bcooper-9/11/2009-referee info not associated to season anymore.  only check if there is an entry, non-season specific --->
		</cfquery>
		<CFIF qGetRefinfoID.recordCount EQ 0>
			<cfinvoke method="insertRefereeInfo" returnvariable="refInfoID" >
				<cfinvokeargument name="refereeID" value="#arguments.contact_id#">
			</cfinvoke>
		</CFIF>	
	</cfif>
	
</cffunction>

<cffunction
	name="getAssignableRoleList"
	access="public"
	description="gets a list of roles that can be assigned by a given user_id.  checks the user_id's current roles against xref_assign_roles"
	returntype="query">
	<cfargument name="contact_id" type="string" required="Yes">
	<!--- get use season --->
	<cfinvoke component="season" method="getCurrentSeason" returnvariable="curseason"></cfinvoke>
	<cfset season_id=curseason.season_id>
	<cfquery datasource="#session.dsn#" name="getRoles">
		select distinct c.Role_id, c.RoleType, RoleDisplayName
		from xref_contact_role a
		inner join xref_assign_roles b
		on a.role_id=b.role_id
		inner join tlkp_role c
		on b.assign_role_id=c.role_id
		where a.contact_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.contact_id#">
		and a.season_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#season_id#">
	</cfquery>
	
	<cfreturn getRoles>

</cffunction>

	    
<!--- =================================================================== --->
<cffunction name="insertTempRefereeInfo" access="public"  returntype="numeric">
	<cfargument name="RefereeID" 	required="yes" type="numeric">
	<cfargument name="email" 	 	required="yes"  type="string"  default="">
	<cfargument name="seasonID"		required="yes" type="numeric">
	<cfargument name="CertYN" 	 	required="no"  type="string"  default="">
	<cfargument name="grade" 	 	required="no"  type="string"  default="">
	<cfargument name="StateReg"  	required="no"  type="string"  default="">
	<cfargument name="RefDOB" 	 	required="no"  type="date"    default="01/01/1900">
	<cfargument name="certYEAR"  	required="no"  type="numeric" default="0">
	<cfargument name="ncsaLevel" 	required="no"  type="string"  default="">
	<cfargument name="additionalRefInfo" required="no" type="string" default="">


	<!--- <cfprocparam type="In"  dbvarname="@xref_contact_role_ID" cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.RefereeID#"> --->
	<cfstoredproc procedure="p_insert_temp_referee_info" datasource="#application.DSN#">
		<cfprocparam type="In"  dbvarname="@certified_yn"		  cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.CertYN#">
		<cfprocparam type="In"  dbvarname="@grade"				  cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.Grade#">
		<cfprocparam type="In"  dbvarname="@StateRegisteredIn"	  cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.StateReg#">
		<cfprocparam type="In"  dbvarname="@birth_date"			  cfsqltype="CF_SQL_DATE"	 value="#ARGUMENTS.RefDOB#">
		<cfprocparam type="In"  dbvarname="@certified_1st_year"   cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.certYEAR#">
		<cfprocparam type="In"  dbvarname="@additionalRefInfo"	  cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.additionalRefInfo#">
		<cfprocparam type="In"  dbvarname="@contact_ID" 		  cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.RefereeID#">
		<cfprocparam type="In" dbvarname="@email" cfsqltype="CF_SQL_VARCHAR" value="#arguments.email#">
	</cfstoredproc> 
	
	<cfreturn 1>
	
</cffunction>



<!--- ------------
END OF contact.cfc
------------- --->
</cfcomponent>
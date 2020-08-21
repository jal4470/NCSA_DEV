

<cfcomponent>
<CFSET DSN = SESSION.DSN>

<!--- ============================================
	functions:
		getClubInfo		- getClubInfo Returns a list of Clubs
		getClubReps		- getClubReps Returns a list of Club reps
		getClubCoaches	- Returns a list of coaches for a club
		insertNewClubRequest - Inserts a new club request
		updateClubInfo	- updates columns in TBL_CLUB for a given CLUB_ID 
		processClubEdit - processes form variables from clubEditInfo.cfm

12/3/08 - aa - fixed processClubEdit alt rep id was empty from clubAdminEdit	
11/17/16 - rg - changed clubID type to string instead of numeric	
============================================= --->


<!--- =================================================================== --->
<cffunction name="getClubInfo" access="public" returntype="query">
	<!--- --------
		08/07/08 - AArnone - New function: getClubInfo Returns a list of Clubs
	----- --->
	<!--- <cfargument name="dsn"		type="string"  required="Yes"> --->
	<cfargument name="clubID"	type="string" required="no" >
	<cfargument name="orderBy"	type="string"  required="no" default="id">
	
	<cfswitch expression="#ARGUMENTS.orderBy#">
		<cfcase value="clubname">
			<CFSET orderBy = "order by cl.club_name">
		</cfcase>
		<cfdefaultcase>
			<CFSET orderBy = "order by cl.club_id">
		</cfdefaultcase>
	</cfswitch>

	<CFIF isDefined("ARGUMENTS.clubID") and ARGUMENTS.clubID GT 0>
		<CFSET andClubid = " AND cl.CLUB_ID = " & ARGUMENTS.clubID>
	<CFELSE>
		<CFSET andClubid = "" ><!---  AND cl.CLUB_ID <> 1  --->
	</CFIF>

	
	<CFQUERY name="qClubInfo" datasource="#VARIABLES.DSN#">
		SELECT distinct cl.club_id, cl.Club_name, cl.ClubAbbr, cl.clubEmail, cl.ClubHomePage, 
				cl.HomeShirtColor, cl.HomeShortColor, cl.AwayShirtColor, cl.AwayShortColor, 
				cl.Address, cl.city, cl.state, cl.zip, cl.CLUB_STATE,
				cl.infoDate, cl.infoUpdate, 
				cl.MemberNCSA, cl.CLUB_STATE, 
				cl.homeFieldFull, cl.homeFieldSmall, 
				cl.USSFCertReferees, 
				XCS.paymentDate, XCS.Bond_YN,
				XCS.TotalU11OlderTeams,			XCS.TotalU10YoungerTeams, 
				XCS.Total11Thru14Teams,			XCS.Total15thru19Teams,
				XCS.Approved_YN, XCS.Active_YN, XCS.termsAccepted_YN,
				XCS.RegSubmit, XCS.SEASON_ID
		  FROM tbl_club cl  INNER JOIN xref_club_season XCS  ON XCS.club_id = cl.club_id 	     
		 WHERE XCS.APPROVED_YN = 'Y'
		   and xcs.season_id = (select season_id from tbl_season where currentSeason_YN = 'Y')
		  #andClubid#
		  #orderBy#
	</CFQUERY>
	
	<cfreturn qClubInfo>
</cffunction>
	

<!--- =================================================================== --->
<cffunction name="getClubReps" access="remote" returntype="query">
	<!--- --------
		08/07/08 - AArnone - New function: getClubReps Returns a list of Club reps
		09/04/08 - AArnone - add argument "seasonID"
		12/05/08 - AARNONE - removed approved_YN from where clause 
	----- --->
	<!--- <cfargument name="dsn"	  type="string"  required="Yes"> --->
	<cfargument name="clubID"   type="string" required="No" default="0">
	<!--- <cfargument name="SeasonID" type="numeric" required="No" default="0"> --->

	
	<CFQUERY name="qClubReps" datasource="#VARIABLES.DSN#">
		SELECT distinct cl.club_id, cl.Club_name, cl.ClubAbbr, cl.clubEmail, cl.ClubHomePage, 
			   cl.MemberNCSA, cl.State, 
			   XCS.SEASON_ID,
			   REP.contact_id 	AS REP_contact_ID,  
			   REP.xref_contact_role_id as Rep_Contact_role_id,
			   REP.FirstName 	AS REP_FIRSTNAME, 	
			   REP.LastName 	AS REP_LASTNAME,
			   REP.address 		as REP_Address,	
			   REP.city 		as REP_city,
			   REP.state 		as REP_State,	
			   REP.ZIPCODE 		as REP_Zipcode,
			   REP.phoneHome 	as REP_PhoneHome, 	
			   REP.phoneWork 	as REP_PhoneWork,
			   REP.phoneCell 	as REP_phoneCell,	
			   REP.phoneFax  	as REP_phoneFax,
			   REP.Email		as REP_Email,
			   ALT.contact_id 	AS ALT_CONTACT_ID,   
			   ALT.xref_contact_role_id as Alt_Contact_role_id,
			   ALT.FirstName 	AS ALT_firstName, 	
			   ALT.LastName 	AS ALT_lastName, 
			   ALT.address 		as alt_Address, 	
			   ALT.city 		as alt_city,
			   ALT.state 		as alt_State,	
			   ALT.ZIPCODE 		as alt_ZipCode,
			   ALT.phoneHome	as alt_PhoneHome, 	
			   ALT.phoneWork	as alt_PhoneWork,
			   ALT.phoneCell 	as alt_PhoneCell,	
			   ALT.phoneFax  	as alt_phoneFax,
			   ALT.Email		as alt_Email,
			   PRES.contact_id 	AS PRES_CONTACT_ID,  
			   PRES.xref_contact_role_id as PRES_Contact_role_id,
			   PRES.FirstName 	AS PRES_Firstname, 	
			   PRES.LastName  	AS PRES_lastName,
			   PRES.address	 	as PRES_Address,	
			   PRES.city	 	as PRES_city,
			   PRES.state	 	as PRES_State,	
			   PRES.ZIPCODE	 	as PRES_ZipCode,
			   PRES.phoneHome 	as PRES_PhoneHome,		
			   PRES.phoneWork 	as PRES_PhoneWork,
			   PRES.phoneCell 	as PRES_PhoneCell,		
			   PRES.phoneFax  	as PRES_PhoneFax,
			   PRES.Email	 	as PRES_Email
		FROM  tbl_club cl 
				INNER JOIN xref_club_season  XCS    ON XCS.club_id 	   = cl.club_id 	     
				LEFT  JOIN (select 	role.club_id,	role.contact_id ,	xref_contact_role_id ,
									FirstName,	LastName,
									address,	city,	state,	ZIPCODE,
									phoneHome,	phoneWork,	phoneCell,	phoneFax,
									Email,	role.season_id
								from xref_contact_role role        
											INNER JOIN tbl_contact contact  ON contact.contact_id  = role.contact_id 
								where role.active_YN = 'Y' 
								  and role.role_id = 27 ) REP
 					      ON REP.club_id = xcs.club_id and REP.season_id = XCS.season_id
				LEFT JOIN (select  role.club_id, role.contact_id, xref_contact_role_id,
								   FirstName,  LastName,
								   address,  city,  state,  ZIPCODE,
								   phoneHome,  phoneWork,  phoneCell,  phoneFax,
								   Email,  role.season_id
							 from  xref_contact_role role        
							 				INNER JOIN tbl_contact contact ON contact.contact_id  = role.contact_id 
							where role.active_YN = 'Y'
							  and role.role_id = 28 ) ALT
					 	  ON ALT.club_id = xcs.club_id and ALT.season_id = XCS.season_id 
				LEFT JOIN (select  role.club_id,  role.contact_id , xref_contact_role_id ,
								   FirstName, LastName ,
								   address	, city	, state	, ZIPCODE	,
								   phoneHome, phoneWork, phoneCell, phoneFax ,
								   Email	, role.season_id
						      from xref_contact_role role
							          		INNER JOIN tbl_contact contact  ON contact.contact_id  = role.contact_id 
							 where role.active_YN = 'Y' 
							   and role.role_id = 26 ) PRES
						ON PRES.club_id = xcs.club_id and PRES.season_id = XCS.season_id 
		WHERE 
		   	<CFIF isDefined("ARGUMENTS.SeasonID") AND ARGUMENTS.SeasonID GT 0>
				xcs.season_id = #ARGUMENTS.seasonID#
			<CFELSE>
				xcs.season_id = (select season_id from tbl_season where currentSeason_YN = 'Y')
			</CFIF>
		    <CFIF isDefined("ARGUMENTS.clubID") AND ARGUMENTS.clubID GT 0>
				AND cl.CLUB_ID = #ARGUMENTS.clubID#
			</CFIF>
		ORDER BY cl.Club_name
	</CFQUERY> <!--- -- XCS.APPROVED_YN = 'Y' AND --->
	     
	<cfreturn qClubReps>
</cffunction>
	


<!--- =================================================================== --->
<cffunction name="getClubCoaches" access="remote" returntype="query">
	<!--- --------
		08/12/08 - AArnone - New function: Returns a list of coaches for a club 
	----- --->
	<!--- <cfargument name="dsn"	  type="string"  required="Yes"> --->
	<cfargument name="clubID" type="string" required="No" default="0">
	<cfargument name="teamID" type="numeric" required="No" default="0">
	<cfargument name="orderby" type="string" required="No" default="id">
	
	<cfswitch expression="#ucase(ARGUMENTS.orderBy)#">
		<cfcase value="LASTNAME">
			<CFSET orderBy = "order by co.LastName">
		</cfcase>
		<cfdefaultcase>
			<CFSET orderBy = "order by co.CONTACT_ID">
		</cfdefaultcase>
	</cfswitch>
	

	<CFQUERY name="qClubCoaches" datasource="#VARIABLES.DSN#">
		SELECT co.CONTACT_ID, co.FirstName, co.LastName, co.email, co.email_2nd,
			   co.ADDRESS, co.CITY, co.STATE, co.ZIPCODE, 
			   co.PHONEHOME, co.PHONEWORK, co.PHONECELL, co.PHONEFAX, 
			   CL.ClubAbbr, CL.club_id, CL.Club_name
		  FROM tbl_contact co 
				INNER JOIN tbl_TEAM t1 ON t1.ContactIDHead = co.contact_id
				INNER JOIN tbl_club CL ON CL.club_id       = t1.club_id
		WHERE cl.CLUB_ID = #ARGUMENTS.clubID#
		  AND t1.season_id = (select season_id from tbl_season where currentSeason_YN = 'Y')
		  <CFIF ARGUMENTS.teamID GT 0>
		  	AND t1.TEAM_ID = #ARGUMENTS.teamID#
		  </CFIF>
		UNION
		SELECT co.CONTACT_ID, co.FirstName, co.LastName, co.email, co.email_2nd,
			   co.ADDRESS, co.CITY, co.STATE, co.ZIPCODE, 
			   co.PHONEHOME, co.PHONEWORK, co.PHONECELL, co.PHONEFAX, 
			   CL.ClubAbbr, CL.club_id, CL.Club_name
		  FROM tbl_contact co 
				INNER JOIN tbl_TEAM t2 ON t2.ContactIDAsst = co.contact_id
				INNER JOIN tbl_club CL ON CL.club_id       = t2.club_id
		WHERE cl.CLUB_ID = #ARGUMENTS.clubID#
		  AND t2.season_id = (select season_id from tbl_season where currentSeason_YN = 'Y')
		  <CFIF ARGUMENTS.teamID GT 0>
		  	AND t2.TEAM_ID = #ARGUMENTS.teamID#
		  </CFIF>
		#orderBy#
	</CFQUERY>
	<cfreturn qClubCoaches>
</cffunction>
	

<!--- =================================================================== --->
<cffunction name="insertNewClubRequest" access="remote" returntype="numeric">
	<!--- --------
		09/03/08 - AArnone - New function: Inserts a new club request
	----- --->
	<cfargument name="stNewClubInfo" type="struct" required="Yes" >

	<CFSET clubReqID = 0>

	<CFIF isDefined("ARGUMENTS.stNewClubInfo") AND structCount(stNewClubInfo)>
		<CFSET ClubName 	 = ARGUMENTS.stNewClubInfo.ClubName>
		<CFSET ClubAddress 	 = ARGUMENTS.stNewClubInfo.ClubAddress>
		<CFSET clubTown 	 = ARGUMENTS.stNewClubInfo.clubTown>
		<CFSET clubState 	 = ARGUMENTS.stNewClubInfo.clubState>
		<CFSET clubZip 		 = ARGUMENTS.stNewClubInfo.clubZip>
		<CFSET USSFCertReferees = ARGUMENTS.stNewClubInfo.USSFCertReferees>
		<CFSET HomeFieldFull    = ARGUMENTS.stNewClubInfo.HomeFieldFull>
		<CFSET HomeFieldSmall   = ARGUMENTS.stNewClubInfo.HomeFieldSmall>
		<CFSET comments 	 = ARGUMENTS.stNewClubInfo.comments>
		<CFSET PresFname 	 = ARGUMENTS.stNewClubInfo.PresFname>
		<CFSET PresLname 	 = ARGUMENTS.stNewClubInfo.PresLname>
		<CFSET PresAddress   = ARGUMENTS.stNewClubInfo.PresAddress>
		<CFSET PresTown 	 = ARGUMENTS.stNewClubInfo.PresTown>
		<CFSET PresState 	 = ARGUMENTS.stNewClubInfo.PresState>
		<CFSET PresZip 		 = ARGUMENTS.stNewClubInfo.PresZip>
		<CFSET PresHomePhone = ARGUMENTS.stNewClubInfo.PresHomePhone>
		<CFSET PresFax 		 = ARGUMENTS.stNewClubInfo.PresFax>
		<CFSET PresWorkPhone = ARGUMENTS.stNewClubInfo.PresWorkPhone>
		<CFSET PresCellPhone = ARGUMENTS.stNewClubInfo.PresCellPhone>
		<CFSET PresEmail 	 = ARGUMENTS.stNewClubInfo.PresEmail>
		<CFSET seasonID		 = ARGUMENTS.stNewClubInfo.seasonID>
		<CFSET stTeams 		 = ARGUMENTS.stNewClubInfo.stTeams>

		<cfstoredproc procedure="p_insert_club_regRequest" datasource="#VARIABLES.DSN#">
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@Season_ID" 	value="#VARIABLES.seasonID#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@Club_name" 	value="#VARIABLES.ClubName#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@Address" 	value="#VARIABLES.ClubAddress#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@City" 		value="#VARIABLES.clubTown#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@State" 		value="#VARIABLES.clubState#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@Zip" 		value="#VARIABLES.clubZip#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresFname" 	value="#VARIABLES.PresFname#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresLname" 	value="#VARIABLES.PresLname#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresAddress" value="#VARIABLES.PresAddress#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresTown" 	value="#VARIABLES.PresTown#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresState" 	value="#VARIABLES.PresState#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresZip" 	value="#VARIABLES.PresZip#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresWorkPhone" 	value="#VARIABLES.PresWorkPhone#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresFax" 		value="#VARIABLES.PresFax#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresHomePhone" 	value="#VARIABLES.PresHomePhone#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresCellPhone" 	value="#VARIABLES.PresCellPhone#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@PresEmail" 		value="#VARIABLES.PresEmail#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@homeFieldFull" 	value="#VARIABLES.HomeFieldFull#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@homeFieldSmall" 	value="#VARIABLES.HomeFieldSmall#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_NUMERIC" dbvarname="@USSFCertReferees" value="#VARIABLES.USSFCertReferees#"> 
			<cfprocparam type="In"  cfsqltype="CF_SQL_VARCHAR" dbvarname="@comments" 		value="#VARIABLES.comments#"> 
			<cfprocparam type="Out" cfsqltype="CF_SQL_NUMERIC" dbvarname="@clubReqID" variable="NewClubReqID"> 
		</cfstoredproc>

		<!--- insert the requested team info --->
		<CFLOOP collection="#stTeams#" item="iBG"><!--- B/G --->
			<CFLOOP collection="#stTeams[iBG]#" item="iAge"> <!--- 07-18 --->
				<CFIF NOT structIsEmpty(stTeams[iBG][iAge])> 
					<!--- <br> [#iBG#] [#iAge#] [#stTeams[iBG][iAge].LEVEL#] [#stTeams[iBG][iAge].COUNT#] --->
					<CFSET AgeGroup	= "U" & ucase(iAge)>

					<CFQUERY name="qInsertTeamReq" datasource="#VARIABLES.DSN#">
						INSERT INTO TBL_CoachesRegRequest
							(ClubID, TeamAge, PlayLevel, Gender, TeamsCount )
						VALUES
							(#NewClubReqID#
							,'#AgeGroup#'
							,'#ucase(stTeams[iBG][iAge].LEVEL)#'
							,'#ucase(iBG)#'
							,#stTeams[iBG][iAge].COUNT#
							)
					</CFQUERY>	
				</CFIF>
			</CFLOOP>
		</CFLOOP>
		
	</CFIF>
	

	<cfreturn NewClubReqID>
</cffunction>



<!--- =================================================================== --->
<cffunction name="updateClubInfo" access="remote" >
	<!--- --------
		09/04/08 - AArnone - updates columns in TBL_CLUB for a given CLUB_ID
		12/11/08 - AA - Added memberNCSA
		01/20/09 - AA - Added Club address, city, state, zip
	----- --->
	<cfargument name="clubID" 	      type="string" required="Yes">
	<cfargument name="ClubName"	      type="string" required="Yes">
	<cfargument name="ClubAbbr"	      type="string" required="Yes">
	<cfargument name="ClubHomePage"   type="string"	required="Yes">
	<cfargument name="ClubEMail"      type="string" required="Yes">
	<cfargument name="HomeShirtColor" type="string" required="Yes">
	<cfargument name="HomeShortColor" type="string" required="Yes">
	<cfargument name="AwayShirtColor" type="string" required="Yes">
	<cfargument name="AwayShortColor" type="string" required="Yes">
	<cfargument name="UpdatedBy"      type="string" required="Yes">
	<cfargument name="ApproveReg"     type="string" required="No"  default="N"> <!--- OPTIONAL --->
	<cfargument name="SeasonID"       type="numeric" required="No">				<!--- OPTIONAL --->
	<cfargument name="memberNCSA"     type="string" required="Yes">
	<cfargument name="clubAddress"    type="string" required="Yes">
	<cfargument name="clubCity"       type="string" required="Yes">
	<cfargument name="clubState"      type="string" required="Yes">
	<cfargument name="clubZip"        type="string" required="Yes">

	<CFQUERY name="qUpdateClubInfo" datasource="#VARIABLES.DSN#">
		 Update TBL_CLUB
			set CLUB_NAME	   	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ClubName#">
			  , CLUBABBR	   	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ClubABBR#">
			  , ClubHomePage	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ClubHomePage#">
			  , ClubEMail		= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ClubEMail#">
			  , HomeShirtColor	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.HomeShirtColor#">
			  , HomeShortColor	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.HomeShortColor#">
			  , AwayShirtColor	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.AwayShirtColor#">
			  , AwayShortColor	= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.AwayShortColor#">
			  , memberNCSA		= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.memberNCSA#">
			  ,	Address			= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.clubAddress#">
			  ,	City			= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.clubCity#">
			  ,	State			= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.clubState#">
			  ,	Zip				= <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.clubZip#">
			  , UpdateDate	    = getdate()	
			  , UpdatedBy		= <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.UpdatedBy#">
		  Where CLUB_ID = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ClubId#">
	</CFQUERY>
	
	<CFIF isDefined("ARGUMENTS.ApproveReg") AND ARGUMENTS.ApproveReg EQ "Y">
		<CFQUERY name="qUpdateClubInfo" datasource="#VARIABLES.DSN#">
			Update xref_club_season	
			   set Approved_YN = 'Y'
				 , Active_YN   = 'Y'
				 , UpdateDate  = getDate()
				 , updatedBy   = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.UpdatedBy#">
		  where club_id     = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ClubId#">
		    and season_id   = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.SeasonID#">
		</CFQUERY>
	</CFIF>
	
	
	
</cffunction>

	
<!--- =================================================================== --->
<cffunction name="processClubEdit" access="remote" >
	<!--- --------
		09/04/08 - AArnone - processes form variables from clubEditInfo.cfm
		12/11/08 - AA - Added memberNCSA
		01/20/09 - AA - Added Club address, city, state, zip
	----- --->
	<cfargument name="formValues" type="struct" required="Yes">

	<CFSET userContactID	= Trim(ARGUMENTS.formValues.userContactID)>
	<CFSET SeasonID			= Trim(ARGUMENTS.formValues.SeasonID)>
	<CFSET ClubId			= Trim(ARGUMENTS.formValues.ClubID)>
	<CFSET ClubName			= Trim(ARGUMENTS.formValues.ClubName)>
	<CFSET ClubAbbr			= Trim(ARGUMENTS.formValues.ClubAbbr)>
	<CFSET ClubHomePage 	= Trim(ARGUMENTS.formValues.HomePage)>
	<CFSET ClubEmail		= Trim(ARGUMENTS.formValues.ClubEMail)>
	<!--- <CFSET UserID			= Trim(ARGUMENTS.formValues.UserID)>
	<CFSET Password			= Trim(ARGUMENTS.formValues.Password)> --->
	<CFSET HomeShirtColor	= Trim(ARGUMENTS.formValues.HomeShirtColor)>
	<CFSET HomeShortColor	= Trim(ARGUMENTS.formValues.HomeShortColor)>
	<CFSET AwayShirtColor	= Trim(ARGUMENTS.formValues.AwayShirtColor)>
	<CFSET AwayShortColor	= Trim(ARGUMENTS.formValues.AwayShortColor)>
	<CFSET memberNCSA 		= Trim(ARGUMENTS.formValues.memberNCSA)>

	<CFSET clubAddress		= Trim(ARGUMENTS.formValues.clubAddress) > 
	<CFSET clubCity			= Trim(ARGUMENTS.formValues.clubCity) > 
	<CFSET clubState		= Trim(ARGUMENTS.formValues.clubState) > 
	<CFSET clubZip			= Trim(ARGUMENTS.formValues.clubZip) > 
	
	<CFSET NEW_Rep_ID 	= 0>
	<CFSET NEW_Alt_ID 	= 0>
	<CFSET NEW_Pres_ID 	= 0>
	<CFSET ORIG_Rep_ID = 0>
	<CFSET Orig_Alt_ID = 0>
	<CFSET ORIG_Pres_ID = 0>
	<CFSET Rep_Contact_role_id = 0>
	<CFSET Alt_Contact_role_id = 0>
	<CFSET Pres_Contact_role_id = 0>

	<CFIF Len(trim(ARGUMENTS.formValues.ClubRepID))>
		<CFSET NEW_Rep_ID	= Trim(ARGUMENTS.formValues.ClubRepID)>
	</CFIF>
	<CFIF Len(trim(ARGUMENTS.formValues.ClubAltID))>
		<CFSET NEW_Alt_ID	= Trim(ARGUMENTS.formValues.ClubAltID)>
	</CFIF>
	<CFIF Len(trim(ARGUMENTS.formValues.ClubPresID))>
		<CFSET NEW_Pres_ID	= Trim(ARGUMENTS.formValues.ClubPresID)>
	</CFIF>

	<CFIF Len(trim(ARGUMENTS.formValues.Orig_Rep_ID))>
		<CFSET ORIG_Rep_ID = Trim(ARGUMENTS.formValues.Orig_Rep_ID)>
	</CFIF>
	<CFIF Len(trim(ARGUMENTS.formValues.Orig_Alt_ID))>
		<CFSET Orig_Alt_ID = Trim(ARGUMENTS.formValues.Orig_Alt_ID)>
	</CFIF>
	<CFIF Len(trim(ARGUMENTS.formValues.ORIG_Pres_ID))>
		<CFSET ORIG_Pres_ID = Trim(ARGUMENTS.formValues.ORIG_Pres_ID)>
	</CFIF>

	<CFIF Len(trim(ARGUMENTS.formValues.Rep_Contact_role_id))>
		<CFSET Rep_Contact_role_id = Trim(ARGUMENTS.formValues.Rep_Contact_role_id)>
	</CFIF>
	<CFIF Len(trim(ARGUMENTS.formValues.Alt_Contact_role_id))>
		<CFSET Alt_Contact_role_id = Trim(ARGUMENTS.formValues.Alt_Contact_role_id)>
	</CFIF>
	<CFIF Len(trim(ARGUMENTS.formValues.Pres_Contact_role_id))>
		<CFSET Pres_Contact_role_id = Trim(ARGUMENTS.formValues.Pres_Contact_role_id)>
	</CFIF>

	<CFIF isDefined("ARGUMENTS.formValues.ApproveREG") AND ARGUMENTS.formValues.ApproveREG EQ "Y">
		<!--- update TBL_CLUB, for registering clubs for new season --->
		<cfinvoke method="updateClubInfo" >
			<cfinvokeargument name="clubID" 	    value="#VARIABLES.ClubId#">
			<cfinvokeargument name="ClubName"	    value="#VARIABLES.ClubName#">
			<cfinvokeargument name="ClubAbbr"	    value="#VARIABLES.ClubAbbr#">
			<cfinvokeargument name="ClubHomePage"   value="#VARIABLES.ClubHomePage#">
			<cfinvokeargument name="ClubEMail"      value="#VARIABLES.ClubEmail#">
			<cfinvokeargument name="HomeShirtColor" value="#VARIABLES.HomeShirtColor#">
			<cfinvokeargument name="HomeShortColor" value="#VARIABLES.HomeShortColor#">
			<cfinvokeargument name="AwayShirtColor" value="#VARIABLES.AwayShirtColor#">
			<cfinvokeargument name="AwayShortColor" value="#VARIABLES.AwayShortColor#">
			<cfinvokeargument name="UpdatedBy"      value="#VARIABLES.userContactID#">
			<cfinvokeargument name="ApproveReg"     value="#ARGUMENTS.formValues.ApproveREG#">
			<cfinvokeargument name="SeasonID"       value="#VARIABLES.SeasonID#">
			<cfinvokeargument name="memberNCSA"     value="#VARIABLES.memberNCSA#">
			<cfinvokeargument name="clubAddress"    value="#VARIABLES.clubAddress#">
			<cfinvokeargument name="clubCity"       value="#VARIABLES.clubCity#">
			<cfinvokeargument name="clubState"      value="#VARIABLES.clubState#">
			<cfinvokeargument name="clubZip"        value="#VARIABLES.clubZip#">
		</cfinvoke> 
	<CFELSE>
		<!--- update TBL_CLUB, for clubs during regular season --->
		<cfinvoke method="updateClubInfo" >
			<cfinvokeargument name="clubID" 	    value="#VARIABLES.ClubId#">
			<cfinvokeargument name="ClubName"	    value="#VARIABLES.ClubName#">
			<cfinvokeargument name="ClubAbbr"	    value="#VARIABLES.ClubAbbr#">
			<cfinvokeargument name="ClubHomePage"   value="#VARIABLES.ClubHomePage#">
			<cfinvokeargument name="ClubEMail"      value="#VARIABLES.ClubEmail#">
			<cfinvokeargument name="HomeShirtColor" value="#VARIABLES.HomeShirtColor#">
			<cfinvokeargument name="HomeShortColor" value="#VARIABLES.HomeShortColor#">
			<cfinvokeargument name="AwayShirtColor" value="#VARIABLES.AwayShirtColor#">
			<cfinvokeargument name="AwayShortColor" value="#VARIABLES.AwayShortColor#">
			<cfinvokeargument name="UpdatedBy"      value="#VARIABLES.userContactID#">
			<cfinvokeargument name="memberNCSA"     value="#VARIABLES.memberNCSA#">
			<cfinvokeargument name="clubAddress"    value="#VARIABLES.clubAddress#">
			<cfinvokeargument name="clubCity"       value="#VARIABLES.clubCity#">
			<cfinvokeargument name="clubState"      value="#VARIABLES.clubState#">
			<cfinvokeargument name="clubZip"        value="#VARIABLES.clubZip#">
		</cfinvoke> 
	</CFIF>
	

	<CFIF ORIG_Rep_ID NEQ NEW_Rep_ID>
		<CFIF NEW_Rep_ID EQ 0 >	<!---  was removed and set to nothing so delete xref --->
			<cfinvoke component="contact" method="deleteXrefContactRole" >
				<cfinvokeargument name="contactROLEid" value="#VARIABLES.Rep_Contact_role_id#">
			</cfinvoke>

		<CFELSE>
			<CFIF ORIG_Rep_ID EQ 0 > <!---  was set to zero so we need to insert xref --->
				<!---  insert new contact for this role --->
				<cfinvoke component="contact" method="insertContactRole" returnvariable="xcrID">
					<cfinvokeargument name="contactID" value="#VARIABLES.NEW_Rep_ID#">
					<cfinvokeargument name="roleID"    value="#SESSION.CONSTANT.ROLEIDCLUBREP#">       
					<cfinvokeargument name="ClubId"    value="#VARIABLES.ClubId#">
					<cfinvokeargument name="seasonID"  value="#VARIABLES.seasonID#">
					<cfinvokeargument name="activeYN"  value="Y">	
					<cfinvokeargument name="allowGameEdit"  value="0"> 
				</cfinvoke>

			<CFELSE>
				<!---  Update role with new contact --->
				<cfinvoke component="contact" method="updContactRoleNEW" >
					<cfinvokeargument name="contactID"     value="#VARIABLES.NEW_Rep_ID#">
					<cfinvokeargument name="contactROLEid" value="#VARIABLES.Rep_Contact_role_id#">
				</cfinvoke>
			</CFIF>
		</CFIF>
	</CFIF>
	
	<CFIF ORIG_Alt_ID NEQ NEW_Alt_ID>
		<CFIF NEW_Alt_ID EQ 0 > <!--- was removed and set to nothing so delete xref --->

			<cfinvoke component="contact" method="deleteXrefContactRole" >
				<cfinvokeargument name="contactROLEid" value="#VARIABLES.Alt_Contact_role_id#">
			</cfinvoke>

		<CFELSE>
			<CFIF ORIG_Alt_ID EQ 0 > <!--- was set to zero so we need to insert xref --->
				<!--- insert new contact for this role --->
				<cfinvoke component="contact" method="insertContactRole" returnvariable="xcrID">
					<cfinvokeargument name="contactID" value="#VARIABLES.NEW_Alt_ID#">
					<cfinvokeargument name="roleID"    value="#SESSION.CONSTANT.ROLEIDCLUBALT#"> 
					<cfinvokeargument name="ClubId"    value="#VARIABLES.ClubId#">
					<cfinvokeargument name="seasonID"  value="#VARIABLES.seasonID#">
					<cfinvokeargument name="activeYN"  value="Y">	
					<cfinvokeargument name="allowGameEdit"  value="0"> 
				</cfinvoke>

			<CFELSE>
				<!---  Update role with new contact --->
				<cfinvoke component="contact" method="updContactRoleNEW" >
					<cfinvokeargument name="contactID"     value="#VARIABLES.NEW_Alt_ID#">
					<cfinvokeargument name="contactROLEid" value="#VARIABLES.Alt_Contact_role_id#">
				</cfinvoke>
			</CFIF>
		</CFIF>
	</CFIF>
	
	<CFIF ORIG_Pres_ID NEQ NEW_Pres_ID >
		<CFIF NEW_Pres_ID EQ 0> <!---  was removed and set to nothing so delete xref --->

			<cfinvoke component="contact" method="deleteXrefContactRole" >
				<cfinvokeargument name="contactROLEid" value="#VARIABLES.Pres_Contact_role_id#">
			</cfinvoke>

		<CFELSE>
			<CFIF ORIG_Pres_ID EQ 0 > <!--- was set to zero so we need to insert xref --->
				 <!--- insert new contact for this role --->
				<cfinvoke component="contact" method="insertContactRole" returnvariable="xcrID">
					<cfinvokeargument name="contactID" value="#VARIABLES.NEW_Pres_ID#">
					<cfinvokeargument name="roleID"    value="#SESSION.CONSTANT.ROLEIDCLUBPRES#">
					<cfinvokeargument name="ClubId"    value="#VARIABLES.ClubId#">
					<cfinvokeargument name="seasonID"  value="#VARIABLES.seasonID#">
					<cfinvokeargument name="activeYN"  value="Y">	
					<cfinvokeargument name="allowGameEdit"  value="0"> 
				</cfinvoke>

			<CFELSE>
				 <!--- Update role with new contact --->
				<cfinvoke component="contact" method="updContactRoleNEW" >
					<cfinvokeargument name="contactID"     value="#VARIABLES.NEW_Pres_ID#">
					<cfinvokeargument name="contactROLEid" value="#VARIABLES.Pres_Contact_role_id#">
				</cfinvoke>
			</CFIF>
		</CFIF>
	</CFIF>

</cffunction>


<!--- =================================================================== --->
<cffunction name="approveNewClubRequest" access="remote" returntype="struct" >
	<!--- --------
		09/08/08 - AArnone - the new club is approved, insert it into tbl clubs
	----- --->
	<cfargument name="newClubID" type="numeric" required="Yes" default="0">
	<cfargument name="seasonID" type="numeric" required="Yes" default="0">
	<cfargument name="contactID" type="numeric" required="Yes" default="0">
	
	<cfset returnMSG = "">
	
	<CFQUERY name="qNewInfo" datasource="#VARIABLES.DSN#">
		SELECT Club, Address, Town, State, Zip,
			   PresidentName, PresidentLastName, PAddress, PTown, PState, PZip,   	
			   PPhone, PFax, PHomePhone, PCellPhone, PEmail,
			   USSFCertReferees, HomeFieldFull, HomeFieldSmall,
			   Comments, RequestDate 
		  FROM TBL_ClubRegRequest 
		 WHERE ID = #ARGUMENTS.newClubID#
	</CFQUERY>
	
	<CFIF qNewInfo.RECORDCOUNT>
		<!--- Insert the new club values.... --->
		<CFSTOREDPROC procedure="p_insert_club" datasource="#VARIABLES.DSN#">
			<cfprocparam type="In" dbvarname="@Club_name"		cfsqltype="CF_SQL_VARCHAR" value="#qNewInfo.Club#">
			<cfprocparam type="In" dbvarname="@ClubAbbr"		cfsqltype="CF_SQL_VARCHAR" value="" null="Yes">
			<cfprocparam type="In" dbvarname="@ClubHomePage"	cfsqltype="CF_SQL_VARCHAR" value="" null="Yes">
			<cfprocparam type="In" dbvarname="@clubEmail"		cfsqltype="CF_SQL_VARCHAR" value="" null="Yes">
			<cfprocparam type="In" dbvarname="@Address"			cfsqltype="CF_SQL_VARCHAR" value="#qNewInfo.Address#">
			<cfprocparam type="In" dbvarname="@City"			cfsqltype="CF_SQL_VARCHAR" value="#qNewInfo.Town#">
			<cfprocparam type="In" dbvarname="@State"			cfsqltype="CF_SQL_VARCHAR" value="#qNewInfo.State#">
			<cfprocparam type="In" dbvarname="@Zip"				cfsqltype="CF_SQL_VARCHAR" value="#qNewInfo.Zip#">
			<cfprocparam type="In" dbvarname="@HomeShirtColor"	cfsqltype="CF_SQL_VARCHAR" value="" null="Yes">
			<cfprocparam type="In" dbvarname="@HomeShortColor"	cfsqltype="CF_SQL_VARCHAR" value="" null="Yes">
			<cfprocparam type="In" dbvarname="@AwayShirtColor"	cfsqltype="CF_SQL_VARCHAR" value="" null="Yes">
			<cfprocparam type="In" dbvarname="@AwayShortColor"	cfsqltype="CF_SQL_VARCHAR" value="" null="Yes">
			<cfprocparam type="In" dbvarname="@MemberNCSA"		cfsqltype="CF_SQL_VARCHAR" value="" null="Yes">
			<cfprocparam type="In" dbvarname="@CreatedBy"		cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">
			<cfprocparam type="In" dbvarname="@Club_State"		cfsqltype="CF_SQL_VARCHAR" value="#qNewInfo.State#">
			<cfprocparam type="In" dbvarname="@homeFieldFull"	cfsqltype="CF_SQL_NUMERIC" value="#qNewInfo.HomeFieldFull#">
			<cfprocparam type="In" dbvarname="@homeFieldSmall"	cfsqltype="CF_SQL_NUMERIC" value="#qNewInfo.HomeFieldSmall#">
			<cfprocparam type="In" dbvarname="@USSFCertReferees" cfsqltype="CF_SQL_NUMERIC" value="#qNewInfo.USSFCertReferees#">
			<cfprocparam type="Out" dbvarname="@club_id"		 cfsqltype="CF_SQL_NUMERIC" variable="clubID">
		</CFSTOREDPROC> 
					
		<!--- Insert club/season xref --->
		<CFSTOREDPROC procedure="p_create_new_club_season" datasource="#VARIABLES.DSN#">
			<cfprocparam type="In" dbvarname="@club_id"    cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.ClubID#">
			<cfprocparam type="In" dbvarname="@season_id"  cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.seasonID#">
			<cfprocparam type="In" dbvarname="@created_by" cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.ContactID#">
		</CFSTOREDPROC> 

		<cfset returnMSG = "">
		<CFSET clubID = clubID>

	<CFELSE>
		<cfset returnMSG = "new club reg id not found.">
		<CFSET clubID = 0>

	</CFIF>	

	<CFSET stReturn = structNew()>	
	<CFSET stReturn.message = returnMSG>
	<CFSET stReturn.clubID  = clubID>


	<cfreturn stReturn>
</cffunction>


<!--- =================================================================== --->
<cffunction name="updateClubTeamCounts" access="remote" >
	<!--- --------
		09/10/08 - AArnone - update a clubs team counts
	----- --->
	<cfargument name="TotalU10YoungerTeams" type="numeric" required="Yes">
	<cfargument name="Total11Thru14Teams"   type="numeric" required="Yes">
	<cfargument name="Total15thru19Teams"   type="numeric" required="Yes">
	<cfargument name="updContactID" type="numeric" required="Yes">
	<cfargument name="seasonID"     type="numeric" required="Yes">
	<cfargument name="clubID"       type="string" required="Yes">

	<CFQUERY name="qUpdateTeamCounts" datasource="#VARIABLES.DSN#">
		Update XREF_CLUB_SEASON
		   SET TotalU10YoungerTeams = #ARGUMENTS.TotalU10YoungerTeams#
			 , Total11Thru14Teams   = #ARGUMENTS.Total11Thru14Teams#
			 , Total15thru19Teams   = #ARGUMENTS.Total15thru19Teams#
			 , UpdateDate		    = getDate()
			 , UpdatedBy			= #ARGUMENTS.updContactID#
		 Where SEASON_ID		    = #ARGUMENTS.seasonID#
		   AND CLUB_ID			    = #ARGUMENTS.clubId#
	</CFQUERY>
</cffunction>


<cffunction name="getClubs" access="public" returntype="query" description="Return query of all clubs">
	<CFQUERY name="qClubs" datasource="#SESSION.DSN#">
		SELECT distinct club_id, Club_name, ClubAbbr
		FROM tbl_club
		order by club_name 
	</CFQUERY>
	
	<cfreturn qClubs>
	
</cffunction>

<!--- -----------------------
	end component CLUB.cfc
------------------------ --->

</cfcomponent>
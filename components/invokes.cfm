

<CFQUERY name="qUpdateGameRequest" datasource="#SESSION.DSN#">
	Update  TBL_GAME_CHANGE_REQUEST
	   set  NewTime	 = 
	   <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#dateFormat(VARIABLES.NewDate,"mm/dd/yyyy")# #timeformat(VARIABLES.NewTime,"hh:mm:ss tt")#"> 
		 ,  NewDate	 = 
	   <cfqueryparam cfsqltype="CF_SQL_DATE" value="#dateFormat(VARIABLES.NewDate,"mm/dd/yyyy")#">

		 ,  NewField = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#VARIABLES.NewFieldID#">
		 ,  Comments = <cfqueryparam cfsqltype="CF_SQL_LONGVARCHAR" value="#VARIABLES.Comments#">
	 Where  game_Change_Request_Id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#VARIABLES.ChangeRequestID#">
</CFQUERY>





<!---  
CLUB  -------------------------------------------------------------------------------  --->
		<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubInfo" returnvariable="qClubs">
			<cfinvokeargument name="orderby"  value="#clubname#">
		</cfinvoke>  
		<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubInfo" returnvariable="qClubs">
			<cfinvokeargument name="clubID" value="#clubid#">
		</cfinvoke>  



<!---  
CONTACT  ----------------------------------------------------------------------------  --->
		<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="getClubContacts" returnvariable="qContacts">
			<cfinvokeargument name="clubID"  value="#CLUBID#">
		</cfinvoke>  
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="ContactExist" returnvariable="coachExist">
					<cfinvokeargument name="contactid" value="#HeadCoachID#">
					<cfinvokeargument name="roleid"    value=29>
					<cfinvokeargument name="clubid"    value="#ClubId#">
					<cfinvokeargument name="seasonid"  value="#SESSION.REGSEASON.SEASONID#">
				</cfinvoke>

<!---  
FIELD -------------------------------------------------------------------------------  --->

<!---  
GAME  -------------------------------------------------------------------------------  --->
		<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
			<cfinvokeargument name="teamID"  value="#FORM.TEAMID#">
		</cfinvoke>  

<!---  
MENU  -------------------------------------------------------------------------------  --->

<!---
TEAM  -------------------------------------------------------------------------------  --->
 		<cfinvoke component="#SESSION.sitevars.cfcPath#team" method="getClubTeams" returnvariable="qClubTeams">
			<cfinvokeargument name="orderby"  value="teamname">
		</cfinvoke>  
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#team" method="deleteTeam">
				<cfinvokeargument name="teamID"   value="#TeamId#">
				<cfinvokeargument name="seasonID" value="#SESSION.REGSEASON.SEASONID#">
			</cfinvoke>

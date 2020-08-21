<!--- 
	FileName:	site.cfc
	Created on: 08/21/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: this file will handle site functions like logging, etc
	
MODS: mm/dd/yyyy - filastname - comments

 --->


<cfcomponent>
<CFSET DSN = SESSION.DSN>

<!--- =================================================================== --->
<cffunction name="WriteLoginLogRecord" access="public" returntype="numeric">
	<!--- --------
		08/21/08 - AArnone - New function: logs a sucessful log in
		05/27/2009 - aarnone - T:7584 - REPLACED query below with SP below and it now returns a log id	


	<cfquery name="insertSiteAsseccLog" datasource="#VARIABLES.DSN#">
		insert into cpc_SiteAccesslog 
			(dt_access_date, userid, session_id, ip_address, browser_info)
		values  
			( getDate() 
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.UserID#" >  
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.SessionID#" >  
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.REMOTEADDR#" >
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.browserInfo#" >
			)
	</cfquery>
	----- --->
	<cfargument name="UserID" 		type="string" required="Yes">
	<cfargument name="SessionID" 	type="string" required="Yes">
	<cfargument name="REMOTEADDR" 	type="string" required="Yes">
	<cfargument name="browserInfo" 	type="string" required="Yes">

	<cfstoredproc procedure="p_insert_SiteAccessLog" datasource="#VARIABLES.DSN#">
		<cfprocparam type="In" dbvarname="@userID"		cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.UserID#" >
		<cfprocparam type="In" dbvarname="@sessionID"   cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.SessionID#" > 
		<cfprocparam type="In" dbvarname="@remoteAddr"  cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.REMOTEADDR#" >
		<cfprocparam type="In" dbvarname="@browserInfo" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.browserInfo#" >
		<cfprocparam type="Out" dbvarname="@siteAccessLogID" cfsqltype="CF_SQL_NUMERIC" variable="siteAccessLogID">
	</cfstoredproc> 

	<cfreturn siteAccessLogID>
</cffunction>
	
<!--- =================================================================== --->
<cffunction name="WriteFailedLoginLogRecord" access="public">
	<!--- --------
		08/21/08 - AArnone - New function: logs a failed log in
	----- --->
	<cfargument name="UserID" 		type="string" required="Yes">
	<cfargument name="SessionID" 	type="string" required="Yes">
	<cfargument name="REMOTEUSER" 	type="string" required="Yes">
	<cfargument name="REMOTEHOST" 	type="string" required="Yes">
	<cfargument name="USERAGENT" 	type="string" required="Yes">
	<cfargument name="REMOTEADDR" 	type="string" required="Yes">
	
	<cfquery name="insertSiteAsseccLog" datasource="#VARIABLES.DSN#">
		insert into cpc_BlockedFailedlog 
			(dt_event_date, userid, session_id, remote_user, remote_host, user_agent, ip_address)
		values 
			( getDate() 
			, 'FAILED: #ARGUMENTS.UserID#'
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.SessionID#" >  
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.REMOTEUSER#"> 
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.REMOTEHOST#"> 
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.USERAGENT#"> 
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.REMOTEADDR#">
			)
	</cfquery>

</cffunction>

<!--- =================================================================== --->
<cffunction name="WritePageAccessLogRecord" access="public">
	<!--- --------
		09/16/08 - AArnone - logs page accessed by user
		05/27/2009 - aarnone - T:7584 - added siteAccessLogID to the INSERT 	
	----- --->
	<cfargument name="userID"			 type="numeric" required="Yes">
	<cfargument name="siteAccessLogID"	 type="numeric" required="Yes">
	<cfargument name="sessionID"		 type="string"  required="Yes">
	<cfargument name="IPaddress"		 type="string"  required="Yes">
	<cfargument name="URL"				 type="string"  required="Yes">
	
	<CFQUERY name="insertPageAccess" datasource="#VARIABLES.DSN#">
		INSERT INTO cpc_pageAccessLog
			( DT_ACCESS_DATE, USER_ID, SESSION_ID, IP_ADDRESS, URL, siteAccessLog_id)
		VALUES
			( getDate()
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.userID#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.sessionID#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.IPaddress#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.URL#">
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.siteAccessLogID#">
			)
	</cfquery>

</cffunction>


<!--- =================================================================== --->
<cffunction name="WriteGameLogRecord" access="public">
	<!--- --------
		09/30/08 - AArnone - logs Game changes
	----- --->
	<cfargument name="GameID" 	   type="numeric" required="Yes" >
	<cfargument name="ContactID"   type="numeric" required="Yes" >
	<cfargument name="Script_Name" type="string"  required="Yes" >

	<cfstoredproc procedure="p_LOG_Game" datasource="#VARIABLES.DSN#">
		<cfprocparam type="In" dbvarname="@game_id" cfsqltype="CF_SQL_NUMERIC"  value="#ARGUMENTS.GameID#">
		<cfprocparam type="In" dbvarname="@username" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ContactID#">
		<cfprocparam type="In" dbvarname="@pagename" cfsqltype="CF_SQL_VARCHAR"	value="#ARGUMENTS.Script_Name#">
	</cfstoredproc>
</cffunction>


<!--- =================================================================== --->
<cffunction name="GetPageAccess" access="public" returntype="query">
	<cfargument name="sortBy"	 type="string" required="No" default="Date" >
	<cfargument name="startDate" type="string"   required="No">
	<cfargument name="endDate"   type="string"   required="No">
	<!--- --------
		01/22/09 - AArnone - 
		05/27/2009 - aarnone - T:7584 - added siteAccessLogID to the SELECT 	
	----- --->
	<CFIF isDefined("ARGUMENTS.startDate") AND isDate(ARGUMENTS.startDate)>
		<CFSET dateStart = dateFormat(ARGUMENTS.startDate, "mm/dd/yyyy")>
	<CFELSE>
		<CFSET dateStart = dateFormat(dateAdd("d",-7,Now() ), "mm/dd/yyyy")>
	</CFIF>
	<CFIF isDefined("ARGUMENTS.endDate") AND isDate(ARGUMENTS.endDate)>
		<CFSET dateEnd = dateFormat(ARGUMENTS.dateEnd, "mm/dd/yyyy")>
	<CFELSE>
		<CFSET dateEnd = dateFormat(dateAdd("d",+1,Now() ), "mm/dd/yyyy")>
	</CFIF>
	
	<cfquery name="qGetPagesViewed" datasource="#VARIABLES.DSN#">
		select pa.pageAccessLog_id, pa.dt_access_date, pa.ip_address, pa.URL,
		       pa.session_id, pa.user_id, pa.siteAccessLog_id,
			   co.Firstname, co.lastname  
		  FROM cpc_pageAccessLog pa 
		  				Inner Join TBL_CONTACT co ON co.CONTACT_ID = pa.user_ID
		 WHERE pa.dt_access_date >= <cfqueryParam cfsqltype="CF_SQL_TIMESTAMP" value="#VARIABLES.dateStart#">
		   AND pa.dt_access_date <= <cfqueryParam cfsqltype="CF_SQL_TIMESTAMP" value="#VARIABLES.dateEnd#">
   		ORDER BY pa.dt_access_date DESC
	</cfquery>

	<cfreturn qGetPagesViewed>

</cffunction>


<!--- ------------------------ --->
<!--- END - component SITE.cfc --->
<!--- ------------------------ --->
</cfcomponent>




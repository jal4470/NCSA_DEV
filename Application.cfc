<!--- 
01/28/2009 - AA - added global vars for site settings in onSessionStart()
02/02/2009 - AA - added global var: ShowGameChangeRequest
 --->
<cfcomponent>
	<cfset This.name="NCSA">
	<cfset This.Sessionmanagement=true>
	<cfset This.Sessiontimeout="#createtimespan(0,0,30,0)#">
	<!--- <cfset This.applicationtimeout="#createtimespan(5,0,0,0)#"> --->

<!--- ============================================================= --->
	<cffunction name="onApplicationStart">
		<CFSET Application.DSN = "NCSA">
		<cfset application.email_dsn = "cp_email">
		<cfset application.reports_dsn = "ncsa_reports">
	    <cftry>
	        <!--- Test whether the DB that this application uses is accessible by selecting some data. --->
	        <cfquery name="menu" dataSource="#Application.DSN#" >
	            SELECT count(*) as numRecs FROM TBL_MENU
	        </cfquery>
	        <!--- If we get database error, report it to the user, log the error information, and do not start the application. --->
	        <cfcatch type="database">
	            <cfoutput>
	                This application encountered an error.<br> 
	                Please contact support.
	            </cfoutput>
	            <cflog file="#This.Name#" type="error" 
	                text="NCSA DB not available. message: #cfcatch.message# 
	                Detail: #cfcatch.detail# Native Error: #cfcatch.NativeErrorCode#">
	            <cfreturn False>
	        </cfcatch>
	    </cftry>
	    <cflog file="#This.Name#" type="Information" text="Application Started">
	    <!--- You do not have to lock code in the onApplicationStart method that sets Application scope variables. --->
		<cfinvoke method="setApplVals">
			<cfinvokeArgument name="menuCounter" value="#menu.numRecs#">
		</cfinvoke>
	    <!--- You do not need to return True if you don't set the cffunction returntype attribute. --->
	 </cffunction>

<!--- ============================================================= --->
	 <cffunction name="setApplVals">
	 	<cfargument name="menuCounter" required="No" type="numeric" default="999">
<!--- TODO: put in logic to distinguish btw DEV and PROD  --->
	    <cfscript>
			APPLICATION.sitevars = structNew();
			Application.sitevars.cfcpath   = "components.";
			Application.sitevars.homehttp  = "//#cgi.server_name#";
			Application.sitevars.imagePath = "assets/images/";
			Application.sitevars.docPath   = "/assets/";
			Application.sitevars.altColors = "FBFBFB,FFFFFF";
			Application.siteVars.tblHeading = "3399CC";
			Application.sitevars.tempPath = "C:\inetpub\wwwroot\NCSA\uploads\temp";
			Application.sitevars.adAssets = "C:\inetpub\wwwroot\NCSA\uploads\ad_assets";
			Application.sitevars.captchaSiteKey = "6LduJe0ZAAAAAHGdpCeCQRLcmW7ApNHv7Jew0HGC";
			Application.sitevars.captchaSecret = "6LduJe0ZAAAAAGLIFdHLKG_L4mFAA0ITjAfPQOpB";
	    </cfscript>

	 </cffunction>

	 
<!--- ============================================================= --->
	<cffunction name="onSessionStart">
		<!--- check login.cfm, it invokes this function because if there is a change in season or reg is opened/closed the session 
			  was not reflecting the new values until the session timed out. Putting logic in the login page will force it to change
			  when someone hits that page.
		 --->
		<cfscript>
    	    SESSION.DSN		 = APPLICATION.DSN ;
    	    SESSION.email_DSN		 = application.email_dsn ;
    	    SESSION.sitevars = APPLICATION.sitevars;
			// Current Season Structure
			season = createObject("component", "#SESSION.sitevars.cfcPath#season");
			qCurrSeason = season.getCurrentSeason();
			if ( qCurrSeason.recordCount )
			{	SESSION.CurrentSeason = structNew();
				SESSION.CurrentSeason.ID		= qCurrSeason.season_id;
			 	SESSION.CurrentSeason.StartDate	= qCurrSeason.season_startDate;
			 	SESSION.CurrentSeason.EndDate	= qCurrSeason.season_endDate;
			 	SESSION.CurrentSeason.SF		= qCurrSeason.season_SF;
			 	SESSION.CurrentSeason.Year		= qCurrSeason.season_year;
			 	SESSION.CurrentSeason.Code		= qCurrSeason.seasonCode;
			}
			// Global Vars Structure
			globalVars = createObject("component", "#SESSION.sitevars.cfcPath#globalVars");
			qGVars = globalVars.getGlobalVars();
			if ( qGVars.recordCount gt 0 )
			{	globalVars = structNew();
				currRow = 1;
				do {	switch(qGVars._NAME[currRow]) 
						{	case "AppealOpen": 		  
								SESSION.globalVars.AppealOpen = qGVars._VALUE[currRow]; 
								break;
							case "RegOpen":			  
								SESSION.globalVars.RegOpen = qGVars._VALUE[currRow]; 
								break;
							case "TBSOpen":			  
								SESSION.globalVars.TBSOpen = qGVars._VALUE[currRow]; 
								break;
							case "DirectionsEdit":	  
								SESSION.globalVars.DirectionsEdit = qGVars._VALUE[currRow]; 
								break;
							case "AllowSchedDisplay": 
								SESSION.globalVars.AllowSchedDisplay = qGVars._VALUE[currRow]; 
								break;
							case "EditGameAuthClub": 
								SESSION.globalVars.EditGameAuthClub = qGVars._VALUE[currRow]; 
								break;
							case "RefAssignViewDate": 
								SESSION.globalVars.RefAssignViewDate = qGVars._VALUE[currRow]; 
								break;
							case "RefAssignViewDateYN": 
								SESSION.globalVars.RefAssignViewDateYN = qGVars._VALUE[currRow]; 
								break;
							case "ShowRegisterClub": 
								SESSION.globalVars.ShowRegisterClub = qGVars._VALUE[currRow]; 
								break;
							case "ShowRegisterTeam": 
								SESSION.globalVars.ShowRegisterTeam = qGVars._VALUE[currRow]; 
								break;
							case "ShowTeamFlightingPublicLink": 
								SESSION.globalVars.ShowTeamFlightingPublicLink = qGVars._VALUE[currRow]; 
								break;
							case "ShowGameChangeRequest": 
								SESSION.globalVars.ShowGameChangeRequest = qGVars._VALUE[currRow]; 
								break;
						}
						currRow=currRow+1;
				   } While (currRow LTE qGVars.recordCount);
			}
			// Registration Season Structure - populate if regOpen is OPEN
			IF ( SESSION.globalVars.RegOpen EQ "OPEN" )
			{	regSeason = createObject("component", "#SESSION.sitevars.cfcPath#season");
				qRegSeason = regSeason.getRegSeason();
				if ( qRegSeason.recordCount )
				{	SESSION.RegSeason = structNew();
					Session.RegSeason.ID		= qRegSeason.season_id;
					Session.RegSeason.StartDate	= qRegSeason.season_startDate;
					Session.RegSeason.EndDate	= qRegSeason.season_endDate;
					Session.RegSeason.SF		= qRegSeason.season_SF;
					Session.RegSeason.Year		= qRegSeason.season_year;
					Session.RegSeason.Code		= qRegSeason.seasonCode;
				}
			}
			// Constants - changing values here will avoid changing HC values in code. will need to refresh application if changed
			SESSION.Constant = structNew();
			SESSION.Constant.RoleIDclubPres = 26;
			SESSION.Constant.RoleIDclubRep  = 27;
			SESSION.Constant.RoleIDclubAlt  = 28;
			SESSION.Constant.RoleIDcoach	= 29;
			SESSION.Constant.CUroles		= "26,27,28,29";
			SESSION.Constant.AdminRoles     = "1,59,61";
		</cfscript>
	</cffunction>
	 
<cffunction name="onRequestStart"> 
	<!--- CHECK FOR URL PARAMETER TO RESTART APPLICATION --->
	<cfif isdefined("url.app_reinit") AND url.app_reinit EQ "resetit">
		<cfset onApplicationStart()>
	</cfif>

	<cfif (isdefined('form.work_with_season'))>
		<cflock scope="SESSION" type="EXCLUSIVE" timeout="5">
			<cfscript>
				season = createObject("component", "#SESSION.sitevars.cfcPath#season");
				qWorkWithSeason = season.getSeasonInfoByID(form.work_with_Season);
				SESSION.CurrentSeason = structNew();
				SESSION.CurrentSeason.ID		= qWorkWithSeason.season_id;
			 	SESSION.CurrentSeason.StartDate	= qWorkWithSeason.season_startDate;
			 	SESSION.CurrentSeason.EndDate	= qWorkWithSeason.season_endDate;
			 	SESSION.CurrentSeason.SF		= qWorkWithSeason.season_SF;
			 	SESSION.CurrentSeason.Year		= qWorkWithSeason.season_year;
			 	SESSION.CurrentSeason.Code		= qWorkWithSeason.seasonCode;
			</cfscript>
			<cfset session.working_with_season = "true">
		</cflock>
		<cfset request.working_with_season = session.working_with_season>
	<cfelseif isdefined('url.mv') and not url.mv and isdefined("session.working_with_season")>
		<cflock scope="SESSION" type="EXCLUSIVE" timeout="5">
			<cfset tmp = StructDelete(session, "working_with_season")>
			<cfscript>
			season = createObject("component", "#SESSION.sitevars.cfcPath#season");
			qCurrSeason = season.getCurrentSeason();
			if ( qCurrSeason.recordCount )
			{	SESSION.CurrentSeason = structNew();
				SESSION.CurrentSeason.ID		= qCurrSeason.season_id;
			 	SESSION.CurrentSeason.StartDate	= qCurrSeason.season_startDate;
			 	SESSION.CurrentSeason.EndDate	= qCurrSeason.season_endDate;
			 	SESSION.CurrentSeason.SF		= qCurrSeason.season_SF;
			 	SESSION.CurrentSeason.Year		= qCurrSeason.season_year;
			 	SESSION.CurrentSeason.Code		= qCurrSeason.seasonCode;
			}
			</cfscript>
		</cflock>
	</cfif>
	
</cffunction>

<cffunction name="onRequest">
    <cfargument name = "targetPage" type="String" required=true/>
	<cfif StructKeyExists(URL,"resetit") AND url.resetit EQ "doit">
		<cfset this.onApplicationStart()>
	</cfif>
	<cfinclude template="cfudfs.cfm">
    <cfsavecontent variable="content">
        <cfinclude template=#Arguments.targetPage#>
    </cfsavecontent>
    <!--- This is a minimal example of an onRequest filter. --->
    <cfoutput>
        #content#
    </cfoutput>
</cffunction>
<cffunction name="onMissingTemplate" returnType="boolean">
  <cfargument type="string" name="targetPage" required=true/>
  <cftry>
    <!--- set response to 404 --->
    <cfheader statusCode = "404" statusText = "Page Not Found">
    <cflocation url="errorPage.cfm" addToken="false">
    <!--- return true to prevent the default ColdFusion error handler from running --->
    <cfreturn true />
    <cfcatch>
      <cfreturn false />
    </cfcatch>
  </cftry>
  <cfreturn />
</cffunction>
<cffunction name="onError" output="true">
    <cfargument name="Exception" required=true/>
    <cfargument type="String" name = "EventName" required=true/>
    <!--- Log all errors. --->
    <!---<cflog file="#This.Name#" type="error" text="Event Name: #Eventname#">
    <cflog file="#This.Name#" type="error" text="Message: #exception.message#">
    <!--- Some exceptions, including server-side validation errors, do not
             generate a rootcause structure. --->
    <cfif isdefined("exception.rootcause")>
        <cflog file="#This.Name#" type="error" 
            text="Root Cause Message: #exception.rootcause.message#">
    </cfif>    
    <!--- Display an error message if there is a page context. --->
    <cfif NOT (Arguments.EventName IS onSessionEnd) OR 
            (Arguments.EventName IS onApplicationEnd)>
        <cfoutput>
            <h2>An unexpected error occurred.</h2>
            <p>Please provide the following information to technical support:</p>
            <p>Error Event: #EventName#</p>
            <p>Error details:<br>
            <cfdump var=#exception#></p>
        </cfoutput>
    </cfif> --->

    <!--- <cfdump var="#CGI#">
    <cfdump var="#arguments#">
    <cfdump var="#variables#"> --->

    <!--- <cfdump var="#Exception#">
    <cfdump var="#Session#">
    <cfdump var="#CGI#">

    <cfoutput>File Name = #CGI.SCRIPT_NAME#</cfoutput><br><br>
    <cfoutput>Error Message (message) = #Exception.cause.message#</cfoutput><br><br>
    <cfoutput>Error Message (detail) = #Exception.cause.detail#</cfoutput><br><br>
    <cfoutput>Error ui page = #Exception.cause.tagcontext[1].template#</cfoutput><br><br>
    <cfoutput>Error Line number = #Exception.cause.tagcontext[1].line#</cfoutput><br><br>
    <cfoutput>Error Function = #Exception.cause.tagcontext[1].raw_trace#</cfoutput><br><br>
    <cfoutput>URL = #CGI.HTTP_HOST##CGI.HTTP_URL#</cfoutput> --->

<!--- --->   
    <cfinclude template="/app_error_exception.cfm">
    <cfinclude template="/errorPage.cfm">  

    <!--- <cfabort> --->
 </cffunction>
	 
</cfcomponent>

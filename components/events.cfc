

<cfcomponent>
<CFSET DSN = SESSION.DSN>

<!--- =================================================================== --->
<cffunction name="getEventDates" access="public" returntype="query">
	<!--- --------
		08/14/08 - AArnone - New function: retruns distinct event dates
	----- --->
	<cfargument name="lTypes" type="string" required="no" default="" >

	<CFIF listLen(ARGUMENTS.lTypes)>
		<CFSET typeIN = listQualify(ARGUMENTS.lTypes,"'",",","ALL")>
	</CFIF>	
	<CFQUERY name="qEventDates" datasource="#VARIABLES.DSN#">
		Select EventDate, event_id,eventTime, Description, location, Month(EventDate) as eMonth, Year(EventDate) as eYear
		  from TBL_EVENTS
		 Where Type in (#preservesinglequotes(typeIN)#)
		 ORDER BY EventDate 
	</CFQUERY>
	
	<cfreturn qEventDates>
</cffunction>
	

<!--- =================================================================== --->
<cffunction name="getEvents" access="public" returntype="query">
	<!--- --------
		08/15/08 - AArnone - New function: retruns events based on dates
	----- --->
	<cfargument name="dateFrom" type="date" required="yes">
	<cfargument name="dateTo"   type="date" required="yes">

	<CFQUERY name="qGetEvents" datasource="#VARIABLES.DSN#">
		Select EVENT_ID, eventDate, eventTime, Type, description, location
		  from TBL_EVENTS
		 Where Type in ('C','B') 
		   and eventdate between <cfqueryparam cfsqltype="CF_SQL_DATE" value="#ARGUMENTS.DateFrom#">
		   				     and <cfqueryparam cfsqltype="CF_SQL_DATE" value="#ARGUMENTS.DateTo#">
		 Order by EventDate, EventTime
	</CFQUERY>
	
	<cfreturn qGetEvents>
</cffunction>

	



</cfcomponent>
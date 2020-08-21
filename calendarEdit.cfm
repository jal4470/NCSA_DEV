<!--- 
	FileName:	calendarAddEvent.cfm
	Created on: 12/01/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Calendar Add Event</H1>
<!--- <h2>For #URL.d# </h2> --->

<cfif isDefined("FORM.BACK")>
	<cflocation url="CalendarManage.cfm">
</cfif>

<cfif isDefined("FORM.DELETE") AND FORM.MODE EQ "DELETE">
	<!--- DELETE THIS ONE... --->   
	<CFQUERY name="qDeleteEvent" datasource="#SESSION.DSN#">
		Delete from TBL_Events Where EVENT_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.EVENTID#">
	</CFQUERY>	
	<cflocation url="CalendarManage.cfm">
</cfif>

<cfset mode = "">
<cfset eventDate = "">
<cfset EventTime = "">
<cfset location  = "">
<cfset eventdescription = "">

<CFIF isDefined("URL.EID") AND isNumeric(URL.EID)>
	<cfset eventID = URL.EID>
<CFELSEIF isDefined("FORM.EVENTID") AND isNumeric(FORM.EVENTID)>
	<cfset eventID = FORM.EVENTID>
<CFELSE>
	<cfset eventID = 0>
</CFIF>

<CFIF isDefined("URL.D") AND isDate(URL.D)>
	<cfset eventDate = URL.D>
<CFELSEIF isDefined("FORM.EVENTDATE") AND isDate(FORM.EVENTDATE)>
	<cfset eventDate = FORM.EVENTDATE>
</CFIF>

<CFIF eventID GT 0>
	<!--- we have an EVENT to EDIT --->
	<CFQUERY name="qGetEvent" datasource="#SESSION.DSN#">
		Select EVENT_ID, eventDate, eventTime, Type, description, location
		  from TBL_EVENTS
		 Where EVENT_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.eventID#">
	</CFQUERY>
	
	<cfif qGetEvent.recordCount>
		<cfset mode = "edit">
		<cfset eventDate = dateFormat(qGetEvent.eventDate,"mm/dd/yyyy")>
		<cfset EventTime = timeFormat(qGetEvent.eventTime,"hh:mm tt") >
		<cfset location  = qGetEvent.location >
		<cfset eventdescription = qGetEvent.description >
	</cfif>
<cfelseif isDate(VARIABLES.eventDate)>
	<!--- we have a DATE to enter an EVENT into --->
	<cfset mode = "add">
	<cfset eventDate = dateFormat(VARIABLES.eventDate,"mm/dd/yyyy")>
	<cfset EventTime = "" >
	<cfset location  = "" >
	<cfset eventdescription = "" >
</CFIF>




<cfset swErr = false>
<cfset msg = "">
<cfif isDefined("FORM.UPDATE") OR isDefined("FORM.INSERT")>
	<cfset eventDate = FORM.EVENTDATE>
	<cfset location = trim(FORM.Location) >
	<cfset eventID = FORM.EVENTID >
	<CFIF len(trim(FORM.EventHour)) EQ 0 OR len(trim(FORM.EventMinute)) EQ 0>
		<cfset swErr = true>
		<cfset msg = msg & "Event Time is not valid.<br>">
	<CFELSE>
		<CFSET EventTime = FORM.EventHour & ":" & FORM.EventMinute & " " & FORM.EventMeridian>
	</CFIF>
	<CFIF len(trim(FORM.Description)) EQ 0>
		<cfset swErr = true>
		<cfset msg = msg & "Event Description/Msg is required.<br>">
	<CFELSE>
		<cfset eventdescription  = trim(FORM.Description) >
	</CFIF>
	
	<cfif NOT swErr>
		<!--- form Passed edit --->
		<cfif isDefined("FORM.UPDATE")>
			<!--- UPDATE THIS ONE..... --->
			<CFQUERY name="qGetEvent" datasource="#SESSION.DSN#">
				Update TBL_Events
				   set Description = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.eventdescription#">
					 , Eventdate   = <cfqueryparam cfsqltype="CF_SQL_DATE" 	  value="#VARIABLES.EventDate#">
					 , EventTime   = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.EventTime#">
					 , Location	   = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.Location#">
					 , Type		   = 'C'
				 Where EVENT_ID =  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.eventID#">
			</CFQUERY>
		<cfelseif isDefined("FORM.INSERT")>
			<!--- insert THIS ONE.....  --->
			<CFQUERY name="qGetEvent" datasource="#SESSION.DSN#">
				Insert into TBL_Events
					(EventDate, EventTime, Description, Location, Type)
				values
					( <cfqueryparam cfsqltype="CF_SQL_DATE"    value="#VARIABLES.EventDate#">
					, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.EventTime#">
					, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.eventdescription#">
					, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.Location#">
					,'C'
					)
			</CFQUERY>
		</cfif>
		<cflocation url="CalendarManage.cfm">
	</cfif>


</cfif>









<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="stTimeParams">
	<cfinvokeargument name="listType" value="DDHHMMTT"> 
</cfinvoke> 

<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">

<FORM name="CalendarManage" action="calendarEdit.cfm" method="post"> 
<input type="Hidden" name="mode"      value="#VARIABLES.mode#">
<input type="Hidden" name="eventID"   value="#VARIABLES.eventID#">
<input type="Hidden" name="eventDate" value="#VARIABLES.eventDate#">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<cfif len(trim(VARIABLES.msg))>
		<TR><TD colspan="2" align="center">
				<span class="red">#VARIABLES.msg#</span>
			</TD>
		</TR>
	</cfif>

	
	<tr class="tblHeading">
		<TD colspan="2">#dateFormat(VARIABLES.eventDate,"full")#</TD>
	</tr>
	<TR><TD width="20%" class="tdUnderLine" align="right">
			#required# <b>Event Date</b>
		</TD>
		<TD width="80%" class="tdUnderLine" align="LEFT">
			#dateFormat(VARIABLES.eventDate,"mm/dd/yyyy")#
		</TD>
	</TR>
	<TR><TD class="tdUnderLine" align="right">
			#required# <b>Time</b>
		</TD>
		<TD class="tdUnderLine">
			<cfset HH = listfirst(VARIABLES.EventTime,":")>
			<cfset MM = listlast( listfirst(VARIABLES.EventTime," ") ,":")>
			<cfset TT = listlast(VARIABLES.EventTime," ")>
			<SELECT name="EventHour"> 
				<OPTION value="" selected>HR</OPTION>
			    <CFLOOP list="#stTimeParams.hour#" index="iHr">
					<OPTION value="#iHr#" <CFIF HH EQ iHr>selected</CFIF> >#iHr#</OPTION>
				</CFLOOP>
			</SELECT>
			<SELECT name="EventMinute"> 
				<OPTION value="" selected>MN</OPTION>
				<CFLOOP list="#stTimeParams.min#" index="iMn">
					<OPTION value="#iMn#" <CFIF MM EQ iMn>selected</CFIF> >#iMn#</OPTION>
				</CFLOOP>
			</SELECT>
			<SELECT name="EventMeridian">
				<CFLOOP list="#stTimeParams.tt#" index="iTT">
					<OPTION value="#iTT#" <CFIF TT EQ iTT>selected</CFIF> >#iTT#</OPTION>
				</CFLOOP>
			</SELECT>  
		</TD>
	</TR>
	<TR><TD class="tdUnderLine" align="right">
			<b>Location</b>
		</TD>
		<TD class="tdUnderLine">
			<INPUT name="Location" value= "#VARIABLES.location#">
		</TD>
	</TR>
	<TR><TD class="tdUnderLine" align="right">
			#required# <b>Description/Msg</b>
		</TD>
		<TD class="tdUnderLine">
			<TEXTAREA name="Description" rows=10  cols=50>#VARIABLES.eventdescription#</TEXTAREA>
		</TD>
	</TR>
	<TR><TD colspan="2" align="center">
		<CFIF mode EQ "add">
			<INPUT type="submit" name="insert" value="Add Event" >
		</CFIF>
		<CFIF mode EQ "edit">
			<INPUT type="submit" name="update" value="Save Changes" >
			<INPUT type="submit" name="delete" value="Delete"  onclick="GoDelete()"	>
		</CFIF>
		<INPUT type="submit" name="back" value="Back" >
	</TD>
  </TR>
</TABLE>
</FORM>


<script language="javascript">
function GoDelete()
{	var DeleteYN;
	DeleteYN = confirm ("Are you sure To DELETE the Calendar Event?");
	if (DeleteYN) 
	{	self.document.CalendarManage.mode.value	= "DELETE";
		self.document.CalendarManage.action		= "calendarEdit.cfm";
		self.document.CalendarManage.submit();
	}
}
</script>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">

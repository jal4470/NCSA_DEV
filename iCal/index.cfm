<cfif isdefined("form.sch_gm_away_team") and len(trim(form.sch_gm_away_team))>
  <cfset awayTeam = form.sch_gm_away_team>
<cfelse>
  <cfset awayTeam = "">
</cfif>

<cfif isdefined("form.sch_gm_home_team") and len(trim(form.sch_gm_home_team))>
  <cfset homeTeam = form.sch_gm_home_team>
<cfelse>
  <cfset homeTeam = "">
</cfif>

<cfif isdefined("form.sch_gm_field") and len(trim(form.sch_gm_field))>
  <cfset location = form.sch_gm_field>
<cfelse>
  <cfset location = "">
</cfif>

<cfif isdefined("form.sch_gm_date") and len(trim(form.sch_gm_date))>
  <cfset gameDate = form.sch_gm_date>
<cfelse>
  <cfset gameDate = "">
</cfif>

<cfif isdefined("form.sch_gm_time") and len(trim(form.sch_gm_time))>
  <cfset gameTime = form.sch_gm_time>
<cfelse>
  <cfset gameTime = "">
</cfif>

<cfif isdefined("form.sch_gm_id") and len(trim(form.sch_gm_id))>
  <cfset gameID = form.sch_gm_id>
<cfelse>
  <cfset gameID = "">
</cfif>

<cfif isdefined("form.sch_fld_id") and len(trim(form.sch_fld_id))>
  <cfset fieldID = form.sch_fld_id>
<cfelse>
  <cfset fieldID = 0>
</cfif>
<cfif NOT isdefined("fieldID") and NOT isNumeric(fieldID)>
	<cfset fieldID = 0>
</cfif>

<cfif isdefined("form.user_email") and len(trim(form.user_email))>
  <cfset userEmail = form.user_email>
</cfif>
<cfset icalInstructions = "NOTE:  The calendar APP for each device differs in functionality for adding the attached event to your calendar.  For example, in Outlook, click on the attachment and save it to your Outlook calendar.  Follow the instructions for your calendar APP in order to add the event to your calendar. Android devices mainly support Google calendar, adding events to other calendars may not work properly. IOS devices will mainly work with the local calendar, an iCloud based calendar update may fail.">
<cfset startTime = CreateDateTime(year(gameDate), month(gameDate), day(gameDate), hour(gameTime), minute(gameTime))>
<cfset startTime = DATEFORMAT(startTime,"mm/dd/yyyy") & " " & TIMEFORMAT(startTime,"hh:mm tt")>
<cfset endTime = dateAdd("h", 2, startTime)>
<cfset endTime = DATEFORMAT(endTime,"mm/dd/yyyy") & " " & TIMEFORMAT(endTime,"hh:mm tt")>

<!--- Retrieve Field Address --->
<cfinvoke component="#SESSION.sitevars.cfcPath#field" method="getDirections" returnvariable="fieldAddress">
  <cfinvokeargument name="fieldID" value="#fieldID#">
</cfinvoke> 

<cfset gMapsLink = "">
<cfset address = "">

<CFIF fieldAddress.RECORDCOUNT>
  <cfscript>
    MQAddress = URLEncodedFormat(Trim(fieldAddress.Address));
    MQCity	  = URLEncodedFormat(Trim(fieldAddress.City));
    MQState	  = URLEncodedFormat(Trim(fieldAddress.State));
    MQZip	  = URLEncodedFormat(Trim(fieldAddress.ZIPCODE));
    gMapsLink = "http://maps.google.com/maps?f=q&hl=en&geocode=&q="  & Trim(MQAddress) & "+" & Trim(MQCity) & "+" & Trim(MQState) & "+" & Trim(MQZip);
  </cfscript>

  <cfset address = fieldAddress.ADDRESS & ', ' & fieldAddress.CITY & ', ' & fieldAddress.STATE & ' ' & fieldAddress.ZIPCODE>
</CFIF>

<!--- Fall back to club field name if no address --->
<cfif trim(address) EQ "">
  <cfset address = location>
</cfif>

<cfinclude template="iCalCP.cfm">

<cfsavecontent variable="emailContent">
<cfoutput>
<div class="email_html" style="font-family: Arial, Tahoma, sans-serif;">
  <h2 style="text-align:center;font-size:22px;font-weight:bold;color:##444;margin:0;padding:0;">#awayTeam# &##64; #homeTeam#</h2>
  <h4 style="padding-bottom: 15px; margin-bottom: 15px; border-bottom: 3px solid ##ebebeb;text-align:center;font-size:16px;color: ##555;font-weight:normal;line-height:1.5;text-transform:uppercase;">#DateFormat(gameDate, "dddd, mmmm dd, yyyy")# &##64; #TimeFormat(startTime, "hh:mm TT")#</h4>

  <div class="field-directions" style="padding-bottom: 15px; margin-bottom: 15px; border-bottom: 3px solid ##ebebeb;">
   <p style="font-size:14px;color:##414141;line-height:1.5;">
      <strong>Field:</strong> #location# 
    </p>
    <p style="font-size:14px;color:##414141;line-height:1.5;">
      <strong>Location:</strong> #address# <cfif isDefined("gMapsLink") and len(trim(gMapsLink))>&nbsp;&nbsp;[<a href="#gMapsLink#" style="text-decoration:none;color:##10069A;">Open in Google Maps</a>]</cfif>
    </p>

    <cfif isDefined("fieldAddress.directions") and len(trim(fieldAddress.directions))>
      <p style="font-size:14px;color:##414141;line-height:1.5;"><strong>Directions:</strong><br> #fieldAddress.directions#</p>
    </cfif>
  </div>
  <div class="ical-instructions" style="padding-bottom: 15px; margin-bottom: 15px; border-bottom: 3px solid ##ebebeb;">
    <p style="font-size:14px;color:##414141;line-height:1.5;">
     #replace(icalInstructions,"NOTE:","<strong>NOTE:</strong>")#
    </p>
  </div>
</div>
</cfoutput>
</cfsavecontent>

<cfsavecontent variable="calendarContent">
<cfoutput>
#awayTeam# @ #homeTeam# \n #DateFormat(gameDate, "dddd, mmmm dd, yyyy")# @ #TimeFormat(startTime, "hh:mm TT")#\n\n ==========================================================================\n\nField: #location# \n\nLocation: #address#\n\n<cfif isDefined("gMapsLink") and len(trim(gMapsLink))>Google Maps Link: #gMapsLink# \n\n</cfif>========================================================================== \n\n<cfif isDefined("fieldAddress.directions") and len(trim(fieldAddress.directions))> Directions:\n #fieldAddress.directions# \n\n ========================================================================== \n\n</cfif>#trim(icalInstructions)#
</cfoutput>
</cfsavecontent>

<cfscript>
eventStr = StructNew();
eventStr.gameID = #gameID#;
eventStr.organizerName = #homeTeam#;
eventStr.organizerEmail = "do-not-reply@ncsanj.com";
eventStr.startTime = #startTime#;
eventStr.endTime = #endTime#;
eventStr.fileName = #awayTeam# & "--at--" & #homeTeam#;
eventStr.location = #address#;
eventStr.subject = #awayTeam# & " @ " & #homeTeam#;
eventStr.description = #trim(calendarContent)#;
</cfscript>

<!--- <cfdump var="#eventStr#">
<cfabort> --->

<cfmail from="do-not-reply@ncsanj.com" to="#userEmail#" subject="NCSA Game Schedule Event" type="html">
  <cfmailparam file="#StructFind(eventStr, 'fileName')#.ics" content="#iCalCP(eventStr)#" disposition="attachment" type="text/calendar" />
  #emailContent#
</cfmail> 

<!--- initialize data --->
<cfset data = {}>
<cfset data.STATUS = "Success">
<cfset data = serializeJSON(data)>
<cfoutput>#data#</cfoutput>
<cfabort>
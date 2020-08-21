<!---
This library is part of the Common Function Library Project. An open source
	collection of UDF libraries designed for ColdFusion 5.0 and higher. For more information,
	please see the web site at:

		http://www.cflib.org

	Warning:
	You may not need all the functions in this library. If speed
	is _extremely_ important, you may want to consider deleting
	functions you do not plan on using. Normally you should not
	have to worry about the size of the library.

	License:
	This code may be used freely.
	You may modify this code as you see fit, however, this header, and the header
	for the functions must remain intact.

	This code is provided as is.  We make no warranty or guarantee.  Use of this code is at your own risk.
--->

<cfscript>
/**
 * Pass a formatted structure containing the event properties and get back a string in the iCalendar format (correctly offset for daylight savings time in U.S.) that can be saved to a file or returned to the browser with MIME type=&quot;text/calendar&quot;.
 * v2 updated by Dan Russel
 * 
 * @param stEvent 	 Structure of data for the event. (Required)
 * @return Returns a string. 
 * @author Troy Pullis (tpullis@yahoo.com) 
 * @version 2, December 18, 2008 
 */
function iCalCP(stEvent) {
	var vCal = "";
	var CRLF=chr(13)&chr(10);
	var date_now = Now();
	
	if (NOT IsDefined("stEvent.organizerName"))
		stEvent.organizerName = "Organizer Name";
		
	if (NOT IsDefined("stEvent.organizerEmail"))
		stEvent.organizerEmail = "Organizer_Name@CFLIB.ORG";
				
	if (NOT IsDefined("stEvent.subject"))
		stEvent.subject = "Event subject goes here";
		
	if (NOT IsDefined("stEvent.location"))
		stEvent.location = "Event location goes here";
	
	if (NOT IsDefined("stEvent.description"))
		stEvent.description = "Event description goes here\n---------------------------\nProvide the complete event details\n\nUse backslash+n sequences for newlines.";
		
	if (NOT IsDefined("stEvent.startTime"))  // This value must be in Eastern time!!!
		stEvent.startTime = ParseDateTime("3/21/2008 14:30");  // Example start time is 21-March-2008 2:30 PM Eastern
	
	if (NOT IsDefined("stEvent.endTime"))
		stEvent.endTime = ParseDateTime("3/21/2008 15:30");  // Example end time is 21-March-2008 3:30 PM Eastern
		
	if (NOT IsDefined("stEvent.priority"))
		stEvent.priority = "1";
	
	vCal = vCal & "BEGIN:VCALENDAR" & CRLF;
	vCal = vCal &  "PRODID:-//Microsoft Corporation//Outlook 12.0 MIMEDIR//EN" & CRLF;
	vCal = vCal &  "VERSION:2.0" & CRLF;
	vCal = vCal &  "METHOD:PUBLISH" & CRLF;
	vCal = vCal &  "X-MS-OLK-FORCEINSPECTOROPEN:TRUE" & CRLF;
	vCal = vCal &  "BEGIN:VEVENT" & CRLF;
	vCal = vCal &  "ATTENDEE;CN=" & stEvent.organizerName & ";mailto:" & stEvent.organizerEmail &  CRLF;
	vCal = vCal &  "CLASS:PUBLIC" & CRLF;
	vCal = vCal &  "CREATED:" & DateFormat(date_now,"yyyymmdd") & "T" & 
			TimeFormat(date_now, "HHmmss") & CRLF;
	vCal = vCal &  "DESCRIPTION:" & stEvent.description & CRLF;
	vCal = vCal & "ATTACH;FMTTYPE=text/plain;" & CRLF;
	vCal = vCal & "DTEND;TZID=Eastern Time:" & 
			DateFormat(stEvent.endTime,"yyyymmdd") & "T" & 
			TimeFormat(stEvent.endTime, "HHmmss") & CRLF;
	vCal = vCal & "DTSTAMP:" & 
			DateFormat(date_now,"yyyymmdd") & "T" & 
			TimeFormat(date_now, "HHmmss") & CRLF;
	vCal = vCal & "DTSTART;TZID=Eastern Time:" & 
			DateFormat(stEvent.startTime,"yyyymmdd") & "T" & 
			TimeFormat(stEvent.startTime, "HHmmss") & CRLF;
	vCal = vCal & "SUMMARY:#stEvent.subject#" & CRLF;
	vCal = vCal & "LOCATION:#stEvent.location#" & CRLF;
	vCal = vCal & "PRIORITY:#stEvent.priority#" & CRLF;
	vCal = vCal & "ORGANIZER;CN=#stEvent.organizerName#:MAILTO:#stEvent.organizerEmail#" & CRLF;
	vCal = vCal & "LAST-MODIFIED:" & DateFormat(date_now,"yyyymmdd") & "T" & 
			TimeFormat(date_now, "HHmmss") & CRLF;
	vCal = vCal & "TRANSP:OPAQUE" & CRLF;
	// vCal =  vCal & "UID:#date_now.getTime()#.CFLIB.ORG" & CRLF; 
	vCal = vCal & "UID:#stEvent.gameID#@ncsanj.com" & CRLF;
	vCal = vCal & "CLASS:PUBLIC" & CRLF;
	vCal = vCal & "BEGIN:VALARM" & CRLF;
	vCal = vCal & "TRIGGER:-PT30M" & CRLF;	
	vCal = vCal & "ACTION:DISPLAY" & CRLF;
	vCal = vCal & "END:VALARM" & CRLF;
	vCal = vCal & "END:VEVENT" & CRLF;
	vCal = vCal & "END:VCALENDAR";
	return Trim(vCal);		
}
</cfscript>







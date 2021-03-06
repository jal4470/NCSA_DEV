<cfsilent>
<cfinvoke component="components.events" method="getEventDates" returnvariable="qDates">
	<cfinvokeargument name="lTypes" value="C,B">
</cfinvoke>
<cfif isdefined("form.DateVar")> 
<cfswitch expression="#Form.DateVar#">
	<cfcase value="<<"><cfset YearVar = Form.eYear- 1><cfset MonthVar = Form.eMonth></cfcase>
	<cfcase value=">>"><cfset YearVar = Form.eYear + 1><cfset MonthVar = Form.eMonth></cfcase>
	<cfcase value="<"><cfif form.eMonth eq 1><cfset MonthVar=12><cfset YearVar = Form.eYear-1><cfelse><cfset MonthVar = Form.eMonth - 1><cfset YearVar = Form.eYear></cfif></cfcase>
	<cfcase value=">"><cfif form.eMonth eq 12><cfset MonthVar=1><cfset YearVar = Form.eYear+1><cfelse><cfset MonthVar = Form.eMonth +1><cfset YearVar = Form.eYear></cfif></cfcase>
<cfdefaultcase> 
	<cfset MonthVar=datepart("M",now())>
	<cfset YearVar = datepart("YYYY", now())>
</cfdefaultcase>
</cfswitch>
<cfelse>
	<cfset MonthVar=datepart("M",now())>
	<cfset YearVar = datepart("YYYY", now())>
</cfif> 


	<cfquery name="qEvent" dbtype="query">
		SELECT distinct EventDate as date_started, eventdate as date_ended, event_id as id, Description, Location
		  from qDates
		  where eMonth=  #MonthVar# and eYear = #YearVar#
		ORDER BY EventDate desc
	</cfquery>


<!---
	Get the month that we are going to be showing the
	events for (April 2007).
--->


<cfif not isdefined("MonthVar") and not isdefined("YearVar")>
	<cfset dtThisMonth = CreateDate( datepart('YYYY', now()),  datepart('M', now()),  1) />
<cfelse>
	<cfset dtThisMonth = CreateDate( YearVar,  MonthVar,  1) />
 </cfif>
<!---
	Because the calendar month doesn't just show our
	month - it may also show the end of last month and
	the beginning of next month - we need to figure out
	the start and end of the "calendar" display month,
	not just this month.
--->
<cfset dtMonthStart = (dtThisMonth + 1 - DayOfWeek( dtThisMonth )) />
 
<!--- Get the last day of the calendar display month. --->
<cfset dtMonthEnd = (dtThisMonth - 1 + DaysInMonth( dtThisMonth )) />
<cfset dtMonthEnd = (dtMonthEnd + (7 - DayOfWeek( dtMonthEnd ))) />
 
 
<!---
	ASSERT: At this point, not only do we know what month
	we are going to display, we also know the first and last
	calendar days that are going to display. We do not need
	to know what numeric month those actually fall on.
--->
 
 
<!---
	Create an object to hold the dates that we want to
	show on the calendar. Since our calendar view doesn't
	have any real detail other than event existence, we
	don't have to care about event details. We will use
	this struct to create an index of date DAYS only.
--->
<cfset objEvents = StructNew() />
 
 
<!---
	Let's populate the event struct. Here, we have to
	be careful not just about single day events but also
	multi day events which have to show up more than once
	on the calendar.
<cfdump var="#qEvent#">--->

<cfloop query="qEvent">
 
	<!---
		For each event, we are going to loop over all the
		days between the start date and the end date. Each
		day within that date range is going to be indexed
		in our event index.
 
		When we are getting the date of the event, remember
		that these dates might have associated times. We
		don't care about the time, we only care about the
		day. Therefore, when we grab the date, we are Fixing
		the value. This will strip out the time and convert
		the date to an integer.
	--->
	<cfset intDateFrom = Fix( qEvent.date_started ) />
	<cfset intDateTo = Fix( qEvent.date_ended ) />
 
 
	<!---
		Loop over all the dates between our start date and
		end date. Be careful though, we don't care about days
		that will NOT show up on our calendar. Therefore,
		using our are Month Start and Month End values found
		above, we can Min/Max our loop.
 
		When looping, increment the index by one. This will
		add a single day for each loop iteration.
	--->
	<cfloop
		index="intDate"
		from="#Max( intDateFrom, dtMonthStart )#"
		to="#Min( intDateTo, dtMonthEnd )#"
		step="1">
 
		<!---
			Index this date. We don't care if two different
			event dates overwrite each other so long as at
			least one of the events registers this date.
		--->
		<cfset objEvents[intDate] = structNew()>
		<cfset objEvents[intDate].ID = qEvent.id />
 		<cfset objEvents[intDate].Location = qEvent.location />
		<cfset objEvents[intDate].Description= qEvent.Description />
	</cfloop>
 
</cfloop>
</cfsilent> 
<cfoutput> 
<cfset mid = 5> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<div id="contentText">


<!---  	<style type="text/css">
 
		body,
		td {
			font: 11px verdana ; height:100px;
			}
 			th {
			font: 11px verdana ; height:50px;
			}
		table.month {}
 
		table.month tr.dayheader {
			background-color: ##3399CC ;
			border: 1px ##cccccc solid ;
			border-bottom-width: 2px ;
			color: ##FFFFFF ;
			font-weight: bold ;
			padding: 5px 0px 5px 0px ;
			text-align: center ;
			}
 
		table.month tr.day td {
			background-color: ##ffffff;
			border: 1px solid ##999999 ;
			color: ##000000 ;
			padding: 5px 0px 5px 0px ;
			text-align: center ;
			}
 
		table.month tr.day td.othermonth {
			background-color: ##fbfbfb ;
			color: ##CCCCCC ;
			}
 
		table.month tr.day td.event {
			background-color: ##CCE4F1 ;
			color: ##000000 ;
			font-weight: bold ;
			}
 
	</style>  --->



	<h2 align="center">
		
	
    <form action="#cgi.script_name#" method="post">
		<input type="hidden" name="eMonth" value="#monthVar#">
		<input type="hidden" name="eYear" value="#yearVar#">
		<input type="submit" name="DateVar" value="<<">
		<input type="submit" name="DateVar" value="<">
		#DateFormat( dtThisMonth, "mmmm yyyy" )#
		<input type="submit" name="DateVar" value=">">
		<input type="submit" name="DateVar" value=">>">
	</form>
	</h2>
	<table cellspacing="2" class="month">
	<colgroup>
		<col width="12%" />
		<col width="15%" />
		<col width="15%" />
		<col width="15%" />
		<col width="15%" />
		<col width="15%" />
		<col width="13%" />
	</colgroup>
	<tr class="dayheader">
		<th>
			Sun
		</th>
		<th>
			Mon
		</th>
		<th>
			Tus
		</th>
		<th>
			Wed
		</th>
		<th>
			Thr
		</th>
		<th>
			Fri
		</th>
		<th>
			Sat
		</th>
	</tr>
	<tr class="day">
 
		<!---
			Now, we need to loop over the days in the
			calendar display month. We can use the start
			and end days we found above. When looping, add
			one to the index. This will add a single day
			per loop iteration.
		--->
		<cfloop
			index="intDate"
			from="#dtMonthStart#"
			to="#dtMonthEnd#"
			step="1">
 
 
			<!---
				Check to see which classes we are going to
				need to assign to this day. We are going to
				use one class for month (this vs. other) and
				one for whether or not there is an event.
			--->
			<cfif (Month( intDate ) EQ Month( dtThisMonth))>
				<cfset strClass = "thismonth" />	
			
			<cfelse>
				<cfset strClass = "othermonth" />
			</cfif>
 				<cfif StructKeyExists( objEvents, intDate )>
					<cfset strClass = (strClass & " event") />
				</cfif>
			<!---
				Check to see if there is an event scheduled
				on this day. We can figure this out by checking
				for this date in the event index.
			--->

		
 
			<td class="#strClass#">
				#Day( intDate )#<br/>
				<cfif structKeyExists(objEvents, intDate)>
				#objEvents[intDate].Description#<br/>
				#objEvents[intDate].Location#
				</cfif>
			</td>
 
 
			<!---
				Check to see if we need to start a new row.
				We will need to do this after every Saturday
				UNLESS we are at the end of our loop.
			--->
			<cfif (
				(DayOfWeek( intDate ) EQ 7) AND
				(intDate LT dtMonthEnd)
				)>
				</tr>
				<tr class="day">
			</cfif>
 
		</cfloop>
	</tr>
	</table>
 

</div>
<cfinclude template="_footer.cfm">
</cfoutput>
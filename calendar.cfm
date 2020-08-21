<!------------------------------------->
<!---  NCSA         	--->
<!---  event calendar page		   			--->
<!------------------------------------->
<!---  Created:  08.17.2018 by		--->
<!---	         A Silverstein			--->
<!---  Last Modified: 				--->
<!---
MODIFICATIONS 
A Silvertein 8/17/18
- Made calendar background white and gave it a border
- Added .cMonth and .cYear classes to the calendar button inputs
- Added styling for .cMonth and .cYear classes
- Added the id #calendarHead to the h1 tag on the calendar
- Restyled #calendarHead
- Updated styles for the .dayheader on calendar (the background is now gray/ changed border radius)
- Updated styles for the .othermonth and .thismonth on the calendar
- Added media query to #calendarHead so that it becomes smaller when the screen shrinks.
- Changed bordercolor of .dayheader to gray.

A Silverstein 8/20/2018
- Altered the media query for the month header of the calendar so that it doesn't get too small. 
- Added script tag at bottom of file
- Added a self executing function to put the javascript inside of
- Added .selectedDate css class with a blue background color
- Created a javascript function for adding selectedDate class to date selected by user
- Added callOut box to the coldfusion and gave it a class of more_info
- Created a javascript function for hiding and showing the callOut box based on whether a date is selected.
- Changed the jquery function for the callout box. It is now toggling the class active when a date is clicked. 

A Silverstein 8/21/2018
- Changed the class name of the call out to .callOut
- Added css for .callOut class
- Added javascript functionality so that the callOut's location is based on where the user clicks inside of the calendar. 
- Moved the callOut right above the footer

- Made it so that modal is only visible when the viewport is a max width of 767px
- Made modal take up full width and height of screen
- Added .calendarInfo class to information being appended to modal
- Added close icon to modal 
- Added javascript functionality so that clicking the close icon closes the modal
- Added br tags before and after .calendarInfo items being appended to the modal

-Added info icon
-Added css to show calendar text and hide info icon when the viewport is bigger than 767px
-Added date data attribute to calendarinfo and appended it to the modal
-Set max width and max height in media query and outside of media query for calendarInfo
-Put the info icon inside of caledarInfo so that it is clickable		

A Silverstein 8/22/2018
- Took #CalendarHead outside of the table that holds the calendar input buttons so that the CalendarHead does not distort the placement of the calendar buttons as the screen gets smaller 

A Silverstein 8/23/2018
Changed the background color of table.month tr.day td.event to #EEEEEE
						--->
<!------------------------------------->


<cfsilent>

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
<cfinvoke component="components.events" method="getEventDates" returnvariable="qDates">
	<cfinvokeargument name="lTypes" value="C,B">
</cfinvoke>


	<cfquery name="qEvent" dbtype="query">
		SELECT distinct EventDate as date_started, eventdate as date_ended,eventTime, event_id as id, Description, Location
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
		<cfset objEvents[intDate].EventTime= qEvent.eventTime />
	</cfloop>
 
</cfloop>
</cfsilent> 
<cfoutput> 

<cfset mid = 5> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
 	<style type="text/css">

 
		##contentText {
			border:2px solid ##D1D1D1;
			background: white;
		}

		.cMonth{
			 height:15px;
			 border-radius: 2px 10px;
			 background-color:##9A8206;
			 color:white;
			 border-color: ##726102;
			 cursor: pointer;
			 padding-bottom:15px;
		}

		.cYear{
			 height:15px;
			 border-radius: 2px 10px;
			 background-color:##10069A;
			 color:white;
			 border-color:##070252;
			 cursor: pointer;
			 padding-bottom:15px;
		}

		.selectedDate{
		background: rgba(96,109,188,.15);
		}

		##calendarHead{
			color: ##000;
	  		font-family: 'Alegreya', Georgia, serif;
	  		font-size: 30px;
		}
		.callOut{
		display:none;
		}

		.calendarInfo{
			max-width: 120px
			max-height: 150px;
		}
		
		.calendarInfo2 {
				visibility:visible;
			}
		.calendarInfo3 {
				visibility:visible;
			}	
		
		.infoIcon{
			visibility: hidden;
		}

		@media screen and (max-width: 767px) {

		.calendarInfo{
			margin:auto;
			cursor:pointer;
			max-width: 20px;
			max-height: 40px;
		}	

		.divide{
			visibility:hidden;
		}

		.calendarInfo2{
				visibility:hidden;
			}
		.calendarInfo3{
				visibility:hidden;
			}	
		
		.infoIcon{

			visibility: visible;
			margin:auto auto;
		}
			.closeCo{
			top:0px;
			float:right;
			display: block;
			cursor: pointer;
			}

			.callOut{
			display:block;
			left:0;
			top:0;
			background: ##e1e1e1;
			border:white solid 5px;
	 		border-radius: 2px 10px;
	  		box-shadow: 0 0 3px rgba(0,0,0,.7);
			position:fixed;
			z-index: 4;
			height:100%;
			width:100%;
			visibility: hidden;
			color:black;
			font-family: 'Roboto', Arial, sans-serif;
			text-align:center;
		}

	 		##calendarHead {
	 			 margin-bottom:10px;
	   			 font-size: 21px;
		  	}
		}




 		/*///////////////*/
		table.month tr.dayheader .cal{
			border: 1px ##a9a9a9  solid ;
			border-bottom-width: 2px ;
			height:30px;
			font-weight: bold ;
			padding: 5px 0px 5px 0px ;
			text-align: center ;
			background-color:rgba(225,225,225,.75) ;
			font-family: 'Roboto', Arial, sans-serif ;
			border-radius: 3px ;
			color:black ;
			}
 	   
		tr.day  {border: 1px black solid  ;
			background-color: ##ffffff;
			border: 1px ##fbfbfb  solid  ;
			color: ##000000 ;
			font-size:12pt;
			padding: 5px 0px 5px 0px ;
			text-align: center ; height:90px;
			}
 
		table.month tr.day td.othermonth {
			background-color: ##fbfbfb ;
			color: ##CCCCCC ;
			font-size:12pt;
			border: 1px ##FFFFFF solid  ;
			border-radius:3px ;
			font-family: 'Roboto', Arial, sans-serif ;
			}

		td.thismonth{
			border-radius:3px ;
			font-family: 'Roboto', Arial, sans-serif ;
			} 

 		td.today{
		background-color: ##ffffff ;
			color: ##000000 ;
			font-size:12pt;
			border: 2px ##cc6600 solid  ;
			}
		table.month tr.day td.event {
			background-color: ##EEEEEE;
			color: ##000000 ;
			font-size:9pt;
			font-weight: bold ;
			border: 1px ##ffffff solid  ;
			}
 
	</style>  
<div id="contentText">


 

<br>

	
		
	
    <form action="#cgi.script_name#" method="post">
		<input type="hidden" name="eMonth" value="#monthVar#">
		<input type="hidden" name="eYear" value="#yearVar#">

		<h1 id="calendarHead" align="center" style="width:100%;">#DateFormat( dtThisMonth, "mmmmm yyyy" )#</h1>

<table cellspacing="0" cellpadding="2" class="month" width="100%">		
	<td align="left"><input class="cYear" type="submit" name="DateVar" value="<<" title="Go Back a Year">
		<input class="cMonth" type="submit" name="DateVar" value="<" title="Go Back a Month"></td>
	<td align="center"><div align="center" style="width:100%;"></div></td>
	<td align="right"><input class="cMonth" type="submit" name="DateVar" value=">" title="Forward 1 Month">
		<input class="cYear" type="submit" name="DateVar" value=">>" title="Forward 1 Year"></td></table>
	</form>
	
	<table cellspacing="1" cellpadding="2" class="month" width="100%">
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
		<th class="cal">
			Sun
		</th>
		<th class="cal">
			Mon
		</th>
		<th class="cal">
			Tue
		</th>
		<th class="cal">
			Wed
		</th>
		<th class="cal">
			Thr
		</th>
		<th class="cal">
			Fri
		</th>
		<th class="cal">
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

		
 
			<td class="#strClass#" style="#iif(Dateformat(intDate,'mm/dd/yyyy') eq dateFormat(Now(),'mm/dd/yyyy'),de('border: 2px red solid  ;'),de('border: 1px silver solid  ;'))#">
				#Day( intDate )#<br/>
				<cfif structKeyExists(objEvents, intDate)>
					<hr>
					<div class="calendarInfo" data-has-event="1" data-date=#(Dateformat(intDate,'mm/dd/yyyy'))#>	
						<i class="infoIcon fa fa-info-circle"></i>
						<small class="calendarInfo2">#objEvents[intDate].Description#</small><hr class='divide'/>
						<small class="calendarInfo3">#timeformat(objEvents[intDate].eventTime,"h:mmtt")#@#objEvents[intDate].Location#</small>
					</div>
				<cfelse>
					<div id="event" data-has-event="0"></div>
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

 <!-- callOut Box -->
	<div class="callOut">
		
	</div>	

<cfinclude template="_footer.cfm">
</cfoutput>
<script>
(function(){


//display callout function, append text from date clicked and append closing icon
	
	$(".calendarInfo").click(function(event) {	

		var hasEvent = $(this).data('has-event');
		if(hasEvent && $(window).width() < 767){	
			$('.callOut').empty();
			$('.callOut').append('<span class="closeCo"><i class="fa fa-times"></i></span>');
			$('.callOut').append('<br/><br/><br/>');
			$('.callOut').append($(this).data('date') +'<br/>');
			$('.callOut').append( $(this).find(".calendarInfo2").text() + '<br/>' + '<br/>');
			$('.callOut').append( $(this).find(".calendarInfo3").text() + '<br/>');
			$('.callOut').css('visibility', 'visible');
			

			// close modal by clicking icon
			$('.fa, .fa-times').click(function(){
				$('.callOut').empty();
				$('.callOut').css('visibility','hidden');
			});
		}
	});


})();
</script>


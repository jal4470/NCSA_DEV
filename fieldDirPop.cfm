<!--- 
	FileName:	homesite+\html\Default Template.htm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
	01/05/09 - AA - Removed DAY1 and DAY2 times - will now be done thru field availability
	09/26/16 - A.Pinzone - Modernized html for new design. 
	9/25/2018 - M Greenberg - updated styles with inline styles
 --->
<style type="text/css">
* {
    box-sizing: border-box;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    -ms-box-sizing: border-box;
    -o-box-sizing: border-box; }
body {
    font-family: 'Roboto', Arial, sans-serif;
    /*padding: .5in;*/
    margin: 0; }
h2 {
    color: #000;
    font-family: 'Alegreya', Georgia, serif;
    font-size: 30px;
    margin: 0;
    padding-bottom: 10px; }
.more_info_list {
    margin: 0;
    padding: 0;
    list-style: none; }
.more_info_list li { 
    clear: left;
    border-top: 1px solid #C7C7C7;
    font-size: .857em;
    line-height: 1.25;
    padding: 10px 0; }
.more_info_list li span {
  display: inline-block;
  float: left;
  font-weight: bold;
  height: 30px;
  margin: 0;
  width: 125px; }
.field_comments span, 
.field_exceptions span, 
.field_directions span {
    display: block;
    float: none;
    height: auto;
    margin-bottom: 5px;
    width: auto; }
</style>
<cfoutput>
 
<cfif isdefined("url.fid") and isNumeric(url.fid)>
	<cfset fieldID = url.fid>
<cfelseif isdefined("variables.fid") and isNumeric(variables.fid)>
	<cfset fieldID = variables.fid>
<cfelse>
	<cfset fieldID = 0>
</cfif>

<cfif NOT isdefined("fieldID") and NOT isNumeric(fieldID)>
	<cfset fieldID = 0>
</cfif>

<cfif cgi.cf_template_path CONTAINS "fieldDirPrint">
	<cfset suppressPrintLink = true>
<cfelse>
	<cfset suppressPrintLink = false>
</cfif>


	<cfinvoke component="#SESSION.sitevars.cfcPath#field" method="getDirections" returnvariable="qDirections">
		<cfinvokeargument name="fieldID" value="#fieldID#">
	</cfinvoke> 

	<CFIF qDirections.RECORDCOUNT>
		<cfscript>
			MQAddress = URLEncodedFormat(Trim(qDirections.Address));
			MQCity	  = URLEncodedFormat(Trim(qDirections.City));
			MQState	  = URLEncodedFormat(Trim(qDirections.State));
			MQZip	  = URLEncodedFormat(Trim(qDirections.ZIPCODE));
			GMapsLink = "http://maps.google.com/maps?f=q&hl=en&geocode=&q="  & Trim(MQAddress) & "+" & Trim(MQCity) & "+" & Trim(MQState) & "+" & Trim(MQZip);
		</cfscript>


			<h2>#qDirections.FIELDABBR# - #qDirections.FIELDNAME#</h2>
			<span class="close_field_info"><i class="fa fa-times" aria-hidden="true"></i></span>

			<ul class="field_information more_info_list">
				<li class="field_name">
					<span class="title">Field:</span> 
					#qDirections.FIELDNAME# <cfif NOT suppressPrintLink><A Target="Map" href="#GMapsLink#">map it</A>
						
					</cfif>
				</li>
				<li class="field_address">
					<span class="title">Address:</span> 
					#qDirections.ADDRESS#<br> #qDirections.CITY#, #qDirections.STATE# #qDirections.ZIPCODE#
				</li>
				<li class="field_size">
					<span class="title">Field Size:</span>
					#fieldSizeText(qDirections.FIELDSIZE)#
				</li>
				<li class="field_comments">
					<span class="title">Comments:</span>
					#qDirections.FIELDSIZECOMMENT#
				</li>
				<li class="field_exceptions">
					<span class="title">Exceptions:</span>
					#qDirections.exceptions#
				</li>
				<li class="field_directions">
					<div class="container">
						<span class="title">Directions:</span>
						#qDirections.DIRECTIONS#
					</div>
				</li>
				<cfif NOT suppressPrintLink>
				<li class="printer_friendly">
					<a href="fieldDirPrint.cfm?fid=#fieldID#" target="_blank">
						<i class="fa fa-print" aria-hidden="true"></i>&nbsp;&nbsp;Printer Friendly
					</a>
				</li>
				</cfif>
			</uxl>	 	

	<cfelse>

		<ul class="field_information">
			<li>No Field Directions found, please try again.</li>
		</ul>

	</CFIF> 

<!--- </cfif>
 --->
</cfoutput>
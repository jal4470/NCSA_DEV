<!---
Template	pagination.cfm
Author		Anthony Staveris
Purpose		Accept start & end record numbers, total records & records/page, return markup of page links, where each link
		has query string of parameters to invoke pagination again.
Usage		<cfmodule template="assets/modules/pagination.cfm" recordStruct="#rs#">

rs.start_record
rs.end_record
rs.total_records
rs.records_per_page


Modifications	Date	Developer	Action


 --->

<cfset rs	= attributes.recordStruct>

<cfsavecontent variable="pages">
	<cfoutput>
		<!--- <br />module:: start: ~#rs.start_record#~, end: ~#rs.end_record#~, total: ~#rs.total_records#~, records/page: ~#rs.records_per_page#~<br /> --->
		<!--- <cfabort> --->

		<!--- Set page count & current page: round division results to next higher integer, to allow for remaining pages --->
		<cfset total_pages	= ceiling(rs.total_records / rs.records_per_page)>
		<cfset current_page	= ceiling(rs.end_record / rs.records_per_page)>
		<cfset variables.query_str = rs.query_str>
		

		<cfif total_pages lt 10>
			<cfset page_count	= total_pages>
		<cfelse>
			<cfset page_count	= 10>
		</cfif>

		<table cellpadding="1" cellspacing="0" border="0">
			<tr>
				<td class="basenavsection">Page #current_page# of #iif(total_pages eq 0, de(1),de(total_pages))#</td>
			</tr>
		</table>
	</cfoutput>
</cfsavecontent>

<cfset caller.pages = pages>

<cfsavecontent variable="counter">
	<cfoutput>
		<!--- <br />module:: start: ~#rs.start_record#~, end: ~#rs.end_record#~, total: ~#rs.total_records#~, records/page: ~#rs.records_per_page#~<br /> --->
		<!--- <cfabort> --->

		<!--- Set page count & current page: round division results to next higher integer, to allow for remaining pages --->
		<cfset total_pages	= ceiling(rs.total_records / rs.records_per_page)>
		<cfset current_page	= ceiling(rs.end_record / rs.records_per_page)>
		<cfset variables.query_str = rs.query_str>
		

		<cfif total_pages lt 10>
			<cfset page_count	= total_pages>
		<cfelse>
			<cfset page_count	= 10>
		</cfif>

		<table cellpadding="1" cellspacing="0" border="0">
			<tr>
				<!--- Check & set previous page links --->
				<cfif rs.start_record gt rs.records_per_page>
					<!--- <td rowspan="2"><a href="">Prev<br/>Page</a></td> --->
					<cfset prev_start	= rs.start_record - rs.records_per_page>
					<cfset prev_end		= rs.end_record - rs.records_per_page>
					<td><a href="#cgi.script_name#?start_record=#prev_start#&end_record=#prev_end#&total_records=#rs.total_records#&records_per_page=#rs.records_per_page#&#variables.query_str#" class="basenavlink">Prev</a>&nbsp;&nbsp;</td>
				</cfif>

				<!--- Check & set page links --->
				<cfif (current_page - (page_count - 1)) lt 1>
					<cfset from_page	= 1>
					<cfset to_page		= page_count>
					<cfset first_record	= 1>
					<cfset last_record	= rs.records_per_page>
					
				<cfelseif (current_page + (page_count - 1)) gt total_pages>
					<cfset from_page	= total_pages - (page_count - 1)>
					<cfset to_page		= total_pages>
					<cfif page_count neq total_pages>
						<cfset first_record	= rs.total_records - (rs.records_per_page * page_count) + 1>
						<cfset last_record	= rs.total_records - (rs.records_per_page * (page_count - 1))>
					<cfelse>
						<cfset first_record	= 1>
						<cfset last_record	= rs.records_per_page>
					</cfif>
				
				<cfelse>
					<cfset from_page	= current_page>
					<cfset to_page		= current_page + (page_count - 1)>
					<cfset first_record	= rs.start_record>
					<cfset last_record	= rs.end_record>
				
				</cfif>
				<!--- <br />from: ~#from_page#~, to: ~#to_page#~<br /> --->

				<cfloop from="#from_page#" to="#to_page#" index="this_page">
					<!--- <br />first: ~#first_record#~, last: ~#last_record#~<br /> --->
					<cfif this_page eq current_page and rs.total_records gt rs.records_per_page>
						 <td class="basenavsection">#this_page#&nbsp;&nbsp;</td> 
					<cfelseif rs.total_records gt rs.records_per_page>
						<td><a href="#cgi.script_name#?start_record=#first_record#&end_record=#last_record#&total_records=#rs.total_records#&records_per_page=#rs.records_per_page#&#variables.query_str#" class="basenavlink">#this_page#</a>&nbsp;&nbsp;</td>
					</cfif>

					<cfset first_record	= first_record + rs.records_per_page>
					<cfset last_record	= last_record + rs.records_per_page>
				</cfloop>

				<!--- Check & set next page links --->
				<cfif rs.end_record lt rs.total_records>
					<!--- <td rowspan="2"><a href="">Next<br/>Page</a></td> --->
					<cfset next_start	= rs.start_record + rs.records_per_page>
					<cfset next_end		= rs.end_record + rs.records_per_page>
					<td><a href="#cgi.script_name#?start_record=#next_start#&end_record=#next_end#&total_records=#rs.total_records#&records_per_page=#rs.records_per_page#&#variables.query_str#" class="basenavlink">Next</a></td>
				</cfif>
			</tr>
		</table>
	</cfoutput>
</cfsavecontent>

<cfset caller.counter = counter>

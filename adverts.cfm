<!--- 
	FileName:	adverts.cfm
	Created on: 1/24/2011
	Created by: bcooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Manage Advertising</H1>
<br> <!--- <h2>yyyyyy </h2> --->

<cfquery datasource="#session.dsn#" name="getAds">
	select * from tbl_ad
	order by beginDate
</cfquery>



<h2>
	Adverisements
	<div style="float:right;">
		<a href="adverts_add.cfm">Add</a> | <a href="adverts_sequence.cfm?public=1">Sequence</a>
	</div>
</h2>
<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%" class="table1">
	<thead>
	<tr>
		<th>&nbsp;</th>
		<th>Title</th>
		<th>Description</th>
		<th>Content</th>
		<th>Begin Date/Time</th>
		<th>End Date/Time</th>
		<th>Clicks</th>
	</tr>
	</thead>
	<tbody>
	<CFLOOP query="getAds">
		<tr>
			<TD style="white-space:nowrap;">
				<a href="adverts_edit.cfm?ad_id=#ad_id#">Edit</a> | <a href="adverts_delete.cfm?ad_id=#ad_id#" onclick="return confirm('Are you sure you want to remove this ad?');">Del</a> | <a href="adverts_flip_status.cfm?ad_id=#ad_id#"><cfif active_flag>Disable<cfelse>Enable</cfif></a>
			</TD>
			<TD>
			<cfif href NEQ "" OR customContent NEQ "">
				<a target="_blank" href="adverts_render.cfm?adid=#ad_id#&notrack">#title#</a>
			<cfelse>
				#title#
			</cfif>
			</TD>
			<TD> #description#&nbsp; </TD>
			<td>
				<div class="ad">
					<cfif text NEQ "">
						#text#
					<cfelse>
						<!--- render image --->
						<!--- <cftimer>
						<cfimage action="resize" width="170" height="" source="#Application.sitevars.homehttp#/adverts_view.cfm?adid=#ad_id#&type=.#extension#" name="resizedimg">
						<cfimage source="#resizedimg#" action="writeToBrowser">
						</cftimer> --->
						<img src="adverts_view.cfm?adid=#ad_id#">
					</cfif>
				</div>
			</td>
			<td>
				<cfset color=iif(datediff("n",now(),beginDate) LT 0,de("green"),de("black"))>
				<span style="color:#color#;">#dateformat(beginDate,"m/d/yyyy")# #timeformat(beginDate,"h:mm tt")#</span>
			</td>
			<td>
				<cfset color=iif(datediff("n",now(),endDate) LT 0,de("red"),de("black"))>
				<span style="color:#color#;">#dateformat(endDate,"m/d/yyyy")# #timeformat(endDate,"h:mm tt")#</span>
			</td>
			<td>#click_cnt#</td>
		</tr>
	</CFLOOP>
	</tbody>
</table>



</cfoutput>
</div>
<cfinclude template="_footer.cfm"> 

<!--- 
	FileName:	homesite+\html\Default Template.htm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
	12/02/2008 - arnone - commented out years 2003&2004 as per NCSA since those years were not complete.
	
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - History</H1>
<br>
<h2></h2>


<CFSET histYear   = "">
<CFSET histSeason = "">
<CFSET histReport = "">

<CFIF isDefined("FORM.year") AND len(trim(FORM.year))> 
	<CFSET histYear = FORM.year> 
</CFIF>
<CFIF isDefined("FORM.season") AND len(trim(FORM.season))> 
	<CFSET histSeason = FORM.season> 
</CFIF>
<CFIF isDefined("FORM.report") AND len(trim(FORM.report))> 
	<CFSET histReport = FORM.report> 
</CFIF>

<CFIF len(trim(histYear)) AND len(trim(histSeason)) AND len(trim(histReport)) >
	<CFIF histReport EQ "GS">
		<CFLOCATION url="historyScore.cfm?sy=#histSeason##histYear#">
	</CFIF>
	<CFIF histReport EQ "FS">
		<CFLOCATION url="historyFinalSTD.cfm?sy=#histSeason##histYear#">
	</CFIF>
</CFIF>

<CFINVOKE component="#SESSION.siteVars.cfcPath#Season" method="getHistSeasons" returnvariable="qHistYrs">
	<CFINVOKEARGUMENT name="currSeason" value="#SESSION.CURRENTSEASON.YEAR#">  
</CFINVOKE>	
<!---
<cfquery name="qHistYrs" dbtype="query">
select season_year from getSeasonHistory GROUP BY season_year
</cfquery>

<cfquery name="getCurrentSeason" dbtype="query">
select * from getSeasonHistory where season_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.CURRENTSEASON.ID#">
</cfquery>
--->


<form action="history.cfm" method="post">
<TABLE align="center" cellSpacing=0 cellPadding=2 width="80%" border=0>
	<tr class="tblHeading">
		<TD colspan="4"> &nbsp; Select Year, Season, report and click Enter. </td>
	</TR>
	<tr><td><select name="year">
				<option value="">select a year</option>
				<option value="05">2005</option>
				<option value="06">2006</option>
				<option value="07">2007</option>
				<option value="08">2008</option>
				<CFLOOP query="qHistYrs">
					<option value="#SEASON_YEAR#">#SEASON_YEAR#</option>
				</CFLOOP>
			</select>	
 			<select name="season">
				<option value="S">Spring</option>
				<option value="F">Fall</option>
			</select>	
			<select name="report">
				<option value="GS">Game Score</option>
				<option value="FS">Final Standing</option>
			</select>
			<input type="Submit" name="enter" value="Enter">	
		</td>
	</tr>
</TABLE>
</form>	




<!--- <br><br><br><br><br><br><br><br><br><br>



	<TABLE align="center" cellSpacing=0 cellPadding=2 width="80%" border=0>
		<tr class="tblHeading">
			<TD colspan="4"> &nbsp;&nbsp; </td>
		</TR>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#">
			<TD rowspan="2" class="tdUnderLine" align="center" valign="top"><b>2008</b>													</TD>
			<td class="tdUnderLine"> <b>Fall</b> 	</TD>
			<td class="tdUnderLine"> n/a 			</td>
			<td class="tdUnderLine"> n/a 			</td>
		</TR>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,2)#">
			<td class="tdUnderLine"> <b>Spring </b>											</td>
			<td class="tdUnderLine"> <a href="historyScore.cfm?sy=S08">Games Score	   </a>	</td>
			<td class="tdUnderLine"> <a href="historyStand.cfm?sy=s08">Final Standings </a>	</td>
		</TR>

		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#">
			<TD rowspan="2" class="tdUnderLine" align="center" valign="top"><b>2007</b>													</TD>
			<td class="tdUnderLine"> <b>Fall</b> 													</TD>
			<td class="tdUnderLine"> <a href="historyScore.cfm?sy=F07">Games Score	   </a>	</td>
			<td class="tdUnderLine"> <a href="historyStand.cfm?sy=F07">Final Standings </a>	</td>
		</TR>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,2)#">
			<td class="tdUnderLine"> <b>Spring </b>											</td>
			<td class="tdUnderLine"> <a href="historyScore.cfm?sy=S07">Games Score	   </a>	</td>
			<td class="tdUnderLine"> <a href="historyStand.cfm?sy=S07">Final Standings </a>	</td>
		</TR>

		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#">
			<TD rowspan="2" class="tdUnderLine" align="center" valign="top"><b>2006</b>												</TD>
			<td class="tdUnderLine"> <b>fall </b> 											</td>
			<td class="tdUnderLine"> <a href="historyScore.cfm?sy=F06">Games Score	   </a>	</td>
			<td class="tdUnderLine"> <a href="historyStand.cfm?sy=F06">Final Standings </a>	</td>
		</TR>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,2)#">
			<td class="tdUnderLine"> <b>Spring </b>										</td>
			<td class="tdUnderLine"> <a href="historyScore.cfm?sy=S06">Games Score	   </a>	</td>
			<td class="tdUnderLine"> <a href="historyStand.cfm?sy=S06">Final Standings </a>	</td>
		</TR>

		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#">
			<TD rowspan="2" class="tdUnderLine" align="center" valign="top"><b>2005</b>												</TD>
			<td class="tdUnderLine"> <b>Fall   </b>						 				</td>
			<td class="tdUnderLine"> <a href="historyScore.cfm?sy=F05">Games Score	   </a>	</td>
			<td class="tdUnderLine"> <a href="historyStand.cfm?sy=F05">Final Standings </a>	</td>
		</TR>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,2)#">
			<td class="tdUnderLine"> <b>Spring </b>										</td>
			<td class="tdUnderLine"> <a href="historyScore.cfm?sy=S05">Games Score	   </a>	</td>
			<td class="tdUnderLine"> <a href="historyStand.cfm?sy=S05">Final Standings </a>	</td>
		</tr>

		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#">
			<TD rowspan="2" class="tdUnderLine" align="center" valign="top"><b>2004</b>												</TD>
			<td class="tdUnderLine"> <b>Fall   </b>										</td>
			<td class="tdUnderLine"> <a href="historyScore.cfm?sy=F05">Games Score	   </a>	</td>
			<td class="tdUnderLine"> <a href="historyStand.cfm?sy=F05">Final Standings </a>	</td>
		</TR>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,2)#">
			<td class="tdUnderLine"> <b>Spring </b>										</td>
			<td class="tdUnderLine"> <a href="historyScore.cfm?sy=S04">Games Score	   </a>	</td>
			<td class="tdUnderLine"> <a href="historyStand.cfm?sy=S04">Final Standings </a>	</td>
		</TR>

		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#">
			<TD rowspan="2" class="tdUnderLine" align="center" valign="top"><b>2003</b>												</TD>
			<td class="tdUnderLine"> <b>Fall   </b>										</td>
			<td class="tdUnderLine"> <a href="historyScore.cfm?sy=F03">Games Score	   </a>	</td>
			<td class="tdUnderLine"> <a href="historyStand.cfm?sy=F03">Final Standings </a>	</td>
		</TR>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,2)#">
			<td class="tdUnderLine"> <b>Spring </b>										</td>
			<td class="tdUnderLine"> <a href="historyScore.cfm?sy=S03">Games Score	   </a>	</td>
			<td class="tdUnderLine"> <a href="historyStand.cfm?sy=S03">Final Standings </a>	</td>
		</TR>

		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#">
			<TD rowspan="2" class="tdUnderLine" align="center" valign="top"><b>2002</b>												</TD>
			<td class="tdUnderLine"> <b>Fall   </b>										</td>
			<td class="tdUnderLine"> <a href="historyScore.cfm?sy=F02">Games Score	   </a>	</td>
			<td class="tdUnderLine"> <a href="historyStand.cfm?sy=F02">Final Standings </a>	</td>
		</TR>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,2)#">
			<td class="tdUnderLine"> <b>Spring </b>										</td>
			<td class="tdUnderLine">&nbsp; <!---  <a href="historyScore.cfm?sy=S02">Games Score	 </a> --->  </td>
			<td class="tdUnderLine">&nbsp; <!---  <a href="historyStand.cfm?sy=S02">Final Standings </a> --->	</td>
		</TR>
	</table>	 --->

	

</cfoutput>
</div>
<cfinclude template="_footer.cfm">

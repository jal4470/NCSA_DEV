<!--- 
	FileName:	clubContactDetails.cfm
	Created on: 08/07/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: this file will display a list of clubs and their reps
	
MODS: mm/dd/yyyy - filastname - comments
12/3/08 - aa - removed link to clubCoaches.cfm
12/30/08 - aa -  supress club 1
 --->

<cfset mid = 2>
<cfinclude template="_header.cfm">

</style>

<div id="contentText">

<H1 class="pageheading"> NCSA Teams and Coaches List </H1>


<CFIF isDefined("FORM.clubID")>
	<CFSET clubID = FORM.clubid>
<CFELSE>
	<CFSET clubID = 0>
</CFIF>



<cfoutput>


<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubInfo" returnvariable="clubInfo">
	<cfinvokeargument name="DSN"     value="#SESSION.DSN#">
	<cfinvokeargument name="orderby" value="clubname">
</cfinvoke><!---   <cfdump var="#clubInfo#"> --->
	
	
<FORM action="clubTeams.cfm" method="post">
	<label class="select_label" for="clubid">Select a club and click Enter to see the club's teams.</label>
	<div class="select_box">
	<select id="clubid" name="clubid">
		<option value="0">Select a Club...</option>
		<CFLOOP query="clubInfo">
			<cfif CLUB_ID NEQ 1> <!--- supress club 1 --->
				<option value="#CLUB_ID#" <cfif variables.clubid EQ CLUB_ID> selected</cfif> >#CLUB_NAME#</option>
			</cfif>
		</CFLOOP>
	</select> 
	</div>
	<button type="submit" name="getTeams" class="gray_btn select_btn">Enter</button>


<CFIF VARIABLES.clubid GT 0>
	<cfinvoke component="#SESSION.sitevars.cfcPath#team" method="getClubTeams" returnvariable="qClubTeams">
		<cfinvokeargument name="DSN"     value="#SESSION.DSN#">
		<cfinvokeargument name="clubID"  value="#VARIABLES.clubID#">
	</cfinvoke>  <!--- <cfdump var="#qClubTeams#"> --->
	
	<CFIF qClubTeams.recordCount>

	  <h3 class="viewing_info"><span>Viewing:</span> #qClubTeams.Club_Name#<br></h3>
	
	  <p style="margin-bottom: 20px;">Click on a coaches name to see their contact information.</p>
	
		<table id="teams_coaches" cellspacing="0" cellpadding="5" align="center" border="0" width="100%" style="margin-top: 2px;">
			<thead>
			<tr class="tblHeading">
				<th class="division_column">DIVISION</th>
				<th class="team_column">TEAM</th>
				<th class="coach_column">COACH</th>
				<th class="asst_coach_column">ASST COACH</th>
			</tr>
			</thead>
			<tbody>
			<CFLOOP query="qClubTeams">
				<tr>
					<td valign="top" class="division_column">
						<span class="mobile_only">Division:</span> #DIVISION#
					</TD>
					<td valign="top" class="team_column">
						<span class="mobile_only">Team:</span> #TEAMNAMEDERIVED#    <!--- <a href="clubCoaches.cfm?tid=#TEAM_ID#&cid=#CLUB_ID#"></a> --->
					</TD>
					<td valign="top" class="coach_column">
						<span class="mobile_only">Coach:</span> <a href="##" class="more_link">#coachFirstName# #coachLastName#</a>
						<div class="more_info">
							<div class="container">
								<h2>#coachFirstName# #coachLastName#</h2>
								<ul class="more_info_list">
									<li><span>Email:</span> <a href="mailto: #coachEmail#">#coachEmail#</a></li>
									<li><span>Cell Phone:</span> #coachCellPhone#</li>
									<li><span>Home Phone:</span> #coachHomePhone#</li>
								</ul>
							</div>
						</div>
					</TD>
					<td valign="top" class="asst_coach_column">
						<span class="mobile_only">Asst Coach:</span> <a href="##" class="more_link">#asstCoachFirstNAme# #asstCoachLastName#</a>
						<div class="more_info">
							<div class="container">
								<h2>#asstCoachFirstNAme# #asstCoachLastName#</h2>
								<ul class="more_info_list">
									<li><span>Email:</span> <a href="mailto: #asstEmail#">#asstEmail#</a></li>
									<li><span>Cell Phone:</span> #asstCellPhone#</li>
									<li><span>Home Phone:</span> #asstHomePhone#</li>
								</ul>
							</div>
						</div>
					</td>
				</tr>

					<!--- START Hidden row, displayed when clicked --->
<!--- 					<tr id="TRD#Team_ID##currentRow#"  bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#" style="Display:none">
						<td valign="top" class="tdUnderLine" colspan="2">
							#repeatString("&nbsp;",1)#
						</TD>
						<td valign="top" class="tdUnderLine" >
							 #coachEmail#  <br>(C) #coachCellPhone#	<br>(H) #coachHomePhone#
						</td>
						<td valign="top" class="tdUnderLine" >
							 #asstEmail#   <br>(C) #asstCellPhone#	<br>(H) #asstHomePhone#
						</td>
					</tr> --->
					<!--- END Hidden Row --->
			</CFLOOP>

			</tbody>
		</table>
		</div>
	</CFIF>
</FORM>

</CFIF>

</cfoutput>
</div>

<script language="javascript">
/*var cForm = document.standing.all;*/
var lastRow;
function DisplayDetail(idx)
{	lastVal = lastRow;
	for (var index = 1; index < 100; index++)
	{	itm1 = "TRD" + idx + index ;
	//	TR1 = "TR_" + idx;
	//	var elem1 = document.getElementById (TR1);
		var obj   = document.getElementById(itm1);
		if ( obj )
			document.getElementById ( itm1 ).style.display = "";
		if (lastRow > 0)
		{//	Hdr2 = "TR_" + lastRow;
			itm2 = "TRD" + lastRow + index
			var obj2   = document.getElementById(itm2);

			if ( obj2 )
					document.getElementById(itm2).style.display = "none";
		}
	}
	if (idx == lastRow)
		idx = 0;
	lastRow = idx;
}
</script>


<cfinclude template="_footer.cfm">




<!--- 
	FileName:	refBulkAssign.cfm
	Created on: 10/14/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
12/12/08 - AA - did not put in the js to input multiple refs, but page was made to return to the same date range of games
				after Save was clicked (previously you had to select the games again)
03/24/09 - AA - added  dbo.formatDateTime(g.GAME_TIME,'HH:MM 24')  so time will sort properly. will have to add to all sorts by time
04/30/09 - AA - Ticket:7623 - disabled the submit button via javascript so it can not be double clicked.
5/22/2017 - apinzone - removed jquery 1.4.2, moved javascript to bottom of page and wrapped in cfsavecontent
					 - added scrollable area around table
09/07/2017 - A. PInzone (27455) - Updated ".live" method (deprecated jq 1.7) to the ".on" method.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>


<cfsavecontent variable="jqueryUI_CSS">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
	<style type="text/css">
		.ui-datepicker{
			font-size:11px;
		}
		.ref,.ar1,.ar2{
			padding-left:15px;
			line-height:16px;
		}
		.ref .green,.ref .red,.ar1 .green,.ar1 .red,.ar2 .green,.ar2 .red{
			margin-left:-10px;
		}
		.ui-icon{
			float:right;
			cursor:pointer;
		}
		##gameTable th{
			text-align:left;
		}
	</style>
</cfsavecontent>
<cfhtmlhead text="#jqueryUI_CSS#">



<cfif isDefined("URL.From")>
	<cfset WeekendFrom = URL.From >
<cfelseif isDefined("FORM.WeekendFrom")>
	<cfset WeekendFrom = FORM.WeekendFrom >
<cfelse>
	<cfset WeekendFrom = dateFormat(now(),"mm/dd/yyyy") >
</cfif>

<cfif isDefined("URL.To")>
	<cfset WeekendTo = URL.To >
<cfelseif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo = FORM.WeekendTo >
<cfelse>
	<cfset WeekendTo = dateFormat(DateAdd("d",7,now() ),"mm/dd/yyyy") >
</cfif>

<cfif isDefined("URL.G")> <!--- ???? --->
	<cfset swExecuteSelect = true >
<cfelse>
	<cfset swExecuteSelect = false >
</cfif>

<cfif isDefined("FORM.gameId")>
	<cfset gameId = FORM.gameId >
<cfelse>
	<cfset gameId = "" >
</cfif>

<cfif isDefined("FORM.RefID")>
	<cfset RefID = FORM.RefID >
<cfelse>
	<cfset RefID = "" >
</cfif>

<cfif isDefined("FORM.chkShowNCSAFields")>
	<cfset showNCSAFields = true >
<cfelse>
	<cfset showNCSAFields = false >
</cfif>

<cfif isDefined("FORM.gameNumber")>
	<cfset gameNumber = FORM.gameNumber >
<cfelse>
	<cfset gameNumber = "" >
</cfif>

<cfif isDefined("FORM.chkShowUnassignedOnly")>
	<cfset ShowUnassignedOnly = true >
<cfelse>
	<cfset ShowUnassignedOnly = false >
</cfif>

<cfif isDefined("FORM.selAgeGroup")>
	<cfset ageGroup = FORM.selAgeGroup >
<cfelse>
	<cfset ageGroup = "" >
</cfif>

<!--- get referees --->

<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo">
	<cfinvokeargument name="certifiedOnly" value="Y"> 
</cfinvoke>

<!--- get game types --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrGameType">
	<cfinvokeargument name="listType" value="GAMETYPE"> 
</cfinvoke> 

<cfif isDefined("form.GO") OR swExecuteSelect OR isDefined("FORM.SAVE")  OR isDefined("FORM.PRINTME") >

	<cfquery name="refGameInfo_A" datasource="#SESSION.DSN#" >
		select  g.GAME_ID,   	g.GAME_DATE,  	  g.GAME_TIME, 
				g.GAME_TYPE, 	g.FIELDABBR,  	  g.Field_id, 	g.DIVISION,
				g.SCOREOVERRIDE, 	g.SCORE_HOME, g.SCORE_VISITOR,
				g.HOME_TEAMNAME,	g.HOME_TEAM_ID,
				g.VISITOR_TEAMNAME, g.VISITOR_TEAM_ID,  g.Virtual_TeamName, 
				g.REFREPORTSBM_YN,  g.REFPAID_YN,
				g.REFID,  	   g.REF_ACCEPT_DATE,	g.Ref_accept_YN,
				g.ASSTREFID1,  g.AREF1ACPTDATE,  	g.ARef1Acpt_YN,
				g.ASSTREFID2,  g.AREF2ACPTDATE,		g.ARef2Acpt_YN,
				c.lastname + ', ' + c.FIRSTNAME as ref_name,
				rrh.FullTimeScore_Home, rrh.FullTimeScore_Visitor,
				rrd.game_id as rrd_game_id,
				dbo.f_get_contact_fullname(g.asstrefid1) as ar1_name,
				dbo.f_get_contact_fullname(g.asstrefid2) as ar2_name
		  from  V_Games_all g  with (nolock)
		  left join TBL_CONTACT c 
		  	ON c.CONTACT_ID = g.REFID
		  left join tbl_referee_rpt_header rrh
		 	 on g.game_id=rrh.game_id
		  left join tbl_referee_rpt_detail rrd
		  	on g.game_id=rrd.game_id and (rrd.serial_no is null or rrd.serial_no = 1)
		  left join tbl_field f
			on g.field_id=f.field_id
		 Where  1=1
		 	<cfif gameNumber NEQ ""  AND isnumeric(gameNumber)>
				and g.game_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#gameNumber#">
			<cfelse>
			    and  g.game_date between <cfqueryparam cfsqltype="CF_SQL_DATE" value="#weekendfrom#"> and <cfqueryparam cfsqltype="CF_SQL_DATE" value="#weekendto#">
			 	and season_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#SESSION.CurrentSeason.ID#">
			 	<cfif NOT showNCSAFields>
					and f.club_id <> 1
				</cfif>
				<cfif ageGroup EQ "fullside">
					and dbo.f_is_game_smallsided(g.game_id) = 0
				<cfelseif ageGroup EQ "u15up">
					and dbo.f_get_game_age(g.game_id) >= 15
				<cfelseif ageGroup EQ "smallside">
					and dbo.f_is_game_smallsided(g.game_id) = 1
				</cfif>
				<cfif showUnassignedOnly>
					and 
					(
						(dbo.f_is_game_smallsided(g.game_id)=1 AND g.refid is null)
						OR
						(dbo.f_is_game_smallsided(g.game_id)=0 AND (g.refid is null or g.asstrefid1 is null or g.asstrefid2 is null))
					)
				</cfif>
			</cfif>
		   order by g.game_date, g.FIELDABBR, dbo.formatDateTime(g.GAME_TIME,'HH:MM 24') 
	</cfquery>
	<!--- and  (g.game_date >= '#WeekendFrom#' and  g.game_date <= '#WeekendTo#' ) #preserveSingleQuotes(whereDiv)# #preserveSingleQuotes(whereState)# --->

	<cfset ctGames = refGameInfo_A.recordCount>
	
	
	<!--- START REF ASSIGNOR LOGIC --->
	<CFIF SESSION.MENUROLEID EQ 23>
		<!--- we have a ref assignor, the games must be limited to the games they are mapped to. --->
		<!--- get the assignor fields --->
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getAssignorFields" returnvariable="qAssignorFields">
			<cfinvokeargument name="AssignorContactID" value="#SESSION.USER.CONTACTID#">
			<cfinvokeargument name="orderBy" value="NAME">
		</cfinvoke>
		<cfset lstAssignorFieldIDs = "0">
		<CFIF qAssignorFields.recordCount>
			<cfset lstAssignorFieldIDs = valueList(qAssignorFields.FIELD_ID)>
		</CFIF>
		<!--- only select games on the fields in the list --->
		<cfquery name="refGameInfo_A" dbtype="query">
			SELECT * FROM refGameInfo_A
			WHERE FIELD_ID in (#lstAssignorFieldIDs#)
		</cfquery>
		<cfset ctGames = refGameInfo_A.recordCount>
	</CFIF>

<cfelse>
	<cfset ctGames = 0>
</cfif>

<div id="contentText">

<H1 class="pageheading"> NCSA - Referee Assignment Bulk </H1> 
<cfif ctGames>
	<table cellspacing="0" cellpadding="3" align="center" border="0"  width="100%" >
		<TR><TD colspan="5" height="1" valign="top">
				<h2>#ctGames# game<cfif ctGames gt 1>s</cfif> listed</h2>
			</TD>
			<TD colspan="5" height="1" align="right">
				<FORM name="PrintFR" action="refBulkAssigncsv.cfm"  method="post" ID="PrintFR">
					<input type="hidden" name="GameID"		value="#GameId#"  ID="GameID"> 
					<input type="hidden" name="UserId"		value="#SESSION.USER.CONTACTID#" ID="UserId"> 
					<input type="hidden" name="ProfileType"	value="#SESSION.MENUROLEID#" ID="ProfileType"> 
					<!--- <input type="hidden" name="Mode"		value="" ID="Mode"> 
					<input type="hidden" name="SubMode"		value="" ID="SubMode">  --->
					<INPUT type="hidden" name="WeekendFrom" value="#VARIABLES.WeekendFrom#">
					<INPUT type="hidden" name="WeekendTo"   value="#VARIABLES.WeekendTo#">
					<input type="Submit" name="printme" value="Print Friendly" >
					<cfif showNCSAFields>
						<input type="hidden" name="chkShowNCSAFields" value="1">
					</cfif>
					<cfif ShowUnassignedOnly>
						<input type="hidden" name="chkShowUnassignedOnly" value="1">
					</cfif>
					<input type="hidden" name="gameNumber" value="#VARIABLES.gameNumber#">
					<input type="hidden" name="selAgeGroup" value="#ageGroup#">
				</FORM>
			</TD>
		</TR>

	</TABLE>
</cfif>
<FORM name="Games" action="refBulkAssign.cfm"  method="post" ID="Games">
<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%" >
	<TR>
		<TD>
			<input type="hidden" name="GameID"		value="#GameId#" ID="GameID">
			<input type="hidden" name="UserId"		value="#SESSION.USER.CONTACTID#" ID="UserId">
			<input type="hidden" name="ProfileType"	value="#SESSION.MENUROLEID#" 	 ID="ProfileType">
			<!--- <input type="hidden" name="Mode"		value="" ID="Mode">
			<input type="hidden" name="SubMode"		value="" ID="SubMode"> --->
			<B>From</B> &nbsp;
			<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9"> 
			&nbsp;&nbsp;&nbsp;
			<B>To</B> &nbsp;
			<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
			
			<!--- <B>State</B> &nbsp;<cfif (SESSION.MENUROLEID EQ 22) OR (SESSION.MENUROLEID EQ 23)> <!--- 22=NYREFASSNR, 23=NJREFASSNR ---> <cfset AssignorState = "NJ"><cfif SESSION.MENUROLEID EQ 22> <cfset AssignorState = "NY"></cfif>	<input type=hidden name="State" value="#AssignorState#" ID="State">#AssignorState#<cfelse><input type=Radio name="State" value="NY" <cfif state eq "NY">checked</cfif> ID="State">New York<input type=Radio name="State" value="NJ" <cfif state eq "NJ">checked</cfif> ID="State">New Jersey</cfif> --->
			<cfif ctGames >
				&nbsp;&nbsp;&nbsp;
				<B>Referee </B> &nbsp;
				<SELECT name="RefID" ID="RefID"> 
					<cfloop query="qRefInfo"><!--- <cfif refId EQ CONTACT_ID>selected</cfif> --->
						<OPTION value="#CONTACT_ID#" >#LASTNAME#, #FIRSTNAME#</OPTION>
					</cfloop>
				</SELECT>
			</cfif>
			
		</td>
	</tr>
	<TR>
		<TD>
			<B>Show NCSA Field Games</B>
			<INPUT type="Checkbox" name="chkShowNCSAFields" <cfif showNCSAFields>checked="checked"</cfif> value="1"> 
			&nbsp;&nbsp;&nbsp;
			<B>Game ##</B>
			<INPUT name="gameNumber" value="#VARIABLES.gameNumber#" size="9">
			&nbsp;&nbsp;&nbsp;
			<b>Show Unassigned Only</b>
			<INPUT type="Checkbox" name="chkShowUnassignedOnly" <cfif ShowUnassignedOnly>checked="checked"</cfif> value="1">
			&nbsp;&nbsp;&nbsp;
			<b>Age Grouping</b>
			<select name="selAgeGroup">
				<option value="all">All Games</option>
				<option value="fullside" <cfif ageGroup EQ "fullside">selected="selected"</cfif>>Full Sided</option>
				<option value="u15up" <cfif ageGroup EQ "u15up">selected="selected"</cfif>>U15 and Up</option>
				<option value="smallside" <cfif ageGroup EQ "smallside">selected="selected"</cfif>>Small Sided</option>
			</select>
			&nbsp;&nbsp;&nbsp;
			<input type="SUBMIT" name="Go"  value="Get Games" >
		</td>
	</tr>
</table>
</form>
<cfif ctGames>
<h3>Sort by:</h3>
<div id="sortLinks" style="font-size:10px;">
	<input type="radio" id="sortLink1" name="radio" checked="checked" /><label for="sortLink1">Date-Field-Time</label>
	<input type="radio" id="sortLink2" name="radio" /><label for="sortLink2">Date-Time-Field</label>
</div>

<div>
	<span class="green"><b>A</b> before the referee name signifies that referee has confirmed assignment.</span>	
	<br><span class="red">  <b>D</b> before the referee name signifies that the referee has declined assignment.</span>  
	<br>No letter signifies no action by referee on assignment.
</div>
</cfif>
<div class="table-container">
<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%" id="gameTable">
<cfif ctGames>
	<thead>
	<tr class="tblHeading">
		<th>Actions</th>
		<th> &nbsp; </th>
		<th> Date</th>
		<th> Time</th>
		<th> Game	</th>
		<th> Div	</th>
		<th> Field	</th>
		<th> Home Team <br>Visitor Team	</th>
		<th> Referee	</th>
		<th> RS </th>
		<th> HV </th>
	</tr>
	</thead>
	<tbody>
	<cfset curDate = refGameInfo_A.Game_Date>
	<cfloop query="refgameinfo_a">
		<!--- set vars --->
		<cfset Game			 = GAME_ID>
		<cfset GameDate		 = dateFormat(GAME_DATE,"m/d/yy")>
		<cfset GameTime		 = timeFormat(GAME_TIME,"h:mm tt")>
		<cfset HomeScore	 = SCORE_HOME>
		<cfset VisitorScore	 = SCORE_VISITOR>
		<cfset HomeTeam		 = HOME_TEAMNAME>

		<cfif len(trim(VISITOR_TEAMNAME))>
			<cfset VisitorTeam	 = VISITOR_TEAMNAME>
		<cfelseif len(trim(Virtual_TeamName))>
			<cfset VisitorTeam	 = Virtual_TeamName>
		<cfelse>
			<cfset VisitorTeam	 = "">
		</cfif>

		<cfset HomeTeamID	 = HOME_TEAM_ID>
		<cfset VisitorTeamID = VISITOR_TEAM_ID>
		<cfset GameType		 = GAME_TYPE>
		<cfset RefReportSbm	 = REFREPORTSBM_YN>
		<cfset RefUnPaid	 = REFPAID_YN>
		<cfset RefId		 = REFID >
		<cfset GameField	 = FIELDABBR>
		<cfset ScoreOverride = SCOREOVERRIDE>
		<cfset GameDiv		 = DIVISION>
		<cfset AsstRefId1	 = ASSTREFID1>
		<cfset AsstRefId2	 = ASSTREFID2>
		<cfset ref_name      = REF_NAME>
		<cfset ar1_name      = ar1_name>
		<cfset ar2_name      = ar2_name>
		<cfset RefAcptDate	 = REF_ACCEPT_DATE>

		<cfset RefAssigned = "">
		<cfif len(trim(ref_name))>
			<cfset RefAssigned = "Y">
		</cfif>

		<cfif listFind("1,20,22,23",SESSION.MenuRoleID) EQ 0>
			<CFIF len(trim(RefID))>
				<cfset ref_name="Referee Covered">
				<cfset RefAssigned  = "" >
			</cfif> 
			<cfif len(trim(asstrefid1))>
				<cfset ar1_name="Referee Covered">
			</cfif>
			<cfif len(trim(asstrefid2))>
				<cfset ar2_name="Referee Covered">
			</cfif>
		</CFIF>

		<cfset ReportSubmitted = "">
		<cfif len(trim(RefReportSbm))>
			<cfset ReportSubmitted = "Checked">
		<cfelse>
			<cfset ReportSubmitted = "">
		</cfif>

		<cfif len(trim(RefUnPaid))>
			<cfset RefereeUnPaid = "Checked">
		<CFELSE>
			<cfset RefereeUnPaid = "">
		</cfif>

		<cfif fulltimescore_home NEQ "" AND fulltimescore_visitor NEQ "">
			<cfset RefScore = FullTimeScore_Home & "-" & FullTimeScore_Visitor>
		<cfelse>
			<cfset RefScore = "" >
		</cfif>
		
		<cfif rrd_game_id NEQ "">
			<cfset RefRptChecked = "checked">
		<cfelse>
			<cfset RefRptChecked = "">
		</cfif>

		<cfset GameTypeAbbr = "">
		<cfif len(Trim(Gametype))>
			<cfloop from="1" to="#arrayLen(arrGameType)#" step="1" index="iGt">
				<cfif GameType EQ arrGameType[igt][1]>
					<cfset GameTypeAbbr = arrGameType[igt][3]>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>

		<cfif len(trim(HomeScore))>
			<cfset SORAttrib	 = "">
			<cfset noScore		 = "N">
			<cfset AllowRefAsgn = "N">
		<cfelse>
			<cfset SORAttrib	= "disabled">
			<cfset noScore		= "Y">
			<cfset AllowRefAsgn = "Y">
		</cfif>
		
		<cfif curDate NEQ Game_Date>
			<cfset curDate = Game_Date>
			<!--- <tr class="tblHeading">
				<td colspan="10" height="10"></td>
			</tr> --->
		</cfif>
		<tr>
			<td class="tdUnderLine">
				<cfif listFind("1,20,22,23",SESSION.MenuRoleID)>
					<a href="refAssign.cfm?gid=#GAME_ID#&from=#WeekendFrom#&to=#WeekendTo#&PageURL=refBulkAssign">Edit</a>
				</cfif>
				<input type="hidden" name="game" value="#game#">
			</td>
			<td class="tdUnderLine">
				<cfif len(trim(GameTypeAbbr))>
					<SPAN class="red">#GameTypeAbbr#</SPAN>
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<td class="tdUnderLine">
				#GameDate#
			</td>
			<td class="tdUnderLine">
				#GameTime#
			</td>
			<td class="tdUnderLine">
				#Game_ID#
			</td>
			<td class="tdUnderLine">
				#GameDiv#
			</td>
			<td class="tdUnderLine">
				#GameField#
			</td>
			<td class="tdUnderLine">
				<b>H</b> #HomeTeam#
				<br>
				<b>V</b> #VisitorTeam#
			</td>
			<td class="tdUnderLine">
				<div class="ref">
					<cfif refid GT 0>
						<span class="ui-icon ui-icon-close"></span>
					</cfif>
					<cfif Ref_accept_YN EQ "Y">
						<span class="green"><b>A</b></span>
					<cfelseif Ref_accept_YN EQ "N">
						<span class="red"><b>D</b></span>
					</cfif>
					<a class="assignLink" href="javascript:void(0);">REF</a>:
					<span class="assigned">
						<cfif REFID GT 0>
							<cfset refname="#ref_name#">
							<cfset contactid=refid>
						<cfelse>
							<cfset refname="">
							<cfset contactid="">
						</cfif>	
						#refname#
					</span>
					<input type="hidden" name="contact_id" value="#contactid#">
				</div>
				<div class="ar1">
					<cfif len(trim(AsstRefId1))>
						<span class="ui-icon ui-icon-close"></span>
					</cfif>
					<cfif ARef1Acpt_YN EQ "Y">
						<span class="green"><b>A</b></span>
					<cfelseif ARef1Acpt_YN EQ "N">
						<span class="red"><b>D</b></span>
					</cfif>
					<a class="assignLink" href="javascript:void(0);">AR1</a>:
					<span class="assigned">
						<cfif len(trim(AsstRefId1))>
							<cfset refname="#ar1_name#">
							<cfset contactid="#AsstRefId1#">
						<cfelse>
							<cfset refname="">
							<cfset contactid="">
						</cfif>	
						#refname#
					</span>
					<input type="hidden" name="contact_id" value="#contactid#">
				</div>
				<div class="ar2">
					<cfif len(trim(AsstRefId2))>
						<span class="ui-icon ui-icon-close"></span>
					</cfif>
					<cfif ARef2Acpt_YN EQ "Y">
						<span class="green"><b>A</b></span>
					<cfelseif ARef2Acpt_YN EQ "N">
						<span class="red"><b>D</b></span>
					</cfif>
					<a class="assignLink" href="javascript:void(0);">AR2</a>:
					<span class="assigned">
						<cfif len(trim(AsstRefId2))>
							<cfset refname="#ar2_name#">
							<cfset contactid="#AsstRefId2#">
						<cfelse>
							<cfset refname="">
							<cfset contactid="">
						</cfif>	
						#refname#
					</span>
					<input type="hidden" name="contact_id" value="#AsstRefId2#">
				</div>
			</td>
			<td class="tdUnderLine">
				<cfif len(trim(RefScore))>
					#RefScore#
				<cfelse>
					-
				</cfif>
			</td>
			<td class="tdUnderLine">
				#HomeScore#-#VisitorScore#
			</td>
		</tr>
	</cfloop>
<cfelse>
	<tr><td colspan="11"> <!--- only show if query ran --->
			<cfif isDefined("refGameInfo_A")>
				There are no games. 
			</cfif>
		</td>
	</tr>
</cfif>
	</tbody>
</table>
</div>

</div>
</cfoutput>

<cfsavecontent variable="cf_footer_scripts">
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery.tablesorter.min.js"></script>
<script language="JavaScript" type="text/javascript">
$(function(){
	$('input[name=WeekendFrom],input[name=WeekendTo]').datepicker();
	
	$('#gameTable').tablesorter({
		headers:{
			0:{
				sorter:false
			},
			1:{
				sorter:false
			},
			3:{
				sorter:'time'
			},
			7:{
				sorter:false
			}
		},
		sortList:[[2,0],[6,0],[3,0]]
	});
	
	$('.assignLink').click(function(){
		var thisref=$(this).closest('div');
		var xicon='<span class="ui-icon ui-icon-close"></span>';
		//are we assigning a ref, ar1, or ar2?
		var reftype=$(this).parent().hasClass('ref')?'1':($(this).parent().hasClass('ar1')?'2':'3');
		
		var game_id=$(this).closest('tr').find('input[name=game]').val();
		
		var contact_id=$('select[name=RefID] option:selected').val();
		var contact_name=$('select[name=RefID] option:selected').text();
		//alert(reftype + ' ' + game_id + ' ' + contact_id + ' ' + contact_name);
		
		//we've got our values, proceed to ajax commands
		$.ajax({
			data:{
				"officialTypeID":reftype,
				"game_id":game_id,
				"contact_id":contact_id
			},
			dataType:'json',
			success:function(a,b,c){
			//alert('hiiiiii');
				$(thisref).find('.assigned').text(contact_name);
				$(thisref).find('.ui-icon').remove();
				$(thisref).prepend(xicon);
				$(thisref).find('input[name=contact_id]').val(contact_id);
				$(thisref).find('.green,.red').remove();
				
			},
			error:function(a,b,c){
			
			},
			type:'POST',
			url:'async_ref_bulk_assign_action.cfm'
		});
	});
	
	$('.ui-icon-close').on('click',function(){
		//remove ref from assignment
		var thisref=$(this).closest('div');
		
		var reftype=$(this).closest('div').hasClass('ref')?'1':($(this).parent().hasClass('ar1')?'2':'3');
		
		var game_id=$(this).closest('tr').find('input[name=game]').val();
		
		var contact_id=$(this).closest('div').find('input[name=contact_id]').val();
		
		//we've got our values, proceed to ajax commands
		$.ajax({
			data:{
				remove:true,
				officialTypeID:reftype,
				game_id:game_id,
				contact_id:contact_id
			},
			dataType:'json',
			success:function(a,b,c){
				$(thisref).find('.assigned').text('');
				$(thisref).find('.ui-icon').remove();
				$(thisref).find('input[name=contact_id]').val('');
				$(thisref).find('.green,.red').remove();
				
			},
			error:function(a,b,c){
			
			},
			type:'POST',
			url:'async_ref_bulk_assign_action.cfm'
		});
		
	});
	
	$('#sortLink1').click(function(){
		var sorting = [[2,0],[6,0],[3,0]];
		$('#gameTable').trigger("sorton",[sorting]);
	});
	$('#sortLink2').click(function(){
		var sorting = [[2,0],[3,0],[6,0]];
		$('#gameTable').trigger("sorton",[sorting]);
	});
	
	$('#sortLinks').buttonset();
	
});

function submitAnddisable()
{
	$('form[name=Games]').submit();
	$('input[name=SUBMITFORM]').attr('disabled','disabled');
}
function GetGames()
{	self.document.Games.DivId.value =	self.document.Games.DivisionList.value;
//	self.document.Games.Weekend.value =	'';
	//self.document.Games.WeekendFrom.value	= '';
	//self.document.Games.WeekendTo.value		= '';
	self.document.Games.action = "refBulkAssign.cfm";
	self.document.Games.submit();
}
function GetWeekendsListFrom()
{	self.document.Games.WeekendFrom.value	=  self.document.Games.WeekendListFrom.value;
	self.document.Games.action				= "refBulkAssign.cfm";
	self.document.Games.submit();
}
function GetWeekendsListTo()
{	self.document.Games.WeekendTo.value		=	self.document.Games.WeekendListTo.value;
	self.document.Games.action				=	"refBulkAssign.cfm";
	self.document.Games.submit();
}
function SubmitIt()
{	self.document.Games.SUBMITFORM.disabled = true; 
	self.document.Games.SAVE.value = 'save'; 
	self.document.Games.action				=	"refBulkAssign.cfm";
	self.document.Games.submit();
}
</script> 
</cfsavecontent>

<cfinclude template="_footer.cfm">
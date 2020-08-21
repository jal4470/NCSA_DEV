<!--- 
	FileName:	rptAssignmentSet.cfm
	Created on: 11/29/2010
	Created by: B. Cooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">


<cfif isDefined("FORM.chkShowNCSAFields")>
	<cfset showNCSAFields = true >
<cfelse>
	<cfset showNCSAFields = false >
</cfif>

<cfif isDefined("FORM.gamedate")>
	<cfset gamedate = FORM.gamedate >
<cfelse>
	<cfset gamedate = dateFormat(now(),"mm/dd/yyyy") >
</cfif>

<cfif isDefined("FORM.selAgeGroup")>
	<cfset ageGroup = FORM.selAgeGroup >
<cfelse>
	<cfset ageGroup = "" >
</cfif>

<cfif isDefined("FORM.selSetType")>
	<cfset setType = FORM.selSetType >
<cfelse>
	<cfset setType = "" >
</cfif>


<cfstoredproc datasource="#application.dsn#" procedure="p_get_game_sets">
	<cfprocparam cfsqltype="CF_SQL_DATE" dbvarname="@gamedate" type="In" value="#gamedate#">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@ageGroup" type="In" value="#ageGroup#" null="#yesnoformat(ageGroup EQ "")#">
	<cfprocparam cfsqltype="CF_SQL_BIT" dbvarname="@showNCSAFields" type="In" value="#showNCSAFields#">
	<cfprocresult resultset="1" name="qryGames">
</cfstoredproc>

<!--- filter by set type --->
<cfif setType NEQ "">
	<cfquery dbtype="query" name="qryGames">
		select * from qryGames
		where set_count
		<cfif listfindnocase("1,2,3,4,5",setType) NEQ 0>
		=#setType#
		<cfelse>
		>5
		</cfif>
	</cfquery>
</cfif>

<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
	<style type="text/css">
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
<cfhtmlhead text="#custom_css#">

<H1 class="pageheading">NCSA - Assignment Set Report</H1>
<FORM name="Games" action="rptAssignmentSet.cfm"  method="post" ID="Games">
<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%" >
	<TR>
		<TD>
			<B>Select Date</B> &nbsp;
			<INPUT name="gamedate" value="#VARIABLES.gamedate#" size="9">
		</td>
	</tr>
	<TR>
		<TD>
			<B>Show NCSA Field Games</B>
			<INPUT type="Checkbox" name="chkShowNCSAFields" <cfif showNCSAFields>checked="checked"</cfif> value="1"> 
			&nbsp;&nbsp;&nbsp;
			<b>Age Grouping</b>
			<select name="selAgeGroup">
				<option value="all">All Games</option>
				<option value="fullside" <cfif ageGroup EQ "fullside">selected="selected"</cfif>>Full Sided</option>
				<option value="smallside" <cfif ageGroup EQ "smallside">selected="selected"</cfif>>Small Sided</option>
			</select>
			&nbsp;&nbsp;&nbsp;
			<b>Type of Set</b>
			<select name="selSetType">
				<option value="">All Games</option>
				<option value="1" <cfif setType EQ "1">selected="selected"</cfif>>Single Games</option>
				<option value="2" <cfif setType EQ "2">selected="selected"</cfif>>2 Game Sets</option>
				<option value="3" <cfif setType EQ "3">selected="selected"</cfif>>3 Game Sets</option>
				<option value="4" <cfif setType EQ "4">selected="selected"</cfif>>4 Game Sets</option>
				<option value="5" <cfif setType EQ "5">selected="selected"</cfif>>5 Game Sets</option>
				<option value="5+" <cfif setType EQ "5+">selected="selected"</cfif>>Over 5 Game Sets</option>
			</select>
			&nbsp;&nbsp;&nbsp;
			<input type="SUBMIT" name="Go"  value="Get Games" >
		</td>
	</tr>
</table>
</form>


<h3>Sort by:</h3>
<div id="sortLinks" style="font-size:10px; margin:0 0 10px 0;">
	<input type="radio" id="sortLink1" name="radio" checked="checked" /><label for="sortLink1">Set-Time-Field</label>
	<input type="radio" id="sortLink2" name="radio" /><label for="sortLink2">Field-Set-Time</label>
</div>

<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%" id="gameTable">
	<thead>
	<tr class="tblHeading">
		<th>Set ID</th>
		<th>Game Type</th>
		<th>Date/Time</th>
		<th>Game ##</th>
		<th>Division</th>
		<th>Set Size</th>
		<th>Set Start Time</th>
		<th>Field</th>
		<th>Teams</th>
	</TR>
	</thead>
	<tbody>
	<cfif qryGames.RecordCount GT 0>
		<CFLOOP query="qryGames">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentrow)#">
				<TD class="tdUnderLine">#set_id#</TD>
				<TD class="tdUnderLine">#type#</TD>
				<TD class="tdUnderLine">#dateFormat(GAME_DATE,"mm/dd/yyyy")# #timeFormat(GAME_TIME,"hh:mm tt")#</TD>
				<TD class="tdUnderLine">#game#</TD>
				<TD class="tdUnderLine">#DIVISION#</TD>
				<td class="tdUnderLine">#set_count#</td>
				<td class="tdUnderLine">#dateformat(GAME_DATE, "mm/dd/yyyy")# #timeformat(set_start_time, "h:mm tt")#</td>
				<td class="tdUnderLine">#field#</td>
				<TD class="tdUnderLine">Home:#Home_Teamname#<br>
					Visitor: #Visitor_Teamname#</TD>
			</TR>
		</CFLOOP>
	<cfelse>
		<!--- Added Blank Row w/ no record counts to prevent tablesorter from breaking --->
		<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></tr>
	</cfif>
	</tbody>	
</table>

</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">
	<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
	<script language="JavaScript" type="text/javascript" src="assets/jquery.tablesorter.min.js"></script>
	<script language="JavaScript" type="text/javascript">
		$(function(){
			$('input[name=gamedate]').datepicker();
			
			$('#sortLink1').click(function(){
				var sorting = [[5,0],[6,0],[7,0],[0,0],[2,0]];
				$('#gameTable').trigger("sorton",[sorting]);
			});
			$('#sortLink2').click(function(){
				var sorting = [[7,0],[5,0],[6,0],[0,0],[2,0]];
				$('#gameTable').trigger("sorton",[sorting]);
			});
			
			$('#sortLinks').buttonset();

			$('#gameTable').tablesorter({
				headers:{
					// 8:{
					// 	sorter:false
					// }
				},
				sortList:[[5,0],[6,0],[7,0],[0,0],[2,0]],
				debug:false
			});
		});
	</script>
</cfsavecontent>

<cfinclude template="_footer.cfm">

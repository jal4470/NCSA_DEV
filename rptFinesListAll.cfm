<!--- 
	FileName:	rptFinesListAll.cfm
	Created on: 02/26/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
06/16/17 - mgreenberg (TICKET NCSA22821) - report mods: updated datepicker and sorter.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 

<cfif isDefined("FORM.StartDate")>
	<cfset StartDate = dateFormat(FORM.StartDate,"mm/dd/yyyy") > 
<cfelse>
	<cfset StartDate = "" > 
</CFIF>

<cfif isDefined("FORM.EndDate")>
	<cfset EndDate   = dateFormat(FORM.EndDate,"mm/dd/yyyy") >
<cfelse>
	<cfset EndDate   = "" >
</CFIF>

<CFIF isDefined("FORM.selFineStatus")>
	<cfset selFineStatus = FORM.selFineStatus>
<CFELSE>
	<cfset selFineStatus = "N">
</CFIF>

<cfif isDefined("FORM.sortBy")>
	<cfset sortBy = FORM.sortBy >
<cfelse>
	<cfset sortBy = "2" >
</cfif>

<cfif isDefined("form.sortType")>
	<cfset sortType = form.sortType>
<cfelseif isDefined("url.sortBy")>
	<cfset sortType = url.sortType>
<cfelse>
	<cfset sortType = "">
</cfif>

<cfif isDefined("form.season_select")>
	<cfset season_select = form.season_select>
<cfelseif isDefined("url.season_select")>
	<cfset season_select = url.season_select>
<cfelse>
	<cfset season_select = SESSION.CURRENTSEASON.ID>
</cfif>

<cfif isDefined("form.club_select")>
	<cfset club_select = form.club_select>
<cfelseif isDefined("url.club_select")>
	<cfset club_select = url.club_select>
<cfelse>
	<cfif isDefined("SESSION.USER.CLUBID")>
		<cfset club_select = SESSION.USER.CLUBID>
	<cfelse>
		<cfset club_select = "">
	</cfif>
</cfif>


<cfset TypeAll		= "" >
<cfset TypePaid		= "" >
<cfset TypeUnPaid	= "" >
<cfset TypeInvoiced	= "" >
<cfset TypeWaived	 = "" >
<cfset TypeDelete 	 = "" >
<cfset TypeAppealed	 = "" >
<cfset TypeNoInvoice = "" >

<!--- <cfswitch expression="#UCASE(selFineStatus)#">
	<cfcase value="P"> <cfset TypePaid 	   ="checked" > </cfcase>
	<cfcase value="U"> <cfset TypeUnPaid   ="checked" > </cfcase>
	<cfcase value="I"> <cfset TypeInvoiced ="checked" > </cfcase>
	<cfcase value="W"> <cfset TypeWaived   ="checked" > </cfcase>
	<cfcase value="D"> <cfset TypeDelete   ="checked" > </cfcase>
	<cfcase value="E"> <cfset TypeAppealed ="checked" > </cfcase>
	<cfcase value="A"> <cfset TypeAll	   ="checked" > </cfcase>
	<cfdefaultcase>    <cfset TypeNoInvoice ="checked" > </cfdefaultcase>
</cfswitch> --->

<cfset holdClubID	= "" >
<cfset Where_ClubSel= "" >
<cfset TotalPaid	= 0 >
<cfset TotalUnPaid	= 0 >
<cfset TotalInvoiced= 0 >
<cfset TotalWaived	= 0 >
<cfset TotalDelete	= 0 >
<cfset TotalAppealed= 0 >
<cfset TotalAmount	= 0 >
<cfset GameCount	= 0 >


<cfquery name="getSeasons" datasource="#SESSION.DSN#">
select * from tbl_season order by season_id asc
</cfquery>

<cfif StartDate EQ "" and NOT isDefined("form.StartDate")>
	<cfloop query="getSeasons">
		<cfif getSeasons.currentSeason_YN EQ "Y">
			<cfset StartDate = dateFormat(getSeasons.season_startDate,"mm/dd/yyyy")>
			<cfset EndDate = dateFormat(getSeasons.season_endDate,"mm/dd/yyyy") >
		</cfif>
	</cfloop>
</cfif>

<cfinvoke component="#SESSION.SITEVARS.cfcPath#FINEFEES" method="getFines" returnvariable="getFines">
	<cfinvokeargument name="FineStatus" value="#selFineStatus#"> 
	<!--- <cfinvokeargument name="clubID"     value="#SESSION.USER.CLUBID#">  --->
	<cfif club_select EQ "">
	<cfinvokeargument name="clubID"     value="#SESSION.USER.CLUBID#"> 
	<cfelse>
	<cfinvokeargument name="clubID"     value="#club_select#"> 
	</cfif>
	<cfif season_select NEQ "">
	<cfinvokeargument name="seasonID" value="#season_select#">
	</cfif>
	<cfif StartDate NEQ "" and EndDate NEQ "">
		<cfinvokeargument name="StartDate" value="#StartDate#"> 
		<cfinvokeargument name="EndDate" value="#EndDate#"> 
	</cfif>
</cfinvoke>  <!--- <cfdump var="#getFines#"> --->

<cfswitch expression="#sortBy#">
	<cfcase value="1">	<cfset orderByCol = "fine_ID" ></cfcase>
	<cfcase value="2">	<cfset orderByCol = "Game_ID" ></cfcase>
	<cfcase value="3">	<cfset orderByCol = "Club_Name" ></cfcase>
	<cfcase value="4">	<cfset orderByCol = "TeamName" ></cfcase>
	<cfcase value="5">	<cfset orderByCol = "FineDateCreated" ></cfcase>
	<cfcase value="6">		<cfset orderByCol = "CreatedBy" ></cfcase>
	<cfcase value="7">	<cfset orderByCol = "Amount" ></cfcase>
	<cfcase value="8">	<cfset orderByCol = "Status" ></cfcase>
	<cfcase value="9">	<cfset orderByCol = "Description" ></cfcase>
	<cfdefaultcase> 		<cfset orderByCol = "Club_Name" >	</cfdefaultcase>
</cfswitch>

<cfquery name="getFines" dbtype="query">
	select * from getFines
	order by #orderByCol# #SortType#
</cfquery>


<cfquery name="getClubs" datasource="#SESSION.DSN#">
select club_id, club_name 
from tbl_club 
order by club_name ASC
</cfquery>

<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfsavecontent variable="custom_css">
  <link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<cfoutput>
<div id="contentText">

<H1 class="pageheading">
	NCSA - Add/Edit Assessed Fines
	<cfif isDefined("getFines") AND getFines.RecordCount GT 0>
		<input id="printBtn" type="button" value="Print Report" />
		<input id="printBtnXls" type="button" value="Download Report" />
	</cfif>
</H1>
<!--- <br>  --->


<FORM name="Fines" id="Fines" action="rptFinesListAll.cfm"  method="post">
<input type="hidden" name="FineId" value="">
<input type="hidden" name="Mode"   value="">
<input type="hidden" name="sortBy" id="sortBy" value="#sortBy#" />
<input type="hidden" name="sortType" id="sortType" value="#sortType#" />
<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
	<TR>
	<td>
	
	<strong>Season: </strong>
	<select name="season_select" id="season_select" >
	<option value="">All Seasons</option>
	<cfloop query="getSeasons">
	<option value="#season_id#"<cfif season_id EQ season_select > selected="selected"</cfif>>#seasonCode#</option>
	</cfloop>
	</select>
	</td>
	
	<cfif SESSION.USER.CLUBID LT 2>
	<td>
	<strong>Club: </strong>
	<select name="club_select" onchange="FilterEvents();">
		<option value="">All Clubs</option>
	<cfloop query="getClubs">
		<option value="#getClubs.club_id#" <cfif club_select EQ getClubs.club_id> selected="selected"</cfif>>#getClubs.club_name#</option>
	</cfloop>
	</select>
	</td>
	</cfif>
	
	<td>
			<b>Filter Fines:</b>
			<select name="selFineStatus">
				<option value="A" <cfif selFineStatus EQ "A">selected</cfif> >All</option>
				<option value="N" <cfif selFineStatus EQ "N">selected</cfif> >All but Invoiced & Deleted</option>
				<option value="P" <cfif selFineStatus EQ "P">selected</cfif> >Paid</option>
				<option value="U" <cfif selFineStatus EQ "U">selected</cfif> >UnPaid</option>
				<option value="I" <cfif selFineStatus EQ "I">selected</cfif> >Invoiced</option>
				<option value="W" <cfif selFineStatus EQ "W">selected</cfif> >Waived</option>
				<option value="D" <cfif selFineStatus EQ "D">selected</cfif> >Deleted</option>
				<option value="E" <cfif selFineStatus EQ "E">selected</cfif> >Appealed</option>
			</select>
				<!--- 	<input type="Radio" maxlength="1" name="selFineStatus" onclick="FilterEvents()" value="A" #TypeAll# > 		All
				 &nbsp; <input type="Radio" maxlength="1" name="selFineStatus" onclick="FilterEvents()" value="N" #TypeNoInvoice# > 	All but Invoiced & Deleted
				 &nbsp; <input type="Radio" maxlength="1" name="selFineStatus" onclick="FilterEvents()" value="P" #TypePaid# >		Paid
				 &nbsp; <input type="Radio" maxlength="1" name="selFineStatus" onclick="FilterEvents()" value="U" #TypeUnPaid# >		UnPaid
				 &nbsp; <input type="Radio" maxlength="1" name="selFineStatus" onclick="FilterEvents()" value="I" #TypeInvoiced# >	Invoiced
				 &nbsp; <input type="Radio" maxlength="1" name="selFineStatus" onclick="FilterEvents()" value="W" #TypeWaived# >		Waived
				 &nbsp; <input type="Radio" maxlength="1" name="selFineStatus" onclick="FilterEvents()" value="D" #TypeDelete# >		Deleted
				 &nbsp; <input type="Radio" maxlength="1" name="selFineStatus" onclick="FilterEvents()" value="E" #TypeAppealed# >	Appealed 
				--->
				</td>
	</TR>
	</table>
<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
	<tr>
	
	<td>
	<strong>Start Date: </strong>
	<input type="text" name="StartDate" value="#StartDate#" />
	<strong>End Date: </strong>
	<input type="text" name="EndDate" value="#EndDate#" />
	</td>
		<td>
			<INPUT type="Submit" name="getFines" value="Go">
	</td>
	</tr>
	</table>
<table cellspacing="0" cellpadding="5" align="center" border="0" width="795px">
<!---	
--->	<tr class="tblHeading" style="cursor: pointer;">
		<TD width="25" onclick="reSort(1);">			 <b>Fine</b>		</TD>
		<TD width="35" onclick="reSort(2);">			 <b>Game</b>	</TD>
		<TD width="110" onclick="reSort(3);">			 <b>Club</b>	</TD>
		<TD width="110" onclick="reSort(4);">			 <b>Team Fined</b>	</TD>
		<TD width="155" onclick="reSort(5);">			 <b>Fine		</b></TD>
		<TD width="110" onclick="reSort(6);" align=center><b>By	</b></TD>
		<TD width="45" onclick="reSort(7);">			 <b>Dated	</b></TD>
		<TD width="50" onclick="reSort(8);" align=right> <b>Amount	</b></TD>
		<TD width="45" onclick="reSort(9);" align=center><b>Status	</b></TD>
		<TD width="10" align=center>&nbsp;</TD>
	</TR>
</table>

<div style="overflow:auto;height:450px;border:1px ##cccccc solid;">
<table cellspacing="0" cellpadding="5" align="left" border="0" width="775px">
	<CFLOOP query="getFines">
		<cfset StatusText = "">
		<CFIF len(trim(AMOUNT)) LT 1>
			<CFSET fineAmount = 0>
		<CFELSE>
			<CFSET fineAmount = AMOUNT>
		</CFIF>
		<cfswitch expression="#UCASE(Status)#">
			<cfcase value="P">
				<cfset TotalPaid = TotalPaid + fineAmount>
				<cfset StatusText = "<font color=blue> Paid </font>">
			</cfcase>
			<cfcase value="W">
				<cfset TotalWaived = TotalWaived + fineAmount>
				<cfset StatusText = "<font color=Green> Waived </font>">
			</cfcase>
			<cfcase value="D">
				<cfset TotalDelete = TotalDelete + fineAmount>
				<cfset StatusText = " Deleted ">
			</cfcase>
			<cfcase value="I">
				<cfset TotalInvoiced = TotalInvoiced + fineAmount>
				<cfset StatusText = "<font color=red> Invoiced </font>">
			</cfcase>
			<cfcase value="E">
				<cfset TotalAppealed = TotalAppealed + fineAmount>
				<cfset StatusText = "<font color=Brown> Appealed </font>">
			</cfcase>
			<cfcase value="U">
				<cfset TotalUnpaid = TotalUnpaid + fineAmount>
				<cfset StatusText = "<font color=orange> Unpaid </font>">
			</cfcase>
			<cfdefaultcase>
				<cfset TotalUnpaid = TotalUnpaid + fineAmount>
				<cfset StatusText = "<font color=orange> Unpaid </font>">
			</cfdefaultcase>
		</cfswitch>

		<cfset GameCount = GameCount + 1>
		<cfset RecPrinted = "">
		<cfset TotalAmount = TotalAmount + fineAmount >


		<cfif len(trim(Comments))>
			<cfset swComments = true>
			<cfset tdClass = "">
		<cfelse>	
			<cfset swComments = false>
			<cfset tdClass = "class='tdUnderLine'">
		</cfif>

		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#" >
			<TD width="25" class="tdUnderLine" valign="top">  #FINE_Id#					</TD>
			<TD width="35" class="tdUnderLine" valign="top">  <cfif GAME_ID GT 0>#Game_id#<cfelse>&nbsp;</cfif></TD>
			<TD width="110" class="tdUnderLine" valign="top">  
			#(Club_Name)#
				</TD>
			<TD width="110" class="tdUnderLine" valign="top">  #TeamName#	&nbsp;	</TD>
			<td width="155" class="tdUnderLine" valign="top">  #Description#				&nbsp;</TD>
			<TD width="110" class="tdUnderLine" valign="top" align=center>  #AddByUser#	&nbsp;</TD><!--- CreatedBy --->
			<TD width="45" class="tdUnderLine" valign="top" align=center>
				<CFIF datediff("d", FineDateCreated, now()) GT 30>
					<span class="red">#dateFormat(FineDateCreated,"mm/dd/yy")#</span>
				<cfelse>
					#dateFormat(FineDateCreated,"mm/dd/yy")#
				</CFIF> 
			</TD>
			<td width="50" class="tdUnderLine" valign="top" align=right> $#fineAmount#</TD>
			<td width="45" class="tdUnderLine" valign="top" align=center> #StatusText#</TD>
		</tr>
		  <cfif  len(trim(Comments))>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#" >
					<TD colspan="2" class="tdUnderLine" valign="top">&nbsp;   </TD>
					<TD colspan="4" class="tdUnderLine" valign="top">  <b>Comments:</b> #Comments# </TD>
					<TD colspan="3" class="tdUnderLine" valign="top">&nbsp;   </TD>
				</tr>
		  	 
		  </cfif>
	</CFLOOP>
	<cfif getFines.RECORDCOUNT>
		<TR><TD colspan="5" align=right> <font color=blue>	Total Paid		</FONT></TD>
			<TD colspan="2" align=right> <font color=blue>	$#TotalPaid#	</font></TD>
			<TD align=center>&nbsp;			 									   </TD>
		</TR>
		<TR><TD colspan="5" align=right> <font color=orange> Total UnPaid	</FONT></TD>
			<TD colspan="2" align=right> <font color=orange> $#TotalUnPaid#	</font></TD>
			<TD align=center>&nbsp;			 										</TD>
		</TR>
		<TR><TD colspan="5" align=right> <font color=red>	Total Invoiced	 </FONT></TD>
			<TD colspan="2" align=right> <font color=red>	$#TotalInvoiced# </font></TD>
			<TD align=center>&nbsp;			 										</TD>
		</TR>
		<TR><TD colspan="5" align=right> <font color=green>	Total Waived	</FONT></TD>
			<TD colspan="2" align=right> <font color=green>	$#TotalWaived#	</font></TD>
			<TD align=center>&nbsp;			 										</TD>
		</TR>
		<TR><TD colspan="5" align=right> <font color=black>	Total Deleted	</FONT></TD>
			<TD colspan="2" align=right> <font color=black> $#TotalDelete#	</font></TD>
			<TD align=center>&nbsp;			 										</TD>
		</TR>
		<TR><TD colspan="5" align=right> <font color=brown>	Total Appealed	 </FONT></TD>
			<TD colspan="2" align=right> <font color=brown>	$#TotalAppealed# </font></TD>
			<TD align=center>&nbsp;			 										</TD>
		</TR>
	</cfif>
</TABLE>
</div>
</FORM>

	
	
</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">
<cfoutput>
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=StartDate],input[name=EndDate]').datepicker();
		
		$("##printBtn").click(function () {
			window.open('rptFinesListAll_PDF.cfm?StartDate=#StartDate#&EndDate=#EndDate#&selFineStatus=#selFineStatus#&sortBy=#sortBy#&sortType=#sortType#&season_select=#season_select#&club_select=#club_select#');
		});
		$("##printBtnXls").click(function () {
			window.open('rptFinesListAll_CSV.cfm?StartDate=#StartDate#&EndDate=#EndDate#&selFineStatus=#selFineStatus#&sortBy=#sortBy#&sortType=#sortType#&season_select=#season_select#&club_select=#club_select#');
		});
	});

	function reSort(num)
	{
		if (num > 0 && num < 10)
		{
			if (document.getElementById('sortBy').value == num)
			{
				if (document.getElementById('sortType').value == "ASC")
				{
					document.getElementById('sortType').value = "DESC";
				}
				else
				{
					document.getElementById('sortType').value = "ASC";
				}
			}
			else
			{
				document.getElementById('sortType').value = "ASC";
			}
			
			document.getElementById('sortBy').value = num;
			
			$('##Fines').submit();
		}
	}

function FilterEvents()
{	self.document.Fines.action = "rptFinesListAll.cfm";
	self.document.Fines.submit();
}

</script>
</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">

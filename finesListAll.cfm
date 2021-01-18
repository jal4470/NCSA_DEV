<!--- 
	FileName:	homesite+\html\finesListAll.cfm
	Created on: 10/13/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

05/22/2017 - apinzone - removed jquery 1.4.2, moved javascript to bottom of page and wrapped in cfsavecontent

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfsavecontent variable="jqueryUI_CSS">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css"> 	
</cfsavecontent>
<cfhtmlhead text="#jqueryUI_CSS#">

<cfoutput>
<div id="contentText">

<cfset menu_id = 81>

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
	<cfset selFineStatus = "">
</CFIF>

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

<cfif isDefined("form.season_select")>
	<cfset season_select = form.season_select>
<cfelseif isDefined("url.season_select")>
	<cfset season_select = url.season_select>
<cfelse>
	<cfset season_select = "">
</cfif>

<cfif isDefined("form.sortBy")>
	<cfset sortBy = form.sortBy>
<cfelseif isDefined("url.sortBy")>
	<cfset sortBy = url.sortBy>
<cfelse>
	<cfset sortBy = "">
</cfif>

<cfif isDefined("form.sortType")>
	<cfset sortType = form.sortType>
<cfelseif isDefined("url.sortBy")>
	<cfset sortType = url.sortType>
<cfelse>
	<cfset sortType = "">
</cfif>

<cfset TypeAll		= "" >
<cfset TypePaid		= "" >
<cfset TypeUnPaid	= "" >
<cfset TypeInvoiced	= "" >
<cfset TypeWaived	 = "" >
<cfset TypeDelete 	 = "" >
<cfset TypeAppealed	 = "" >
<cfset TypeNoInvoice = "" >

<cfswitch expression="#UCASE(selFineStatus)#">
	<cfcase value="P"> <cfset TypePaid 	   ="checked" > </cfcase>
	<cfcase value="U"> <cfset TypeUnPaid   ="checked" > </cfcase>
	<cfcase value="I"> <cfset TypeInvoiced ="checked" > </cfcase>
	<cfcase value="W"> <cfset TypeWaived   ="checked" > </cfcase>
	<cfcase value="D"> <cfset TypeDelete   ="checked" > </cfcase>
	<cfcase value="E"> <cfset TypeAppealed ="checked" > </cfcase>
	<cfcase value="A"> <cfset TypeAll	   ="checked" > </cfcase>
	<cfdefaultcase> <cfset TypeNoInvoice   ="checked" > </cfdefaultcase>
</cfswitch>

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

<!--- get roles for this menu --->
<cfinvoke
	component="#session.sitevars.cfcpath#.menu"
	method="getMenuRoles"
	menu_id="#menu_id#"
	returnvariable="menuRoles">
<cfset menuList=valuelist(menuRoles.role_id)>

<cfif listFind(menuList,SESSION.MENUROLEID)>
		<cfset swAllowAdd = true>
		<cfset TargetPage = "fineEdit.cfm" >
		<!--- 	1=ASSTADMIN		2=PRESIDENT		3=VICEPRES		4=SECRETARY		5=TREASURER		6=DIVCOMMB01	
				7=DIVCOMMB02	8=DIVCOMMB03	9=DIVCOMMB04	10=DIVCOMMB05	11=DIVCOMMB06	12=DIVCOMMG01	
				13=DIVCOMMG02	14=DIVCOMMG03	15=DIVCOMMG04	16=DIVCOMMG05	17=DIVCOMMG06	18=RULESCHAIR	
				19=GAMESCHAIR	20=GAMECONDCH	21=REFDEVELCO	22=NYREFASSNR	23=NJREFASSNR	24=REFASSNRCO	
				25=REFEREE		26=CLUBPRES		27=CLUBREP		28=CLUBALTREP	59=SYSTADMIN		 --->
<cfelse>
		<cfset swAllowAdd = false>
		<cfset TargetPage = "fineDisplay.cfm" >
</cfif>

<!---
<cfswitch expression="#SESSION.MENUROLEID#">
	<cfcase value="1,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,59" delimiters=",">
		<cfset swAllowAdd = true>
		<cfset TargetPage = "fineEdit.cfm" >
		<!--- 	1=ASSTADMIN		2=PRESIDENT		3=VICEPRES		4=SECRETARY		5=TREASURER		6=DIVCOMMB01	
				7=DIVCOMMB02	8=DIVCOMMB03	9=DIVCOMMB04	10=DIVCOMMB05	11=DIVCOMMB06	12=DIVCOMMG01	
				13=DIVCOMMG02	14=DIVCOMMG03	15=DIVCOMMG04	16=DIVCOMMG05	17=DIVCOMMG06	18=RULESCHAIR	
				19=GAMESCHAIR	20=GAMECONDCH	21=REFDEVELCO	22=NYREFASSNR	23=NJREFASSNR	24=REFASSNRCO	
				25=REFEREE		26=CLUBPRES		27=CLUBREP		28=CLUBALTREP	59=SYSTADMIN		 --->
	</cfcase>
	<cfdefaultcase>
		<cfset swAllowAdd = false>
		<cfset TargetPage = "fineDisplay.cfm" >
	</cfdefaultcase>
</cfswitch>
--->
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
	<cfif club_select EQ "">
	<cfinvokeargument name="clubID"     value="#SESSION.USER.CLUBID#"> 
	<cfelse>
	<cfinvokeargument name="clubID"     value="#club_select#"> 
	</cfif>
	<cfif season_select NEQ "">
	<cfinvokeargument name="seasonID" value="#season_select#"> 
	</cfif>
	<cfif sortBy NEQ "">
	<cfinvokeargument name="sortBy" value="#sortBy#">
	<cfinvokeargument name="sortType" value="#sortType#">
	</cfif>
	<cfif StartDate NEQ "" and EndDate NEQ "">
	<cfinvokeargument name="StartDate" value="#StartDate#"> 
	<cfinvokeargument name="EndDate" value="#EndDate#"> 
	</cfif>
</cfinvoke>

<cfquery name="getClubs" datasource="#SESSION.DSN#">
select club_id, club_name from tbl_club order by club_name ASC
</cfquery>

<FORM name="Fines" action="#TargetPage#"  method="post">
<input type="hidden" name="FineId" value="">
<input type="hidden" name="Mode"   value="">
<input type="hidden" name="sortBy" id="sortBy" value="#sortBy#" />
<input type="hidden" name="sortType" id="sortType" value="#sortType#" />
		

<H1 class="pageheading">NCSA - Add/Edit Assessed Fines <cfif swAllowAdd><input type="Submit" name="addFine" value="Add a Fine"></cfif></H1>
<br> <!--- <h2>yyyyyy </h2> --->

<table cellspacing="0" cellpadding="5" align="center" border="0" width="795px">

	<TR>
	<td>
	
	<strong>Season: </strong><br /><br />
	<select name="season_select" id="season_select" onchange="seasonSelect()">
	<option value="">All Seasons</option>
	<cfloop query="getSeasons">
	<option value="#season_id#"<cfif season_id EQ season_select > selected="selected"</cfif>>#seasonCode#</option>
	</cfloop>
	</select>
	</td>
	<cfif SESSION.USER.CLUBID LT 2>
	<td>
	<strong>Club: </strong><br /><br />
	<select name="club_select" onchange="FilterEvents();">
		<option value="">All Clubs</option>
	<cfloop query="getClubs">
		<option value="#getClubs.club_id#" <cfif club_select EQ getClubs.club_id> selected="selected"</cfif>>#getClubs.club_name#</option>
	</cfloop>
	</select>
	</td>
	</cfif>
	<td>
	<strong>Start Date: </strong><br /><br />
	<input type="text" name="StartDate" value="#StartDate#" />
	</td>
	<td>
	<strong>End Date: </strong><br /><br />
	<input type="text" name="EndDate" value="#EndDate#" />
	</td>
	</TR>
</table>
<table cellspacing="0" cellpadding="5" align="center" border="0" width="795px">
<TR>
		<td>
		
			<b>Filter Fines:</b><br /><br />
				<input type="Radio" maxlength="1" name="selFineStatus" onclick="FilterEvents()" value="A" #TypeAll# > 		All
				<input type="Radio" maxlength="1" name="selFineStatus" onclick="FilterEvents()" value="N" #TypeNoInvoice# > All but Invoiced & Deleted
				<input type="Radio" maxlength="1" name="selFineStatus" onclick="FilterEvents()" value="P" #TypePaid# >		Paid
				<input type="Radio" maxlength="1" name="selFineStatus" onclick="FilterEvents()" value="U" #TypeUnPaid# >	UnPaid
				<input type="Radio" maxlength="1" name="selFineStatus" onclick="FilterEvents()" value="I" #TypeInvoiced# >	Invoiced
				<input type="Radio" maxlength="1" name="selFineStatus" onclick="FilterEvents()" value="W" #TypeWaived# >	Waived
				<input type="Radio" maxlength="1" name="selFineStatus" onclick="FilterEvents()" value="D" #TypeDelete# >	Deleted
				<input type="Radio" maxlength="1" name="selFineStatus" onclick="FilterEvents()" value="E" #TypeAppealed# >	Appealed
				</td>
		<td align="right" valign="bottom">
			<input type="button" onclick="FilterEvents()" value="Search" />
		</td>
	</TR>
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

<div style="overflow:scroll;height:450px;border:1px ##cccccc solid; width: 795px;">
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

			<!--- Select case uCase(Trim(AddByUser))
				case "ASSTADMIN"		FinedByUser = "ADMIN"
				case "GAMESCHAIRMAN"	FinedByUser = "GMCHR"
				case "GAMESCONDUCT"		FinedByUser = "GMCND"
				case "AUTO"				FinedByUser = "AUTO"
				case else				FinedByUser = "OTHER"
			End Select --->

		<cfset GameCount = GameCount + 1>
		<cfset RecPrinted = "">
		<cfset TotalAmount = TotalAmount + fineAmount >
		
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#" onclick="SubmitForm(#FINE_Id#)"	onmouseover="this.style.cursor='pointer'" 	>
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
	</CFLOOP>

	<TR><TD colspan="4" align=right> <font color=blue>	Total Paid		</FONT></TD>
		<TD colspan="2" align=right> <font color=blue>	$#TotalPaid#	</font></TD>
		<TD align=center>&nbsp;			 										</TD>
	</TR>
	<TR><TD colspan="4" align=right> <font color=orange> Total UnPaid	</FONT></TD>
		<TD colspan="2" align=right> <font color=orange> $#TotalUnPaid#	</font></TD>
		<TD align=center>&nbsp;			 										</TD>
	</TR>
	<TR><TD colspan="4" align=right> <font color=red>	Total Invoiced	 </FONT></TD>
		<TD colspan="2" align=right> <font color=red>	$#TotalInvoiced# </font></TD>
		<TD align=center>&nbsp;			 										</TD>
	</TR>
	<TR><TD colspan="4" align=right> <font color=green>	Total Waived	</FONT></TD>
		<TD colspan="2" align=right> <font color=green>	$#TotalWaived#	</font></TD>
		<TD align=center>&nbsp;			 										</TD>
	</TR>
	<TR><TD colspan="4" align=right> <font color=black>	Total Deleted	</FONT></TD>
		<TD colspan="2" align=right> <font color=black> $#TotalDelete#	</font></TD>
		<TD align=center>&nbsp;			 										</TD>
	</TR>
	<TR><TD colspan="4" align=right> <font color=brown>	Total Appealed	 </FONT></TD>
		<TD colspan="2" align=right> <font color=brown>	$#TotalAppealed# </font></TD>
		<TD align=center>&nbsp;			 										</TD>
	</TR>
</TABLE>
</div>
</FORM>
	
</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript">
$(function(){
	$('input[name=StartDate],input[name=EndDate]').datepicker();
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
		
		FilterEvents();
	}
}
function seasonSelect()
{
	$('input[name=StartDate]').val("");
	$('input[name=EndDate]').val("");
	FilterEvents();
}
function FilterEvents()
{	self.document.Fines.action = "finesListAll.cfm";
	self.document.Fines.submit();
}
function SubmitForm(id)
{	self.document.Fines.FineId.value = id;
	self.document.Fines.Mode.value   = "EDIT";
	self.document.Fines.submit();	
}
</script>	
</cfsavecontent>

<cfinclude template="_footer.cfm">

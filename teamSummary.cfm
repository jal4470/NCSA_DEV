<!--- 
	FileName:	teamSummary.cfm
	Created on: 09/19/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
- 6/29/2011, J. Oriente (ticket 10912)
	> updated non-NY fee1 from 355 to 455
	> updated non-NY fee2 from 305 to 355
- 7/14/2011, J. Oriente (ticket 8068)
	> removed alternate fees for NY clubs. Now all clubs pay the same rates.	
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Teams/Payment Summary</H1>
<br> <!--- <h2>yyyyyy </h2> --->

<CFIF isDefined("SESSION.REGSEASON")>
	<CFSET displaySeason = SESSION.REGSEASON.SF & " " & SESSION.REGSEASON.YEAR>
	<CFSET SF = SESSION.REGSEASON.SF>
	<CFSET seasonID = SESSION.REGSEASON.ID>
<CFELSE>
	<CFSET displaySeason = SESSION.CURRENTSEASON.SF & " " & SESSION.CURRENTSEASON.YEAR>
	<CFSET SF = SESSION.CURRENTSEASON.SF>
	<CFSET seasonID = SESSION.CURRENTSEASON.ID>
</CFIF>

<CFIF isDefined("URL.cid")>
	<CFSET clubID = URL.cid >
<CFELSEIF isDefined("FORM.clubID")>
	<CFSET clubID = FORM.clubID >
<CFELSEIF isDefined("SESSION.USER.clubID")>
	<CFSET clubID = SESSION.USER.clubID >
<CFELSE>
	<CFSET clubID = 0 >
</CFIF>

<CFIF isDefined("URL.p")>
	<CFSET backPage = URL.p >
<CFELSEIF isDefined("FORM.backPage")>
	<CFSET backPage = FORM.backPage >
<CFELSE>
	<CFSET backPage = "teamSummary" >
</CFIF>

<CFIF isDefined("FORM.BACK")>  
	<CFLOCATION url="#VARIABLES.backpage#.cfm">
</CFIF>

<CFIF isDefined("FORM.SAVE")>
	<cfset ClubId	 = FORM.ClubID>
	<cfset TotalU10YoungerTeams = FORM.TotalU10YoungerTeams >
	<cfset Total11Thru14Teams   = FORM.Total11Thru14Teams >
	<cfset Total15thru19Teams   = FORM.Total15thru19Teams >
	<cfset Bond	 = FORM.Bond>

	<CFQUERY name="updateXCS" datasource="#SESSION.DSN#">
		Update XREF_CLUB_SEASON
		   SET TotalU10YoungerTeams = #VARIABLES.TotalU10YoungerTeams#
		     , Total11Thru14Teams   = #VARIABLES.Total11Thru14Teams#
			 , Total15thru19Teams   = #VARIABLES.Total15thru19Teams#
			 , Bond_YN				= '#VARIABLES.Bond#'
			 , UpdateDate			= getDate()
			 , UpdatedBy			= #SESSION.USER.contactID#
		 Where SEASON_ID	= #VARIABLES.seasonID#
		   AND CLUB_ID		= #VARIABLES.ClubId#
	</CFQUERY>	
	
	<CFLOCATION url="#VARIABLES.backpage#.cfm">

</CFIF>

<CFQUERY name="qGetState" datasource="#SESSION.DSN#">
	Select Club_State from TBL_CLUB
	 Where Club_ID = #VARIABLES.clubID#
</CFQUERY>		

<CFIF qGetState.RECORDCOUNT>
	<CFSET ClubState = qGetState.Club_State>
<CFELSE>
	<CFSET ClubState = "">
</CFIF>

<!--- REMOVED 7/14/2011 by J. Oriente: no longer required
<CFIF ClubState EQ "NY">
	<CFSET Fee1 = 200>
	<CFSET Fee2 = 200>
	<CFSET Fee3 = 200>
<CFELSE> --->

	<CFSET Fee1 = 455>
	<CFSET Fee2 = 355>
	<CFSET Fee3 = 405>

<!--- REMOVED 7/14/2011 by J. Oriente: no longer required
</CFIF> --->

<CFSET TotalU10YoungerTeams = 0 > 
<CFSET Total11Thru14Teams = 0 > 
<CFSET Total15thru19Teams = 0 > 

<CFQUERY name="qGetTeamAGES" datasource="#SESSION.DSN#">
	SELECT T.teamAge
	  FROM tbl_team T  INNER JOIN tbl_club CL  ON CL.club_id = T.club_id
     WHERE T.season_id = (select season_id from tbl_season where RegistrationOpen_YN = 'Y')
	   AND T.Club_ID	 = #VARIABLES.clubID#
	   AND T.Registered_YN = 'Y' 
</CFQUERY>

<CFLOOP query="qGetTeamAGES">
	<CFSET AGE	= Trim(Right(TeamAge, 2))>
	<cfif AGE LE 10 >
		<CFSET TotalU10YoungerTeams = TotalU10YoungerTeams + 1>
	<cfelse>
		<cfif AGE LE 14 >
			<cfset Total11Thru14Teams = Total11Thru14Teams + 1	>
		<cfelse>
			<cfset Total15thru19Teams = Total15thru19Teams + 1	>
		</cfif>
	</cfif>
</CFLOOP>

<cfinvoke component="#SESSION.SITEVARS.cfcPath#registration" method="getRegisteredClubs" returnvariable="qBond">
	<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
</cfinvoke>

<cfif qBond.RECORDCOUNT>
	<CFSET Bond = qBond.Bond_YN>
	<cfif Bond EQ "Y">
		<CFSET BondAmt = 0>
	<cfelse>
		<cfset totalTeams = (TotalU10YoungerTeams + Total11Thru14Teams + Total15thru19Teams)>
		<cfif totalTeams GT 1>
			<cfset BondAmt = 600 >
		</cfif>
		<cfif totalTeams eq 1>
			<cfset BondAmt = 450 >
		</cfif>
		<cfif totalTeams eq 0 >
			<cfset BondAmt = 0 >
		</cfif>
	</cfif>
<CFELSE>
	<CFSET Bond = "">
	<CFSET BondAmt = "">
</cfif>
				
<cfset AMT15thru19	= Fee3 * Total15thru19Teams >
<cfset AMT11thru14	= Fee1 * Total11Thru14Teams >
<cfset AMT10younger = Fee2 * TotalU10YoungerTeams >

<!--- <br>ClubID[#ClubId#]
<br>backpage[#backpage#]
<br>TotalU10YoungerTeams[#TotalU10YoungerTeams#]
<br>Total11Thru14Teams[#Total11Thru14Teams#]
<br>Total15thru19Teams[#Total15thru19Teams#]
<br>BOND[#BOND#]
<br>BondAmt[#BondAmt#]
<br>U15Amt[#AMT15thru19#]
<br>U11Amt[#AMT11thru14#]
<br>U10Amt[#AMT10younger#] --->


	<span class="red">Fields marked with <strong>*</strong> are required</span><br /><br />
<FORM name="ClubsMaintain" action="teamSummary.cfm" method="post">
	<input type="hidden" name="ClubID"	 value="#ClubId#">
	<input type="hidden" name="backpage" value="#backpage#">
	<input type="hidden" name="TotalU10YoungerTeams" value="#TotalU10YoungerTeams#">
	<input type="hidden" name="Total11Thru14Teams"   value="#Total11Thru14Teams#" >
	<input type="hidden" name="Total15thru19Teams"   value="#Total15thru19Teams#" >


	<CFSET required = "<FONT color=red>*</FONT>">
	<table cellspacing="0" cellpadding="5" align="LEFT" border="0" width="75%">
		<tr class="tblHeading">
			<TD colspan="3">&nbsp;</TD>
		</tr>
		<tr>
			<TD colspan="3">PLEASE DOWNLOAD, PRINT AND COMPLETE THE <A HREF="formsView.cfm?form_id=164">CLUB PAYMENT FORM</A> WHICH IS POSTED UNDER CLUB DOCUMENT UNDER THE NAME CLUB PAYMENT FORM FOLLOWED BY THE UPCOMING SEASON DESIGNATION.  THIS DOCUMENT MUST BE COMPLETED IN FULL AND WILL LET YOU KNOW THE AMOUNT DUE FOR THE TEAMS JUST REGISTERED.  THE FORM MUST BE SENT ALONG WITH THE PAYMENT TO NCSA PER EMAILED INSTRUCTIONS.</TD>
		</tr>
<!--- <TD class="tdUnderLine" nowrap> bbbbbbbbb		</TD> --->
		<!--- <TR><TD width="60%" align="right">
				<B>#required# BOND - Do you have a $600 Bond with NCSA	<B>
			</TD>
			<TD width="20%" align="left">
					<SELECT name="Bond"  onchange=CalcBond() > 
						<OPTION value="0" selected>Select</OPTION>
							<OPTION value="Y" <CFIF BOND EQ "Y">selected</CFIF> >Yes</OPTION>
							<OPTION value="N" <CFIF BOND EQ "N">selected</CFIF> >No </OPTION>
					</SELECT>
			</TD>
			<td width="20%" align="right">
				<input maxlength="25" name="BondAmt" value="#BondAmt#" Disabled >
			</td>
		</TR>
		<TR><TD align="right"><b>Total ## of U-15 and Older teams</b>		</TD>
			<TD align="left"> <b>#Total15thru19Teams#</b> @ $#trim(Fee3)#	</TD>
			<td align="right"><input maxlength="25" name="U15Amt" value="#AMT15thru19#" Disabled >	</td>
		</TR>
		<TR><TD align="right"><B>Total ## of U-11 through U-14 teams</B>	</TD>
			<TD align="left"> <B>#Total11Thru14Teams#</B> @ $#trim(Fee1)#	</TD>
			<td align="right"><input maxlength="25" name="U11Amt" value="#AMT11thru14#" Disabled >	</td>
		</TR>
		<TR><TD align="right"> <B>Total ## of U-10 and Younger teams</B>	</TD>
			<TD align="left">  <B>#TotalU10YoungerTeams#</B> @ $#trim(Fee2)#</TD>
			<td align="right"> <input maxlength="25" name="U10Amt" value="#AMT10younger#" Disabled >	</td>
		</TR>
		<TR>
		<TD colspan="3"><FONT color="##FF0000">For <B><U>SPRING</U></B> season registrations only, pay fees only for teams that did not play in the just completed Fall season.  For <B><U>FALL</U></B> season, pay full amount.</FONT></TD>
		</TR> --->
		<TR><TD colspan="3" align="center">
				<!--- <INPUT type="submit" name="SAVE" value="Save" > --->
				<INPUT type="submit" name="BACK" value="Back" >
			</TD>
		</TR>
	<!--- </TABLE> --->

		<!--- <tr><td colspan="3">
				<table cellspacing="0" cellpadding="5" align="LEFT" border="0" width="100%">
					<tr class="tblHeading">
						<TD colspan="3">Late Fees or Credit per New Schedule (only ONE section applies) see Rule 2.3</TD>
					</tr>
				
					<CFQUERY name="qFee1" datasource="#SESSION.DSN#">
						Select * from FeeSchedule where Rectype = 1
					</CFQUERY> 
				
					<CFLOOP query="qFee1">
						<tr><td width="33%">#InfoDetail#</td>
							<td width="33%">#PaymentDetail#</td>
							<td width="33%">#FineDetail#</td>
						</tr>
					</CFLOOP>
					<tr><td colspan="3">
							<span class="red">
								REMINDER: Teams dropping out after deadlines also incur fines, in addition
								to loss of registration fee, whether paid yet or not, as follows
							</span>
						</td>
					</tr>
				</TABLE>
			</td>
		</tr>	
		<tr><td colspan="3">
				<table cellspacing="0" cellpadding="5" align="LEFT" border="0" width="100%">
					<CFQUERY name="qFee2" datasource="#SESSION.DSN#">
						Select * from FeeSchedule where Rectype = 2					
					</CFQUERY> 
					<CFLOOP query="qFee2">
						<tr><td width="50%"> #InfoDetail# </td>
							<td width="50%"> #FineDetail# </td>
						</tr>
					</CFLOOP>
					<tr><td colspan="2" align="left"><b>Be Sure you have a team when you register it</b></td>
					</tr>
					<tr><td colspan="2">
							<span class="red">
								<B>IMPORTANT, PLEASE NOTE</b>
									<br> Credits for early submission and late fees for late submission will be verified by NCSA Treasurer; add any outstanding fines in order for your teams to be flighted.
									<p>  The league has found it necessary to raise packet costs due to the increase in insurance cost at the NJ state level			
							</span>
						</td>
					</tr>
				</TABLE>
			</td>
		</tr>	 --->
	</TABLE>
</FORM>




<script language="javascript">
var cForm = document.ClubsMaintain.all;
function CalcBond()
{	var U15Teams = document.ClubsMaintain.Total15thru19Teams.value;
	var U11Teams = document.ClubsMaintain.Total11Thru14Teams.value;
	var U10Teams = document.ClubsMaintain.TotalU10YoungerTeams.value;
	if (document.ClubsMaintain.Bond.value == "Y")
	{	document.ClubsMaintain.BondAmt.value = 0
	}
	else
	{	if ((U11Teams + U10Teams + U15Teams) > 1)
		{	document.ClubsMaintain.BondAmt.value = 600
		}
		else
		{	if ((U11Teams + U10Teams + U15Teams) == 1)
			{	document.ClubsMaintain.BondAmt.value = 450
			}
			else
			{	document.ClubsMaintain.BondAmt.value = 0
			}
		}
	}
	return;
}


</script>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">

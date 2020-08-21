<!--- 
	FileName:	ContactApproveList.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Approve New Contact List</H1>
<br>
<!--- <h2>yyyyyy </h2> --->

<cfset err = "">

<!--- <CFIF isDefined("FORM.Clubselected") AND FORM.Clubselected GT 0>
	<CFSET Clubselected = FORM.Clubselected>
<CFELSE>
	<CFSET Clubselected = 0>
</CFIF>

<CFIF listFind(SESSION.CONSTANT.CUROLES,SESSION.MENUROLEID) GT 0>
	<!--- we are logged in as "CU" as a CLUB user(rep,alt,pres) 
		  Make the selected club equal to the user's club	--->
	<CFSET Clubselected = SESSION.USER.CLUBID>
</CFIF> 

<CFIF isDefined("FORM.AddContact")>
	<cflocation url="contactCreate.cfm?cid=#Clubselected#">
</CFIF> 

<CFIF Clubselected GT 0>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getClubContacts" returnvariable="clubContacts">
		<cfinvokeargument name="clubID" value="#VARIABLES.Clubselected#">
	</cfinvoke>

	<cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="getClubInfo" returnvariable="qclubInfo">
		<cfinvokeargument name="clubID" value="#VARIABLES.Clubselected#">
	</cfinvoke>
	
	<CFSET clubName = qclubInfo.Club_name>
</CFIF>
--->

<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getunApprovedContacts" returnvariable="qNewContacts">
</cfinvoke>

<form name="frmContact" action="ContactList.cfm" method="post">
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="85%">
		<tr class="tblHeading">
			<TD>&nbsp;		</TD>
			<TD colspan="3">&nbsp; Contact List </TD>
		</tr>

		<cfif len(Trim(err))>
			<TR><TD>&nbsp;		</TD>
				<TD colspan="3" align="center" class="red">
					<b>Please correct the following errors and submit again.</b>
					<br>
					#stValidFields.errorMessage#
					#err#
				</td>
			</TR>
		</cfif>
		 		
		<CFIF listFind(SESSION.CONSTANT.CUroles,SESSION.menuRoleID) EQ 0>  
			<!--- user logged in is NOT a CLUB user, so they can select any club --->
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="getClubInfo" returnvariable="qClubs">
				<cfinvokeargument name="orderby" value="clubname">
			</cfinvoke>
			<TR><TD align="right"> &nbsp; </TD>
				<TD colspan="3"> <b>Select a Club:</b>
					<Select name="Clubselected">
						<option value="0">Select a Club</option>
						<CFLOOP query="qClubs">
							<option value="#CLUB_ID#" <CFIF CLUB_ID EQ VARIABLES.Clubselected>selected</CFIF> >#CLUB_NAME#</option>
						</CFLOOP>
					</SELECT>
					<INPUT type="Submit" name="goClub" value="Go">
				</TD>
			</TR>
		<CFELSE>
			<!--- user logged in IS a CLUB user, they can only see their own club --->
			<input type="Hidden" name="Clubselected" value="#SESSION.USER.CLUBID#">	
		</CFIF>

		<CFIF isDefined("clubContacts")>
			<tr class="tblHeading">
				<TD width="05%" align="right"> &nbsp; </TD>
				<td width="20%" > Last Name </td>
				<td width="20%"> First Name	</td>
				<td width="55%"> CLub </td>
			</tr>
			<CFLOOP query="clubContacts">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
					<TD class="tdUnderLine" valign="middle"> &nbsp; </TD> 
					<TD class="tdUnderLine" valign="middle"> 
						<A href="contactEdit.cfm?c=#contact_ID#&cid=#VARIABLES.Clubselected#">#LastName#</A>
					</TD>
					<TD class="tdUnderLine">
						#firstName#
					</TD>
					<TD class="tdUnderLine">
						#VARIABLES.clubName#
					</td>
				</tr>
			</CFLOOP>
		</CFIF> 
		<tr><td colspan="4" align="center">
				<BR>
				<input type="submit" name="AddContact" value="Add Another Contact">
			</td>
		</tr>
	</table>
</form>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">

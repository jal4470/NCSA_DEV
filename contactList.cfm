<!--- 
	FileName:	homesite+\html\Default Template.htm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
		12/03/08 - aarnone - added Select ALL Users
		09/12/2012 - J. Rab - Added new filter based on approval status, role status and rejections
					Added style changes throughout page
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<cfinclude template="_checkLogin.cfm"> 

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Contact List</H1>
<!--- <br> <h2>yyyyyy </h2> --->

<cfset err = "">
 
<cfif isDefined("form.filter_status")>
	<cfset filter_status = form.filter_status>
<cfelse>
	<cfset form.filter_status = 2>
</cfif>

<cfif isdefined("form.f")>
	<cfset filter_selected = form.f>
<cfelse>
	<cfset filter_selected = "Active">
</cfif>
<CFIF isDefined("FORM.Clubselected") AND FORM.Clubselected GT 0>
	<CFSET Clubselected = FORM.Clubselected>
<CFELSEIF isDefined("URL.cid") AND isNumeric(URL.cid)>
	<CFSET Clubselected = URL.cid>
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

<CFIF isNumeric(Clubselected) AND Clubselected GT 0>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getClubContacts" returnvariable="clubContacts">
		<cfinvokeargument name="clubID" value="#VARIABLES.Clubselected#">
	</cfinvoke>
 	<cfquery name="clubContacts" dbtype="query">
		SELECT *
		  FROM clubContacts
		 WHERE LASTNAME IS NOT NULL
		 AND roll_assigned <> 0
		 <cfif filter_selected eq 'Active'>
		 	and Active_yn = 'Y'
		 <cfelseif filter_selected eq 'Inactive'>
		 	and Active_yn = 'N'
		 </cfif>
	</cfquery>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getClubRequestedContacts" returnvariable="clubRequestedContacts">
		<cfinvokeargument name="clubID" value="#VARIABLES.Clubselected#">
	</cfinvoke>
 
	<!--- the following QoQ omits the requested referees, they will be found in REFEREE MAINTAINENCE 
		and anyone that has received a role
	--->
	<cfquery name="clubRequestedContacts" dbtype="query">
		SELECT * FROM clubRequestedContacts
		WHERE ROLE_ID IS NULL
		AND			current_status <> 4 <!--- 4 = Approved, but not active --->
		<cfif filter_status NEQ "">
		AND		current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="#filter_status#">
		</cfif>
	</cfquery><!--- <> 25 --->
 
	
	<!--- <cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="getClubInfo" returnvariable="qclubInfo">
		<cfinvokeargument name="clubID" value="#VARIABLES.Clubselected#">
	</cfinvoke> 
	<CFSET clubName = qclubInfo.Club_name>--->

<CFELSEIF Clubselected EQ "ALL">
	<!--- ALL WAS SELECTED!!!!!!!!!!!! --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getALLContacts" returnvariable="clubContactsALL">
	</cfinvoke>
	
	<cfquery name="clubContacts" dbtype="query">
		SELECT *
		  FROM clubContactsALL
		 WHERE LASTNAME IS NOT NULL
		 AND roll_assigned <> 0
		 <cfif filter_selected eq 'Active'>
		 	and Active_yn = 'Y'
		 <cfelseif filter_selected eq 'Inactive'>
		 	and Active_yn = 'N'
		 </cfif>
	</cfquery>

	<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getClubRequestedContacts" returnvariable="clubRequestedContacts">
	</cfinvoke>
 
	<!--- the following QoQ omits the requested referees, they will be found in REFEREE MAINTAINENCE 
		and anyone that has received a role
	--->
	<cfquery name="clubRequestedContacts" dbtype="query">
		SELECT * FROM clubRequestedContacts
		WHERE ROLE_ID IS NULL
		AND			current_status <> 4 <!--- 4 = Approved, but not active --->
		<cfif filter_status NEQ "">
		AND		current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="#filter_status#">
		</cfif>
	</cfquery><!--- <> 25 --->






</CFIF>

<cfif isDefined("clubRequestedContacts") and clubRequestedContacts.RECORDCOUNT>
	<br> Number of Requested Users: #clubRequestedContacts.RECORDCOUNT#. 
	<cfquery name="qCtApproved" dbtype="query">
		Select count(*) as ApprovedRequests 
		  from clubRequestedContacts
		 where APPROVE_YN = 'Y'
	</cfquery>
	<cfif qCtApproved.ApprovedRequests GT 0>
		<span class="red">There <cfif qCtApproved.ApprovedRequests EQ 1>is<cfelse>are</cfif> #qCtApproved.ApprovedRequests# Approved Request(s) waiting to be activated. Click on the approved user to assign a Role.</span>
	</cfif>	
</cfif>
<form name="frmContact" action="ContactList.cfm" method="post">
	<CFIF listFind(SESSION.CONSTANT.CUroles,SESSION.menuRoleID) EQ 0>  
	
		<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
			<cfif len(Trim(err))>
				<TR><TD>&nbsp;		</TD>
					<TD colspan="4" align="center" class="red">
						<b>Please correct the following errors and submit again.
						<br>
						#stValidFields.errorMessage#
						#err#</b>
					</td>
				</TR>
			</cfif>
			<!--- user logged in is NOT a CLUB user, so they can select any club --->
			<!--- <cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="getClubInfo" returnvariable="qClubs">
				<cfinvokeargument name="orderby" value="clubname">
			</cfinvoke> --->
			<CFQUERY name="qClubs" datasource="#SESSION.DSN#">
				SELECT distinct cl.club_id, cl.Club_name, cl.ClubAbbr
				  FROM tbl_club cl   
				 order by cl.club_name 
 			</CFQUERY>
			<TR><TD align="right">&nbsp;  </TD>
				<TD colspan="4"> <b>Select a Club:</b>
					<Select name="Clubselected">
						<option value="0">Select a Club</option>
						<option value="ALL" <CFIF Clubselected EQ "ALL" >selected</CFIF> >Select ALL users</option>
						<CFLOOP query="qClubs">
							<option value="#CLUB_ID#" <CFIF CLUB_ID EQ VARIABLES.Clubselected>selected</CFIF> >#CLUB_NAME#</option>
						</CFLOOP>
					</SELECT>
					<INPUT type="Submit" name="goClub" value="Go">
				</TD>
			</TR>
		</table>
	<CFELSE>
		<!--- user logged in IS a CLUB user, they can only see their own club --->
		<input type="Hidden" name="Clubselected" value="#SESSION.USER.CLUBID#">	
	</CFIF>
	<div align="center" style="background:##333399;color:white;padding-left:3px;padding-top:3px;border-top-left-radius:15px;border-top-right-radius:15px;"><strong>Show:</strong>
	
				<select name="filter_status" id="filter_status" onchange="javascript:document.getElementById('subFilter2').click();">
					<option value="" <cfif filter_status EQ "">selected="selected"</cfif>>All</option>
					<option value="1" <cfif filter_status EQ 1>selected="selected"</cfif>>Waiting For Approval</option>
					<option value="2" <cfif filter_status EQ 2>selected="selected"</cfif>>Approved, No Role Assigned</option>
					<option value="3" <cfif filter_status EQ 3>selected="selected"</cfif>>Rejected</option>
				</select>
			<input type="Submit" value="Go!" id="subFilter2">
	</div>

	<!--- TABLE FOR CONTACTS REQUESTING APPROVAL --->

		<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
			<tr class="tblHeading">
				<TD colspan="4"> Requested Users </TD>
			</tr>
			<tr class="tblHeading">
				<TD width="02%" align="right">&nbsp;  </TD>
				<td width="30%" > Last, First Name	</td>
				<td width="44%"> Club </td>
				<td width="25%"> Approved </td>
			</tr>
 		</table>	
			<cfset reqDivHeight = 25>
		<CFIF isDefined("clubRequestedContacts") AND clubRequestedContacts.RECORDCOUNT>
		<cfif clubRequestedContacts.RECORDCOUNT GT 4>
			<cfset reqDivHeight = 100>
		<cfelse>
			<cfset reqDivHeight = 25 * clubRequestedContacts.RECORDCOUNT > 
		</cfif>
		<div style="overflow:auto;height:#reqDivHeight#px;border:1px ##cccccc solid;">
		<table cellspacing="0" cellpadding="5" align="left" border="0" width="98%">

			<CFLOOP query="clubRequestedContacts">
				<CFIF ROLE_ID NEQ 25>
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
					<TD width="02%" class="tdUnderLine" valign="middle">&nbsp;  </TD> 
					<TD width="30%" class="tdUnderLine" valign="middle"> 
						<!--- <CFIF ROLE_ID EQ 25>
							<!--- its a referee --->
							<CFSET ahrefLink = "refereeMaintain.cfm?rfid=" & xref_contact_role_ID >
						<CFELSE>
							<!--- all Others --->
							<CFSET ahrefLink = "contactEdit.cfm?c=" & contact_ID & "&cid=" & VARIABLES.Clubselected >
						</CFIF>	 --->
					
						<CFIF APPROVE_YN eq "Y">
								<A href="contactEdit.cfm?c=#contact_ID#&cid=#VARIABLES.Clubselected#" title="Proceed to Assign Role">#LastName#, #firstName#</A>
								<!--- <A href="#ahrefLink#">#LastName#, #firstName#</A> --->
						<CFELSEIF APPROVE_YN eq "N">
								#LastName#, #firstName#
								<!--- <A href="#ahrefLink#">#LastName#, #firstName#</A> --->
						<CFELSEIF NOT LEN(TRIM(APPROVE_YN))>
								<!--- <A href="contactRequestDisplay.cfm?c=#contact_ID#" title="Proceed to Approve">--->#LastName#, #firstName#<!---</a>--->
						</CFIF>
					</TD>
					<TD width="44%" class="tdUnderLine">
						#club_Name#<!--- #VARIABLES.clubName# --->
					</td>
					<TD width="25%" class="tdUnderLine">
						<CFIF APPROVE_YN eq "Y">
							<span class="green"><b>Approved</b></span> 
								<CFIF ROLE_ID EQ 25>
									<!--- its a referee --->
									(Referee) click to finish edit.
								<CFELSE>
									<!--- all Others --->
									 click user to assign role.
								</CFIF>	
						<cfelseif APPROVE_YN eq "N">
							<span class="red">Rejected</span>
						<cfelse>
							Waiting for approval
						</CFIF>
					</td>
					</tr>
				</CFIF>
			</CFLOOP>
		</table>
		</div>
	<cfelse>
	<div style="overflow:auto;height:#reqDivHeight#px;border:1px ##cccccc solid;">
		<table cellspacing="0" cellpadding="5" align="left" border="0" width="98%">
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#"> 
					<TD width="02%" class="tdUnderLine" valign="middle" align="center"> No records found matching criteria. </TD> 
					</tr>
		</table>
		</div>
	</CFIF> 

	<br>
	<CFIF isDefined("clubContacts")>
		<!--- TABLE FOR CONTACTS THAT ARE ACTIVE AND APPROVED --->
		<!--- Joe Lechuga - 7/18/2011 - Added Filter for Active/Inactive contacts --->
		<div align="center" style="background:##333399;color:white;padding-left:3px;padding-top:3px;border-top-left-radius:15px;border-top-right-radius:15px;">View:	
		<form action="#cgi.script_name#" method="post">
			<select name="f" onchange="javascript:document.getElementById('subFilter').click();">
				<option value="Active" #iif(filter_selected eq 'Active',de('Selected=true'),de(''))#>Active</option>
				<option value="All" #iif(filter_selected eq 'All',de('Selected=true'),de(''))#>ALL</option>
				<option value="Inactive" #iif(filter_selected eq 'Inactive',de('Selected=true'),de(''))#>Inactive</option>
			</select>
			<input type="Submit" value="Go!" id="subFilter">
		</form>
		</div>

		<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
			<!--- <tr class="tblHeading">
				<TD colspan="4"> Active Users </TD>
			</tr> --->
			<tr class="tblHeading">
				<TD width="02%" align="right">&nbsp;  </TD>
				<td width="30%" > Last, First Name	</td>
				<td width="50%"> Club </td>
				<td width="18%">&nbsp;  </td> 
			</tr>
		</table>

		<div style="overflow:auto;height:350px;border:1px ##cccccc solid;">
		<table cellspacing="0" cellpadding="5" align="left" border="0" width="98%">
			<CFLOOP query="clubContacts">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
					<TD width="02%" class="tdUnderLine" valign="middle">&nbsp;  </TD> 
					<TD width="30%" class="tdUnderLine" valign="middle"> 
						<A href="contactEdit.cfm?c=#contact_ID#&cid=#VARIABLES.Clubselected#">#LastName#, #firstName#</A> <cfif active_yn eq 'N'><span style="color:red;font-style:italic;">Inactive</span></cfif>
					</TD>
					<TD width="50%" class="tdUnderLine">
						#club_Name#<!--- #VARIABLES.clubName# --->
					</td>
					<TD width="18%" class="tdUnderLine">
						&nbsp; <!--- #ACTIVE_YN# - #APPROVE_YN# --->
					</td>  
				</tr>
			</CFLOOP>
		</table>
		</div>

	</CFIF> 

		<!--- ADD A CONTACT --->
		<cfif listFind(SESSION.CONSTANT.CUROLES,SESSION.MENUROLEID) EQ 0>
			<!--- supressed for club reps --->
			<table width="100%">
				<tr><td colspan="4" align="center">
						<BR><input type="submit" name="AddContact" value="Add Another Contact">
					</td>
				</tr>
			</table>
		</cfif>

</form>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">





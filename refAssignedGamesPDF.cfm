<!--- 
	FileName:	refAssignedGamesPDF.cfm
	Created on: 05/13/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments


	NOTE! - changes to this page may also have to be included into refAssignedGames.cfm

 --->

<!--- <cfinclude template="cfudfs.cfm"> ---> 
<cfinclude template="_checkLogin.cfm">

<CFIF isDefined("URL.rcid") AND isNumeric(URL.rcid)>
	<cfset refereeContactID = URL.rcid>
<CFELSE>
	<cfset refereeContactID = 0>
</CFIF>

<CFSET GameDateLimit = "">
<CFIF isDefined("SESSION.GLOBALVARS.REFASSIGNVIEWDATEYN") AND SESSION.GLOBALVARS.REFASSIGNVIEWDATEYN EQ "Y">
	<CFIF SESSION.menuRoleID EQ 25 AND isDate(SESSION.GLOBALVARS.REFASSIGNVIEWDATE)>
		<CFSET GameDateLimit = SESSION.GLOBALVARS.REFASSIGNVIEWDATE >
	</CFIF>
</CFIF>

<!--- <CFIF SESSION.menuRoleID EQ 25> <!--- logged in as referee, using referee menu --->
	<cfset refereeContactID = SESSION.USER.CONTACTID>
</CFIF> --->

<!--- <CFIF len(Trim(GameDateLimit))>
	<span class="red"><b> NOTE! Game assigments are currently viewable up to #VARIABLES.gameDateLimit#, assignments after this date have not been published.</b></span>
</CFIF>
 --->

<cfif IsDefined("FORM.SortBy")>
	 <cfset sortBy = FORM.SortBy>
	 <cfswitch expression="#UCASE(FORM.SortBy)#">
	 	<cfcase value="GAME">
			<cfset orderBy = " ORDER BY GAME_ID ">
		</cfcase>
	 	<cfcase value="DIV">
			<cfset orderBy = " ORDER BY DIVISION, GAME_DATE ">
		</cfcase>
	 	<cfcase value="VISITOR">
			<cfset orderBy = " ORDER BY VISITOR_TEAMNAME, GAME_DATE ">
		</cfcase>
	 	<cfcase value="HOME">
			<cfset orderBy = " ORDER BY HOME_TEAMNAME, GAME_DATE ">
		</cfcase>
	 	<cfcase value="PLAYFIELD">
			<cfset orderBy = " ORDER BY FieldAbbr, GAME_DATE ">
		</cfcase>
	 	<cfdefaultcase>
			<cfset orderBy = " ORDER BY GAME_DATE ">
		</cfdefaultcase>
	 </cfswitch>
<cfelse>
	<cfset sortBy = "DATE">
	<cfset orderBy = " ORDER BY GAME_DATE ">
</cfif>

<CFQUERY name="qGetRefGames" datasource="#SESSION.DSN#">
	Select Game_ID,       GAME_Date,        GAME_Time,    Division, GAME_TYPE,
		   Fieldname,     FieldAbbr,        Field_ID, 
		   Home_CLUB_ID,  HOME_TEAMNAME,    VISITOR_TEAMNAME, Virtual_TeamName, 
		   Forfeit_Home,  Forfeit_Visitor, 
		   RefID,		Ref_accept_Date,	Ref_accept_YN,
		   AsstRefID1,  ARef1AcptDate,		ARef1Acpt_YN,
		   AsstRefID2,  ARef2AcptDate,		ARef2Acpt_YN
	  from V_Games with (nolock)
	 WHERE 
	 	(  RefID = #VARIABLES.refereeContactID#
	    or AsstRefID1 = #VARIABLES.refereeContactID#
		or AsstRefID2 = #VARIABLES.refereeContactID#
		)
	 #preserveSingleQuotes(VARIABLES.orderBy)#, dbo.formatDateTime(GAME_TIME,'HH:MM 24')
</CFQUERY> 

<CFIF len(Trim(GameDateLimit))>
	<CFQUERY name="qGetRefGames" dbtype="query">
		Select *
		  from qGetRefGames 
		 WHERE GAME_Date <= '#VARIABLES.gameDateLimit#'  
		 #preserveSingleQuotes(VARIABLES.orderBy)#, GAME_TIME
	</CFQUERY> 
</CFIF>

<!--- get game types --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrGameType">
	<cfinvokeargument name="listType" value="GAMETYPE"> 
</cfinvoke> 



<cfdocument format="pdf" 
			marginBottom=".4"
			marginLeft=".3"
			marginRight=".3"
			marginTop=".75"  
			orientation="landscape" >
<cfhtmlhead text="<link rel='STYLESHEET' type='text/css' href='2col_leftNav.css'>">	
	<cfoutput><cfdocumentitem type="header" > <!--- has heading but not spaced right --->
		<table cellspacing="0" cellpadding="5" align="center" border="0"  width="100%" >
		<tr><td colspan="6" align="left">
				<br>NCSA - Accept/Reject Game assignments
			</td>
			<td colspan="2" align="right">
				<br>Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
			</td>
		</tr>
		<!--- <tr><td colspan="5" align="left">
				<!--- <span class="red">
						- To Accept game assignment, mark the check box and then press SAVE button at the bottom of the page
					<br>- To Decline game assignment, mark the check box and then press SAVE button at the bottom of the page
					<br>- You must act on assignments within 24 hours of posting
					<br>- You cannot change an acceptance or rejection after saving 
					<br>- you must email the assignors (see instructions on referee login page) immediately if you make an error or have a change in plans 
				</span> --->
			</td>
			<td colspan="3" align="right" valign="bottom">
				Sorted by: 
				<cfswitch expression="#sortBy#">
					<cfcase value="DATE">	Game Date	 </cfcase>
					<cfcase value="GAME">	Game Number	 </cfcase>
					<cfcase value="DIV" > 	Division	 </cfcase>
					<cfcase value="VISITOR">Visting Team </cfcase>
					<cfcase value="HOME">   Home Team	 </cfcase>
					<cfcase value="PLAYFIELD">Play Field </cfcase>
				</cfswitch>
			</td>
		</tr> --->
		<tr class="tblHeading">
			<TD width="18%" valign="bottom">Date/Time	</TD>
		    <TD width="06%" valign="bottom">Game		</TD>
		    <TD width="07%" valign="bottom">Div		</TD>
			<TD width="18%" valign="bottom">PlayField 	</TD>
			<TD width="26%" valign="bottom">Home Team <br> Visitor Team	</TD>
			<TD width="15%" valign="bottom">Refs	</TD>
			<TD width="05%" valign="bottom" align="left">Accept	</TD>
			<TD width="05%" valign="bottom" align="left">Reject	</TD>
		</TR>
		</table>
	</cfdocumentitem>

		<cfif qGetRefGames.RECORDCOUNT >
			<table cellspacing="0" cellpadding="2" border="0" width="100%" align="left" >
				<CFLOOP query="qGetRefGames">
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
						<TD width="18%"  class="tdUnderLine" valign="top" align="left">
							#dateFormat(GAME_DATE,"ddd")#&nbsp;&nbsp;#dateFormat(GAME_DATE,"mm/dd/yy")#
							<br>#repeatString("&nbsp;",6)# #timeFormat(GAME_TIME,"hh:mm tt")# 
							<cfif len(Trim(GAME_TYPE))>
								<cfloop from="1" to="#arrayLen(arrGameType)#" step="1" index="iGt">
									<cfif GAME_TYPE EQ arrGameType[igt][1]>
										<br> <SPAN class="red">#arrGameType[igt][3]#</span>
										<cfbreak>
									</cfif>
								</cfloop>
							</cfif>
						</TD>
						<TD width="06%"  class="tdUnderLine" valign="top" align="left">#GAME_ID#</TD>
						<TD width="06%" class="tdUnderLine" valign="top" >#DIVISION#</TD>
						<TD width="17%" class="tdUnderLine" valign="top">
							<a href="fieldDirPop.cfm?fid=#FIELD_ID#" target="_blank">#FieldAbbr#</a>
						</TD>
						<TD width="25%" class="tdUnderLine" valign="top">
								#Home_TEAMNAME#		<!--- (#Forfeit_Home#) --->
							<br><!--- #VISITOR_TEAMNAME# --->	<!--- (#Forfeit_Visitor#)  --->
								<cfif len(trim(VISITOR_TEAMNAME))>
									#VISITOR_TEAMNAME#
								<cfelseif len(trim(Virtual_TeamName))>
									#Virtual_TeamName#
								<cfelse>
									&nbsp;
								</cfif>
						</TD>
						<TD width="25%" colspan="2" class="tdUnderLine" valign="top" align=left>
								<!--- Start INNER table --->
								<table align="left" width="100%" border="0" cellpadding="0" cellspacing="0">
									<!--- ref ref ref ref ref ref ref ref ref ref --->
									<tr><td width="77%">
											REF:
											<cfif len(trim(RefID))>
												<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo">
													<cfinvokeargument name="contactID" value="#RefID#">
												</cfinvoke>
												<cfif qContactInfo.recordCount>
													<cfif refID EQ refereeContactID> 
														<b>#qContactInfo.LastName#, #qContactInfo.firstName#</b>
													<cfelse>
														#qContactInfo.LastName#, #qContactInfo.firstName#
													</cfif>
												<cfelse>
													n/a
												</cfif>
											</cfif> <!--- [#REFID#][#Ref_accept_Date#][#Ref_accept_YN#] --->
										</td>
										<td><!--- Ref Accept --->
											<cfif Ref_accept_YN EQ "Y"> <!--- ref accepted, set checked and disable --->
												<cfset txtDisable = "disabled">	   	
												<cfset txtChecked = "checked">
											<cfelseif Ref_accept_YN EQ "N"> <!--- ref rejected, set checked and disable --->
												<cfset txtDisable = "disabled">
												<cfset txtChecked = "">
											<cfelse>						<!--- ref took no action uncheck and able --->
												<cfset txtDisable = "">
												<cfset txtChecked = "">
											</cfif>
											<cfif refID EQ refereeContactID and len(trim(txtDisable)) EQ 0> 
												<!--- this REF is the logged in user, let box be checkable --->	
												<cfset txtName	  = "name='CONFIRM_REF_" & GAME_ID & "'">
											<cfelse>
												<cfset txtName	  = "">		<!--- this REF is NOT the logged in user, disable the box --->
												<cfset txtDisable = "disabled">
											</cfif>
											<input type="checkbox" #txtDisable# #txtChecked# #txtName#> 
										</td>
										<td><!--- Ref Reject --->
											<cfif Ref_accept_YN EQ "Y"> <!--- ref accepted, set checked and disable --->
												<cfset txtDisable = "disabled">	   	
												<cfset txtChecked = "">
											<cfelseif Ref_accept_YN EQ "N"> <!--- ref rejected, set checked and disable --->
												<cfset txtDisable = "disabled">
												<cfset txtChecked = "checked">
											<cfelse>						<!--- ref took no action uncheck and able --->
												<cfset txtDisable = "">
												<cfset txtChecked = "">
											</cfif>
											<cfif refID EQ refereeContactID and len(trim(txtDisable)) EQ 0> 
												<!--- this REF is the logged in user, let box be checkable --->	
												<cfset txtName	  = "name='REJECT_REF_" & GAME_ID & "'">
											<cfelse>
												<cfset txtName	  = "">		<!--- this REF is NOT the logged in user, disable the box --->
												<cfset txtDisable = "disabled">
											</cfif>
											<input type="checkbox" #txtDisable# #txtChecked# #txtName#> 
										</td>
									</tr>
									<!--- AR1 AR1 AR1 AR1 AR1 AR1 AR1 AR1 AR1 AR1 AR1 AR1 AR1 AR1 AR1 --->
									<tr><td>AR1:
											<cfif len(trim(AsstRefId1))>
												<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo1">
													<cfinvokeargument name="contactID" value="#AsstRefId1#">
												</cfinvoke>
												<cfif qContactInfo1.recordCount>
													<cfif AsstRefId1 EQ refereeContactID> 
														<b>#qContactInfo1.LastName#, #qContactInfo1.firstName#</b>
													<cfelse>
														#qContactInfo1.LastName#, #qContactInfo1.firstName#
													</cfif>
												<cfelse>
													n/a
												</cfif>
											</cfif><!---  [#AsstRefID1#][#ARef1AcptDate#][#ARef1Acpt_YN#] --->
										</td>
										<td><!--- AR_1 Accept --->
											<cfif ARef1Acpt_YN EQ "Y"> <!--- ref accepted, set checked and disable --->
												<cfset txtDisable = "disabled">	   	
												<cfset txtChecked = "checked">
											<cfelseif ARef1Acpt_YN EQ "N"> <!--- ref rejected, set checked and disable --->
												<cfset txtDisable = "disabled">
												<cfset txtChecked = "">
											<cfelse>						<!--- ref took no action uncheck and able --->
												<cfset txtDisable = "">
												<cfset txtChecked = "">
											</cfif>
											<cfif AsstRefId1 EQ refereeContactID and len(trim(txtDisable)) EQ 0> 
												<!--- this REF is the logged in user, let box be checkable --->	
												<cfset txtName	  = "name='CONFIRM_AR1_" & GAME_ID & "'">
											<cfelse>
												<cfset txtName	  = "">		<!--- this REF is NOT the logged in user, disable the box --->
												<cfset txtDisable = "disabled">
											</cfif>
											<input type="checkbox" #txtDisable# #txtChecked# #txtName#> 
										</td>
										<td><!--- AR_1 Reject --->
											<cfif ARef1Acpt_YN EQ "Y"> <!--- ref accepted, set checked and disable --->
												<cfset txtDisable = "disabled">	   	
												<cfset txtChecked = "">
											<cfelseif ARef1Acpt_YN EQ "N"> <!--- ref rejected, set checked and disable --->
												<cfset txtDisable = "disabled">
												<cfset txtChecked = "checked">
											<cfelse>						<!--- ref took no action uncheck and able --->
												<cfset txtDisable = "">
												<cfset txtChecked = "">
											</cfif>
											<cfif AsstRefId1 EQ refereeContactID and len(trim(txtDisable)) EQ 0> 
												<!--- this REF is the logged in user, let box be checkable --->	
												<cfset txtName	  = "name='REJECT_AR1_" & GAME_ID & "'">
											<cfelse>
												<cfset txtName	  = "">		<!--- this REF is NOT the logged in user, disable the box --->
												<cfset txtDisable = "disabled">
											</cfif>
											<input type="checkbox" #txtDisable# #txtChecked# #txtName#> 
										</td>
									</tr>
									<tr><td>AR2:
											<cfif len(trim(AsstRefId2))>
												<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo2">
													<cfinvokeargument name="contactID" value="#AsstRefId2#">
												</cfinvoke>
												<cfif qContactInfo2.recordCount>
													<cfif AsstRefId2 EQ refereeContactID> 
														<b>#qContactInfo2.LastName#, #qContactInfo2.firstName#</b>
													<cfelse>
														#qContactInfo2.LastName#, #qContactInfo2.firstName#
													</cfif>
												<cfelse>
													n/a
												</cfif>
											</cfif> <!--- [#AsstRefID2#][#ARef2AcptDate#][#ARef2Acpt_YN#] --->
										</td>
										<td><!--- AR_2 Accept --->
											<cfif ARef2Acpt_YN EQ "Y"> <!--- ref accepted, set checked and disable --->
												<cfset txtDisable = "disabled">	   	
												<cfset txtChecked = "checked">
											<cfelseif ARef2Acpt_YN EQ "N"> <!--- ref rejected, set checked and disable --->
												<cfset txtDisable = "disabled">
												<cfset txtChecked = "">
											<cfelse>						<!--- ref took no action uncheck and able --->
												<cfset txtDisable = "">
												<cfset txtChecked = "">
											</cfif>
											<cfif AsstRefId2 EQ refereeContactID and len(trim(txtDisable)) EQ 0> 
												<!--- this REF is the logged in user, let box be checkable --->	
												<cfset txtName	  = "name='CONFIRM_AR2_" & GAME_ID & "'">
											<cfelse>
												<cfset txtName	  = "">		<!--- this REF is NOT the logged in user, disable the box --->
												<cfset txtDisable = "disabled">
											</cfif>
											<input type="checkbox" #txtDisable# #txtChecked# #txtName#> 
										</td>
										<td><!--- AR_2 Reject --->
											<cfif ARef2Acpt_YN EQ "Y"> <!--- ref accepted, set checked and disable --->
												<cfset txtDisable = "disabled">	   	
												<cfset txtChecked = "">
											<cfelseif ARef2Acpt_YN EQ "N"> <!--- ref rejected, set checked and disable --->
												<cfset txtDisable = "disabled">
												<cfset txtChecked = "checked">
											<cfelse>						<!--- ref took no action uncheck and able --->
												<cfset txtDisable = "">
												<cfset txtChecked = "">
											</cfif>
											<cfif AsstRefId2 EQ refereeContactID and len(trim(txtDisable)) EQ 0> 
												<!--- this REF is the logged in user, let box be checkable --->	
												<cfset txtName	  = "name='REJECT_AR2_" & GAME_ID & "'">
											<cfelse>
												<cfset txtName	  = "">		<!--- this REF is NOT the logged in user, disable the box --->
												<cfset txtDisable = "disabled">
											</cfif>
											<input type="checkbox" #txtDisable# #txtChecked# #txtName#> 
										</td>
									</tr>
									</tr>
								</table><!--- End INNER table --->
						</TD>
					</TR>
				 </CFLOOP>
			</TABLE>
		<cfelse>
			<table cellspacing="0" cellpadding="2" border="0" width="100%" align="left" >
				<tr>
					<td cellspacing="8" align="center">No Games Refereed</td>
				</tr>
			</table>

		</CFIF>

	</cfoutput>
</cfdocument>


<!--- 
	FileName:	contactForm_inc.cfm
	Created on: 09/15/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: this form include is used by contactCreate.cfm and contactEdit.cfm
	
Change History:
Joe Lechuga - 7-18-2011 - Added Active Flag to form
 --->
<cfoutput> 

<CFIF listFind(SESSION.CONSTANT.CUROLES,SESSION.MENUROLEID) GT 0>
	<!--- we are logged in as "CU" as a CLUB user(rep,alt,pres) Only show CLUB user ROLES	--->
	<CFSET swClubRolesOnly = TRUE>
<CFELSE>
	<CFSET swClubRolesOnly = FALSE>
</CFIF> 

<cfif NOT isDefined("swNameReadOnly")>
	<cfset swNameReadOnly = false>
</cfif>


<cfif NOT isDefined("readOnlyForm")>
	<cfset readOnlyForm = false>
</cfif>

<CFIF swShowRoles>
	<!--- use both cols --->
	<cfset col_1_width = "90%">
	<cfset col_2_width = "10%">
<cfelse>
	<!--- use one col --->
	<cfset col_1_width = "90%">
	<cfset col_2_width = "10%">
</CFIF>

<tr><td width="#col_1_width#" valign="top"> 
		<table><!--- start left side table --->
			<TR><TD align="right" nowrap>#required# <b>First Name:</b></TD>
				<TD><cfif swNameReadOnly>
						&nbsp; #FirstName#
						<input type="hidden" name="FirstName" value="#FirstName#">
					<cfelse>
						<cfif readOnlyForm EQ true>
							&nbsp; #FirstName#
						<cfelse>
							<input type="Text" name="FirstName"	value="#FirstName#">
						</cfif>
					</cfif>
					<input type="Hidden" name="FirstName_ATTRIBUTES" value="type=ALPHA~required=1~FIELDNAME=First Name">	
				</TD>
			</TR>
			<TR><TD align="right">#required#<b>Last Name:</b></TD>
				<TD><cfif swNameReadOnly>
						&nbsp; #LastName#
						<input type="Hidden" name="LastName" value="#LastName#">
					<cfelse>
						<cfif readOnlyForm EQ true>
							&nbsp; #LastName#
						<cfelse>
							<input type="Text" name="LastName" value="#LastName#">
						</cfif>
					</cfif>
					<input type="Hidden" name="LastName_ATTRIBUTES" value="type=ALPHA~required=1~FIELDNAME=Last Name">		 
				</TD>
			</TR>
			<TR><TD align="right">#required#<b>Address</b></TD>
				<TD>
					<cfif readOnlyForm EQ true>
						&nbsp; #Address#
					<cfelse>
						<input type="Text"  maxlength="25" name="Address" value="#Address#">
					</cfif>
					<input type="Hidden" name="Address_ATTRIBUTES" 	value="type=NOSPECIALCHAR~required=1~FIELDNAME=Address">	
				</TD>
			</TR>
			<TR><TD align="right">#required#<b>Town</b></TD>
				<TD>
					<cfif readOnlyForm EQ true>
						&nbsp; #Town#
					<cfelse>
						<input type="Text"  maxlength="25" name="Town" 	value="#Town#">
					</cfif>
					<input type="Hidden" name="Town_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=Town">	
				</TD>
			</TR>
			<TR><TD align="right">#required# <b>State</b> <br> (2 Char. ex: NJ)</TD>
				<TD>
					<cfif readOnlyForm EQ true>
						&nbsp; #State#
					<cfelse>
						<input type="Text"  maxlength="2" name="State" 	value="#State#">
					</cfif>
					<input type="Hidden" name="State_ATTRIBUTES" value="type=STATE~required=1~FIELDNAME=State">	
				</TD>
			</TR>
			<TR><TD align="right">#required# <b>Zip</b></TD>
				<TD>
					<cfif readOnlyForm EQ true>
						&nbsp; #Zip#
					<cfelse>
						<input type="Text"  maxlength="10" name="Zip" width="10" 	value="#Zip#">
					</cfif>
					<input type="Hidden" name="Zip_ATTRIBUTES" value="type=ZIPCODE~required=1~FIELDNAME=Zip Code">		
				</TD>
			</TR>
			<TR><TD align="right">#required#<b>Home Phone</b> <br>999-999-9999</TD>
				<TD>
					<cfif readOnlyForm EQ true>
						&nbsp; #HPhone#
					<cfelse>
						<input type="Text"  maxlength="25" name="HPhone" value="#HPhone#">
					</cfif>
					<input type="Hidden" name="HPhone_ATTRIBUTES" value="type=PHONE~required=1~FIELDNAME=Home Phone">	
				</TD>
			</TR>
			<TR><TD align="right">#required#<b>Cell Phone</b> <br>999-999-9999</TD>
				<TD>
					<cfif readOnlyForm EQ true>
						&nbsp; #CPhone#
					<cfelse>
						<input type="Text"  maxlength="25" name="CPhone" value="#CPhone#">
					</cfif>
					<input type="Hidden" name="CPhone_ATTRIBUTES" value="type=PHONE~required=1~FIELDNAME=Cell Phone">	
				</TD>
			</TR>
			<TR><TD align="right"> <b>Work Phone</b> <br>999-999-9999</TD>
				<TD>
					<cfif readOnlyForm EQ true>
						&nbsp; #WPhone#
					<cfelse>
						<input type="Text"  maxlength="25" name="WPhone" value="#WPhone#">
					</cfif>
					<input type="Hidden" name="WPhone_ATTRIBUTES" value="type=PHONE~required=0~FIELDNAME=Work Phone">	
				</TD>
			</TR>
			<TR><TD align="right"><b>Fax</b> <br>999-999-9999</TD>
				<TD>
					<cfif readOnlyForm EQ true>
						&nbsp; #Fax#
					<cfelse>
						<input type="Text"  maxlength="25" name="Fax" value="#Fax#">
					</cfif>
					<input type="Hidden" name="Fax_ATTRIBUTES" 		value="type=PHONE~required=0~FIELDNAME=Fax">	
				</TD>
			</TR>
			<TR><TD align="right">#required#<b>EMail</b></TD>
				<TD>
					<cfif readOnlyForm EQ true>
						&nbsp; #EMail#
					<cfelse>
						<input type="Text"  maxlength="100" name="EMail"  size="40" value="#EMail#">
					</cfif>
					<input type="Hidden" name="Email_ATTRIBUTES" 	value="type=EMAIL~required=1~FIELDNAME=Email">	
				</TD>
			</TR>
			<CFIF SESSION.MENUROLEID EQ 29 > 
				<TR>
					<TD align="right"><b>PASS NUMBER</b></TD>
					<TD>
						<cfif readOnlyForm EQ true>
							&nbsp; #pass_number#
						<cfelse>
							<input type="Text"  maxlength="100" name="pass_number"  size="25" value="#pass_number#">
						</cfif>
					</TD>
				</TR>
			</CFIF>
			<!--- Joe Lechuga 7/15/2011 - Added active_yn field to Edit form --->
			<cfif isdefined("active_yn") and readOnlyForm EQ false>
			<TR><TD align="right"><b>Active:</b></TD>
				<TD>
					<select name="active_yn">
						<option value="Y" #iif(active_yn eq 'Y',de('selected=true'),de(''))#>Yes</option>
						<option value="N" #iif(active_yn eq 'N',de('selected=true'),de(''))#>No</option>
					</select>
				</TD>
			</TR>
			<cfelseif isdefined("active_yn")>
				<input type="hidden" name="active_yn" value="#active_yn#">
			</cfif>
			<CFIF swShowLoginPW AND readOnlyForm EQ false>
				<TR><TD align="right"><b>Login</b></TD>
					<TD>
						<input type="Text"  maxlength="100" name="Login"	value="#Login#" >
						<input type="Hidden" name="Login_ATTRIBUTES" 	value="type=NOSPECIALCHAR~FIELDNAME=Login">
					</TD>	
				</TR>
				<TR><TD align="right"><b>Password</b></TD>
					<TD>
						<input type="Password" maxlength="100" name="Pwd" 	value="#Pwd#" >
						<input type="Hidden" name="Pwd_ATTRIBUTES" 	value="type=GENERIC~FIELDNAME=Password">	
					</TD>
				</TR>
				<TR><TD align="right"><b>Confirm Password</b></TD>
					<TD>
						<input type="Password" maxlength="100" name="ConfPwd" 	value="#ConfPwd#" >
						<input type="Hidden" name="ConfPwd_ATTRIBUTES" 	value="type=GENERIC~FIELDNAME=Confirm Password">
					</TD>
				</TR>
			</CFIF>
			<!--- ------------------------------------------------------------------------------------------------ --->
			<!--- REFEREE specific information ------------------------------------------------------------------- --->
			<CFIF SESSION.MENUROLEID EQ 25 OR isDefined("swAllowRefEntry")>		<!--- MENUROLEID=25=Referee 1=ADMIN --->
				<!--- <CFIF isDefined("swAllowRefEntry") AND swAllowRefEntry>
					<CFSET refDisableText = "">
				<CFELSE>
					<CFSET refDisableText = "disabled">
				</CFIF> --->
				<TR><TD colspan="2" align="left"><b>Referee Specific information:</b></TD>
				</TR>
				<TR><TD align="right"> #required# <b>Date Of Birth</b></TD><!--- #required# --->
					<TD><CFIF isDefined("swAllowRefEntry") AND swAllowRefEntry>
							<input type="Text"  maxlength="10" name="refDob"  value="#refDob#">
							<input type="Hidden" name="refDob_ATTRIBUTES" 	value="type=DATE~required=1~FIELDNAME=Date Of Birth">	
							<span class="red">(must be valid date as "mm/dd/yyyy")</span>
						<CFELSE>
							#refDob#
						</CFIF>
					</TD>
				</TR>
				<TR><TD align="right">#required#<b>Grade</b></TD>
					<TD><CFIF isDefined("swAllowRefEntry") AND swAllowRefEntry>
							<input maxlength="5" name="Grade"  value="#Grade#" >
							<input type="Hidden" name="Grade_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Grade">	
						<CFELSE>
							#Grade#
						</CFIF>
					</TD>
				</TR>
				<TR><TD align="right">#required#<b>State Registered In</b></TD>
					<TD><CFIF isDefined("swAllowRefEntry") AND swAllowRefEntry>
							<SELECT name="StateRegisteredIn"  > 
								<OPTION value="" selected>select state</OPTION>
								<cfloop from="1" to="#arrayLen(arrStates)#" index="iSt">
									<OPTION value="#arrStates[iSt][1]#" <cfif StateRegisteredIn EQ arrStates[iSt][1]>selected</cfif> >#arrStates[iSt][1]#</OPTION>
								</cfloop>
							</SELECT>
							<input type="Hidden" name="StateRegisteredIn_ATTRIBUTES" 	value="type=STATE~required=1~FIELDNAME=State Registered In">	
						<CFELSE>
							#StateRegisteredIn#
						</CFIF>
					</TD>
				</TR>
				<TR><TD align="right">#required#<b>USSF Certified</b></TD>
					<TD><CFIF isDefined("swAllowRefEntry") AND swAllowRefEntry>
							<SELECT name="Certified" > 
								<OPTION value="Y" <cfif Certified EQ "Y">selected</cfif> > Yes</OPTION>
								<OPTION value="N" <cfif Certified EQ "N">selected</cfif> > No</OPTION>
							</SELECT>
							<input type="Hidden" name="Certified_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=USSF Certified">	
						<CFELSE>
							#Certified#
						</CFIF>
					</td>
				</TR>
				<TR><TD align="right">#required#<b>Year First Certified</b></TD>
					<TD><CFIF isDefined("swAllowRefEntry") AND swAllowRefEntry>
							<input type="Text"  maxlength="4" name="refCertYear"  value="#refCertYear#">
							<input type="Hidden" name="refCertYear_ATTRIBUTES" value="type=Numeric~required=0~FIELDNAME=Year First Certified">	
							<span class="red">(enter 4 digit year "yyyy", if certified)</span>
						<CFELSE>
							#refCertYear#
						</CFIF>
					</TD>
				</TR>
				<CFIF isDefined("SESSION.MENUROLEID") AND ( SESSION.MENUROLEID EQ 0 OR SESSION.MENUROLEID EQ 1)>
				<!--- only show if Applying for ref (no menuroleid: public page) or you are an admin --->
					<TR><TD align="right"><b>Additional Info:</b></TD>
						<TD><CFIF isDefined("swAllowRefEntry") AND swAllowRefEntry>
								<!--- <input type="Text"  maxlength="4" name="additionalRefInfo"  value="#additionalRefInfo#"> --->
								<TEXTAREA name="additionalRefInfo" rows=3  cols=50>#Trim(additionalRefInfo)#</TEXTAREA>
								<input type="Hidden" name="additionalRefInfo_ATTRIBUTES" value="type=NOSPECIALCHAR~required=0~FIELDNAME=Additional Info">	
							<CFELSE>
								#additionalRefInfo#
							</CFIF>
						</TD>
					</TR>
				</CFIF>
				<CFIF isDefined("SESSION.MENUROLEID") AND SESSION.MENUROLEID EQ 1 >
				<!--- only show to admin --->
					<TR><TD align="right"><b>NCSA Level</b></TD>
						<TD><input type="Text"  maxlength="4" name="refNcsaLevel" 	value="#refNcsaLevel#">
						</TD>
					</TR>
				</CFIF>
			</CFIF> <!--- END Referee specific info -------------------------------------------------------------------- --->

			<!--- ----------------------------------------------------------------------------------------------------------- --->
			<!--- Board Member Specific Info.... ---------------------------------------------------------------------------- --->
			<CFIF swBoardMEMBER>
				<input type="Hidden" name="Sequence"	  value="#VARIABLES.Sequence#">
				<input type="Hidden" name="boardMemberID" value="#VARIABLES.boardMemberID#">
				<input type="Hidden" name="ncsaTitle"	  value="#VARIABLES.ncsaTitle#">
				<TR><TD colspan="2" align="left"><b>Board Member Specific information:</b></TD>
				</TR>
				<TR><TD align="right">#required#<b>NCSA Phone</b></TD>
					<TD><input type="Text"  maxlength="25" name="ncsaPhone" 	value="#ncsaPhone#" >
						<input type="Hidden" name="ncsaPhone_ATTRIBUTES" value="type=PHONE~required=1~FIELDNAME=NCSA Phone">	
					</TD>
				</TR>
				<TR><TD align="right">#required#<b>NCSA Fax</b></TD>
					<TD><input type="Text"  maxlength="25" name="ncsaFax" 	value="#ncsaFax#" >
						<input type="Hidden" name="ncsaFax_ATTRIBUTES" value="type=PHONE~required=1~FIELDNAME=NCSA Fax">	
					</TD>
				</TR>
				<TR><TD align="right">#required#<b>NCSA Email</b></TD>
					<TD><input type="Text"  maxlength="25" name="ncsaEmail" 	value="#ncsaEmail#" >
						<input type="Hidden" name="ncsaEmail_ATTRIBUTES" value="type=EMAIL~required=1~FIELDNAME=NCSA Email">	
					</TD>
				</TR>
			</CFIF> <!--- END board member INFO --->

		</table> <!--- END - left side Table --->
	</td>
	<td width="#col_2_width#">
		
	</td>

</tr>

</cfoutput>
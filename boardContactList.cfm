<!--- 
	FileName:	boardContactList.cfm
	Created on: 11/17/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: used to edit the board member's contact info
	
MODS: mm/dd/yyyy - flastname - comments

 --->

<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Board of Directors and Commissioners</H1>
<!--- <h2>yyyyyy </h2> --->


<cfif isDefined("FORM.AddMember")>
	<cflocation url="boardContactAdd.cfm">
</cfif>

<cfif isDefined("FORM.updateSequence")>
	<!--- re-sequence --->	
	 <!--- Initialize list that will hold boardmember ids in listed in new order --->
	<cfset BMIorder = "">
	<cfloop from="1" to="#FORM.MemberCount + 1#" index="iPos">
		<cfset BMIorder = listAppend(BMIorder,0)>
	</cfloop>	<!--- <cfdump var="#BMIorder#"> --->
	
	<!--- loop form looking for BMids and new sequence values --->
	<CFLOOP collection="#FORM#" item="iSeq">
		<cfif UCASE(listFirst(iSeq,"_")) EQ "NEWSEQ">
			<cfset bmID = listLast(iSeq,"_")> <!--- boardmember ID --->
			<cfif FORM[iSeq] LT 1>
				<cfset seq = 1>
			<cfelseif FORM[iSeq] GT FORM.MemberCount > 
				<cfset seq = FORM.MemberCount > 
			<cfelse>
				<cfset seq  = FORM[iSeq]>
			</cfif>
			<!--- <br> BMI=[#bmID#] newseq[#seq#] --->
			
			<cfif listGetAt(BMIorder,seq) EQ 0>
				<!--- set value, replace initialized 0 with ID at specified position --->
				<CFSET BMIorder = listSetAt(BMIorder,seq,bmID)>
			<CFELSE>
				<!--- insert value, the position is already occupied, insert id after position --->
				<CFSET BMIorder = listInsertAt(BMIorder,seq + 1,bmID)>
			</cfif>
		</cfif>
	</CFLOOP>	<!--- <br><cfdump var="#BMIorder#"> --->
	
	<cfset ctFound = 0>
	<!--- loop the list of BMids which are in the order they should appear, ignore 0's,  --->
	<cfloop list="#BMIorder#" index="iBMI">
		<cfif iBMI NEQ 0>
			<CFSET ctFound = ctFound + 1 >
			<!--- <br> update tbl_boardMember_info set sequence = #ctFound# where BMI = #iBMI#  --->
			<cfquery name="qUpdateSeq" datasource="#SESSION.DSN#">
				UPDATE TBL_BOARDMEMBER_INFO
				   SET SEQUENCE = #VARIABLES.ctFound#
				 WHERE BOARDMEMBER_ID = #VARIABLES.iBMI#
			</cfquery>
			
		</cfif>
	</cfloop>
</cfif>


<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="getBoardMemberInfo" returnvariable="boardMems">
	<cfinvokeargument name="DSN" value="#SESSION.DSN#">
</cfinvoke>  <!--- <cfdump var="#boardMems#"> --->


<form action="boardContactList.cfm" method="post">
<input type="Hidden" name="MemberCount" value="#boardMems.RECORDCOUNT#">
<table cellspacing="0" cellpadding="0"   align="left" border="0" width="98%" >
	<tr><td colspan="8"> &nbsp; </td>
	<tr>
	<tr class="tblHeading">
		<td width="20%"> Name	 </td>
		<td width="15%"> Active	 </td>
		<td width="50%"> Title	 </td>
		<td width="15%"> Sequence</td>
	</tr>

<!--- BOARDMEMBER_ID  
 	CONTACT_ID  	 
 	XREF_CONTACT_ROLE_ID  	
 --->
	<CFLOOP query="boardMems">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<td valign="top" class="tdUnderLine"> 
				<a href="boardContactEdit.cfm?bmid=#BOARDMEMBER_ID#"> #FIRSTNAME# #LASTNAME# </a> 
			</td>
			<td valign="top" align="left" class="tdUnderLine"> 
				<cfif ACTIVE_YN EQ "Y">
					<span class="green"><b>ACTIVE</b></span>
				<cfelse>
					<span class="red"><b>NOT Active</b></span>
				</cfif>
			</td>
			<td valign="top" class="tdUnderLine"> 
				Title: <b>#TITLE#</b>
				<br>
				Role:  #ROLE#
			</td>
			<td valign="top" class="tdUnderLine">		 
				<input type="Text" size="1" name="newSeq_#BOARDMEMBER_ID#" value="#SEQUENCE#">
				<!--- bmi[#BOARDMEMBER_ID#] cid[#CONTACT_ID#] xcr[#XREF_CONTACT_ROLE_ID#]	 --->
			</td>
		</tr>
	</CFLOOP>
		<tr><td colspan="2" align="left">
				<input type="Submit" name="AddMember"  value="ADD a Board Member">
			</td>
			<td colspan="2" align="right">
				<input type="Submit" name="updateSequence" value="Update Sequence">
			</td>
		</tr>
</table>
</form>  	
</div>
</cfoutput>
<cfinclude template="_footer.cfm">
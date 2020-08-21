<!--- 
	FileName:	feeSchedule.cfm
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
<H1 class="pageheading">NCSA - Team Registration - Fee Schedule</H1>
<br> <!--- <h2>yyyyyy </h2> --->

<cfif isDefined("FORM.SAVE")>
	<!--- loop to look for 17 field values (17 IDs) --->
	<CFLOOP from="1" to="17" index="idx">
		<!--- initialize for next ID --->
		<cfset FSId  = "" >
		<cfset InfoDetail  = "" >
		<cfset PaymentDetail = "" >
		<cfset FineDetail  = "" >
		<!--- loop form to find values for current ID --->
		<cfloop collection="#FORM#" item="ifn">
			<cfif listLast(ifn,"_") EQ idx>
				<!--- found a field for current id, which one is it? --->
				<cfswitch expression="#UCASE(listFirst(ifn,"_"))#">
					<cfcase value="FSID">			<cfset FSId  = trim(FORM[ifn]) >			</cfcase>
					<cfcase value="INFODETAIL">		<cfset InfoDetail  = trim(FORM[ifn]) >	</cfcase>
					<cfcase value="PAYMENTDETAIL">	<cfset PaymentDetail = trim(FORM[ifn]) >	</cfcase>
					<cfcase value="FINEDETAIL">		<cfset FineDetail  = trim(FORM[ifn]) >	</cfcase>
				</cfswitch>
			</cfif>
		</cfloop>
		<!--- we found all the values for the current id, do the update --->
		<CFQUERY name="qUpdFeesSched" datasource="#session.dsn#">
			Update tbl_FeeSchedule
			   set InfoDetail	 = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#InfoDetail#"	>
				 , PaymentDetail = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#PaymentDetail#"	>
				 , FineDetail	 = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FineDetail#"	>
			 Where FEESCHED_ID   = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FSId#"			>
		</CFQUERY>

	</CFLOOP>

</cfif>


<cfquery name="qGetFeeSchedule" datasource="#session.dsn#">
	Select FEESCHED_ID, InfoDetail, PaymentDetail, FineDetail
	  from tbl_FeeSchedule
</cfquery> <!--- <cfdump var="#tbl_FeeSchedule#"> --->


<FORM name="FeeSchedule" action="feeSchedule.cfm"  method="post">
<table cellspacing="0" cellpadding="1" align="left" border="0" width="100%">
	<tr class="tblHeading">
		<TD> &nbsp; Info Detail	</TD>
		<TD> &nbsp;	Payment Detail</TD>
		<TD> &nbsp;	Fine Detail</TD>
	</tr>
	<cfloop query="qGetFeeSchedule">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<TD class="tdUnderLine">
				<input type="hidden"	name="FSId_#FEESCHED_ID#"			value="#FEESCHED_ID#">
				<input maxlength="100"	name="InfoDetail_#FEESCHED_ID#"		value="#InfoDetail#">
			</td>
			<TD class="tdUnderLine">
				<input maxlength="100"	name="PaymentDetail_#FEESCHED_ID#"	value="#PaymentDetail#">
			</td>
			<TD class="tdUnderLine">
				<input maxlength="100"	name="FineDetail_#FEESCHED_ID#"		value="#FineDetail#">
			</td>
		</tr>
	</cfloop>
	<TR ><TD align=center>
			<INPUT type="submit" name="Save" value="Save" >
          </TD>
	</TR>
</table>	
</form>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">

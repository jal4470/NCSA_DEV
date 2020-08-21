<!--- 
	FileName:	regInfoDeadline.cfm
	Created on: 09/19/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Registration Deadlines</H1>
<br> <!--- <h2>yyyyyy </h2> --->

	<table cellspacing="0" cellpadding="5" align="LEFT" border="0" width="75%">
		<tr><td colspan="3">
				<table cellspacing="0" cellpadding="5" align="LEFT" border="0" width="100%">
					<tr class="tblHeading">
						<TD colspan="3">Late Fees or Credit per New Schedule (only ONE section applies) see Rule 2.3</TD>
					</tr>
				
					<CFQUERY name="qFee1" datasource="#SESSION.DSN#">
						Select * from tbl_FeeSchedule where Rectype = 1
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
						Select * from tbl_FeeSchedule where Rectype = 2					
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
									<!---	<p>  The league has found it necessary to raise packet costs due to the increase in insurance cost at the NJ state level	--->
							</span>
						</td>
					</tr>
				</TABLE>
			</td>
		</tr>	
	</TABLE>
 



 </cfoutput>
</div>
<cfinclude template="_footer.cfm">

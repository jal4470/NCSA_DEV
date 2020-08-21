<!--- 
	FileName:	newClubApplic.cfm
	Created on: 08/11/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

09-17-2012 - J. Rab - Added new copy changes (TICKET NCSA12504)
7/30/2018 M Greenberg (Ticket NCSA27075) - updated style to make responsive

 --->
 
<CFSET mid = 1>
<cfinclude template="_header.cfm">
<style>
	div{
      margin: 5px;}
   #label{
   		display: block;
   		font-weight: bold;
   		text-align: left; }
   	#label2{
   		display: block;
   		font-weight: bold;
   		text-align: left; }
   	#labelHome{
   		display: inline-block;
   		font-weight: bold;
   		text-align: left;
   		/*width: 50%;	*/}
   	#textarea{
   		width: 100%; }
   	#tblHead{
   		width: 100%; }
   	.button{
   		text-align: center; }
   	#tblTeamMobile{
   		display: none; }
   	.tblTeam thead tr {
  	    background-color: transparent; }
	.tblTeam thead th {
	  border-top: 1px solid #AEAEAE;
	  border-bottom: 1px solid #AEAEAE;
	  color: #333;
	  font-weight: bold;
	  padding: 10px 0;
	  text-transform: uppercase; }
@media screen and (min-width: 768px) {
	 #label{
   		display: inline-block;
/*   		font-weight: bold;*/
/*   		text-align: right;*/
   		width: 15%;	}
   	#label2{
   		display: inline-block;
   		font-weight: bold;
/*   		text-align: right;*/
   		width: 30%;	}
   	#labelHome{
   		display: inline-block;
   		font-weight: bold;
   		text-align: left;
   		/*width: 22%;*/	}
   	.col > input{
		width: 90%; }
   	.col2 > input{
   		width: 80%; }
   	#first > input{
   		width: 90%; }
	.col2_town > input{
		width: 90%; }
	.col4_state > input{
		width:45%; }
	.col4_zip > input{
		width:60%; }
	.col2_town{
		display: table-cell;
		width: 50%;
		margin: 3px; }
	.col4_state{
		display: table-cell;
		box-sizing: content-box;
		width: 18%;
		margin: 3px; }
	.col4_zip{
		display: table-cell;
		box-sizing: content-box;
/*		width: 25%;*/
		margin: 3px; }
	.col2_home {
		display: table-cell;
		width:30%; }
  } 
  @media screen and (max-width: 480px) {
  	#labelHome{
  		width: 55%;
  		text-align: left; }
  }
 @media screen and (max-width: 768px) {
	#tblTeam{
		display: none; }
	#tblTeamMobile{
		display: initial; }
	.formfield input{
		width: 100%; }

 }
</style>

<cfoutput>
<div id="contentText">

<h1 class="pageheading">Application by a New Club to Participate in NCSA League</h1>
<br />
<div class="h2_new">In order to permit NCSA to review applications sufficiently and to prepare for the upcoming season, including timely registration and flighting of teams, generally only those applications submitted as follows will be considered:</div>
<br />
<div class="h2_new">between March 15 and May 31 for the upcoming Fall season and</div>
<br />
<div class="h2_new">between September 15 and November 30 for the upcoming Spring season.</div>
<br />
<div class="h2_new">If there is a reason why your application is being submitted beyond the usual application period, please include that in the comments section below.</div>
<br />
<div class="h2_new">Generally NCSA will evaluate whether the number and level of teams is consistent with the NCSA current program in determining whether to admit the club to participate in NCSA.  As a general rule, a minimum of 3 teams is required.  Location of your program and level of play are important considerations.</div>
<br />
<div class="h2_new">Please complete the following data fields for your application to be considered.</div>
<br />
<CFIF isDefined("FORM.ClubName")>
	<CFSET ClubName = trim(FORM.ClubName)>
<CFELSE>
	<CFSET ClubName = "">
</CFIF>
<CFIF isDefined("FORM.ClubAddress")>
	<CFSET ClubAddress = trim(FORM.ClubAddress)>
<CFELSE>
	<CFSET ClubAddress = "">
</CFIF>
<CFIF isDefined("FORM.clubTown")>
	<CFSET clubTown = trim(FORM.clubTown)>
<CFELSE>
	<CFSET clubTown = "">
</CFIF>
<CFIF isDefined("FORM.clubState")>
	<CFSET clubState = trim(FORM.clubState)>
<CFELSE>
	<CFSET clubState = "">
</CFIF>
<CFIF isDefined("FORM.clubZip")>
	<CFSET clubZip = trim(FORM.clubZip)>
<CFELSE>
	<CFSET clubZip = "">
</CFIF>
<CFIF isDefined("FORM.PresFname")>
	<CFSET PresFname = trim(FORM.PresFname)>
<CFELSE>
	<CFSET PresFname = "">
</CFIF>
<CFIF isDefined("FORM.PresLname")>
	<CFSET PresLname = trim(FORM.PresLname)>
<CFELSE>
	<CFSET PresLname = "">
</CFIF>
<CFIF isDefined("FORM.PresAddress")>
	<CFSET PresAddress = trim(FORM.PresAddress)>
<CFELSE>
	<CFSET PresAddress = "">
</CFIF>
<CFIF isDefined("FORM.PresTown")>
	<CFSET PresTown = trim(FORM.PresTown)>
<CFELSE>
	<CFSET PresTown = "">
</CFIF>
<CFIF isDefined("FORM.PresState")>
	<CFSET PresState = trim(FORM.PresState)>
<CFELSE>
	<CFSET PresState = "">
</CFIF>
<CFIF isDefined("FORM.PresZip")>
	<CFSET PresZip = trim(FORM.PresZip)>
<CFELSE>
	<CFSET PresZip = "">
</CFIF>
<CFIF isDefined("FORM.PresHomePhone")>
	<CFSET PresHomePhone = trim(FORM.PresHomePhone)>
<CFELSE>
	<CFSET PresHomePhone = "">
</CFIF>
<CFIF isDefined("FORM.PresFax")>
	<CFSET PresFax = trim(FORM.PresFax)>
<CFELSE>
	<CFSET PresFax = "">
</CFIF>
<CFIF isDefined("FORM.PresWorkPhone")>
	<CFSET PresWorkPhone = trim(FORM.PresWorkPhone)>
<CFELSE>
	<CFSET PresWorkPhone = "">
</CFIF>
<CFIF isDefined("FORM.PresCellPhone")>
	<CFSET PresCellPhone = trim(FORM.PresCellPhone)>
<CFELSE>
	<CFSET PresCellPhone = "">
</CFIF>
<CFIF isDefined("FORM.PresEmail")>
	<CFSET PresEmail = trim(FORM.PresEmail)>
<CFELSE>
	<CFSET PresEmail = "">
</CFIF>
<CFIF isDefined("FORM.USSFCertReferees")>
	<CFSET USSFCertReferees = trim(FORM.USSFCertReferees)>
<CFELSE>
	<CFSET USSFCertReferees = 0>
</CFIF>
<CFIF isDefined("FORM.HomeFieldFull")>
	<CFSET HomeFieldFull = trim(FORM.HomeFieldFull)>
<CFELSE>
	<CFSET HomeFieldFull = "">
</CFIF>
<CFIF isDefined("FORM.HomeFieldSmall")>
	<CFSET HomeFieldSmall = trim(FORM.HomeFieldSmall)>
<CFELSE>
	<CFSET HomeFieldSmall = "">
</CFIF>
<CFIF isDefined("FORM.comments")>
	<CFSET comments = trim(FORM.comments)>
<CFELSE>
	<CFSET comments = "">
</CFIF>

<CFIF isDefined("FORM.B_Team_07")>  <CFSET B_Team_07  =trim(FORM.B_Team_07)>  <CFELSE> <CFSET B_Team_07  =""> </CFIF>
<CFIF isDefined("FORM.B_Team_08")>  <CFSET B_Team_08  =trim(FORM.B_Team_08)>  <CFELSE> <CFSET B_Team_08  =""> </CFIF>
<CFIF isDefined("FORM.B_Team_09")>  <CFSET B_Team_09  =trim(FORM.B_Team_09)>  <CFELSE> <CFSET B_Team_09  =""> </CFIF>
<CFIF isDefined("FORM.B_Team_10")>  <CFSET B_Team_10  =trim(FORM.B_Team_10)>  <CFELSE> <CFSET B_Team_10  =""> </CFIF>
<CFIF isDefined("FORM.B_Team_11")>  <CFSET B_Team_11  =trim(FORM.B_Team_11)>  <CFELSE> <CFSET B_Team_11  =""> </CFIF>
<CFIF isDefined("FORM.B_Team_12")>  <CFSET B_Team_12  =trim(FORM.B_Team_12)>  <CFELSE> <CFSET B_Team_12  =""> </CFIF>
<CFIF isDefined("FORM.B_Team_13")>  <CFSET B_Team_13  =trim(FORM.B_Team_13)>  <CFELSE> <CFSET B_Team_13  =""> </CFIF>
<CFIF isDefined("FORM.B_Team_14")>  <CFSET B_Team_14  =trim(FORM.B_Team_14)>  <CFELSE> <CFSET B_Team_14  =""> </CFIF>
<CFIF isDefined("FORM.B_Team_15")>  <CFSET B_Team_15  =trim(FORM.B_Team_15)>  <CFELSE> <CFSET B_Team_15  =""> </CFIF>
<CFIF isDefined("FORM.B_Team_16")>  <CFSET B_Team_16  =trim(FORM.B_Team_16)>  <CFELSE> <CFSET B_Team_16  =""> </CFIF>
<CFIF isDefined("FORM.B_Team_17")>  <CFSET B_Team_17  =trim(FORM.B_Team_17)>  <CFELSE> <CFSET B_Team_17  =""> </CFIF>
<CFIF isDefined("FORM.B_Team_18")>  <CFSET B_Team_18  =trim(FORM.B_Team_18)>  <CFELSE> <CFSET B_Team_18  =""> </CFIF>
<CFIF isDefined("FORM.B_Level_07")> <CFSET B_Level_07 =trim(FORM.B_Level_07)> <CFELSE> <CFSET B_Level_07 =""> </CFIF>
<CFIF isDefined("FORM.B_Level_08")> <CFSET B_Level_08 =trim(FORM.B_Level_08)> <CFELSE> <CFSET B_Level_08 =""> </CFIF>
<CFIF isDefined("FORM.B_Level_09")> <CFSET B_Level_09 =trim(FORM.B_Level_09)> <CFELSE> <CFSET B_Level_09 =""> </CFIF>
<CFIF isDefined("FORM.B_Level_10")> <CFSET B_Level_10 =trim(FORM.B_Level_10)> <CFELSE> <CFSET B_Level_10 =""> </CFIF>
<CFIF isDefined("FORM.B_Level_11")> <CFSET B_Level_11 =trim(FORM.B_Level_11)> <CFELSE> <CFSET B_Level_11 =""> </CFIF>
<CFIF isDefined("FORM.B_Level_12")> <CFSET B_Level_12 =trim(FORM.B_Level_12)> <CFELSE> <CFSET B_Level_12 =""> </CFIF>
<CFIF isDefined("FORM.B_Level_13")> <CFSET B_Level_13 =trim(FORM.B_Level_13)> <CFELSE> <CFSET B_Level_13 =""> </CFIF>
<CFIF isDefined("FORM.B_Level_14")> <CFSET B_Level_14 =trim(FORM.B_Level_14)> <CFELSE> <CFSET B_Level_14 =""> </CFIF>
<CFIF isDefined("FORM.B_Level_15")> <CFSET B_Level_15 =trim(FORM.B_Level_15)> <CFELSE> <CFSET B_Level_15 =""> </CFIF>
<CFIF isDefined("FORM.B_Level_16")> <CFSET B_Level_16 =trim(FORM.B_Level_16)> <CFELSE> <CFSET B_Level_16 =""> </CFIF>
<CFIF isDefined("FORM.B_Level_17")> <CFSET B_Level_17 =trim(FORM.B_Level_17)> <CFELSE> <CFSET B_Level_17 =""> </CFIF>
<CFIF isDefined("FORM.B_Level_18")> <CFSET B_Level_18 =trim(FORM.B_Level_18)> <CFELSE> <CFSET B_Level_18 =""> </CFIF>
<CFIF isDefined("FORM.G_Team_07")>  <CFSET G_Team_07  =trim(FORM.G_Team_07)>  <CFELSE> <CFSET G_Team_07  =""> </CFIF>
<CFIF isDefined("FORM.G_Team_08")>  <CFSET G_Team_08  =trim(FORM.G_Team_08)>  <CFELSE> <CFSET G_Team_08  =""> </CFIF>
<CFIF isDefined("FORM.G_Team_09")>  <CFSET G_Team_09  =trim(FORM.G_Team_09)>  <CFELSE> <CFSET G_Team_09  =""> </CFIF>
<CFIF isDefined("FORM.G_Team_10")>  <CFSET G_Team_10  =trim(FORM.G_Team_10)>  <CFELSE> <CFSET G_Team_10  =""> </CFIF>
<CFIF isDefined("FORM.G_Team_11")>  <CFSET G_Team_11  =trim(FORM.G_Team_11)>  <CFELSE> <CFSET G_Team_11  =""> </CFIF>
<CFIF isDefined("FORM.G_Team_12")>  <CFSET G_Team_12  =trim(FORM.G_Team_12)>  <CFELSE> <CFSET G_Team_12  =""> </CFIF>
<CFIF isDefined("FORM.G_Team_13")>  <CFSET G_Team_13  =trim(FORM.G_Team_13)>  <CFELSE> <CFSET G_Team_13  =""> </CFIF>
<CFIF isDefined("FORM.G_Team_14")>  <CFSET G_Team_14  =trim(FORM.G_Team_14)>  <CFELSE> <CFSET G_Team_14  =""> </CFIF>
<CFIF isDefined("FORM.G_Team_15")>  <CFSET G_Team_15  =trim(FORM.G_Team_15)>  <CFELSE> <CFSET G_Team_15  =""> </CFIF>
<CFIF isDefined("FORM.G_Team_16")>  <CFSET G_Team_16  =trim(FORM.G_Team_16)>  <CFELSE> <CFSET G_Team_16  =""> </CFIF>
<CFIF isDefined("FORM.G_Team_17")>  <CFSET G_Team_17  =trim(FORM.G_Team_17)>  <CFELSE> <CFSET G_Team_17  =""> </CFIF>
<CFIF isDefined("FORM.G_Team_18")>  <CFSET G_Team_18  =trim(FORM.G_Team_18)>  <CFELSE> <CFSET G_Team_18  =""> </CFIF>
<CFIF isDefined("FORM.G_Level_07")> <CFSET G_Level_07 =trim(FORM.G_Level_07)> <CFELSE> <CFSET G_Level_07 =""> </CFIF>
<CFIF isDefined("FORM.G_Level_08")> <CFSET G_Level_08 =trim(FORM.G_Level_08)> <CFELSE> <CFSET G_Level_08 =""> </CFIF>
<CFIF isDefined("FORM.G_Level_09")> <CFSET G_Level_09 =trim(FORM.G_Level_09)> <CFELSE> <CFSET G_Level_09 =""> </CFIF>
<CFIF isDefined("FORM.G_Level_10")> <CFSET G_Level_10 =trim(FORM.G_Level_10)> <CFELSE> <CFSET G_Level_10 =""> </CFIF>
<CFIF isDefined("FORM.G_Level_11")> <CFSET G_Level_11 =trim(FORM.G_Level_11)> <CFELSE> <CFSET G_Level_11 =""> </CFIF>
<CFIF isDefined("FORM.G_Level_12")> <CFSET G_Level_12 =trim(FORM.G_Level_12)> <CFELSE> <CFSET G_Level_12 =""> </CFIF>
<CFIF isDefined("FORM.G_Level_13")> <CFSET G_Level_13 =trim(FORM.G_Level_13)> <CFELSE> <CFSET G_Level_13 =""> </CFIF>
<CFIF isDefined("FORM.G_Level_14")> <CFSET G_Level_14 =trim(FORM.G_Level_14)> <CFELSE> <CFSET G_Level_14 =""> </CFIF>
<CFIF isDefined("FORM.G_Level_15")> <CFSET G_Level_15 =trim(FORM.G_Level_15)> <CFELSE> <CFSET G_Level_15 =""> </CFIF>
<CFIF isDefined("FORM.G_Level_16")> <CFSET G_Level_16 =trim(FORM.G_Level_16)> <CFELSE> <CFSET G_Level_16 =""> </CFIF>
<CFIF isDefined("FORM.G_Level_17")> <CFSET G_Level_17 =trim(FORM.G_Level_17)> <CFELSE> <CFSET G_Level_17 =""> </CFIF>
<CFIF isDefined("FORM.G_Level_18")> <CFSET G_Level_18 =trim(FORM.G_Level_18)> <CFELSE> <CFSET G_Level_18 =""> </CFIF>


<cfset swShowForm = true>





<CFIF isDefined("FORM.SUBMIT")>
	<cfinvoke component="#SESSION.sitevars.cfcPath#formValidate" method="validateFields" returnvariable="stValidFields">
		<cfinvokeargument name="formFields" value="#FORM#">
	</cfinvoke>  <!--- <cfdump var="#stValidFields#"> --->
	
	<CFIF stValidFields.errors>
		<SPAN class="red">
			<b>Please correct the following errors and submit again.</b>
			<br>
			#stValidFields.errorMessage#
		</SPAN>
	<CFELSE>
		<!--- all fields passed validation, INSERT new club request --->
		<CFSET stNewInfo = structNew()>
		<CFSET stNewInfo.ClubName 		= FORM.ClubName>
		<CFSET stNewInfo.ClubAddress 	= FORM.ClubAddress>
		<CFSET stNewInfo.clubTown 		= FORM.clubTown>
		<CFSET stNewInfo.clubState 		= FORM.clubState>
		<CFSET stNewInfo.clubZip 		= FORM.clubZip>
		<CFSET stNewInfo.USSFCertReferees = FORM.USSFCertReferees>
		<CFSET stNewInfo.HomeFieldFull 	= FORM.HomeFieldFull>
		<CFSET stNewInfo.HomeFieldSmall = FORM.HomeFieldSmall>
		<CFSET stNewInfo.comments 		= FORM.comments>
		<CFSET stNewInfo.PresFname 		= FORM.PresFname>
		<CFSET stNewInfo.PresLname 		= FORM.PresLname>
		<CFSET stNewInfo.PresAddress 	= FORM.PresAddress>
		<CFSET stNewInfo.PresTown 		= FORM.PresTown>
		<CFSET stNewInfo.PresState 		= FORM.PresState>
		<CFSET stNewInfo.PresZip 		= FORM.PresZip>
		<CFSET stNewInfo.PresHomePhone 	= FORM.PresHomePhone>
		<CFSET stNewInfo.PresFax 		= FORM.PresFax>
		<CFSET stNewInfo.PresWorkPhone 	= FORM.PresWorkPhone>
		<CFSET stNewInfo.PresCellPhone 	= FORM.PresCellPhone>
		<CFSET stNewInfo.PresEmail 		= FORM.PresEmail>
		
		<CFIF isDefined("SESSION.regseason.ID")>
			<CFSET stNewInfo.seasonID = SESSION.regseason.ID>
		<CFELSE>
			<CFSET stNewInfo.seasonID = SESSION.currentseason.ID>
		</CFIF>

		<!--- save team info in a structure to pass to the cfc --->
		<CFSET stTeams = structNew()>
		<CFSET stTeams.B = structNew()>
			<CFSET stTeams.B.07 = structNew()>
			<CFSET stTeams.B.08 = structNew()>
			<CFSET stTeams.B.09 = structNew()>
			<CFSET stTeams.B.10 = structNew()>
			<CFSET stTeams.B.11 = structNew()>
			<CFSET stTeams.B.12 = structNew()>
			<CFSET stTeams.B.13 = structNew()>
			<CFSET stTeams.B.14 = structNew()>
			<CFSET stTeams.B.15 = structNew()>
			<CFSET stTeams.B.16 = structNew()>
			<CFSET stTeams.B.17 = structNew()>
			<CFSET stTeams.B.18 = structNew()>
		<CFSET stTeams.G = structNew()>
			<CFSET stTeams.G.07 = structNew()>
			<CFSET stTeams.G.08 = structNew()>
			<CFSET stTeams.G.09 = structNew()>
			<CFSET stTeams.G.10 = structNew()>
			<CFSET stTeams.G.11 = structNew()>
			<CFSET stTeams.G.12 = structNew()>
			<CFSET stTeams.G.13 = structNew()>
			<CFSET stTeams.G.14 = structNew()>
			<CFSET stTeams.G.15 = structNew()>
			<CFSET stTeams.G.16 = structNew()>
			<CFSET stTeams.G.17 = structNew()>
			<CFSET stTeams.G.18 = structNew()>

		<CFLOOP collection="#FORM#" item="iTm">
			<!--- find all the "B_" and "G_" FORM fields --->
			<CFIF listFirst(iTm,"_") EQ "B" OR listFirst(iTm,"_") EQ "G" >
				<!--- skip "_ATTRIBUTES" --->
				<CFIF listLast(iTm,"_") NEQ "ATTRIBUTES">
					<!--- find the ones with values --->
					<CFIF len(trim(EVALUATE(iTm)))>
						<!--- <br>#itm# [ #EVALUATE(iTm)# ] --->
						<CFSET age = listLast(iTm,"_")>
						<CFSET BG  = ListFirst(iTm,"_")>
						<CFIF listGetAt(iTm,2,"_") EQ "LEVEL">
							<CFSET stTeams[BG][age].level = EVALUATE(iTm) >
						<CFELSE>
							<CFSET stTeams[BG][age].count = EVALUATE(iTm) >
						</CFIF>
					</CFIF>	
				</CFIF>
			</CFIF>
		</CFLOOP> <!--- <cfdump var="#stTeams#"> --->	

		<CFSET stNewInfo.stTeams = stTeams>

		<cfinvoke component="#SESSION.sitevars.cfcPath#registration" method="insertNewClubRequest" returnvariable="XclubReqId">
			<cfinvokeargument name="stNewClubInfo" value="#stNewInfo#" >
		</cfinvoke>  <!--- <cfdump var="#stValidFields#"> --->

		<CFIF XclubReqId GT 0>

			<cfset swShowForm = false>

			<BR> <span class="red"><b>Your Club Registration Request has been submitted. </b></span>
			<BR> <span class="red"> 
			A member of the committee which reviews club applications to join NCSA will contact you. That member will report the information to the NCSA board for a decision. The board meets only once per month, so please be patient. If you have any questions or have additional information to share, please contact NCSA through its Administrative Assistant – you can find info on the “Contact Us” page, found through the link below.
			 </span> 

			<CFSET ClubName = "">
			<CFSET ClubAddress = "">
			<CFSET clubTown = "">
			<CFSET clubState = "">
			<CFSET clubZip = "">
			<CFSET PresFname = "">
			<CFSET PresLname = "">
			<CFSET PresAddress = "">
			<CFSET PresTown = "">
			<CFSET PresState = "">
			<CFSET PresZip = "">
			<CFSET PresHomePhone = "">
			<CFSET PresFax = "">
			<CFSET PresWorkPhone = "">
			<CFSET PresCellPhone = "">
			<CFSET PresEmail = "">
			<CFSET USSFCertReferees = "">
			<CFSET HomeFieldFull = "">
			<CFSET HomeFieldSmall = "">
			<CFSET comments = "">
			<CFSET B_Team_07  ="">
			<CFSET B_Team_08  ="">
			<CFSET B_Team_09  ="">
			<CFSET B_Team_10  ="">
			<CFSET B_Team_11  ="">
			<CFSET B_Team_12  ="">
			<CFSET B_Team_13  ="">
			<CFSET B_Team_14  ="">
			<CFSET B_Team_15  ="">
			<CFSET B_Team_16  ="">
			<CFSET B_Team_17  ="">
			<CFSET B_Team_18  ="">
			<CFSET B_Level_07 ="">
			<CFSET B_Level_08 ="">
			<CFSET B_Level_09 ="">
			<CFSET B_Level_10 ="">
			<CFSET B_Level_11 ="">
			<CFSET B_Level_12 ="">
			<CFSET B_Level_13 ="">
			<CFSET B_Level_14 ="">
			<CFSET B_Level_15 ="">
			<CFSET B_Level_16 ="">
			<CFSET B_Level_17 ="">
			<CFSET B_Level_18 ="">
			<CFSET G_Team_07  ="">
			<CFSET G_Team_08  ="">
			<CFSET G_Team_09  ="">
			<CFSET G_Team_10  ="">
			<CFSET G_Team_11  ="">
			<CFSET G_Team_12  ="">
			<CFSET G_Team_13  ="">
			<CFSET G_Team_14  ="">
			<CFSET G_Team_15  ="">
			<CFSET G_Team_16  ="">
			<CFSET G_Team_17  ="">
			<CFSET G_Team_18  ="">
			<CFSET G_Level_07 ="">
			<CFSET G_Level_08 ="">
			<CFSET G_Level_09 ="">
			<CFSET G_Level_10 ="">
			<CFSET G_Level_11 ="">
			<CFSET G_Level_12 ="">
			<CFSET G_Level_13 ="">
			<CFSET G_Level_14 ="">
			<CFSET G_Level_15 ="">
			<CFSET G_Level_16 ="">
			<CFSET G_Level_17 ="">
			<CFSET G_Level_18 ="">

		<CFELSE>
			<BR> <span class="red"> There was an error processing your request. </span>
		</CFIF>

		 
	</CFIF>
</CFIF>


<CFIF swShowForm>
<div class="newClubApp">
	<FORM name="newClubAppl" action="newClubApplic.cfm"  method="post">
	
	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>">
	
<!--- 	<TABLE  cellSpacing=0 cellPadding=3 width="85%" border=0 class="newClubApp"> --->
		<!--- ====================================================================== --->
		<div class="Heading">
			Club Info
		</div>
		<div class="row form_field"> 
			<div class="col" id="label"><label>Information Date</label></div> #DateFormat(now(),"MM/DD/YYYY")#
		</div>
		<div class="row form_field"> 
			<div class="col">
				<div id="label"><label> #required# Club Name</label></div>
			<input id="input" maxlength="50" name="ClubName"  value="#clubName#" >	
				<input type="Hidden" name="ClubName_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=Club Name">
			</div>
		</div>
		<div class="row form_field">
			<div class="col">
				<div id="label"><label> #required# Address</label></div>
			<input id="input" maxlength="100" name="ClubAddress" value="#clubAddress#">	
				<input type="Hidden" name="ClubAddress_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=Club Address">
			</div>	
		</div>
		<div class="row form_field">
			<div class="col2_town">
				<div id="label"><label> #required# Town</label></div>
				<input id="input" maxlength="50" name="clubTown"  value="#clubTown#" >	
				<input type="Hidden" name="clubTown_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=Club Town">	
			</div>
	<!--- 	</div> --->
<!--- 		<div class="row form_field"> --->
			<div class="col4_state"><div id="label2"><label> #required# State</label></div>
				<input maxlength="2"  size="3"  name="clubState" value="#clubState#">
				<input type="Hidden" name="clubState_ATTRIBUTES" value="type=STATE~required=1~FIELDNAME=Club State">
			</div>
			<div class="col4_zip"><div id="label2"><label> #required# Zip</label></div>
				<input maxlength="10" size="10" name="clubZip"   value="#clubZip#">
				<input type="Hidden" name="clubZip_ATTRIBUTES" value="type=ZIPCODE~required=1~FIELDNAME=Club Zip">
			</div>	
		</div>
		<!--- ====================================================================== --->
		<div class="Heading">
			President Info
		</div>
		<div class="name row form_field">
			<div class="col2"  id="first">
				<div id="label2"> #required# First Name</div>
					<input maxlength="25" name="PresFname" value="#PresFname#" >
					<input type="Hidden" name="PresFname_ATTRIBUTES" value="type=ALPHA~required=1~FIELDNAME=President First Name">	
			</div>
			<div class="col2 form_field">
				<div id="label2"> #required# Last Name</div>
					<input maxlength="25" name="PresLname" value="#PresLname#"  >
					<input type="Hidden" name="PresLname_ATTRIBUTES" value="type=ALPHA~required=1~FIELDNAME=President Last Name">
			</div>		 
		</div>
		<div class="row form_field">
			<div class="col">
				<div id="label"><label> #required# Address</label></div>
					<input id="input" maxlength="50" name="PresAddress" value="#PresAddress#" >
					<input type="Hidden" name="PresAddress_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=President Address">	
			</div>
		</div>
		<div class="row form_field"> 
			<div class="col2_town">
				<div id="label"><label> #required# Town</label></div>
					<input id="input" maxlength="30" name="PresTown" value="#PresTown#" >		
					<input type="Hidden" name="PresTown_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=President Town">
			</div>
<!--- 		</div>
		<div class="row form_field">  --->
			<div class="col4_state">
				<div id="label2"><label> #required# State</label></div>
					<input maxlength="2" name="PresState" value="#PresState#" >
					<input type="Hidden" name="PresState_ATTRIBUTES" value="type=STATE~required=1~FIELDNAME=President State">	
			</div>
			<div class="col4_zip">
				<div id="label2"><label> #required# Zip</label></div>	
					<input maxlength="10" size="10" name="PresZip" value="#PresZip#" >
					<input type="Hidden" name="PresZip_ATTRIBUTES" value="type=ZIPCODE~required=1~FIELDNAME=President Zip Code">
				</div>		
			</div>
		</div>
		<div class="name row form_field"> 
			<div class="col2" id="first">
				<div id="label2"><label> #required# Home Phone</label></div>
					<input maxlength="25" name="PresHomePhone" value="#PresHomePhone#" >
					<input type="Hidden" name="PresHomePhone_ATTRIBUTES" value="type=PHONE~required=1~FIELDNAME=President Home Phone">
			</div>	
			<div class="col2">
				<div id="label2"><label>Cell Phone</label></div>
					<input maxlength="25" name="PresCellPhone" value="#PresCellPhone#" >
					<input type="Hidden" name="PresCellPhone_ATTRIBUTES" value="type=PHONE~required=0~FIELDNAME=President Cell Phone">	
			</div>
		</div>
		<div class="name row form_field">
			<div class="col2" id="first">
				<div id="label2"><label>Fax</label></div>
					<input maxlength="25"  name="PresFax" value="#PresFax#" >
					<input type="Hidden" name="PresFax_ATTRIBUTES" value="type=PHONE~required=0~FIELDNAME=President Fax">
			</div>
			<div class="col2"><div id="label2"><label>Work Phone</label></div>
					<input maxlength="25"  name="PresWorkPhone" value="#PresWorkPhone#" >
					<input type="Hidden" name="PresWorkPhone_ATTRIBUTES" value="type=PHONE~required=0~FIELDNAME=President Work Phone">	
			</div>
		</div>
		<div class="row form_field">
			<div class="col">
				<div id="label"><label>#required#  EMail</label></div>
					<input id="input" maxlength="50" name="PresEmail" value="#PresEmail#" >	
					<input type="Hidden" name="PresEmail_ATTRIBUTES" value="type=EMAIL~required=1~FIELDNAME=President Email">
			</div>	
		</div>
		<!--- ====================================================================== --->
		<div class="Heading">
			Field/Team Info
		</div>
		<div class="tdUnderLine">
			<div class="col" style="display: none;"><div id="label"><label> #required# USSF Certified Referees</label></div>
					<input maxlength="25" size="3" name="USSFCertReferees" value="#USSFCertReferees#" >
					<input type="Hidden" name="USSFCertReferees_ATTRIBUTES" value="type=NUMERIC~required=1~FIELDNAME=USS Cert. Refs">	
			</div>
			<div class="row form_field">
				<div class="col2_home">
					<div id="labelHome"> #required# Home Fields - Full Sided</div>
						<input maxlength="25" size="3" name="HomeFieldFull" value="#HomeFieldFull#" >
						<input type="Hidden" name="HomeFieldFull_ATTRIBUTES" value="type=NUMERIC~required=1~FIELDNAME=Home Fields Full Sided">
				</div>	
<!--- 			</div>
			<div class="row form_field"> --->
				<div class="col2_home">
					<div id="labelHome"> #required# Home Fields - Small Sided</div>
						<input maxlength="25" size="3" name="HomeFieldSmall" value="#HomeFieldSmall#" >
						<input type="Hidden" name="HomeFieldSmall_ATTRIBUTES" value="type=NUMERIC~required=1~FIELDNAME=Home Fields Small Sided">	
				</div>
			</div> 
		</div>
		<!--- ====================================================================== --->
		<div>
				<font size=2>
					<!---    - Enter number of teams under the AgeGroup column in Boys/Girls Row
					<br>- Play Levels are A, B, C, D, E, F, G--->
			<ul style="list-style-image:none;  
				        list-style-position:outside;  
				        list-style-type:none;  
				        margin-left:0;  
				        padding-left:1em;  
				        text-indent:-1em; ">
				<li style="margin-bottom: 5px;">- Please enter number of teams you wish to register next season in the applicable age column, and in the appropriate row for boys and girls teams.</li>
					
				<li style="margin-bottom: 5px;">- Please indicate the anticipated Play Level for each team expected to be registered.  Use a rating of A, B, C, D or E, with A being the highest level and E being the lowest level (NCSA has more than 5 flights per age level, but this provides the necessary information).  If you indicated that you expect to register more than one team in an age group, only indicate the play level of the higher level team – indicate the level of other teams in the comments section.  If a team is comparable to teams in an existing NCSA flight based upon tournament or other competition, please include that also in the comments below.</li>

				<li style="margin-bottom: 5px;">- If the application is for the Fall season, but you expect to register U15 and above teams for Spring, please include those teams also in the list and comments.</li>

				<li style="margin-bottom: 5px;">- If you have additional teams in the club which will not register with NCSA, please indicate in the comments section what league they play and why those teams are not expected to be registered in NCSA.</li>
			</ul>

				</font>
		</div>
		<div class="tdUnderLine">
			<table cellSpacing=0 cellPadding=0 border=1 align="center" id="tblTeam">
				<TR class="Heading"">
				<thead>
					<td align="right">&nbsp; </td>
					<td align="center"> U-07 </td>
					<td align="center"> U-08 </td>
					<td align="center"> U-09 </td>
					<td align="center"> U-10 </td>
					<td align="center"> U-11 </td>
					<td align="center"> U-12 </td>
					<td align="center"> U-13 </td>
					<td align="center"> U-14 </td>
					<td align="center"> U-15 </td>
					<td align="center"> U-16 </td>
					<td align="center"> U-17 </td>
					<td align="center"> U-18 </td>
				</thead>
				</tr>
				<tbody>
				<tr><td align="center" id="teams">## Boys teams </td>
					<td align="center"><input maxlength=2 name="B_Team_07" size=1 value="#VARIABLES.B_Team_07#"></td>
					<td align="center"><input maxlength=2 name="B_Team_08" size=1 value="#VARIABLES.B_Team_08#"></td>
					<td align="center"><input maxlength=2 name="B_Team_09" size=1 value="#VARIABLES.B_Team_09#"></td>
					<td align="center"><input maxlength=2 name="B_Team_10" size=1 value="#VARIABLES.B_Team_10#"></td>
					<td align="center"><input maxlength=2 name="B_Team_11" size=1 value="#VARIABLES.B_Team_11#"></td>
					<td align="center"><input maxlength=2 name="B_Team_12" size=1 value="#VARIABLES.B_Team_12#"></td>
					<td align="center"><input maxlength=2 name="B_Team_13" size=1 value="#VARIABLES.B_Team_13#"></td>
					<td align="center"><input maxlength=2 name="B_Team_14" size=1 value="#VARIABLES.B_Team_14#"></td>
					<td align="center"><input maxlength=2 name="B_Team_15" size=1 value="#VARIABLES.B_Team_15#"></td>
					<td align="center"><input maxlength=2 name="B_Team_16" size=1 value="#VARIABLES.B_Team_16#"></td>
					<td align="center"><input maxlength=2 name="B_Team_17" size=1 value="#VARIABLES.B_Team_17#"></td>
					<td align="center"><input maxlength=2 name="B_Team_18" size=1 value="#VARIABLES.B_Team_18#"></td>
				</tr>
				<tr><td align="center" id="teams"> Boys Level </td>
					<td align="center"><input maxlength=1 name="B_Level_07" size=1 value="#VARIABLES.B_Level_07#"></td>
					<td align="center"><input maxlength=1 name="B_Level_08" size=1 value="#VARIABLES.B_Level_08#"></td>
					<td align="center"><input maxlength=1 name="B_Level_09" size=1 value="#VARIABLES.B_Level_09#"></td>
					<td align="center"><input maxlength=1 name="B_Level_10" size=1 value="#VARIABLES.B_Level_10#"></td>
					<td align="center"><input maxlength=1 name="B_Level_11" size=1 value="#VARIABLES.B_Level_11#"></td>
					<td align="center"><input maxlength=1 name="B_Level_12" size=1 value="#VARIABLES.B_Level_12#"></td>
					<td align="center"><input maxlength=1 name="B_Level_13" size=1 value="#VARIABLES.B_Level_13#"></td>
					<td align="center"><input maxlength=1 name="B_Level_14" size=1 value="#VARIABLES.B_Level_14#"></td>
					<td align="center"><input maxlength=1 name="B_Level_15" size=1 value="#VARIABLES.B_Level_15#"></td>
					<td align="center"><input maxlength=1 name="B_Level_16" size=1 value="#VARIABLES.B_Level_16#"></td>
					<td align="center"><input maxlength=1 name="B_Level_17" size=1 value="#VARIABLES.B_Level_17#"></td>
					<td align="center"><input maxlength=1 name="B_Level_18" size=1 value="#VARIABLES.B_Level_18#"></td>
				</tr>
				<tr><td align="center" id="teams">## Girls teams</td>
					<td align="center"><input maxlength=2 name="G_Team_07" size=1 value="#VARIABLES.G_Team_07#"></td>
					<td align="center"><input maxlength=2 name="G_Team_08" size=1 value="#VARIABLES.G_Team_08#"></td>
					<td align="center"><input maxlength=2 name="G_Team_09" size=1 value="#VARIABLES.G_Team_09#"></td>
					<td align="center"><input maxlength=2 name="G_Team_10" size=1 value="#VARIABLES.G_Team_10#"></td>
					<td align="center"><input maxlength=2 name="G_Team_11" size=1 value="#VARIABLES.G_Team_11#"></td>
					<td align="center"><input maxlength=2 name="G_Team_12" size=1 value="#VARIABLES.G_Team_12#"></td>
					<td align="center"><input maxlength=2 name="G_Team_13" size=1 value="#VARIABLES.G_Team_13#"></td>
					<td align="center"><input maxlength=2 name="G_Team_14" size=1 value="#VARIABLES.G_Team_14#"></td>
					<td align="center"><input maxlength=2 name="G_Team_15" size=1 value="#VARIABLES.G_Team_15#"></td>
					<td align="center"><input maxlength=2 name="G_Team_16" size=1 value="#VARIABLES.G_Team_16#"></td>
					<td align="center"><input maxlength=2 name="G_Team_17" size=1 value="#VARIABLES.G_Team_17#"></td>
					<td align="center"><input maxlength=2 name="G_Team_18" size=1 value="#VARIABLES.G_Team_18#"></td>
				</tr>
				<tr><td align="center" id="teams"> Girls Level </td>
					<td align="center"><input maxlength=1 name="G_Level_07" size=1 value="#VARIABLES.G_Level_07#"></td>
					<td align="center"><input maxlength=1 name="G_Level_08" size=1 value="#VARIABLES.G_Level_08#"></td>
					<td align="center"><input maxlength=1 name="G_Level_09" size=1 value="#VARIABLES.G_Level_09#"></td>
					<td align="center"><input maxlength=1 name="G_Level_10" size=1 value="#VARIABLES.G_Level_10#"></td>
					<td align="center"><input maxlength=1 name="G_Level_11" size=1 value="#VARIABLES.G_Level_11#"></td>
					<td align="center"><input maxlength=1 name="G_Level_12" size=1 value="#VARIABLES.G_Level_12#"></td>
					<td align="center"><input maxlength=1 name="G_Level_13" size=1 value="#VARIABLES.G_Level_13#"></td>
					<td align="center"><input maxlength=1 name="G_Level_14" size=1 value="#VARIABLES.G_Level_14#"></td>
					<td align="center"><input maxlength=1 name="G_Level_15" size=1 value="#VARIABLES.G_Level_15#"></td>
					<td align="center"><input maxlength=1 name="G_Level_16" size=1 value="#VARIABLES.G_Level_16#"></td>
					<td align="center"><input maxlength=1 name="G_Level_17" size=1 value="#VARIABLES.G_Level_17#"></td>
					<td align="center"><input maxlength=1 name="G_Level_18" size=1 value="#VARIABLES.G_Level_18#"></td>
				</tr>
				</tbody>
			</table>

			<table cellSpacing=0 cellPadding=0 border=1 align="center" id="tblTeamMobile">
				<TR class="Heading">
				<thead>
					<td align="right">&nbsp; </td>
					<td align="center" id="teams">## Boys teams </td>
					<td align="center" id="teams"> Boys Level </td>
					<td align="center" id="teams">## Girls teams</td>
					<td align="center" id="teams"> Girls Level </td>
				</thead>
				</TR>
				<tbody>
				<tr>
					<td align="center"> U-07 </td>
					<td align="center"><input maxlength=2 name="B_Team_07" size=1 value="#VARIABLES.B_Team_07#"></td>
					<td align="center"><input maxlength=1 name="B_Level_07" size=1 value="#VARIABLES.B_Level_07#"></td>
					<td align="center"><input maxlength=2 name="G_Team_07" size=1 value="#VARIABLES.G_Team_07#"></td>
					<td align="center"><input maxlength=1 name="G_Level_07" size=1 value="#VARIABLES.G_Level_07#"></td>
				</tr>
				<tr>
					<td align="center"> U-08 </td>
					<td align="center"><input maxlength=2 name="B_Team_08" size=1 value="#VARIABLES.B_Team_08#"></td>
					<td align="center"><input maxlength=1 name="B_Level_08" size=1 value="#VARIABLES.B_Level_08#"></td>
					<td align="center"><input maxlength=2 name="G_Team_08" size=1 value="#VARIABLES.G_Team_08#"></td>
					<td align="center"><input maxlength=1 name="G_Level_08" size=1 value="#VARIABLES.G_Level_08#"></td>
				</tr>
				<tr>
					<td align="center"> U-09 </td>
					<td align="center"><input maxlength=2 name="B_Team_09" size=1 value="#VARIABLES.B_Team_09#"></td>
					<td align="center"><input maxlength=1 name="B_Level_09" size=1 value="#VARIABLES.B_Level_09#"></td>
					<td align="center"><input maxlength=2 name="G_Team_09" size=1 value="#VARIABLES.G_Team_09#"></td>
					<td align="center"><input maxlength=1 name="G_Level_09" size=1 value="#VARIABLES.G_Level_09#"></td>
				</tr>
				<tr>
					<td align="center"> U-10 </td>
					<td align="center"><input maxlength=2 name="B_Team_10" size=1 value="#VARIABLES.B_Team_10#"></td>
					<td align="center"><input maxlength=1 name="B_Level_10" size=1 value="#VARIABLES.B_Level_10#"></td>
					<td align="center"><input maxlength=2 name="G_Team_10" size=1 value="#VARIABLES.G_Team_10#"></td>
					<td align="center"><input maxlength=1 name="G_Level_10" size=1 value="#VARIABLES.G_Level_10#"></td>
				</tr>
				<tr>
					<td align="center"> U-11 </td>
					<td align="center"><input maxlength=2 name="B_Team_11" size=1 value="#VARIABLES.B_Team_11#"></td>
					<td align="center"><input maxlength=1 name="B_Level_11" size=1 value="#VARIABLES.B_Level_11#"></td>
					<td align="center"><input maxlength=2 name="G_Team_11" size=1 value="#VARIABLES.G_Team_11#"></td>
					<td align="center"><input maxlength=1 name="G_Level_11" size=1 value="#VARIABLES.G_Level_11#"></td>
				</tr>
				<tr>
					<td align="center"> U-12 </td>
					<td align="center"><input maxlength=2 name="B_Team_12" size=1 value="#VARIABLES.B_Team_12#"></td>
					<td align="center"><input maxlength=1 name="B_Level_12" size=1 value="#VARIABLES.B_Level_12#"></td>
					<td align="center"><input maxlength=2 name="G_Team_12" size=1 value="#VARIABLES.G_Team_12#"></td>
					<td align="center"><input maxlength=1 name="G_Level_12" size=1 value="#VARIABLES.G_Level_12#"></td>
				</tr>
				<tr>
					<td align="center"> U-13 </td>
					<td align="center"><input maxlength=2 name="B_Team_13" size=1 value="#VARIABLES.B_Team_13#"></td>
					<td align="center"><input maxlength=1 name="B_Level_13" size=1 value="#VARIABLES.B_Level_13#"></td>
					<td align="center"><input maxlength=2 name="G_Team_13" size=1 value="#VARIABLES.G_Team_13#"></td>
					<td align="center"><input maxlength=1 name="G_Level_13" size=1 value="#VARIABLES.G_Level_13#"></td>
				</tr>
				<tr>
					<td align="center"> U-14 </td>
					<td align="center"><input maxlength=2 name="B_Team_14" size=1 value="#VARIABLES.B_Team_14#"></td>
					<td align="center"><input maxlength=1 name="B_Level_14" size=1 value="#VARIABLES.B_Level_14#"></td>
					<td align="center"><input maxlength=2 name="G_Team_14" size=1 value="#VARIABLES.G_Team_14#"></td>
					<td align="center"><input maxlength=1 name="G_Level_14" size=1 value="#VARIABLES.G_Level_14#"></td>
				</tr>
				<tr>
					<td align="center"> U-15 </td>
					<td align="center"><input maxlength=2 name="B_Team_15" size=1 value="#VARIABLES.B_Team_15#"></td>
					<td align="center"><input maxlength=1 name="B_Level_15" size=1 value="#VARIABLES.B_Level_15#"></td>
					<td align="center"><input maxlength=2 name="G_Team_15" size=1 value="#VARIABLES.G_Team_15#"></td>
					<td align="center"><input maxlength=1 name="G_Level_15" size=1 value="#VARIABLES.G_Level_15#"></td>
				</tr>
				<tr>
					<td align="center"> U-16 </td>
					<td align="center"><input maxlength=2 name="B_Team_16" size=1 value="#VARIABLES.B_Team_16#"></td>
					<td align="center"><input maxlength=1 name="B_Level_16" size=1 value="#VARIABLES.B_Level_16#"></td>
					<td align="center"><input maxlength=2 name="G_Team_16" size=1 value="#VARIABLES.G_Team_16#"></td>
					<td align="center"><input maxlength=1 name="G_Level_16" size=1 value="#VARIABLES.G_Level_16#"></td>
				</tr>
				<tr>
					<td align="center"> U-17 </td>
					<td align="center"><input maxlength=2 name="B_Team_17" size=1 value="#VARIABLES.B_Team_17#"></td>
					<td align="center"><input maxlength=1 name="B_Level_17" size=1 value="#VARIABLES.B_Level_17#"></td>
					<td align="center"><input maxlength=2 name="G_Team_17" size=1 value="#VARIABLES.G_Team_17#"></td>
					<td align="center"><input maxlength=1 name="G_Level_17" size=1 value="#VARIABLES.G_Level_17#"></td>
				</tr>
				<tr>
					<td align="center"> U-18 </td>
					<td align="center"><input maxlength=2 name="B_Team_18" size=1 value="#VARIABLES.B_Team_18#"></td>
					<td align="center"><input maxlength=1 name="B_Level_18" size=1 value="#VARIABLES.B_Level_18#"></td>
					<td align="center"><input maxlength=2 name="G_Team_18" size=1 value="#VARIABLES.G_Team_18#"></td>
					<td align="center"><input maxlength=1 name="G_Level_18" size=1 value="#VARIABLES.G_Level_18#"></td>
				</tr>
				</tbody>
			</table>

				<input type="Hidden" name="B_Team_07_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Boys 07 team count">	
				<input type="Hidden" name="B_Team_08_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Boys 08 team count">	
				<input type="Hidden" name="B_Team_09_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Boys 09 team count">	
				<input type="Hidden" name="B_Team_10_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Boys 10 team count">	
				<input type="Hidden" name="B_Team_11_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Boys 11 team count">	
				<input type="Hidden" name="B_Team_12_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Boys 12 team count">	
				<input type="Hidden" name="B_Team_13_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Boys 13 team count">	
				<input type="Hidden" name="B_Team_14_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Boys 14 team count">	
				<input type="Hidden" name="B_Team_15_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Boys 15 team count">	
				<input type="Hidden" name="B_Team_16_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Boys 16 team count">	
				<input type="Hidden" name="B_Team_17_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Boys 17 team count">	
				<input type="Hidden" name="B_Team_18_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Boys 18 team count">	
				<input type="Hidden" name="B_Level_07_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Boys 07 Level">	
				<input type="Hidden" name="B_Level_08_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Boys 08 Level">	
				<input type="Hidden" name="B_Level_09_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Boys 09 Level">	
				<input type="Hidden" name="B_Level_10_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Boys 10 Level">	
				<input type="Hidden" name="B_Level_11_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Boys 11 Level">		
				<input type="Hidden" name="B_Level_12_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Boys 12 Level">		
				<input type="Hidden" name="B_Level_13_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Boys 13 Level">		
				<input type="Hidden" name="B_Level_14_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Boys 14 Level">		
				<input type="Hidden" name="B_Level_15_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Boys 15 Level">		
				<input type="Hidden" name="B_Level_16_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Boys 16 Level">		
				<input type="Hidden" name="B_Level_17_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Boys 17 Level">	
				<input type="Hidden" name="B_Level_18_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Boys 18 Level">	
				<input type="Hidden" name="G_Team_07_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Girls 07 team count">	
				<input type="Hidden" name="G_Team_08_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Girls 08 team count">	
				<input type="Hidden" name="G_Team_09_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Girls 09 team count">	
				<input type="Hidden" name="G_Team_10_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Girls 10 team count">	
				<input type="Hidden" name="G_Team_11_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Girls 11 team count">	
				<input type="Hidden" name="G_Team_12_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Girls 12 team count">	
				<input type="Hidden" name="G_Team_13_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Girls 13 team count">	
				<input type="Hidden" name="G_Team_14_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Girls 14 team count">	
				<input type="Hidden" name="G_Team_15_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Girls 15 team count">	
				<input type="Hidden" name="G_Team_16_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Girls 16 team count">	
				<input type="Hidden" name="G_Team_17_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Girls 17 team count">	
				<input type="Hidden" name="G_Team_18_ATTRIBUTES" value="type=NUMERIC~required=0~FIELDNAME=Girls 18 team count">	
				<input type="Hidden" name="G_Level_07_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Girls 07 Level">	
				<input type="Hidden" name="G_Level_08_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Girls 08 Level">	
				<input type="Hidden" name="G_Level_09_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Girls 09 Level">	
				<input type="Hidden" name="G_Level_10_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Girls 10 Level">	
				<input type="Hidden" name="G_Level_11_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Girls 11 Level">		
				<input type="Hidden" name="G_Level_12_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Girls 12 Level">		
				<input type="Hidden" name="G_Level_13_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Girls 13 Level">		
				<input type="Hidden" name="G_Level_14_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Girls 14 Level">		
				<input type="Hidden" name="G_Level_15_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Girls 15 Level">		
				<input type="Hidden" name="G_Level_16_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Girls 16 Level">		
				<input type="Hidden" name="G_Level_17_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Girls 17 Level">	
				<input type="Hidden" name="G_Level_18_ATTRIBUTES" value="type=PLAYLEVEL~required=0~FIELDNAME=Girls 18 Level">	
				
		</div>
		<!--- ====================================================================== --->
		<div class="Heading">
			Comment/Resume/History
		</div>
		<div class="row form_field">
			<div class="col">
				<TEXTAREA id="textarea" name="Comments"  rows=8 cols=75>#Trim(Comments)#</TEXTAREA>
			</div>
		</div>
		<div class="row form_field">
			<div class="col">
				<font size=2 color="red">
					<!---Contact the league office for Confirmation in 24hrs after Submiting the Form--->
					A member of the committee which reviews club applications to join NCSA will contact you.  That member will report the information to the NCSA board for a decision.  The board meets only once per month, so please be patient.  If you have any questions or have additional information to share, please contact NCSA through its Administrative Assistant – you can find info on the “Contact Us” page, found through the link below.
				</font>
			</div>
		</div>
		<div class="row button">
			<div class="col">
				<button type="submit" class="yellow_btn" value="Submit" size="38" name="Submit" onclick="">Submit</button>
			</div>
		</div>
	 </FORM>
</div><!--- newClubApp --->
</CFIF>
	 
</cfoutput>
</div>
<cfinclude template="_footer.cfm">



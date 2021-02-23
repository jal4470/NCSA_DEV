

<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfif isDefined("url.clubid")>
	<cfset clubID = url.clubid>
<cfelse>
	<cfset clubID = "0">
</cfif>	


<cfif isDefined("url.Season")>
	<cfset Season = url.Season>
<cfelse>
	<cfset Season = session.currentseason.id>
</cfif>


<cfif isdefined("url.finestatus")>
	<cfset finestatus = url.finestatus>
<cfelse>
	<cfset finestatus = "U">
</cfif>

<cfif (isdefined("url.startDate") and len(trim(url.startDate))) and (isdefined("url.endDate") and len(trim(url.endDate)))>
	<cfset startDate = url.startDate>
	<cfset endDate = url.endDate>
<cfelse>
	<cfset startDate =" ">
	<cfset endDate = " ">
</cfif>

<cfif isdefined("url.sortBy")>
	<cfset sortBy = url.sortBy>
<cfelse>
	<cfset sortBy = "1">
</cfif>

 	<cfquery name="refUnPaidAdded" datasource="#SESSION.DSN#">
		select  
			    CASE r.RefPosition WHEN 1 THEN 'REF' WHEN 2 THEN 'AR1' WHEN 3 THEN 'AR2' END as RefPosition,
				r.REFID, co.FirstNAME, co.LastName,co.address, co.city, co.state, co.zipcode,
				r.GAME,  r.GDATE,  r.GTIME, r.DIVISION, r.COMMENTS,
				r.FIELD, r.FIELDABBR, 
				dbo.getTeamName(r.HOME)    AS HomeTeamName,
				dbo.getTeamName(r.VISITOR) AS VisitorTeamName,
				r.RefAmountOwed, C.CLUB_NAME,
				r.FIELDID, 	th.Club_ID,
				r.RefGameDateUnpaid,  
				r.HOME, r.VISITOR,  r.SEASONID, r.STATUS, 
				r.DATEADDED, r.ADDBYUSER, r.TIMEADDED, 
				r.DATEUPDATED, r.UPDBYUSER, r.TIMEUPDATED
		  from  RefUnPaid r INNER JOIN TBL_TEAM TH 		ON TH.TEAM_ID = R.Home
							INNER JOIN TBL_CLUB C 		ON C.CLUB_ID = TH.CLUB_ID
							INNER JOIN TBL_CONTACT CO	ON CO.CONTACT_ID = R.REFID
		 where  r.seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Season#">
		 	<CFIF isDefined("clubID") AND clubID GT 1>
				and C.Club_Id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#clubID#">
			</CFIF>
			<!--- 11/1/2012 J. Rab --->
			<cfif (isDefined("StartDate") and isDate(StartDate)) and (isDefined("EndDate") and isDate(EndDate))>
				and cast(r.dateadded as date) between <cfqueryparam cfsqltype="CF_SQL_DATE" value="#StartDate#"> and  <cfqueryparam cfsqltype="CF_SQL_DATE" value="#EndDate#">
			</cfif>
			
			
		 ORDER BY C.CLUB_NAME, r.gDate DESC, r.gTime DESC
	</cfquery>  
<!--- create download file --->	
<CFIF isDefined("refUnPaidAdded") AND refUnPaidAdded.RECORDCOUNT >
	<CFSET filename = "#SESSION.USER.CONTACTID#RefereeUnpaid.csv" >
	<CFSET output = "">

	<CFSET output = output & "Referee,Address,City,State,Zip,Pos,Owed,Game,'Date/Time/Field',Div,Teams,Comments" & chr(13) & chr(10) >
	<CFLOOP query="refUnPaidAdded">
			<CFSET output = output & """#LastName#, #FirstNAME#"",""#address#"",""#city#"",""#state#"",""#zipcode#"",""#RefPosition#"",""#dollarFormat(RefAmountOwed)#"",""#GAME#"",""[#dateFormat(RefGameDateUnpaid,"mm/dd/yyyy")#]/[#timeFormat(GTIME,"hh:mm tt")#]/[#FieldAbbr#]"",""#Division#"",""(H) #HomeTeamName# vs. (V) #VisitorTeamName#"",""#Comments#""">
			<cfset output = output & chr(13) & chr(10)>
	</CFLOOP>
</CFIF>

<cfheader name="Content-disposition" value="attachment;filename=#filename#"> 
<cfcontent type="application/vnd.Microsoft Excel Comma Seperated Values 
	File; charset=utf-8" variable="#ToBinary( ToBase64( output ) )#"> <!--- To prevent whitespace in CSV, do a cfcontent workaround --->

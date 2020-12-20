<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<!--- REFEREE FULL DATA REPORT (Board)
Sort options: alpha last name (default), Town (grouped by state), ref grade level, NCSA level, age, years of service

Select Options: 
	state registered in or all, 
	certified y/n/all (since most data is type-in rather than selectable, can't think what else could use)

YIELD: all info, like coach report, but with additional ref info also
	AGE (instead of DOB, compute age at time of report)
	Years as Ref (instead of year first certified, compute # of years certified)
	Comments (underneath as on other reports?) - see email for discussion)
	EMAIL LIST COPY AND PASTE AT BOTTOM\ --->




<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qGetRefs">
</cfinvoke> <!---  <cfdump var="#qGetRefs#"> --->
<!--- 	<cfinvokeargument name="sortby" value="STATE"> --->

<cfquery name="qStateReg" dbtype="query">
	select DISTINCT STATEREGISTEREDIN from qGetRefs 
</cfquery>

<cfif isDefined("FORM.sortOrder")>
	<cfset sortBy = FORM.sortOrder >
<cfelse>
	<cfset sortBy = "NAME" >
</cfif>
<cfswitch expression="#UCASE(sortBy)#">
	<cfcase value="TOWN">	<cfset orderByCol = " STATE, CITY, LastName, FirstNAme " ></cfcase>
	<cfcase value="RSTATE">	<cfset orderByCol = " STATEREGISTEREDIN " ></cfcase>
	<cfcase value="GRADE">	<cfset orderByCol = " GRADE, LastName, FirstNAme" ></cfcase>
	<cfcase value="NCSAL">	<cfset orderByCol = " REF_LEVEL, LastName, FirstNAme" ></cfcase>
	<cfcase value="AGE">	<cfset orderByCol = " BIRTH_DATE, LastName, FirstNAme" ></cfcase>
	<cfcase value="YRSERVICE">	<cfset orderByCol = " CERTIFIED_1ST_YEAR, LastName, FirstNAme" ></cfcase>
	<cfdefaultcase> 	<cfset orderByCol = " LastName, FirstNAme " >	</cfdefaultcase>
</cfswitch>

<cfif isDefined("FORM.selCert")>
	<cfset selCert = FORM.selCert >
<cfelse>
	<cfset selCert = "" >
</cfif>
<cfif isDefined("FORM.selState")>
	<cfset selState = FORM.selState >
<cfelse>
	<cfset selState = "" >
</cfif>

<cfset whereClause = "">

<CFIF len(trim(selCert))>  
	<CFIF selCert EQ "Y">
		<CFSET whereClause = "WHERE certified_yn = '#selCert#' "> 
	<CFELSE>
		<CFSET whereClause = "WHERE certified_yn <> 'Y' "> 
	</CFIF>
</CFIF>

<CFIF len(trim(selState))> 
	<cfif len(trim(whereClause))>
		<CFSET whereClause = whereClause & " AND " >
	<cfelse>
		<CFSET whereClause = whereClause & " WHERE " >
	</cfif>
	<CFSET whereClause = whereClause & " STATEREGISTEREDIN = '#selState#' ">
</CFIF>

<cfquery name="qGetRefs" dbtype="query">
	select * from qGetRefs
	#preservesinglequotes(whereClause)#
	order by #orderByCol#
</cfquery>



	<TD width="20%" class="tdUnderLine" align=Left>		#LastName#, #FirstName#			</td>
			<TD width="15%" class="tdUnderLine" align=Left>		#CITY#		</td>
			<TD width="10%" class="tdUnderLine" align=center>   #State#		</td>
			<TD width="25%" class="tdUnderLine" align=Left> 	#Email#		</td>
			<TD width="15%" class="tdUnderLine" align=Left> 	#phoneCell# </td>
			<TD width="15%" class="tdUnderLine" align=Left> 	#phoneHome#	</td>

<!--- create download file --->	
<CFIF isDefined("qGetRefs") AND qGetRefs.RECORDCOUNT >
	<CFSET filename = "#SESSION.USER.CONTACTID#RefereeContactInfo.csv" >
	<CFSET output = "">
	<CFSET output = output & "Referee,City, State,Email,Cell,Home" & chr(13) & chr(10) >
	<CFLOOP query="qGetRefs">
		<cfif len(trim(CERTIFIED_1ST_YEAR))>
			<cfset yrsCert = datePart("yyyy",now()) - CERTIFIED_1ST_YEAR>
		<cfelse>
			<cfset yrsCert = 0>
		</cfif>
		<cfif isDate(BIRTH_DATE)>
			<cfset yrsAge = dateDiff("yyyy",BIRTH_DATE,now() ) >
		<cfelse>
			<cfset yrsAge = 0>
		</cfif>
			<CFSET output = output & """#LastName#, #FirstNAme#"",""#CITY#"", ""#STATE#"",""#Email#"", ""#phoneCell#"",""#phoneHome#""">
			<cfset output = output & chr(13) & chr(10)>
	</CFLOOP>
</CFIF>

<cfheader name="Content-disposition" value="attachement;filename=#filename#"> 
<cfcontent type="application/vnd.Microsoft Excel Comma Seperated Values 
	File; charset=utf-8" variable="#ToBinary( ToBase64( output ) )#"> <!--- To prevent whitespace in CSV, do a cfcontent workaround --->

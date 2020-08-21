<cfsetting enablecfoutputonly="true">
<!--- 
	FileName:	rptRefereeDataQuickinfo.cfm
	Created on: 02/27/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qGetRefs">
</cfinvoke> <!---  <cfdump var="#qGetRefs#"> --->
<!--- 	<cfinvokeargument name="sortby" value="STATE"> --->

<cfquery name="qStateReg" dbtype="query">
	select DISTINCT STATEREGISTEREDIN from qGetRefs 
</cfquery>

<cfif isDefined("FORM.sortBy")>
	<cfset sortBy = FORM.sortBy >
<cfelseif isDefined("URL.sortBy")>
	<cfset sortBy = URL.sortBy >
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
<cfelseif isDefined("URL.selCert")>
	<cfset selCert = URL.selCert >
<cfelse>
	<cfset selCert = "" >
</cfif>
<cfif isDefined("FORM.selState")>
	<cfset selState = FORM.selState >
<cfelseif isDefined("URL.selState")>
	<cfset selState = URL.selState >
<cfelse>
	<cfset selState = "" >
</cfif>

<cfset whereClause = "">

<CFIF len(trim(selCert))>  
	<CFSET whereClause = "WHERE certified_yn = '#selCert#' "> 
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

 
<!--- create download file --->	
<CFIF isDefined("qGetRefs") AND qGetRefs.RECORDCOUNT >
	<CFSET filename = "#SESSION.USER.CONTACTID#RefDataInfo.csv" >
	<CFSET output = "">
	<CFSET output = output & "Referee,City State,Age-Yrs-Level,Sat Avail,Sat Assign,Sun Avail,Sun Assign" & chr(13) & chr(10) >
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
			<CFSET output = output & """#LastName#, #FirstNAme#"",""#CITY#, #STATE#"",""#VARIABLES.yrsAge#-#VARIABLES.yrsCert#-#REF_LEVEL#"", , , , ">
			<cfset output = output & chr(13) & chr(10)>
	</CFLOOP>
</CFIF>

<cfheader name="Content-disposition" value="attachement;filename=#filename#"> 
<cfcontent type="application/vnd.Microsoft Excel Comma Seperated Values 
	File; charset=utf-8" variable="#ToBinary( ToBase64( output ) )#"> <!--- To prevent whitespace in CSV, do a cfcontent workaround --->

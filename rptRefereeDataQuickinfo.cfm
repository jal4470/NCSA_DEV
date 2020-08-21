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

<cfoutput>
<div id="contentText">


<H1 class="pageheading">NCSA - Referee Quick Info Report </H1>

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



<!--- <cfquery name="AllContacts" dbtype="query">
		SELECT *
		  FROM clubContactsALL
		 WHERE LASTNAME IS NOT NULL
		 ORDER BY LASTNAME, FIRSTNAME
</cfquery>
 --->

 
<!--- create download file --->	
<!--- <CFIF isDefined("qGetRefs") AND qGetRefs.RECORDCOUNT >
	<CFSET tempfile = "#GetDirectoryFromPath(ExpandPath("*.*"))#downloads\#SESSION.USER.CONTACTID#RefDataInfo.csv" >
	<CFSET output = "">
	<CFSET output = output & "Referee,City State,Age-Yrs-Level,Sat Avail,Sat Assign,Sun Avail,Sun Assign" >
	<cfscript>
           if (FileExists(#tempfile#) )
		   {	FileDelete(#tempfile#);
		   }
     </cfscript>

	<CFFILE ACTION="WRITE"  FILE="#tempfile#" OUTPUT="#output#" nameconflict="OVERWRITE" >
	<CFLOOP query="qGetRefs">
		<CFSET output = "">

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
			<CFFILE ACTION="APPEND" FILE="#tempfile#" OUTPUT="#output#" >
	</CFLOOP>
	<CFSET swShowDownLoad = true>
</CFIF>
  --->
 
 
 
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr><td colspan="3" align="right">
		<form action="rptRefereeDataQuickinfo.cfm" method="post">
			<b>State Registered:</b>
			<select name="selState">
				<option value="" <cfif selState EQ "">selected</cfif> >All</option>
				<cfloop query="qStateReg">
					<cfif LEN(TRIM(STATEREGISTEREDIN))>
					<option value="#STATEREGISTEREDIN#" <cfif selState EQ STATEREGISTEREDIN>selected</cfif> >#STATEREGISTEREDIN#</option>
					</cfif>
				</cfloop>
			</select>

			<b>Certified:</b>
			<select name="selCert">
				<option value="" <cfif selCert EQ "">selected</cfif> >All</option>
				<option value="Y" <cfif selCert EQ "Y">selected</cfif> >Yes</option>
				<option value="N" <cfif selCert EQ "N">selected</cfif> >No</option>
			</select>


			<b>Sort By:</b>
			<select name="sortOrder">
				<option value="NAME" <cfif sortBy EQ "NAME">selected</cfif> >Name</option>
				<option value="TOWN" <cfif sortBy EQ "TOWN">selected</cfif> >Town</option>
				<option value="RSTATE" <cfif sortBy EQ "RSTATE">selected</cfif> >Registered State</option>
				<option value="GRADE" <cfif sortBy EQ "GRADE">selected</cfif> >Ref Grade Level</option>
				<option value="NCSAL" <cfif sortBy EQ "NCSAL">selected</cfif> >NCSA Level</option>
				<option value="AGE" <cfif sortBy EQ "AGE">selected</cfif> >Age</option>
				<option value="YRSERVICE" <cfif sortBy EQ "YRSERVICE">selected</cfif> >Years of Service</option>
			</select>
			<INPUT type="Submit" name="getRefs" value="Go">
		</form>
		</td>
		<td colspan="5" align="right">
					<a href="rptRefereeDataQuickInfo_csv.cfm?sortBy=#sortBy#&selCert=#selCert#&selState=#selState#">Download Ref info</a>
					<br>(IE users, please save the file before opening it.)
		</td>
	</tr>
	<tr class="tblHeading">
		<TD width="25%" valign="bottom">Referee</TD>
		<TD width="25%" valign="bottom">City/State </TD>
		<TD width="20%" valign="bottom">Age-Yrs-Level </TD>
		<TD width="15%" valign="bottom">Sat Avail </TD>
		<TD width="15%" valign="bottom">Sat Assign </TD>
		<TD width="15%" valign="bottom">Sun Avail </TD>
		<TD width="15%" valign="bottom">Sun Assign </TD>
	</tr>
</table>

<div style="overflow:auto;height:400px;border:1px ##cccccc solid;">
	<table cellspacing="0" cellpadding="1" align="left" border="0" width="100%">
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
 		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
			<TD width="25%" class="tdUnderLine" valign="top" > #LastName#, #FirstNAme#  </TD>
			<TD width="25%" class="tdUnderLine" valign="top" > #CITY#, #STATE#			</TD>
			<TD width="20%" class="tdUnderLine" valign="top" > #VARIABLES.yrsAge#-#VARIABLES.yrsCert#-#REF_LEVEL# </TD>
			<TD width="15%" class="tdUnderLine" >&nbsp; </TD>
			<TD width="15%" class="tdUnderLine" >&nbsp; </TD>
			<TD width="15%" class="tdUnderLine" >&nbsp; </TD>
			<TD width="15%" class="tdUnderLine" >&nbsp; </TD>
		</tr>
	</CFLOOP>
	</table>
</div>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">

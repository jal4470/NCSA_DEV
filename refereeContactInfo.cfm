<!--- 
	FileName:	refereeContactInfo.cfm
	Created on: 02/27/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

07/20/17 - apinzone (27024) - Added state registered, certified and sorting functionality.
 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Referee Contact Info</H1> 

<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qGetRefs">
</cfinvoke>

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

<!--- FILTER FORM --->
<section id="formElements">
    <div class="container">

    	<FORM name="filters" action="refereeContactInfo.cfm" method="post" style="display:inline-block;">

	    	<div class="inline_input">
	    		<label>State Registered:</label>
				<select name="selState">
					<option value="" <cfif selState EQ "">selected</cfif> >All</option>
					<cfloop query="qStateReg">
						<cfif LEN(TRIM(STATEREGISTEREDIN))>
						<option value="#STATEREGISTEREDIN#" <cfif selState EQ STATEREGISTEREDIN>selected</cfif> >#STATEREGISTEREDIN#</option>
						</cfif>
					</cfloop>
				</select>
		    </div>

	    	<div class="inline_input">
	    		<label>Certified:</label>
				<select name="selCert">
					<option value="" <cfif selCert EQ "">selected</cfif> >All</option>
					<option value="Y" <cfif selCert EQ "Y">selected</cfif> >Yes</option>
					<option value="N" <cfif selCert EQ "N">selected</cfif> >No</option>
				</select>
		    </div>

	    	<div class="inline_input">
	    		<label>Sort By:</label>
				<select name="sortOrder">
					<option value="NAME" <cfif sortBy EQ "NAME">selected</cfif> >Name</option>
					<option value="TOWN" <cfif sortBy EQ "TOWN">selected</cfif> >Town</option>
					<option value="RSTATE" <cfif sortBy EQ "RSTATE">selected</cfif> >Registered State</option>
					<option value="GRADE" <cfif sortBy EQ "GRADE">selected</cfif> >Ref Grade Level</option>
					<option value="NCSAL" <cfif sortBy EQ "NCSAL">selected</cfif> >NCSA Level</option>
					<option value="AGE" <cfif sortBy EQ "AGE">selected</cfif> >Age</option>
					<option value="YRSERVICE" <cfif sortBy EQ "YRSERVICE">selected</cfif> >Years of Service</option>
				</select>
				<div class="filter_submit">
	        		<INPUT type="Submit" name="getRefs" value="Go"> 
	        	</div>
		    </div>
        </FORM>
		

	        <FORM name="refContInfo" action="refereeContactInfoPDF.cfm" method="post" style="display:inline-block;" target="_blank">
	        	<input type="hidden" name="selState" value="#selState#">
	        	<input type="hidden" name="selCert" value="#selCert#">
	        	<input type="hidden" name="sortOrder" value="#sortBy#">
				<input type="Submit" name="printme" value="Printer Friendly" >
			</FORM>

		<span style="float:right;display:inline-block;">
			<a href="refereeContactInfo_csv.cfm?sortBy=#sortBy#&selCert=#selCert#&selState=#selState#">Download Ref info</a>
			<br><small>(IE users, please save the file before opening it.)</small>
		</span>
		
    </div>
</section>


<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">	
		<td width="20%" align=Left> Referee	</td>
		<td width="15%" align=Left> City	</td>
		<td width="10%" align=Left> State 	</td>
		<td width="25%" align=Left> Email	</td>
		<td width="15%" align=Left> Cell	</td>
		<td width="15%" align=Left> Home	</td>
	</tr>
</table>
<div style="overflow:auto;height:400px;border:1px ##cccccc solid;">
	<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<CFLOOP query="qGetRefs">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<TD width="20%" class="tdUnderLine" align=Left>		#LastName#, #FirstName#			</td>
			<TD width="15%" class="tdUnderLine" align=Left>		#CITY#		</td>
			<TD width="10%" class="tdUnderLine" align=center>   #State#		</td>
			<TD width="25%" class="tdUnderLine" align=Left> 	#Email#		</td>
			<TD width="15%" class="tdUnderLine" align=Left> 	#phoneCell# </td>
			<TD width="15%" class="tdUnderLine" align=Left> 	#phoneHome#	</td>
		</tr>
	</CFLOOP>
	</table>
</div>



</div><!---//contentText--->

</cfoutput>
<cfinclude template="_footer.cfm">

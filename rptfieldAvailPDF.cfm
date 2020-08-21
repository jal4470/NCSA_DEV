<!--- 
	FileName:	rptfieldAvailPDF.cfm
	Created on: 05/19/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

05/19/09 - aarnone - #7311 printer friendly


	NOTE! - changes to this page may also have to be included into rptFieldAvail.cfm

 --->
 

<!--- <cfinclude template="cfudfs.cfm"> ---> 
<cfinclude template="_checkLogin.cfm">

<CFIF isDefined("URL.cid") AND isNumeric(URL.cid)>
	<CFSET clubSelected = URL.cid >
<CFELSE>
	<CFSET clubSelected = 0 >
</CFIF>

<cfif isDefined("URL.fid") AND isNumeric(URL.fid)>
	<cfset fieldid = URL.fid>
<CFELSE>
	<cfset fieldid = 0>
</cfif>

<cfif isDefined("URL.wid") AND isNumeric(URL.wid)>
	<cfset weekEndID	 = URL.wid>
	<cfset QuerySeasonID = 0>
<cfelseif isDefined("URL.wid") AND URL.wid EQ "cur" >
	<cfset weekEndID	 = 0>
	<cfset QuerySeasonID = SESSION.CURRENTSEASON.ID>
<cfelseif isDefined("URL.wid") AND URL.wid EQ "reg" >
	<cfset weekEndID	 = 0>
	<cfset QuerySeasonID = SESSION.REGSEASON.ID>
<CFELSE>
	<cfset weekEndID	 = 0>
	<cfset QuerySeasonID = 0>
</cfif>

<cfif isDefined("URL.sz")>
	<cfset size = URL.sz>
<CFELSE>
	<cfset size = "">
</cfif>
<cfif isDefined("URL.tf")>
	<cfset turf = URL.tf>
<CFELSE>
	<cfset turf = "">
</cfif>
<cfif isDefined("URL.lit")>
	<cfset lights = URL.lit>
<CFELSE>
	<cfset lights = "">
</cfif>


<CFIF FIELDID GT 0> 
	<CFSET whereField = "x.FIELD_ID = #FIELDID#">
<CFELSE>
	<CFSET whereField = "">
</CFIF>
<CFIF weekEndID GT 0> 
	<CFSET whereWEID = "x.PLAYWEEKEND_ID = #weekEndID#">
<CFELSE>
	<CFSET whereWEID = "">
</CFIF>
<CFIF weekEndID EQ 0 AND QuerySeasonID GT 0> 
	<CFSET whereSeasonID = "x.SEASON_ID = #QuerySeasonID#">
<CFELSE>
	<CFSET whereSeasonID = "">
</CFIF>

<cfif len(trim(size)) > 
	<cfset whereSize = " AND F.FIELDSIZE = '" & VARIABLES.size & "'">
<CFELSE>
	<cfset whereSize = "">
</cfif>
<cfif len(trim(turf)) >
	<cfset whereTurf = " AND F.TURF_TYPE = '" & VARIABLES.turf & "'">
<CFELSE>
	<cfset whereTurf = "">
</cfif>
<cfif len(trim(lights)) >
	<cfset whereLights = " AND F.LIGHTS_YN = '" & VARIABLES.lights & "'">
<CFELSE>
	<cfset whereLights = "">
</cfif>

<cfquery name="getFieldplayweeks" datasource="#SESSION.DSN#">
	SELECT X.PLAYWEEKEND_ID, 
		   X.SAT_AVAIL_YN,  X.SAT_TIME_FROM,  X.SAT_TIME_TO,
		   X.SUN_AVAIL_YN,  X.SUN_TIME_FROM,  X.SUN_TIME_TO,
		   pw.WEEK_NUMBER,  pw.Day1_Date, 	  pw.Day2_Date,
		   F.FIELD_ID,		F.FIELDABBR,	  F.FIELDNAME, 
		   F.CITY,			F.FIELDSIZE, 	  F.LIGHTS_YN, F.TURF_TYPE
	  FROM XREF_FIELD_WEEKEND X 
	  			inner join tbl_playweekend pw ON pw.playweekend_ID = X.playweekend_id
	  			inner join tbl_FIELD f		  ON f.FIELD_ID = X.field_id
				<CFIF clubSelected GT 0>
					left JOIN XREF_CLUB_FIELD CF ON CF.FIELD_ID = F.field_id
				</CFIF>
	<CFIF len(trim(whereField)) OR len(trim(whereWEID)) OR len(trim(whereSeasonID)) >
		WHERE 
	</CFIF>
			<CFIF len(trim(whereField))>
				#whereField#
			</CFIF>
			<CFIF len(trim(whereField)) AND ( len(trim(whereWEID)) OR len(trim(whereSeasonID)) )>
				AND 
			</CFIF>
			<CFIF len(trim(whereWEID))>
				#whereWEID#
			<cfelseif len(trim(whereSeasonID))>
				#whereSeasonID#
			</CFIF>
			<CFIF len(Trim(whereSize))>
				#preserveSingleQuotes(whereSize)#
			</CFIF>
			<CFIF len(Trim(whereTurf))>
				#preserveSingleQuotes(whereTurf)#
			</CFIF>
			<CFIF len(Trim(whereLights))>
				#preserveSingleQuotes(whereLights)#
			</CFIF>
			<CFIF clubSelected GT 0>
				AND CF.CLUB_ID = #VARIABLES.clubSelected#
			</CFIF>
	ORDER BY F.FIELDABBR, pw.WEEK_NUMBER
</cfquery>

<cfquery name="qDistinctFieldIDs" dbtype="query">
	SELECT DISTINCT FIELD_ID FROM getFieldplayweeks
</cfquery>

 <cfheader name="content-disposition" value="application/pdf; filename=""Field Availability.pdf""" />
 
<cfdocument format="pdf" 
			marginBottom=".5"
			marginLeft=".4"
			marginRight=".4"
			marginTop=".85"
			orientation="landscape" > 
	<cfdocumentsection>
<cfoutput>
	<cfdocumentitem type="header" > <!--- has heading but not spaced right --->
		<cfhtmlhead text="<link rel='STYLESHEET' type='text/css' href='2col_leftNav.css'>">	
		<div id="contentText">
			<table border="0" width="100%" cellpadding="2" cellspacing="0">
				<tr><td colspan="6" align="left">
						<br><H1 class="pageheading">NCSA - Field Availability Report </H1>
					</td>
					<td colspan="4" align="right">
						<br>Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
					</td>
				</tr>
				<tr><td colspan="10" align="left">
						<span class="red">Number of fields displayed: #qDistinctFieldIDs.recordCount#</span>
					</td>
				</tr>
				<tr class="tblHeading">
					<td> WEEK##  </td>
					<td> Sat     </td>
					<td> Avail?  </td>
					<td> Sat From</td>
					<td> Sat To  </td>
					<td> &nbsp;  </td>
					<td> Sun     </td>
					<td> Avail?  </td>
					<td> Sun From</td>
					<td> Sun To  </td>
				</tr>
			</table>
			</div>
	</cfdocumentitem>
	<div id="contentText">
	<CFIF getFieldplayweeks.recordCount>
		<cfset holdFieldID = 0>
		<cfloop query="getFieldplayweeks">
			<table border="0" width="100%" cellpadding="2" cellspacing="0">
				<cfif holdFieldID NEQ FIELDABBR>
					<cfset holdFieldID = FIELDABBR>
					<cfset swPrintWeeks = true>
					<tr bgcolor="##CCE4F1">
						<td colspan="8" class="sizetext12">
							#FIELD_ID# - <b>#FIELDABBR#</b> - #CITY#
							<br> <b>#FIELDNAME#</b>
						</td>
						<td colspan="1" class="sizetext12">
								Lights: #LIGHTS_YN#
							<br>Turf: #TURF_TYPE#
						</td>
						<td colspan="1" class="sizetext12">
							Size: #FIELDSIZE#
						</td>
					</tr>
					<cfset swAllSame = false>
					<cfif WEEK_NUMBER EQ 1><!--- check 1st week only so we don't repeat this for every row --->
						<cfquery name="qAllSame" dbtype="query">
							SELECT DISTINCT SAT_AVAIL_YN,  SAT_TIME_FROM,  SAT_TIME_TO, SUN_AVAIL_YN,  SUN_TIME_FROM,  SUN_TIME_TO
							  FROM getFieldplayweeks
							 WHERE FIELD_ID = #FIELD_ID#
						</cfquery>
						<cfif qAllSame.RECORDCOUNT EQ 1>
							<cfset swAllSame = true>
						</cfif>
					</cfif>
				</cfif> 
				<CFIF swPrintWeeks>
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,WEEK_NUMBER)#">
						<td width="06%" class="tdUnderLinePDF"> &nbsp; #WEEK_NUMBER#	</td>
						<td width="13%" class="tdUnderLinePDF"> &nbsp; #dateFormat(Day1_Date, "DDD mm/dd/yy")#</td>
						<td width="05%" class="tdUnderLinePDF"> <cfif len(trim(SAT_AVAIL_YN))>#SAT_AVAIL_YN#<cfelse>N</cfif> </td>	
						<td width="13%" class="tdUnderLinePDF"> &nbsp; #timeFormat(SAT_TIME_FROM,"hh:mm tt")#	</td>	
						<td width="13%" class="tdUnderLinePDF"> &nbsp; #timeFormat(SAT_TIME_TO,"hh:mm tt")#	</td>	
						<td width="06%" class="tdUnderLinePDF"> &nbsp;	</td>
						<td width="13%" class="tdUnderLinePDF"> &nbsp; #dateFormat(Day2_Date, "DDD mm/dd/yy")#</td>	
						<td width="05%" class="tdUnderLinePDF"> <cfif len(trim(SUN_AVAIL_YN))>#SUN_AVAIL_YN#<cfelse>N</cfif> </td>	
						<td width="13%" class="tdUnderLinePDF"> &nbsp; #timeFormat(SUN_TIME_FROM,"hh:mm tt")#	</td>	
						<td width="13%" class="tdUnderLinePDF"> &nbsp; #timeFormat(SUN_TIME_TO,"hh:mm tt")# 	</td>	
					</tr>
				</CFIF>
				<CFIF swAllSame AND WEEK_NUMBER EQ 1>
					<cfset swPrintWeeks = false>
					<!--- if all the weeks are the same, then supress wks2-10 and put out message --->
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,WEEK_NUMBER)#">
						<td colspan="6" class="tdUnderLinePDF"> &nbsp; 2 - 10 <span class="red">same as Week 1</span>	</td>
						<td colspan="4" class="tdUnderLinePDF"> &nbsp;<span class="red"> Weeks 2-10 same as Week 1	</span></td>
					</tr>
					</table>
				</CFIF>
			</table>
		</cfloop>	
	<CFELSE>
		<table border="0" width="98%" cellpadding="2" cellspacing="0">
			<tr class="tblHeading">	
				<td> &nbsp; </td> 
			</tr>
			<tr><td class="red"> 
					<b>There are no play week availabilty records found for this field.</b> 
				</td> 
			</tr>
		</table>
	</CFIF>	
	
	</div>
</cfoutput>
	</cfdocumentsection>

</cfdocument>
 
 
 

<!--- 
	FileName:	gamesUploadDisplay.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<div id="contentText">

<cfoutput>

<H1 class="pageheading">NCSA - Display Uploaded Games</H1>
<!--- <h2>yyyyyy </h2> --->

<CFQUERY name="qGetLoadedGames" datasource="#SESSION.DSN#">
	SELECT  G.GAME_CODE   AS Num
		 , G.DIVISION_ID AS Div
	     , G.GAME_DATE   AS Date     
		 , G.GAME_TIME   AS Time
	     , F.FIELDABBR   AS Field   
	     , (SELECT top 1 TEAM_ID  FROM XREF_GAME_TEAM 
					 WHERE game_id = G.GAME_ID AND IsHomeTeam = 0 ) 
			AS Visitor
	     , (SELECT top 1 teamname FROM TBL_TEAM 
					 WHERE team_id = ( SELECT top 1 TEAM_ID FROM XREF_GAME_TEAM 
					 					WHERE game_id = G.GAME_ID AND IsHomeTeam = 0 ) ) 
	     	AS TeamV
		 , (SELECT top 1 TEAM_ID 	FROM XREF_GAME_TEAM 
					 WHERE game_id = G.GAME_ID AND IsHomeTeam = 1 ) 
	     	AS Home
		 , (SELECT top 1 teamname FROM TBL_TEAM 
					 WHERE team_id = ( SELECT top 1 TEAM_ID FROM XREF_GAME_TEAM 
					 					WHERE game_id = G.GAME_ID AND IsHomeTeam = 1 ) ) 
			AS TeamH
	  FROM TBL_GAME G 
	  			INNER JOIN TBL_FIELD F on F.FIELD_ID = G.FIELD_ID
	 WHERE G.SEASON_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#SESSION.CurrentSeason.ID#">
	 ORDER BY G.GAME_CODE
</CFQUERY>

<!---
<cfset thisPath=ExpandPath("*.*")>
<cfset thisDirectory=GetDirectoryFromPath(thisPath)>
--(Select season_id from tbl_season where currentSeason_yn = 'Y')
 <br>thisPath[#thisPath#]
<br>thisDirectory[#thisDirectory#]
<br>downloadfrom[#thisDirectory#filename]
 --->
<CFSET tempfile = "#GetDirectoryFromPath(ExpandPath("*.*"))#\uploads\downloadGamesFile.csv" >
<!--- The "spaces" in the text below are TAB characters. Do not change them to spaces otherwise the Excel export will not work.--->
<CFSET output = "">
<CFSET output = output & "Num,Div,Date,Time,Field,Visitor,TeamV,Home,TeamH" >
<CFFILE ACTION="WRITE" FILE="#tempfile#" OUTPUT="#output#" nameconflict="OVERWRITE"  >

<CFLOOP query="qGetLoadedGames">
	<CFSET output = "#Num#,#Div#,#dateFormat(Date,"mm/dd/yyyy")#,#timeFormat(Time,"hh:mm tt")#,#Field#,#Visitor#,#TeamV#,#Home#,#TeamH#">
	<CFFILE ACTION="APPEND" FILE="#tempfile#" OUTPUT="#output#" >
</CFLOOP>


<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
	<tr><td colspan="9" align="right"> 
			<a href="#SESSION.SITEVARS.HOMEHTTP#/uploads/downloadGamesFile.csv">DOWNLOAD This File</a>
		</td>
	</tr>
	<tr class="tblHeading">
		<td width="05%"> <b>Num</b>    </td>
		<td width="05%"> <b>Div</b>    </td>
		<td width="10%"> <b>Date</b>   </td>
		<td width="10%"> <b>Time</b>   </td>
		<td width="05%"> <b>Field</b>  </td>
		<td width="05%"> <b>Visitor</b></td>
		<td width="25%"> <b>TeamV</b>  </td>
		<td width="10%"> <b>Home</b>   </td>
		<td width="25%"> <b>TeamH</b>  </td>
	</tr>
</table>

<div style="overflow:auto; height:300px; border:1px ##cccccc solid;">
<table cellspacing="0" cellpadding="2" align="left" border="0" width="100%">
	<CFLOOP query="qGetLoadedGames">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<td width="05%" class="tdUnderLine"> #Num#		</td>
			<td width="05%" class="tdUnderLine"> #Div#		</td>
			<td width="10%" class="tdUnderLine"> #dateFormat(Date,"mm/dd/yyyy")#</td>
			<td width="10%" class="tdUnderLine"> #timeFormat(Time,"hh:mm tt")#	</td>
			<td width="05%" class="tdUnderLine"> #Field#	</td>
			<td width="05%" class="tdUnderLine"> #Visitor#	</td>
			<td width="25%" class="tdUnderLine"> #TeamV#	</td>
			<td width="10%" class="tdUnderLine"> #Home#		</td>
			<td width="25%" class="tdUnderLine"> #TeamH#	</td>
		</tr>
	</CFLOOP>
</table>
</div>
	
</cfoutput>

</div>
<cfinclude template="_footer.cfm">

 
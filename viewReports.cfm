<!--- 
	FileName:	viewReports.cfm
	Created on: 10/31/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: 
Joe Lechuga - 7/25/2011 - Changed Report 53 to Competition Evaluation - Sportsmanship Changed report 57 to Detailed Ref Evaluation - Arrival, Uniform
 J.Danz 8-26-2014 NCSA15511 - added report 38a.
 R.Gonzalez 7-12-2016 NCSA22671 - added report 9a.
 R.Gonzalez 9/5/2017 NCSA27024 - added report 3a. 
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Report List</H1>
<!--- <br> <h2>yyyyyy </h2> --->

<!--- 	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>"> --->

<table width="100%">
	<tr><td valign="top" width="50%"> <!--- start RIGHT side reports --->
			<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
				<tr class="tblHeading">
					<TD> &nbsp;	</TD>
				</tr>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#">  
					<TD class="tdUnderLine" > 
						<br>1. <a href="rptTeamID.cfm">			 Team ID Report			 	</a> (Board Only)
						<br>2. <a href="rptTBSselection.cfm">	 Requested TBS Report		</a> (Board and Clubs)
						<br>3. <a href="rptTBSselection.cfm?spr">Special Scheduling Requests	 	</a>
						<br>3a. <a href="rptHeadCoachMultiTeam.cfm">Head Coach Multi-Team Report	 	</a>
						<br>4. <a href="rptClubReps.cfm?prs"> 	 Club President Report		</a> (Board Only)
						<br>5. <a href="rptClubReps.cfm?rep">	 Club Representative Report </a> (Board Only)
						<br>6. <a href="rptCoachesEmail.cfm">	 Coaches Email Report		</a> (Board Only)
						<br>7. <a href="rptCoachesEmail.cfm?pn"> Coaches Contact Info Report</a> (Board, Clubs, Refs )
						<br>7a. <a href="rptContactInfo.cfm">	 Contact Info Report 		</a> (Board)
						
						<br>8. <a href="rptAppTeamSummary.cfm">	  Approved Team Summary </a> 		(Board)
						<br>9. <a href="rptRegSeasonAppTeams.cfm">Registration Season Report</a> (Board and Clubs)
						<br>9a. <a href="rptTeamRegInfo.cfm">Team Registration Information</a>
						<br>9b. <a href="rptTeamCreatedSeason.cfm">Created Teams By Season</a>
						<br>11. <a href="rptfieldAvail.cfm">	  Field Availability Report </a> (Board)	
						<br>12. <a href="rptBoardmembers.cfm">	  Board List</a> (Board)		
			
						<br>13. <a href="rptTeamsMisMatchedDiv.cfm"> Teams with Mismatches Divisions</a> (Board)
						<br>14. <a href="rptPendingTBSgames.cfm"> Pending TBS Games</a>  
						<br>15. <a href="rptGameOverlap.cfm"> 	  Overlapping Games Report</a>  
						<br>16. <a href="rptGameGapTime.cfm">	  Game Gap Report</a>
						<!--- <br>16A. <a href="rptSingleGame.cfm">	  Single Game Report</a> --->
						<br>16A. <a href="rptAssignmentSet.cfm">Assignment Set Report</a>
						<br>17.  <a href="rptGameMissingScore.cfm">	Games with Missing Scores Report</a>
						<br>18.  <a href="rptGameExcessScore.cfm">	Games with Excessive Scores Report</a>
						<br>19.  <a href="rptGameForfeit.cfm">		Games with Forfeit Recorded</a>	
						<br>20.  <a href="rptRefNoShow.cfm">	  	Games with Referee Not Present</a>
						<br>21.  <a href="rptRefereeAssign.cfm?st=0">  Games with Referee Not Accepted</a>
						<br>22.  <a href="rptRefereeAssign.cfm?st=1">  Games with Referee Declining Assignments</a>
						<br>23.  <a href="rptGamesmissingreport.cfm">  Games with Referee Not Filed Match Report</a>
						<!--- <br>23a  <a href="rptGameswithreport.cfm">		Games with Referee Match Report</a> --->
						<br>23a  <a href="refMatchReportView.cfm">		Games with Referee Match Report</a>
						<br>24.  <a href="rptRefAssSum.cfm">			Referee Assignment Summary</a>
						<br>24a. <a href="refAssignmentReport.cfm">   	Referee Assignments by Date Range</a>
						
						<br><hr>
						<br>25 <a href="rptScoreDiscrep.cfm">			Score Discrepancy Report </a>
						<br>26 <a href="rptGameNotPlayed.cfm">			Game not Played Discrepancy Report </a>
						<br>27 <a href="rptNoMatchRepFiled.cfm">		No Match Report But Score Reported Discrepancy Report </a>
						<br>28 <a href="rptPlayerInj.cfm">				Player Injury Report </a>
						<br>29 <a href="rptMatchComments.cfm">			Match Reports Containing Comments </a>
						<br>30 <a href="rptMatchRepGameNotPlayed.cfm">	Match Reports Indicating Game Not Played </a>
						<br>31 <a href="rptMatchRepFieldCond.cfm">	  	Field Condition Overall Status Report </a>
						<br>32 <a href="rptMatchRepFieldCondSpecific.cfm">  Field Condition Specific Problem Report </a> 
						<br>33 <a href="rptMatchTeamLateSts.cfm">		Team Late Status Report </a>
						<br>34 <a href="rptMatchPartConduct.cfm">		Participant Conduct Report  </a>
						<br>35 <a href="rptMatchRptPasses.cfm">			Passes/Rosters Status Report </a>
						<br>36 <a href="rptClubRefs.cfm">   	Referee Contacts not through NCSA Club</a>
						<br>37 <a href="rptNoMDF.cfm">Match Day Form Not Completed</a>
						<br>37a <a href="rptGDDNotCreated.cfm">Game Day Documents file Not Created</a>
						<br>37b <a href="rptGDDIncomplete.cfm">Game Day Documents file Not Complete</a>
						<br>37c <a href="rptGDDNCByDatetime.cfm">Game Day Documents not submitted by game time</a>
						<br>37d <a href="rptRosterStatus.cfm">Status of Roster Uploaded</a>
						<br>37e <a href="rptRosterStatusReg.cfm">Status of Roster Uploaded(Registration Season)</a>
						<br>38 <a href="rptPlayingUp.cfm">Players Playing Up - Data List</a>
						<br>38a <a href="rptPlayUpRefReport.cfm">Players Playing Up - Data list From Referee Report</a>
						<br>39 <a href="rptRefereeRptPlayingUp.cfm">Referee Reporting of Players Playing Up</a>
						<br>39a <a href="rptRefereeRptNotParticipating.cfm">Referee Reporting of Players/Coaches NOT Participating</a>
						<br>39b <a href="rptNotParticipating.cfm">Players/Coaches Not Participating - Data List</a>
						<br>40 <a href="rptPlayUpDiscrepancy.cfm">Players Playing Up Compared to Referee Report Discrepancy</a>
						<br>41 <a href="rptMDFCoaches.cfm">Coaches Participating in Games per MDF</a>
						<br>42 <a href="rptMDFCoachCount.cfm">Coaches count/analysis (Team with MDF)</a>
						<br>44 <a href="rptDelayedScoreReport.cfm">Delayed Report of Score per Coach Login</a>
						<br>45 <a href="rptCoachNoShow.cfm">Coach Reported Team No Show Within Grace Period</a>
						<br>46 <a href="rptCoachRefNoShow.cfm">Coach Reported Officials Not Present</a>
						<br>47 <a href="rptCoachGameNotes.cfm">Coach Message for Division Commissioner</a>
						<br>48 <a href="rptPreGameIssuesField.cfm">Pre-Game Issues Field</a>
						<br>49 <a href="rptPreGameIssuesPlayers.cfm">Pre-Game Issues Players and Coaches</a>
						<br>50 <a href="rptPreGameIssuesPaperwork.cfm">Pre-Game Issues Paperwork</a>
						<br>51 <a href="rptPreGameIssuesComments.cfm">Pre-Game Issues Comments</a>
						<br>52 <a href="rptCompEval.cfm">Competition Evaluation</a>
						<br>53 <a href="rptCompEval2.cfm">Competition Evaluation - Sportsmanship</a>
						<br>54 <a href="rptCompEvalComments.cfm">Competition Evalation Comments</a>
						<br>55 <a href="rptRefEvalShort.cfm">Short Form Ref Evaluation</a>
						<br>56 <a href="rptRefEvalDetailCR.cfm">Detailed Ref Evaluation CR Specific</a>
						<br>57 <a href="rptRefEvalDetailedAllRefs.cfm">Detailed Ref Evaluation - Arrival, Uniform</a>
						<br>58 <a href="rptRefEvalDetailAttitude.cfm">Detailed Ref Evaluation - Attitude</a>
						<br>59 <a href="rptRefEvalDetailComments.cfm">Detailed Ref Evaluation - Comments</a>
						<br>60 <a href="rptRefEvalDetailAbility.cfm">Detailed Ref Evaluation - Ability</a>
						<br>61 <a href="rptRefEvalDetailAbilityComments.cfm">Detailed Ref Evaluation - Ability Comments</a>
						<br>62 <a href="rptCompletionAnalysis.cfm">Completion/Result Evaluation Submission Analysis</a>
						<br>63 <a href="rptRefRatingAnalysis.cfm">Referee Rating Analysis</a>
						<br>64 <a href="rptRefDelayedScoreReport.cfm">Delayed Report of Score per Referee Login</a>
						
					</TD>
				</tr>
			</table>	
		</td> <!--- end RIGHT side reports --->

		<td valign="top" width="50%"> <!--- start LEFT side reports --->
			<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
				<tr class="tblHeading">
					<TD> &nbsp;	</TD>
				</tr>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#"> <!--- currentRow or counter --->
					<TD class="tdUnderLine" > 
						<br> <a href="refereeUnPaidReport.cfm">		  Unpaid Referee Report</a>
						<br> <a href="logGameLogList.cfm">			  View Game Log Files</a>	
						<br> <a href="assignorViewMappings.cfm" target="_blank">Display Field Assignments</a>
						<br> <a href="teamsSummaryMatrix.cfm">		  Club/Teams Summary (current season)</a>
						<br> <a href="teamsSummaryMatrix.cfm?q=rsa">  Club/Teams Summary (Reg Season Approved)</a>		
						<br> <a href="teamsSummaryMatrix.cfm?q=rsu">  Club/Teams Summary (Reg Season Not Approved)</a>		
						<br> <a href="cautionEjectRpt.cfm">			  Caution Ejection Report</a>	
						<br> <a href="fieldsApproved.cfm">			  Approved Fields</a>
					</TD>
				</tr>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#">  
					<TD class="tdUnderLine" > 
						<br>A. <a href="rptFinesListAll.cfm"> 	 	  Fines Report </a> 				(Board Only)
						<br>B. <a href="refereeContactInfo.cfm"> 	  Referee Contact Info </a> 		
						<br>C. <a href="rptRefereeData.cfm"> 	 	  Referee Full Data Report </a> 		
						<br>D. <a href="rptRefereeDataQuickInfo.cfm"> Referee Quick Info Report</a> 		
					</TD>
				</tr>
			</table>	
		</td> <!--- end LEFT side reports --->
	</tr>
</table>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">

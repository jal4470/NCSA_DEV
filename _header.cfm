<cfinclude template="_preprocess.cfm">

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Northern Counties Soccer Association &copy;</title>
	<link href="https://fonts.googleapis.com/css?family=Alegreya:400,900|Roboto:300,400,700" rel="stylesheet"> 
	<link rel="stylesheet" href='/assets/bxslider/jquery.bxslider.css' rel='stylesheet' />
	<link rel="stylesheet" href="/2col_leftNav.css?t=2" type="text/css" />
	<link rel="stylesheet" href="/css/advert_edit.css" type="text/css" />
	
	<cfinclude template="/_universal_styles.cfm">

	<script src="/js/vendor/html5shiv.min.js"></script>
	<script src="https://use.fontawesome.com/2878319762.js"></script>

	<!-- Google Analytics -->
	<script>
		(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
		(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

		ga('create', 'UA-20310713-1', 'auto');  // Replace with your property ID.
		ga('send', 'pageview');
	</script>
	<!-- End Google Analytics -->
</head>

<body>

	<header id="page_header">
		<div class="container">

			<!--- ================================================================================= --->
			<!--- TIMEOUT MESSAGE --->
			<!--- ================================================================================= --->
			<CFIF isDefined("URL.x") and URL.x EQ "exp">
				<span class="yellow-card">
					Sorry, your session has expired. Please click the Login button to login again.
				</span>
			</CFIF>

			<!--- ================================================================================= --->
			<!--- LOGO --->
			<!--- ================================================================================= --->
			<hgroup id="logo" class="clearfix">
				<!--- <h1 class="logo_img"><a href="<cfoutput>#SESSION.sitevars.homehttp#</cfoutput>">NCSA &ndash; Northern Counties Soccer Association</a></h1> --->
				<h1 class="logo_img"><a href="/index.cfm">NCSA &ndash; Northern Counties Soccer Association</a></h1>
				<h2 class="logo_slogan">Enjoy the <br>Beautiful Game</h2>
			</hgroup>

			<CFIF isDefined("SESSION.USER")>
				<button id="logout_btn" class="yellow_btn" onclick="window.location='/logout.cfm'">Logout</button>
			<CFELSE>
				<button id="login_btn" class="yellow_btn">Login</button>
				<div id="login_content" class="modal">
					<cfinclude template="/login.cfm">
				</div>
			</CFIF>
			<button class="menu_btn blue_btn">Menu</button>

			<nav id="main_menu" class="menu">
				<div class="container">

					<button class="menu_btn blue_btn">Close</button>

				<!--- get PUBLIC MENU for TOP of page --->
				<CFIF NOT isDefined("SESSION.publicMenu") OR true>
					<cfinvoke component="#SESSION.sitevars.cfcPath#Menu" method="getPublicMenu" returnvariable="publicMenu">
						<cfinvokeargument name="DSN" value="#SESSION.DSN#">
						<!--- <cfinvokeargument name="isPublic" value="1"> --->
						<cfinvokeargument name="location" value="1">
						<cfinvokeargument name="swGetChild" value="1">
					</cfinvoke>
					<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
						<CFSET SESSION.publicMenu = publicMenu>
					</CFLOCK>
				</CFIF>	
				<!--- get PARENT menu --->
				<cfquery name="getParent" dbtype="query">
						SELECT LOCATION_ID, LOCATOR, MENU_ID, MENU_NAME, PARENT_MENU_ID, SEQ
						FROM SESSION.publicMenu
						WHERE Parent_menu_id is NULL
						order by SEQ
				</cfquery>

				<!--- START LOGIC FOR ROLE MENU --->
				<CFSET ROLEID = 0>
				<CFIF isDefined("URL.rid")>
					<CFSET ROLEID = URL.rid>
				<CFELSEIF isDefined("SESSION.menuRoleID")>
					<CFSET ROLEID = SESSION.menuRoleID>
				<CFELSEIF isDefined("SESSION.USER.stRole") >
					<cfset keyList = listSort(structKeyList(SESSION.USER.stRole),"numeric","asc")>
					<CFIF listLen(keyList) EQ 1>
						<CFSET ROLEID = keyList>
					</CFIF>
				</CFIF>

				<CFIF isDefined("SESSION.menuRoleID")>
					<CFIF SESSION.menuRoleID NEQ VARIABLES.ROLEID>
						<!--- Role has changed so reset role/menu to new selection --->
						<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
							<CFSET SESSION.menuRoleID = VARIABLES.ROLEID>
							<CFIF isDefined("SESSION.pmID")>
								<CFSET SESSION.pmID = 0>
							</CFIF>
							<CFIF isDefined("SESSION.smID")>
								<CFSET SESSION.smID = 0>
							</CFIF>
						</CFLOCK>
					</CFIF>
				<CFELSE>
					<!--- not defined, initialize it --->
					<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
						<CFSET SESSION.menuRoleID = VARIABLES.ROLEID>
					</CFLOCK>
				</CFIF>
				<!--- END LOGIC FOR ROLE MENU --->

			<!--- ================================================================================= --->
			<!--- MAIN MENU --->
			<!--- ================================================================================= --->
				<ul class="primary_menu clearfix">
					<cfloop query="getParent">
					  <cfoutput>
						<li class="headlink"><!---  --->
							<a href="javascript:void(0);" id="menuItem#menu_id#">
								#MENU_NAME#
							</a>  
							 <!--- #repeatString("&nbsp;",14)# --->
							<cfquery name="getSub" dbtype="query">
								SELECT LOCATION_ID, LOCATOR, MENU_ID, MENU_NAME, PARENT_MENU_ID, SEQ
								FROM SESSION.publicMenu
								WHERE Parent_menu_id = #MENU_ID#
								order by SEQ
							</cfquery>
							<ul>
							<CFLOOP query="getSub">
								<li><a href="#LOCATOR#">#MENU_NAME#</a></li>
							</CFLOOP>
							</ul>
						</li>
						</cfoutput>
					</cfloop>
				</ul>	

			<!--- ================================================================================= --->
			<!--- LOGGED IN / LOGGED OUT MENUS --->
			<!--- ================================================================================= --->
			<CFIF isDefined("SESSION.USER")>
				<ul class="mobile_user_menu logged_in">
					<li class="menu_title welcome"><h3>Welcome <cfoutput>#SESSION.USER.FNAME# #SESSION.USER.LNAME#</cfoutput></h3></li>
					<CFIF isDefined("session.menuroleid")>
		              <li><a href="loginHome.cfm?rid=<cfoutput>#SESSION.menuroleid#</cfoutput>">Home</a></li>
		            <cfelse>
		              <li><a href="loginHome.cfm">Home</a></li>
		            </CFIF>
            	<cfif isDefined("SESSION.MENUROLEID")>
	            <CFSWITCH expression="#SESSION.MENUROLEID#">
	              <cfcase value="25"> <!--- referee --->
	                <!--- change the following to include _homeRefereePage.cfm create a _homeXXXpage.cfm page for each type that is needed,
	                    for repeats, cfcase value="1,2,3,4,5"       
	                 --->
	                    <CFQUERY name="qGetNewRefAssignments" datasource="#SESSION.DSN#">
	                      Select Game_ID, GAME_Date
	                        from V_Games  
	                       WHERE  season_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#SESSION.CurrentSeason.ID#"> and ( RefID      = #SESSION.USER.ContactID# 
	                           and (Ref_accept_Date is Null or Ref_accept_Date = '') AND Ref_accept_YN is NULL )
	                          or ( AsstRefID1 = #SESSION.USER.ContactID# 
	                           and (ARef1AcptDate   is Null or ARef1AcptDate   = '')   AND ARef1Acpt_YN  is NULL )
	                        or ( AsstRefID2 = #SESSION.USER.ContactID# 
	                           and (ARef2AcptDate   is Null or ARef2AcptDate   = '')   AND ARef2Acpt_YN is NULL )
	                    </CFQUERY> 
	                    <CFIF isDefined("SESSION.GLOBALVARS.REFASSIGNVIEWDATEYN") AND SESSION.GLOBALVARS.REFASSIGNVIEWDATEYN EQ "Y">
	                      <CFIF isDate(SESSION.GLOBALVARS.REFASSIGNVIEWDATE)>
	                        <CFQUERY name="qGetNewRefAssignments" dbtype="query">
	                          Select *
	                            from qGetNewRefAssignments 
	                           WHERE GAME_Date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#(dateFormat(SESSION.GLOBALVARS.REFASSIGNVIEWDATE,"mm/dd/yyyy"))#" >   
	                        </CFQUERY> 
	                           <!--- WHERE GAME_Date <= '#(dateFormat(SESSION.GLOBALVARS.REFASSIGNVIEWDATE,"mm/dd/yyyy"))#'   --->
	                      </CFIF>
	                    </CFIF>
	                  <li>
	                    <span class="red fauxLink">
	                      New Game Assignments: <b>[<cfoutput>#qGetNewRefAssignments.RECORDCOUNT#]</cfoutput></b> 
	                      <cfif qGetNewRefAssignments.RECORDCOUNT>
	                        <br> Please confirm assignments.
	                      </cfif>
	                    </span>
	                  </li>
	              </cfcase>
	            </CFSWITCH>
          	</cfif>
          	<CFIF structCount(SESSION.USER.stRole) GT 1>
              <li><a href="loginhome.cfm">Switch Roles</a></li>
              <li><a href="logout.cfm">Logout</a></li>
            <CFELSE> 
              <li><a href="logout.cfm">Logout</a></li>  
            </CFIF>
			      <CFIF structCount(SESSION.USER.stRole) EQ 1>
			        <CFSET roleid = structKeyList(SESSION.USER.stRole)>
			      <CFELSE>  
			        <CFIF isDefined("SESSION.MENUROLEID")>
			          <CFSET roleid = SESSION.MENUROLEID>
			        <CFELSE>
			          <CFSET roleid = 0>
			        </CFIF>
			      </CFIF> 
					</ul>
			<CFELSE>
				<ul class="mobile_user_menu logged_out">
						<CFSET ROLEID = 0>
						<li><a href="coachespage.cfm">Coaches</a></li>
		        <li><a href="playerspage.cfm">Players</a></li>
		        <li><a href="parentspage.cfm">Parents</a></li>
		        <cfset swShowTeamFlightingPublicLink = "N" >
		        <cfinvoke component="#SESSION.SITEVARS.CFCPATH#GLOBALVARS" method="getGlobalValue" returnvariable="swShowTeamFlightingPublicLink">
		          <cfinvokeargument name="globalVarName" value="ShowTeamFlightingPublicLink">
		        </cfinvoke>
		        <CFIF swShowTeamFlightingPublicLink EQ "Y" >
		          <cfinvoke component="#SESSION.sitevars.cfcPath#SEASON" method="getNextSeason" returnvariable="qRegSeasonData"></cfinvoke>
		          <li><a href="teamFlightDisplay.cfm"> <cfoutput>#qRegSeasonData.SEASON_SF# #qRegSeasonData.SEASON_YEAR#</cfoutput> Team Flighting</a></li>
		        </CFIF>
		        <li><a href="login.cfm">Click Here to Login</a></li>
					</ul>
			</CFIF> <!--- isdefined session.user --->

		  	<!--- ================================================================================= --->
			<!--- USER ROLE MENUS --->
			<!--- ================================================================================= --->
			  <CFIF isDefined("URL.smid")>
			    <CFSET selectedMenuID = URL.smid>
			    <CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
			      <CFSET SESSION.smid = smid>
			    </CFLOCK>
			  <CFELSEIF isDefined("SESSION.smid")>
			    <CFSET selectedMenuID = SESSION.smid>
			  <cfelse>
			    <CFSET selectedMenuID = 0>
			  </CFIF>

			 <cfinvoke component="#SESSION.sitevars.cfcPath#Menu" method="getPrivateMenu" returnvariable="RoleMenu">
			    <cfinvokeargument name="DSN"    value="#SESSION.DSN#">
			    <cfinvokeargument name="isPublic"   value="0">
			    <cfinvokeargument name="location"   value="2">
			    <cfinvokeargument name="swGetChild" value="1">
			    <cfinvokeargument name="roleID"   value="#variables.ROLEID#">
			  </cfinvoke> 

			  
				<cfif RoleMenu.RECORDCOUNT GT 0>
				<ul class="related_links">

				  <li class="menu_title">
				  	<cfoutput>
			        <CFIF len(trim(RoleMenu.ROLEDISPLAYNAME))>
			          <h3>#RoleMenu.ROLEDISPLAYNAME#
			          <CFIF listFind("26,27,28",ROLEID)>
			            <CFIF isDefined("SESSION.USER.CLUBNAME") and len(trim(SESSION.USER.CLUBNAME))>
			              <br> for #SESSION.USER.CLUBNAME#
			            </CFIF>
			          <CFELSE>
			            <br> for Northern Counties Soccer Association
			          </CFIF>
			          </h3>
			        <CFELSE>
			          &nbsp;
			        </CFIF> 
			        </cfoutput>
	      		 </li>

			    <cfQuery name="roleTopMenu" dbtype="query">
			      SELECT LOCATOR, MENU_ID, MENU_NAME, MENU_CODE, PARENT_MENU_ID, SEQ
			      FROM RoleMenu
			      WHERE Parent_menu_id IS NULL
			      order by SEQ
			    </cfquery>  
			     
			    <cfoutput>
				    <CFLOOP query="roleTopMenu">
				      <CFSET swShow = true>
				      <CFIF UCASE(MENU_CODE) EQ "SEASONALREG">
				        <!--- dont show REGISTRATION Link if registration is closed --->
				        <CFIF NOT SESSION.GLOBALVARS.REGOPEN EQ "OPEN">
				          <CFSET swShow = false>
				        </CFIF>
				      </CFIF>

				      <CFIF swShow>
				        <li><a href="javascript:void(0);" id="privItem#MENU_ID#">#menu_name#</a>
				          <ul id="privMenu#MENU_ID#" class="privMenu">
				          <cfQuery name="roleSubMenu" dbtype="query">
				            SELECT LOCATOR, MENU_ID, MENU_CODE, MENU_NAME, PARENT_MENU_ID, SEQ
				            FROM RoleMenu
				            WHERE Parent_menu_id = #MENU_ID#
				            order by SEQ
				          </cfquery>  
				          <CFSET parentMenuID = MENU_ID>
				          <CFLOOP query="roleSubMenu">
				            <CFSET swShowSub = true>
				            <CFIF listLen(LOCATOR,"?") GT 1>
				              <CFSET appendURL = "&pmid=" & parentMenuID & "&smid=" & MENU_ID >
				            <CFELSE>
				              <CFSET appendURL = "?pmid=" & parentMenuID & "&smid=" & MENU_ID >
				            </CFIF>

				            <!--- START - SEASONAL REGISTRATION - toggles --->
				            <CFIF UCASE(MENU_CODE) EQ "CLUBREGISTER">   <!--- show if option is on --->
				              <CFIF isDefined("SESSION.GLOBALVARS.SHOWREGISTERCLUB") AND SESSION.GLOBALVARS.SHOWREGISTERCLUB EQ "Y">
				                <CFSET swShowSub = true>
				              <CFELSE>
				                <CFSET swShowSub = false>
				              </CFIF>
				            </CFIF>
				            <CFIF UCASE(MENU_CODE) EQ "TEAMREGISTER">   <!--- show if option is on --->
				              <CFIF isDefined("SESSION.GLOBALVARS.SHOWREGISTERTEAM") AND SESSION.GLOBALVARS.SHOWREGISTERTEAM EQ "Y">
				                <CFSET swShowSub = true>
				              <CFELSE>
				                <CFSET swShowSub = false>
				              </CFIF>
				            </CFIF>
				            <CFIF UCASE(MENU_CODE) EQ "GAMEPRESEASCHED">
				              <CFSET swShowSub = false> 
				              <!--- show Pre Season scheduling Link when authorized clubs are allowed to edit, the 
				                  link will be open to all, the locator page will determine if user is autorized to edit or not --->
				              <CFIF isDefined("SESSION.GLOBALVARS.EDITGAMEAUTHCLUB") AND SESSION.GLOBALVARS.EDITGAMEAUTHCLUB EQ "Y">
				                <CFSET swShowSub = true>
				              </CFIF>
				            </CFIF>
				            <!---  end - PRE-SEASON ACTIVITEIS - toggles --->
				            <!--- START - GAME MANAGEMENT - toggles --->
				            <CFIF UCASE(MENU_CODE) EQ "GAMECHANGEREQSUBMIT">  <!--- show if option is on --->
				              <CFIF isDefined("SESSION.GLOBALVARS.ShowGameChangeRequest") AND SESSION.GLOBALVARS.ShowGameChangeRequest EQ "Y">
				                <CFSET swShowSub = true>
				              <CFELSE>
				                <CFSET swShowSub = false>
				              </CFIF>
				            </CFIF>
				            <!--- end - PRE-SEASON ACTIVITEIS - toggles --->
				            <CFIF swShowSub>
				              <li><a href="#LOCATOR##appendURL#">
				                  <CFIF MENU_ID EQ selectedMenuID>
				                    <div class="privMenuSelected"> #MENU_NAME# </div>
				                  <CFELSE>
				                    #MENU_NAME#
				                  </CFIF>
				                </a>
				              </li>
				            </CFIF>
				          </CFLOOP>
				          </ul>
				        </li>
				      </CFIF>
				    </CFLOOP>
			    </cfoutput>
			  </ul><!--- related_links--->
			  </cfif>


				</div><!--- END OF NAV CONTAINER --->
			</nav><!--- END OF NAVIGATION --->


		<!--- ================================================================================= --->
		<!--- SOCIAL ICONS --->
		<!--- ================================================================================= --->
<!--- 		<ul id="social_icons">
			<li class="facebook"><a class="icon" href="##"><i class="fa fa-facebook-official" aria-hidden="true"></i><span>Facebook</span></a></li>
			<li class="twitter"><a class="icon" href="##"><i class="fa fa-twitter-square" aria-hidden="true"></i><span>Twitter</span></a></li>
		</ul> --->

		<!--- ================================================================================= --->
		<!--- TICKER --->
		<!--- ================================================================================= --->
			<cfquery name="getTicker" datasource="#application.dsn#">
				SELECT message
				FROM   tbl_TickerMsg
			</cfquery>

			<div id="ticker">
				<div class="container">
					<ul class="news_list">
						<cfoutput query="getTicker">
							<li>#message#</li>
						</cfoutput>
					</ul>
					<!--- <span class="ticker_arrow ticker_left"></span>
					<span class="ticker_arrow ticker_right"></span> --->
				</div>
			</div>

		</div><!--- .container --->
	</header>

				<!---
					DO WE NEED THIS FOR THE REDESIGN?
					<cfloop query="getParent">
						<cfquery name="getSub" dbtype="query">
							SELECT LOCATION_ID, LOCATOR, MENU_ID, MENU_NAME, PARENT_MENU_ID, SEQ
							FROM SESSION.publicMenu
							WHERE Parent_menu_id = #MENU_ID#
							order by SEQ
						</cfquery>
					  	<div id="subNav#menu_id#" class="subNav"  align="left">
							<CFLOOP query="getSub">
							   	<cfif currentRow GT 1><img src="<cfoutput>#SESSION.sitevars.imagePath#soccer_ball_bullet.jpg</cfoutput>" border="0" class="bullit"></cfif> 
								<cfset spanMenuHiLiteClass = "SubNavTextNormal">
								<cfif PARENT_MENU_ID EQ 3 ><!--- For Sched/Results, all the submenus use the same template but with different URL values
											  so the way we check for which link to hilite is to check the value of the url param --->
									<CFIF listLast(CGI.QUERY_STRING) EQ listLast(LOCATOR,"?")>
										<cfset spanMenuHiLiteClass = "SubNavTextHiLite">
									</CFIF>
								<CFELSE><!--- all other menu options, we check to see which locator matches the page we are on --->
									<CFIF GetFileFromPath(CGI.CF_TEMPLATE_PATH) EQ listFirst(LOCATOR,"?")>
										<cfset spanMenuHiLiteClass = "SubNavTextHiLite">
									</CFIF>
								</cfif>
								<a href="#LOCATOR#"><span class="#spanMenuHiLiteClass#">#MENU_NAME#</span></a>  
							</CFLOOP>
						</div>
					</cfloop>
				--->


<div id="page_body" class="clearfix">
	<div class="container">

		<main id="content">
			<div class="container">
			
		

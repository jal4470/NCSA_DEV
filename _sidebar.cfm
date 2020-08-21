<!--- left nav --->
<aside id="sidebar">
  <div class="container">
  <!--- ================================================================================= --->
  <CFIF isDefined("SESSION.USER")>
    <!--- a user has logged in, show this --->
    <section class="user_menu logged_in">
      <h3 class="welcome_user">Welcome <cfoutput>#SESSION.USER.FNAME# #SESSION.USER.LNAME#</cfoutput></h3> 
      <cfoutput>
        <ul>
          <CFIF isDefined("session.menuroleid")>
            <li><a href="loginHome.cfm?rid=#SESSION.menuroleid#">Home</a></li>
          <cfelse>
            <li><a href="loginHome.cfm">Home</a></li>
          </CFIF>

          <cfif isDefined("SESSION.MENUROLEID") AND isDefined("SESSION.USER")>
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
                      <span class="red">
                        New Game Assignments: <strong>[#qGetNewRefAssignments.RECORDCOUNT#]</strong> 
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
        </ul>
      </cfoutput>

      <CFIF structCount(SESSION.USER.stRole) EQ 1>
        <CFSET roleid = structKeyList(SESSION.USER.stRole)>
      <CFELSE>  
        <CFIF isDefined("SESSION.MENUROLEID")>
          <CFSET roleid = SESSION.MENUROLEID>
        <CFELSE>
          <CFSET roleid = 0>
        </CFIF>
      </CFIF>
    </section>

  <CFELSE>
    <!--- Public View, (not logged in) ---> 
    <CFSET ROLEID = 0>
    <section class="user_menu logged_out">
      <h3 class="menu_title"><a href="javascript:void(0)">Helpful Links</a></h3>
      <ul>
        <li><a href="coachespage.cfm">Coaches</a></li>
        <li><a href="playerspage.cfm">Players</a></li>
        <li><a href="parentspage.cfm">Parents</a></li>
        <cfset swShowTeamFlightingPublicLink = "N" >
        <cfinvoke component="#SESSION.SITEVARS.CFCPATH#GLOBALVARS" method="getGlobalValue" returnvariable="swShowTeamFlightingPublicLink">
          <cfinvokeargument name="globalVarName" value="ShowTeamFlightingPublicLink">
        </cfinvoke>

        <CFIF swShowTeamFlightingPublicLink EQ "Y" >
          <cfinvoke component="#SESSION.sitevars.cfcPath#SEASON" method="getNextSeason" returnvariable="qRegSeasonData">
          </cfinvoke>
          <li><a href="teamFlightDisplay.cfm"> <cfoutput>#qRegSeasonData.SEASON_SF# #qRegSeasonData.SEASON_YEAR#</cfoutput> Team Flighting</a></li>
        </CFIF>

        <li><a href="login.cfm">Click Here to Login</a></li>
      </ul>
    </section>
  </CFIF>

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

<!--- Only Show Related Links if they Exist --->
<cfif RoleMenu.RecordCount GT 0>
  <section class="related_links">
      <h3><cfoutput>
        <CFIF len(trim(RoleMenu.ROLEDISPLAYNAME))>
          #RoleMenu.ROLEDISPLAYNAME#
          <CFIF listFind("26,27,28",ROLEID)>
            <CFIF isDefined("SESSION.USER.CLUBNAME") and len(trim(SESSION.USER.CLUBNAME))>
              <br> for #SESSION.USER.CLUBNAME#
            </CFIF>
          <CFELSE>
            <br> for Northern Counties Soccer Association
          </CFIF>
        <CFELSE>
          &nbsp;
        </CFIF> 
      </cfoutput>
    </h3>
    <!--- <hr /> --->
    <ul>
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
                WHERE Parent_menu_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#roleTopMenu.MENU_ID#">
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
                <!--- end - SEASONAL REGISTRATION - toggles --->
                <!--- START - PRE-SEASON ACTIVITIES - toggles --->
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
    </ul>
  </section><!--- relatedLinks --->
</cfif>
      
  <cfoutput>
    <CFIF len(trim(RoleMenu.ROLEDISPLAYNAME)) AND listFind("1,59",SESSION.menuRoleID) NEQ 0>  
      <section class="site_info">
        <cfif isdefined("session.working_with_season")>
          <h3>Site Info</h3>
          <ul>
          <li><button class="padded_btn gray_btn" onclick="window.location.href='#cgi.script_name#?mv=0';">RESET TO CURRENT SEASON</button></li>
          <li>Working With Season:   <strong>#SESSION.currentSeason.CODE# </strong></li>
          <li>Registration Season: <strong><CFIF isDefined("SESSION.REGSEASON")> #SESSION.REGSEASON.CODE# <CFELSE>none </CFIF></strong></li>
          <li>TBS Entry:       <strong>#SESSION.globalvars.TBSOPEN#</strong></li>
          <li>Flight Appeals:    <strong>#SESSION.globalvars.APPEALOPEN#</strong></li>
          <li>Schedule Display:    <strong>#SESSION.globalvars.ALLOWSCHEDDISPLAY#</strong></li>
          <li>Auth Clubs Edit Game Sched: <strong>#SESSION.globalvars.EditGameAuthClub#</strong></li>
          <li>Ref Assignment Viewable:  <strong>#SESSION.globalvars.RefAssignViewDate#</strong></li>
          </ul>
        <cfelse>
          <cfquery name="getAllbutCurrentSeason" datasource="#session.dsn#">
            select distinct season_id, seasoncode from tbl_season
            order by season_id desc
          </cfquery>

          <cfif getAllButCurrentSeason.recordcount eq 0>
            <p>This is the first season being played</p>
          <cfelse>
            <p>The Following Allows you to  View Activity for of a Previous Season</p>
            <form action="#cgi.script_name#" method="post" class="clearfix">
              <div class="select_box">
                <select name="work_with_season">
                  <cfloop query="getAllbutCurrentSeason">
                    <option value="#season_id#" #iif(season_id eq SESSION.CurrentSeason.ID,de('selected'),de(''))#>#seasoncode#</option>
                  </cfloop>
                </select>
              </div>
              <button type="submit" class="smallButton gray_btn">View Season</button>
              <!--- <input type="submit" value="View Season" class="smallButton"> --->
            </form>
          </cfif>
          <h3>Site Info</h3>
          <ul>
          <li>Current Season:    <strong>#SESSION.currentSeason.CODE# </strong></li>
          <li>Registration Season: <strong><CFIF isDefined("SESSION.REGSEASON")> #SESSION.REGSEASON.CODE# <CFELSE>none </CFIF></strong></li>
          <li>TBS Entry:       <strong>#SESSION.globalvars.TBSOPEN#</strong></li>
          <li>Flight Appeals:    <strong>#SESSION.globalvars.APPEALOPEN#</strong></li>
          <li>Schedule Display:    <strong>#SESSION.globalvars.ALLOWSCHEDDISPLAY#</strong></li>
          <li>Auth Clubs Edit Game Sched: <strong>#SESSION.globalvars.EditGameAuthClub#</strong></li>
          <li>Ref Assignment Viewable:  <strong>#SESSION.globalvars.RefAssignViewDate#</strong></li>
          </ul>
        </cfif>
      </section>
    </CFIF>
  </cfoutput>

 

  <!--- get ads --->
  <cfinvoke
    component="#application.sitevars.cfcpath#.ad"
    method="getCurrentAds"
    returnvariable="ads">
  <cfif ads.recordcount>
    <section class="banner_ads">
      <cfoutput query="ads">
        
        <cfset galabel="ad#ad_id#: #jsstringformat(title)#">
        <!--- log display of this ad --->
        <script language="JavaScript">
          ga('send', 'event', 'NCSA Ads', 'Display', '#galabel#');
        </script>
        <div class="ad">
          <cfif href NEQ "" OR customContent NEQ "">
            <a target="_blank" href="adverts_render.cfm?adid=#ad_id#" onClick="recordOutboundLink(this, 'NCSA Ads', 'Click', '#galabel#');">
          </cfif>
          <cfif text NEQ "">
            <div class="adText">
              #text#
            </div>
          <cfelse>
            <div class="adContent">
              <img src="adverts_view.cfm?adid=#ad_id#">
            </div>
          </cfif>
          <cfif href NEQ "" OR customContent NEQ "">
            </a>
          </cfif>
        </div>
      </cfoutput>
    </section>
  </cfif>
  <!--- =================================================================================--->

  </div><!--- .container --->
</aside><!--- #navBar --->
<!--- Get Directory Path --->
<cfset dirPath = ExpandPath("./")>

<!--- Get File Information --->
<cfdirectory directory="#dirPath#js/" name="DirInfo" action="list" sort="datelastmodified desc"></cfdirectory>

<!--- Set last modified value to a variable --->
<cfset last_modified = DateTimeFormat(DirInfo.datelastmodified, "mmddyyyyhhnnss")>

<!--- Append to JS file call --->
<script type="text/javascript" src="js/scripts.js?<cfoutput>#last_modified#</cfoutput>"></script>
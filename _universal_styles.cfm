<!--- Get Directory Path --->
<cfset dirPath = ExpandPath("./")>

<!--- Get File Information --->
<cfdirectory directory="#dirPath#css/" name="DirInfo" action="list" sort="datelastmodified desc"></cfdirectory>

<!--- Set last modified value to a variable --->
<cfset last_modified = DateTimeFormat(DirInfo.datelastmodified, "mmddyyyyhhnnss")>

<!--- Append to CSS file call --->
<link rel="stylesheet" href="css/ncsa_2016.css?<cfoutput>#last_modified#</cfoutput>" type="text/css">
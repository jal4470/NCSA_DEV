<!--- 
    FileName:   fieldDirPrint.cfm
    Created on: 06/16/2017
    Created by: apinzone@capturepoint.com
    
    Purpose: Printer friendly version of field information and directions.
    
MODS: mm/dd/yyyy - filastname - comments

 ---> 
<cfif isdefined("url.fid") and isNumeric(url.fid)>
    <cfset fid = url.fid>
<cfelseif isdefined("variables.fid") and isNumeric(variables.fid)>
    <cfset fid = variables.fid>
<cfelse>
    <cfset fid = 0>
</cfif>

<cfif NOT isdefined("fid") and NOT isNumeric(fid)>
    <cfset fid = 0>
</cfif>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Northern Counties Soccer Association &copy;</title>
    <style type="text/css">
        * {
            box-sizing: border-box;
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            -ms-box-sizing: border-box;
            -o-box-sizing: border-box; }
        body {
            font-family: 'Roboto', Arial, sans-serif;
            width: 8.5in;
            padding: .5in;
            margin: 0; }
        h2 {
            color: #000;
            font-family: 'Alegreya', Georgia, serif;
            font-size: 30px;
            margin: 0;
            padding-bottom: 10px; }
        ul {
            margin: 0;
            padding: 0;
            list-style: none; }
        ul li { 
            clear: left;
            border-top: 1px solid #C7C7C7;
            font-size: .857em;
            line-height: 1.25;
            padding: 10px 0; }
        ul li span {
          display: inline-block;
          float: left;
          font-weight: bold;
          height: 30px;
          margin: 0;
          width: 125px; }
        .field_comments span, 
        .field_exceptions span, 
        .field_directions span {
            display: block;
            float: none;
            height: auto;
            margin-bottom: 5px;
            width: auto; }

        header {
            background: #eee;
            border-bottom: 1px solid #ddd;
            height: 40px;
            line-height: 40px;
            padding: 0 15px;
            position: absolute;
            top: 0; left: 0; right: 0; }
            header h1 { 
                font-size: 16px;
                margin: 0; }
            header .print {
                background-color: #9A8206;
                border-color: #524600;
                -moz-appearance: none;
                -webkit-appearance: none;
                border-radius: 2px 10px;
                border-style: solid;
                border-width: 1px;
                color: #fff;
                cursor: pointer;
                font-family: 'Roboto', Arial, sans-serif;
                font-size: 12px;
                font-weight: 700;
                outline: 0;
                padding: 5px 10px;
                text-align: center;
                text-transform: uppercase;
                position: absolute;
                top: 50%; left: 50%;
                transform: translate(-50%,-50%);
                -webkit-transform: translate(-50%,-50%);
                -moz-transform: translate(-50%,-50%);
                -ms-transform: translate(-50%,-50%);
                -o-transform: translate(-50%,-50%);  }
                header .print:hover {
                    background-color: #524600; }

        @media only print{  header { display: none; }  }
    </style>
</head>
<body onload="window.print()">
<cfoutput>
    <header>
        <h1>NCSA Printer Friendly Field Directions</h1>
        <button class="print" type="button" name="printBtn" onclick="window.print()">Print</button>
    </header>
    <cfinclude template="fieldDirPop.cfm">
</cfoutput>
</body>
</html>
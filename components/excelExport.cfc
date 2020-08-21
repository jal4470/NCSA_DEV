<!------------------------------------------
  Excel Export
  A general template for exporting reports to excel.

  Requires:
    1. Query for header rows (table headers).
    2. Query for content rows (results).
  
  Created On: 9/13/2017
  Created By: A.Pinzone
---------------------------------------------->


<CFCOMPONENT DISPLAYNAME="ExcelExport">

  <CFFUNCTION NAME="createExcelDoc" DISPLAYNAME="createExcelDoc" RETURNTYPE="any" output="No" access="public">

    <CFARGUMENT NAME="queryResults" type="any" REQUIRED="Yes">

    <cfscript>
      results = arguments.queryResults;
      headers = arguments.queryResults.columnList;

      headerFormat = StructNew();
      headerFormat.bold = true;
      headerFormat.alignment = "center";

      xls = SpreadsheetNew();
      SpreadsheetAddRows(xls, results, 1, 1, true, [""], true);
      SpreadsheetFormatRow(xls, headerFormat, 1);
      
    </cfscript>

    <cfheader name="Content-Disposition" value="attachment;filename=gameSchedule.xls"> 
    <cfcontent type="application/vnd.ms-excel" variable="#SpreadsheetReadBinary( xls )#">
  
  </CFFUNCTION>

</CFCOMPONENT>
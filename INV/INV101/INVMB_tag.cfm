<title>標籤</title>

<cfquery datasource="#SESSION.COMPANY#" name="INVMB" >
    SELECT *
    FROM INVMB
    WHERE  0 = 0
      AND MB001  IN (#PreserveSingleQuotes(FORM.check1)#)
    ORDER BY MB001
</cfquery>

<cfoutput>

<cfdocument pagetype="custom" unit="cm"  pageheight="6" pagewidth="10" format="pdf" marginleft="0.1" marginright="0.1" scale="100" margintop="0.2" marginbottom="0.1"> 

    <cfloop query="INVMB">
 
 <cfquery datasource="#SESSION.COMPANY#" name="INVMC" >
    SELECT *
    FROM INVMC
    WHERE  0 = 0
      AND MC001 = '#MB001#'
	  AND MC002 = '#MB017#'
</cfquery>

   
    <cfdocumentsection> 
        <table style="font:'微軟正黑體';font-size:17" align="center">
				<tr><td colspan="2" width="300"><center><div style="font:'IDAutomationHC39M';font-size:18px">*#TRIM(MB001)#*</div> <br /></center></td></tr>     
				<tr><td  width="60">品號：</td><td><strong>#MB001#</strong><br></td></tr>
				<tr><td>品名：</td><td><strong>#MB002#</strong><br></td></tr>
				<tr><td>規格：</td><td><strong>#MB003#</strong><br></td></tr>
				<tr><td>備註：</td><td><strong>#MB028#</strong><br></td></tr>
				<tr><td>儲位：</td><td><strong><cfloop query="INVMC">#MC003#</cfloop></strong><br></td></tr>
				<cfif #FORM.num# neq ""><tr><td>數量：</td><td><strong>#FORM.num#</strong><br></td></tr></cfif>
        </table>
    </cfdocumentsection>
    
    </cfloop>
    
</cfdocument>

</cfoutput>
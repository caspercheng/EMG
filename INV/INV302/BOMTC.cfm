<cfif  NOT IsDefined("FORM.MB001")> <cfset #FORM.MB001#="">	</cfif>
<cfif  NOT IsDefined("FORM.submit")> <cfset #FORM.submit#="">	</cfif>

<title>材料品號設變記錄查詢作業</title>

<h4><center>材料品號設變記錄查詢作業</center></h4>

<!---資料查詢介面--->
<cfform action="BOMTC.cfm">
	<table align="center" bgcolor="9999CC">
	 <tr>
	  <td>材料品號：</td> <td><cfinput type="Text" name="MB001" size="30" maxlength="30"  required="yes"></td>
	  <td><input type="submit" name="submit" value="查詢"></td>
     </tr>
	</table>
</cfform>



<cfif #FORM.submit# neq "">
<!---查詢BOM表資料--->

<cfquery datasource="EAGLE" name="INVMB">
    SELECT TA003,TC105,TC108,TC005,TC008,TB004
    FROM BOMTC
    JOIN BOMTB ON TC001=TB001 AND TC002=TB002 AND TC003=TB003
    JOIN BOMTA ON TC001=TA001 AND TC002=TA002
    WHERE TA007='Y'
     AND TC105 = '#FORM.MB001#'
</cfquery>
        

 <!---第一層--->
<table align="center">
    <tr bgcolor="CCCCCC">
     <td>設變日期</td>
     <td>原材料品號</td>
     <td>原組成用量</td>
     <td>新材料品號</td>
     <td>新組成用量</td>
     <td>主件品號</td>
    </tr>
          
<cfoutput>
 
  <cfloop query="INVMB">
    <tr>
     <td>#MID(TA003,1,4)#-#MID(TA003,5,2)#-#MID(TA003,7,2)#</td>
     <td>#TC105#</td>
     <td align="right">#TC108#</td>
     <td>#TC005#</td>
     <td align="right">#TC008#</td>
     <td>#TB004#</td>
    </tr>
          
  </cfloop>
 </cfoutput>	
   
</table>
	
</cfif>      


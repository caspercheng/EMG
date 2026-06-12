<!---105.6.8 新增未來異動量欄位--->
<!---105.6.8 BOM展階查詢獨立檔案，再做include--->

<cfinclude template="/EAGLE/menu_all.cfm">

<cfif  NOT IsDefined("FORM.MB001")> <cfset #FORM.MB001#="">	</cfif>
<cfif  NOT IsDefined("FORM.LB002")> <cfset #FORM.LB002#="">	</cfif>
<cfif  NOT IsDefined("FORM.submit")> <cfset #FORM.submit#="">	</cfif>

<title>BOM多階標準成本查詢作業</title>

<h4><center>BOM多階標準成本查詢</center></h4>

<!---資料查詢介面--->
<cfform action="BOM2.cfm">
	<table align="center" bgcolor="9999CC">
	 <tr>
	  <td>品號：</td> <td><cfinput type="Text" name="MB001" size="30" maxlength="30"  required="yes"></td>
	  <td>實際成本年月：</td> <td><cfinput type="Text" name="LB002" size="6" maxlength="6" required="yes" ></td>
	  <td><input type="submit" name="submit" value="查詢"></td>
     </tr>
	</table>
</cfform>


<cfif #FORM.submit# EQ "查詢" AND (#FORM.MB001# NEQ "" OR (#FORM.MG001# NEQ "" AND #FORM.MG003# NEQ ""))>

<!---查詢品號資料--->
	<cfquery name="INVMB_MD" datasource="EAGLE">
	   SELECT DISTINCT MB001,MB002,MB003,MB004,MC004,MB005,MB025,MB068,MB057,MB058,MB059,MB060,MB061,MB062,MB063,LB010,LB011,LB012,LB013,LB014
	   FROM INVMB
       JOIN INVLB ON LB001=MB001 AND LB002='#FORM.LB002#'
	   LEFT JOIN BOMMC ON MC001=MB001
	   WHERE  0 = 0
       <cfif FORM.MB001 IS NOT ""> AND  MB001 = '#FORM.MB001#' </cfif>
	</cfquery>
<cfoutput query="INVMB_MD"><cfset MB001=#MB001#>	</cfoutput>
<cfset sn="0010">

<!---查詢BOM表資料--->

<cfquery datasource="EAGLE" name="INVMB">
    SELECT MB001,MB002,MB003,MB004,MB005,MB025,MB068,MB057,MB058,MB059,MB060,MB061,MB062,MB063,LB010,LB011,LB012,LB013,LB014,MD003
        
    FROM BOMMD
    
    LEFT JOIN  JAG_TEST..INVMB ON MB001 = MD003
    JOIN INVLB ON LB001=MB001 AND LB002='#FORM.LB002#'
    
    WHERE 0=0 AND MD001 = '#MB001#' AND MB002 NOT LIKE '%貼紙%'
</cfquery>
        
<!---列出最上層品號、品名，並區分是由類別選單查詢品號或用查詢功能來查詢--->
<cfoutput query="INVMB_MD">主件品號：#MB001#<br />品名：#MB002#<br />規格：#MB003#<br />單位：#MB004#<br />標準批量：#MC004#</cfoutput>

 <!---第一層--->
<table>
    <tr bgcolor="CCCCCC">
     <td>低階碼</td>
     <td>品號</td>
     <td>品名</td>
     <td>規格</td>
     <td>屬性</td>
     <td>生產線別</td>
     <td>單位標準材料成本</td>
     <td>單位標準人工成本</td>
     <td>單位標準製造費用</td>	
     <td>單位標準加工費用</td>
     <td>本階人工</td>
     <td>本階製費</td>
     <td>本階加工	單位成本</td>
     <td>單位成本</td>
     <td>單位成本-材料</td>
     <td>單位成本-人工</td>
     <td>單位成本-製費</td>
     <td>單位成本-加工</td>

    </tr>
          
<cfoutput>
  <cfloop query="INVMB_MD">
  <cfset level=".0">
  <tr >
     <td>#level#</td>
     <td>#MB001#</td>
     <td>#MB002#</td>
     <td>#MB003#</td>
     <td>#MB025#</td>
     <td>#MB068#</td>
     <td align="right">#numberformat(MB057,"999999.999")#</td>
     <td align="right">#numberformat(MB058,"999999.999")#</td>
     <td align="right">#numberformat(MB059,"999999.999")#</td>	
     <td align="right">#numberformat(MB060,"999999.999")#</td>
     <td align="right">#numberformat(MB061,"999999.999")#</td>
     <td align="right">#numberformat(MB062,"999999.999")#</td>
     <td align="right">#numberformat(MB063,"999999.999")#</td>
     <td align="right">#numberformat(LB010,"999999.999")#</td>
     <td align="right">#numberformat(LB011,"999999.999")#</td>
     <td align="right">#numberformat(LB012,"999999.999")#</td>
     <td align="right">#numberformat(LB013,"999999.999")#</td>
     <td align="right">#numberformat(LB014,"999999.999")#</td>
  </tr>  
  </cfloop>
  
  <cfloop query="INVMB">
        
  <cfset bgcolor ="99CC99">
  <cfset level=".1">
  <cfinclude template="bom_query2.cfm">
          
	   <!---第二層--->
       <cfloop query="BOMMD">
       
       <cfset bgcolor ="CCCCFF">
       <cfset level=".2">
       <cfinclude template="bom_query2.cfm">
							
			<!---第三層--->
            <cfloop query="BOMMD">
            
            <cfset bgcolor ="99CCFF">
            <cfset level=".3">
            <cfinclude template="bom_query2.cfm">
									
				<!---第四層--->
                <cfloop query="BOMMD">
                
                <cfset bgcolor ="FFFFCC">
                <cfset level=".4">
                <cfinclude template="bom_query2.cfm">

					<!---第五層--->
                    <cfloop query="BOMMD">
                    
                    <cfset bgcolor ="FFFFCC">
                    <cfset level=".5">
                    <cfinclude template="bom_query2.cfm">

						  <!---第六層--->
                          <cfloop query="BOMMD">
                          
                          <cfset bgcolor ="FFFFCC">
                          <cfset level=".6">
                          <cfinclude template="bom_query2.cfm">
									   
                          </cfloop>
					 </cfloop>
				  </cfloop>
               </cfloop>
		  </cfloop>
    </cfloop>
 </cfoutput>	
   
</table>
	  
</cfif>


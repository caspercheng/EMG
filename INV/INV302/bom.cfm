<!---105.6.8 新增未來異動量欄位--->
<!---105.6.8 BOM展階查詢獨立檔案，再做include--->

<cfinclude template="/EAGLE/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "INV301" >
<cfset program_name = "BOM多階庫存狀況查詢作業" >
<cfset program_type = "Q" >

<!---檢查是否有權限--->
<cfinclude template="/EAGLE/permission.cfm">

<cfif  NOT IsDefined("FORM.MB001")> <cfset #FORM.MB001#="">	</cfif>
<cfif  NOT IsDefined("FORM.submit")> <cfset #FORM.submit#="">	</cfif>

<title>BOM多階庫存狀況查詢作業</title>

<h4><center>BOM多階庫存狀況查詢作業</center></h4>

<!---資料查詢介面--->
<cfform action="BOM.cfm">
	<table align="center" bgcolor="9999CC">
	 <tr>
	  <td>品號：</td> <td><cfinput type="Text" name="MB001" size="30" maxlength="30" ></td>
	  <td><input type="submit" name="submit" value="查詢"></td>
     </tr>
	</table>
</cfform>


<cfif #FORM.submit# EQ "查詢" AND (#FORM.MB001# NEQ "" OR (#FORM.MG001# NEQ "" AND #FORM.MG003# NEQ ""))>

<!---查詢品號資料--->
	<cfquery name="INVMB_MD" datasource="EAGLE">
	   SELECT DISTINCT MB001,MB002,MB003,MB004,MC004
	   FROM INVMB
	   LEFT JOIN BOMMC ON MC001=MB001
	   WHERE  0 = 0
       <cfif FORM.MB001 IS NOT ""> AND  MB001 = '#FORM.MB001#' </cfif>
	</cfquery>
<cfoutput query="INVMB_MD"><cfset MB001=#MB001#>	</cfoutput>
<cfset sn="0010">

<!---查詢BOM表資料--->

<cfquery datasource="EAGLE" name="INVMB">
    SELECT MD001,MD003,MB002,MD006,MB003,MB064,MB013,MB032,MB050,MB057,MB060,MD007,MB025,MB017,INVMC_MC007
    ,(MB057*MD006/MD007) AS MD087,MB068,
    CASE WHEN PUR_TD008 IS NULL THEN 0 ELSE PUR_TD008 END AS PUR_TD008,
    CASE WHEN COP_TD008 IS NULL THEN 0 ELSE COP_TD008 END AS COP_TD008,
    CASE WHEN MOC_TA015 IS NULL THEN 0 ELSE MOC_TA015 END AS MOC_TA015,
    CASE WHEN MOC_TB004 IS NULL THEN 0 ELSE MOC_TB004 END AS MOC_TB004,
    CASE WHEN LRP_TC006 IS NULL THEN 0 ELSE LRP_TC006 END AS LRP_TC006,
    CASE WHEN LRP_TA006 IS NULL THEN 0 ELSE LRP_TA006 END AS LRP_TA006,
    CASE WHEN LRP_TB007 IS NULL THEN 0 ELSE LRP_TB007 END AS LRP_TB007,
    CASE WHEN PUR_TB009 IS NULL THEN 0 ELSE PUR_TB009 END AS PUR_TB009,
    CASE WHEN PUR_TH007 IS NULL THEN 0 ELSE PUR_TH007 END AS PUR_TH007,
    CASE WHEN MOC_TI007 IS NULL THEN 0 ELSE MOC_TI007 END AS MOC_TI007
        
    FROM BOMMD
    
    LEFT JOIN INVMB ON MB001 = MD003
    LEFT JOIN (SELECT MC001,SUM(MC007) AS INVMC_MC007 FROM INVMC WHERE MC002 IN ('D02','E02') GROUP BY MC001)AS INVMC ON MB001=MC001 
    LEFT JOIN (SELECT TD004,SUM(TD008-TD015) AS PUR_TD008 FROM PURTD WHERE TD016='N' AND TD018<>'V' GROUP BY TD004) AS PURTD ON PURTD.TD004=MD003
    LEFT JOIN (SELECT TD004,SUM(TD008+TD024-TD009-TD025) AS COP_TD008 FROM COPTD WHERE TD016='N' AND TD021='Y' GROUP BY TD004) AS COPTD ON COPTD.TD004=MD003
    LEFT JOIN (SELECT TA006,SUM(TA015-TA017) AS MOC_TA015 FROM MOCTA WHERE TA011 IN ('1','2','3') AND TA013='Y' GROUP BY TA006) AS MOCTA ON MOCTA.TA006=MD003
    LEFT JOIN (SELECT TB003,SUM(TB004-TB005) AS MOC_TB004 FROM MOCTB JOIN MOCTA ON TA001=TB001 AND TA002=TB002 WHERE TA011 IN ('1','2','3') AND TA013='Y' GROUP BY TB003) AS MOCTB ON MOCTB.TB003=MD003
    LEFT JOIN (SELECT TC002,SUM(TC006) AS LRP_TC006 FROM LRPTC	WHERE 1=1 GROUP BY TC002) AS LRPTC ON LRPTC.TC002=MD003
    LEFT JOIN (SELECT TA002,SUM(TA006) AS LRP_TA006 FROM LRPTA	WHERE 1=1 GROUP BY TA002) AS LRPTA ON LRPTA.TA002=MD003
    LEFT JOIN (SELECT TB002,SUM(TB007) AS LRP_TB007 FROM LRPTB	WHERE 1=1 GROUP BY TB002) AS LRPTB ON LRPTB.TB002=MD003
    LEFT JOIN (SELECT TB004,SUM(TB009) AS PUR_TB009 FROM PURTB WHERE 1=1 AND TB021='N' AND TB025='Y' AND TB039='N' GROUP BY TB004) AS PURTB ON PURTB.TB004=MD003
    LEFT JOIN (SELECT TH004,SUM(TH007) AS PUR_TH007 FROM PURTH WHERE 1=1 AND TH030='N' GROUP BY TH004) AS PURTH ON PURTH.TH004=MD003
    LEFT JOIN (SELECT TI004,SUM(TI007) AS MOC_TI007 FROM MOCTI WHERE 1=1 AND TI037='N' GROUP BY TI004) AS MOCTI ON MOCTI.TI004=MD003   
    
    WHERE 0=0 AND MD001 = '#MB001#'  AND MD017 <> '4' AND MD012=''
</cfquery>
        
<!---列出最上層品號、品名，並區分是由類別選單查詢品號或用查詢功能來查詢--->
<cfoutput query="INVMB_MD">主件品號：#MB001#<BR />品名：#MB002#<BR />規格：#MB003#<BR />單位：#MB004#<BR />標準批量：#MC004#</cfoutput>

 <!---第一層--->
<table border="1">
    <tr bgcolor="CCCCCC">
     <td>低階碼</td>
     <td>品號</td>
     <td>品名</td>
     <td>規格</td>
     <td>屬性</td>
     <td>組成用量 </td>
     <td>底數</td>
     <td>庫存 </td>
     <td>總需求</td>
     <td>預計進</td>
     <td>預計銷</td>
     <td>預計生</td>
     <td>預計領</td>
     <td>已進待驗</td>
     <td>託工待驗</td>
    </tr>
          
<cfoutput>
 
  <cfloop query="INVMB">
      
  <cfset bgcolor ="99CC99">
  <cfset level=".1">
  <cfinclude template="bom_query.cfm">
          
	   <!---第二層--->
       <cfloop query="BOMMD">
       
       <cfset bgcolor ="CCCCFF">
       <cfset level=".2">
       <cfinclude template="bom_query.cfm">
							
			<!---第三層--->
            <cfloop query="BOMMD">
            
            <cfset bgcolor ="99CCFF">
            <cfset level=".3">
            <cfinclude template="bom_query.cfm">
									
				<!---第四層--->
                <cfloop query="BOMMD">
                
                <cfset bgcolor ="FFFFCC">
                <cfset level=".4">
                <cfinclude template="bom_query.cfm">

					<!---第五層--->
                    <cfloop query="BOMMD">
                    
                    <cfset bgcolor ="FFFFCC">
                    <cfset level=".5">
                    <cfinclude template="bom_query.cfm">

						  <!---第六層--->
                          <cfloop query="BOMMD">
                          
                          <cfset bgcolor ="FFFFCC">
                          <cfset level=".6">
                          <cfinclude template="bom_query.cfm">
									   
                          </cfloop>
					 </cfloop>
				  </cfloop>
               </cfloop>
		  </cfloop>
    </cfloop>
 </cfoutput>	
   
</table>
	  
</cfif>


<style>
  table {border-collapse: collapse;}
  tr:hover{background:#FFCC99;}
</style>

<!---查詢BOM表資料--->
<h4><center>製令材料庫存狀況表</center></h4>

<cfquery datasource="EAGLE" name="INVMB">
 SELECT MOCTB1.TB003  as TB004,MB002,MB003,MB064,MB013,MB032,MB050,MB057,MB060,MB025,MB017,MB068,INVMC_MC007,TB005,
    CASE WHEN PUR_TD008 IS NULL THEN 0 ELSE PUR_TD008 END AS PUR_TD008,
    CASE WHEN COP_TD008 IS NULL THEN 0 ELSE COP_TD008 END AS COP_TD008,
    CASE WHEN MOC_TA015 IS NULL THEN 0 ELSE MOC_TA015 END AS MOC_TA015,
    CASE WHEN MOC_TB004 IS NULL THEN 0 ELSE MOC_TB004 END AS MOC_TB004,
    CASE WHEN LRP_TC006 IS NULL THEN 0 ELSE LRP_TC006 END AS LRP_TC006,
    CASE WHEN LRP_TA006 IS NULL THEN 0 ELSE LRP_TA006 END AS LRP_TA006,
    CASE WHEN LRP_TB007 IS NULL THEN 0 ELSE LRP_TB007 END AS LRP_TB007,
    CASE WHEN PUR_TB009 IS NULL THEN 0 ELSE PUR_TB009 END AS PUR_TB009,
    CASE WHEN PUR_TH007 IS NULL THEN 0 ELSE PUR_TH007 END AS PUR_TH007,
    CASE WHEN MOC_TI007 IS NULL THEN 0 ELSE MOC_TI007 END AS MOC_TI007,
    MOCTB1.TB004 AS TB009,MOCTA1.TA006 AS TA006
        
    FROM MOCTB AS MOCTB1
    JOIN MOCTA  AS MOCTA1 ON MOCTA1.TA001=MOCTB1.TB001 AND MOCTA1.TA002=MOCTB1.TB002
    
    LEFT JOIN INVMB ON MB001 = TB003
    LEFT JOIN (SELECT MC001,SUM(MC007) AS INVMC_MC007 FROM INVMC WHERE MC002 IN ('D02','E02') GROUP BY MC001) AS INVMC ON MB001=MC001 
    LEFT JOIN
     (SELECT TD004,SUM(TD008-TD015) AS PUR_TD008
      FROM PURTD 
      LEFT JOIN PURTH ON TH011=TD001 AND TH012=TD002 AND TH013=TD003 AND TH030='N'
      WHERE TD016='N' AND TD018<>'V'  AND TH001 IS NULL
      GROUP BY TD004) 
     AS PURTD ON PURTD.TD004=MOCTB1.TB003
    LEFT JOIN (SELECT TD004,SUM(TD008+TD024-TD009-TD025) AS COP_TD008 FROM COPTD WHERE TD016='N' AND TD021='Y' GROUP BY TD004) AS COPTD ON COPTD.TD004=MOCTB1.TB003
    LEFT JOIN (SELECT TA006,SUM(TA015-TA017) AS MOC_TA015 FROM MOCTA WHERE TA011 IN ('1','2','3') AND TA013='Y' GROUP BY TA006) AS MOCTA ON MOCTA.TA006=MOCTB1.TB003
    LEFT JOIN (SELECT TB003,SUM(TB004-TB005) AS MOC_TB004 FROM MOCTB JOIN MOCTA ON TA001=TB001 AND TA002=TB002 WHERE TA011 IN ('1','2','3') AND TA013='Y' GROUP BY TB003) AS MOCTB ON MOCTB.TB003=MOCTB1.TB003
    LEFT JOIN (SELECT TC002,SUM(TC006) AS LRP_TC006 FROM LRPTC	WHERE 1=1 GROUP BY TC002) AS LRPTC ON LRPTC.TC002=MOCTB1.TB003
    LEFT JOIN (SELECT TA002,SUM(TA006) AS LRP_TA006 FROM LRPTA	WHERE 1=1 GROUP BY TA002) AS LRPTA ON LRPTA.TA002=MOCTB1.TB003
    LEFT JOIN (SELECT TB002,SUM(TB007) AS LRP_TB007 FROM LRPTB	WHERE 1=1 GROUP BY TB002) AS LRPTB ON LRPTB.TB002=MOCTB1.TB003
    LEFT JOIN (SELECT TB004,SUM(TB009) AS PUR_TB009 FROM PURTB WHERE 1=1 AND TB021='N' AND TB025='Y' AND TB039='N' GROUP BY TB004) AS PURTB2 ON PURTB2.TB004=MOCTB1.TB003
    LEFT JOIN (SELECT TH004,SUM(TH007) AS PUR_TH007 FROM PURTH WHERE 1=1 AND TH030='N' GROUP BY TH004) AS PURTH ON PURTH.TH004=MOCTB1.TB003
    LEFT JOIN (SELECT TI004,SUM(TI007) AS MOC_TI007 FROM MOCTI WHERE 1=1 AND TI037='N' GROUP BY TI004) AS MOCTI ON MOCTI.TI004=MOCTB1.TB003 
    
    
    
    WHERE 0=0 AND MOCTB1.TB001 + MOCTB1.TB002  IN (#PreserveSingleQuotes(FORM.check1)#)
    
    ORDER BY MOCTA1.TA006
</cfquery>
        
<table border="1">
    <tr bgcolor="CCCCCC">
     <td>產品品號</td>
     <td>品號</td>
     <td>品名</td>
     <td>規格</td>
     <td>屬性</td>
     <td>需領數量 </td>
     <td>已領數量 </td>
     <td>庫存 </td>
     <td>總需求</td>
     <td><cftooltip tooltip="已採購未進貨數量">預計進</cftooltip></td>
     <td><cftooltip tooltip="訂單未銷貨數量">預計銷</cftooltip></td>
     <td><cftooltip tooltip="已開製令未生產入庫數量">預計生</cftooltip></td>
     <td><cftooltip tooltip="已開製令未領料數量">預計領</cftooltip></td>
     <td><cftooltip tooltip="已請購未採購數量">已請未採</cftooltip></td>
     <td><cftooltip tooltip="已採購進貨未驗收數量">已進待驗</cftooltip></td>
     <td><cftooltip tooltip="已加工進貨未驗收數量">託工待驗</cftooltip></td>
    </tr>
          
<cfoutput>
 
  <cfloop query="INVMB">

  <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
      
  <tr bgcolor="#bgcolor#">
   <td>#TA006#</td>
   <td>#TB004#</td>
   <td>#MB002#</td>
   <td>#MB003#</td>
   <td>#MB025#</td>
   <td align="right">#NUMBERFORMAT(TB009,"9,999,999")#</td>
   <td align="right">#NUMBERFORMAT(TB005,"9,999,999")#</td>
   <td align="right">#NUMBERFORMAT(INVMC_MC007,"9,999,999")#</td>
   <td align="right">#NUMBERFORMAT(COP_TD008+MOC_TB004-PUR_TD008-MOC_TA015-PUR_TB009-PUR_TH007,"9,999,999")#</td>
   <td align="right"><cfif PUR_TD008 gt 0><a href="PURTD.cfm?MD003=#TB004#" target="_blank">#NUMBERFORMAT(PUR_TD008,"9,999,999")#</a><cfelse>0</cfif></td>
   <td align="right"><cfif COP_TD008 gt 0><a href="COPTD.cfm?MD003=#TB004#" target="_blank">#NUMBERFORMAT(COP_TD008,"9,999,999")#</a><cfelse>0</cfif></td>
   <td align="right"><cfif MOC_TA015 gt 0><a href="MOCTA.cfm?MD003=#TB004#" target="_blank">#NUMBERFORMAT(MOC_TA015,"9,999,999")#</a><cfelse>0</cfif></td>
   <td align="right"><cfif MOC_TB004 gt 0><a href="MOCTB.cfm?MD003=#TB004#" target="_blank">#NUMBERFORMAT(MOC_TB004,"9,999,999")#</a><cfelse>0</cfif></td>
   <td align="right"><cfif PUR_TB009 gt 0>#NUMBERFORMAT(PUR_TB009,"9,999,999")#<cfelse>0</cfif></td>
   <td align="right"><cfif PUR_TH007 gt 0>#NUMBERFORMAT(PUR_TH007,"9,999,999")#<cfelse>0</cfif></td>
   <td align="right"><cfif MOC_TI007 gt 0>#NUMBERFORMAT(MOC_TI007,"999,999")#<cfelse>0</cfif></td>
  </tr>

  </cfloop>
 </cfoutput>	
   

</table>
	  


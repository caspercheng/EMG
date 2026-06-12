<!---105.7.21 可查詢『上一階單階物料需求』，條件為倉管別P206系列、P210、P220、P403系列，其餘類別暫不列入。--->

<cfinclude template="menu.cfm">

<cfif  NOT IsDefined("FORM.MB001")> <cfset #FORM.MB001#="">	</cfif>
<cfif  NOT IsDefined("FORM.submit")> <cfset #FORM.submit#="">	</cfif>

<title>BOM上階庫存狀況查詢作業</title>

<h4><center>BOM上階庫存狀況查詢作業</center></h4>

<!---資料查詢介面--->
<cfform action="BOM_UP.cfm">
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
    SELECT MD001,MD003,MB002,MD006,MB003,MB064,MB013,MB032,MB050,MB057,MB060,MD007,MB025,MB017,MC007
    ,(MB057*MD006/MD007) AS MD087,MB068,
    CASE WHEN PUR_TD008 IS NULL THEN 0 ELSE PUR_TD008 END AS PUR_TD008,
    CASE WHEN COP_TD008 IS NULL THEN 0 ELSE COP_TD008 END AS COP_TD008,
    CASE WHEN MOC_TA015 IS NULL THEN 0 ELSE MOC_TA015 END AS MOC_TA015,
    CASE WHEN MOC_TB004 IS NULL THEN 0 ELSE MOC_TB004 END AS MOC_TB004,
    CASE WHEN LRP_TC006 IS NULL THEN 0 ELSE LRP_TC006 END AS LRP_TC006,
    CASE WHEN LRP_TA006 IS NULL THEN 0 ELSE LRP_TA006 END AS LRP_TA006,
    CASE WHEN LRP_TB007 IS NULL THEN 0 ELSE LRP_TB007 END AS LRP_TB007,
    CASE WHEN PUR_TB009 IS NULL THEN 0 ELSE PUR_TB009 END AS PUR_TB009,
    CASE WHEN PUR_TH007 IS NULL THEN 0 ELSE PUR_TH007 END AS PUR_TH007
    
    FROM BOMMD
    JOIN INVMB ON MB001=MD001
    JOIN INVMC ON MB001=MC001 AND MC002='1B'
    LEFT JOIN (SELECT TD004,SUM(TD008-TD015) AS PUR_TD008 FROM PURTD WHERE TD016='N' AND TD018<>'V' GROUP BY TD004) AS PURTD ON PURTD.TD004=MD001
    LEFT JOIN (SELECT TD004,SUM(TD008+TD024-TD009-TD025) AS COP_TD008 FROM COPTD WHERE TD016='N' AND TD021='Y' GROUP BY TD004) AS COPTD ON COPTD.TD004=MD001
    LEFT JOIN (SELECT TA006,SUM(TA015-TA017) AS MOC_TA015 FROM MOCTA WHERE TA011 IN ('1','2','3') AND TA013='Y' GROUP BY TA006) AS MOCTA ON MOCTA.TA006=MD001
    LEFT JOIN (SELECT TB003,SUM(TB004-TB005) AS MOC_TB004 FROM MOCTB JOIN MOCTA ON TA001=TB001 AND TA002=TB002 WHERE TA011 IN ('1','2','3') AND TA013='Y' GROUP BY TB003) AS MOCTB ON MOCTB.TB003=MD001
    LEFT JOIN (SELECT TC002,SUM(TC006) AS LRP_TC006 FROM LRPTC	WHERE 1=1 GROUP BY TC002) AS LRPTC ON LRPTC.TC002=MD001
    LEFT JOIN (SELECT TA002,SUM(TA006) AS LRP_TA006 FROM LRPTA	WHERE 1=1 GROUP BY TA002) AS LRPTA ON LRPTA.TA002=MD001
    LEFT JOIN (SELECT TB002,SUM(TB007) AS LRP_TB007 FROM LRPTB	WHERE 1=1 GROUP BY TB002) AS LRPTB ON LRPTB.TB002=MD001
    LEFT JOIN (SELECT TB004,SUM(TB009) AS PUR_TB009 FROM PURTB WHERE 1=1 AND TB021='N' AND TB025='Y' AND TB039='N' GROUP BY TB004) AS PURTB ON PURTB.TB004=MD001
    LEFT JOIN (SELECT TH004,SUM(TH007) AS PUR_TH007 FROM PURTH WHERE 1=1 AND TH030='N' GROUP BY TH004) AS PURTH ON PURTH.TH004=MD001
    WHERE (MB005 LIKE 'P206%' OR MB005 LIKE 'P210%' OR MB005 LIKE 'P220%' OR MB005 LIKE 'P403%') AND MD003='#MB001#'
    AND (MOC_TA015 <> 0 OR MOC_TB004 <> 0 OR PUR_TD008 <> 0 OR COP_TD008 <> 0)
</cfquery>
 
 <cfquery datasource="EAGLE" name="INVMB2">
    SELECT MB001,MB002,MB003,MB064,MB013,MB032,MB050,MB057,MB060,MB025,MB017,MC007
    ,1 AS MD087,MB068,
    CASE WHEN PUR_TD008 IS NULL THEN 0 ELSE PUR_TD008 END AS PUR_TD008,
    CASE WHEN COP_TD008 IS NULL THEN 0 ELSE COP_TD008 END AS COP_TD008,
    CASE WHEN MOC_TA015 IS NULL THEN 0 ELSE MOC_TA015 END AS MOC_TA015,
    CASE WHEN MOC_TB004 IS NULL THEN 0 ELSE MOC_TB004 END AS MOC_TB004,
    CASE WHEN LRP_TC006 IS NULL THEN 0 ELSE LRP_TC006 END AS LRP_TC006,
    CASE WHEN LRP_TA006 IS NULL THEN 0 ELSE LRP_TA006 END AS LRP_TA006,
    CASE WHEN LRP_TB007 IS NULL THEN 0 ELSE LRP_TB007 END AS LRP_TB007,
    CASE WHEN PUR_TB009 IS NULL THEN 0 ELSE PUR_TB009 END AS PUR_TB009,
    CASE WHEN PUR_TH007 IS NULL THEN 0 ELSE PUR_TH007 END AS PUR_TH007
    
    FROM INVMB
    JOIN INVMC ON MB001=MC001 AND MC002='1B'
    LEFT JOIN (SELECT TD004,SUM(TD008-TD015) AS PUR_TD008 FROM PURTD WHERE TD016='N' AND TD018<>'V' GROUP BY TD004) AS PURTD ON PURTD.TD004=MB001
    LEFT JOIN (SELECT TD004,SUM(TD008+TD024-TD009-TD025) AS COP_TD008 FROM COPTD WHERE TD016='N' AND TD021='Y' GROUP BY TD004) AS COPTD ON COPTD.TD004=MB001
    LEFT JOIN (SELECT TA006,SUM(TA015-TA017) AS MOC_TA015 FROM MOCTA WHERE TA011 IN ('1','2','3') AND TA013='Y' GROUP BY TA006) AS MOCTA ON MOCTA.TA006=MB001
    LEFT JOIN (SELECT TB003,SUM(TB004-TB005) AS MOC_TB004 FROM MOCTB JOIN MOCTA ON TA001=TB001 AND TA002=TB002 WHERE TA011 IN ('1','2','3') AND TA013='Y' GROUP BY TB003) AS MOCTB ON MOCTB.TB003=MB001
    LEFT JOIN (SELECT TC002,SUM(TC006) AS LRP_TC006 FROM LRPTC	WHERE 1=1 GROUP BY TC002) AS LRPTC ON LRPTC.TC002=MB001
    LEFT JOIN (SELECT TA002,SUM(TA006) AS LRP_TA006 FROM LRPTA	WHERE 1=1 GROUP BY TA002) AS LRPTA ON LRPTA.TA002=MB001
    LEFT JOIN (SELECT TB002,SUM(TB007) AS LRP_TB007 FROM LRPTB	WHERE 1=1 GROUP BY TB002) AS LRPTB ON LRPTB.TB002=MB001
    LEFT JOIN (SELECT TB004,SUM(TB009) AS PUR_TB009 FROM PURTB WHERE 1=1 AND TB021='N' AND TB025='Y' AND TB039='N' GROUP BY TB004) AS PURTB ON PURTB.TB004=MB001
    LEFT JOIN (SELECT TH004,SUM(TH007) AS PUR_TH007 FROM PURTH WHERE 1=1 AND TH030='N' GROUP BY TH004) AS PURTH ON PURTH.TH004=MB001
    WHERE MB001='#MB001#'
</cfquery>
       
<!---列出最上層品號、品名，並區分是由類別選單查詢品號或用查詢功能來查詢--->
<cfoutput query="INVMB_MD">元件品號：#MB001#<BR />品名：#MB002#<BR />規格：#MB003#<BR />單位：#MB004#<BR />標準批量：#MC004#</cfoutput>

 <!---第一層--->
<table>
    <TR bgcolor="666666" style="color:FFF">
     <td>品號</td>
     <td>品名<BR />規格</td>
     <td>屬性</td>
     <td>組成用量 </td>
     <td>底數 </td>
     <td>主要庫別</td>
     <td>1B庫存 </td>
     <td>總需求 </td>
     <td>差異數 </td>
     <td>預計進</td>
     <td>預計銷</td>
     <td>預計生</td>
     <td>預計領</td>
     <td>計劃採</td>
     <td>計劃生</td>
     <td>計劃領</td>
     <td>已請未採</td>
     <td>已進待驗</td>
    </tr>
          
<cfoutput>

  <cfloop query="INVMB2">
      
  <TR bgcolor="FFFFCC">
   <td>#MB001#</td>
   <td>#MB002#<BR />#MB003#</td>
   <td>#MB025#</td>
   <td align="right">1</td>
   <td align="right">1</td>
   <td>#MB017#</td>
   <td align="right">#NUMBERFORMAT(MC007,"999999.99")#</td>
   <td align="right">#NUMBERFORMAT(COP_TD008+MOC_TB004,"99999999")#</td>
   <td align="right">#NUMBERFORMAT(MC007-(COP_TD008+MOC_TB004),"99999999")#</td>
   <td align="right"><cfif PUR_TD008 gt 0><a href="PURTD.cfm?MD003=#MB001#" target="_blank">#NUMBERFORMAT(PUR_TD008,"999999.99")#</a><cfelse>0</cfif></td>
   <td align="right"><cfif COP_TD008 gt 0><a href="COPTD.cfm?MD003=#MB001#" target="_blank">#NUMBERFORMAT(COP_TD008,"999999.99")#</a><cfelse>0</cfif></td>
   <td align="right"><cfif MOC_TA015 gt 0><a href="MOCTA.cfm?MD003=#MB001#" target="_blank">#NUMBERFORMAT(MOC_TA015,"999999.99")#</a><cfelse>0</cfif></td>
   <td align="right"><cfif MOC_TB004 gt 0><a href="MOCTB.cfm?MD003=#MB001#" target="_blank">#NUMBERFORMAT(MOC_TB004,"999999.99")#</a><cfelse>0</cfif></td>
   <td align="right"><cfif LRP_TC006 gt 0>#NUMBERFORMAT(LRP_TC006,"999999.99")#<cfelse>0</cfif></td>
   <td align="right"><cfif LRP_TA006 gt 0>#NUMBERFORMAT(LRP_TA006,"999999.99")#<cfelse>0</cfif></td>
   <td align="right"><cfif LRP_TB007 gt 0>#NUMBERFORMAT(LRP_TB007,"999999.99")#<cfelse>0</cfif></td>
   <td align="right"><cfif PUR_TB009 gt 0>#NUMBERFORMAT(PUR_TB009,"999999.99")#<cfelse>0</cfif></td>
   <td align="right"><cfif PUR_TH007 gt 0>#NUMBERFORMAT(PUR_TH007,"999999.99")#<cfelse>0</cfif></td>
  </tr>
  
  </cfloop>
   
  <cfloop query="INVMB">
      
  <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
  <TR bgcolor="#bgcolor#">
   <td>#MD001#</td>
   <td>#MB002#<BR />#MB003#</td>
   <td>#MB025#</td>
   <td align="right">#MD006# </td>
   <td align="right">#MD007# </td>
   <td>#MB017#</td>
   <td align="right">#NUMBERFORMAT(MC007,"999999.99")#</td>
   <td align="right">#NUMBERFORMAT(COP_TD008+MOC_TB004,"99999999")#</td>
   <td align="right">#NUMBERFORMAT(MC007-(COP_TD008+MOC_TB004),"99999999")#</td>
   <td align="right"><cfif PUR_TD008 gt 0><a href="PURTD.cfm?MD003=#MD001#" target="_blank">#NUMBERFORMAT(PUR_TD008,"999999.99")#</a><cfelse>0</cfif></td>
   <td align="right"><cfif COP_TD008 gt 0><a href="COPTD.cfm?MD003=#MD001#" target="_blank">#NUMBERFORMAT(COP_TD008,"999999.99")#</a><cfelse>0</cfif></td>
   <td align="right"><cfif MOC_TA015 gt 0><a href="MOCTA.cfm?MD003=#MD001#" target="_blank">#NUMBERFORMAT(MOC_TA015,"999999.99")#</a><cfelse>0</cfif></td>
   <td align="right"><cfif MOC_TB004 gt 0><a href="MOCTB.cfm?MD003=#MD001#" target="_blank">#NUMBERFORMAT(MOC_TB004,"999999.99")#</a><cfelse>0</cfif></td>
   <td align="right"><cfif LRP_TC006 gt 0>#NUMBERFORMAT(LRP_TC006,"999999.99")#<cfelse>0</cfif></td>
   <td align="right"><cfif LRP_TA006 gt 0>#NUMBERFORMAT(LRP_TA006,"999999.99")#<cfelse>0</cfif></td>
   <td align="right"><cfif LRP_TB007 gt 0>#NUMBERFORMAT(LRP_TB007,"999999.99")#<cfelse>0</cfif></td>
   <td align="right"><cfif PUR_TB009 gt 0>#NUMBERFORMAT(PUR_TB009,"999999.99")#<cfelse>0</cfif></td>
   <td align="right"><cfif PUR_TH007 gt 0>#NUMBERFORMAT(PUR_TH007,"999999.99")#<cfelse>0</cfif></td>
  </tr>
  
  </cfloop>
</cfoutput>	
   
</table>
	  
</cfif>

只展上階倉管別P206系列、P210、P220、P403系列資料。

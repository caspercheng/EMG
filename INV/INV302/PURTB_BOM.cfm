<cfinclude template="menu.cfm">

<cfif  NOT IsDefined("FORM.TA001")> <cfset #FORM.TA001#="">	</cfif>
<cfif  NOT IsDefined("FORM.submit")> <cfset #FORM.submit#="">	</cfif>

<title>請購庫存狀況查詢作業</title>

<h4><center>請購庫存狀況查詢作業</center></h4>

<!---資料查詢介面--->
<cfform action="PURTB_BOM.cfm">
	<table align="center" bgcolor="9999CC">
	 <tr>
	  <td>請購單別-單號：</td> <td><cfinput type="Text" name="TA001" size="30" maxlength="30" required="yes" ></td>
	  <td><input type="submit" name="submit" value="查詢"></td>
     </tr>
	</table>
</cfform>


<cfif #FORM.submit# EQ "查詢">

<!---查詢BOM表資料--->

<cfquery datasource="EAGLE" name="INVMB">
    SELECT PURTB1.TB004  as TB004,MB002,MB003,MB064,MB013,MB032,MB050,MB057,MB060,MB025,MB017,MB068,MC007,
    CASE WHEN PUR_TD008 IS NULL THEN 0 ELSE PUR_TD008 END AS PUR_TD008,
    CASE WHEN COP_TD008 IS NULL THEN 0 ELSE COP_TD008 END AS COP_TD008,
    CASE WHEN MOC_TA015 IS NULL THEN 0 ELSE MOC_TA015 END AS MOC_TA015,
    CASE WHEN MOC_TB004 IS NULL THEN 0 ELSE MOC_TB004 END AS MOC_TB004,
    CASE WHEN LRP_TC006 IS NULL THEN 0 ELSE LRP_TC006 END AS LRP_TC006,
    CASE WHEN LRP_TA006 IS NULL THEN 0 ELSE LRP_TA006 END AS LRP_TA006,
    CASE WHEN LRP_TB007 IS NULL THEN 0 ELSE LRP_TB007 END AS LRP_TB007,
    CASE WHEN PUR_TB009 IS NULL THEN 0 ELSE PUR_TB009 END AS PUR_TB009,
    CASE WHEN PUR_TH007 IS NULL THEN 0 ELSE PUR_TH007 END AS PUR_TH007,
    PURTB1.TB009 AS TB009
        
    FROM PURTB AS PURTB1
    
    LEFT JOIN INVMB ON MB001 = TB004
    JOIN INVMC ON MB001=MC001 AND MC002='1B'
    LEFT JOIN
     (SELECT TD004,SUM(TD008-TD015) AS PUR_TD008
      FROM PURTD 
      LEFT JOIN PURTH ON TH011=TD001 AND TH012=TD002 AND TH013=TD003 AND TH030='N'
      WHERE TD016='N' AND TD018<>'V'  AND TH001 IS NULL
      GROUP BY TD004) 
     AS PURTD ON PURTD.TD004=PURTB1.TB004
    LEFT JOIN (SELECT TD004,SUM(TD008+TD024-TD009-TD025) AS COP_TD008 FROM COPTD WHERE TD016='N' AND TD021='Y' GROUP BY TD004) AS COPTD ON COPTD.TD004=PURTB1.TB004
    LEFT JOIN (SELECT TA006,SUM(TA015-TA017) AS MOC_TA015 FROM MOCTA WHERE TA011 IN ('1','2','3') AND TA013='Y' GROUP BY TA006) AS MOCTA ON MOCTA.TA006=PURTB1.TB004
    LEFT JOIN (SELECT TB003,SUM(TB004-TB005) AS MOC_TB004 FROM MOCTB JOIN MOCTA ON TA001=TB001 AND TA002=TB002 WHERE TA011 IN ('1','2','3') AND TA013='Y' GROUP BY TB003) AS MOCTB ON MOCTB.TB003=PURTB1.TB004
    LEFT JOIN (SELECT TC002,SUM(TC006) AS LRP_TC006 FROM LRPTC	WHERE 1=1 GROUP BY TC002) AS LRPTC ON LRPTC.TC002=PURTB1.TB004
    LEFT JOIN (SELECT TA002,SUM(TA006) AS LRP_TA006 FROM LRPTA	WHERE 1=1 GROUP BY TA002) AS LRPTA ON LRPTA.TA002=PURTB1.TB004
    LEFT JOIN (SELECT TB002,SUM(TB007) AS LRP_TB007 FROM LRPTB	WHERE 1=1 GROUP BY TB002) AS LRPTB ON LRPTB.TB002=PURTB1.TB004
    LEFT JOIN (SELECT TB004,SUM(TB009) AS PUR_TB009 FROM PURTB WHERE 1=1 AND TB021='N' AND TB025='Y' AND TB039='N' GROUP BY TB004) AS PURTB2 ON PURTB2.TB004=PURTB1.TB004
    LEFT JOIN (SELECT TH004,SUM(TH007) AS PUR_TH007 FROM PURTH WHERE 1=1 AND TH030='N' GROUP BY TH004) AS PURTH ON PURTH.TH004=PURTB1.TB004
    
    WHERE 0=0 AND PURTB1.TB001='#MID(FORM.TA001,1,4)#' AND PURTB1.TB002='#MID(FORM.TA001,6,10)#'
</cfquery>
        
 <!---第一層--->
<table>
    <tr bgcolor="CCCCCC">
     <td>品號</td>
     <td>品名<br />規格</td>
     <td>請購數量 </td>
     <td>1B庫存 </td>
     <td>總需求</td>
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
 
  <cfloop query="INVMB">

  <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
      
  <tr bgcolor="#bgcolor#">
   <td>#TB004#</td>
   <td>#MB002#<br />#MB003#</td>
   <td align="right">#NUMBERFORMAT(TB009,"9,999,999")#</td>
   <td align="right">#NUMBERFORMAT(MC007,"9,999,999")#</td>
   <td align="right">#NUMBERFORMAT(COP_TD008+MOC_TB004-PUR_TD008-MOC_TA015-LRP_TC006-LRP_TA006+LRP_TB007-PUR_TB009-PUR_TH007,"9,999,999")#</td>
   <td align="right"><cfif PUR_TD008 gt 0><a href="PURTD.cfm?MD003=#TB004#" target="_blank">#NUMBERFORMAT(PUR_TD008,"9,999,999")#</a><cfelse>0</cfif></td>
   <td align="right"><cfif COP_TD008 gt 0><a href="COPTD.cfm?TMD003=#TB004#" target="_blank">#NUMBERFORMAT(COP_TD008,"9,999,999")#</a><cfelse>0</cfif></td>
   <td align="right"><cfif MOC_TA015 gt 0><a href="MOCTA.cfm?MD003=#TB004#" target="_blank">#NUMBERFORMAT(MOC_TA015,"9,999,999")#</a><cfelse>0</cfif></td>
   <td align="right"><cfif MOC_TB004 gt 0><a href="MOCTB.cfm?MD003=#TB004#" target="_blank">#NUMBERFORMAT(MOC_TB004,"9,999,999")#</a><cfelse>0</cfif></td>
   <td align="right"><cfif LRP_TC006 gt 0>#NUMBERFORMAT(LRP_TC006,"9,999,999")#<cfelse>0</cfif></td>
   <td align="right"><cfif LRP_TA006 gt 0>#NUMBERFORMAT(LRP_TA006,"9,999,999")#<cfelse>0</cfif></td>
   <td align="right"><cfif LRP_TB007 gt 0>#NUMBERFORMAT(LRP_TB007,"9,999,999")#<cfelse>0</cfif></td>
   <td align="right"><cfif PUR_TB009 gt 0>#NUMBERFORMAT(PUR_TB009,"9,999,999")#<cfelse>0</cfif></td>
   <td align="right"><cfif PUR_TH007 gt 0>#NUMBERFORMAT(PUR_TH007,"9,999,999")#<cfelse>0</cfif></td>
  </tr>

  </cfloop>
 </cfoutput>	
   
</table>
	  
</cfif>


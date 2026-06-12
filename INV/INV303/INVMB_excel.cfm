<title>材料庫存檢視表</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "INV303" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfoutput>

<cfsetting enablecfoutputonly="Yes">
<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="filename=材料庫存檢視表_#Dateformat(now(),"yyyy-mm-dd")#.xls">

<cfif NOT IsDefined("URL.d1")><cfset #URL.d1#="#DATEFORMAT(now()-366,"yyyymm")#"></cfif> 
<cfif NOT IsDefined("URL.d2")><cfset #URL.d2#="#DATEFORMAT(now()-30,"yyyymm")#"></cfif> 
<cfif NOT IsDefined("URL.MB001")><cfset #URL.MB001#=""></cfif> 
<cfif NOT IsDefined("URL.MB002")><cfset #URL.MB002#=""></cfif> 
<cfif NOT IsDefined("URL.MB003")><cfset #URL.MB003#=""></cfif> 
<cfif NOT IsDefined("URL.MB025")><cfset #URL.MB025#=""></cfif> 
<cfif NOT IsDefined("URL.MB064")><cfset #URL.MB064#=""></cfif> 


<cfset begin_mon= #mid(URL.d1,1,4)#&'-'&#mid(URL.d1,5,2)#&'-01'>
<cfset end_mon2= #mid(URL.d2,1,4)#&'-'&#mid(URL.d2,5,2)#&'-01'>
<cfset lastday=#DaysInMonth(end_mon2)#>
<cfset  end_mon= #mid(URL.d2,1,4)#&'-'&#mid(URL.d2,5,2)#&'-'&#lastday#>
<cfset mon =#DateDiff("M", begin_mon, end_mon)#>

<cfquery datasource="#SESSION.COMPANY#" name="INVMB">
    SELECT  MB001,MB002,MB003,MB036,MB037,MB039,MB064,MB065,MC004,
	ISNULL(MOC_TB004,0) AS MOC_TB004,
	ISNULL(PUR_TD008,0) AS PUR_TD008,
	ISNULL(COP_TD008,0) AS COP_TD008,
	ISNULL(PUR_TB009,0) AS PUR_TB009,
	ISNULL(MOC_TA015,0) AS MOC_TA015,
	ISNULL(PUR_TH007,0) AS PUR_TH007,
	ISNULL(COP_TH008,0) AS COP_TH008,
	ISNULL(MOC_TE005,0) AS MOC_TE005,
	PUR_TH014,
	MOC_TI018,
	MAXTC003,
	MAXTA003

    FROM INVMB
	LEFT JOIN INVMC ON MC001=MB001 AND MC002='203'
	LEFT JOIN 
	(SELECT TB003,SUM(TB004-TB005) AS MOC_TB004
	   FROM MOCTB
	   JOIN MOCTA ON TA001=TB001 AND TA002=TB002
	    WHERE TA011 IN ('1','2','3') AND TA013 ='Y' GROUP BY TB003) AS MOCTB ON MOCTB.TB003=MB001
		
	LEFT JOIN (SELECT TD004,SUM(TD008-TD015) AS PUR_TD008 FROM PURTD WHERE TD016='N' AND TD018<>'V' GROUP BY TD004) AS PURTD ON PURTD.TD004=MB001
    LEFT JOIN (SELECT TD004,SUM(TD008+TD024-TD009-TD025) AS COP_TD008 FROM COPTD WHERE TD016='N' AND TD021='Y' GROUP BY TD004) AS COPTD ON COPTD.TD004=MB001
    LEFT JOIN (SELECT TB004,SUM(TB009) AS PUR_TB009 FROM PURTB WHERE 1=1 AND TB021='N' AND TB025='Y' AND TB039='N' GROUP BY TB004) AS PURTB ON PURTB.TB004=MB001
    LEFT JOIN (SELECT TH004,SUM(TH007) AS PUR_TH007 FROM PURTH WHERE 1=1 AND TH030='N' GROUP BY TH004) AS PURTH ON PURTH.TH004=MB001
    LEFT JOIN (SELECT TA006,SUM(TA015-TA017) AS MOC_TA015 FROM MOCTA WHERE TA011 IN ('1','2','3') AND TA013='Y' GROUP BY TA006) AS MOCTA2 ON MOCTA2.TA006=MB001

    LEFT JOIN (SELECT TH004,MAX(TH014) AS PUR_TH014 FROM PURTH WHERE 1=1 AND TH030='Y' GROUP BY TH004) AS PURTH2 ON PURTH2.TH004=MB001 AND MB025='P'
	LEFT JOIN (SELECT TI004,MAX(TI018) AS MOC_TI018 FROM MOCTI WHERE 1=1 AND TI037='Y' AND TI009 <> '' GROUP BY TI004) AS MOCTI ON MOCTI.TI004=MB001 AND MB025='S'

	LEFT JOIN
	 (SELECT MAX(TC003) AS MAXTC003,TD004
	  FROM PURTD 
	  JOIN PURTC ON TC001=TD001 AND TC002=TD002
	  WHERE  TD018 ='Y' 
	  GROUP BY TD004) AS PURTD2 ON PURTD2.TD004=MB001

	LEFT JOIN
	 (SELECT MAX(TA003) AS MAXTA003,TA006
	  FROM MOCTA
	  WHERE  TA013 ='Y' 
	  GROUP BY TA006) AS MOCTA3 ON MOCTA3.TA006=MB001

    LEFT JOIN
	 (SELECT TH004,SUM(TH008-TH043) AS COP_TH008 
	  FROM COPTH 
	  JOIN COPTG ON TG001=TH001 AND TG002=TH002
	  WHERE TH020 ='Y' 
	   AND TG003 >= '#URL.d1#01'
	   AND TG003 <= '#URL.d2##lastday#'
	  GROUP BY TH004) AS COPTH ON COPTH.TH004=MB001

    LEFT JOIN
	 (SELECT TE004,SUM(TE005) AS MOC_TE005
	  FROM MOCTE 
	  JOIN MOCTC ON TC001=TE001 AND TC002=TE002
	  WHERE TE019 ='Y' 
	   AND TC003 >= '#URL.d1#01'
	   AND TC003 <= '#URL.d2##lastday#'
	  GROUP BY TE004) AS MOCTE ON MOCTE.TE004=MB001

	WHERE 1=1 
	   AND MB025 IN ('P','S')
    <cfif URL.MB001 IS NOT ""> AND  MB001 like '#URL.MB001#%' </cfif>
    <cfif URL.MB002 IS NOT ""> AND  MB002 like N'%#URL.MB002#%' </cfif>
    <cfif URL.MB003 IS NOT ""> AND  MB003 like N'%#URL.MB003#%' </cfif>
    <cfif URL.MB025 IS NOT ""> AND  MB025 = '#URL.MB025#' </cfif>
	<cfif URL.MB064 IS  "K">AND MB064 > 0</cfif>
   
	ORDER BY MB001
</cfquery>


<table border="1">

<TR >
   <TH>品號</TH>
   <TH>品名</TH>
   <TH>規格</TH>
   <TH>庫存數量</TH>
   <TH>單位成本</TH>
   <TH>庫存金額</TH>
   <TH>前置天數</TH>
   <TH>最低補量</TH>
   <TH>安全存量</TH>
   <TH>最近採購</TH>
   <TH>APS預計領</TH>
   <TH>預計進貨</TH>
   <TH>預計加工進</TH>
   <TH>已進待驗</TH>
   <TH>預計領料</TH>
   <TH>預計銷</TH>
   <TH>可用量</TH>
   <TH>月均耗用量</TH>
   <TH>銷貨量</TH>
   <TH>領料量</TH>
   <TH>可用月數</TH>
</TR>

<cfset APS_out=0>

<cfloop query="INVMB">

     <!---查詢APS建議製令的預計進貨量--->
	<cfquery datasource="APS" name="APS_MOC">
			SELECT
			 Item_Master2.part_id  AS part_id,
			  sum(Out_DD.use_qty) as use_qty
			
			FROM  Item_Master  Item_Master2 
			RIGHT OUTER JOIN Out_DD ON (Out_DD.input_part_id=Item_Master2.part_id)
			 INNER JOIN Out_MO ON (Out_MO.mfg_order_id=Out_DD.mfg_order_id)
			  
			WHERE
			  (
			   case when Out_MO.state=0 then '0.建議開立工單'
			when Out_MO.state=1 then '1.已確認工單'
			when Out_MO.state=3 then '3.已發放工單'
			when Out_MO.state=4 then '4.已發料工單'
			when Out_MO.state=5 then '5.在製中工單'
			when Out_MO.state=7 then '7.部份入庫'
			when Out_MO.state=9then '9.全部入庫結案工單'
			end  IN  ( '0.建議開立工單'  )
			  
			  )
			   and Item_Master2.part_id='#MB001#'
			  group by Item_Master2.part_id
	</cfquery>
	
	<cfloop query="APS_MOC"><cfset APS_out=#use_qty#></cfloop>
	<cfset amount = #NUMBERFORMAT(MB064-MOC_TB004+PUR_TD008-COP_TD008+MOC_TA015+PUR_TB009+PUR_TH007-APS_out,"99999999")#>
	<cfset mon_use = #NUMBERFORMAT((COP_TH008+MOC_TE005)/(mon+1),"9999999.99")#>
	
	<tr>
		<TD align="center"><a href="http://192.168.1.36:8500/EMG/INV/ref/INVMB_detail.cfm?MB001=#trim(MB001)#" target="_blank">#MB001#</a></TD>
		<TD >#MB002#</TD>
		<TD>#MB003#</TD>
		<TD align="right"><cfif MB064 gt 0>#NUMBERFORMAT(MB064,"9,999,999")#<cfelse>0</cfif></TD>
		<TD align="right"><cfif MB064 gt 0>#NUMBERFORMAT(MB065/MB064,"9,999,999.99")#<cfelse>0</cfif></TD>
		<TD align="right"><cfif MB065 gt 0>#NUMBERFORMAT(MB065,"9,999,999")#<cfelse>0</cfif></TD>
		<TD align="center">#MB036#</TD>
		<TD align="center">#NUMBERFORMAT(MB039,"9,999,999")#</TD>
		<TD align="center">#NUMBERFORMAT(MC004,"9,999,999")#</TD>
		<TD align="center">
		  <cfif #MAXTC003# gt "">#MID(MAXTC003,1,4)#-#MID(MAXTC003,5,2)#-#MID(MAXTC003,7,2)#</cfif>
		  <!---<cfif #PUR_TH014# gt "">#MID(PUR_TH014,1,4)#-#MID(PUR_TH014,5,2)#-#MID(PUR_TH014,7,2)#</cfif>--->
		  <cfif #MAXTA003# gt "">#MID(MAXTA003,1,4)#-#MID(MAXTA003,5,2)#-#MID(MAXTA003,7,2)#</cfif>
		  <!---<cfif #MOC_TI018# gt "">#MID(MOC_TI018,1,4)#-#MID(MOC_TI018,5,2)#-#MID(MOC_TI018,7,2)#</cfif>--->
		 </TD>
		<TD align="right"><cfif APS_out gt 0>#NUMBERFORMAT(APS_out,"9,999,999")#<cfelse>0</cfif></TD>
		<TD align="right"><cfif PUR_TD008 gt 0>#NUMBERFORMAT(PUR_TD008,"9,999,999")#<cfelse>0</cfif></TD>
        <TD align="right"><cfif MOC_TA015 gt 0>#NUMBERFORMAT(MOC_TA015,"9,999,999")#<cfelse>0</cfif></TD>
        <TD align="right"><cfif PUR_TH007 gt 0>#NUMBERFORMAT(PUR_TH007,"9,999,999")#<cfelse>0</cfif></TD>
		<TD align="right"><cfif MOC_TB004 gt 0>#NUMBERFORMAT(MOC_TB004,"9,999,999")#<cfelse>0</cfif></TD>
        <TD align="right"><cfif COP_TD008 gt 0>#NUMBERFORMAT(COP_TD008,"9,999,999")#<cfelse>0</cfif></TD>
	    <TD align="right">#NUMBERFORMAT(amount,"9,999,999")#</TD>
        <TD align="right"><cfif mon_use gt 0>#NUMBERFORMAT(mon_use,"9,999,999")#<cfelse>0</cfif></TD>
        <TD align="right"><cfif COP_TH008 gt 0>#NUMBERFORMAT(COP_TH008,"9,999,999")#<cfelse>0</cfif></TD>
        <TD align="right"><cfif MOC_TE005 gt 0>#NUMBERFORMAT(MOC_TE005,"9,999,999")#<cfelse>0</cfif></TD>
	    <TD align="right"><cfif mon_use gt 0>#NUMBERFORMAT(amount/mon_use,"9,999,999.99")#</cfif></TD>
	</tr>
</cfloop>

</table>


</cfoutput>


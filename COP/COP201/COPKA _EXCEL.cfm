<title>訂單出貨收款狀況表</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "COP201" >
<cfset program_name = "訂單出貨收款狀況表" >
<cfset program_type = "Q" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif  NOT IsDefined("URL.KA001")> <cfset #URL.KA001#="">	</cfif> 
<cfif  NOT IsDefined("URL.KA004")> <cfset #URL.KA004#="">	</cfif> 

<cfif URL.KA001 IS NOT ""><cfset #URL.KA001#=#URL.KA001#>	 </cfif>
<cfif URL.KA004 IS NOT ""><cfset #URL.KA004#=#URL.KA004#>	 </cfif>


<cfif NOT IsDefined("URL.KA001")><cfset #URL.KA001#="#DATEFORMAT(NOW(),"yyyymm")#"></cfif>
<cfif NOT IsDefined("URL.KA004")><cfset #URL.KA004#="#DATEFORMAT(NOW(),"yyyymm")#"></cfif>
<cfif NOT IsDefined("URL.submit")><cfset #URL.submit#=""></cfif>

<!---作業標題--->
<h4 align="center">訂單出貨收款狀況表</h4>

<cfoutput>


<cfsetting enablecfoutputonly="Yes">
<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="filename=訂單出貨收款狀況表_#dateformat(now(),"YYYY-MM-DD")#.xls">


<cfquery name="COPKA" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKA
	JOIN COPTC ON KA001=TC001 AND KA002=TC002
	JOIN COPMA ON TC004=MA001
	WHERE 1=1 
		AND KA004 LIKE '#URL.KA001#%'
		AND KA001 NOT LIKE 'A229%'
	ORDER BY KA003 ,KA002
</cfquery>

<!---撈取依幣別統計訂單金額--->
<cfquery name="COPKA_Currency" datasource="#SESSION.COMPANY#">
	SELECT TC008,SUM(KA008) SUMKA008
	FROM COPKA
	JOIN COPTC ON KA001=TC001 AND KA002=TC002
	JOIN COPMA ON TC004=MA001
	WHERE 1=1 
		AND KA004 LIKE '#URL.KA001#%'
		AND KA001 NOT LIKE 'A229%'
	GROUP BY TC008
</cfquery>

<!---撈取依公司及幣別統計訂單金額--->
<cfquery name="COPKA_COMPANY" datasource="#SESSION.COMPANY#">
	SELECT '上岳' COM,TC008,SUM(KA008) SUMKA008
	FROM COPKA
	JOIN COPTC ON KA001=TC001 AND KA002=TC002
	JOIN COPMA ON TC004=MA001
	JOIN CMSMQ ON MQ001=TC001
	WHERE 1=1 
		AND KA004 LIKE '#URL.KA001#%'
		AND MQ003 <> '27'
		AND KA001 NOT LIKE 'A229%'
	GROUP BY  TC008
	UNION
	SELECT '東莞' COM,TC008,SUM(KA008) SUMKA008
	FROM COPKA
	JOIN COPTC ON KA001=TC001 AND KA002=TC002
	JOIN COPMA ON TC004=MA001
	JOIN CMSMQ ON MQ001=TC001
	WHERE 1=1 
		AND KA004 LIKE '#URL.KA001#%'
		AND MQ003 = '27'
		AND KA001 NOT LIKE 'A229%'
	GROUP BY  TC008
</cfquery>

<!---撈取未收款BY幣別統計--->
<cfquery name="COPKA_Uncollected" datasource="#SESSION.COMPANY#">
	SELECT TC008,SUM (KA008-KA009) SUMKA89 
	FROM COPKA
	JOIN COPTC ON TC001=KA001 AND TC002=KA002
	
	WHERE 1=1
		AND KA004 LIKE '#URL.KA001#%'
		AND KA001 NOT LIKE 'A229%'
		AND (KA008-KA009)  <>0
	GROUP BY TC008
</cfquery>			
	
<cfquery name="COPKD" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKD
	WHERE 1=1 
		AND KD001 LIKE '#URL.KA001#%'
</cfquery>

<table border="1" align="center" width="100%">

	<tr>
			<td align="center" colspan="25">
			<font size="+2">
			<strong>上岳科技股份有限公司</strong></font><br /><font size="+1"><strong>訂單出貨收款狀況表</strong></font>
			<br /><font size="+1"><strong>訂單年月：#MID(URL.KA001,1,4)#-#MID(URL.KA001,5,2)#</strong></font>
			
			</td>
		</tr>
		<tr>
			<td align="right" colspan="25">製表日期：#dateformat(NOW(),"yyyy-mm-dd")#</td>
	  </tr>
	<tr style="font-family:'微軟正黑體'; font-size:14px">
		<td align="center">客戶資料</td>
		<td align="center">訂單單號</td>
		<td align="center">幣別</td>
		<td align="center">原幣金額</td>
		<td align="center">訂單金額%</td>
		<td align="center">銷貨金額</td>
		<td align="center">未出貨金額</td>
		<td align="center">原預交日</td>
		<td align="center">預計完成日</td>
		<td align="center">變更歷程</td>
		<td align="center">ETD</td>
		<td align="center">變更歷程</td>
		<td align="center">ETA</td>
		<td align="center">變更歷程</td>
		<td align="center">出貨逾期天數</td>
		<td align="center">變更日期<BR>逾期原因</td>
		<td align="center">訂金金額</td>
		<td align="center">%</td>
		<td align="center">訂金預收日期</td>
		<td align="center">訂金實收日期</td>
		<td align="center">尾款預收日期</td>
		<td align="center">變更記錄</td>
		<td align="center">尾款實收日期</td>
		<td align="center">尾款實收款</td>
		<td align="center">累計收款%</td>
	</TR>
<cfloop query="COPKA">
<cfset KA008=#KA008#>
<cfset 銷貨金額=0>
<!---撈取各異動類別的變更日期--->
<cfquery name="COPKB1" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKB
	WHERE 1=1 
		AND KB001='#KA001#'
		AND KB002='#KA002#'
		AND KB003='#KA003#'
		AND KB005='1'
	ORDER BY KB004 DESC
</cfquery>

<cfquery name="COPKB2" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKB
	WHERE 1=1 
		AND KB001='#KA001#'
		AND KB002='#KA002#'
		AND KB003='#KA003#'
		AND KB005='2'
	ORDER BY KB004 DESC
</cfquery>

<cfquery name="COPKB3" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKB
	WHERE 1=1 
		AND KB001='#KA001#'
		AND KB002='#KA002#'
		AND KB003='#KA003#'
		AND KB005='3'
	ORDER BY KB004 DESC
</cfquery>

<cfquery name="COPKB4" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKB
	WHERE 1=1 
		AND KB001='#KA001#'
		AND KB002='#KA002#'
		AND KB003='#KA003#'
		AND KB005='4'
	ORDER BY KB004 DESC
</cfquery>


<cfform action="COPKA_UPDATE_SQL.cfm?KA001=#URL.KA001#&KA004=#URL.KA004#" method="post">

<cfquery name="COPTD" datasource="#SESSION.COMPANY#">
	SELECT TD001,TD002,TD047,TC016,TC041,SUM(TD012) SUMTD012
	FROM COPTD
	JOIN COPTC ON TC001=TD001 AND TC002=TD002	
	where 1=1
		AND TD001='#KA001#'
		AND TD002='#KA002#'
		AND TD047='#KA003#'
		AND TD021='Y'
	GROUP BY TD001,TD002,TD047,TC016,TC041
</cfquery>	

<cfquery name="COPTH" datasource="#SESSION.COMPANY#">
	SELECT TH001,TH002,SUM(TH035+TH036) SUMTH3536
	FROM COPTH
	WHERE RTRIM(TH014)+RTRIM(TH015)+RTRIM(TH016) IN
	(
	SELECT RTRIM(TD001)+RTRIM(TD002)+RTRIM(TD003)
	FROM COPTD
	JOIN COPTC ON TC001=TD001 AND TC002=TD002	
	where 1=1
	AND TD001='#KA001#'
	AND TD002='#KA002#'
	AND TD047='#KA003#'
	AND TD021='Y'
	) 
	AND TH020='Y'
	GROUP BY TH001,TH002
</cfquery>

<cfinput type="hidden" name="KA001" value="#KA001#">
<cfinput type="hidden" name="KA002" value="#KA002#">
<cfinput type="hidden" name="KA003" value="#KA003#">

<tr style="font-family:'微軟正黑體'; font-size:14px">
		<td>#MA001#<br />#MA002#</td>
		<td align="center">#KA001#-#KA002#</td>
		<td align="center">#TC008#</td>
		<td align="center">#NUMBERFORMAT(KA008,"999,999.99")#</td>
		<td align="center">#numberformat(KA019*100,"999,999.99")#%</td>
		<td align="right">
		<cfset 銷貨金額_total = 0>
			
		<cfloop query="COPTH"><cfset 銷貨金額_total = #銷貨金額_total#+#SUMTH3536#></cfloop>

		<cfif #COPTH.recordcount# gt 0>
			<cfloop query="COPTH"><cfif #SUMTH3536# neq 0>#NUMBERFORMAT(SUMTH3536,"999,999.99")#<bR><cfelse>0<BR></cfif></cfloop>
		<cfelse>
		0
		</cfif>
			
			<cfquery name="KA009_UPDATE" datasource="#SESSION.COMPANY#">
				UPDATE COPKA SET KA009= #銷貨金額_total #
				FROM COPKA
				where 1=1
					AND KA001='#KA001#'
					AND KA002='#KA002#'
					AND KA003='#KA003#'
			</cfquery>

		</td>
		<td align="right">
		<cfset 訂單金額=0>
		<cfloop query="COPTD">
			<cfif #TC016# EQ "2">
				<cfset 訂單金額=#ROUND(SUMTD012* (1+TC041))#>
			<cfelse>
				<cfset 訂單金額=#SUMTD012#>
			</cfif>
			<cfset 原預交日=#TD047#>
		
			
				<cfif #訂單金額#-#銷貨金額_total# neq 0 and #訂單金額#-#銷貨金額_total# gt 10>#NUMBERFORMAT(訂單金額-銷貨金額_total,"999,999.99")#<bR></cfif>				
	
			
		</cfloop>
	
		</td>
		<td align="center">#mid(KA003,1,4)#-#mid(KA003,5,2)#-#mid(KA003,7,2)#</td>
		<td align="center">
		<cfif #KA005# NEQ "1900-01-01" AND #KA005# NEQ "">#KA005#</cfif>	
		<td align="center"><cfloop query="COPKB1">#KB006#<BR></cfloop></td>
		<td align="center">
		<cfif #KA006# NEQ "1900-01-01" AND #KA006# NEQ "">#KA006#</cfif>	
		</td>
		<td align="center"><cfloop query="COPKB2">#KB006#<BR></cfloop></td>
		<td align="center">
		<cfif #KA007# NEQ "1900-01-01" AND #KA007# NEQ "">#KA007#</cfif>	
		</td>
		<td align="center"><cfloop query="COPKB3">#KB006#<BR></cfloop></td>
		<td align="center"><cfif #KA010# GT 0>#NUMBERFORMAT(KA010,"9,999")#</cfif></td>
		<td>#KA011#<BR>
		<cfif #KA012# NEQ "1900-01-01" AND #KA012# NEQ "">#KA012#</cfif></td>
		<td align="center">#numberformat(KA013,"999,999.99")#</td>
		<td align="center"><cfif #KA008# NEQ 0>#numberformat(KA013/KA008*100,"999,999.99")#%<cfelse>0%</cfif></td>
		<td align="center">
		<cfif #KA014# NEQ "1900-01-01" AND #KA014# NEQ "">#KA014#</cfif>
		</td>
		<td align="center"><cfif #KA015# NEQ "1900-01-01" AND #KA015# NEQ "">#KA015#</cfif></td>
		<td align="center"><cfif #KA017# NEQ "1900-01-01" AND #KA017# NEQ "">#KA017#</cfif><!---<br /><cfloop query="COPKB4"><font color="0000FF">#KB006#</font><BR></cfloop>---></td>
		<td align="center"><cfloop query="COPKB4">#KB006#<BR></cfloop></td>
		<td align="center"><!---<cfif #KA018# NEQ "1900-01-01" AND #KA018# NEQ "">#KA018#</cfif>--->
			<cfquery name="COPTD3" datasource="#SESSION.COMPANY#">
			SELECT  KC006,SUM(KC005) SUMKC005
				FROM COPKC
				WHERE RTRIM(KC002)+RTRIM(KC003)+RTRIM(KC004) IN 
				(SELECT  RTRIM(TD001)+RTRIM(TD002)+RTRIM(TD003)
				FROM COPTD
				
				where 1=1
					AND TD001='#KA001#'
					AND TD002='#trim(KA002)#'
					AND TD047='#KA003#'
					AND TD021='Y')
				GROUP BY KC006
			</cfquery>
			<cfloop query="COPTD3">#MID(KC006,1,4)#-#MID(KC006,5,2)#-#MID(KC006,7,2)#<BR /></cfloop>
			<cfloop query="COPKB4"><font color="0000FF">#KB006#</font><BR>	</cfloop>	
		
		</td>
		<td align="right">
		<cfif #KA013# GT 0 AND #KA016# GT 0><!---有訂金 而且有尾款--->
			<cfif #KA016#-#KA013# gt -1 and #KA016#-#KA013# lt 1 ><!---尾款-訂金 大於 -1 小於1，表示已收齊--->
			0
			<cfelse>
				<cfif #KA016#-#KA013#-#KA008# LTe 1.5 AND #KA016#-#KA013#-#KA008# GTE -1.5>
				#numberformat(KA008,"999,999,999.99")#
				<cfelse>
				#numberformat(KA016-KA013,"999,999,999.99")#
				</cfif>
			</cfif>
		<cfelse>
			<cfquery name="COPTD2" datasource="#SESSION.COMPANY#">
			SELECT  KC006,SUM(KC005) SUMKC005
				FROM COPKC
				WHERE RTRIM(KC002)+RTRIM(KC003)+RTRIM(KC004) IN 
				(SELECT  RTRIM(TD001)+RTRIM(TD002)+RTRIM(TD003)
				FROM COPTD
				
				where 1=1
					AND TD001='#KA001#'
					AND TD002='#trim(KA002)#'
					AND TD047='#KA003#'
					AND TD021='Y')
				GROUP BY KC006
			</cfquery>	
			
			<cfif #COPTD2.RecordCount# gt 0>
				<cfloop query ="COPTD2">
					<cfif #SUMKC005# gt 1 or  #SUMKC005# lt -1  >
					
						<cfif #SUMKC005# - #KA008# LTe 2 AND #SUMKC005# - #KA008# GTE -2>
							#numberformat(KA008,"999,999,999.99")#<BR />
						<cfelse>
							#numberformat(SUMKC005,"999,999,999.99")#<BR />
						</cfif>
					<cfelse>
					0
					</cfif>
				</cfloop>
			<cfelse>
			0
			</cfif>
		</cfif>
				
		</td>

		<td align="center">#numberformat(KA020*100,"999,999,999.99")#%</td>
<!---		<td align="center">
		<a href ="PALKC.cfm?KC001=#KB001#&KC002=#KB002#" class="btn btn-info m-1 btn-sm" target="_blank">檢視</a>
		</td>
		<td align="center">
		<a href ="PALKB_DELETE_SQL2.cfm?KB001=#KB001#&KB002=#KB002#" class="btn btn-secondary m-1 btn-sm" onclick = "if (! confirm('是否確認要刪除?')) { return false; }">刪除</a>
		</td>
--->	</tr>	

	</cfform>
</cfloop>
		<tr style="font-family:'微軟正黑體'; font-size:14px">
			<td colspan="4" align="CENTER">合計：</td>
			<td colspan="2" align="right" style="vertical-align:top">訂單金額：</td>
			<td colspan="3" align="left"><cfloop query="COPKA_Currency">#TC008#:#NUMBERFORMAT(SUMKA008,"999,999,999.99")#<BR></cfloop></td>
			<td colspan="3"><cfloop query="COPKA_COMPANY"><cfif #TRIM(COM)# eq "上岳">#TRIM(COM)##TC008#:#NUMBERFORMAT(SUMKA008,"999,999,999.99")#</cfif><BR></cfloop></td>
			<td colspan="3" style="vertical-align:top"><cfloop query="COPKA_COMPANY"><cfif #TRIM(COM)# eq "東莞">#TRIM(COM)##TC008#:#NUMBERFORMAT(SUMKA008,"999,999,999.99")#</cfif></cfloop></td>
			<td colspan="2" align="right" style="vertical-align:top">未出金額：</td>
			<td colspan="8"><cfloop query="COPKA_Uncollected">#TC008#:	#NUMBERFORMAT(SUMKA89,"999,999,999.99")#<BR></cfloop></td>


		</TR>
		<tr style="font-family:'微軟正黑體'; font-size:18px" height="100">
			<td colspan="4" align="CENTER">預交延遲說明：</td>
			<td colspan="21"><cfloop query="COPKD">#KD002#</cfloop></td>
			
		</TR>


		</TR>
		<tr style="font-family:'微軟正黑體'; font-size:18px" height="100">
			<td colspan="25" align="CENTER">核准：
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;審核：&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;經辦：#session.cnname#</td>
			
		</TR>

</table>

</cfoutput>


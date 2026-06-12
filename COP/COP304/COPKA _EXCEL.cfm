<title>訂單出貨狀況月報</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "COP304" >
<cfset program_name = "訂單出貨狀況月報" >
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
<h4 align="center">訂單出貨狀況月報</h4>

<cfoutput>
<cfsetting enablecfoutputonly="Yes">
<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="filename=訂單出貨狀況月報_#URL.KA001#.xls">

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

<cfquery name="COPKD" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKD
	WHERE 1=1 
		AND KD001  LIKE '#url.KA001#%'
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
	ORDER BY TC008 DESC
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
		AND MQ003='27'
		AND KA001 NOT LIKE 'A229%'
	GROUP BY  TC008
	ORDER BY TC008 DESC
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
	ORDER BY TC008 DESC

</cfquery>			

<table align="center" width="100%">
	<tr>
			<td align="center" colspan="21">
			<font size="+3"><strong>上岳科技股份有限公司</strong></font><br />
			<font size="+2"><strong>訂單出貨收款狀況表</strong></font><br />
			<font size="+2"><strong>訂單年月：#MID(URL.KA001,1,4)#-#MID(URL.KA001,5,2)#</strong></font><br />
			<font size="+2"><strong>製表日期：#dateformat(NOW(),"yyyy-mm-dd")#</strong></font>	
			
			</td>
		</tr>
	<tr style="font-family:'微軟正黑體'; font-size:16px " align="center">
		<TD rowspan="3" style="vertical-align:middle; border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">客戶資料</td>
		<TD colspan="5" style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">訂單資訊</td>
		<TD colspan="7" style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">銷貨資訊</td>
		<TD colspan="8" style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">帳款資訊</td>
	</TR>
	<tr style="font-family:'微軟正黑體'; font-size:16px " align="center">
		<td rowspan="2" style="vertical-align:middle; border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">訂單單號</td>
		<td style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">幣別</td>
		<td rowspan="2" style="vertical-align:middle; border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">原幣金額</td>
		<td rowspan="2" style="vertical-align:middle;border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">預交日</td>
		<td style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">生產完成日</td>
		<td rowspan="2" style="vertical-align:middle;border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">出貨日</td>
		<td rowspan="2" style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">銷貨<BR>逾期天數</td>
		<td style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">ETD</td>
		<td style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">B/L</td>
		<td style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">ETA</td>
		<td rowspan="2" style="vertical-align:middle;border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">銷貨金額</td>
		<td rowspan="2" style="vertical-align:middle;border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">未出貨金額</td>
		<td style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">訂金</td>
		<td rowspan="2" style="vertical-align:middle;border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">收款日</td>
		<td rowspan="2" style="vertical-align:middle;border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">帳款金額</td>
		<td rowspan="2" style="vertical-align:middle;border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">預計收款</td>
		<td rowspan="2" style="vertical-align:middle;border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">實際收款日</td>
		<td rowspan="2" style="vertical-align:middle;border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">未收金額</td>
		<td rowspan="2" style="vertical-align:middle;border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">累計總%</td>
		<td rowspan="2" style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">帳款<BR>逾期天數</td>
	</TR>
	<tr style="font-family:'微軟正黑體'; font-size:16px " align="center">
		<td style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">總訂單%</td>
		<td style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">變更歷程</td>
		<td style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">變更歷程</td>
		<td style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">變更歷程</td>
		<td style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">變更歷程</td>
		<td style="border-bottom:thin solid; border-top: thin solid; border-left:thin solid; border-right:thin solid">%</td>
	</TR>


<cfloop query="COPKA">

<cfset 銷貨金額=0>
<cfset KA008=#KA008#>
<cfset SUMTH3536=0>

<!---撈取各異動類別的變更日期--->
<cfquery name="COPKB1" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKB
	WHERE 1=1 
		AND KB001='#KA001#'
		AND KB002='#KA002#'
		AND KB003='#KA003#'
		AND KB005='1'
	ORDER BY KB004 
</cfquery>

<cfquery name="COPKB2" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKB
	WHERE 1=1 
		AND KB001='#KA001#'
		AND KB002='#KA002#'
		AND KB003='#KA003#'
		AND KB005='2'
	ORDER BY KB004 
</cfquery>

<cfquery name="COPKB3" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKB
	WHERE 1=1 
		AND KB001='#KA001#'
		AND KB002='#KA002#'
		AND KB003='#KA003#'
		AND KB005='3'
	ORDER BY KB004
</cfquery>

<cfquery name="COPKB4" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKB
	WHERE 1=1 
		AND KB001='#KA001#'
		AND KB002='#KA002#'
		AND KB003='#KA003#'
		AND KB005='4'
	ORDER BY KB004 
</cfquery>

<cfquery name="COPKB4_1" datasource="#SESSION.COMPANY#">
	SELECT top 1 *
	FROM COPKB
	WHERE 1=1 
		AND KB001='#KA001#'
		AND KB002='#KA002#'
		AND KB003='#KA003#'
		AND KB005='4'
	ORDER BY KB004 DESC
</cfquery>

<cfquery name="COPKB5" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKB
	WHERE 1=1 
		AND KB001='#KA001#'
		AND KB002='#KA002#'
		AND KB003='#KA003#'
		AND KB005='5'
	ORDER BY KB004 
</cfquery>


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

<cfquery name="COPTH_DATE" datasource="#SESSION.COMPANY#">
	SELECT TG003
	FROM COPTH
	JOIN COPTG ON TG001=TH001 AND TG002=TH002
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
	GROUP BY TG003
</cfquery>



<tr style="font-family:'微軟正黑體'; font-size:16px ">
		<td>#MA001#<br />#MA002#</td>
		<td align="left">#KA001#-<BR>#KA002#</td>
		<td align="center">#TC008#<BR><CFIF #KA019# NEQ 0>#numberformat(KA019*100,"999,999.99")#%</CFIF></td>
		<td align="right"><cfif #KA008# NEQ 0>#NUMBERFORMAT(KA008,"999,999.99")#</cfif></td>
		<td align="left">#MID(KA003,1,4)#-#MID(KA003,5,2)#-#MID(KA003,7,2)#</td>
		<td align="left">
		<cfif #KA005# NEQ "1900-01-01" AND #KA005# NEQ "">
			#KA005#<br />
		</cfif>
		<cfloop query="COPKB1"><font color="0000FF">#KB006#</font><BR></cfloop>
		</td>
		<td align="left"><cfloop query="COPTH_DATE">#MID(TG003,1,4)#-#MID(TG003,5,2)#-#MID(TG003,7,2)#<BR></cfloop></td>
		<td align="center"><cfif #KA010# GT 0>#NUMBERFORMAT(KA010,"9,999")#</cfif></td>
		<td align="left">
		<cfif #KA006# NEQ "1900-01-01" AND #KA006# NEQ "">
			#KA006#<BR />
		</cfif>
		<cfloop query="COPKB2"><font color="0000FF">#KB006#</font><BR></cfloop>
		</td>
		<td align="left">
		<cfif #KA021# NEQ "1900-01-01" AND #KA021# NEQ "">
			#KA021#<BR />
		</cfif>
		<cfloop query="COPKB5"><font color="0000FF">#KB006#</font><BR></cfloop>
		</td>
		<td align="left">
		<cfif #KA007# NEQ "1900-01-01" AND #KA007# NEQ "">
			#KA007#<br />
		</cfif>
		<cfloop query="COPKB3"><font color="0000FF">#KB006#</font><BR></cfloop>			
		</td>
		
		<td align="right">
		<cfset 銷貨金額_total = 0>
			
		<cfloop query="COPTH"><cfset 銷貨金額_total = #銷貨金額_total#+#SUMTH3536#></cfloop>

		<cfif #COPTH.recordcount# gt 0>
			<cfloop query="COPTH"><cfif #SUMTH3536# neq 0>#NUMBERFORMAT(SUMTH3536,"999,999.99")#<bR></cfif></cfloop>
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
		<td align="right">
		<cfif #KA013# NEQ 0>#numberformat(KA013,"999,999.99")#<BR></cfif>
		<cfif #KA008# NEQ 0 AND #KA013# NEQ 0>#numberformat(KA013/KA008*100,"999,999.99")#%</cfif>
		</td>
		<td align="left"><cfif #KA015# NEQ "1900-01-01" AND #KA015# NEQ "">#KA015#</cfif></td>
		<td align="right">
		<cfif #COPTH.recordcount# gt 0>
			<cfloop query="COPTH"><cfif #SUMTH3536# neq 0><cfset SUMTH3536=#SUMTH3536#></cfif></cfloop>
			<cfif #SUMTH3536# - #KA013# neq 0>
			#NUMBERFORMAT(SUMTH3536-KA013,"999,999.99")#
			</cfif>
		</cfif>		
		</td>
		<td align="left">
		<cfif #KA017# NEQ "1900-01-01" AND #KA017# NEQ "">#KA017#</cfif><!---<br /><cfloop query="COPKB4"><font color="0000FF">#KB006#</font><br /></cfloop>--->

		
		</td>
		<td align="left"><!---<cfif #KA018# NEQ "1900-01-01" AND #KA018# NEQ "">#KA018#</cfif>--->
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
			
		</td>


		<td align="right">
		<cfset Collection=0>

		<cfif #KA013# GT 0 AND #KA016# GT 0><!---有訂金 而且有尾款--->
			<cfif #KA016#-#KA013# gt -1 and #KA016#-#KA013# lt 1 ><!---尾款-訂金 大於 -1 小於1，表示已收齊--->
			<cfset Collection=0>
			<cfelse><!---未收金額大時--->
				<cfif #KA016#-#KA013#-#KA008# LTe 1.5 AND #KA016#-#KA013#-#KA008# GTE -1.5>
					<cfset Collection=#KA008#>
				<cfelse>
					<cfset Collection=#KA016#-#KA013#>
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
					
						<cfif #SUMKC005# - #KA008# LTe 1.5 AND #SUMKC005# - #KA008# GTE -1.5>
							<cfset Collection=Collection+#KA008#>
						<cfelse>
							<cfset Collection=Collection+#SUMKC005#>
						</cfif>
					<cfelse>
						<cfset Collection=0>
					</cfif>
				</cfloop>
			<cfelse>
			<cfset Collection=0>
			</cfif>
		</cfif>
		
		<cfif #KA009# - #KA013# -#Collection# GT 0 >
		#NUMBERFORMAT(KA009- KA013- Collection , "999,999,999.99")#
		</cfif>
		
		</td>
		<td align="right"><cfif #KA020# gte 0.999 and #KA020# lte 1.005  >100%<cfelseif #KA020# NEQ 0>#numberformat(KA020*100,"999,999,999.99")#%</cfif></td>
		<td align="right">

		<cfif #KA021# NEQ "1900-01-01" AND #KA021# NEQ "" >
			<cfquery name="COPKC" datasource="#SESSION.COMPANY#">
			SELECT  convert(datetime, MAX(KC006),121) TC003,convert(datetime, KA017,121) TA020
				FROM COPKC
				JOIN
				(SELECT  TD001,TD002,TD003,KA017
				FROM COPTD
				JOIN COPKA ON TD001=KA001 AND TD002=KA002 AND TD047=KA003

				where 1=1
					AND TD001='#KA001#'
					AND TD002='#trim(KA002)#'
					AND TD047='#KA003#'
					AND TD021='Y') AS COPTD ON TD001=KC002 AND TD002=KC003 AND TD003=KC004
				GROUP BY KC002,KC003,KC004,KA017
			</cfquery>
			<cfloop query="COPKC">
				<cfif #TC003# EQ "">
					<cfif #DateDiff('d', TA020,dateformat(now(),"yyyy-mm-dd"))# gt 0>
				#DateDiff('d', TA020,dateformat(now(),"yyyy-mm-dd"))#<BR>
					</cfif>
				<cfelse>
					<cfif #DateDiff('d', TA020,TC003)# gt 0>
					#DateDiff('d', TA020,TC003)#<BR>
					</cfif>
				</cfif>
			</cfloop>

		<cfelse>
<!---		查詢訂單的所有銷貨單--->
			<cfquery name="COPTH_1" datasource="#SESSION.COMPANY#">
			SELECT DISTINCT TH001,TH002
			FROM COPTH
			WHERE RTRIM(TH014)+RTRIM(TH015)+RTRIM(TH016) IN
			(SELECT RTRIM(TD001)+RTRIM(TD002)+RTRIM(TD003)
			FROM COPTD
			WHERE 1=1
				AND TD001='#KA001#'
				AND TD002='#TRIM(KA002)#'
				AND TD047='#KA003#'
			AND TD021='Y')
			</cfquery>

<!---		查詢銷貨單後續結帳單的預計收款日與實際收款日--->
			<cfloop query="COPTH_1">
				<cfquery name="ACRTC" datasource="#SESSION.COMPANY#">
				SELECT DISTINCT convert(datetime, TA020,121) TA020,convert(datetime, TC003,121) TC003
				FROM ACRTB
				JOIN ACRTA ON TA001=TB001 AND TA002=TB002
				LEFT JOIN ACRTD ON TD006=TB001 AND TD007=TB002
				LEFT JOIN ACRTC ON TC001=TD001 AND TC002=TD002
				WHERE 1=1
					AND TB005='#TH001#'
					AND TB006='#TH002#'
				</cfquery>

				<cfloop query="ACRTC">
					<cfif #TC003# EQ "">
						<cfif #DateDiff('d', TA020,dateformat(now(),"yyyy-mm-dd"))# gt 0>
					#DateDiff('d', TA020,dateformat(now(),"yyyy-mm-dd"))#<BR>
						</cfif>
					<cfelse>
						<cfif #DateDiff('d', TA020,TC003)# gt 0>
						#DateDiff('d', TA020,TC003)#<BR>
						</cfif>
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>

		</td>

	</tr>	
</cfloop>
		<TR style="vertical-align:top">
			<td colspan="4" align="right" style="border-top:thin solid" ><font size="+1">合計：</font></td>
			<td colspan="3" align="right"  style="border-top:thin solid" ><font size="+1">訂單金額：</font></td>
			<td colspan="3" align="left" style="border-top:thin solid" ><cfloop query="COPKA_Currency"><font size="+1">#TC008#:#NUMBERFORMAT(SUMKA008,"999,999,999.99")#</font><BR></cfloop></td>
			<td colspan="3" style="border-top:thin solid" ><cfloop query="COPKA_COMPANY"><cfif #TRIM(COM)# eq "上岳"><font size="+1">#TRIM(COM)##TC008#:#NUMBERFORMAT(SUMKA008,"999,999,999.99")#</font><BR></cfif></cfloop></td>
			<td colspan="3" style="border-top:thin solid" ><cfloop query="COPKA_COMPANY"><cfif #TRIM(COM)# eq "東莞"><font size="+1">#TRIM(COM)##TC008#:#NUMBERFORMAT(SUMKA008,"999,999,999.99")#</font><BR></cfif></cfloop></td>
			<td colspan="2" align="right" style="border-top:thin solid" ><font size="+1">未出金額：</font></td>
			<td colspan="3" style="border-top:thin solid" ><cfloop query="COPKA_Uncollected"><font size="+1">#TC008#:	#NUMBERFORMAT(SUMKA89,"999,999,999.99")#</font><BR></cfloop></td>
		</TR>
		<TR style="vertical-align:top; border:hidden">
			<TD colspan="1"  align="right" style="border-top:thin solid" ><font size="+1">預交日延遲說明：</font></TD>
			<TD colspan="20" style="border-top:thin solid" ><font size="+1">依單號別說明原別(廠務、業務、客戶)：</font></TD>
		</TR>
		<TR style="vertical-align:top; border:hidden">
			<TD colspan="21">	
			<cfloop query="COPKD">
			<font size="+1">#KD002#</font>
			</cfloop>
			</TD>
		</TR>
		<TR style="vertical-align:middle; border:hidden">
			<TD colspan="21" height="50" style="border-top:thin solid" ><font size="+1">&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;核准：
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;審核：
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;經辦：#SESSION.CNNAME#
			
			
			
			</font></TD>

			
		</TR>
</table>
<BR />

<BR />

</cfoutput>


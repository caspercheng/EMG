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

<cfif URL.KA001 IS NOT ""><cfset #FORM.KA001#=#URL.KA001#>	 </cfif>
<cfif URL.KA004 IS NOT ""><cfset #FORM.KA004#=#URL.KA004#>	 </cfif>


<cfif NOT IsDefined("FORM.KA001")><cfset #FORM.KA001#="#DATEFORMAT(NOW(),"yyyymm")#"></cfif>
<cfif NOT IsDefined("FORM.KA004")><cfset #FORM.KA004#="#DATEFORMAT(NOW(),"yyyymm")#"></cfif>
<cfif NOT IsDefined("FORM.submit")><cfset #FORM.submit#=""></cfif>

<!---作業標題--->
<h4 align="center">訂單出貨狀況月報</h4>

<cfoutput>

<cfform action="COPKA.cfm" method="post">

<table align="center" bgcolor="9999CC">
	<tr>
	
		<td>查詢年月 </td>
		<td> 	  
			<cfinput type="text" mask="999999" name="KA001" size="8" value="#FORM.KA001#" required="yes" message="查詢年月不可為空!!">
		</td>

		<td colspan="1" align="center"><input type="submit" value="查詢" name="submit"></td>
	  
	</tr>
</table>
	
</cfform>

<cfquery name="COPKA" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKA
	JOIN COPTC ON KA001=TC001 AND KA002=TC002
	JOIN COPMA ON TC004=MA001
	WHERE 1=1 
		AND KA004 LIKE '#FORM.KA001#%'
		AND KA001 NOT LIKE 'A229%'
	ORDER BY KA003 ,KA002
</cfquery>

<cfquery name="COPKD" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKD
	WHERE 1=1 
		AND KD001  LIKE '#FORM.KA001#%'
</cfquery>

<!---撈取依幣別統計訂單金額--->
<cfquery name="COPKA_Currency" datasource="#SESSION.COMPANY#">
	SELECT TC008,SUM(KA008) SUMKA008
	FROM COPKA
	JOIN COPTC ON KA001=TC001 AND KA002=TC002
	JOIN COPMA ON TC004=MA001
	WHERE 1=1 
		AND KA004 LIKE '#FORM.KA001#%'
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
		AND KA004 LIKE '#FORM.KA001#%'
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
		AND KA004 LIKE '#FORM.KA001#%'
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
		AND KA004 LIKE '#FORM.KA001#%'
		AND KA001 NOT LIKE 'A229%'
		AND (KA008-KA009)  <>0
	GROUP BY TC008
	ORDER BY TC008 DESC
</cfquery>			
			
<!---<cfform action="COPKA_INSERT_SQL.cfm?KA001=#FORM.KA001#&KA004=#FORM.KA004#" enctype="multipart/form-data"  method="post">
<table align="center"  style="font-size:16px">
	<TR>
		
		<td bgcolor="CCCCCC"  style="color:000000">
		預交日年月
					<cfinput type="text" name="KA004" value="#FORM.KA001#" size=6>
					<cfinput type="submit" name="submit" value="新增" class="btn btn-success btn-sm m-1">
					<cfinput type="submit" name="submit" value="更新" class="btn btn-primary btn-sm m-1">
					<cfinput type="submit" name="submit" value="訂金分攤" class="btn btn-info btn-sm m-1">
					<cfinput type="submit" name="submit" value="尾款回推" class="btn btn-warning btn-sm m-1">
					<a href ="COPKD.cfm?KA001=#FORM.KA001#" class="btn btn-secondary btn-sm m-1" target="_blank">逾期說明</a>
		</td>
	
	</TR>	 
</table>	
	
</cfform>

--->
<a href="COPKA _EXCEL.cfm?KA001=#FORM.KA001#" class="btn btn-success m-1">轉出EXCEL</a>

<div style="height:85%">
<table id="myTable01" class="fancyTable" >
<thead>

	<TR  bgcolor="666666" style="color:FFF;font:'微軟正黑體'; font-size:9px" align="center">
		<TH rowspan="3" style="vertical-align:middle">客戶資料</TH>
		<TH colspan="5">訂單資訊</TH>
		<TH colspan="7">銷貨資訊</TH>
		<TH colspan="8">帳款資訊</TH>
	</TR>
	<TR  bgcolor="666666" style="color:FFF;font:'微軟正黑體';font-size:11px" align="center">
		<TH rowspan="2" style="vertical-align:middle">訂單單號</TH>
		<TH>幣別</TH>
		<TH rowspan="2" style="vertical-align:middle">原幣金額</TH>
		<TH rowspan="2" style="vertical-align:middle">預交日</TH>
		<TH>生產完成日</TH>
		<TH rowspan="2" style="vertical-align:middle">出貨日</TH>
		<TH rowspan="2">銷貨<BR>逾期天數</TH>
		<TH>ETD</TH>
		<TH>B/L</TH>
		<TH>ETA</TH>
		<TH rowspan="2" style="vertical-align:middle">銷貨金額</TH>
		<TH rowspan="2" style="vertical-align:middle">未出貨金額</TH>
		<TH>訂金</TH>
		<TH rowspan="2" style="vertical-align:middle">收款日</TH>
		<TH rowspan="2" style="vertical-align:middle">帳款金額</TH>
		<TH rowspan="2" style="vertical-align:middle">預計收款</TH>
		<TH rowspan="2" style="vertical-align:middle">實際收款日</TH>
		<TH rowspan="2" style="vertical-align:middle">未收金額</TH>
		<TH rowspan="2" style="vertical-align:middle">累計總%</TH>
		<TH rowspan="2">帳款<BR>逾期天數</TH>
	</TR>
	<TR  bgcolor="666666" style="color:FFF;font:'微軟正黑體';font-size:11px" align="center">
		<TH>總訂單%</TH>
		<TH>變更歷程</TH>
		<TH>變更歷程</TH>
		<TH>變更歷程</TH>
		<TH>變更歷程</TH>
		<TH>%</TH>
	</TR>

</thead>

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


<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
<tbody>

<tr style="font-family:'微軟正黑體'; font-size:12px " bgcolor="#bgcolor#">
		<td width="20">#MA001#<br />#MA002#</td>
		<td align="left">#KA001#-<BR>#KA002#</td>
		<td align="center">#TC008#<BR><CFIF #KA019# NEQ 0>#numberformat(KA019*100,"999,999.99")#%</CFIF></td>
		<td align="center"><cfif #KA008# NEQ 0>#NUMBERFORMAT(KA008,"999,999.99")#</cfif></td>
		<td align="center">#mid(KA003,1,4)#-#mid(KA003,5,2)#-#mid(KA003,7,2)#</td>
		<td align="center">
		<cfif #KA005# NEQ "1900-01-01" AND #KA005# NEQ "">
			#KA005#<br />
		</cfif>
		<cfloop query="COPKB1"><font color="0000FF">#KB006#</font><BR></cfloop>
		</td>
		<td align="center"><cfloop query="COPTH_DATE">#mid(TG003,1,4)#-#mid(TG003,5,2)#-#mid(TG003,7,2)#<BR></cfloop></td>
		<td align="center"><cfif #KA010# GT 0>#NUMBERFORMAT(KA010,"9,999")#</cfif></td>
		<td align="center">
		<cfif #KA006# NEQ "1900-01-01" AND #KA006# NEQ "">
			#KA006#<BR />
		</cfif>
		<cfloop query="COPKB2"><font color="0000FF">#KB006#</font><BR></cfloop>
		</td>
		<td align="center">
		<cfif #KA021# NEQ "1900-01-01" AND #KA021# NEQ "">
			#KA021#<BR />
		</cfif>
		<cfloop query="COPKB5"><font color="0000FF">#KB006#</font><BR></cfloop>
		</td>
		<td align="center">
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
		<td align="center" width="20">
		<cfif #KA013# NEQ 0>#numberformat(KA013,"999,999.99")#<BR></cfif>
		<cfif #KA008# NEQ 0 AND #KA013# NEQ 0>#numberformat(KA013/KA008*100,"999,999.99")#%</cfif></td>
		<td align="center"><cfif #KA015# NEQ "1900-01-01" AND #KA015# NEQ "">#KA015#</cfif></td>
		<td align="center">
		<cfif #COPTH.recordcount# gt 0>
			<cfloop query="COPTH"><cfif #SUMTH3536# neq 0><cfset SUMTH3536=#SUMTH3536#></cfif></cfloop>
			<cfif #SUMTH3536#-#KA013# neq 0>
			#NUMBERFORMAT(SUMTH3536-KA013,"999,999.99")#
			</cfif>
		</cfif>		
		</td>

		<td align="center">
		<cfif #KA017# NEQ "1900-01-01" AND #KA017# NEQ "">#KA017#</cfif><!---<br /><cfloop query="COPKB4"><font color="0000FF">#KB006#</font><br /></cfloop>--->

		
		</td>
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
		<td align="center">
		<cfif #KA020# gte 0.999 and #KA020# lte 1.005  >100%<cfelseif #KA020# NEQ 0>#numberformat(KA020*100,"999,999,999.99")#%</cfif></td>
		<td align="center">
		
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
</tbody>
</cfloop>
		<TR style="border-bottom:solid">
			<td colspan="4" align="right">合計：</td>
			<td colspan="3" align="right">訂單金額：</td>
			<td colspan="3" align="left"><cfloop query="COPKA_Currency">#TC008#:#NUMBERFORMAT(SUMKA008,"999,999,999.99")#<BR></cfloop></td>
			<td colspan="3"><cfloop query="COPKA_COMPANY"><cfif #TRIM(COM)# eq "上岳">#TRIM(COM)##TC008#:#NUMBERFORMAT(SUMKA008,"999,999,999.99")#<BR></cfif></cfloop></td>
			<td colspan="3"><cfloop query="COPKA_COMPANY"><cfif #TRIM(COM)# eq "東莞">#TRIM(COM)##TC008#:#NUMBERFORMAT(SUMKA008,"999,999,999.99")#<BR></cfif></cfloop></td>
			<td colspan="2" align="right">未出金額：</td>
			<td colspan="3"><cfloop query="COPKA_Uncollected">#TC008#:	#NUMBERFORMAT(SUMKA89,"999,999,999.99")#<BR></cfloop></td>
		</TR>


</table>
<BR />
<div class="container-fluid">
	<div class="row">		
		<div class="col-2">
		<font size="+1">預交日延遲說明：</font>
		</div>
		<div class="col-10">
		<font size="+1">依單號別說明原別(廠務、業務、客戶)：</font>
		</div>
	</div>

	<div class="row">		
		<div class="col-2" align="center">
		
		</div>
		<div class="col-10">
		<cfloop query="COPKD">
		<font size="+1">#KD002#</font>
		</cfloop>
		</div>
	</div>
	<BR>
	<BR>
	<div class="row">		
		<div class="col-4" align="center">
		<font size="+2">
		核准：</font>
		</div>
		<div class="col-4" align="center">
		<font size="+2">
		審核：</font>
		</div>
		<div class="col-4" align="center">
		<font size="+2">
		經辦：#SESSION.CNNAME#</font>
		</div>

	</div>
	
</div>
<BR />

</cfoutput>


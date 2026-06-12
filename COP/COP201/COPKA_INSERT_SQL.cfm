<!---新增訂單單頭資料--->
<cfoutput>
<cfinclude template="/EMG/menu.cfm">

<cfif #FORM.SUBMIT# EQ "新增">
<!---	<!---新增訂單單頭--->
	<cfquery datasource="#SESSION.COMPANY#" name="COPKA">
			SELECT *
			FROM COPKA
			WHERE 1=1
				AND KA004 LIKE '#FORM.KA004#%'
	</cfquery>
	
	<cfif #COPKA.RECORDCOUNT# GT 0>
	<div class="alert alert-success" role="alert" align="center">
	#FORM.KA004#, 該月份已經產生過維護檔，請重新輸入!!!
	</div>	
	<cfabort>
	</cfif>
--->    
	<!---新增訂單單頭--->
	<cfquery datasource="#SESSION.COMPANY#" name="COPTC">
			SELECT MA001,MA002,TD001,TD002,TD047,TC008,SUM(TD012),KA001
			FROM COPTD
			JOIN COPTC ON TC001=TD001 AND TC002=TD002
			JOIN COPMA ON MA001=TC004
			LEFT JOIN COPKA ON KA001=TC001 AND KA002=TC002 AND KA003=TD047				
			WHERE 1=1
				AND TD021='Y' 
				AND TD047 LIKE '#FORM.KA004#%'
				AND SUBSTRING(TD001 ,1,4) NOT IN ('A228','A229')
			GROUP BY MA001,MA002,TD001,TD002,TD047,TC008,KA001

	</cfquery>

	<cfloop query="COPTC">
	<cfif #KA001# EQ "">
	<!---新增訂單單頭--->
	<cfquery datasource="#SESSION.COMPANY#" name="COPKA_INSERT">
			INSERT dbo.COPKA  (KA001,KA002,KA003,KA004,KA005,KA006,KA007,KA008,KA009,KA010,
													KA011,KA012,KA013,KA014,KA015,KA016,KA017,KA018,KA019,KA020)
		   VALUES ('#TD001#','#TD002#','#TD047#','#FORM.KA004#','','','',0,0,0,
		   					'','',0,'','',0,'','',0,0)
	</cfquery>
	</cfif>
	</cfloop>
	
	<cfquery datasource="#SESSION.COMPANY#" name="COPKD">
			SELECT *
			FROM COPKD
			WHERE 1=1
				AND KD001 ='#FORM.KA004#'
	</cfquery>
	
	<cfif #COPKD.RECORDCOUNT# EQ 0>
		<cfquery datasource="#SESSION.COMPANY#" name="COPKD_INSERT">
			INSERT dbo.COPKD  (KD001,KD002)
		   VALUES ('#FORM.KA004#','')
	</cfquery>

	
	</cfif>

	
</cfif>


<cfif #FORM.SUBMIT# EQ "更新">
	<!---更新維護檔的原幣金額--->
	<cfquery name="COPKA" datasource="#SESSION.COMPANY#">
		SELECT COPKA.*,NA002,ISNULL(convert(datetime, KB006, 21),'') KB006A,
		convert(datetime, KB006, 21)+CMSNA.UDF06   尾款預收日_change,
		convert(datetime, KA021, 21)+CMSNA.UDF06   尾款預收日_first
		FROM COPKA	
		JOIN COPTC ON KA001=TC001 AND KA002=TC002
		JOIN CMSNA ON TC042=NA002 AND NA001='2'
		LEFT JOIN 
		( SELECT TOP 1 KB001,KB002,KB003,KB006
		FROM COPKB
		WHERE 1=1
			AND KB005='5'
		ORDER BY KB004 DESC
		) AS COPKB ON KB001=KA001 AND KB002=KA002 AND KB003=KA003
		
		WHERE 1=1 
			AND KA004 LIKE '#FORM.KA004#%'
	</cfquery>
	
	<cfloop query="COPKA">		
		<cfquery name="KA008_UPDATE" datasource="#SESSION.COMPANY#">	
			UPDATE COPKA 
			SET KA008=ISNULL(SUMTD012,0)
			FROM COPKA	
			JOIN
			(SELECT TD001,TD002,TD047,	
			CASE TC016
			WHEN '2' THEN ROUND(SUM(TD012*1.05) ,0)
			WHEN '1' THEN SUM(TD012) 
			ELSE SUM(TD012) END  SUMTD012
			FROM COPTD
			JOIN COPTC ON TC001=TD001 AND TC002=TD002			
			WHERE TD021='Y'
			GROUP BY TD001,TD002,TD047,TD013,TC016
			) AS COPTD ON TD001=KA001 AND TD002=KA002 AND TD047=KA003
				AND KA004 LIKE '#FORM.KA004#%'
		</cfquery>

		<cfquery name="KA010_UPDATE" datasource="#SESSION.COMPANY#">	
		UPDATE COPKA 
			SET 	KA010=ISNULL(DAYCOUNT,0)
			FROM COPKA	
			JOIN
			(SELECT COPTD.TD001,COPTD.TD002,COPTD.TD047,				
			CASE ISNULL(MAXTG003,0)
			WHEN 0 THEN DATEDIFF(day, convert(datetime, COPTD.TD047, 121), getdate())
			ELSE DATEDIFF(day, convert(datetime, COPTD.TD047, 121), convert(datetime, MAXTG003, 121)) END  DAYCOUNT
			FROM COPTD
			JOIN COPTC ON TC001=TD001 AND TC002=TD002
			LEFT JOIN (
				SELECT TD001,TD002,TD047,MAX(TG003) MAXTG003
				FROM COPTD
				LEFT JOIN COPTH ON TD001=TH014 AND TD002=TH015 AND TD003=TH016
				LEFT JOIN COPTG ON TG001=TH001 AND TG002=TH002
				GROUP BY TD001,TD002,TD047
				)	AS COPTH ON COPTH.TD001=COPTD.TD001 AND COPTH.TD002=COPTD.TD002 AND COPTH.TD047=COPTD.TD047
			WHERE TD021='Y'
			GROUP BY COPTD.TD001,COPTD.TD002,COPTD.TD047,MAXTG003
			) AS COPTD ON COPTD.TD001=KA001 AND COPTD.TD002=KA002 AND COPTD.TD047=KA003
				AND KA004 LIKE '#FORM.KA004#%'
		</cfquery>

	</cfloop>	
	
	<cfloop query="COPKA"><!---撈出符合的出貨通知單，回寫ETD/ETA/BL日期--->
	<cfset ETD="">	
	<cfset BL="">	
	<cfset ETA="">	
	
		<cfquery name="EPSTA" datasource="#SESSION.COMPANY#">
		SELECT distinct TA039,TA040,TA054,len(TA039) len39,len(TA040) len40,len(TA054) len54
		FROM EPSTB
		JOIN EPSTA ON TA001=TB001 AND TA002=TB002
		WHERE RTRIM(TB004)+RTRIM(TB005)+RTRIM(TB006) IN 
		(SELECT RTRIM(TD001)+RTRIM(TD002)+RTRIM(TD003)
		FROM COPTD
		WHERE 1=1
			AND TD001='#KA001#'
			AND TD002='#TRIM(KA002)#'	
			AND TD047='#KA003#'
			AND TD021='Y')
		ORDER BY TA039
		</cfquery>
		
		<cfloop query="EPSTA">
			<cfif #len40# eq 0><cfset ETD=""><cfelse><cfset ETD=#MID(TA040,1,4)#&"-"&#MID(TA040,5,2)#&"-"&#MID(TA040,7,2)#></cfif>	
			<cfif #len54# eq 0><cfset BL=""><cfelse><cfset BL   =#MID(TA054,1,4)#&"-"&#MID(TA054,5,2)#&"-"&#MID(TA054,7,2)#></cfif>	
			<cfif #len39# eq 0><cfset ETA=""><cfelse><cfset ETA=#MID(TA039,1,4)#&"-"&#MID(TA039,5,2)#&"-"&#MID(TA039,7,2)#></cfif>	
		</cfloop>		

		<cfquery name="EPS_UPDATE" datasource="#SESSION.COMPANY#">
			UPDATE COPKA
			SET 	KA006= convert(datetime, '#ETD#', 121) ,
					 KA007=convert(datetime, '#ETA#', 121) ,
				  	KA021= convert(datetime,  '#BL#', 121)
			FROM COPKA							
			WHERE 1=1
				AND KA001='#KA001#'
				AND KA002='#KA002#'
				AND KA003='#KA003#'
		</cfquery>
	</cfloop>	
	
	
	
	
	
<!---更新維護檔的尾款實收金額--->
	<cfloop query="COPKA">
		<cfset KA001=#KA001#>
		<cfset KA002=#KA002#>
		<cfset KA003=#KA003#>
		<cfset 尾款預收日="">

		<cfquery name="COPTH_DATE" datasource="#SESSION.COMPANY#">
			SELECT convert(varchar, convert(datetime, TG003, 111)+CMSNA.UDF06 , 111) 計算後日期
			FROM COPTH
			JOIN COPTG ON TG001=TH001 AND TG002=TH002
			JOIN CMSNA ON TG047=NA002 AND NA001='2'

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
			GROUP BY convert(varchar, convert(datetime, TG003, 111)+CMSNA.UDF06 , 111) 
			order by convert(varchar, convert(datetime, TG003, 111)+CMSNA.UDF06 , 111) 
		</cfquery>
		
		<!---撈出符合預交日的結帳預收日  --->
		<cfquery name="ACRTA020" datasource="#SESSION.COMPANY#">
		SELECT DISTINCT convert(varchar, convert(datetime, TA020, 111) , 111)  結帳預收日
		FROM COPTH
		JOIN ACRTB ON TB005=TH001 AND TB006=TH002 AND TB007=TH003
		JOIN ACRTA ON TA001=TB001 AND TA002=TB002
		WHERE RTRIM(TH014)+RTRIM(TH015)+RTRIM(TH016) IN 
		(SELECT RTRIM(TD001)+RTRIM(TD002)+RTRIM(TD003)
		FROM COPTD
		WHERE 1=1
			AND TD001='#KA001#'
			AND TD002='#TRIM(KA002)#'	
			AND TD047='#KA003#'
			AND TD021='Y')
		ORDER BY  convert(varchar, convert(datetime, TA020, 111) , 111)  
		</cfquery>
		
		<cfif #NA002# EQ "37"><!---付款條件37的，一律推算到下星期二--->
			<cfif  #mid(尾款預收日_change,1,10)# NEQ "1900-01-01" AND #尾款預收日_change# NEQ "">		
				<cfif #dayofweek(尾款預收日_change)# eq 1><cfset 尾款預收日=#dateformat(尾款預收日_change+2,"yyyy-mm-dd")#></cfif>
				<cfif #dayofweek(尾款預收日_change)# eq 2><cfset 尾款預收日=#dateformat(尾款預收日_change+8,"yyyy-mm-dd")#></cfif>
				<cfif #dayofweek(尾款預收日_change)# eq 3><cfset 尾款預收日=#dateformat(尾款預收日_change+7,"yyyy-mm-dd")#></cfif>
				<cfif #dayofweek(尾款預收日_change)# eq 4><cfset 尾款預收日=#dateformat(尾款預收日_change+6,"yyyy-mm-dd")#></cfif>
				<cfif #dayofweek(尾款預收日_change)# eq 5><cfset 尾款預收日=#dateformat(尾款預收日_change+5,"yyyy-mm-dd")#></cfif>
				<cfif #dayofweek(尾款預收日_change)# eq 6><cfset 尾款預收日=#dateformat(尾款預收日_change+4,"yyyy-mm-dd")#></cfif>
				<cfif #dayofweek(尾款預收日_change)# eq 7><cfset 尾款預收日=#dateformat(尾款預收日_change+3,"yyyy-mm-dd")#></cfif>
			<cfelseif #KA021# NEQ "1900-01-01" AND #KA021# NEQ "">
				<cfif #dayofweek(尾款預收日_first)# eq 1><cfset 尾款預收日=#dateformat(尾款預收日_first+2,"yyyy-mm-dd")#></cfif>
				<cfif #dayofweek(尾款預收日_first)# eq 2><cfset 尾款預收日=#dateformat(尾款預收日_first+8,"yyyy-mm-dd")#></cfif>
				<cfif #dayofweek(尾款預收日_first)# eq 3><cfset 尾款預收日=#dateformat(尾款預收日_first+7,"yyyy-mm-dd")#></cfif>
				<cfif #dayofweek(尾款預收日_first)# eq 4><cfset 尾款預收日=#dateformat(尾款預收日_first+6,"yyyy-mm-dd")#></cfif>
				<cfif #dayofweek(尾款預收日_first)# eq 5><cfset 尾款預收日=#dateformat(尾款預收日_first+5,"yyyy-mm-dd")#></cfif>
				<cfif #dayofweek(尾款預收日_first)# eq 6><cfset 尾款預收日=#dateformat(尾款預收日_first+4,"yyyy-mm-dd")#></cfif>
				<cfif #dayofweek(尾款預收日_first)# eq 7><cfset 尾款預收日=#dateformat(尾款預收日_first+3,"yyyy-mm-dd")#></cfif>
			<cfelseif #COPTH_DATE.recordcount# gt 0>
					<cfloop query="COPTH_DATE">
						<cfset 計算後日期_final="">
						<cfif #dayofweek(計算後日期)# eq 1><cfset 計算後日期_final=#dateformat(計算後日期+2,"yyyy-mm-dd")#></cfif>
						<cfif #dayofweek(計算後日期)# eq 2><cfset 計算後日期_final=#dateformat(計算後日期+8,"yyyy-mm-dd")#></cfif>
						<cfif #dayofweek(計算後日期)# eq 3><cfset 計算後日期_final=#dateformat(計算後日期+7,"yyyy-mm-dd")#></cfif>
						<cfif #dayofweek(計算後日期)# eq 4><cfset 計算後日期_final=#dateformat(計算後日期+6,"yyyy-mm-dd")#></cfif>
						<cfif #dayofweek(計算後日期)# eq 5><cfset 計算後日期_final=#dateformat(計算後日期+5,"yyyy-mm-dd")#></cfif>
						<cfif #dayofweek(計算後日期)# eq 6><cfset 計算後日期_final=#dateformat(計算後日期+4,"yyyy-mm-dd")#></cfif>
						<cfif #dayofweek(計算後日期)# eq 7><cfset 計算後日期_final=#dateformat(計算後日期+3,"yyyy-mm-dd")#></cfif>
						<cfset 尾款預收日=#尾款預收日#&#MID(計算後日期_final,1,10)#&"<br>">	

					</cfloop>
					
			<cfelse>
				<cfquery name="CMSNA" datasource="#SESSION.COMPANY#">
					SELECT convert(datetime, KA003, 21)+CMSNA.UDF06  尾款預收日
					FROM COPKA
					JOIN COPTC ON KA001=TC001 AND KA002=TC002
					JOIN CMSNA ON TC042=NA002 AND NA001='2'
					WHERE 1=1
						AND TC001='#KA001#'
						AND TC002='#KA002#'							
				</cfquery>
				
				<cfloop query ="CMSNA">
						<cfif #dayofweek(尾款預收日)# eq 1><cfset 尾款預收日=#dateformat(尾款預收日+2,"yyyy-mm-dd")#></cfif>
						<cfif #dayofweek(尾款預收日)# eq 2><cfset 尾款預收日=#dateformat(尾款預收日+8,"yyyy-mm-dd")#></cfif>
						<cfif #dayofweek(尾款預收日)# eq 3><cfset 尾款預收日=#dateformat(尾款預收日+7,"yyyy-mm-dd")#></cfif>
						<cfif #dayofweek(尾款預收日)# eq 4><cfset 尾款預收日=#dateformat(尾款預收日+6,"yyyy-mm-dd")#></cfif>
						<cfif #dayofweek(尾款預收日)# eq 5><cfset 尾款預收日=#dateformat(尾款預收日+5,"yyyy-mm-dd")#></cfif>
						<cfif #dayofweek(尾款預收日)# eq 6><cfset 尾款預收日=#dateformat(尾款預收日+4,"yyyy-mm-dd")#></cfif>
						<cfif #dayofweek(尾款預收日)# eq 7><cfset 尾款預收日=#dateformat(尾款預收日+3,"yyyy-mm-dd")#></cfif>
						<cfset 尾款預收日 =#MID(dateformat(尾款預收日,"yyyy-mm-dd"),1,10)#>
				</cfloop>
			</cfif>
	
				
		<cfelse>
			
			<cfif  #mid(尾款預收日_change,1,10)# NEQ "1900-01-01" AND #尾款預收日_change# NEQ "">		
					<cfset 尾款預收日=#MID(DATEFORMAT(尾款預收日_change,"yyyy-mm-dd"),1,10)#>	
			<cfelseif  #KA021# NEQ "1900-01-01" AND #KA021# NEQ "">		
					<cfset 尾款預收日=#MID(DATEFORMAT(尾款預收日_first,"yyyy-mm-dd"),1,10)#>	
			<cfelseif #ACRTA020.recordcount# gt 0>
					<cfloop query="ACRTA020">
						<cfset 尾款預收日=#尾款預收日#&#MID(DATEFORMAT(結帳預收日,"yyyy-mm-dd"),1,10)#&"<br>">	
					</cfloop>	
			<cfelseif #COPTH_DATE.recordcount# gt 0>
					<cfloop query="COPTH_DATE">
						<cfset 尾款預收日=#尾款預收日#&#MID(DATEFORMAT(計算後日期,"yyyy-mm-dd"),1,10)#&"<br>">	
					</cfloop>	
			<cfelse>
				<cfquery name="CMSNA" datasource="#SESSION.COMPANY#">
					SELECT convert(datetime, KA003, 21)+CMSNA.UDF06  尾款預收日
					FROM COPKA
					JOIN COPTC ON KA001=TC001 AND KA002=TC002
					JOIN CMSNA ON TC042=NA002 AND NA001='2'
					WHERE 1=1
						AND TC001='#KA001#'
						AND TC002='#KA002#'							
				</cfquery>
				
				<cfloop query ="CMSNA"><cfset 尾款預收日 =#MID(dateformat(尾款預收日,"yyyy-mm-dd"),1,10)#></cfloop>
	
			</cfif>			
		</cfif>
		<!---</cfloop>	--->							
				<!---更新COPKA的尾款預收日--->
		<cfquery name="KA017_UPDATE" datasource="#SESSION.COMPANY#">
			UPDATE COPKA
			SET 	KA017='<cfif #尾款預收日# neq "">#尾款預收日#</cfif>'
					
			FROM COPKA							
			WHERE 1=1
				AND KA001='#KA001#'
				AND KA002='#KA002#'
				AND KA003='#KA003#'
		</cfquery>


	</cfloop>
	


<!---<CFABORT>
---></cfif>			




<cfif #FORM.SUBMIT# EQ "訂金分攤">

<!---撈取該月份所有訂單單別、單號--->
<cfquery name="COPKA" datasource="#SESSION.COMPANY#">
	SELECT DISTINCT KA001,KA002
	FROM COPKA	
	WHERE 1=1 
		AND KA004 LIKE '#FORM.KA004#%'
</cfquery>
	
<cfloop query="COPKA">
<!---宣告變數--->
	<cfset 訂金金額_A=0>
	<cfset 訂金金額_B=0>
	<cfset 實收訂金日_A="">
	<cfset 實收訂金日_B="">	
	<cfset 訂金合計=0>
	<cfset 原幣金額合計 = 0>
	
	<!---撈取每張訂單溢收訂金--->	
	<cfquery name="ACRTD" datasource="#SESSION.COMPANY#">
		SELECT  TC003,ISNULL(SUM(TD014),0) 訂金金額
		FROM ACRTD	
		JOIN ACRTC ON TC001=TD001 AND TC002=TD002
		where 1=1
		AND TD017 LIKE '%#KA001#'+'-'+'#trim(KA002)#%'
		AND TD005='5'
		AND TD020='Y'
		GROUP BY TC003
	</cfquery>
	<cfloop query="ACRTD">
		<cfset 訂金金額_A=訂金金額_A+#訂金金額#>
		<cfset 實收訂金日_A=實收訂金日_A&#MID(TC003,1,4)#&"-"&#MID(TC003,5,2)#&"-"&#MID(TC003,7,2)#&"<BR>">
	</cfloop>
	
	<!---撈取每張訂單預收訂金--->	
	<cfquery name="ACRTB" datasource="#SESSION.COMPANY#">
		SELECT  TA003,ISNULL(SUM(TB017+TB018),0) 訂金金額
		FROM ACRTB	
		JOIN ACRTA ON TB001=TA001 AND TB002=TA002
		where 1=1
			AND TB005='#KA001#'
			AND TB006='#trim(KA002)#'
			AND TB004='6'
			AND TB012='Y'
		GROUP BY TA003
	</cfquery>
	<cfloop query="ACRTB">
		<cfset 訂金金額_B=訂金金額_B+#訂金金額#>
		<cfset 實收訂金日_A=實收訂金日_A&#MID(TA003,1,4)#&"-"&#MID(TA003,5,2)#&"-"&#MID(TA003,7,2)#&"<BR>">
	</cfloop>
	
	<!---預收+溢收訂金加總--->
	<cfset 訂金合計=#NUMBERFORMAT(訂金金額_A+ 訂金金額_B , "9999999.99")#>

	<!---撈取該訂單單號共幾筆預交日--->
	<cfquery name="COPKA2" datasource="#SESSION.COMPANY#">
		SELECT *
		FROM COPKA		
		where 1=1
			AND COPKA.KA001='#KA001#'
			AND COPKA.KA002='#trim(KA002)#'
	
	</cfquery>

	<cfloop query="COPKA2">
	
	<cfquery name="KA019_UPDATE" datasource="#SESSION.COMPANY#">
	UPDATE COPKA SET 
		KA019= KA008 / ISNULL(SUMKA008,0),
		KA013=#訂金合計# * KA008 / ISNULL(SUMKA008,0),
		KA015=
		<cfif #實收訂金日_A# neq "">'#實收訂金日_A#'</cfif>
		<cfif #實收訂金日_A# eq "">''</cfif>
		FROM COPKA
		LEFT JOIN 
			(SELECT KA001,KA002,SUM(KA008) SUMKA008
			FROM COPKA 
			WHERE KA001='#KA001#' AND KA002='#trim(KA002)#'	
			GROUP BY KA001,KA002)COPKA2  ON COPKA2.KA001=COPKA.KA001 AND COPKA2.KA002=COPKA.KA002
		where 1=1
		AND COPKA2.SUMKA008<>0
		AND COPKA.KA001='#KA001#'
		AND COPKA.KA002='#trim(KA002)#'
		AND COPKA.KA003='#KA003#'

		</cfquery>
	</cfloop>
	</cfloop>

</cfif>

<cfif #FORM.SUBMIT# EQ "尾款回推">
	<cfquery name="COPKC_DELETE" datasource="#SESSION.COMPANY#">	
		DELETE COPKC
	</cfquery>

	<!---計算結帳單身比率--->
	<cfquery name="ACRTB_UDF05" datasource="#SESSION.COMPANY#">	
		UPDATE ACRTB SET UDF06=(A1.TB017+A1.TB018)/SUMTB01718
		FROM ACRTB A1		
		JOIN
			(SELECT TB001,TB002,SUM(TB017+TB018) SUMTB01718
			FROM ACRTB
			GROUP BY TB001,TB002)AS A2 ON A2.TB001=A1.TB001 AND A2.TB002=A1.TB002	
	    WHERE SUMTB01718 <> 0
	</cfquery>
		
		<!---計算銷貨單身比率--->
	<cfquery name="COPTH_UDF06" datasource="#SESSION.COMPANY#">	
		UPDATE COPTH SET UDF06=(A1.TH035+A1.TH036)/SUMTH03536
		FROM COPTH A1		
		JOIN
			(SELECT TH001,TH002,SUM(TH035+TH036) SUMTH03536
			FROM COPTH
			GROUP BY TH001,TH002)AS A2 ON A2.TH001=A1.TH001 AND A2.TH002=A1.TH002	
	    WHERE SUMTH03536 <> 0
	</cfquery>

	<!---逐筆結帳--->
	<cfquery name="ACRTC" datasource="#SESSION.COMPANY#">	
	SELECT 	ROUND(ACR.TD014*ACRTB.UDF06,4) 收款金額,
	<!---(CASE WHEN (TB017+TB018 - ACR.TD014) <= 0 THEN (TB017+TB018)  WHEN  TB017+TB018 - ACR.TD014 > 0 THEN  ACR.TD014  END) AS 收款金額	--->
	TC003 收款日期, COP.TD001,COP.TD002,COP.TD003
	FROM ACRTD ACR
	JOIN ACRTC ON TC001=ACR.TD001 AND TC002=ACR.TD002
	JOIN ACRTB ON TB001=ACR.TD006 AND TB002 =ACR.TD007
	JOIN COPTH ON TB005=TH001 AND TB006=TH002 AND TB007=TH003
	
	
	JOIN COPTD COP ON COP.TD001=TH014 AND COP.TD002=TH015 AND COP.TD003=TH016	
	WHERE 1=1
		AND ACR.TD005='4'
		AND ACR.TD020='Y'
		AND TB012='Y'
		AND TH020='Y'         
		AND COP.TD021='Y'
	</cfquery>
	
	<cfloop query="ACRTC">
		<!---查詢該單號的最大序號--->
		<cfquery name="COPKC_KC001" datasource="#SESSION.COMPANY#">
			SELECT MAX(KC001) +1 AS MAX_KC001
			FROM COPKC
			WHERE  1=1
		</cfquery>
		
		<!---設定序號--->
		<cfloop query="COPKC_KC001">
			<cfif #MAX_KC001# EQ "">
				<cfset SN = 00000001>
			<cfelse>
				<cfset SN = #NUMBERFORMAT(MAX_KC001,"00000000")#>
			</cfif>
		</cfloop>
		
		<cfquery name="COPKC_INSERT" datasource="#SESSION.COMPANY#">	
			INSERT COPKC (KC001,KC002,KC003,KC004,KC005,KC006)
			VALUES 
			('#SN#','#TD001#','#TD002#','#TD003#',#numberformat(收款金額,"999999999.9999")#,'#收款日期#')
		</cfquery>	
	</cfloop>
	
<!---	<cfquery name="COPKA" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKA	
	WHERE 1=1 
		AND KA004 LIKE '#FORM.KA004#%'
	</cfquery>

	
		<cfloop query="COPKA">
		<cfset KA001=#KA001#>
		<cfset KA002=#KA002#>
		<cfset KA003=#KA003#>
		<cfset 尾款實收日="">
		<cfset 尾款實收日_A="">
		<cfset 尾款實收日_old="">	
		<cfset 尾款實收款=0>
		
		<!---撈出符合預交日的訂單單號+序號  --->
		<cfquery name="COPTD" datasource="#SESSION.COMPANY#">
		SELECT *
		FROM COPTD
		WHERE 1=1
			AND TD001='#KA001#'
			AND TD002='#TRIM(KA002)#'	
			AND TD047='#KA003#'
			AND TD021='Y'
		</cfquery>
		
		<cfloop query="COPTD">
			<cfset TD001=#TD001#>
			<cfset TD002=#TD002#>
			<cfset TD003=#TD003#>
			<cfquery name="COPKC" datasource="#SESSION.COMPANY#">
			SELECT *
			FROM COPKC
			WHERE 1=1
				AND KC002='#TD001#'
				AND KC003='#TRIM(TD002)#'	
				AND KC004='#TD003#'
			</cfquery>
			<cfloop query = "COPKC">
				<cfset 尾款實收日=#KC006#>
				<cfset 尾款實收款=尾款實收款+#KC005#>
				
				<cfif #尾款實收日# neq #尾款實收日_old#> 
					<cfset 尾款實收日_A=尾款實收日_A&#MID(KC006,1,4)#&"-"&#MID(KC006,5,2)#&"-"&#MID(KC006,7,2)#&"<BR>">
				</cfif>
				
				<cfset 尾款實收日_old = #尾款實收日# >
				
			</cfloop>
		</cfloop>

			<cfquery name="COPKA_UPDATE" datasource="#SESSION.COMPANY#">
			UPDATE COPKA 
			SET KA016 = #NUMBERFORMAT(尾款實收款,"99999999.99")#,
					KA018 ='#尾款實收日_A#'

			WHERE 1=1
				AND KA001='#KA001#'
				AND KA002='#TRIM(KA002)#'	
				AND KA003='#KA003#'
			</cfquery>
			
		<cfquery name="KA020_UPDATE" datasource="#SESSION.COMPANY#">
			UPDATE COPKA
					SET 	KA020=ROUND((KA016 / KA008),4)
			FROM COPKA
			
			WHERE 1=1
				AND KA008<>0
				AND KA004 LIKE '#FORM.KA004#%'
		</cfquery>	
	</cfloop>
--->	
	<!---整單結帳--->
	<cfquery name="ACRTC2" datasource="#SESSION.COMPANY#">	
	SELECT 	ROUND(ACR.TD014*COPTH.UDF06,4) 收款金額,
	<!---(CASE WHEN (TB017+TB018 - ACR.TD014) <= 0 THEN (TB017+TB018)  WHEN  TB017+TB018 - ACR.TD014 > 0 THEN  ACR.TD014  END) AS 收款金額	--->
	TC003 收款日期, COP.TD001,COP.TD002,COP.TD003
	FROM ACRTD ACR
	JOIN ACRTC ON TC001=ACR.TD001 AND TC002=ACR.TD002
	JOIN ACRTB ON TB001=ACR.TD006 AND TB002 =ACR.TD007
	JOIN COPTH ON TB005=TH001 AND TB006=TH002 AND TB007=''
	JOIN COPTD COP ON COP.TD001=TH014 AND COP.TD002=TH015 AND COP.TD003=TH016	
	WHERE 1=1
		AND ACR.TD005='4'
		AND ACR.TD020='Y'
		AND TB012='Y'
		AND TH020='Y'         
		AND COP.TD021='Y'
	</cfquery>
	
	<cfloop query="ACRTC2">
		<!---查詢該單號的最大序號--->
		<cfquery name="COPKC_KC001" datasource="#SESSION.COMPANY#">
			SELECT MAX(KC001) +1 AS MAX_KC001
			FROM COPKC
			WHERE  1=1
		</cfquery>
		
		<!---設定序號--->
		<cfloop query="COPKC_KC001">
			<cfif #MAX_KC001# EQ "">
				<cfset SN = 00000001>
			<cfelse>
				<cfset SN = #NUMBERFORMAT(MAX_KC001,"00000000")#>
			</cfif>
		</cfloop>
		
		<cfquery name="COPKC_INSERT" datasource="#SESSION.COMPANY#">	
			INSERT COPKC (KC001,KC002,KC003,KC004,KC005,KC006)
			VALUES 
			('#SN#','#TD001#','#TD002#','#TD003#',#numberformat(收款金額,"999999999.9999")#,'#收款日期#')
		</cfquery>	
	</cfloop>
	
	<cfquery name="COPKA" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKA	
	WHERE 1=1 
		AND KA004 LIKE '#FORM.KA004#%'
	</cfquery>

	
	<cfloop query="COPKA">
		<cfset KA001=#KA001#>
		<cfset KA002=#KA002#>
		<cfset KA003=#KA003#>
		<cfset 尾款實收日="">
		<cfset 尾款實收日_A="">
		<cfset 尾款實收日_old="">	
		<cfset 尾款實收款=0>
		
		<!---撈出符合預交日的訂單單號+序號  --->
		<cfquery name="COPTD" datasource="#SESSION.COMPANY#">
		SELECT *
		FROM COPTD
		WHERE 1=1
			AND TD001='#KA001#'
			AND TD002='#TRIM(KA002)#'	
			AND TD047='#KA003#'
			AND TD021='Y'
		</cfquery>
		
		<cfloop query="COPTD">
			<cfset TD001=#TD001#>
			<cfset TD002=#TD002#>
			<cfset TD003=#TD003#>
			<cfquery name="COPKC" datasource="#SESSION.COMPANY#">
			SELECT *
			FROM COPKC
			WHERE 1=1
				AND KC002='#TD001#'
				AND KC003='#TRIM(TD002)#'	
				AND KC004='#TD003#'
			</cfquery>
			<cfloop query = "COPKC">
				<cfset 尾款實收日=#KC006#>
				<cfset 尾款實收款=尾款實收款+#KC005#>
				
				<cfif #尾款實收日# neq #尾款實收日_old#> 
					<cfset 尾款實收日_A=尾款實收日_A&#MID(KC006,1,4)#&"-"&#MID(KC006,5,2)#&"-"&#MID(KC006,7,2)#&"<BR>">
				</cfif>
				
				<cfset 尾款實收日_old = #尾款實收日# >
				
			</cfloop>
		</cfloop>

			<cfquery name="COPKA_UPDATE" datasource="#SESSION.COMPANY#">
			UPDATE COPKA 
			SET KA016 = #NUMBERFORMAT(尾款實收款,"99999999.99")#,
					KA018 ='#尾款實收日_A#'

			WHERE 1=1
				AND KA001='#KA001#'
				AND KA002='#TRIM(KA002)#'	
				AND KA003='#KA003#'
			</cfquery>
	
			<cfset aa=0>
			<cfset KA008=#KA008#>

			<cfif #KA013# GT 0 AND #尾款實收款# GT 0>
				<cfif #尾款實收款#-#KA013# gt -1 and #尾款實收款#-#KA013# lt 1 > <!---尾款-訂金    金額很小時--->
					<cfset aa=0>
				<cfelse>
					<cfif #尾款實收款#-#KA013#-#KA008# LTe 1.5 AND #尾款實收款#-#KA013#-#KA008# GTE -1.5> <!---尾款-訂金-原訂單金額    金額很小時--->
						<cfset aa=#KA008#><!---訂單金額--->
					<cfelse>
						<cfset aa=#尾款實收款#-#KA013#><!---訂單金額--->
					</cfif>
				</cfif>
			<cfelse>
				<cfquery name="COPTD2" datasource="#SESSION.COMPANY#"><!---收款金額--->
				SELECT  ISNULL(SUM(KC005),0) SUMKC005
					FROM COPKC
					WHERE RTRIM(KC002)+RTRIM(KC003)+RTRIM(KC004) IN 
					(SELECT  RTRIM(TD001)+RTRIM(TD002)+RTRIM(TD003)
					FROM COPTD
					
					where 1=1
						AND TD001='#KA001#'
						AND TD002='#trim(KA002)#'
						AND TD047='#KA003#'
						AND TD021='Y')
				</cfquery>	
				
				<cfif #COPTD2.RecordCount# gt 0>
					<cfloop query ="COPTD2">
						<cfif #SUMKC005# gt 1 or  #SUMKC005# lt -1  >
						
							<cfif #SUMKC005# - #KA008# LTe 1.5 AND #SUMKC005# - #KA008# GTE -1.5>
								<cfset aa=#KA008#>
							<cfelse>
								<cfset aa=#SUMKC005#>
							</cfif>
						<cfelse>
							<cfset aa=0>
						</cfif>
					</cfloop>
				<cfelse>
						<cfset aa=0>
				</cfif>
			</cfif>
	
		<cfquery name="KA020_UPDATE" datasource="#SESSION.COMPANY#">
			UPDATE COPKA
					SET 	KA020=ROUND(((#aa#+KA013) / KA008),4)
			FROM COPKA
			
			WHERE 1=1
				AND KA008<>0
				AND KA001='#KA001#'
				AND KA002='#KA002#'
				AND KA003='#KA003#'

		</cfquery>	
		
	</cfloop>	
	
	
</cfif>

<cflocation url="COPKA.cfm?KA001=#URL.KA001#&KA004=#URL.KA004#">

</cfoutput>

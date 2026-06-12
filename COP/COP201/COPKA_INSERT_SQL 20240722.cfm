<!---新增訂單單頭資料--->
<cfoutput>
<cfinclude template="/EMG/menu.cfm">

<cfif #FORM.SUBMIT# EQ "新增">
	<!---新增訂單單頭--->
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
    
	<!---新增訂單單頭--->
	<cfquery datasource="#SESSION.COMPANY#" name="COPTC">
			SELECT MA001,MA002,TD001,TD002,TD047,TC008,SUM(TD012)
			FROM COPTD
			JOIN COPTC ON TC001=TD001 AND TC002=TD002
			JOIN COPMA ON MA001=TC004			
			WHERE 1=1
				AND TD021='Y' 
				AND TD047 LIKE '#FORM.KA004#%'
			GROUP BY MA001,MA002,TD001,TD002,TD047,TC008

	</cfquery>

	<cfloop query="COPTC">
	<!---新增訂單單頭--->
	<cfquery datasource="#SESSION.COMPANY#" name="COPKA_INSERT">
			INSERT dbo.COPKA  (KA001,KA002,KA003,KA004,KA005,KA006,KA007,KA008,KA009,KA010,
													KA011,KA012,KA013,KA014,KA015,KA016,KA017,KA018,KA019,KA020)
		   VALUES ('#TD001#','#TD002#','#TD047#','#FORM.KA004#','','','',0,0,0,
		   					'','',0,'','',0,'','',0,0)
	</cfquery>
	</cfloop>
</cfif>


<cfif #FORM.SUBMIT# EQ "更新">
	<!---更新維護檔的原幣金額--->
	<cfquery name="COPKA" datasource="#SESSION.COMPANY#">
		SELECT *
		FROM COPKA	
		WHERE 1=1 
			AND KA004 LIKE '#FORM.KA004#%'
	</cfquery>
	
	<cfloop query="COPKA">		
		<cfquery name="KA008_UPDATE" datasource="#SESSION.COMPANY#">	
			UPDATE COPKA 
			SET KA008=ISNULL(SUMTD012,0),
					KA010=ISNULL(DAYCOUNT,0)

			FROM COPKA	
			JOIN
			(SELECT TD001,TD002,TD047,			
			CASE TC016
			WHEN '2' THEN ROUND(SUM(TD012*1.05) ,0)
			WHEN '1' THEN SUM(TD012) 
			ELSE SUM(TD012) END  SUMTD012 ,
			
			DATEDIFF(day, convert(datetime, TD013, 121), getdate()) DAYCOUNT
			FROM COPTD
			JOIN COPTC ON TC001=TD001 AND TC002=TD002
			WHERE TD021='Y'
			GROUP BY TD001,TD002,TD047,TD013,TC016
			) AS COPTD ON TD001=KA001 AND TD002=KA002 AND TD047=KA003
				AND KA004 LIKE '#FORM.KA004#%'
		</cfquery>

		<cfquery name="KA010_UPDATE" datasource="#SESSION.COMPANY#">	
			UPDATE COPKA 
			SET KA010=0
			FROM COPKA	
			WHERE 1=1
				AND KA004 LIKE '#FORM.KA004#%'
				AND (KA008 - KA009) <=0
		</cfquery>

	</cfloop>	
<!---更新維護檔的尾款實收金額--->
	<cfloop query="COPKA">
		<cfset KA001=#KA001#>
		<cfset KA002=#KA002#>
		<cfset KA003=#KA003#>
		<cfset 尾款實收日="">
		<cfset 尾款實收款=0>
		<cfset 尾款預收日="">
		<!---撈出符合訂單+預交日的結帳金額  --->
		<cfquery name="ACRTB_TB1718" datasource="#SESSION.COMPANY#">
		
					SELECT (TB017+TB018) SUMTB1718
						FROM ACRTB
						WHERE TB005+RTRIM(TB006) +TB007 IN 
						(
						SELECT TH001+RTRIM(TH002)+TH003
						FROM COPTH 
						WHERE TH014+RTRIM(TH015)+TH016 IN 
						(
						SELECT TD001+RTRIM(TD002)+TD003
						FROM COPKA
						JOIN COPTD ON KA001=TD001 AND KA002=TD002 AND KA003=TD047
						WHERE KA001='#KA001#'
							AND KA002='#KA002#'
							AND KA003='#KA003#'
						))
		</cfquery>
		
		<cfloop query="ACRTB_TB1718"><cfset 尾款實收款=尾款實收款+#SUMTB1718#></cfloop>
		
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

			<!---撈出符合訂單單號、序號的銷貨單--->
			<cfquery name="COPTH" datasource="#SESSION.COMPANY#">
			SELECT *
			FROM COPTH
			WHERE 1=1
				AND TH014='#TD001#'
				AND TH015='#TRIM(TD002)#'
				AND TH016='#TD003#'
				AND TH020='Y'
			</cfquery>
			
			<cfloop query="COPTH">
				<cfset TH001=#TH001#>
				<cfset TH002=#TH002#>
				<cfset TH003=#TH003#>
				
			<!---撈出符合銷貨單號、序號的結帳單--->
				<cfquery name="ACRTB" datasource="#SESSION.COMPANY#">
					SELECT *
					FROM ACRTB
					JOIN ACRTA ON TA001=TB001 AND TA002=TB002 
					WHERE 1=1
					 	AND TB005='#TH001#'
						AND TB006='#TRIM(TH002)#'
						--AND TB007='#TH003#'
						AND TB012='Y'
				</cfquery>
				
				
					<cfif #ACRTB.RECORDCOUNT# GT 0>		
					<cfloop query="ACRTB">		
						<cfset TB001=#TB001#>
						<cfset TB002=#TB002#>
						
						<cfset 尾款預收日=#尾款預收日#&#TA020#>
						
						<!---撈出所有符合結帳單的所有款單--->
						<cfquery name="ACRTD" datasource="#SESSION.COMPANY#">
							SELECT *,TC003 收款日期
							FROM ACRTD
							JOIN ACRTC ON TC001=TD001 AND TC002=TD002
							WHERE 1=1
								AND TD006='#TB001#'
								AND TD007='#TB002#'
								AND TD005='4'
								AND TD020='Y'
						</cfquery>					

							<cfloop query="ACRTD"><cfset 尾款實收日=#尾款實收日#&#收款日期#></cfloop>									
						
					</cfloop>			

						
					<cfelse>
						<cfquery name="CMSNA" datasource="#SESSION.COMPANY#">
							SELECT convert(datetime, KA003, 112)+CMSNA.UDF06  尾款預收日
							FROM COPKA
							JOIN COPTC ON KA001=TC001 AND KA002=TC002
							JOIN CMSNA ON TC042=NA002 AND NA001='2'
							WHERE 1=1
								AND TC001='#KA001#'
								AND TC002='#KA002#'							
						</cfquery>
						
						<cfloop query ="CMSNA"><cfset 尾款預收日 =#尾款預收日#></cfloop>
						
						<cfquery name="KA018_UPDATE" datasource="#SESSION.COMPANY#">
									UPDATE COPKA
									SET 	KA017='#MID(尾款預收日,1,4)#'+'-'+'#MID(尾款預收日,5,2)#'+'-'+'#MID(尾款預收日,7,2)#'
									
									FROM COPKA
					
									WHERE 1=1
										AND KA001='#KA001#'
										AND KA002='#KA002#'
										AND KA003='#KA003#'
								</cfquery>
					
					</cfif>			

			</cfloop>		
										
		</cfloop>
				<!---更新COPKA的尾款預收日--->
		<cfquery name="KA016_UPDATE" datasource="#SESSION.COMPANY#">
			UPDATE COPKA
			SET 	KA016=#尾款實收款#,
					KA017=
					<cfif #尾款預收日# neq "">'#MID(尾款預收日,1,4)#'+'-' +'#MID(尾款預收日,5,2)#'+'-'+'#MID(尾款預收日,7,2)#',</cfif>
					<cfif #尾款預收日# eq "">'',</cfif>
					KA018 =
					<cfif #尾款實收日# neq "">'#MID(尾款實收日,1,4)#'+'-' +'#MID(尾款實收日,5,2)#'+'-'+'#MID(尾款實收日,7,2)#'</cfif>
					<cfif #尾款實收日# eq "">''</cfif>
			FROM COPKA							
			WHERE 1=1
				AND KA001='#KA001#'
				AND KA002='#KA002#'
				AND KA003='#KA003#'
		</cfquery>

		
	</cfloop>
	<cfquery name="KA019_UPDATE" datasource="#SESSION.COMPANY#">
		UPDATE COPKA
				SET 	KA020=KA016 / KA008
		FROM COPKA
		
		WHERE 1=1
			AND KA008<>0
			AND KA004 LIKE '#FORM.KA004#%'
	</cfquery>	
	

</cfif>			




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
	<cfloop query="ACRTD"><cfset 訂金金額_A=#訂金金額#><cfset 實收訂金日_A=#TC003#></cfloop>
	
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
	<cfloop query="ACRTB"><cfset 訂金金額_B=#訂金金額#><cfset 實收訂金日_B=#TA003#></cfloop>
	
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
		<cfif #實收訂金日_A# neq "">'#MID(實收訂金日_A,1,4)#'+'-' +'#MID(實收訂金日_A,5,2)#'+'-'+'#MID(實收訂金日_A,7,2)#'+'<br>'</cfif>
		<cfif #實收訂金日_B# neq "">'#MID(實收訂金日_B,1,4)#'+'-' +'#MID(實收訂金日_B,5,2)#'+'-'+'#MID(實收訂金日_B,7,2)#+'<br>'</cfif>
		<cfif #實收訂金日_A# eq "" and #實收訂金日_B# eq "">''</cfif>
		FROM COPKA
		LEFT JOIN 
			(SELECT KA001,KA002,SUM(KA008) SUMKA008
			FROM COPKA 
			WHERE KA001='#KA001#' AND KA002='#KA002#'	
			GROUP BY KA001,KA002)COPKA2  ON COPKA2.KA001=COPKA.KA001 AND COPKA2.KA002=COPKA.KA002
		where 1=1
		AND COPKA2.SUMKA008<>0
		AND COPKA.KA001='#KA001#'
		AND COPKA.KA002='#KA002#'
		AND COPKA.KA003='#KA003#'

		</cfquery>
	</cfloop>
	</cfloop>

</cfif>

<cflocation url="COPKA.cfm?KA001=#URL.KA001#&KA004=#URL.KA004#">

</cfoutput>

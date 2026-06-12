
<!---查詢未詢採購單資料
--->

<cfoutput>

<cfquery datasource="#SESSION.COMPANY#" name="BOMMF">
    SELECT *
	FROM BOMMF
	JOIN INVMB ON MB001=MF001
	WHERE MB025='S' 
</cfquery>

<cfloop query="BOMMF">

<cfquery datasource="#SESSION.COMPANY#" name="PURKA">
    DELETE
	FROM PURKA
	WHERE KA002='#MF001#' AND KA006='#MF004#'
</cfquery>

	<cfquery datasource="#SESSION.COMPANY#" name="MOCTI_SUM">
		SELECT SUBSTRING(TI018,1,4) AS YEAR,TI004,SUM(TI019) AS NUM,SUM(TI025) AS AMOUNT,TI015
		FROM MOCTI
		WHERE 1=1
		AND TI019 <> 0	
		AND TI004 = '#MF001#'
		AND TI015 = '#MF004#'
		GROUP BY SUBSTRING(TI018,1,4),TI004,TI015
		ORDER BY SUBSTRING(TI018,1,4),TI004,TI015
	</cfquery>
	
	
	<cfloop query="MOCTI_SUM">
	
		<cfquery datasource="#SESSION.COMPANY#" name="PURKA_INSERT">
			INSERT INTO PURKA(KA001,KA002,KA003,KA004,KA005,KA006)
			VALUES('#YEAR#','#TRIM(TI004)#',#NUM#,#AMOUNT#,#NUMBERFORMAT(AMOUNT/NUM,"9999999.999")#,
			'#TI015#')
		</cfquery>
	
	</cfloop>

</cfloop>

託外進貨年均價更新完成
</cfoutput>

<cfinclude template="/EMG/footer.cfm">

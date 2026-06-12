<!---更新每年的採購進貨單價到PURKA--->

<cfquery datasource="#SESSION.COMPANY#" name="PURKA">
    DELETE
	FROM PURKA
	WHERE KA006='X'
</cfquery>

<cfquery datasource="#SESSION.COMPANY#" name="PURTH_SUM">
    SELECT SUBSTRING(TH014,1,4) AS YEAR,TH004,SUM(TH015) AS NUM,SUM(TH019) AS AMOUNT
	FROM PURTH
	WHERE 1=1
	AND TH015 <> 0	
    GROUP BY SUBSTRING(TH014,1,4),TH004
	ORDER BY SUBSTRING(TH014,1,4),TH004
</cfquery>

<cfoutput>

<cfloop query="PURTH_SUM">

	<cfquery datasource="#SESSION.COMPANY#" name="PURKA_INSERT">
		INSERT INTO PURKA(KA001,KA002,KA003,KA004,KA005,KA006)
		VALUES('#YEAR#','#TRIM(TH004)#',#NUM#,#AMOUNT#,#NUMBERFORMAT(AMOUNT/NUM,"9999999.999")#,
		'X')
	</cfquery>

</cfloop>

進貨年均價更新完成
</cfoutput>

<cfinclude template="/EMG/footer.cfm">

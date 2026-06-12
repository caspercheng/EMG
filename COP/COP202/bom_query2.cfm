 <!---BOM展階程式--->   
 
<cfoutput>
 
<!---查詢轉手單號最大序號--->
<cfquery datasource="#SESSION.COMPANY#" name="COPKH_KH002">
	SELECT MAX(KH002) +1 AS MAX_KH002
	FROM COPKH
	WHERE  0 = 0
		AND KH001 like '#SESSION.KG001#%'
</cfquery>

<!---若當月份無資料，自動帶出第一筆--->
<cfloop query="COPKH_KH002">
	<cfif #MAX_KH002# EQ "">
		<cfset SN = 0001>
	<cfelse>
		<cfset SN = #NUMBERFORMAT(MAX_KH002,"0000")#>
	</cfif>
</cfloop>

<cfset bomno=bomno+1>
<cfquery datasource="#SESSION.COMPANY#" name="COPKH_INSERT">
	INSERT INTO COPKH(KH001,KH002,KH003,KH004,KH005,KH006,KH007,KH008,KH009,KH010,
											KH011,KH012,KH013,KH014,KH015,KH016,KH017,KH018,KH019)			
	VALUES('#SESSION.KG001#','#SN#','#level#','#MD003#','#NUMBERFORMAT(QTY,"99999.9999")#',
	0,	0,0,'',0,
	0,0,'',	0,0,
	'','','','#MB004#')
</cfquery>
				

<!---展下一階層查詢語法，剔除品號失效的資料---> 
<cfquery datasource="#SESSION.COMPANY#" name="BOMMD" >
SELECT MB001,MB002,MB003,MB004,MB005,MB025,MB068,MB057,MB058,MB010,MB011,
			  MB059,MB060,MB061,MB062,MB063,MB064,MD003,MA002,MB046,MD006,MD008,MB080,MA001
	
FROM BOMMD

LEFT JOIN  INVMB ON MB001 = MD003
LEFT JOIN  PURMA ON MB032 = MA001
WHERE MD001 = '#MD003#'  
		AND ((MD012='' OR MD012> '#MID(FORM.CHECKDATE,1,4)#'+'#MID(FORM.CHECKDATE,6,2)#'+'#MID(FORM.CHECKDATE,9,2)#')	  
		AND (MD011='' OR MD011< '#MID(FORM.CHECKDATE,1,4)#'+'#MID(FORM.CHECKDATE,6,2)#'+'#MID(FORM.CHECKDATE,9,2)#'))
</cfquery>

 
</cfoutput>  
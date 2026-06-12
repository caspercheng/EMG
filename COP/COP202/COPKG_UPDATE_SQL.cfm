<!---資料更新---> 

<cfoutput>
<cfset MB001="">

<!---<cfif #FORM.SUBMIT# EQ "更新">
<cfquery name="COPKE_UPDATE" datasource="#SESSION.COMPANY#">
     UPDATE COPKE SET 
	 KE008 = N'#FORM.KE008#'
     
	 WHERE KE001 = '#TRIM(FORM.KE001)#'
</cfquery>

</cfif>
--->
<cfif #FORM.SUBMIT# EQ "更新核價">
	 <!---撈取本單號的所有品號來計算即可--->
	<cfquery name="COPKG" datasource="#SESSION.COMPANY#">
		 SELECT *
		 FROM COPKH
		 JOIN INVMB ON MB001=KH004
		 WHERE 1=1
			AND KH001= '#TRIM(FORM.KG001)#'
		 ORDER BY MB001    
 
	</cfquery>

	<cfloop query ="COPKG">
		<cfset MB801A=0>
		<cfset MB802A=0>
		<cfset MB803A=0>
		<cfset MB804A=0>
		<cfset MB805A=0>
		<cfset MB806A=0>
		<cfset MB807A="">
		<cfset MB808A="">
		<cfset MA001A="">
		<cfset MA001B="">
		<cfset PNO1="">
		<cfset SNO1="">
		<cfset MG001A="NTD">
		<cfset MG001B="NTD">	 

<!---非主件且品號屬性為P，撈取採購系統核價單價--->	
	 
		<cfif #MB025# EQ "P">
			<cfquery datasource="#SESSION.COMPANY#" name="PURTM_before">
	
				SELECT TOP 1 PURTM.*,TL004,MB004,MA001,TL005
				FROM PURTM
				JOIN PURTL ON TM001=TL001 AND TM002=TL002
				JOIN INVMB ON MB001=TM004
				JOIN PURMA ON MA001=TL004
				WHERE  1=1
					AND TL003 <='#MID(FORM.KG003,1,4)#'+'#MID(FORM.KG003,6,2)#'+'#MID(FORM.KG003,9,2)#'
					AND TM004='#MB001#'
					AND TM011='Y'
					AND TM010>0
				ORDER BY TL003 DESC
			</cfquery>
			
	
			<cfquery datasource="#SESSION.COMPANY#" name="PURTM_after">
	
				SELECT TOP 1 PURTM.*,TL004,MB004,MA001,TL005
				FROM PURTM
				JOIN PURTL ON TM001=TL001 AND TM002=TL002
				JOIN INVMB ON MB001=TM004
				JOIN PURMA ON MA001=TL004
				WHERE  1=1
					AND TL003 >='#MID(FORM.KG003,1,4)#'+'#MID(FORM.KG003,6,2)#'+'#MID(FORM.KG003,9,2)#'
					AND TM004='#MB001#'
					AND TM011='Y'
					AND TM010>0
				ORDER BY TL003 
			</cfquery>
	

		<!---基準日前核價單價且做單位換算	--->	
		
		<cfloop query="PURTM_before">
		
								
		<cfset MG004A=1>
		<cfset MA001A=#MA001#>
		<cfset TM010A=#TM010#>
		<cfset MG001A=#TL005#><!---幣別--->
		
		<cfquery datasource="#SESSION.COMPANY#" name="CMSMG_before">
		SELECT TOP 1 MG004
		FROM CMSMG
		WHERE 1=1
			AND MG001='#MG001A#'
			AND MG002<='#MID(FORM.KG003,1,4)#'+'#MID(FORM.KG003,6,2)#'+'#MID(FORM.KG003,9,2)#'
		ORDER BY MG002 DESC
		</cfquery>
		
		<cfloop query="CMSMG_before"><cfset MG004A=#MG004#></cfloop>

		
		<cfif #MB004# NEQ #TM009#> <!---核價單位不等於庫存單位--->
			<cfquery datasource="#SESSION.COMPANY#" name="INVMD">
			SELECT *
			FROM INVMD
			WHERE 1=1
			AND MD001='#TM004#'
			</cfquery>
			
			<cfloop query="INVMD">
			<cfset MB801A=#TM010A#*#MG004A#/ #MD004#>
			<cfset MB802A=0>			
			</cfloop>
			
		<cfelse>
			<cfset MB801A=#TM010A#*#MG004A#>
			<cfset MB802A=0>
		</cfif>
		
		</cfloop>

		<cfloop query="PURTM_after">
		<cfset MG004B=1>
		<cfset MA001B=#MA001#>
		<cfset TM010B=#TM010#>
		<cfset MG001B=#TL005#><!---幣別--->
		<cfset PNO1=#TM001#&"-"&#TM002#&"-"&#TM003#>			
		
		<cfquery datasource="#SESSION.COMPANY#" name="CMSMG_after">
		SELECT TOP 1 MG004
		FROM CMSMG
		WHERE 1=1
			AND MG001='#MG001B#'
			AND MG002<='#MID(FORM.KG003,1,4)#'+'#MID(FORM.KG003,6,2)#'+'#MID(FORM.KG003,9,2)#'
		ORDER BY MG002 DESC
		</cfquery>
		
		<cfloop query="CMSMG_after"><cfset MG004B=#MG004#></cfloop>

		
		<cfif #MB004# NEQ #TM009#>
				<cfquery datasource="#SESSION.COMPANY#" name="INVMD">
					SELECT *
					FROM INVMD
					WHERE 1=1
						AND MD001='#TM004#'
				</cfquery>
				
				<cfloop query="INVMD">
					<cfset MB804A=#TM010B#*#MG004B#/ #MD004#>
					<cfset MB805A=0>
		
				</cfloop>
			<cfelse>
				<cfset MB804A=#TM010B#*#MG004B#>
				<cfset MB805A=0>
			</cfif>
		
		</cfloop>
			
	
		<!---若無基準日後的核價單，則核價後金額與核價前一樣--->
		<cfif #PURTM_after.recordcount# eq 0><cfset MB804A=#MB801A#></cfif>
	
			<cfquery datasource="#SESSION.COMPANY#" name="INVMB_UPDATE"><!---更新回INVMB的MB801與MB804--->
			UPDATE INVMB 
			SET MB801=#MB801A#,
					MB804=#MB804A#,
					MB807='#MA001A#',
					MB808='#MA001B#',
					MB809='#PNO1#'
			FROM INVMB
			WHERE 1=1
				AND MB001='#MB001#'	
	
			</cfquery>
			
		</cfif>
		
	<!---	非主件且品號屬性為S，撈製令系統加工核價單價		
	---><cfif #MB025# EQ "S">
			<cfquery datasource="#SESSION.COMPANY#" name="MOCTN_before">
	
				SELECT TOP 1 MOCTN.*,TM004,MB004,MA001,TM005
				FROM MOCTN
				JOIN MOCTM ON TM001=TN001 AND TM002=TN002
				JOIN INVMB ON MB001=TN004
				JOIN PURMA ON MA001=TM004
				WHERE  1=1
					AND TM003 <='#MID(FORM.KG003,1,4)#'+'#MID(FORM.KG003,6,2)#'+'#MID(FORM.KG003,9,2)#'
					AND TN004='#MB001#'
					AND TN014='Y'
					AND TN009>0
				ORDER BY TM003 DESC
			</cfquery>
			
			
	
			<cfquery datasource="#SESSION.COMPANY#" name="MOCTN_after">
	
				SELECT TOP 1 MOCTN.*,TM004,MB004,MA001,TM005
				FROM MOCTN
				JOIN MOCTM ON TM001=TN001 AND TM002=TN002
				JOIN INVMB ON MB001=TN004
				JOIN PURMA ON MA001=TM004
				WHERE  1=1
					AND TM003 >='#MID(FORM.KG003,1,4)#'+'#MID(FORM.KG003,6,2)#'+'#MID(FORM.KG003,9,2)#'
					AND TN004='#MB001#'
					AND TN014='Y'
					AND TN009>0
				ORDER BY TM003
			</cfquery>
			
	
			<cfloop query="MOCTN_before">
				<cfset MG004A=1>
				<cfset MA001A=#MA001#>
				<cfset TN009A=#TN009#>
				<cfset MG001A=#TM005#><!---幣別--->
			
				<cfquery datasource="#SESSION.COMPANY#" name="CMSMG_before">
				SELECT TOP 1 MG004
				FROM CMSMG
				WHERE 1=1
					AND MG001='#MG001A#'
					AND MG002<='#MID(FORM.KG003,1,4)#'+'#MID(FORM.KG003,6,2)#'+'#MID(FORM.KG003,9,2)#'
				ORDER BY MG002 DESC
				</cfquery>
				
				<cfloop query="CMSMG_before"><cfset MG004A=#MG004#></cfloop>
				
				
				<cfif #MB004# NEQ #TN008#>
					<cfquery datasource="#SESSION.COMPANY#" name="INVMD">
						SELECT *
						FROM INVMD
						WHERE 1=1
							AND MD001='#TN004#'
					</cfquery>
					<cfloop query="INVMD">
						<cfset MB802A=#TN009A#*#MG004A#/ #MD004#>
						<cfset MB801A=0>
			
					</cfloop>
				<cfelse>
						<cfset MB802A=#TN009A#*#MG004A#>
						<cfset MB801A=0>
				</cfif>

			</cfloop>

			
			<cfloop query="MOCTN_after">
			<cfset MG004B=1>
			<cfset MA001B=#MA001#>
			<cfset TN009B=#TN009#>
			<cfset MG001B=#TM005#><!---幣別--->			
			<cfset SNO1=#TN001#&"-"&#TN002#&"-"&#TN003#>
			
			<cfquery datasource="#SESSION.COMPANY#" name="CMSMG_after">
			SELECT TOP 1 MG004
			FROM CMSMG
			WHERE 1=1
				AND MG001='#MG001B#'
				AND MG002<='#MID(FORM.KG003,1,4)#'+'#MID(FORM.KG003,6,2)#'+'#MID(FORM.KG003,9,2)#'
			ORDER BY MG002 DESC
			</cfquery>
				
				<cfloop query="CMSMG_after"><cfset MG004B=#MG004#></cfloop>
				
			
				<cfif #MB004# NEQ #TN008#>
					<cfquery datasource="#SESSION.COMPANY#" name="INVMD">
						SELECT *
						FROM INVMD
						WHERE 1=1
							AND MD001='#TN004#'
					</cfquery>
					<cfloop query="INVMD">
						<cfset MB805A=#TN009B#*#MG004B#/ #MD004#>
						<cfset MB804A=0>
			
					</cfloop>
				<cfelse>
					<cfset MB804A=0>
					<cfset MB805A=#TN009B#*#MG004B#>
				</cfif>
			</cfloop>
			
			<cfif #MOCTN_after.recordcount# eq 0><cfset MB805A=#MB802A#></cfif>
			<cfquery datasource="#SESSION.COMPANY#" name="INVMB_UPDATE">
			UPDATE INVMB 
			SET MB802=#MB802A#,
					MB805=#MB805A#,
					MB807='#MA001A#',
					MB808='#MA001B#',
					MB809='#SNO1#'
			FROM INVMB
			WHERE 1=1
				AND MB001='#MB001#'		
			</cfquery>
	
		</cfif>	
		</cfloop>
		
	<!---尾階推算上階--->
	<!---
	撈取低階碼不為99的品號，進行多階成本的滾算(從尾階品號開始算)--->
	<cfquery datasource="#SESSION.COMPANY#" name="INVMB_ORDER">
		SELECT RTRIM(MB001) MB001,MB026
		FROM INVMB
		JOIN COPKH ON KH004=MB001
		WHERE  1=1
			AND MB026<>'99'
			AND KH001='#FORM.KG001#'
		ORDER BY MB026 DESC
	</cfquery>
	
	<cfloop query ="INVMB_ORDER">
		<cfinclude template="BOMMC_CHECK.cfm">
	</cfloop>



  <!---將品號金額更新過來---> 
  <cfquery datasource="#SESSION.COMPANY#" name="INVMB_UPDATE" >
    UPDATE COPKH
		SET KH006=MB801,
				KH007=MB802,
				KH008=MB803,
				KH010=MB804,
				KH011=MB805,
				KH012=MB806,
				KH009=MB807,
				KH013=MB808,
				KH016=SUBSTRING(MB809,1,4),
				KH017=SUBSTRING(MB809,6,11),
				KH018=SUBSTRING(MB809,18,4)
	FROM COPKH
	INNER JOIN INVMB ON MB001=KH004
	WHERE KH001='#FORM.KG001#'
  </cfquery>
		
 
<!---  將品號金額更新過來---> 
  <cfquery datasource="#SESSION.COMPANY#" name="COPKH_UPDATE1" >
	 UPDATE COPKH 
 	SET KH008=ROUND(KH008*KH005,2),KH012=ROUND(KH012*KH005,2) 
	WHERE KH001='#FORM.KG001#' AND KH002<>'0000'
	</cfquery>
	
  <cfquery datasource="#SESSION.COMPANY#" name="COPKH_UPDATE2" >
	 UPDATE COPKH 
 	SET KH008=ROUND(KH008*1,2),KH012=ROUND(KH012*1,2) 
	WHERE KH001='#FORM.KG001#' AND KH002='0000'
	</cfquery>
	
	  <cfquery datasource="#SESSION.COMPANY#" name="INVMB_UPDATE" >
		UPDATE COPKG
		SET  KG004=ROUND(KH008,0),
				KG005=ROUND(KH012,0)
		FROM COPKG
		JOIN COPKH ON KG001=KH001 AND KH002='0000'
		WHERE KG001='#FORM.KG001#'
	  </cfquery>


  <cfquery datasource="#SESSION.COMPANY#" name="COPKG_FINAL" >
  	SELECT *
	FROM COPKG
	WHERE KG001='#FORM.KG001#'
  </cfquery>

  <cfloop query="COPKG_FINAL">
  <cfif #KG004# eq 0>
	  <cfquery datasource="#SESSION.COMPANY#" name="COPKG_UPDATE" >
		UPDATE COPKG
		SET  KG006= 1
		FROM COPKG
		JOIN COPKH ON KG001=KH001 AND KH002='0000'
		WHERE KG001='#KG001#'	
	  </cfquery>
	<cfelse>
	  <cfquery datasource="#SESSION.COMPANY#" name="COPKG_UPDATE" >
		UPDATE COPKG
		SET  KG006= (KG005-KG004) / KG004
		FROM COPKG
		JOIN COPKH ON KG001=KH001 AND KH002='0000'
		WHERE KG001='#KG001#'	
	  </cfquery>
	  
	 </cfif>

  </cfloop>
  
		
<!---  將品號金額更新過來---> 
  <cfquery datasource="#SESSION.COMPANY#" name="COPKH" >
    SELECT *
	FROM  COPKH
	WHERE KH001='#FORM.KG001#'
  </cfquery>
  
  <cfloop query="COPKH">
  <cfif #KH006# NEQ #KH010# OR #KH007# NEQ #KH011#>
  <cfquery datasource="#SESSION.COMPANY#" name="KH014_UPDATE" >
    UPDATE COPKH
		SET  KH014=ROUND((KH011-KH007)+(KH010-KH006),2),
				 KH015=((KH011-KH007)+(KH010-KH006))/(KH006+KH007)
	FROM COPKH
	WHERE KH001='#KH001#'
		AND  KH002='#KH002#'
		 AND (KH006+KH007) > 0
  </cfquery>
  
  <cfquery datasource="#SESSION.COMPANY#" name="KH014_UPDATE2" >
    UPDATE COPKH
		SET  KH014=ROUND((KH011-KH007)+(KH010-KH006),2),
				 KH015=1
	FROM COPKH
	WHERE KH001='#KH001#'
		AND  KH002='#KH002#'
		 AND (KH006+KH007) = 0
  </cfquery>

  </cfif>
  </cfloop>
		
</cfif>

<cflocation url="COPKH_UPDATE.cfm?KG001=#FORM.KG001#">


</cfoutput>

<!---查詢品號資料--->
	<cfquery name="INVMB_MD" datasource="#SESSION.COMPANY#">
	   SELECT DISTINCT MB001,MB002,MB003,MB004,MC004,MB005,MB025,MB068,MB057,MB058,MB080,MB010,MB011,
                                        MB059,MB060,MB061,MB062,MB063,MB064,MB046,MA002,1 AS MD006,0 AS MD008,MA001,MB004
	   FROM INVMB
	   LEFT JOIN  PURMA ON MB032 = MA001
	   LEFT JOIN BOMMC ON MC001=MB001
	   WHERE  0 = 0
        AND  MB001 = '#FORM.MB001#' 
	</cfquery>
	
<cfoutput query="INVMB_MD">
	<cfset MB001=#MB001#>
	<cfset MB004=#MB004#>
</cfoutput>
<cfset sn="0010">

<!---查詢BOM表資料--->

<cfquery datasource="#SESSION.COMPANY#" name="INVMB">
    SELECT MB001,MB002,MB003,MB004,MB005,MB025,MB068,MB057,MB058,MB010,MB011,
                  MB059,MB060,MB061,MB062,MB063,MB064,RTRIM(MD003) MD003,MA002,MB046,MD006,MD007,MD008,MB080,MA001
        
    FROM BOMMD
    
    LEFT JOIN  INVMB ON MB001 = MD003
    LEFT JOIN  PURMA ON MB032 = MA001
    WHERE 0=0 
		AND MD001 = '#MB001#' 
		AND ((MD012='' OR MD012> '#MID(FORM.CHECKDATE,1,4)#'+'#MID(FORM.CHECKDATE,6,2)#'+'#MID(FORM.CHECKDATE,9,2)#')	  
		AND (MD011='' OR MD011< '#MID(FORM.CHECKDATE,1,4)#'+'#MID(FORM.CHECKDATE,6,2)#'+'#MID(FORM.CHECKDATE,9,2)#'))
</cfquery>

          
<cfoutput>
  
<cfloop query="INVMB_MD">
<cfset level=".0">
  
  <!---查詢會員編單最大號--->
	<cfquery datasource="#SESSION.COMPANY#" name="COPKG_KG001">
		SELECT MAX(SUBSTRING(KG001,9,3)) +1 AS MAX_KG001
		FROM COPKG
		WHERE  0 = 0
			AND KG001 like '#DATEFORMAT(NOW(),"yyyymmdd")#%'
	</cfquery>
	
	<!---若當月份無資料，自動帶出第一筆--->
	<cfloop query="COPKG_KG001">
		<cfif #MAX_KG001# EQ "">
			<cfset SESSION.KG001 = #DATEFORMAT(NOW(),"yyyymmdd")#&001>
		<cfelse>
			<cfset SESSION.KG001 = #DATEFORMAT(NOW(),"yyyymmdd")#&#NUMBERFORMAT(MAX_KG001,"000")#>
		</cfif>
	</cfloop>
	
	<cfquery name="COPKG_INSERT" datasource="#SESSION.COMPANY#">
			 INSERT INTO COPKG(KG001,KG002,KG003,KG004,KG005,KG006,KG007)    
			 VALUES('#TRIM(SESSION.KG001)#','#MB001#','#FORM.CHECKDATE#',0,0,0,'')
		</cfquery>
  </cfloop>
  
  <cfquery datasource="#SESSION.COMPANY#" name="COPKH_INSERT">
	INSERT INTO COPKH(KH001,KH002,KH003,KH004,KH005,KH006,KH007,KH008,KH009,KH010,
											KH011,KH012,KH013,KH014,KH015,KH016,KH017,KH018,KH019)			
	VALUES('#SESSION.KG001#','0000','#level#','#MB001#','0',
	0,	0,0,'',0,
	0,0,'',	0,0,
	'','','','#MB004#')
</cfquery>

  <cfloop query="INVMB">
	<cfset MD007=#MD007#>
	<cfset level=".1">
	<cfset QTY=#MD006#/#MD007#>
	<cfset QTY1=#MD006#/#MD007#>
	<cfinclude template="bom_query2.cfm">
          
	   <!---第二層--->
       <cfloop query="BOMMD">
       
       <cfset bgcolor ="FFFFCB">
       <cfset level="..2">
		<cfset QTY=QTY1*(#MD006#/#MD007#)>
		<cfset QTY2=QTY1*(#MD006#/#MD007#)>
       <cfinclude template="bom_query2.cfm">

							
			<!---第三層--->
            <cfloop query="BOMMD">
            
            <cfset level="...3">
			<cfset QTY=QTY1*QTY2*(#MD006#/#MD007#)>
			<cfset QTY3=QTY1*QTY2*(#MD006#/#MD007#)>
            <cfinclude template="bom_query2.cfm">
									
				<!---第四層--->
                <cfloop query="BOMMD">
                
                <cfset level="....4">
				<cfset QTY=QTY1*QTY2*QTY3*(#MD006#/#MD007#)>
				<cfset QTY4=QTY1*QTY2*QTY3*(#MD006#/#MD007#)>
                <cfinclude template="bom_query2.cfm">

					<!---第五層--->
                    <cfloop query="BOMMD">
                    
                    <cfset level=".....5">
					<cfset QTY=QTY1*QTY2*QTY3*QTY4*(#MD006#/#MD007#)>
					<cfset QTY5=QTY1*QTY2*QTY3*QTY4*(#MD006#/#MD007#)>
                    <cfinclude template="bom_query2.cfm">

						  <!---第六層--->
                          <cfloop query="BOMMD">
                          
                          <cfset level="......6">
						<cfset QTY=QTY1*QTY2*QTY3*QTY4*QTY5*(#MD006#/#MD007#)>
						<cfset QTY6=QTY1*QTY2*QTY3*QTY4*QTY5*(#MD006#/#MD007#)>
                          <cfinclude template="bom_query2.cfm">

						  <!---第七層--->
                          <cfloop query="BOMMD">
                          
                          <cfset level=".......7">
							<cfset QTY=QTY1*QTY2*QTY3*QTY4*QTY5*QTY6*(#MD006#/#MD007#)>
							<cfset QTY7=QTY1*QTY2*QTY3*QTY4*QTY5*QTY6*(#MD006#/#MD007#)>
                          <cfinclude template="bom_query2.cfm">

						  <!---第八層--->
                          <cfloop query="BOMMD">
                          
                          <cfset level="........8">
							<cfset QTY=QTY1*QTY2*QTY3*QTY4*QTY5*QTY6*QTY7*(#MD006#/#MD007#)>
							<cfset QTY8=QTY1*QTY2*QTY3*QTY4*QTY5*QTY6*QTY7*(#MD006#/#MD007#)>
                          <cfinclude template="bom_query2.cfm">
						  

                          </cfloop>

						  <!---第九層--->
                          <cfloop query="BOMMD">
                          
                          <cfset level=".........9">
							<cfset QTY=QTY1*QTY2*QTY3*QTY4*QTY5*QTY6*QTY7*QTY8*(#MD006#/#MD007#)>
							<cfset QTY9=QTY1*QTY2*QTY3*QTY4*QTY5*QTY6*QTY7*QTY8*(#MD006#/#MD007#)>
                          <cfinclude template="bom_query2.cfm">

                          </cfloop>

						  <!---第十層--->
                          <cfloop query="BOMMD">
                          
                          <cfset level="..........10">
							<cfset QTY=QTY1*QTY2*QTY3*QTY4*QTY5*QTY6*QTY7*QTY8*QTY9*(#MD006#/#MD007#)>
							<cfset QTY10=QTY1*QTY2*QTY3*QTY4*QTY5*QTY6*QTY7*QTY8*QTY9*(#MD006#/#MD007#)>
                          <cfinclude template="bom_query2.cfm">

                          </cfloop>

                          </cfloop>
                          </cfloop>
					 </cfloop>
				  </cfloop>
               </cfloop>
		  </cfloop>
    </cfloop>
	

 </cfoutput>	
   
	  
<!---<cfinclude template="/#SESSION.COMPANY#/footer.cfm">
<cfinclude template="/#SESSION.COMPANY#/close_window.cfm">
--->
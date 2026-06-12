
<title>產品相關材料每年進價表</title>

<h4 align="center">產品相關材料每年進價表</h4>

<!---查詢品號資料--->
	<cfquery name="INVMB_MD" datasource="#SESSION.COMPANY#">
	   SELECT DISTINCT MB001,MB002,MB003,MB004,MC004
	   FROM INVMB
	   LEFT JOIN BOMMC ON MC001=MB001
	   WHERE  0 = 0
        AND  MB001 = '#TRIM(URL.MB001)#' 
	</cfquery>
	
<cfoutput query="INVMB_MD"><cfset MB001=#MB001#>	</cfoutput>
<cfset sn="0010">

<!---查詢BOM表資料--->

<cfquery datasource="#SESSION.COMPANY#" name="INVMB">
   SELECT MD001,MD003,MD011,MD012,MB002,MD006,MB003,MB064,MB013,MB032,MB050,MB057,MB060,MD007,MB025,MB017
    ,(MB057*MD006/MD007) AS MD087,MB068,MA002,
	PURKA_2022.KA005 AS KA005_2023,
	PURKA_2022.KA005 AS KA005_2022,
	PURKA_2021.KA005 AS KA005_2021,
	PURKA_2020.KA005 AS KA005_2020,
	PURKA_2019.KA005 AS KA005_2019,
	PURKA_2018.KA005 AS KA005_2018
	
    FROM BOMMD  
    JOIN INVMB ON MB001 = MD003
	LEFT JOIN PURMA ON MA001=MB032
    LEFT JOIN (SELECT KA001,KA002,SUM(KA005) AS KA005
						FROM PURKA
						WHERE KA001='2023'
						GROUP BY KA001,KA002) AS PURKA_2023 ON  PURKA_2023.KA002=MB001
    LEFT JOIN (SELECT KA001,KA002,SUM(KA005) AS KA005
						FROM PURKA
						WHERE KA001='2022'
						GROUP BY KA001,KA002) AS PURKA_2022 ON  PURKA_2022.KA002=MB001
    LEFT JOIN (SELECT KA001,KA002,SUM(KA005) AS KA005
						FROM PURKA
						WHERE KA001='2021'
						GROUP BY KA001,KA002) AS PURKA_2021 ON  PURKA_2021.KA002=MB001
    LEFT JOIN (SELECT KA001,KA002,SUM(KA005) AS KA005
						FROM PURKA
						WHERE KA001='2020'
						GROUP BY KA001,KA002) AS PURKA_2020 ON  PURKA_2020.KA002=MB001
    LEFT JOIN (SELECT KA001,KA002,SUM(KA005) AS KA005
						FROM PURKA
						WHERE KA001='2019'
						GROUP BY KA001,KA002) AS PURKA_2019 ON  PURKA_2019.KA002=MB001
    LEFT JOIN (SELECT KA001,KA002,SUM(KA005) AS KA005
						FROM PURKA
						WHERE KA001='2018'
						GROUP BY KA001,KA002) AS PURKA_2018 ON  PURKA_2018.KA002=MB001
    
    WHERE 0=0 AND MD001 = '#MB001#'
	ORDER BY MD002
</cfquery>
      
<cfoutput>
  
<cfloop query="INVMB_MD">
 主件品號：<strong>#MB001#</strong><BR />
 品名：<strong>#MB002#</strong><BR />
 規格：<strong>#MB003#</strong><BR />
 單位：<strong>#MB004#</strong><BR />
 標準批量：<strong>#MC004#</strong>
</cfloop>


 <!---第一層--->
<table border="1">

    <tr bgcolor="666666" style="color:FFF">
     <td>階次</td>
     <td>材料品號</td>
     <td>品名/規格</td>
     <td>屬性</td>
     <td>主供應商</td>
     <td>生效日</td>
     <td>失效日</td>
     <td>用量</td>
     <td>2023</td>
     <td>2022</td>
     <td>2021</td>
     <td>2020</td>
     <td>2019</td>
     <td>2018</td>
     <td>進貨明細</td>
    </tr>
          
 
  <cfloop query="INVMB">
      
  <cfset bgcolor ="99CC99">
  <cfset level=".1">
  <cfinclude template="bom_query.cfm">
          
	   <!---第二層--->
       <cfloop query="BOMMD">
       
       <cfset bgcolor ="CCCCFF">
       <cfset level=".2">
       <cfinclude template="bom_query.cfm">
							
			<!---第三層--->
            <cfloop query="BOMMD">
            
            <cfset bgcolor ="99CCFF">
            <cfset level=".3">
            <cfinclude template="bom_query.cfm">
									
				<!---第四層--->
                <cfloop query="BOMMD">
                
                <cfset bgcolor ="FFFFCC">
                <cfset level=".4">
                <cfinclude template="bom_query.cfm">

					<!---第五層--->
                    <cfloop query="BOMMD">
                    
                    <cfset bgcolor ="FFFFCC">
                    <cfset level=".5">
                    <cfinclude template="bom_query.cfm">

						  <!---第六層--->
                          <cfloop query="BOMMD">
                          
                          <cfset bgcolor ="FFFFCC">
                          <cfset level=".6">
                          <cfinclude template="bom_query.cfm">
									   
                          </cfloop>
					 </cfloop>
				  </cfloop>
               </cfloop>
		  </cfloop>
    </cfloop>
   

</table>
	  
 </cfoutput>	

<cfinclude template="/EMG/close_window.cfm">
<cfinclude template="/EMG/footer.cfm">

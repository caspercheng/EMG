	
 <!---BOM展階程式--->   
 
<cfoutput>
 
  <!---秀上階BOM展階資料---> 
  <tr>
   <td align="center">#level#</td>
   <td>#MD003#</td>
   <td width="500">#MB002#<BR/>#MB003#</td>
	<TD align="center">
		  <cfif #MB025# EQ "M"><span class="badge badge-secondary">自製件</span></cfif>	
		  <cfif #MB025# EQ "P"><span class="badge badge-warning">採購件</span></cfif>
		  <cfif #MB025# EQ "S"><span class="badge badge-success">加工件</span></cfif>
		  <cfif #MB025# EQ "Y"><span class="badge badge-light">虛設件</span></cfif>
		  <cfif #MB025# EQ "F"><span class="badge badge-info">選配件</span></cfif>
	</TD> 
   <td>#MA002#</td>
   <td><cfif #MD011# gt "">#MID(MD011,1,4)#-#MID(MD011,5,2)#-#MID(MD011,7,2)#</cfif></td>
   <td><cfif #MD012# gt "">#MID(MD012,1,4)#-#MID(MD012,5,2)#-#MID(MD012,7,2)#</cfif></td>
   <td  align="center">#NUMBERFORMAT(MD006/MD007,"999,999.99")#</td>
   <td align="right">
      <cfif KA005_2023 gt 0> #NUMBERFORMAT(KA005_2023,"999999.99")#<cfelse>0</cfif>
   </td>
   <td align="right">
      <cfif KA005_2022 gt 0> #NUMBERFORMAT(KA005_2022,"999999.99")#<cfelse>0</cfif>
   </td>
   <td align="right">
      <cfif KA005_2021 gt 0>#NUMBERFORMAT(KA005_2021,"999999.99")#<cfelse>0</cfif>
   </td>
   <td align="right">
      <cfif KA005_2020 gt 0>#NUMBERFORMAT(KA005_2020,"999999.99")#	 <cfelse>0</cfif>
   </td>
   <td align="right">
       <cfif KA005_2019 gt 0>#NUMBERFORMAT(KA005_2019,"999999.99")#	<cfelse>0</cfif>
   </td>
   <td align="right">
       <cfif KA005_2018 gt 0>#NUMBERFORMAT(KA005_2018,"999999.99")#<cfelse>0</cfif>
   </td>
   <td align="center">
      <cfif #MB025# EQ "P">
		  <a href="PURTH.cfm?MD003=#TRIM(MD003)#" target="_blank">明細</a>
	  </cfif>
      <cfif #MB025# EQ "S">
		  <a href="MOCTI.cfm?MD003=#TRIM(MD003)#" target="_blank">明細</a>
	  </cfif>
	</td>
  </tr>
  
  <!---委外件展出途程資料---> 
  <cfif #MB025# EQ "S">
  
	  <cfquery datasource="#SESSION.COMPANY#" name="BOMMF" >
		SELECT MF003,MF007,MF018,MW002,
					PURKA_2023.KA005 AS KA005_2023,
					PURKA_2022.KA005 AS KA005_2022,
					PURKA_2021.KA005 AS KA005_2021,
					PURKA_2020.KA005 AS KA005_2020,
					PURKA_2019.KA005 AS KA005_2019,
					PURKA_2018.KA005 AS KA005_2018
					
		FROM BOMMF
		JOIN CMSMW ON MW001=MF004
		LEFT JOIN (SELECT KA001,KA002,KA006,SUM(KA005) AS KA005
							FROM PURKA
							WHERE KA001='2023'
							GROUP BY KA001,KA002,KA006) AS PURKA_2023 ON  PURKA_2023.KA002=MF001 AND PURKA_2023.KA006=MF004
		LEFT JOIN (SELECT KA001,KA002,KA006,SUM(KA005) AS KA005
							FROM PURKA
							WHERE KA001='2022'
							GROUP BY KA001,KA002,KA006) AS PURKA_2022 ON  PURKA_2022.KA002=MF001 AND PURKA_2022.KA006=MF004
		LEFT JOIN (SELECT KA001,KA002,KA006,SUM(KA005) AS KA005
							FROM PURKA
							WHERE KA001='2021'
							GROUP BY KA001,KA002,KA006) AS PURKA_2021 ON  PURKA_2021.KA002=MF001 AND PURKA_2021.KA006=MF004
		LEFT JOIN (SELECT KA001,KA002,KA006,SUM(KA005) AS KA005
							FROM PURKA
							WHERE KA001='2020'
							GROUP BY KA001,KA002,KA006) AS PURKA_2020 ON  PURKA_2020.KA002=MF001 AND PURKA_2020.KA006=MF004
		LEFT JOIN (SELECT KA001,KA002,KA006,SUM(KA005) AS KA005
							FROM PURKA
							WHERE KA001='2019'
							GROUP BY KA001,KA002,KA006) AS PURKA_2019 ON  PURKA_2019.KA002=MF001 AND PURKA_2019.KA006=MF004
		LEFT JOIN (SELECT KA001,KA002,KA006,SUM(KA005) AS KA005
							FROM PURKA
							WHERE KA001='2018'
							GROUP BY KA001,KA002,KA006) AS PURKA_2018 ON  PURKA_2018.KA002=MF001 AND PURKA_2018.KA006=MF004		
		
		WHERE MF001 = '#MD003#'
	  </cfquery>
	
	  <cfloop query="BOMMF">
	  
	   <tr>
		   <td align="center"></td>
		   <td align="center"></td>
		   <td >#MF003#-#MW002#</td>
		   <td align="center"><span class="badge badge-primary">製程</span></td>
		   <td >#MF007#</td>
		   <td align="center"></td>
		   <td align="center"></td>
		   <td align="center"></td>
		   <td align="right">
			  <cfif KA005_2023 gt 0> #NUMBERFORMAT(KA005_2023,"999999.99")#<cfelse>0</cfif>
		   </td>
		   <td align="right">
			  <cfif KA005_2022 gt 0> #NUMBERFORMAT(KA005_2022,"999999.99")#<cfelse>0</cfif>
		   </td>
		   <td align="right">
			  <cfif KA005_2021 gt 0>#NUMBERFORMAT(KA005_2021,"999999.99")#<cfelse>0</cfif>
		   </td>
		   <td align="right">
			  <cfif KA005_2020 gt 0>#NUMBERFORMAT(KA005_2020,"999999.99")#	 <cfelse>0</cfif>
		   </td>
		   <td align="right">
			   <cfif KA005_2019 gt 0>#NUMBERFORMAT(KA005_2019,"999999.99")#	<cfelse>0</cfif>
		   </td>
		   <td align="right">
			   <cfif KA005_2018 gt 0>#NUMBERFORMAT(KA005_2018,"999999.99")#<cfelse>0</cfif>
		   </td>
		   <td align="center"></td>
	  </tr>
	  
	   </cfloop>
   
  </cfif>
  
  <!---展下一階層查詢語法---> 
  <cfquery datasource="#SESSION.COMPANY#" name="BOMMD" >
    SELECT MD001,MD003,MB002,MD006,MB003,MD007,MD011,MD012,MB064,MB013,MB032,MB050,MB057,MB060
           ,(MB057*MD006/MD007) AS MD087,MB064,MB068,MB025,MB017,MA002,
	PURKA_2023.KA005 AS KA005_2023,
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
    
    WHERE MD001 = '#MD003#'
	ORDER BY MD002
  </cfquery>
  
</cfoutput>  
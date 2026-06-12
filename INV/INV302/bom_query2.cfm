	
 <!---BOM展階程式--->   
 
<cfoutput>
 
  <!---秀上階BOM展階資料---> 
  <tr bgcolor="#bgcolor#">
     <td>#level#</td>
     <td>#MD003#</td>
     <td>#MB002#</td>
     <td>#MB003#</td>
     <td>#MB025#</td>
     <td>#MB068#</td>
     <td align="right">#numberformat(MB057,"999999.999")#</td>
     <td align="right">#numberformat(MB058,"999999.999")#</td>
     <td align="right">#numberformat(MB059,"999999.999")#</td>	
     <td align="right">#numberformat(MB060,"999999.999")#</td>
     <td align="right">#numberformat(MB061,"999999.999")#</td>
     <td align="right">#numberformat(MB062,"999999.999")#</td>
     <td align="right">#numberformat(MB063,"999999.999")#</td>
     <td align="right">#numberformat(LB010,"999999.999")#</td>
     <td align="right">#numberformat(LB011,"999999.999")#</td>
     <td align="right">#numberformat(LB012,"999999.999")#</td>
     <td align="right">#numberformat(LB013,"999999.999")#</td>
     <td align="right">#numberformat(LB014,"999999.999")#</td>
  </tr>

  <!---展下一階層查詢語法---> 
  <cfquery datasource="EAGLE" name="BOMMD" >
    SELECT MB001,MB002,MB003,MB004,MB005,MB025,MB068,MB057,MB058,MB059,MB060,MB061,MB062,MB063,LB010,LB011,LB012,LB013,LB014,MD003
        
    FROM BOMMD
    
    LEFT JOIN  JAG_TEST..INVMB ON MB001 = MD003
    JOIN INVLB ON LB001=MB001 AND LB002='#FORM.LB002#'
    
    WHERE MD001 = '#MD003#' AND MB002 NOT LIKE '%貼紙%'
  </cfquery>
  
</cfoutput>  
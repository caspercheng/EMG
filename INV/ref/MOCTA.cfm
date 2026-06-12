<!---預計生產/託外進貨明細--->

<cfquery name="MOCTA" datasource="#SESSION.COMPANY#" >
    SELECT TA010,TA001,TA002,TA006,TA034,TA035,TA012,TA007,TA015,TA017,MA002
    FROM MOCTA
    LEFT JOIN PURMA ON MA001=TA032
    WHERE TA006='#URL.MB001#' 
	     AND TA013='Y'
		 AND TA011 IN ('1','2','3')
</cfquery>

<cfoutput>
  
 <cfif #MOCTA.recordcount# neq 0>
 
<h5 align="center">預計生產/託外進貨明細</h5>

<table align="center" border="1">
	<TR bgcolor="666666" style="color:FFF">
	    <td>預計開工日</td>
	    <td>製令單號</td>
	    <td>加工廠商</td>
		<td>品號</td>
		<td>品名</td>
        <td>規格</td>
		<td>預計產量</td>
		<td>已生產量</td>
		<td>單位</td>
	</tr>

    <cfloop query="MOCTA">
    
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<TR bgcolor="#bgcolor#">
	    <td>#MID(TA010,1,4)#-#MID(TA010,5,2)#-#MID(TA010,7,2)#</td>
	    <td>#TA001#-#TA002#</td>
		<td>#MA002#</td>
		<td>#TA006#</td>
		<td>#TA034#</td>
        <td>#TA035#</td>
		<td align="right">#NUMBERFORMAT(TA015,"9,999,999")#</td>
		<td align="right">#NUMBERFORMAT(TA017,"9,999,999")#</td>
		<td>#TA007#</td>
	</tr>
    </cfloop>

</table>

<BR/>
</cfif>
</cfoutput>




<h4><center>預計生產明細</center></h4>

<cfquery name="MOCTA" datasource="EAGLE">
    SELECT TA010,TA001,TA002,TA006,TA034,TA035,TA012,TA007,TA015,TA017,MA002
    FROM MOCTA
    LEFT JOIN PURMA ON TA032=MA001
    WHERE TA006='#URL.MD003#' AND TA013='Y' AND TA011 IN ('1','2','3')
    ORDER BY TA010
</cfquery>

<cfoutput>
 
<table align="center">
	<TR bgcolor="666666" style="color:FFF">
	    <td>預計開工日</td>
	    <td>製令單號</td>
		<td>品號</td>
		<td>品名</td>
        <td>規格</td>
		<td>預計產量</td>
		<td>已生產量</td>
		<td>單位</td>
		<td>加工廠商</td>
	</tr>

    <cfloop query="MOCTA">
    
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<TR bgcolor="#bgcolor#">
	    <td>#MID(TA010,1,4)#-#MID(TA010,5,2)#-#MID(TA010,7,2)#</td>
	    <td>#TA001#-#TA002#</td>
		<td>#TA006#</td>
		<td>#TA034#</td>
        <td>#TA035#</td>
		<td align="right">#NUMBERFORMAT(TA015,9999999.99)#</td>
		<td align="right">#NUMBERFORMAT(TA017,9999999.99)#</td>
		<td>#TA007#</td>
		<td>#MA002#</td>
	</tr>
    
    </cfloop>
</table>

</cfoutput>


<p>

<!---關閉視窗--->
<table align="center">
     <tr>
        <td><input type="button" value="結束-關閉視窗" onClick="top.window.close()"></td>
     </tr>
</table>

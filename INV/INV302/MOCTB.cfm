

<h4><center>預計領料明細</center></h4>

<cfquery name="MOCTB" datasource="EAGLE" result="result1">
    SELECT TA010,TA001,TA002,TB003,TB012,TB013,TA012,TB007,TB004,TB005
    FROM MOCTB
    JOIN MOCTA ON TA001=TB001 AND TA002=TB002
    WHERE TB003='#URL.MD003#' AND TA013='Y' AND TA011 IN ('1','2','3')
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
	</tr>

    <cfloop query="MOCTB">
    
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<TR bgcolor="#bgcolor#">
	    <td>#MID(TA010,1,4)#-#MID(TA010,5,2)#-#MID(TA010,7,2)#</td>
	    <td>#TA001#-#TA002#</td>
		<td>#TB003#</td>
		<td>#TB012#</td>
        <td>#TB013#</td>
		<td align="right">#NUMBERFORMAT(TB004,9999999.99)#</td>
		<td align="right">#NUMBERFORMAT(TB005,9999999.99)#</td>
		<td>#TB007#</td>
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

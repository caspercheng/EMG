

<h3><center>預計銷貨明細</center></h3>

<cfquery name="COPTD" datasource="#SESSION.COMPANY#" result="result1">
    SELECT TD013,MA002,TD001,TD002,TD003,TD004,TD005,TD006,TD008,TD010,TD009
    FROM COPTD
    JOIN COPTC ON TC001=TD001 AND TC002=TD002
    JOIN COPMA ON MA001=TC004
    WHERE TD004='#URL.MD003#' AND TD021='Y' AND TD016='N'
</cfquery>

<cfoutput>
 
<table align="center">
	<TR bgcolor="666666" style="color:FFF">
	    <td>預交日</td>
	    <td>客戶</td>
	    <td>訂單單號</td>
		<td>品號</td>
		<td>品名</td>
        <td>規格</td>
		<td>訂單數量</td>
		<td>已交數量</td>
		<td>單位</td>
	</tr>

    <cfloop query="COPTD">
    
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<TR bgcolor="#bgcolor#">
	    <td>#MID(TD013,1,4)#-#MID(TD013,5,2)#-#MID(TD013,7,2)#</td>
	    <td>#MA002#</td>
	    <td>#TD001#-#TD002#-#TD003#</td>
		<td>#TD004#</td>
		<td>#TD005#</td>
        <td>#TD006#</td>
		<td align="right">#NUMBERFORMAT(TD008,9999999.99)#</td>
		<td align="right">#NUMBERFORMAT(TD009,9999999.99)#</td>
		<td>#TD010#</td>
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
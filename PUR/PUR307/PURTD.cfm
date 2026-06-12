

<h3><center>已採未進貨明細</center></h3>

<cfquery name="PURTD" datasource="#SESSION.COMPANY#" result="result1">
    SELECT TD012,MA002,TD001,TD002,TD003,TD004,TD005,TD006,TD008,TD015,TD009
    FROM PURTD
    JOIN PURTC ON TC001=TD001 AND TC002=TD002
    JOIN PURMA ON MA001=TC004
    WHERE TD004='#URL.MD003#' AND TD018='Y' AND TD016='N'
</cfquery>

<cfoutput>
 
<table align="center">
	<TR bgcolor="666666" style="color:FFF">
	    <td>預交日</td>
	    <td>廠商</td>
	    <td>採購單號</td>
		<td>品號</td>
		<td>品名</td>
        <td>規格</td>
		<td>採購數量</td>
		<td>已交數量</td>
		<td>單位</td>
	</tr>

    <cfloop query="PURTD">
    
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<TR bgcolor="#bgcolor#">
	    <td>#MID(TD012,1,4)#-#MID(TD012,5,2)#-#MID(TD012,7,2)#</td>
	    <td>#MA002#</td>
	    <td>#TD001#-#TD002#-#TD003#</td>
		<td>#TD004#</td>
		<td>#TD005#</td>
        <td>#TD006#</td>
		<td align="right">#NUMBERFORMAT(TD008,9999999.99)#</td>
		<td align="right">#NUMBERFORMAT(TD015,9999999.99)#</td>
		<td>#TD009#</td>
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

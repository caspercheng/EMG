<!---預計銷貨明細--->

<cfquery name="COPTD" datasource="#SESSION.COMPANY#" >
    SELECT TD013,MA002,TD001,TD002,TD003,TD004,TD005,TD006,TD008,TD010,TD009
    FROM COPTD
    JOIN COPTC ON TC001=TD001 AND TC002=TD002
    JOIN COPMA ON MA001=TC004
    WHERE TD004='#URL.MB001#' 
	    AND TD021='Y'
	    AND TD016='N'
</cfquery>

<cfoutput>

<cfif #COPTD.recordcount# neq 0>
 
<h5 align="center">預計銷貨明細</h5>
 
<table align="center" border="1">
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
		<td align="right">#NUMBERFORMAT(TD008,"9,999,999")#</td>
		<td align="right">#NUMBERFORMAT(TD009,"9,999,999")#</td>
		<td>#TD010#</td>
	</tr>
    </cfloop>
	
</table>

<BR/>

</cfif>

</cfoutput>



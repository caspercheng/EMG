<title>託外進貨明細</title>
<h4 align="center">託外進貨明細</h3>

<cfquery name="MOCTI" datasource="#SESSION.COMPANY#" >
    SELECT *
    FROM MOCTI
    JOIN MOCTH ON TI001=TH001 AND TI002=TH002
    JOIN PURMA ON MA001=TH005
	LEFT JOIN CMSMW ON MW001=TI015
    WHERE TI004='#URL.MD003#' 
	    AND TI037='Y'
		AND TH003 >= '20180101'
		AND TI019 > 0
		AND TI024 > 0
	ORDER BY TH003 DESC
</cfquery>


<cfoutput>
 
<table align="center" border="1">
	<TR bgcolor="666666" style="color:FFF">
	    <td>進貨日</td>
	    <td>廠商</td>
        <td>製程</td>
	    <td>進貨單號</td>
		<td>品號</td>
		<td>品名</td>
        <td>規格</td>
		<td>數量</td>
		<td>金額</td>
		<td>單價</td>
	</tr>

    <cfloop query="MOCTI">
    
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<TR bgcolor="#bgcolor#">
	    <td>#MID(TH003,1,4)#-#MID(TH003,5,2)#-#MID(TH003,7,2)#</td>
	    <td>#MA002#</td>
        <td>#MW002#</td>
	    <td>#trim(TI001)#-#TI002#-#TI003#</td>
		<td>#TI004#</td>
		<td>#TI005#</td>
        <td>#TI006#</td>
		<td align="right">#NUMBERFORMAT(TI019,"9,999,999")#</td>
		<td align="right">#NUMBERFORMAT(TI025,"9,999,999")#</td>
		<td align="right">#NUMBERFORMAT(TI024,"9,999,999.99")#</td>
	</tr>
    </cfloop>
</table>

</cfoutput>


<cfinclude template="/EMG/close_window.cfm">
<cfinclude template="/EMG/footer.cfm">

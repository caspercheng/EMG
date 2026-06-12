<!---品號未結採購明細--->

<cfquery name="PURTD" datasource="#SESSION.COMPANY#" >
	SELECT *
	FROM PURTD
    JOIN PURTC ON TC001=TD001 AND TC002=TD002
    JOIN PURMA ON MA001=TC004
    LEFT JOIN INVMB ON TD004=MB001
    LEFT JOIN CMSMV ON MV001=TC011
	WHERE  1=1
	AND TD016='N' 
	AND TD018<>'V'
    AND TD004='#URL.MB001#'
    ORDER BY TC003
</cfquery>

<cfoutput>
 
 <cfif #PURTD.recordcount# neq 0>
  
<table  align="center" border="1">

    <TR >
        <TD colspan="10">未結案採購單</TD>
    </TR>

	<tr bgcolor="666666" style="color:FFF">
		<td>採購單號</td>
		<td>採購日期</td>
		<td>廠商代號</td>
		<td>廠商名稱</td>
		<td>採購人員</td>
		<td>預交日</td>
		<td align="center">採購數量</td>
		<td align="center">已交數量</td>
		<td align="center">未交數量</td>
	</tr>

<cfloop query="PURTD" > 	
	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<cfif #TD010# EQ 0><cfset bgcolor2="FFCCFF"><cfelse><cfset bgcolor2=bgcolor></cfif>
    
	<TR bgcolor="#bgcolor#" >
		<td >#TRIM(TD001)#-#TD002#-#TD003#</td>
		<td>#MID(TC003,1,4)#-#MID(TC003,5,2)#-#MID(TC003,7,2)#</td>
		<td align="center">#MA001#</td>
		<td align="center">#MA002#</td>
		<td align="center">#MV002#</td>
		<td>#MID(TD012,1,4)#-#MID(TD012,5,2)#-#MID(TD012,7,2)#</td>
		<td align="right" >#NUMBERFORMAT(TD008,"9,999,999")#</td>
		<td align="right" >#NUMBERFORMAT(TD015,"9,999,999")#</td>
		<td align="right" >#NUMBERFORMAT(TD008-TD015,"9,999,999")#</td>
	</tr>
	</cfloop>	
	
</table>

<BR/>

</cfif>

</cfoutput>


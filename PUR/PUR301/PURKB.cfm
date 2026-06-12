<cfinclude template="/EMG/menu.cfm">

<cfoutput>

<h4><center>採購變更記錄查詢<center></h4>

<!---查詢採購變更記錄資料--->
<cfquery datasource="#SESSION.COMPANY#" name="PURTD">
    SELECT *
    FROM PURKB
    JOIN PURTD ON TD001=KB001 AND TD002=KB002 AND TD003=KB003
	JOIN PURTC ON TC001=TD001 AND TC002=TD002
    JOIN PURMA ON TC004=MA001
	LEFT JOIN CMSMV  ON MV001=TC011

	WHERE 1=1 
		AND KB001='#URL.TD001#'
		AND KB002='#URL.TD002#'
		AND KB003='#URL.TD003#'
		
    ORDER BY KB001,KB002,KB003,KB004
</cfquery>


<cfform action="PURTD_UPDATE_SQL.cfm" method="post">

<table border="1" align="center">

<TR  bgcolor="666666" style="color:FFF" align="center">
   <TD>採購單號</TD>
   <TD>變更序號</TD>
   <TD>採購日期</TD>
   <TD>簡稱</TD>
   <TD>採購人員</TD>
    <td>品號</td>
    <td>品名/規格</td>
    <td>原預交日</td>
    <td>新預交日</td>
    <td>原備註</td>
    <td>新備註</td>
    <td>異動資訊</td>
    <td align="center">採購數量</td>
    <td align="center">已交數量</td>
    <td align="center">未交數量</td>
    <td align="center">單位</td>
</TR>

<cfloop query="PURTD">
	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	
	<TR bgcolor="#bgcolor#">
		<TD>#TRIM(TD001)#-#TRIM(TD002)#-#TRIM(TD003)#</TD> 
		<td>#KB004#</td>
		<TD>#MID(TC003,1,4)#-#MID(TC003,5,2)#-#MID(TC003,7,2)#</TD>
		<TD>#MA002#</TD>
		<TD>#MV002#</TD>
		<td>#TD004#</td>
		<td>#TD005#/#TD006#</td>
		<td>#MID(KB008,1,4)#-#MID(KB008,5,2)#-#MID(KB008,7,2)#</td>
		<td>#MID(KB009,1,4)#-#MID(KB009,5,2)#-#MID(KB009,7,2)#</td>
		<td>#KB010#</td>
		<td>#KB011#</td>
		<td align="center">#KB007#<br>#dateformat(KB005,"yyyy-mm-dd")#  #timeformat(KB006,"HH:mm")#</td>
		<td align="right" width="60">#NUMBERFORMAT(TD008,"9,999,999")#</td>
		<td align="right" width="60">#NUMBERFORMAT(TD015,"9,999,999")#</td>
		<td align="right" width="60">#NUMBERFORMAT(TD008-TD015,"9,999,999")#</td>
		<td align="center">#TD009#</td>
	</TR>
<!---    </cfif>
---></cfloop>

</table>

</cfform>

</cfoutput>

<!---關閉視窗--->
<table align="center">
     <tr>
        <td><input type="button" value="結束-關閉視窗" onClick="top.window.close()"></td>
     </tr>
</table>

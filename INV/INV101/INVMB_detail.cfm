<title>品號明細資料</title>
<cfinclude template="/EMG/menu.cfm">

		<!---設定此程式代號--->
<cfset program_id = "INV101" >
<cfset program_name = "品號資料維護作業" >
<cfset program_type = "I" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfquery datasource="#SESSION.COMPANY#" name="INVMB">
    SELECT  *
    FROM INVMB
    LEFT JOIN INVMA ON MA001='2' AND MA002=MB006
	WHERE 1=1
	AND MB001='#URL.MB001#'
</cfquery>

<cfquery datasource="#SESSION.COMPANY#" name="INVLA">
    SELECT  *
    FROM  INVLA
    JOIN  CMSMQ ON MQ001=LA006
    JOIN CMSMC ON MC001=LA009
	WHERE 1=1
	AND LA001='#URL.MB001#'
    ORDER BY LA004 DESC
</cfquery>

<cfquery name="PURTD" datasource="#SESSION.COMPANY#" >
	SELECT *
	FROM PURTD
    JOIN PURTC ON TC001=TD001 AND TC002=TD002
    JOIN PURMA ON MA001=TC004
    LEFT JOIN INVMB ON TD004=MB001
    LEFT JOIN CMSMV ON MV001=TC011
	WHERE  1=1
	AND TD016='N' 
	AND TD018 = 'Y'
    AND TD004='#URL.MB001#'
    ORDER BY TC003
</cfquery>

<cfquery datasource="#SESSION.COMPANY#" name="INVMC">
    SELECT  CMSMC.MC002 AS NAME,INVMC.MC003 AS LOCATION,INVMC.MC007 AS NUM
    FROM INVMC
    LEFT JOIN CMSMC ON CMSMC.MC001=INVMC.MC002
	WHERE 1=1
	AND INVMC.MC001='#URL.MB001#'
</cfquery>

<h4><center>品號明細資料</center></h4>

<!---使用輸入條件--->
<cfoutput>
<cfloop query="INVMB">
	
    <table border="1" align="center" >
    
        <tr>
            <td  bgcolor="666666" style="color:FFF">品號</td>
            <td>#MB001#</td>
        </tr>
        
        <tr>
            <td  bgcolor="666666" style="color:FFF">品名</td>
            <td>#MB002#</td>
        </tr>
    
        <tr>
            <td  bgcolor="666666" style="color:FFF">規格</td>
            <td>#MB003#</td>
        </tr>
    
        <tr>
            <td  bgcolor="666666" style="color:FFF">單位</td>
            <td>#MB004#</td>
        </tr>		
        
        <tr>
            <td  bgcolor="666666" style="color:FFF">採購分類</td>
            <td>#MA003#</td>
        </tr>		
    
        <tr>
            <td  bgcolor="666666" style="color:FFF">前置天數</td>
            <td>#MB036#</td>
        </tr>		

        <tr>
            <td  bgcolor="666666" style="color:FFF">最低補量</td>
            <td>#NUMBERFORMAT(MB039,"9,999,999")#</td>
        </tr>		
        
    
          
    </table>

</cfloop>	

<BR/>
<table  align="center" border="1">

    <TR >
        <TD colspan="10">各庫數量</TD>
    </TR>

	<tr bgcolor="666666" style="color:FFF">
		<td>庫別</td>
		<td>儲存位置</td>
		<td align="center">數量</td>
	</tr>

<cfloop query="INVMC" > 	
	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    
	<TR bgcolor="#bgcolor#" >
		<td align="center">#NAME#</td>
		<td align="center">#LOCATION#</td>
		<td align="right" width="60">#NUMBERFORMAT(NUM ,"9,999,999")#</td>
	</tr>
	</cfloop>	
	
</table>

<BR/>
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
		<td align="right" width="60">#NUMBERFORMAT(TD008,"9,999,999")#</td>
		<td align="right" width="60">#NUMBERFORMAT(TD015,"9,999,999")#</td>
		<td align="right" width="60">#NUMBERFORMAT(TD008-TD015,"9,999,999")#</td>
	</tr>
	</cfloop>	
	
</table>
	
<BR/>

<table border="1" align="center">

    <TR >
        <TD colspan="10">歷史異動明細</TD>
    </TR>

    <TR bgcolor="666666" style="color:FFF">
        <TD>日期</TD>
        <TD>單據</TD>
        <TD>單號</TD>
        <TD>數量</TD>
        <TD>庫別</TD>
    </TR>

<cfloop query="INVLA">
	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<TR bgcolor="#bgcolor#" >
		<TD align="center" width="120">#MID(LA004,1,4)#-#MID(LA004,5,2)#-#MID(LA004,7,2)#</TD> 
		<TD>#MQ002#</TD> 
		<TD  align="center">#TRIM(LA006)#-#TRIM(LA007)#-#LA008#</TD> 
		<TD align="right" width="60">#NUMBERFORMAT(LA011*LA005,"9,999,999")#</TD> 
		<TD>#MC002#</TD> 
    </TR>
</cfloop>	

</table>

</cfoutput>

<cfinclude template="/EMG/close_window.cfm">
<cfinclude template="/EMG/footer.cfm">


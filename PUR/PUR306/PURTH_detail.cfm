<title>進貨單明細</title>

<!---CSS--->
<style>
  table {border-collapse: collapse;}
</style>

<!---設定此程式代號--->
<cfset program_id = "PUR306" >
<cfset program_name = "進貨統計表" >
<cfset program_type = "Q" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("URL.MA002")><cfset #URL.MA002#=""></cfif> 
<cfif NOT IsDefined("URL.TG003_1")><cfset #URL.TG003_1#=""></cfif> 
<cfif NOT IsDefined("URL.TG003_2")><cfset #URL.TG003_2#=""></cfif> 
<cfif NOT IsDefined("URL.TH004")><cfset #URL.TH004#=""></cfif> 

<cfoutput>

<h4><center>進貨單明細</center></h4>

<center>查詢條件：進貨日期: #URL.TG003_1#～#URL.TG003_2#，客戶簡稱: #URL.MA002#，品號: #URL.TH004# </center>

<cfquery datasource="#SESSION.COMPANY#" name="PURTH_SUM">
    SELECT   SUBSTRING(TG003,1,6) AS MONTH,SUM(TH007) AS SUMTH007,SUM(TH019) AS SUMTH019
    FROM PURTH
	JOIN PURTG ON TH001=TG001 AND TH002=TG002
	JOIN INVMB ON MB001=TH004
	JOIN PURMA ON MA001=TG005
	WHERE 1=1 AND TH030 = 'Y'
			<cfif URL.MA002 IS NOT ""> AND MA002 like '%#URL.MA002#%'</cfif>
			<cfif URL.TG003_1 IS NOT ""> AND SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) >= '#URL.TG003_1#'</cfif>
			<cfif URL.TG003_2 IS NOT ""> AND SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) <= '#URL.TG003_2#'</cfif>
			<cfif URL.TH004 IS NOT ""> AND TH004 like '%#URL.TH004#%'</cfif>
	GROUP BY SUBSTRING(TG003,1,6)  
	ORDER BY SUBSTRING(TG003,1,6)  
</cfquery>


<cfquery datasource="#SESSION.COMPANY#" name="PURTH">
    SELECT   *
    FROM PURTH
	JOIN PURTG ON TH001=TG001 AND TH002=TG002
	JOIN INVMB ON MB001=TH004
	JOIN PURMA ON MA001=TG005
	JOIN CMSMC ON MC001=TH009
	WHERE 1=1 AND TH030 = 'Y'
			<cfif URL.MA002 IS NOT ""> AND MA002 like '%#URL.MA002#%'</cfif>
			<cfif URL.TG003_1 IS NOT ""> AND SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) >= '#URL.TG003_1#'</cfif>
			<cfif URL.TG003_2 IS NOT ""> AND SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) <= '#URL.TG003_2#'</cfif>
			<cfif URL.TH004 IS NOT ""> AND TH004 like '%#URL.TH004#%'</cfif>
	ORDER BY TG003 DESC,TG001,TG002
</cfquery>

<table border="1" align="center">

<TR><TD colspan="10" align="center">各月統計</TD></TR>

<TR bgcolor="666666" style="color:FFF">
	<TH>進貨日期</TH>
	<TH>進貨數量</TH>
	<cfif #價格權限# eq "Y">
	<TH>金額</TH>
	</cfif>
</TR>


<cfloop query="PURTH_SUM">

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	
	<tr bgcolor="#bgcolor#">
		<TD align="center">#MID(MONTH,1,4)#-#MID(MONTH,5,2)#</TD> 
		<TD align="right">#NUMBERFORMAT(SUMTH007,"9,999,999")#</TD>
		<cfif #價格權限# eq "Y">
		<TD align="right">#NUMBERFORMAT(SUMTH019,"99,999,999.99")#</TD>
		</cfif>
	</tr>
</cfloop>

</table>

<BR/>

<table border="1" align="center">

<TR bgcolor="666666" style="color:FFF">
    <TH>單別-單號</TH>
    <TH>進貨日期</TH>
    <TH>廠商簡稱</TH>
	<TH>品號</TH>
	<TH>品名</TH>
	<TH>規格</TH>
	<TH>進貨數量</TH>
	<TH>單位</TH>
	<TH>批號</TH>
	<TH>採購單別-單號</TH>
	<TH>庫別</TH>
	<TH>確認碼</TH>    
</TR>


<cfloop query="PURTH">
	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
 	<cfif TG013 EQ "Y"><cfset confirm="已確認"><cfelse><cfset confirm="未確認"></cfif>
	
	<tr bgcolor="#bgcolor#">
		<TD align="center">#TRIM(TG001)#-#TRIM(TG002)#</TD> 
		<TD align="center">#MID(TG003,1,4)#-#MID(TG003,5,2)#-#MID(TG003,7,2)#</TD>
		<TD align="center">#MA002#</TD>
		<TD align="center" >#TH004#</TD>
		<TD>#TH005#</TD>
		<TD>#TH006#</td>
		<TD align="right" width="60">#NUMBERFORMAT(TH007,"9,999,999")#</TD>
		<TD align="center">#TH008#</TD>
		<TD>#TH010#</TD>
		<TD align="center">#TH011#-#TH012#-#TH013#</TD>
		<TD align="center">#MC002#</TD>
    	<TD align="center">#confirm#</TD>
	</tr>

</cfloop>

</table>

 </cfoutput>
<cfinclude template="/EMG/close_window.cfm">

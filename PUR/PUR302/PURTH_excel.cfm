<!---設定此程式代號--->
<cfset program_id = "PUR302" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("URL.TG001")><cfset #URL.TG001#=""></cfif>
<cfif NOT IsDefined("URL.TG002")><cfset #URL.TG002#=""></cfif>
<cfif NOT IsDefined("URL.TG003_1")><cfset #URL.TG003_1#=""></cfif>
<cfif NOT IsDefined("URL.TG003_2")><cfset #URL.TG003_2#=""></cfif>
<cfif NOT IsDefined("URL.MA001")><cfset #URL.MA001#=""></cfif>
<cfif NOT IsDefined("URL.MA002")><cfset #URL.MA002#=""></cfif>
<cfif NOT IsDefined("URL.MB001")><cfset #URL.MB001#=""></cfif> 
<cfif NOT IsDefined("URL.MB002")><cfset #URL.MB002#=""></cfif> 
<cfif NOT IsDefined("URL.TH010")><cfset #URL.TH010#=""></cfif> 
<cfif NOT IsDefined("URL.TH011")><cfset #URL.TH011#=""></cfif> 
<cfif NOT IsDefined("URL.TH012")><cfset #URL.TH012#=""></cfif> 
<cfif NOT IsDefined("URL.TH030")><cfset #URL.TH030#=""></cfif> 
<cfif NOT IsDefined("URL.num")><cfset #URL.num#="500"></cfif> 


<cfsetting enablecfoutputonly="Yes">
<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="filename=進貨單明細.xls">

<h4><center>進貨單查詢<center></h4>


<!---查詢未詢採購單資料--->
<cfquery datasource="#SESSION.COMPANY#" name="PURTH">
    SELECT top #URL.num# TG001,TG002,TG003,TH011,TH012,TH013,TG013,MA002,TH004,TH005,TH006,TH007,TH018,TH019,TH008,TH039,TH040,TH041,MC002,MV002,
	PURTH.CREATE_DATE AS DATE,PURTH.CREATE_TIME AS TIME
    FROM PURTH
	JOIN PURTG ON TH001=TG001 AND TH002=TG002
    JOIN PURMA ON TG005=MA001
	JOIN CMSMC ON MC001=TH009
	JOIN INVMB ON MB001=TH004
	LEFT JOIN CMSMV ON MV001=PURTH.CREATOR
	
	WHERE 1=1  AND TG013 <> 'V'
	<cfif URL.TG001 IS NOT ""> AND TG001 = '#URL.TG001#'</cfif>
	<cfif URL.TG002 IS NOT ""> AND TG002 = '#URL.TG002#'</cfif>
	<cfif URL.TG003_1 IS NOT ""> AND  SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) >= '#URL.TG003_1#'</cfif>
	<cfif URL.TG003_2 IS NOT ""> AND  SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) <= '#URL.TG003_2#'</cfif>
	<cfif URL.MA002 IS NOT ""> AND  MA002 like '#URL.MA002#%'</cfif>
    <cfif URL.MB001 IS NOT ""> AND  MB001 like '%#URL.MB001#%' </cfif>
    <cfif URL.MB002 IS NOT ""> AND  MB002 like '%#URL.MB002#%' </cfif>
    <cfif URL.TH010 IS NOT ""> AND  TH010 like '#URL.TH010#%' </cfif>
	<cfif URL.TH011 IS NOT ""> AND TH011 = '#URL.TH011#'</cfif>
	<cfif URL.TH012 IS NOT ""> AND TH012 = '#URL.TH012#'</cfif>
	<cfif URL.TH030 IS NOT ""> AND TH030 = '#URL.TH030#'</cfif>
    ORDER BY TG003 DESC,TG001,TG002
	
</cfquery>

<cfoutput>

<table border="1">

<TR>
    <TH>單別-單號</TH>
    <TH>進貨日期</TH>
    <TH>廠商簡稱</TH>
	<TH>品號</TH>
	<TH>品名</TH>
	<TH>規格</TH>
	<TH>進貨數量</TH>
   <cfif #價格權限# eq "Y">
   <TH>單價</TH>
   <TH>金額</TH>
   </cfif>
	<TH>單位</TH>
	<TH>批號</TH>
	<TH>採購單別-單號</TH>
	<TH>庫別</TH>
	<TH>確認碼</TH>   
	<TH>打單人員</TH>
	<TH>打單日期</TH>
</TR>


<cfset SUMTH007=0>
<cfset SUMTH007_2=0>

<cfloop query="PURTH">

<cfset SUMTH007 = SUMTH007 + TH007>

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
 	<cfif TG013 EQ "Y"><cfset confirm="已確認"><cfelse><cfset confirm="未確認"></cfif>
	
	<tr bgcolor="#bgcolor#">
		<TD align="center">#TRIM(TG001)#-#TRIM(TG002)#</TD> 
		<TD align="center">#MID(TG003,1,4)#-#MID(TG003,5,2)#-#MID(TG003,7,2)#</TD>
		<TD align="center">#MA002#</TD>
		<TD align="center" >#TH004#</TD>
		<TD>#TH005#</TD>
		<TD>#TH006#</td>
		<TD align="right" >#NUMBERFORMAT(TH007,"9,999,999")#</TD>
		<cfif #價格權限# eq "Y">
        <TD align="right">#NUMBERFORMAT(TH018,"9,999,999.99")#</TD>
        <TD align="right">#NUMBERFORMAT(TH019,"99,999,999")#</TD>
		</cfif>
		<TD align="center">#TH008#</TD>
		<TD>#TH010#</TD>
		<TD align="center">#TH011#-#TH012#-#TH013#</TD>
		<TD align="center">#MC002#</TD>
    	<TD align="center">#confirm#</TD>
		<TD align="center">#MV002#</TD>
		<TD>#MID(DATE,1,4)#-#MID(DATE,5,2)#-#MID(DATE,7,2)#</TD>
	</tr>


</cfloop>

	<TR>
		<TD></TD> 
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD align="center" style="color:FFF">小計</TD>
		<TD align="right" style="color:FFF" width="60">#NUMBERFORMAT(SUMTH007,"9,999,999")#</TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
	</TR>

</table>


</cfoutput>


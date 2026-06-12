<!---設定此程式代號--->
<cfset program_id = "COP303" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("URL.TH014")><cfset #URL.TH014#=""></cfif> 
<cfif NOT IsDefined("URL.TH015")><cfset #URL.TH015#=""></cfif> 
<cfif NOT IsDefined("URL.TG001")><cfset #URL.TG001#=""></cfif> 
<cfif NOT IsDefined("URL.TG002")><cfset #URL.TG002#=""></cfif>
<cfif NOT IsDefined("URL.TG023")><cfset #URL.TG023#=""></cfif> 
<cfif NOT IsDefined("URL.MA002")><cfset #URL.MA002#=""></cfif> 
<cfif NOT IsDefined("URL.TG003_1")><cfset #URL.TG003_1#=""></cfif> 
<cfif NOT IsDefined("URL.TG003_2")><cfset #URL.TG003_2#=""></cfif> 
<cfif NOT IsDefined("URL.TH005")><cfset #URL.TH005#=""></cfif> 
<cfif NOT IsDefined("URL.TH019")><cfset #URL.TH019#=""></cfif> 
<cfif NOT IsDefined("URL.submit")><cfset #URL.submit#=""></cfif> 
<cfif NOT IsDefined("URL.num")><cfset #URL.num#="500"></cfif> 

<cfoutput>

<cfsetting enablecfoutputonly="Yes">
<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="filename=銷貨單_#dateformat(now(),"yyyy-mm-dd")#.xls">

<cfquery datasource="#SESSION.COMPANY#" name="COPTH">
    SELECT TOP #URL.num#  *
    FROM COPTH
	JOIN COPTG ON TH001=TG001 AND TH002=TG002
	LEFT JOIN COPTD ON TD001=TH014 AND TD002=TH015 AND TD003=TH016
	JOIN INVMB ON MB001=TH004
	JOIN COPMA ON MA001=TG004
	WHERE 1=1 AND TH020 <> 'V'
    <cfif URL.TG001 IS NOT ""> AND TG001 = '#URL.TG001#'</cfif>
    <cfif URL.TG023 IS NOT ""> AND TG023 = '#URL.TG023#'</cfif>
    <cfif URL.TH014 IS NOT ""> AND TH014 = '#URL.TH014#'</cfif>
    <cfif URL.TH015 IS NOT ""> AND TH015 = '#URL.TH015#'</cfif>
    <cfif URL.TG002 IS NOT ""> AND TG002 like '#URL.TG002#%'</cfif>
    <cfif URL.MA002 IS NOT ""> AND MA002 like '%#URL.MA002#%'</cfif>
	<cfif URL.TG003_1 IS NOT ""> AND SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) >= '#URL.TG003_1#'</cfif>
	<cfif URL.TG003_2 IS NOT ""> AND SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) <= '#URL.TG003_2#'</cfif>
    <cfif URL.TH019 IS NOT ""> AND TH019 like '%#URL.TH019#%'</cfif>
    <cfif URL.TH005 IS NOT ""> AND TH005 like '%#URL.TH005#%'</cfif>
	ORDER BY TG003 DESC,TG001,TG002
</cfquery>



<table border="1">

<TR>
	<TH>銷貨單別-單號</TH>
	<TH>訂單單別-單號</TH>	
	<TH>銷貨日期</TH>
	<TH>客戶簡稱</TH>	
    <TH>品號</TH>
	<TH>品名</TH>
	<TH>銷貨數量</TH>
	<cfif #價格權限# eq "Y">
	<TH>單價</TH>
	<TH>金額</TH>
	</cfif>
	<TH>確認碼</TH>    
	<TH>結帳單</TH>    
</TR>

<cfset SUMTH008 =  0>
<cfset SUMTH013 =  0>

<cfloop query="COPTH">

<cfset SUMTH008 =  SUMTH008 +TH008>
<cfset SUMTH013 =  SUMTH013 +TH013>

	
	<cfif TG023 EQ "Y"><cfset confirm="已確認"><cfelse><cfset confirm="未確認"></cfif>

    <tr>
		<TD align="center">#TRIM(TG001)#-#TRIM(TG002)#-#TH003#</TD>
		<TD>#TRIM(TH014)#-#TRIM(TH015)#-#TH016#</TD>		
		<TD align="center">#MID(TG003,1,4)#-#MID(TG003,5,2)#-#MID(TG003,7,2)#</TD> 
		<TD align="center">#MA002#</TD>		
        <TD align="center">#TH004#</TD>
		<TD>#TH005#</TD> 
		<TD align="right">#NUMBERFORMAT(TH008,"9,999,999")#</TD>
		<cfif #價格權限# eq "Y">
		<TD align="right">#NUMBERFORMAT(TH012,"9,999,999.99")#</TD>
		<TD align="right">#NUMBERFORMAT(TH013,"99,999,999")#</TD>
		</cfif>
    	<TD align="center">#confirm#</TD>
		<TD align="center">#TRIM(TH027)#-#TRIM(TH028)#-#TH029#</TD>		
	</tr>
</cfloop>

	<TR>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD align="center" style="color:FFF">小計</TD>
		<TD align="right" style="color:FFF">#NUMBERFORMAT(SUMTH008,"99,999,999")#</TD>

		<cfif #價格權限# eq "Y">
		<TD align="center" style="color:FFF"></TD>
		<TD align="right" style="color:FFF">#NUMBERFORMAT(SUMTH013,"999,999,999")#</TD>
		</cfif>
		<TD></TD>
	</TR>

</table>


</cfoutput>


<!---設定此程式代號--->
<cfset program_id = "PUR301" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">


<cfif NOT IsDefined("URL.TC001")><cfset #URL.TC001#=""></cfif>
<cfif NOT IsDefined("URL.TC002")><cfset #URL.TC002#=""></cfif>
<cfif NOT IsDefined("URL.TC014")><cfset #URL.TC014#=""></cfif>
<cfif NOT IsDefined("URL.TC003_1")><cfset #URL.TC003_1#=""></cfif>
<cfif NOT IsDefined("URL.TC003_2")><cfset #URL.TC003_2#=""></cfif>
<cfif NOT IsDefined("URL.TD012_1")><cfset #URL.TD012_1#=""></cfif>
<cfif NOT IsDefined("URL.TD012_2")><cfset #URL.TD012_2#=""></cfif>
<cfif NOT IsDefined("URL.MA002")><cfset #URL.MA002#=""></cfif>
<cfif NOT IsDefined("URL.MB001")><cfset #URL.MB001#=""></cfif>
<cfif NOT IsDefined("URL.MB002")><cfset #URL.MB002#=""></cfif>
<cfif NOT IsDefined("URL.TD014")><cfset #URL.TD014#=""></cfif> 
<cfif NOT IsDefined("URL.TD016")><cfset #URL.TD016#=""></cfif> 


<cfsetting enablecfoutputonly="Yes">
<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="filename=採購單明細_#Dateformat(now(),"YYYY-MM-DD")#.xls">

<!---查詢未詢採購單資料--->
<cfquery datasource="#SESSION.COMPANY#" name="PURTC">
    SELECT  TOP 500 *
    FROM PURTD
	JOIN PURTC ON TC001=TD001 AND TC002=TD002
    JOIN PURMA ON TC004=MA001
	JOIN INVMB ON MB001=TD004
	LEFT JOIN PURTB ON TD026=TB001 AND TD027=TB002 AND TD028=TB003
	WHERE 1=1 AND TC014  <> 'V'
	<cfif URL.TC001 IS NOT ""> AND TC001 = '#URL.TC001#'</cfif>
	<cfif URL.TC002 IS NOT ""> AND TC002 = '#URL.TC002#'</cfif>
    <cfif URL.TC014 IS NOT ""> AND TC014 = '#URL.TC014#'</cfif>
	<cfif URL.TC003_1 IS NOT ""> AND  SUBSTRING(TC003,1,4)+'-'+ SUBSTRING(TC003,5,2)+'-'+SUBSTRING(TC003,7,2) >= '#URL.TC003_1#'</cfif>
	<cfif URL.TC003_2 IS NOT ""> AND  SUBSTRING(TC003,1,4)+'-'+ SUBSTRING(TC003,5,2)+'-'+SUBSTRING(TC003,7,2) <= '#URL.TC003_2#'</cfif>
	<cfif URL.TD012_1 IS NOT ""> AND  SUBSTRING(TD012,1,4)+'-'+ SUBSTRING(TD012,5,2)+'-'+SUBSTRING(TD012,7,2) >= '#URL.TD012_1#'</cfif>
	<cfif URL.TD012_2 IS NOT ""> AND  SUBSTRING(TD012,1,4)+'-'+ SUBSTRING(TD012,5,2)+'-'+SUBSTRING(TD012,7,2) <= '#URL.TD012_2#'</cfif>
	<cfif URL.MA002 IS NOT ""> AND  MA002 like '%#URL.MA002#%'</cfif>
    <cfif URL.MB001 IS NOT ""> AND MB001 like '#URL.MB001#%'</cfif>
    <cfif URL.MB002 IS NOT ""> AND MB002 like '%#URL.MB002#%'</cfif>
    <cfif URL.TD014 IS NOT ""> AND TD014 like '%#URL.TD014#%'</cfif>
    <cfif URL.TD016 IS NOT ""> AND TD016 = '#URL.TD016#'</cfif>
    ORDER BY TC003 DESC,TC001,TC002
</cfquery>

<cfoutput>

<table border="1">

<TR>
   <TH>單別-單號</TH>
   <TH>採購日期</TH>
   <TH>審核狀況</TH>
   <TH>預計交貨日</TH>
   <TH>廠商簡稱</TH>
   <TH>品號</TH>
   <TH>品名/規格</TH>  
   <TH>採購數量</TH>
   <TH>已交數量</TH>
   <TH>未交數量</TH>
   <cfif #價格權限# eq "Y">
   <TH>單價</TH>
   <TH>金額</TH>
   </cfif>
   <TH>單位</TH>
   <TH>備註</TH>
   <TH>專案代號</TH>
   <TH>進貨明細</TH>
   <TH>退貨明細</TH>
</TR>

<cfset SUMTD008=0>
<cfset SUMTD015=0>
<cfset SUMTD008_2=0>
<cfset SUMTD015_2=0>

<cfloop query="PURTC">

	<cfquery datasource="#SESSION.COMPANY#" name="PURTH">
		SELECT TG003,TH015
		FROM PURTH
		JOIN PURTG ON TG001=TH001 AND TG002=TH002
		WHERE 1=1 AND TG013 <> 'V'
		   AND TH011='#TD001#' AND TH012='#TD002#' AND TH013='#TD003#'
		   AND TH015 <> 0
		   ORDER BY  TG003,TH015 DESC
	</cfquery>
	
	<cfquery datasource="#SESSION.COMPANY#" name="PURTJ">
		SELECT TI003,TJ009*-1  AS TJ009
		FROM PURTJ
		JOIN PURTI ON TI001=TJ001 AND TI002=TJ002
		WHERE 1=1 AND TJ020 <> 'V'
		   AND TJ016='#TD001#' AND TJ017='#TD002#' AND TJ018='#TD003#'
		   AND TJ009 <> 0
		   ORDER BY  TJ003
	</cfquery>

	<cfset SUMTD008 = SUMTD008 + TD008>
	<cfset SUMTD015 = SUMTD015 + TD015>
		
	<tr>
		<TD align="center">#TRIM(TC001)#-#TRIM(TC002)#-#TRIM(TD003)#</TD>
		<TD>#MID(TC003,1,4)#-#MID(TC003,5,2)#-#MID(TC003,7,2)#
		<TD>#TB055#</TD> 
        <TD align="center" > #MID(TD012,1,4)#-#MID(TD012,5,2)#-#MID(TD012,7,2)#</TD>
		<TD align="center">#MA002#</TD>
		<td align="center" >#TD004#</td>
		<td width="300">#TD005#/#TD006#</td>
		<TD align="right" width="80">#NUMBERFORMAT(TD008,"9,999,999")#</TD>
		<TD>#NUMBERFORMAT(TD015,"9,999,999")#</TD>
		<TD>#NUMBERFORMAT(TD008-TD015,"9,999,999")#</TD>
		<cfif #價格權限# eq "Y">
        <TD align="right" width="60">#NUMBERFORMAT(TD010,"9,999,999.99")#</TD>
        <TD align="right" width="60">#NUMBERFORMAT(TD011,"99,999,999")#</TD>
		</cfif>
		<TD align="center">#TD009#</TD>
		<TD width="400">#TD014#</TD>
		<TD>#TD022#</TD>
		<TD align="center">
		   <cfloop query="PURTH">#MID(TG003,1,4)#/#MID(TG003,5,2)#/#MID(TG003,7,2)#(#NUMBERFORMAT(TH015,"9,999,999")#)<BR/></cfloop>
		</TD>
		<TD align="center">
		   <cfloop query="PURTJ">#MID(TI003,1,4)#/#MID(TI003,5,2)#/#MID(TI003,7,2)#(#NUMBERFORMAT(TJ009,"9,999,999")#)<BR/></cfloop>
		</TD>
	</tr>

</cfloop>


</table>

</cfoutput>


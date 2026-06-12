<!---設定此程式代號--->
<cfset program_id = "COP301" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("URL.TC001")><cfset #URL.TC001#=""></cfif> 
<cfif NOT IsDefined("URL.TC002")><cfset #URL.TC002#=""></cfif> 
<cfif NOT IsDefined("URL.TC003_1")><cfset #URL.TC003_1#=""></cfif>
<cfif NOT IsDefined("URL.TC003_2")><cfset #URL.TC003_2#=""></cfif>
<cfif NOT IsDefined("URL.MA002")><cfset #URL.MA002#=""></cfif> 
<cfif NOT IsDefined("URL.TD013_1")><cfset #URL.TD013_1#=""></cfif>
<cfif NOT IsDefined("URL.TD013_2")><cfset #URL.TD013_2#=""></cfif>
<cfif NOT IsDefined("URL.TC012")><cfset #URL.TC012#=""></cfif>
<cfif NOT IsDefined("URL.TD004")><cfset #URL.TD004#=""></cfif>
<cfif NOT IsDefined("URL.TD016")><cfset #URL.TD016#=""></cfif>  
<cfif NOT IsDefined("URL.TD021")><cfset #URL.TD021#=""></cfif>  

<cfif NOT IsDefined("URL.num")><cfset #URL.num#="200"></cfif> 


<cfsetting enablecfoutputonly="Yes">
<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="filename=客戶訂單_#dateformat(now(),"yyyy-mm-dd")#.xls">



<cfquery datasource="#SESSION.COMPANY#" name="COPTC">
    SELECT TOP #URL.num# *
    FROM COPTD
	JOIN COPTC ON TC001=TD001 AND TC002=TD002
	JOIN INVMB ON MB001=TD004
	JOIN COPMA ON MA001=TC004
	WHERE 1=1 AND TC027 <>'V' AND TD008 > 0
    <cfif URL.TC001 IS NOT ""> AND TC001 = '#URL.TC001#'</cfif>
    <cfif URL.TC002 IS NOT ""> AND TC002 like '#URL.TC002#%'</cfif>
    <cfif URL.MA002 IS NOT ""> AND MA002 like '%#URL.MA002#%'</cfif>
	<cfif URL.TC003_1 IS NOT ""> AND  SUBSTRING(TC003,1,4)+'-'+ SUBSTRING(TC003,5,2)+'-'+SUBSTRING(TC003,7,2) >= '#URL.TC003_1#'</cfif>
	<cfif URL.TC003_2 IS NOT ""> AND  SUBSTRING(TC003,1,4)+'-'+ SUBSTRING(TC003,5,2)+'-'+SUBSTRING(TC003,7,2) <= '#URL.TC003_2#'</cfif>
	<cfif URL.TD013_1 IS NOT ""> AND  SUBSTRING(TD013,1,4)+'-'+ SUBSTRING(TD013,5,2)+'-'+SUBSTRING(TD013,7,2) >= '#URL.TD013_1#'</cfif>
	<cfif URL.TD013_2 IS NOT ""> AND  SUBSTRING(TD013,1,4)+'-'+ SUBSTRING(TD013,5,2)+'-'+SUBSTRING(TD013,7,2) <= '#URL.TD013_2#'</cfif>
    <cfif URL.TC012 IS NOT ""> AND TC012 like '#URL.TC012#%'</cfif>
    <cfif URL.TD004 IS NOT ""> AND TD004 like '%#URL.TD004#%'</cfif>
    <cfif URL.TD016 IS NOT ""> AND TD016 = '#URL.TD016#'</cfif>
    <cfif URL.TD021 IS NOT ""> AND TD021 = '#URL.TD021#'</cfif>
	ORDER BY TC003 DESC,TC001,TC002

</cfquery>

<cfoutput>

<table border="1">

<TR>
	<TH>單別-單號</TH>
    <TH>訂單日期</TH>
    <TH>預交日期</TH>
	<TH>客戶簡稱</TH>
	<TH>會員</TH>
	<TH>品號</TH>
	<TH>品名<br/>規格</TH>
	<TH>訂單數量</TH>
	<TH>未交數量</TH>
	<cfif #價格權限# eq "Y">
	<TH>單價</TH>
	<TH>金額</TH>
	</cfif>
   <TH>出貨明細</TH>
</TR>

<cfset totalqty =0>
<cfset totalmoney =0>

<cfloop query="COPTC">

<cfset totalqty =totalqty + #TD008#>
<cfset totalmoney =totalmoney+#TD012#>

<cfquery datasource="#SESSION.COMPANY#" name="COPTH">
    SELECT TG003,TH008
    FROM COPTH
	JOIN COPTG ON TG001=TH001 AND TG002=TH002
	WHERE 1=1 AND TG023 <> 'V'
	   AND TH014='#TD001#' AND TH015='#TD002#' AND TH016='#TD003#'
	   AND TH008 <> 0
	   ORDER BY  TG003,TH008 DESC
</cfquery>

<cfquery datasource="#SESSION.COMPANY#" name="COPTJ">
    SELECT TJ001,TJ002,TI003,TJ007*-1  AS TJ007
    FROM COPTJ
	JOIN COPTI ON TI001=TJ001 AND TI002=TJ002
	WHERE 1=1 AND TJ021 <> 'V'
	   AND TJ018='#TD001#' AND TJ019='#TD002#' AND TJ020='#TD003#'
	   AND TJ007 <> 0
	   ORDER BY  TJ003
</cfquery>

    <tr >
		<TD align="center">
		   #TRIM(TC001)#-#TC002#
		  <cfif #TD016# EQ "Y"><br/><span class="badge badge-pill badge-success">已結案</span>
		  <cfelseif #TD016# EQ "y"><br/><span class="badge badge-pill badge-info">指定結案</span>
		  </cfif>
		  <cfif #TD021# EQ "Y"><br/><span class="badge badge-pill badge-success">已確認</span>
		  <cfelseif #TD021# EQ "N"><br/><span class="badge badge-pill badge-secondary">未確認</span>
		  <cfelseif #TD021# EQ "V"><br/><span class="badge badge-pill badge-danger">作廢</span>
		  </cfif>
		</TD>
        <TD align="center">
		    #MID(TC003,1,4)#-#MID(TC003,5,2)#-#MID(TC003,7,2)#
	    </TD>
        <TD align="center">
		    #MID(TD013,1,4)#-#MID(TD013,5,2)#-#MID(TD013,7,2)#
	    </TD>
		<TD align="center" width="100">#MA002#</TD> 
		<TD align="center" width="120">#TC012#</TD>
		<TD align="center">#TD004#</TD>
		<TD>#TD005#<br/>#TD006#</TD>
        <TD align="right" >#NUMBERFORMAT(TD008,"9,999,999")#</TD>
        <TD align="right" >#NUMBERFORMAT(TD008-TD009,"9,999,999")#</TD>
		<cfif #價格權限# eq "Y">
		<TD align="right">#NUMBERFORMAT(TD011,"9,999,999.99")#</TD>
		<TD align="right">#NUMBERFORMAT(TD012,"99,999,999")#</TD>
		</cfif>
		<TD align="center">
		   <cfloop query="COPTH">#MID(TG003,1,4)#/#MID(TG003,5,2)#/#MID(TG003,7,2)#(#NUMBERFORMAT(TH008,"9,999,999")#)<BR/></cfloop>
		</TD>
	</tr>
</cfloop>
	<TR>
		<TD colspan="6"></TD>
		<TD align="center">小計</TD>
		<TD align="right">#numberformat(TOTALQTY,"999,999,999")#</TD>
		<td></td>
		<td></td>
		<TD align="right">#numberformat(TOTALMONEY,"999,999,999")#</TD>
		<td></td>
	</TR>

</table>


</cfoutput>


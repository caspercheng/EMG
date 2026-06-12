<cfoutput>

<cfsetting enablecfoutputonly="Yes">
<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="filename=庫存明細表_#DATEFORMAT(NOW(),"YYYY-MM-DD")#.xls">

<cfif NOT IsDefined("URL.MB001")><cfset #URL.MB001#=""></cfif> 
<cfif NOT IsDefined("URL.MB002")><cfset #URL.MB002#=""></cfif> 
<cfif NOT IsDefined("URL.MB003")><cfset #URL.MB003#=""></cfif> 
<cfif NOT IsDefined("URL.MC002")><cfset #URL.MC002#=""></cfif> 
<cfif NOT IsDefined("URL.MC003")><cfset #URL.MC003#=""></cfif> 

<cfquery datasource="#SESSION.COMPANY#" name="INVMB">
    SELECT  MB001,MB002,MB003,MB004,CMSMC.MC002 AS MC002_1,INVMC. MC004 AS MC004,INVMC. MC007 AS MC007,INVMC. MC003 AS MC003
    FROM INVMC
	JOIN INVMB ON MB001=MC001
	LEFT JOIN CMSMC ON INVMC.MC002=CMSMC.MC001
	WHERE 1=1  
	     AND INVMC.MC007 <> 0
    <cfif URL.MB001 IS NOT ""> AND MB001 like '#URL.MB001#%'</cfif>
    <cfif URL.MB002 IS NOT ""> AND MB002 like '%#URL.MB002#%'</cfif>
    <cfif URL.MB003 IS NOT ""> AND MB003 like '%#URL.MB003#%'</cfif>
    <cfif URL.MC003 IS NOT ""> AND INVMC.MC003 like '#URL.MC003#%'</cfif>
    <cfif URL.MC002 IS NOT ""> AND INVMC.MC002 = '#URL.MC002#'</cfif>
	ORDER BY INVMC.MC003,MB001
</cfquery>

<table border="1">

<TR>
	<TH>品號</TH>
	<TH>品名</TH>
	<TH>規格</TH>	
	<TH>庫別</TH>
	<TH>儲存位置</TH>
	<TH>庫存數量</TH>
    <TH>單位</TH>
</TR>

<cfloop query="INVMB">

    <tr>
        <TD align="center">#MB001#</TD> 
		<TD>#MB002#</TD> 
		<TD>#MB003#</TD>		 
		<TD align="center">#MC002_1#</TD>
		<TD align="center">#MC003#</TD>
		<TD align="right">#NUMBERFORMAT(MC007,"9,999,999")#</TD>  
        <TD align="center">#MB004#</TD> 
	</tr>

</cfloop>

</table>

</cfoutput>
 

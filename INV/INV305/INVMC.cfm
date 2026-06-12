<title>庫存明細表</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "INV305" >
<cfset program_name = "庫存明細表" >
<cfset program_type = "Q" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">


<cfif NOT IsDefined("FORM.MB001")><cfset #FORM.MB001#=""></cfif> 
<cfif NOT IsDefined("FORM.MB002")><cfset #FORM.MB002#=""></cfif> 
<cfif NOT IsDefined("FORM.MB003")><cfset #FORM.MB003#=""></cfif> 
<cfif NOT IsDefined("FORM.MC002")><cfset #FORM.MC002#=""></cfif> 
<cfif NOT IsDefined("FORM.MC003")><cfset #FORM.MC003#=""></cfif> 
<cfif  NOT IsDefined("FORM.submit")> <cfset #FORM.submit#="">	</cfif> 

<h4><center>庫存明細表</center></h4>

<cfquery datasource="#SESSION.COMPANY#" name="CMSMC">
    SELECT  *
	FROM CMSMC
</cfquery>

<cfoutput>

<!---使用者查詢條件--->
<cfform action="INVMC.cfm" method="post">

	<table align="center" bgcolor="9999CC">
	 <tr>
	  <td>品號</td><td><cfinput type="text" size="15" name="MB001"></td>
	  <td>品名</td><td><cfinput type="text" size="15" name="MB002"></td>
	  <td>規格</td><td><cfinput type="text" size="10" name="MB003"></td>
	  <td>倉存位置</td><td><cfinput type="text" size="10" name="MC003"></td>
	  <td>庫別</td><td><select name="MC002"><cfloop query="CMSMC"><option value="#MC001#">#MC002#</option></cfloop></select></td>
	  <td colspan="1" align="center"><input type="submit" name="submit" value="查詢"></td>
	  </tr>
	</table>

</cfform>

<cfif #FORM.submit# neq "查詢"><cfabort></cfif>

<cfquery datasource="#SESSION.COMPANY#" name="INVMB">
    SELECT  MB001,MB002,MB003,MB004,CMSMC.MC002 AS MC002_1,INVMC. MC004 AS MC004,INVMC. MC007 AS MC007,INVMC. MC003 AS MC003
    FROM INVMC
	JOIN INVMB ON MB001=MC001
	LEFT JOIN CMSMC ON INVMC.MC002=CMSMC.MC001
	WHERE 1=1  
	     AND INVMC.MC007 <> 0
    <cfif FORM.MB001 IS NOT ""> AND MB001 like '#FORM.MB001#%'</cfif>
    <cfif FORM.MB002 IS NOT ""> AND MB002 like '%#FORM.MB002#%'</cfif>
    <cfif FORM.MB003 IS NOT ""> AND MB003 like '%#FORM.MB003#%'</cfif>
    <cfif FORM.MC003 IS NOT ""> AND INVMC.MC003 like '#FORM.MC003#%'</cfif>
    <cfif FORM.MC002 IS NOT ""> AND INVMC.MC002 = '#FORM.MC002#'</cfif>
	ORDER BY INVMC.MC003,MB001
</cfquery>

<a href="INVMC_excel.cfm?MB001=#FORM.MB001#&MB002=#FORM.MB002#&MB003=#FORM.MB003#&MC002=#TRIM(FORM.MC002)#&MC003=#FORM.MC003#" class="btn btn-success" target="_blank">轉EXCEL</a>

<div style="height:80%">
<table id="myTable01" class="fancyTable" >
<thead>

<TR bgcolor="666666" style="color:FFF">
	<TH>品號</TH>
	<TH>品名</TH>
	<TH>規格</TH>	
	<TH>庫別</TH>
	<TH>儲存位置</TH>
	<TH>庫存數量</TH>
    <TH>單位</TH>
</TR>

</thead>

<tbody>

<cfloop query="INVMB">

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
        <tr bgcolor="#bgcolor#">
         <TD align="center">#MB001#</TD> 
		<TD>#MB002#</TD> 
		<TD>#MB003#</TD>		 
		<TD align="center">#MC002_1#</TD>
		<TD align="center">#MC003#</TD>
		<TD align="right">#NUMBERFORMAT(MC007,"9,999,999")#</TD>  
        <TD align="center">#MB004#</TD> 
	</tr>

</cfloop>

</tbody>

</table>

</div>

</cfoutput>
 
<cfinclude template="/EMG/footer.cfm">

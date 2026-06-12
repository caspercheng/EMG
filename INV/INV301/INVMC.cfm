<title>品號再補貨建議表</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "INV301" >
<cfset program_name = "品號再補貨建議表" >
<cfset program_type = "Q" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">


<cfif NOT IsDefined("FORM.MB001")><cfset #FORM.MB001#=""></cfif> 
<cfif NOT IsDefined("FORM.MB002")><cfset #FORM.MB002#=""></cfif> 
<cfif NOT IsDefined("FORM.MB003")><cfset #FORM.MB003#=""></cfif> 
<cfif NOT IsDefined("FORM.MC002")><cfset #FORM.MC002#=""></cfif> 


<h4><center>品號再補貨建議表</center></h4>

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
	  <td>庫別</td><td><select name="MC002"><option value="">全部</option><cfloop query="CMSMC"><option value="#MC001#">#MC002#</option></cfloop></select></td>
	  <td colspan="1" align="center"><input type="submit" name="submit" value="查詢"></td>
	  </tr>
	</table>

</cfform>

<cfquery datasource="#SESSION.COMPANY#" name="INVMB">
    SELECT  *,CMSMC.MC002 AS MC002_1,INVMC. MC004 AS MC004,INVMC. MC007 AS MC007
    FROM INVMC
	JOIN INVMB ON MB001=MC001
	LEFT JOIN CMSMC ON INVMC.MC002=CMSMC.MC001
	WHERE 1=1  AND INVMC. MC004 <> 0
    <cfif FORM.MB001 IS NOT ""> AND MB001 like '#FORM.MB001#%'</cfif>
    <cfif FORM.MB002 IS NOT ""> AND MB002 like '%#FORM.MB002#%'</cfif>
    <cfif FORM.MB003 IS NOT ""> AND MB003 like '%#FORM.MB003#%'</cfif>
    <cfif FORM.MC002 IS NOT ""> AND INVMC.MC002 = '#FORM.MC002#'</cfif>
	ORDER BY MB001
</cfquery>

<div style="height:80%">
<table id="myTable01" class="fancyTable" >
<thead>

<TR bgcolor="666666" style="color:FFF">
	<TH>品號</TH>
	<TH>品名</TH>
	<TH>規格</TH>	
	<TH>庫別</TH>
    <TH>單位</TH>
	<TH>安全存量</TH>
	<TH>庫存數量</TH>
	<TH>狀態</TH>
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
        <TD align="center">#MB004#</TD> 
		<TD align="right">#NUMBERFORMAT(MC004,"9,999,999")#</TD>
		<TD align="right">#NUMBERFORMAT(MC007,"9,999,999")#</TD>    
		<TD align="center">
		     <cfif #NUMBERFORMAT(MC007,"9999999")# lt #NUMBERFORMAT(MC004,"9999999")#>
			    <span class="badge badge-pill badge-warning">庫存低於安全存量</span>
		     <cfelse>
			    <span class="badge badge-pill badge-success">庫存數量足夠</span>
			 </cfif>
	   </TD>		 
	</tr>

</cfloop>

</tbody>
</table>
</div>

</cfoutput>
 
<cfinclude template="/EMG/footer.cfm">

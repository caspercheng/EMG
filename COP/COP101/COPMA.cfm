<title>客戶查詢</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "COP101" >
<cfset program_name = "客戶基本資料" >
<cfset program_type = "Q" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("FORM.MA002")><cfset #FORM.MA002#=""></cfif> 
<cfif NOT IsDefined("FORM.MA003")><cfset #FORM.MA003#=""></cfif> 
<cfif NOT IsDefined("FORM.MA009")><cfset #FORM.MA009#=""></cfif> 
<cfif NOT IsDefined("FORM.MA011")><cfset #FORM.MA011#=""></cfif> 
<cfif NOT IsDefined("FORM.MA023")><cfset #FORM.MA023#=""></cfif> 

<h4 align="center">客戶查詢</h4>

<!---使用者查詢條件--->
<cfform action="COPMA.cfm" method="post">

	<table align="center" bgcolor="9999CC">
	 <tr>
	  <td>客戶簡稱</td><td><cfinput type="text" size="10" name="MA002"></td>
	  <td>公司全名</td><td><cfinput type="text" size="10" name="MA003"></td>
	  <td>聯絡地址</td><td><cfinput type="text" size="10" name="MA023"></td>
	  <td>E-mail</td><td><cfinput type="text" size="10" name="MA009"></td>
	  <td colspan="1" align="center"><input type="submit" name="submit" value="查詢"></td>
	  </tr>
	</table>

</cfform>
	
<cfquery datasource="#SESSION.COMPANY#" name="COPMA">
    SELECT  top 100*
    FROM COPMA
	WHERE 1=1
    <cfif FORM.MA002 IS NOT ""> AND MA002 like '%#FORM.MA002#%'</cfif>
    <cfif FORM.MA003 IS NOT ""> AND MA003 like '%#FORM.MA003#%'</cfif>
    <cfif FORM.MA011 IS NOT ""> AND MA011 like '%#FORM.MA011#%'</cfif>	
    <cfif FORM.MA023 IS NOT ""> AND MA023 like '%#FORM.MA023#%'</cfif>	
    <cfif FORM.MA009 IS NOT ""> AND MA009 like '%#FORM.MA009#%'</cfif>	
</cfquery>
	
<cfoutput>

<div style="height:85%">
<table id="myTable01" class="fancyTable">
<thead>

<TR bgcolor="666666" style="color:FFF">
   <TH>客戶代號</TH>
   <TH>客戶簡稱</TH>
   <TH>公司全名</TH>
   <TH>TEL</TH>
   <TH>FAX</TH>
   <TH>聯絡人</TH>
   <TH>聯絡地址</TH>
   <TH>E-mail</TH>
</TR>

</thead>

<tbody>

<cfloop query="COPMA">

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    
	<tr bgcolor="#bgcolor#">
		<TD align="center">#MA001#</TD> 
		<TD align="center">#MA002#</TD>
		<TD>#MA003#</TD>
		<TD>#MA006#</TD>
		<TD>#MA008#</TD>
		<TD align="center">#MA005#</TD>
        <TD>#MA023#</TD>
        <TD align="center">#MA009#</TD>
	</tr>

</cfloop>

</tbody>


</table>

</div>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">

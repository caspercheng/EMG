<title>供應商查詢</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "PUR101" >
<cfset program_name = "供應商資料" >
<cfset program_type = "Q" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("FORM.MA002")><cfset #FORM.MA002#=""></cfif> 
<cfif NOT IsDefined("FORM.MA005")><cfset #FORM.MA005#=""></cfif> 
<cfif NOT IsDefined("FORM.MA011")><cfset #FORM.MA011#=""></cfif> 
<cfif NOT IsDefined("FORM.MA014")><cfset #FORM.MA014#=""></cfif> 
<cfif NOT IsDefined("FORM.MA066")><cfset #FORM.MA066#=""></cfif> 
	
<h4><center>供應商查詢</center></h4>

<!---使用者查詢條件--->
<cfform action="PURMA.cfm" method="post">

	<table align="center" bgcolor="9999CC">
	 <tr>
	  <td>廠商簡稱</td><td><cfinput type="text" size="10" name="MA002"></td>
	  <td>統一編號</td><td><cfinput type="text" size="10" name="MA005"></td>
      <td>E-mail</td><td><cfinput type="text" size="15" name="MA011"></td>
	  <td>地址</td><td><cfinput type="text" size="10" name="MA014"></td>
	  <td colspan="1" align="center"><input type="submit" name="submit" value="查詢"></td>
	 </tr>
	</table>

</cfform>
	
<cfquery datasource="#SESSION.COMPANY#" name="PURMA">
    SELECT  *
    FROM PURMA
	LEFT JOIN CMSNA ON NA002=MA055 AND NA001='1'
	WHERE 1=1
    <cfif FORM.MA002 IS NOT ""> AND MA002 like '%#FORM.MA002#%'</cfif>
    <cfif FORM.MA005 IS NOT ""> AND MA005 = '#FORM.MA005#'</cfif>
    <cfif FORM.MA011 IS NOT ""> AND MA011 like '%#FORM.MA011#%'</cfif>	
    <cfif FORM.MA014 IS NOT ""> AND MA014 like '%#FORM.MA014#%'</cfif>
    <cfif FORM.MA066 IS NOT ""> AND MA066 like '%#FORM.MA066#%'</cfif>
</cfquery>

<cfoutput>

<div style="height:85%">
<table id="myTable01" class="fancyTable" >
<thead>

<TR bgcolor="666666" style="color:FFF">
   <TH>廠商代號</TH>
   <TH>廠商簡稱</TH>
   <TH>統一編號</TH>
   <TH>TEL</TH>
   <TH>FAX</TH>
   <TH>聯絡人</TH>
   <TH>聯絡地址</TH>
   <TH>E-mail</TH>
   <TH>付款條件</TH>
</TR>

</thead>

<tbody>
<cfloop query="PURMA">
	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
        
	<tr bgcolor="#bgcolor#">
		<TD align="center">#MA001#</TD> 
		<TD align="center">#MA002#</TD>
		<TD align="center">#MA005#</TD>
		<TD>#MA008#<cfif #MA009# GT "" AND #MA008# NEQ #MA009#><BR/>#MA009#</cfif></TD>
		<TD>#MA010#</TD>
		<TD align="center">#MA013#</TD>
		<TD>#MA014#</TD>
        <TD  width="250">#MA011#</TD>
        <TD>#NA003#</TD>
	</tr>
</cfloop>

</tbody>

</table>

</div>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">

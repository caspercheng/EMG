<title>品號查詢作業</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "INV101" >
<cfset program_name = "品號查詢作業" >
<cfset program_type = "Q" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">


<cfif NOT IsDefined("FORM.MB001")><cfset #FORM.MB001#=""></cfif> 
<cfif NOT IsDefined("FORM.MB002")><cfset #FORM.MB002#=""></cfif> 
<cfif NOT IsDefined("FORM.MB003")><cfset #FORM.MB003#=""></cfif> 
<cfif NOT IsDefined("FORM.MB005")><cfset #FORM.MB005#=""></cfif> 
<cfif NOT IsDefined("FORM.MB017")><cfset #FORM.MB017#=""></cfif> 
<cfif NOT IsDefined("FORM.MB028")><cfset #FORM.MB028#=""></cfif> 
<cfif NOT IsDefined("FORM.MB064")><cfset #FORM.MB064#=""></cfif> 
<cfif NOT IsDefined("FORM.num")><cfset #FORM.num#="100"></cfif> 

<cfquery datasource="#SESSION.COMPANY#" name="INVMA">
    SELECT  *
    FROM INVMA
	WHERE 1=1  AND MA001='1' 
</cfquery>

<cfquery datasource="#SESSION.COMPANY#" name="CMSMC">
    SELECT  MC001,MC002
    FROM CMSMC
	WHERE 1=1  
</cfquery>

<cfoutput >

<h4><center>品號查詢作業</center></h4>

<!---使用者查詢條件--->
<cfform action="INVMB.cfm" method="post">

	<table align="center" bgcolor="9999CC">
	 <tr>
	  <td>分類</td><td><select name="MB005"><option value="">全部</option><cfloop query="INVMA"><option value="#MA002#">#MA003#</option></cfloop></select></td>
	  <td>品號</td><td><cfinput type="text" size="15" name="MB001"></td>
	  <td>品名</td><td><cfinput type="text" size="12" name="MB002"></td>
	  <td>規格</td><td><cfinput type="text" size="4" name="MB003"></td>
	  <td>備註</td><td><cfinput type="text" size="10" name="MB028"></td>
	  <td>主要庫別</td><td><select name="MB017"><option value="">全部</option><cfloop query="CMSMC"><option value="#MC001#">#MC002#</option></cfloop></select></td>
	  <td>庫存數</td><td><select name="MB064"><option value="">全部</option><option value="1">數量大於0</option></select></td>
	  <td>筆數</td><td><select name="num"><option value="100">100</option><option value="500">500</option><option value="1000">1000</option><option value="2000">2000</option></select></td>               
	  <td colspan="1" align="center"><input type="submit" name="submit" value="查詢"></td>
	  </tr>
	</table>

</cfform>

<cfquery datasource="#SESSION.COMPANY#" name="INVMB">
    SELECT  top #FORM.num#  MB001,MB002,MB003,MB004,MB025,MB036,MB034,MB064,MB057,MB060,MB039,MB046,MB063,MB047,MB058,MB080,
	                PURMA.MA002 AS PURMA002,PURMA.MA001 AS PURMA001,
					INVMA.MA003 AS INVMA003,MB023,MB028,MC002
    FROM INVMB
	LEFT JOIN PURMA ON MB032=PURMA.MA001
	LEFT JOIN INVMA ON MB005=INVMA.MA002 AND INVMA.MA001='1'
	LEFT JOIN CMSMC ON MC001=MB017
	WHERE 1=1  AND MB031=''
    <cfif FORM.MB001 IS NOT ""> AND  MB001 like '%#FORM.MB001#%' </cfif>
    <cfif FORM.MB002 IS NOT ""> AND  MB002 like '%#FORM.MB002#%' </cfif>
    <cfif FORM.MB003 IS NOT ""> AND  MB003 like '%#FORM.MB003#%' </cfif>
    <cfif FORM.MB028 IS NOT ""> AND  MB028 like '%#FORM.MB028#%' </cfif>
    <cfif FORM.MB005 IS NOT ""> AND  MB005 = '#FORM.MB005#' </cfif>
    <cfif FORM.MB017 IS NOT ""> AND  MB017 = '#FORM.MB017#' </cfif>
    <cfif FORM.MB064 IS NOT ""> AND  MB064 > 0</cfif>
	ORDER BY MB001
</cfquery>


<div style="height:85%">
<table id="myTable01" class="fancyTable" >
<thead>

<TR bgcolor="666666" style="color:FFF">
	<TH width="150">品號</TH>
	<TH>品名/規格</TH>
	<TH>備註</TH>
	<TH>單位</TH>
	<TH>屬性</TH>
	<TH>分類</TH>
	<TH>主要庫別</TH>
	<TH>前置天數</TH>
	<TH>MOQ</TH>
	<TH>庫存數量</TH>
	<TH>明細</TH>
</TR>

</thead>
<tbody>

<cfloop query="INVMB">

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>

	<tr bgcolor="#bgcolor#" >
		<TD align="center">#MB001#</TD> 
		<TD>#MB002#<BR/>#MB003#</TD> 
		<TD>#MB028#</TD> 
		<TD align="center">#MB004#</TD> 
		<TD align="center">
			  <cfif #MB025# EQ "M"><span class="badge badge-secondary">自製件</span></cfif>	
              <cfif #MB025# EQ "P"><span class="badge badge-warning">採購件</span></cfif>
              <cfif #MB025# EQ "S"><span class="badge badge-success">加工件</span></cfif>
              <cfif #MB025# EQ "Y"><span class="badge badge-light">虛設件</span></cfif>
              <cfif #MB025# EQ "F"><span class="badge badge-info">選配件</span></cfif>
		</TD> 
		<TD align="center">#INVMA003#</TD> 
		<TD align="center">#MC002#</TD> 
		<TD align="center">#MB036#</TD> 
		<TD align="right"><cfif #MB039# NEQ 0>#NUMBERFORMAT(MB039,"9,999,999")#</cfif></TD>
		<TD align="right">
		    <cfif #MB064# NEQ 0>
			   <cfif #MB004#  EQ "KG">#NUMBERFORMAT(MB064,"9,999,999.99")#<cfelse>#NUMBERFORMAT(MB064,"9,999,999")#</cfif>
			 </cfif>
	    </TD>
		<TD align="center"><a href="INVMB_detail.cfm?MB001=#MB001#" target="_blank">明細</a></TD>
	</tr>

</cfloop>

</tbody>
</table>
</div>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">

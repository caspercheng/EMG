<title>產品查詢</title>
<cfinclude template="/EMG/menu.cfm">

<cfif  NOT IsDefined("FORM.MB001")> <cfset #FORM.MB001#="">	</cfif> 
<cfif  NOT IsDefined("FORM.MB002")> <cfset #FORM.MB002#="">	</cfif> 
<cfif  NOT IsDefined("FORM.MB001_2")> <cfset #FORM.MB001_2#="">	</cfif> 
<cfif  NOT IsDefined("FORM.MB002_2")> <cfset #FORM.MB002_2#="">	</cfif> 
<cfif  NOT IsDefined("FORM.MB003")> <cfset #FORM.MB003#="">	</cfif> 
<cfif NOT IsDefined("FORM.num")><cfset #FORM.num#="300"></cfif> 

<cfoutput>

<h4 align="center"><center>產品查詢</center></h4>

<cfform action="BOMMC.cfm" method="post">

	<table align="center" bgcolor="9999CC">
	 <tr>
	  <td>主件品號</td><td><cfinput type="text" size="30" name="MB001"></td>
	  <td>主件品名</td><td><cfinput type="text" size="20" name="MB002"></td>
	  <td>規格</td><td><cfinput type="text" size="20" name="MB003"></td>
	  <td>筆數</td><td><select name="num"><option value="500">500</option><option value="1000">1000</option><option value="2000">2000</option></select></td>
	  <td align="center"><input type="submit" name="submit" value="查詢"></td>
	  </tr>
	</table>

</cfform>

<cfquery datasource="#SESSION.COMPANY#" name="BOMMC">
    SELECT  top #FORM.num#  *
    FROM BOMMC
    JOIN INVMB ON MB001=MC001 
	LEFT JOIN INVMA ON MB006=INVMA.MA002 AND INVMA.MA001='2'
	WHERE 1=1 AND MB031='' 
	     AND MC010 NOT LIKE '%失效%'
    <cfif FORM.MB001 IS NOT ""> AND  MB001 like '%#FORM.MB001#%' </cfif>
    <cfif FORM.MB002 IS NOT ""> AND  MB002 like '%#FORM.MB002#%' </cfif>
    <cfif FORM.MB003 IS NOT ""> AND  MB003 like '%#FORM.MB003#%' </cfif>
	ORDER BY MB001
</cfquery>


<div style="height:85%">
<table id="myTable01" class="fancyTable" >
<thead>

<TR bgcolor="666666" style="color:FFF">
	<TH>主件品號</TH>
	<TH>品名<br/>規格</TH>
	<TH>單位</TH>
	<TH>屬性</TH>
	<TH>標準批量</TH>
	<TH>相關材料成本</TH>
</TR>

</thead>

<tbody>

<cfloop query="BOMMC">

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<tr bgcolor="#bgcolor#" >
		<TD >
		#MB001#
		</TD> 
		<TD width="500">#MB002#<br/>#MB003#</TD>
		<TD align="center">#MB004#</TD>
        <TD align="center">#MB025#</TD>
        <TD>#MC004#</TD>
        <TD><a href="bom.cfm?MB001=#TRIM(MB001)#" target="_blank">相關材料成本</a></TD>
	</tr>

</cfloop>

</tbody>


</table>

</div>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">


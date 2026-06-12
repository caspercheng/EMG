<title>轉撥單查詢</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "INV304" >
<cfset program_name = "轉撥單" >
<cfset program_type = "I" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("FORM.TB001")><cfset #FORM.TB001#=""></cfif>
<cfif NOT IsDefined("FORM.TB002")><cfset #FORM.TB002#=""></cfif>
<cfif NOT IsDefined("FORM.TB018")><cfset #FORM.TB018#=""></cfif>
<cfif NOT IsDefined("FORM.TA003_1")><cfset #FORM.TA003_1#=""></cfif>
<cfif NOT IsDefined("FORM.TA003_2")><cfset #FORM.TA003_2#=""></cfif>
<cfif NOT IsDefined("FORM.MB001")><cfset #FORM.MB001#=""></cfif> 
<cfif NOT IsDefined("FORM.MB002")><cfset #FORM.MB002#=""></cfif> 
<cfif NOT IsDefined("FORM.MB003")><cfset #FORM.MB003#=""></cfif> 
<cfif NOT IsDefined("FORM.num")><cfset #FORM.num#="500"></cfif> 

<h4><center>轉撥單查詢<center></h4>

<cfform action="INVTB.cfm" method="post">

	<table align="center" bgcolor="9999CC">
	 <tr>      
       <td>單別</td>
       <td><cfinput type="text"  name="TB001" size="1" maxlength="4" value=""></td> 
       <td>單號</td>
       <td><cfinput type="text"  name="TB002" size="10" maxlength="12"></td>          
	  <td>轉撥日期</td>
	  <td><cfinput type="date" name="TA003_1" >~</td>
	  <td><cfinput type="date" name="TA003_2" ></td>
	  <td>品號</td><td><cfinput type="text" size="15" name="MB001"></td>
	  <td>品名</td><td><cfinput type="text" size="10" name="MB002"></td>
      <td>確認碼</td>
	  <td>
	      <select name="TB018">
		     <option value="">全部</option>
			 <option value="N">未確認</option>
			 <option value="Y">已確認</option>
	      </select></td>
	  <td>筆數</td><td><select name="num"><option value="500">500</option><option value="1000">1000</option><option value="2000">2000</option></select></td>
	  <td colspan="1" align="center"><input type="submit" value="查詢" name="submit"></td>	  
	   </tr>
	</table>
	
</cfform>

<!---查詢轉撥單資料--->
<cfquery datasource="AGP" name="INVTB">
    SELECT   top #FORM.num# TB001,TB002,TB003,TB018,TA003,MB001,MB002,MB003,TB007,TB014,
	               CMSMC1.MC002 AS MC002_1,CMSMC2.MC002 AS MC002_2
    FROM INVTB
	JOIN INVTA ON TA001=TB001 AND TA002=TB002
    JOIN INVMB ON MB001=TB004
	JOIN CMSMC  AS CMSMC1 ON TB012=CMSMC1.MC001
	JOIN CMSMC  AS CMSMC2 ON TB013=CMSMC2.MC001
	WHERE 1=1  AND TB001 LIKE '12%' AND TB018 <> 'V'
	<cfif FORM.TB001 IS NOT ""> AND TB001 = '#FORM.TB001#'</cfif>
	<cfif FORM.TB002 IS NOT ""> AND TB002 = '#FORM.TB002#'</cfif>
	<cfif FORM.TB018 IS NOT ""> AND TB018 = '#FORM.TB018#'</cfif>
    <cfif FORM.MB001 IS NOT ""> AND  MB001 like '%#FORM.MB001#%' </cfif>
    <cfif FORM.MB002 IS NOT ""> AND  MB002 like '%#FORM.MB002#%' </cfif>
	<cfif FORM.TA003_1 IS NOT ""> AND  SUBSTRING(TA003,1,4)+'-'+ SUBSTRING(TA003,5,2)+'-'+SUBSTRING(TA003,7,2) >= '#FORM.TA003_1#'</cfif>
	<cfif FORM.TA003_2 IS NOT ""> AND  SUBSTRING(TA003,1,4)+'-'+ SUBSTRING(TA003,5,2)+'-'+SUBSTRING(TA003,7,2) <= '#FORM.TA003_2#'</cfif>
    ORDER BY TA003 DESC,TB001,TB002
</cfquery>

<cfoutput>


<div style="height:85%">
<table id="myTable01" class="fancyTable" >
<thead>

<TR  bgcolor="666666" style="color:FFF">
   <TH>單別-單號</TH>
   <TH>轉撥日期</TH>
   <TH>品號</TH>
   <TH>品名</TH>
   <TH>規格</TH>
   <TH>轉撥數量</TH>
   <TH>轉出庫</TH>
   <TH>轉入庫</TH> 
</TR>

</thead>
<tbody>

<cfloop query="INVTB">

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
 	
	<tr bgcolor="#bgcolor#">
		<TD align="center">#TRIM(TB001)#-#TRIM(TB002)#-#TRIM(TB003)#<cfif TB018 EQ "N"><span class="badge badge-warning">未確認</span></cfif></TD> 
		<TD align="center">#MID(TA003,1,4)#-#MID(TA003,5,2)#-#MID(TA003,7,2)#</TD>
		<TD align="center">#MB001#</TD>
		<TD>#MB002#</TD>
		<TD align="center">#MB003#</TD>
		<TD align="right">#NUMBERFORMAT(TB007,"9,999,999")#</TD>
		<TD align="center">#MC002_1#</TD>
		<TD align="center">#MC002_2#</TD>		
	</tr>

</cfloop>

</tbody>
</table>
</div>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">

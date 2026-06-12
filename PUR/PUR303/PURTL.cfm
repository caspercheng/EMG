<title>核價單查詢作業</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "PUR303" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">


<cfif NOT IsDefined("FORM.TL001")><cfset #FORM.TL001#=""></cfif>
<cfif NOT IsDefined("FORM.TL002")><cfset #FORM.TL002#=""></cfif>
<cfif NOT IsDefined("FORM.TL003_1")><cfset #FORM.TL003_1#=""></cfif>
<cfif NOT IsDefined("FORM.TL003_2")><cfset #FORM.TL003_2#=""></cfif>
<cfif NOT IsDefined("FORM.TL006")><cfset #FORM.TL006#=""></cfif>
<cfif NOT IsDefined("FORM.MA001")><cfset #FORM.MA001#=""></cfif>
<cfif NOT IsDefined("FORM.MA002")><cfset #FORM.MA002#=""></cfif>
<cfif NOT IsDefined("FORM.MB001")><cfset #FORM.MB001#=""></cfif> 
<cfif NOT IsDefined("FORM.MB002")><cfset #FORM.MB002#=""></cfif>
<cfif NOT IsDefined("FORM.TM019")><cfset #FORM.TM019#=""></cfif> 
<cfif NOT IsDefined("FORM.num")><cfset #FORM.num#="500"></cfif> 

<h4><center>核價單查詢作業<center></h4>

<cfform action="PURTL.cfm" method="post">

	<table align="center" bgcolor="9999CC">
	 <tr>
      
      <td>單別</td>
      <td><cfinput type="text"  name="TL001" size="1" maxlength="4" value=""></td>
 
      <td>單號</td>
      <td><cfinput type="text"  name="TL002" size="8" maxlength="12"></td>
          
	  <td>核價日期</td><td> 	  
	  <cfinput type="datefield" mask="yyyy-mm-dd" name="TL003_1" size="6" 
	  monthnames="一月,二月,三月,四月,五月,六月,七月,八月,九月,十月,十一月,十二月" firstdayofweek="1" maxlength="10">
	  ～
	  <td>
	  <cfinput type="datefield"   mask="yyyy-mm-dd" name="TL003_2" size="6" 
	  monthnames="一月,二月,三月,四月,五月,六月,七月,八月,九月,十月,十一月,十二月" firstdayofweek="1" maxlength="10" ></td>

      <td>廠商簡稱</td><td><cfinput type="text"  name="MA002" size="8" maxlength="20" ></td>
	  <td>品號</td><td><cfinput type="text" size="15" name="MB001"></td>
	  <td>品名</td><td><cfinput type="text" size="10" name="MB002"></td>
      <td>確認碼</td>
	  <td>
	      <select name="TL006">
		     <option value="">全部</option>
			 <option value="N">未確認</option>
			 <option value="Y">已確認</option>
	      </select></td>
	  <td>筆數</td><td><select name="num"><option value="500">500</option><option value="1000">1000</option><option value="2000">2000</option></select></td>
	  <td colspan="1" align="center"><input type="submit" value="查詢" name="submit"></td>
	  
	  </tr>
	</table>
	
</cfform>

<!---查詢未詢採購單資料--->
<cfquery datasource="#SESSION.COMPANY#" name="PURTL">
    SELECT top #FORM.num# *
    FROM PURTM
	JOIN PURTL ON TL001=TM001 AND TL002=TM002
    JOIN PURMA ON TL004=MA001
	JOIN INVMB ON MB001=TM004
	WHERE 1=1  AND TL006 <> 'V'
	<cfif FORM.TL001 IS NOT ""> AND TL001 = '#FORM.TL001#'</cfif>
	<cfif FORM.TL002 IS NOT ""> AND TL002 = '#FORM.TL002#'</cfif>
    <cfif FORM.TL006 IS NOT ""> AND TL006 = '#FORM.TL006#'</cfif>
    <cfif FORM.TM019 IS NOT ""> AND TM019 = '#FORM.TM019#'</cfif>
	<cfif FORM.TL003_1 IS NOT ""> AND  SUBSTRING(TL003,1,4)+'-'+ SUBSTRING(TL003,5,2)+'-'+SUBSTRING(TL003,7,2) >= '#FORM.TL003_1#'</cfif>
	<cfif FORM.TL003_2 IS NOT ""> AND  SUBSTRING(TL003,1,4)+'-'+ SUBSTRING(TL003,5,2)+'-'+SUBSTRING(TL003,7,2) <= '#FORM.TL003_2#'</cfif>
	<cfif FORM.MA002 IS NOT ""> AND  MA002 like '%#FORM.MA002#%'</cfif>
    <cfif FORM.MB001 IS NOT ""> AND  MB001 like '%#FORM.MB001#%' </cfif>
    <cfif FORM.MB002 IS NOT ""> AND  MB002 like '%#FORM.MB002#%' </cfif>
    ORDER BY TL003 DESC,TL001,TL002
</cfquery>

<cfoutput>

<div style="height:80%">
<table id="myTable01" class="fancyTable" >
<thead>

<TR bgcolor="666666" style="color:FFF">
   <TH>單別-單號</TH>
   <TH>核價日期</TH>
   <TH>廠商簡稱</TH>
   <TH>品號</TH>
   <TH>品名/規格</TH>
   <TH>生效日</TH>
   <TH>原單價</TH>
   <TH>新單價</TH>
   <TH>單位</TH>
   <TH>分量計價</TH>
   <TH>數量以上</TH>
   <TH>單價</TH>
   <TH>確認碼</TH>    
</TR>

</thead>

<tbody>

<cfloop query="PURTL">

	<cfquery name="PURTN" datasource="#SESSION.COMPANY#">
			SELECT *
			FROM PURTN
			WHERE  1=1
			AND TN001 = '#TM001#'
			AND TN002 = '#TM002#'
			AND TN003 = '#TM003#'
        </cfquery>

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>

 	<cfif TL006 EQ "Y"><cfset confirm="已確認"><cfelse><cfset confirm="未確認"></cfif>
    <cfset rate=#TM019# * 100>

	<tr bgcolor="#bgcolor#">
		<TD align="center">#TRIM(TL001)#-#TRIM(TL002)#</TD> 
		<TD align="center">#MID(TL003,1,4)#-#MID(TL003,5,2)#-#MID(TL003,7,2)#</TD>
		<TD align="center">#MA002#</TD>
		<TD align="center" >#TM004#</TD>
		<TD >#TM005#<BR/>#TM006#</TD>
		<TD align="center">#MID(TM014,1,4)#-#MID(TM014,5,2)#-#MID(TM014,7,2)#</TD>
		<TD align="right" width="60">#NUMBERFORMAT(TM018,"9,999,999.99")#</TD>
        <TD align="right" width="60">#NUMBERFORMAT(TM010,"9,999,999.99")#</TD>
		<TD align="center">#TM009#</TD>
		<cfif #TM008# eq "Y"><cfset bgcolor="66FF66"><TD align="center" bgcolor="#bgcolor#">V</TD></cfif>	
                <cfif #TM008# neq "Y"><TD align="center"></TD></cfif>
		<TD align="right"><cfloop query="PURTN">#NUMBERFORMAT(TN007,"9,999,999.99")# <BR/></cfloop></TD>
                <cfif #TM008# eq "Y"><cfset bgcolor="66FF66"><TD align="right" bgcolor="#bgcolor#"><cfloop query="PURTN">#NUMBERFORMAT(TN008,"9,999,999.99")#<BR/></cfloop></TD> 
		    <cfelse><TD align="right"><cfloop query="PURTN">#NUMBERFORMAT(TN008,"9,999,999.99")#<BR/></cfloop></TD></cfif>
    	    <TD align="center">#confirm#</TD>

	</tr>

</cfloop>

</tbody>

</table>

</div>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">

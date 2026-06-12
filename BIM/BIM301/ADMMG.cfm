<title>ERP權限查詢作業</title>

<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "BIM301" >
<cfset program_name = "權限查詢作業" >
<cfset program_type = "I" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("FORM.MG001")><cfset #FORM.MG001#=""></cfif>
<cfif NOT IsDefined("FORM.MG002")><cfset #FORM.MG002#=""></cfif>
<cfif NOT IsDefined("FORM.MF002")><cfset #FORM.MF002#=""></cfif>
<cfif NOT IsDefined("FORM.SUBMIT")><cfset #FORM.SUBMIT#=""></cfif>

<cfoutput>

<center><h4>ERP權限查詢作業</h4></center>

<!---資料查詢介面--->
<cfform action="ADMMG.cfm" method="post">
	<table align="center" bgcolor="9999CC">
	 <tr>
	  <td>使用者工號</td><td><cfinput type="Text" name="MG001" size="10" maxlength="20" value=""></td>	 
	  <td>，使用者名稱</td><td><cfinput type="Text" name="MF002" size="10" maxlength="20" value=""></td>
	  <td>，程式代號</td><td><cfinput type="Text" name="MG002" size="10" maxlength="20" value=""></td>	 
	  <td colspan="1" align="center"><input type="submit" name="submit" value="查詢"></td>
         </tr>
	</table>
</cfform>

<cfif #FORM.submit# neq "查詢">
   <cfabort>
</cfif>

<cfif #FORM.MG001# eq "" AND  #FORM.MG002# eq "" AND #FORM.MF002# eq "">
   <center><h4>請輸入條件!</h4></center>
   <cfabort>
</cfif>

<!---查詢人員資料--->
<cfquery name="DSCMB" datasource="PKOOL">
	SELECT *
	FROM DSCMB
	WHERE MB001 IN ('KS','FS','XC','LY','NLY','KK','HJ','FS_A','FS_B','XC_B','KK_A','TEST','XC_TEST','FS_TEST')
</cfquery>

<cflayout type="tab" tabheight="750">

<cfloop query="DSCMB">

<cflayoutarea title="#MB002#" align="center">

	<!---查詢人員資料--->
	<cfquery name="ADMMG" datasource="#trim(MB003)#">
		SELECT *
		,SUBSTRING(MG006,9,1) AS 新增1
		,SUBSTRING(MG006,1,1) AS 查詢1  
		,SUBSTRING(MG006,2,1) AS 修改1 
		,SUBSTRING(MG006,3,1) AS 刪除1 
		,SUBSTRING(MG006,4,1) AS 確認1
		,SUBSTRING(MG006,5,1) AS 取消確認1
		,SUBSTRING(MG006,6,1) AS 輸出1
		,SUBSTRING(MG006,7,1) AS 成本1
		,SUBSTRING(MG006,8,1) AS 售價1
		FROM ADMMG
		JOIN ADMMF ON MF001=MG001
		JOIN DSCSYS..ADMMB ON MB001=MG002
		<cfif FORM.MG001 IS NOT ""> AND MG001 = '#TRIM(FORM.MG001)#' </cfif>	
		<cfif FORM.MG002 IS NOT ""> AND MG002 = '#TRIM(FORM.MG002)#' </cfif>	
		<cfif FORM.MF002 IS NOT ""> AND MF002 = '#TRIM(FORM.MF002)#' </cfif>
		ORDER BY MG001,MG002
	</cfquery>        


   <table id='myTable01' class="fancyTable" >
        <thead>		
		<tr bgcolor="666666" style="color:FFF">
			<TH>項次</TH>
			<TH>使用者工號</TH>
			<TH>使用者名稱</TH>
			<TH>程式代碼</TH>
			<TH>程式名稱</TH>
			<TH>新增</TH>     
			<TH>查詢</TH>  
			<TH>修改</TH>  
			<TH>刪除</TH>      
			<TH>確認</TH>  
			<TH>取消確認</TH>  
			<TH>輸出</TH>    
			<TH>成本</TH>  
			<TH>售價</TH>  
		</tr>	
        </thead>
        <tbody>
	   <cfloop query="ADMMG">
		<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
		<tr bgcolor="#bgcolor#">
			<td align="center">#CurrentRow#</td>
			<td align="center">#MF001#</td>
			<td align="center">#MF002#</td>
			<td align="center">#MB001#</td>
			<td>#MB002#</td>
			<td align="center">#新增1#</TD>     
			<td align="center">#查詢1#</TD>  
			<td align="center">#修改1#</TD>  
			<td align="center">#刪除1#</TD>      
			<td align="center">#確認1#</TD>  
			<td align="center">#取消確認1#</TD>  
			<td align="center">#輸出1#</TD>    
			<td align="center">#成本1#</TD>  
			<td align="center">#售價1#</TD>  
		</tr>		
	   </cfloop>
        </tbody>	
   </table>

</cflayoutarea>

</cfloop>

</cflayout>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">

<title>公司別權限複製作業</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "BIM202" >
<cfset program_name = "公司別權限複製作業" >
<cfset program_type = "I" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("FORM.MG001")><cfset #FORM.MG001#=""></cfif>
<cfif NOT IsDefined("FORM.MG002")><cfset #FORM.MG002#=""></cfif>
<cfif NOT IsDefined("FORM.SUBMIT")><cfset #FORM.SUBMIT#=""></cfif>

<cfoutput>

<center><h4>公司別權限複製作業(來源：#SESSION.COMPANY_NAME#)</h4></center>

<!---查詢多公司資料--->
<cfquery name="DSCMB" datasource="PKOOL">
	SELECT *
	FROM DSCMB
	WHERE MB001 IN  ('KS','FS','XC','LY','NLY','KK','HJ','FS_A','FS_B','XC_B','KK_A','TEST','XC_TEST','FS_TEST')
	    AND MB001 <> '#SESSION.COMPANY#'
</cfquery>



<!---資料查詢介面--->
<cfform action="ADMMG_INSERT.cfm" method="post">
	<table align="center"  border="1">
	    <tr><td bgcolor="666666" style="color:FFF">使用者工號：</td> <td bgcolor="666666"><cfinput type="Text" name="MG001" size="10" maxlength="20"  value=""></td></tr>
	    <tr><td bgcolor="666666" style="color:FFF">拋轉公司別：</td> <td><cfloop query="DSCMB"><cfinput type="checkbox" name='check1' id='check_list' checked="no" style="zoom: 1.5"   value="'#Trim(MB003)#'"/>#MB002#</cfloop></td></tr>
	    <tr><td colspan="3" align="center"  bgcolor="666666"><input type="submit" name="submit" value="權限複製"></td></tr>
	</table>
</cfform>

</cfoutput>

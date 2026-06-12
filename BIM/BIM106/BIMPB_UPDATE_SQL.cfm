<!---人員資料更新---> 
<cfquery name="BIMPB_UPDATE" datasource="PKOOL">
     UPDATE BIMPB SET 
	 PB002 = '#FORM.PB002#',
	 PB004 = '#FORM.PB004#',
	 PB006 = '#FORM.PB006#'
	 
	 WHERE PB001 = '#FORM.PB001#'
</cfquery>

<cfinclude template="/EMG/menu.cfm">
<br/>
 <h4 class="alert alert-success"><center>資料更新完成！</center></h4>
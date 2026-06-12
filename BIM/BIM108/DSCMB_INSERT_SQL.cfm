<!---系統別資料新增---> 
<cfquery name="DSCMB_INSERT" datasource="PKOOL">
     INSERT INTO DSCMB(MB001,MB002,MB003,MB004)
     
     VALUES('#FORM.MB001#','#FORM.MB002#','#FORM.MB003#','Y')
</cfquery>



<cflocation url="DSCMB_INSERT.cfm">
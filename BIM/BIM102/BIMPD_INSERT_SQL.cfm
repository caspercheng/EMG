<!---系統別資料新增---> 
<cfquery name="BIMPD_INSERT" datasource="PKOOL">
     INSERT INTO BIMPD(PD001,PD002,PD003)
     
     VALUES('#FORM.PD001#','#FORM.PD002#','#FORM.PD003#')
</cfquery>



<cflocation url="BIMPD.cfm">
<!---檔案資料新增---> 
<cfquery name="BIMPI_INSERT" datasource="PKOOL">
     INSERT INTO BIMPI(PI001,PI002,PI003,PI004)
     
     VALUES('#TRIM(FORM.PI001)#','#FORM.PI002#','#FORM.PI003#','#FORM.PI004#')
</cfquery>

<cflocation url="BIMPI.cfm">
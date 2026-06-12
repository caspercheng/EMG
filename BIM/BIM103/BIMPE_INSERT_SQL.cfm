<!---檔案資料新增---> 
<cfquery name="BIMPE_INSERT" datasource="PKOOL">
     INSERT INTO BIMPE(PE001,PE002,PE003,PE004,PE005)
     
     VALUES('#TRIM(FORM.PE001)#','#FORM.PE002#','#FORM.PE003#','#FORM.PE004#','#FORM.PE005#')
</cfquery>

<cflocation url="BIMPE.cfm">
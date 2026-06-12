<!---人員權限新增---> 


<cfquery name="BIMPK_INSERT" datasource="PKOOL">
     INSERT INTO BIMPK(PK001,PK002)
     
     VALUES('#TRIM(FORM.PK001)#','#FORM.PK002#')
</cfquery>

<cflocation url="BIMPK.cfm?PI001=#FORM.PK001#">

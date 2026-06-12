
<!---Àx¦ì§ó·s--->
<cfquery datasource="#SESSION.COMPANY#" name="INVMC_UPDATE">
   UPDATE INVMC
   SET MC003='#FORM.MC003#'
    WHERE 1=1
         AND MC001='#FORM.MC001#'
         AND MC002='#FORM.MC002#'
</cfquery>


<cflocation url="INVMB_UPDATE_FORM.cfm?MB001=#FORM.MC001#">
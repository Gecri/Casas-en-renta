<cfscript>
// reload application if ?app_reload_key in querystring
if (structKeyExists(application.apex, 'getGlobalkey')){

    if (structKeyExists(url,application.apex.getGlobalKey('APP_RELOAD_KEY'))){
      reloadApplication(relocateurl=application.apex.apiutil.getURL());
    } 

}    
</cfscript>
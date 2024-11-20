<cfscript>
    // Override Taffy settings
    // See https://docs.taffy.io/#/3.5.0?id=variablesframework-settings
    
    variables.framework.allowCrossDomain = "true";
    variables.framework.docs.APIName = "Summit APEX";
    variables.framework.docs.APIVersion = "1.0";

    variables.framework.environments = {
		production = {
			disableDashboard = true,
			disabledDashboardRedirect = '',
            showDocsWhenDashboardDisabled = false
		}
	}
</cfscript>
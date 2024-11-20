<cfscript>
  // cf settings
  this.name = cgi.http_host & '_api';
  this.applicationManagement 	= true;
  this.applicationtimeout = createTimeSpan(5,0,0,0);
  this.enablerobustexception = true;
  this.mappings[ "/api" ] = "#getDirectoryFromPath(getCurrentTemplatePath())#api/";
  this.ormenabled = false;
  this.ormsettings.eventhandling = false;
  this.scriptprotect = 'all';
  this.serialization.preservecaseforstructkey = true;
  this.sessionManagement = false;  
</cfscript>
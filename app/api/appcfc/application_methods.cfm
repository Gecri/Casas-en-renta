<cfscript>  
  /** 
  * reloadApplication
  * @relocateurl string optional - Address to relocate to after reload
  */
  public void function reloadApplication(string relocateurl=''){
    ApplicationStop();
    if (len(trim(arguments.relocateurl))){
        location(arguments.relocateurl,false);
    }
  }
  
  /** 
  * registerGlobalMethods
  */
  public void function registerGlobalMethods(){
    structAppend(variables, application.apex, true);
  }

  /** 
  * getGlobalKey
  * @key string Env variable name
  * @fallback string Default value
  */
  public string function getGlobalKey(string key='', string fallback=''){
    var val = '';
    var env = {};
    var apex = application.apex;
    var keytr = trim(arguments.key);
    var keyre = replace(keytr,'_','','all');
    
    // get environment values from application scope via config.json
    try{
      env = apex.config.environment;
    } catch (any e){}

    // check application for value
    if (structKeyExists(env,keytr)){
        val = env[keytr];

    // get direct value of environment variable     
    } else {
      env  = CreateObject("java", "java.lang.System").getEnv();

      // check exact syntax
      if (structKeyExists(env,keytr)){
        val = env[keytr];
        
      // check without underscore (legacy support)
      } else if (structKeyExists(env,keyre)){
        val = env[keyre];
      
      // use fallback if not found anywhere
      } else {
        val = arguments.fallback;
      }

    }
    return val;
  }

  /** 
   * getEnvironment
   * overrides Taffy example function
   * set instance environment value in config.json.cfm API_MODE
   * configure environment definitions in framework_settings.cfm 
   * see getEnvironment() here https://github.com/atuttle/TaffyDocs/blob/main/src/3.2.0.md
   */
  public string function getEnvironments(){
    var returnEnv = 'development';
    if ( lcase(application.apex.getGlobalKey('API_MODE')) eq 'production' ){
      returnEnv = 'production';
    }
    return returnEnv;
  }

  /** 
  * parse_error
  * @errorObject errorStruct message as a struct
  * @jsonError string error struct
  */
  public any function parse_error(
        required struct errorObject
        ) {
        var compactError = {};
        
        compactError.message = arguments.errorObject.message;
        compactError.detail = arguments.errorObject.detail;
     
        compactError.tagContext = arguments.errorObject.tagContext; 
        
        var jsonError = serializeJSON(compactError);
        
        return jsonError;
    }
     
    /** 
    * log_error
    * @jsonError string error struct
    */
    public any function log_error(required string jsonError) {
        var currentDirPath = getDirectoryFromPath(getCurrentTemplatePath());
      
        var logDirPath = currentDirPath & "logs/";
        var logFilePath = logDirPath & "logfile.log";
        if (!directoryExists(logDirPath)) {
          directoryCreate(logDirPath);
        }
        var fileObject = fileOpen(logFilePath, "append");
    
        try {
            fileWrite(fileObject, jsonError & chr(13) & chr(10));
        } finally {
            fileClose(fileObject);
        }
    }
</cfscript>
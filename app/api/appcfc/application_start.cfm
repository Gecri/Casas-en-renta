<cfscript>

  // init global application.apex struct
  application.apex = {};
  variables.dsnerror = false;

  // register global methods to application.apex struct
  keys = structkeylist(this);
  for (i = 1; i LTE listlen(keys); i = i + 1) {
    key = listgetat(keys, i);
    if (iscustomfunction(this[key])and left(lcase(key), 2)NEQ "on") {
      structinsert(application.apex, key, this[key]);
    }
  }
  application.registerglobalmethods = this.registerglobalmethods;

  // get config values from config.json.cfm
  application.apex.config = [];
  try {
    application.apex.config = DeserializeJSON(FileRead(expandPath("./config.json.cfm")));
  } catch (any e) {
    writeDump(e);
    abort;
    throw(message = "Unable to read configuration data at application startup");
  }

  // include taffy global settings
	include "framework_settings.cfm";

  // set islocal flag
  param name = "application.apex.config.environment.islocal" default = "false";
  if (cgi.SERVER_NAME contains 'localhost') {
    application.apex.config.environment.islocal = true;
  }

  // set version
  param name = "application.apex.config.apexversion" default = "1.x";
  try {
    // read from file
    application.apex.config.apexversion = fileRead(expandPath("../../app/version.txt"));
  } catch (any e) {
    // no error for version data
  }

  // set datasource from config value
  try {
    this.datasource = application.apex.config.environment.DATASOURCE_NAME;
  } catch (any e) {
    throw(message = "Unable to set datasource name from global config");
  }

  // add custom functions to global struct  e.g. application.apex.dbutil
  // any .cfc file in the /cfc directory will be appended to application.apex
  // with methods available e.g. application.apex.dbutil.exec()
  rscfc = directoryList(expandPath("cfc"), false, "query");
  for (f in rscfc) {
    if (listLast(f.name, '.')eq 'cfc') {
      fname = lcase(listFirst(f.name, '.'));
      if (application.apex.config.environment.islocal) {
        application.apex[fname] = createObject('component', 'api.cfc.#fname#');
      } else {
        application.apex[fname] = createObject('component', 'cfc.#fname#');
      }
    }
  }

  // create dsn if not exists
  if (application.apex.getGlobalKey('CREATE_DSN')) {

    // check for active database connection
    // query will return '1' if db exists
    try {
      variables.dbping = application.apex.dbutil.exec(sql = "Select 1").result;
    } catch (any e) {
      variables.dsnerror = true;
    }

    // create datasource if no data returned
    if (variables.dsnerror OR dbping.recordcount < 1) {
      dsnargs = {
        datasource: this.datasource,
        adminpw: application.apex.getGlobalKey('cfconfig_adminPassword'),
        driver: application.apex.getGlobalKey('DATASOURCE_DRIVER'),
        db: application.apex.getGlobalKey('DATASOURCE_DB'),
        host: application.apex.getGlobalKey('DATASOURCE_HOST'),
        port: application.apex.getGlobalKey('DATASOURCE_PORT'),
        user: application.apex.getGlobalKey('DATASOURCE_USER'),
        pw: application.apex.getGlobalKey('DATASOURCE_PW')
      };

      application.apex.dbutil.createDSN(dsnargs);
    }
  }

  //init rsautil
  if (application.apex.config.environment.islocal) {
    application.apex.rsautil = new api.cfc.rsautil(privateKey = application.apex.getGlobalKey('PRIVATE_KEY'), publicKey = application.apex.getGlobalKey('PUBLIC_KEY'));
  } else {
    application.apex.rsautil = new cfc.rsautil(privateKey = application.apex.getGlobalKey('PRIVATE_KEY'), publicKey = application.apex.getGlobalKey('PUBLIC_KEY'));
  }
</cfscript>
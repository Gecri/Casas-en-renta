<cfscript>
  component extends = "taffy.core.api" {

    include "appcfc/application_settings.cfm";
    include "appcfc/application_methods.cfm";

    /**
	* init
	*/
    public component function init() {
      return this;
    }

    /**
	* onApplicationStart
	*/
    function onApplicationStart() {

      include "appcfc/application_start.cfm";
      return super.onApplicationStart();
    }

    /**
	* onRequestStart
	*/
    function onRequestStart() {
      include "appcfc/request_start.cfm";
      return super.onRequestStart();
    }

    /**
	* onTaffyRequest
	* called after request has been parsed and all request details are known
	* Return TRUE to allow the request to continue as intended.
	* Return a Representation Object to abort the request and return the contents.
	* The newRepresentation() or rep() method creates a new instance of your default * * * representation class,  then you can either use noData()
	* or if you want to have a response body, use setData()
	* to pass in the data to send back to the consumer
	*/
    function onTaffyRequest(verb, cfc, requestArguments, mimeExt, headers, methodMetadata, matchedURI) {

    
        
      
      return true;
    }
}
</cfscript>
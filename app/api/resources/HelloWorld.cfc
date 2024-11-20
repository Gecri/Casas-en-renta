component extends="taffy.core.resource" 
        taffy_uri="/HelloWorlds"
        taffy_docs_name="HelloWorld"
        displayname="HelloWorld" 
        hint="HelloWorld" 
        output="false" 
        access="remote"{

    function get() {
        return {
            "message" = "Hello, world!"
        };
    }
}

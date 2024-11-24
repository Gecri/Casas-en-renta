component
extends="taffy.core.resource"
taffy_uri="/register"
{
    public function get() {
        return representationOf({ "message": "Listado de personas" }).withStatus(200);
    }
}

component
extends="taffy.core.resource"
taffy_uri="/people/{personName}"
{
	public function get(string personName){
		//find the requested person, by name
		//then...
		return representationOf(someMemberObject).withStatus(200); //member might be a structure, ORM entity, etc
	}
}
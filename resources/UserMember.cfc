component
extends="taffy.core.resource"
taffy_uri="/users"
{
     // Propiedad para la fuente de datos
    this.datasource = "Real_Estate_DB"; // Cambia por el nombre de tu datasource configurado
    function get() {
        try {
            var query = queryExecute(
                "SELECT id_user, name, lastname, email, type_user, phone, creatio_at FROM Users",
                {},
                {datasource=this.datasource}
            );

            return representationOf(query).withStatus(200);
        } catch (any e) {
       
            return representationOf({error="Error al obtener usuarios", detail=e.message}).withStatus(500);
        }
    }
   function post(required struct body) {
        try {
            if (!len(this.datasource)) {
                return representationOf({ERROR="Datasource no configurado"}).withStatus(500);
            }
            queryExecute(
                "INSERT INTO Users (name, lastname, email, password, type_user, phone) VALUES (:name, :lastname, :email, :password, :type_user, :phone)",
                {
                    name: {value=body.name, cfsqltype="cf_sql_varchar"},
                    lastname: {value=body.lastname, cfsqltype="cf_sql_varchar"},
                    email: {value=body.email, cfsqltype="cf_sql_varchar"},
                    password: {value=body.password, cfsqltype="cf_sql_varchar"},
                    type_user: {value=body.type_user, cfsqltype="cf_sql_varchar"},
                    phone: {value=body.phone, cfsqltype="cf_sql_integer"}
                },
                {datasource=this.datasource}
            );

            return representationOf({message="Usuario creado exitosamente"}).withStatus(201);
        } catch (any e) {
            return representationOf({ERROR="Error al crear usuario", DETAIL=e.message}).withStatus(500);
        }
    }
}

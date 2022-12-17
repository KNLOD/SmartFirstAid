using LibPQ, Tables
include("Result.jl")
include("decrypt.jl")


mutable struct DatabaseRepository
	host::String
	port::String
	dbname::String
	user::String
	password::String

	function DatabaseRepository()
		host = "localhost"
		port = "5432"
		dbname = "first_aid_db"
		user = "admin"
		password = "root"
		new(host, port, dbname, user, password)
	end 
end


function connect_to_db()
	db = DatabaseRepository()
	conn = LibPQ.Connection("host=$(db.host) port=$(db.port) dbname=$(db.dbname) user=$(db.user) password=$(db.password)")


	return conn
end

function create_table()
	conn = connect_to_db()
	execute(conn, """
		CREATE TABLE IF NOT EXISTS keys (
		user_id integer references aid_user(id), 
		key varchar(255) UNIQUE NOT NULL PRIMARY KEY,
		rights_level varchar(10)) 
		""")
	close(conn)
end

function save_key(key::String, lvl::String)
	conn = connect_to_db()
	key = getKey(key) 
	LibPQ.load!((;key=[key], rights_level=[lvl]),
	      conn,
	      "INSERT INTO keys (key, rights_level) VALUES(\$1, \$2);")
	execute(conn, "COMMIT;")
	close(conn)

end

function is_key_in_db(key::String)
	conn = connect_to_db()
	key = getKey(key)
	result = execute(conn, "SELECT * FROM keys WHERE key=\$1", [key])
	data = columntable(result)
	if data.key == []
		close(conn)
		return Result("0", false)
	end

	close(conn)
	rights_level = data.rights_level[1]
	return Result(rights_level, true)
	
end




	



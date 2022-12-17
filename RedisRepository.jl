
include("decrypt.jl")
include("Result.jl") 
import Redis

mutable struct RedisRepository
	host::String
	port::Int
	db::Int
	
	function RedisRepository()
		new("0.0.0.0", 6379, 0)
	end
end

"""
Проверка наличия ключа в оперативной памяти
(In memory Database -> Redis) 
Возвращает nothing если ключа нет
Возввращяет Result(level, boolean) если ключ есть
"""
function is_key_in_memory(key::String)

	conn = connect()
	key = getKey(key)
	result = Redis.get(conn, key)
	Redis.disconnect(conn)

	if result == nothing
		println("No key in memory: $key")
		return nothing
	end

	return Result(result, true)


end


"""
Загружает ключ и уровень в Redis

"""

function load_key(key::String, lvl::Int64)
	conn = connect()
	decrypt_key = getKey(key)
	Redis.set(conn, decrypt_key, lvl) 
	Redis.disconnect(conn)
end

"""
Подключается к Redis

"""

function connect()
	redis = RedisRepository()
	conn = Redis.RedisConnection(host=redis.host, port=redis.port, db=redis.db)
	return conn
end










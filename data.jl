
import Redis
import LibPQ
include("decrypt.jl")
include("RedisRepository.jl")
include("DatabaseRepository.jl")




# Описывает логику проверки наличие ключа в БД


function authorize_user(key::String)
	db = Dict( getKey("key1") => "1", getKey("key2") => "2", getKey("key3") => "3")

	# Проверить есть ли ключ в оперативной памяти
	in_memory_result =  is_key_in_memory(key)
	if in_memory_result != nothing
		return in_memory_result
	end
	# Вернуть результат проверки в самой БД
	return is_key_in_db(key)


end


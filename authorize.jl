include("authorizationEvent.jl")
include("data.jl")
include("user.jl")


user = User("1", "key1")

# Проверка пользователя с правильным ключом и уровнем
result = execute_auth(authorizationEvent(user))

# Проверка пользователя с неправильным ключом доступа
wrong_user = User("3", "notValidKey")
execute_auth(authorizationEvent(wrong_user))


# Проверка ползьователя с правильным ключом, но с не соответсвующем ключу уровнем 
user_with_wrong_level = User("3", "key2")
execute_auth(authorizationEvent(user_with_wrong_level))

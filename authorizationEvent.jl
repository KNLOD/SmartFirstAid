include("data.jl")
include("user.jl")

# Событие выдачи ползьователю прав

mutable struct authorizationEvent
	user::User
	user_key::String
	user_level::String
	errorMessage::String
	function authorizationEvent(user::User, errorMessage::String="")
		new(user,
			user.authorization_key,
			user.level,
			errorMessage)

	end
end


# Выполнение события

function execute_auth(event::authorizationEvent)
	result = authorize_user(event.user_key)
	println(result)
	if (result.success)
		new_user = User(result.access_level, event.user_key)
		return authorizationEvent(new_user)
		
	else
		return authorizationEvent(User("0", ""), "User not found")
	end



end



import SHA 
# Хэширование ключа ->
# Защита от несанкцианированного доступа
function getKey(nfc_key::String)
	return bytes2hex(SHA.sha256(nfc_key))
end

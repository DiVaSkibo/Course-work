extends Node

#			Vars
enum Cipher {none, Caesar, Kagura, Iris, Janus}


#			Funcs
func encrypt(obj :Array[int], key :Array, cipher :Cipher, symbol :Array[String] = []) -> Array:
	match cipher:
		Cipher.Caesar: return [key[0] - obj[0], key[1] - obj[1]]
		Cipher.Kagura: return [symbol[0].repeat(key[0].length() + obj[0]), symbol[1].repeat(key[1].length() + obj[1])]
		Cipher.Iris: return [Color.from_hsv(key[0].h + obj[0] / 15., key[0].s, key[0].v), Color.from_hsv(key[1].h + obj[1] / 15., key[1].s, key[1].v)]
		Cipher.Janus: return [Vector2i(obj[0] % key[0], obj[0] / key[0]), Vector2i(obj[1] % key[1], obj[1] / key[1])]
		_: return []
func decrypt(enc :Array, key :Array, cipher :Cipher) -> Array[int]:
	match cipher:
		Cipher.Caesar: return [key[0] - enc[0], key[1] + enc[1]]
		Cipher.Kagura: return [enc[0].length() - key[0].length(), enc[1].length() - key[1].length()]
		Cipher.Iris: return [15. * (enc[0].h - key[0].h), 15. * (enc[1].h - key[1].h)]
		Cipher.Janus: return [enc[0].x + enc[0].y * key[0], enc[1].x + enc[1].y * key[1]]
		_: return []


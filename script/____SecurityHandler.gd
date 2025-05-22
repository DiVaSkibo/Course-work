extends Node

#			Vars
enum Cipher {none, Caesar, Kagura, Iris, Janus}


#			Funcs
func analyze(what :Text, key :Array, cipher :Cipher) -> bool:
	var isentence := -1
	var iword := 0
	for word in what.atext:
		var decode = decrypt(word.code, key, cipher)
		if decode[1] == 0:
			isentence = decode[0]
			iword = 0
		if decode[0] < isentence or decode[1] < iword: return false
		iword = decode[1]
	return true

func display_cipher() -> void:
	Dialogic.start("Cipher")

func encrypt(what :Array[int], key :Array, cipher :Cipher, symbol :Array[String] = []) -> Array:
	match cipher:
		Cipher.Caesar: return [key[0] - what[0], key[1] - what[1]]
		Cipher.Kagura: return [symbol[0].repeat(key[0].length() + what[0]), symbol[1].repeat(key[1].length() + what[1])]
		Cipher.Iris: return [Color.from_hsv(key[0].h + what[0] / 10., key[0].s, key[0].v), Color.from_hsv(key[1].h + what[1] / 20., key[1].s, key[1].v)]
		Cipher.Janus: return [Vector2i(what[0] % key[0], what[0] / key[0]), Vector2i(what[1] % key[1], what[1] / key[1])]
		_: return []
func decrypt(enc :Array, key :Array, cipher :Cipher) -> Array[int]:
	match cipher:
		Cipher.Caesar: return [key[0] - enc[0], key[1] - enc[1]]
		Cipher.Kagura: return [enc[0].length() - key[0].length(), enc[1].length() - key[1].length()]
		Cipher.Iris: return [10. * (enc[0].h - key[0].h), round(20. * (enc[1].h - key[1].h))]
		Cipher.Janus: return [enc[0].x + enc[0].y * key[0], enc[1].x + enc[1].y * key[1]]
		_: return []


extends Sprite

const COLORS = [Color("ffb286"), Color("eaffa3"), Color("c6e851"), Color("9ffca4"), Color("7eff84"), Color("a7cfa9"), Color("84f7d2"), Color("00ffad"), Color("00d3ff"), Color("85eaff"), Color("96bcc3"), Color("aac2ff"), Color("719aff"), Color("cbb6ff"), Color("ba9eff"), Color("f1b8ff"), Color("ffb8e9"), Color("d1abc6"), Color("ffc2ce"), Color("ff829c"), Color("ff587a"), Color("ffaf4e"), Color("fff0de"), Color("fff1f1") ]

export(String) var set

func _ready():
	texture = Util.textures[set][randi() % Util.textures[set].size()]
	
	if set == "planets":
		modulate = COLORS[randi() % COLORS.size()]
		var newScale = 0
		while newScale < 6:
			newScale = randi() % 14
		newScale = newScale/10.0
		scale = Vector2(newScale, newScale)
		 
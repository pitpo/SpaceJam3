extends Sprite

export(String) var set

func _ready():
	texture = Util.textures[set][randi() % Util.textures[set].size()]
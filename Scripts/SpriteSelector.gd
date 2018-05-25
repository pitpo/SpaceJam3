extends AnimatedSprite

var sprites = self.frames.animations

func _ready():
	animation = sprites[randi() % sprites.size()]["name"]

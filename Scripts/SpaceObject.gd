extends KinematicBody2D

export var mass = 1
var merged = false
var motion = Vector2()

func _ready():
	pass

func _process(delta):
	if !merged:
		var gravity = (Util.player.position - position).normalized()
		motion += gravity
		
		var collision = move_and_collide(motion)
		if collision: print(collision.collider.name)
		
		if collision and collision.collider.is_in_group("player"):
			collision.collider.add_object(self)
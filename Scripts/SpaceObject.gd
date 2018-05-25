extends KinematicBody2D

export var mass = 1
var merged = false
var motion = Vector2()

func _ready():
	pass

func _process(delta):
	if !merged:
		if true:#Util.player.MASS > mass:
			var gravity = (Util.player.position - position).normalized()
			motion += gravity
			
			var collision = move_and_collide(motion)
			
			if collision and collision.collider.is_in_group("player"):
				collision.collider.add_object(self)
		
		else:
			Util.player.gravitate(self)

func add_object(object):
	var gp = object.global_position
	object.merged = true
	object.get_parent().remove_child(object)
	add_child(object)
	object.add_to_group("player")
	object.global_position = gp
extends KinematicBody2D

export var mass = 1
var motion = Vector2()

func _ready():
	pass

func _process(delta):
	var gravity = (Util.player.position - position).normalized()
	motion += gravity
	
	move_and_collide(motion)
extends KinematicBody2D

export(int) var MASS
export(int) var SPEED # will be calculted dynamically from mass in the future
var velocity = Vector2()

func _init():
	Util.player = self

func _ready():
	# spawn next to a planer (earth? XD), orbitting around it
	pass
	
func _process(delta):
	
	# MOVEMENT
	# use controls to alter the vector
	
	# current implementation is temporary
	if Input.is_action_pressed("ui_right") && velocity.x < 20:
		velocity.x += 1
	elif velocity.x > 0:
		velocity.x -= 1
		
	if Input.is_action_pressed("ui_left") && velocity.x > -20:
		velocity.x -= 1
	elif velocity.x < 0:
		velocity.x += 1
		
	if Input.is_action_pressed("ui_up") && velocity.y > -20:
		velocity.y -= 1
	elif velocity.y < 0:
		velocity.y += 1
		
	if Input.is_action_pressed("ui_down") && velocity.y < 20:
		velocity.y += 1
	elif velocity.y > 0:
		velocity.y -= 1
	
	var curVelocity = velocity
	if velocity.length() > 0:
		curVelocity = curVelocity.normalized() * SPEED
	
	position += curVelocity * delta

func add_object(object):
	object.merged = true
	object.get_parent().remove_child(object)
	add_child(object)
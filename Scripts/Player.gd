extends Area2D

export(int) var MASS
export(int) var SPEED # will be calculted dynamically from mass in the future
var velocity = Vector2()

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
	
	position += velocity * delta
	
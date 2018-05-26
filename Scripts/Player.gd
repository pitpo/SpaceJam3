extends KinematicBody2D

var mass = 100
var speed = 400
var velocity = Vector2()

func _init():
	Util.player = self
	
func _ready():
	# spawn next to a planet (earth? XD), orbitting around it
	var pos = $"../StartingPlanet".position
	# adjust Y position to spawn at the top of the planet
	pos.y -= $"../StartingPlanet/Sprite".texture.get_width() * $"../StartingPlanet".scale.y / 2
	pos.y -= 100
	position = pos
	
	velocity.x = 1
	velocity.y = 0

func _process(delta):
	# player can slightly manipulate the movement vector
	if Input.is_action_pressed("ui_right"):
		velocity.x += 2
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 2
	
	if Input.is_action_pressed("ui_down"):
		velocity.y += 2
	
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 2
	
	rotation = velocity.normalized().angle()
	velocity = velocity.normalized() * speed
	move_and_collide(velocity * delta)
	var recentNodes = get_tree().get_nodes_in_group("player")
#	print(recentNodes.size())
	if recentNodes.size() < 22:
		for i in range(1, recentNodes.size()):
			recentNodes[i].hug_player()
	else:
		for i in range(recentNodes.size() - 21, recentNodes.size()):
			recentNodes[i].hug_player()

func gravitate(object):
	var dist = object.position - position
	# no idea what is going on down there but it works
	if (dist.length() < 3000):
		var gravity = dist.normalized() * (object.get_node("CollisionShape2D").shape.radius * object.scale.x * 3 / dist.length())
		if mass/object.mass/10 < 0.05:
			velocity += gravity * 0.95
		else:
			velocity += gravity * (1 - mass/object.mass/10)

func add_object(object):
	var gp = object.global_position
	var gr = object.global_rotation
	object.merged = true
	
	object.get_parent().remove_child(object)
	add_child(object)
	object.add_to_group("player")
	
	object.global_position = gp
	object.global_rotation = gr
	Util.player.mass += mass
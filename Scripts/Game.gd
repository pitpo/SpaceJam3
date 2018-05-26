extends Node2D

onready var background = $ParallaxBackground/ParallaxLayer/Background
onready var start_color = background.modulate

func _ready():
	randomize()
	
	for i in range(200):
		var cloud = load("res://Nodes/Cloud.tscn").instance()
		cloud.position = Vector2(rand_range(-10000, 10000), rand_range(-10000, 10000))
		cloud.z_index = rand_range(-100, 0)
		$Clouds.add_child(cloud)
	
	generate_belt(5000)

func _process(delta):
	background.modulate.r = min(start_color.r + Util.player.position.length() / 10000, 1)
	background.modulate.b = min(max(start_color.b - (Util.player.position.length() - 5335) / 10000, 0), start_color.b)
	$Clouds.modulate = background.modulate

func generate_belt(distance):
	for i in range(500):
		var trash = preload("res://Nodes/SpaceObjects/SmallTrash.tscn").instance()
		add_child(trash)
		var angle = randf() * PI * 2
		trash.position = Vector2(sin(angle) * distance, cos(angle) * distance)
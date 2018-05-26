extends Node2D

onready var background = $ParallaxBackground/ParallaxLayer/Background
onready var start_color = background.modulate

func _ready():
	randomize()

func _process(delta):
	background.modulate.r = min(start_color.r + Util.player.position.length() / 10000, 1)
	background.modulate.b = min(max(start_color.b - (Util.player.position.length() - 5335) / 10000, 0), start_color.b)

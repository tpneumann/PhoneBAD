extends Camera2D

# Declare member variables here. Examples:
var startx
var starty
var endgame = false

# Called when the node enters the scene tree for the first time.
func _ready():
	startx = global_position.x
	starty = global_position.y

func _physics_process(delta):
	if (!endgame):
		global_position = Vector2(startx, global_position.y)
	else:
		global_position = Vector2(startx, starty)

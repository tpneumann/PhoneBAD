extends Camera2D

# Declare member variables here. Examples:
var startx

# Called when the node enters the scene tree for the first time.
func _ready():
	startx = global_position.x

func _physics_process(delta):
	global_position = Vector2(startx, global_position.y)

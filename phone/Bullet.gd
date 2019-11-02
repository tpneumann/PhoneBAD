extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var SPEED = 100 

var shoot_dir = Vector2()

func fire(postion, direction):
	shoot_dir = direction
	self.position = position
	
	print("Bullet.gd ran")
	
	
	

func _physics_process(delta):
	move_and_slide(shoot_dir)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var speed = 200

var velocity = Vector2()
var rot_dir = 0
export (float) var rot_speed = 1.5
# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func get_input():
	velocity = Vector2()
	
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
		rot_dir += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
		rot_dir -+ 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	Vector2().rotated(rot_dir)
	get_node("PlayerSprite").rotation = velocity.angle() + deg2rad(90)
	#rotation += rot_dir * rot_speed * delta
	move_and_slide(velocity)


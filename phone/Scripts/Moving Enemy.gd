extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player
var playerRef
var followPlayer = false
var speed = 50
var aggroRange = 600
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0];
	playerRef = weakref(player);

func _physics_process(delta):
	if(playerRef.get_ref()):
		
		var dist = player.position - position
		if (dist.x + dist.y < aggroRange):
			followPlayer = true
		
		if (followPlayer):
			var playerAngle = get_angle_to(player.get_position()) + deg2rad(90)
			get_node("EnMovingSprite").rotation = playerAngle
			
			var dir = dist.normalized()
			move_and_slide(dir * speed)
		#print("playerAngle: " + String(playerAngle))
		#print("position: " + String(position))
	

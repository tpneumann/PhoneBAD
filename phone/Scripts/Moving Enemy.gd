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
var dir

onready var bullet_scene = preload("res://EnemyBullet.tscn")
var bulletTimer
var canShoot = true
var shotSpeed = .25

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0];
	playerRef = weakref(player);
	
	bulletTimer = Timer.new()
	bulletTimer.connect("timeout",self,"_on_bulletTimer_timeout") 
	add_child(bulletTimer)

func _physics_process(delta):
	if(playerRef.get_ref()):
		
		var dist = player.position - position
		if (abs(dist.x + dist.y) < aggroRange):
			followPlayer = true
		
		if (followPlayer):
			var playerAngle = get_angle_to(player.get_position()) + deg2rad(90)
			get_node("EnMovingSprite").rotation = playerAngle
			
			dir = dist.normalized()
			move_and_slide(dir * speed)
			
			if (canShoot):
				shoot()
			
func shoot():
	#print("pew pew" + String(rng.randf_range(1, 100)))
	
	canShoot = false
	bulletTimer.start(shotSpeed)
	
	var bullet = bullet_scene.instance()
	bullet.fire(self.global_position + dir * 40, dir.angle())
	get_parent().add_child(bullet)
	
func _on_bulletTimer_timeout():
	canShoot = true

extends KinematicBody2D

var player
var playerRef
var angle = 0
var spinSpeed = .25
var health = 1

onready var bullet_scene = preload("res://EnemyBullet.tscn")
var bulletTimer
var canShoot = true
var shotSpeed = .1

func _ready():
	player = get_tree().get_nodes_in_group("player")[0];
	playerRef = weakref(player);
	
	bulletTimer = Timer.new()
	bulletTimer.connect("timeout",self,"_on_bulletTimer_timeout") 
	add_child(bulletTimer)


func _physics_process(delta):
	if(playerRef.get_ref()):
		
		if canShoot:
			shoot()
		
		angle += spinSpeed
		if angle >= 90:
			angle = 0
		

func shoot():
	#print("pew pew" + String(rng.randf_range(1, 100)))
	
	canShoot = false
	bulletTimer.start(shotSpeed)
	
	var bullet1 = bullet_scene.instance()
	bullet1.fire(self.global_position, deg2rad(angle))
	get_parent().add_child(bullet1)
	
	var bullet2 = bullet_scene.instance()
	bullet2.fire(self.global_position, deg2rad(90  + angle))
	get_parent().add_child(bullet2)
	
	var bullet3 = bullet_scene.instance()
	bullet3.fire(self.global_position, deg2rad(180 + angle))
	get_parent().add_child(bullet3)
	
	var bullet4 = bullet_scene.instance()
	bullet4.fire(self.global_position, deg2rad(270 + angle))
	get_parent().add_child(bullet4)


func _on_bulletTimer_timeout():
	canShoot = true


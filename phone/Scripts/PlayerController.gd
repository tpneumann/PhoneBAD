extends KinematicBody2D

# Declare member variables here. Examples:

export (int) var speed = 200
onready var bullet_scene = preload("res://Bullet.tscn")
var canShoot = true
var bulletTimer
var shotSpeed = .1

var moving = false

var rng = RandomNumberGenerator.new()

var velocity = Vector2()
var dir = Vector2(0,0)
export (float) var rot_speed = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	bulletTimer = Timer.new()
	bulletTimer.connect("timeout",self,"_on_bulletTimer_timeout") 
	add_child(bulletTimer)
	
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func get_input():
	velocity = Vector2()
	
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
		moving = true
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
		moving = true
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
		moving = true
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
		moving = true
	
	dir = velocity.normalized()
	
	if Input.is_action_pressed('ui_accept') && canShoot:
		shoot()
	

func _physics_process(delta):
	
	moving = false
	
	get_input()
	if moving: 
		get_node("PlayerSprite").rotation = dir.angle() + deg2rad(90)
	else: 
		get_node("PlayerSprite").rotation = deg2rad(0)
	move_and_slide(dir * speed)
	
func shoot():
	#print("pew pew" + String(rng.randf_range(1, 100)))
	
	canShoot = false
	bulletTimer.start(shotSpeed)
	
	var bullet = bullet_scene.instance()
	#bullet.fire(self.global_position + velocity * 30, velocity.angle())
	if (moving):
		bullet.fire(self.position + dir * 30, dir.angle())
	else:
		bullet.fire(self.position + Vector2(0,30), deg2rad(270))
	get_parent().add_child(bullet)


func _on_bulletTimer_timeout():
	canShoot = true

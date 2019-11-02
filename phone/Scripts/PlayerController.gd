extends KinematicBody2D

# Declare member variables here. Examples:

export (int) var speed = 200
onready var bullet_scene = preload("res://Bullet.tscn")
var canShoot = true
var bulletTimer
var shotSpeed = .1

var rng = RandomNumberGenerator.new()

var velocity = Vector2()
var dir
var rot_dir = 0
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
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
		print("left")
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
		print("up")
		
	dir = velocity.normalized()
	
	if Input.is_action_pressed('ui_accept') && canShoot:
		shoot()
		print("pew pew " + String(rng.randf_range(1, 100)))
	

func _physics_process(delta):
	get_input()
	get_node("PlayerSprite").rotation = dir.angle() + deg2rad(90)
	move_and_slide(dir * speed)
	
func shoot():
	#print("pew pew" + String(rng.randf_range(1, 100)))
	
	canShoot = false
	bulletTimer.start(shotSpeed)
	
	var bullet = bullet_scene.instance()
	#bullet.fire(self.global_position + velocity * 30, velocity.angle())
	bullet.fire(self.global_position + dir * 75, dir.angle())
	get_parent().add_child(bullet)


func _on_bulletTimer_timeout():
	canShoot = true

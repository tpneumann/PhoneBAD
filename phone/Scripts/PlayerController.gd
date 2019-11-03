extends KinematicBody2D

# Declare member variables here. Examples:

export (int) var speed = 200
onready var bullet_scene = preload("res://Bullet.tscn")
onready var sceneRestart = preload("res://Prefabs/SceneRestarter.tscn")

onready var health5 = preload("res://Sprites/playerSprite5.png")
onready var health4 = preload("res://Sprites/playerSprite4.png")
onready var health3 = preload("res://Sprites/playerSprite3.png")
onready var health2 = preload("res://Sprites/playerSprite2.png")
onready var health1 = preload("res://Sprites/playerSprite1.png")

#onready var alarmScreen1 = preload("res://Sprites/__placeholderPhoneScreen.png")
#onready var alarmScreen2 = preload("res://Sprites/__placeholderPhoneScreen2.png")

var fone1
var fone2
onready var death1 = preload("res://Sprites/playerDeath1.png")
onready var death2 = preload("res://Sprites/playerDeat2.png")

var canShoot = true
var bulletTimer
var shotSpeed = .1

var winTime
var winDelay = 5
var booTime
var booDelay = 1.5

var health = 5

var moving = false

var hittable = true
var hitTimer
var hitDelay = .05

var rng = RandomNumberGenerator.new()

var velocity = Vector2()
var dir = Vector2(0,0)
export (float) var rot_speed = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	bulletTimer = Timer.new()
	bulletTimer.connect("timeout",self,"_on_bulletTimer_timeout") 
	add_child(bulletTimer)
	
	winTime = Timer.new()
	winTime.connect("timeout",self,"doBigWin")
	add_child(winTime)
	
	booTime = Timer.new()
	booTime.connect("timeout",self,"BOO")
	add_child(booTime)
	
	hitTimer = Timer.new()
	hitTimer.connect("timeout",self,"beHit")
	add_child(hitTimer)
	
	fone1 = get_parent().get_node("GUI").get_node("PhoneScreen1")
	fone2 = get_parent().get_node("GUI").get_node("PhoneScreen2")
	
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
	if (moving):
		bullet.fire(self.position + dir * 30, dir.angle())
	else:
		bullet.fire(self.position + Vector2(0,-30), deg2rad(270))
	get_parent().add_child(bullet)
	bullet.player = self

func _on_bulletTimer_timeout():
	canShoot = true

func takeShot():
	get_tree().call_group("enemybullet", "beDeleted")
	
	if (hittable):
		health -= 1
		
		hitTimer.start(hitDelay)
		hittable = false
		
		if(health > 0):
			setPlayerSprite()
		else:
			var redo = sceneRestart.instance()
			get_parent().add_child(redo)
			
			
			var sceneCamera = get_node("PlayerCamera")
			sceneCamera.current = false
			self.remove_child(sceneCamera)
			get_parent().add_child(sceneCamera)
			
			self.queue_free()
			get_parent().remove_child(self)
	if(health > 0):
		setPlayerSprite()
	else:
		self.playerDeath()
		
		##REMOVE ONCE CAMERA FIXED
		var t = Timer.new()
		t.set_wait_time(3)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		##REMOVE ONCE CAMERA FIXED

		var redo = sceneRestart.instance()
		get_parent().add_child(redo)
		self.queue_free()
		get_parent().remove_child(self)

func setPlayerSprite():
	if(health >= 5):
		get_node("PlayerSprite").set_texture(health5)
	elif(health == 4):
		get_node("PlayerSprite").set_texture(health4)
	elif(health == 3):
		get_node("PlayerSprite").set_texture(health3)
	elif(health == 2):
		get_node("PlayerSprite").set_texture(health2)
	elif(health == 1):
		get_node("PlayerSprite").set_texture(health1)
		

func winTimer():
	get_tree().call_group("enemybullet", "beDeleted")
	get_tree().call_group("enemy", "takeShot")
	
	winTime.start(winDelay)

func doBigWin():
	print("did big win?")
	fone1.visible = true
	booTime.start(booDelay)

func beHit():
	hittable = true

func BOO():
	fone1.visible = false
	fone2.visible = true

func playerDeath():
	get_node("PlayerSprite").visible = false; 
	get_node("PlayerSpriteDeath").visible = true; 
	get_node("PlayerSpriteDeath").play("default", false)





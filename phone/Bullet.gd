extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 600 

var velocity = Vector2()

var activeTimer
var timerCountdown = .1

var player

func _ready():
	activeTimer = Timer.new()
	activeTimer.connect("timeout",self,"_on_activeTimer_timeout") 
	add_child(activeTimer)
	get_node("BulletCollide").disabled = true
	activeTimer.one_shot = true
	activeTimer.start(timerCountdown)
	

func fire(pos, dir):
	rotation = dir
	global_position = pos
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision is KinematicCollision2D :
			
			var other = collision.collider
			if other.is_in_group("enemy"):
				other.takeShot()
				if (other.health <= 0 and other.is_in_group("final")):
					print("health be go?")
					player.winTimer()
			elif other.is_in_group("enemybullet"):
				other.queue_free()
			
			self.queue_free()
			#get_parent().remove_child(self)
		else:
			velocity = velocity.bounce(collision.normal)
	

func _on_activeTimer_timeout(): 
	get_node("BulletCollide").disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

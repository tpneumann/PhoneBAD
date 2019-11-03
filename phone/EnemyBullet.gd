extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 500

var velocity = Vector2()
var timerCountdown = .1

func fire(pos, dir):
	rotation = dir
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision is KinematicCollision2D :
			
			var other = collision.collider
			if other.is_in_group("player"):
				other.takeShot()
			elif !other.is_in_group("enemy"):
				self.queue_free()
				get_parent().remove_child(self)
		else:
			velocity = velocity.bounce(collision.normal)
	
	get_node("Sprite").visible = true


func beDeleted():
	self.queue_free()


extends Node2D

# Declare member variables here. Examples:
var sceneTimer
var restartTime = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	print("restarting...")
	sceneTimer = Timer.new()
	sceneTimer.connect("timeout", self, "restartScene")
	add_child(sceneTimer)
	sceneTimer.start(restartTime)
	






func restartScene():
	print("restarted")
	get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

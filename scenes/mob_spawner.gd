extends Node2D

@onready var main = get_node("/root/main")
var slime_spawn := preload("res://scenes/path_mob.tscn")

var spawn_x = 600
var spawn_y = -105

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn_wave"):
		var slime = slime_spawn.instantiate()
		slime.position.x = spawn_x
		slime.position.y = spawn_y
		main.add_child(slime)

	pass

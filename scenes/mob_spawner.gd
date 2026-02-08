extends Node2D

@onready var main = get_node("/root/main")
var slime_spawn := preload("res://scenes/path_mob.tscn")

var spawn_x = 600
var spawn_y = -105

var spawn_delay := 10.0
var min_spawn_delay := 0.25
var spawn_timer := 0.0
var difficulty_timer := 0.0
var amount_enemy = 1
var difficulty_cycle = 1

var rng = RandomNumberGenerator.new()

signal damage(count: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer += delta
	difficulty_timer += delta
	
	if spawn_timer >= spawn_delay:
		spawn_timer = 0.0
		spawn_mob()

	if difficulty_timer >= 20.0:
		difficulty_timer = 0.0
		difficulty_cycle += 1
		spawn_delay = max(min_spawn_delay, spawn_delay * 0.9)
		if difficulty_cycle % 5:
			amount_enemy += 1
	pass

func spawn_mob() -> void:
	var amount = rng.randi_range(1, amount_enemy)
	for a in amount:
		var slime = slime_spawn.instantiate()
		slime.position.x = rng.randf_range(spawn_x - 20.0, spawn_x + 20.0)
		slime.position.y = rng.randf_range(spawn_y - 20.0, spawn_y + 20.0)
		main.add_child(slime)

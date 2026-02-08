extends Node2D

@onready var main = get_node("/root/main")
var slime_spawn := preload("res://scenes/path_mob.tscn")
var mage_spawn := preload("res://scenes/path_mage.tscn")

var spawn_x = 600
var spawn_y = -105

var spawn_delay := 10.0
var min_spawn_delay := 0.25
var spawn_timer := 0.0
var difficulty_timer := 0.0
var amount_enemy = 1
var difficulty_cycle = 1

var mage_amount = 1
var mage_cycle = 0
var apocalypse = false

var dead:bool = false

var rng = RandomNumberGenerator.new()

signal damage(count: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dead:
		return
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
	if apocalypse:
		mage_cycle += 1
		if mage_cycle % 3 == 0:
			if mage_cycle % 9:
				mage_amount += 1
			var amount_mage = rng.randi_range(1, mage_amount)
			for a in amount_mage:
				var mage = mage_spawn.instantiate()
				mage.position.x = rng.randf_range(spawn_x - 20.0, spawn_x + 20.0)
				mage.position.y = rng.randf_range(spawn_y - 20.0, spawn_y + 20.0)
				main.add_child(mage)


func _on_timer_timeout() -> void:
	apocalypse = true
	print("apocalypse has started!")
	pass # Replace with function body.


func _on_player_death() -> void:
	dead = true
	queue_free()
	pass # Replace with function body.


func _on_timer_2_timeout() -> void:
	queue_free()
	pass # Replace with function body.

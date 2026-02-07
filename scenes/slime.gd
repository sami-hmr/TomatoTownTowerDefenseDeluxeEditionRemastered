extends CharacterBody2D

@onready var spool: StatPool = $StatPool
@onready var animated_sprite_2d = $AnimatedSprite2D
var timer = 0.0
var death_position: Vector2
var death_progress

func _ready() -> void:
	spool.pv = 100
	pass # Replace with function body.

func die() -> void:
	set_process_input(false)
	animated_sprite_2d.play("death")
	

func _physics_process(delta: float) -> void:
	spool.pv -= 1

	if spool.pv < 0:
		die()
		#queue_free()

extends CharacterBody2D

@onready var spool: StatPool = $StatPool
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var parent = get_parent()
@onready var mob_spawner = get_parent().get_parent().get_parent().get_parent().get_node("mob_spawner")
var damaged: bool = false

func _ready() -> void:
	spool.pv = 1000
	pass # Replace with function body.

func die() -> void:
	if !animated_sprite_2d.animation == "death":
		parent.move = false
		animated_sprite_2d.play("death")
		
func damage() -> void:
	mob_spawner.damage.emit(spool.pv)
	print("I damaged the village!")
	damaged = true
	die()
	pass

func _physics_process(delta: float) -> void:
	
	if parent.progress > 5000 && damaged == false:
		damage()
	
	if spool.pv <= 0:
		die()

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "death":
		queue_free()
	pass # Replace with function body.

func enemy() -> void:
	pass

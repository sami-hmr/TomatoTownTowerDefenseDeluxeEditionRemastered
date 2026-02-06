extends Node2D

@onready var ibuild = $IBuild
@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	$AnimatedSprite2D.play()
	pass

func update_animation() -> void:
	var anim_name = str(ibuild.level) + "_idle"
	if (anim.animation != anim_name):
		anim.animation = anim_name

func _process(delta: float) -> void:
	update_animation()

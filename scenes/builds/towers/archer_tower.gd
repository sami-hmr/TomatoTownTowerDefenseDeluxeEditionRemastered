extends Node2D

@onready var build = $BuildInfo
@onready var info = $Label
@onready var anim = $AnimatedSprite2D

@onready var select_btn = $Select
@onready var select_sp = $Select/SelectSprite


func _ready() -> void:
	# Tower animation
	anim.play()
	# Button animations
	select_sp.play()

func _process(delta: float) -> void:
	update_info()
	selection()
	update_animation()

func update_info() -> void:
	info.text = build.build_name + " - LvL." + str(build.level)

func selection() -> void:
	if select_btn.has_focus(): 
		if Input.is_action_just_pressed("upgrade_build") and build.level < 7:
			build.level += 1
		select_sp.visible = true
	else:
		select_sp.visible = false

func update_animation() -> void:
	# Select tower animation
	var anim_name = str(build.level) + "_idle"
	if (anim.animation != anim_name):
		anim.animation = anim_name

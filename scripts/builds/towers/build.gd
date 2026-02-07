extends Node2D

@onready var build = $BuildInfo
@onready var info = $Info
@onready var costs = $Cost
@onready var anim = $AnimatedSprite2D

@onready var select_btn = $Select
@onready var select_sp = $Select/SelectSprite
@onready var select_build = $BuildSelection

@export var timer_list: Array[float] = [
	5.0,
	10.0,
	15.0,
	20.0,
	25.0,
	30.0,
	35.0,
]
@onready var build_timer: Timer = $Building
@onready var timer_label: Label = $BuildTimer

func _ready() -> void:
	anim.play()
	select_sp.play()
	timer_label.visible = false
	info.visible = false
	select_build.visible = false
	info.text = build.build_name + " - LvL." + str(build.level)

func _process(delta: float) -> void:
	building_process()
	if build_timer.time_left > 0:
		timer_label.text = str(int(build_timer.time_left))
	if select_btn.has_focus():
		if build.level == 0:
			select_build.visible = true
			select_build.grab_focus()
			select_build.show_popup()
		else:
			select_sp.visible = true
		if Input.is_action_just_pressed("upgrade_build"):
			upgrade_build()
	else:
		select_sp.visible = false
	if !select_build.has_focus():
		select_build.visible = false

func building_process() -> void:
	if build_timer.time_left <= 0:
		return
	timer_label.text = str(int(build_timer.time_left))
	var progress: int = build_timer.time_left / timer_list[build.level] * 100
	if progress < 25:
		anim.frame = 3
	elif progress < 50:
		anim.frame = 2
	elif progress < 75:
		anim.frame = 1
	else:
		anim.frame = 0

func can_upgrade() -> bool:
	var actual_res: Resources = get_parent().get_node("Player").get_node("Resources")
	for name in costs.resource_list:
		if costs.get_resource(name) > actual_res.get_resource(name):
			return false
	for name in costs.resource_list:
		actual_res.update_resource(name, -costs.get_resource(name))
	return true

func upgrade_build() -> void:
	if build.level < 7 and build_timer.time_left <= 0 and can_upgrade():
		build.level += 1
	else:
		return
	timer_label.visible = true
	build_timer.wait_time = timer_list[build.level - 1]
	build_timer.start()
	anim.animation = str(build.level) + "_build"
	anim.stop()

func _on_building_timeout() -> void:
	timer_label.visible = false
	build_timer.stop()
	anim.animation = str(build.level) + "_idle"
	anim.play()
	info.visible = true
	info.text = build.build_name + " - LvL." + str(build.level)


func _on_build_selection(index: int) -> void:
	select_build.visible = false
	if index == 6:
		upgrade_build()

extends Node2D

@onready var build_list = $BuildList
@onready var info = $Info
@onready var anim = $AnimatedSprite2D

@onready var select_btn: Button = $Select
@onready var select_sp = $Select/SelectSprite
@onready var select_build = $BuildSelection

@onready var build_timer: Timer = $Building
@onready var timer_label: Label = $BuildTimer

var build_selected: int = -1
var costs: Resources = null
var build_info: BuildInfo = null

@onready var cooldown: Timer = $Reload

func _ready() -> void:
	anim.play()
	select_sp.play()
	timer_label.visible = false
	info.visible = false
	select_build.visible = false

func _process(delta: float) -> void:
	building_process()
	if build_timer.time_left > 0:
		timer_label.text = str(int(build_timer.time_left))
	if select_btn.has_focus():
		if build_info == null:
			select_build.visible = true
			select_build.grab_focus()
			select_build.show_popup()
		else:
			select_sp.visible = true
		if Input.is_action_just_pressed("upgrade_build") and can_upgrade():
			upgrade_build()
	else:
		select_sp.visible = false
	if !select_build.has_focus():
		select_build.visible = false

func building_process() -> void:
	if build_timer.time_left <= 0:
		return
	timer_label.text = str(int(build_timer.time_left))
	var progress: int = build_timer.time_left / costs.get_resource("time") * 100
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
	if build_info.level < 7 and build_timer.time_left <= 0:
		build_info.level += 1
	else:
		return
	costs = build_list.cost_list[build_selected].resources[build_info.level - 1]
	timer_label.visible = true
	build_timer.wait_time = costs.get_resource("time")
	build_timer.start()
	anim.animation = str(build_info.level) + "_build"
	anim.stop()

func _on_building_timeout() -> void:
	timer_label.visible = false
	build_timer.stop()
	anim.animation = str(build_info.level) + "_idle"
	anim.play()
	info.visible = true
	info.text = build_info.build_name + " - LvL." + str(build_info.level)


func _on_build_selection(index: int) -> void:
	select_build.visible = false
	index -= 1
	if index >= 4:
		index -= 1
	build_selected = index
	build_info = build_list.build_info_list[index]
	costs = build_list.cost_list[index].resources[0]
	if can_upgrade():
		upgrade_build()
	else:
		build_selected = -1
		build_info = null
		costs = null

func _on_cooldown() -> void:
	if build_timer.time_left > 0:
		return
	if build_selected == 0:
		var res: Resources = get_parent().get_node("Player").get_node("Resources")
		res.update_resource("wood", 10 * build_info.level)
	if build_selected == 1:
		var res: Resources = get_parent().get_node("Player").get_node("Resources")
		res.update_resource("stone", 5 * build_info.level)
	if build_selected == 2:
		var res: Resources = get_parent().get_node("Player").get_node("Resources")
		res.update_resource("iron", 2 * build_info.level)
	if build_selected == 3:
		var res: Resources = get_parent().get_node("Player").get_node("Resources")
		res.update_resource("juice", 1 * build_info.level)
	if build_selected == 4:
		pass

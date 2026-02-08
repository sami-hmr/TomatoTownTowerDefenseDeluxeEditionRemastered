extends Node2D

@onready var build_list = $BuildList
@onready var info = $Info
@onready var anim = $AnimatedSprite2D
@onready var select_btn: Button = $Select
@onready var select_sp = $Select/SelectSprite
@onready var select_build = $BuildSelection
@onready var reload: Timer = $Reload
@onready var build_timer: Timer = $Building
@onready var timer_label: Label = $BuildTimer
@onready var cost_info: Node2D = $UpgradeInfo
@onready var cooldown: Timer = $Reload
@onready var range_shape: CollisionShape2D = $range/shape
@onready var build_finished_anim : AnimatedSprite2D = $end_animation
@onready var building_sound: AudioStreamPlayer = $building_sound
@onready var building_ended_sound: AudioStreamPlayer = $building_ended_sound



var build_selected: int = -1
var costs: Resources = null
var build_info: BuildInfo = null
var selected : bool = false
var in_area: Array = []
var player


func _ready() -> void:
	range_shape.shape = range_shape.shape.duplicate()
	select_build.get_popup().id_focused.connect(_on_item_hovered)
	anim.play()
	select_sp.play()
	timer_label.hide()
	info.hide()
	select_build.hide()
	var children = get_parent().get_children()
	for child in children:
		if child.name == "Player":
			player = child
			print("found player")

func _process(delta: float) -> void:
	building_process()
	if build_timer.time_left > 0:
		timer_label.text = str(int(build_timer.time_left))
	if select_btn.has_focus():
		select_build.show()
		selected = true
		if build_info == null:
			select_build.hide()
			select_build.grab_focus()
			select_build.show_popup()
		else:
			select_sp.show()
			cost_info.show()
		if Input.is_action_just_pressed("upgrade_build") and can_upgrade():
			upgrade_build()
	else:
		select_sp.hide()
		if !select_build.has_focus():
			cost_info.hide()
	if !select_build.has_focus():
		select_build.hide()
	

func building_process() -> void:
	if build_timer.time_left <= 0 or build_info == null:
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
	if build_timer.time_left > 0:
		return false
	if build_selected <= 3 and build_info.level >= 3:
		return false
	elif build_info.level >= 7:
		return false
	var actual_res: Resources = get_parent().get_node("Player").get_node("Resources")
	for name in costs.resource_list:
		if costs.get_resource(name) > actual_res.get_resource(name):
			return false
	for name in costs.resource_list:
		actual_res.update_resource(name, -costs.get_resource(name))
	return true

func upgrade_build() -> void:
	build_info.level += 1
	reload.wait_time = build_info.cooldown[build_info.level - 1]
	range_shape.shape.radius = build_info.attack_range[build_info.level - 1]
	costs = build_list.cost_list[build_selected].resources[build_info.level - 1]
	player.shake_cam(10)
	building_sound.play()
	var next_cost: Resources = build_list.cost_list[build_selected].resources[build_info.level]
	cost_info.get_node("Text").text =\
						"Wood " + str(next_cost.get_resource("wood")) +\
						"\nStone " + str(next_cost.get_resource("stone")) +\
						"\nIron " + str(next_cost.get_resource("iron")) +\
						 "\nTime " + str(next_cost.get_resource("time"))
	timer_label.show()
	build_timer.wait_time = costs.get_resource("time")
	build_timer.start()
	anim.animation = str(build_info.level) + "_build"
	anim.stop()

func _on_building_timeout() -> void:
	timer_label.visible = false
	build_finished_anim.visible = true
	build_finished_anim.play("default")
	building_ended_sound.play()
	if (build_info == null):
		return
	timer_label.hide()
	build_timer.stop()
	anim.animation = str(build_info.level) + "_idle"
	anim.play()
	info.show()
	info.text = build_info.build_name + " - LvL." + str(build_info.level)

func _on_item_hovered(id: int):
	var cost = build_list.cost_list[id].resources[0]
	cost_info.get_node("Text").text =\
						"Wood " + str(cost.get_resource("wood")) +\
						"\nStone " + str(cost.get_resource("stone")) +\
						"\nIron " + str(cost.get_resource("iron")) +\
						 "\nTime " + str(cost.get_resource("time"))
	cost_info.show()

func _on_build_selection(index: int) -> void:
	select_build.hide()
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

func shoot_enemies():
	for enemy in in_area:
		if !is_instance_valid(enemy):
			return
		var bullet = preload("res://scenes/bullet.tscn").instantiate()
		self.add_child(bullet)
		bullet.global_position = self.global_position
		bullet.target = enemy
		return
	return

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
		shoot_enemies()

func _on_area_2d_body_entered(body: Node2D) -> void:
	var parent = body.get_parent()
	if body.has_method("enemy") or (parent and parent.has_method("enemy")):
		in_area.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	var parent = body.get_parent()
	if body.has_method("enemy") or (parent and parent.has_method("enemy")):
		var id = in_area.find(body)
		if id != -1:
			in_area.remove_at(id)


func _on_range_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if area.has_method("enemy") or (parent and parent.has_method("enemy")):
		in_area.append(area)

func _on_range_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if area.has_method("enemy") or (parent and parent.has_method("enemy")):
		var id = in_area.find(area)
		if id != -1:
			in_area.remove_at(id)

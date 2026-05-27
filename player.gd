extends CharacterBody2D
const SPEED = 500.0
const JUMP_VELOCITY = -580.0
var att = false
var game_over = false
var current_health = 3  # Текущее здоровье игрока
var max_health = 3      # Максимальное здоровье
@onready var camera = $Camera2D
@onready var attack_area = $"AnimatedSprite2D/ОбластьАтаки"

func change_cam(s:int):
	match s:
		1: #start
			camera.limit_left = -1791
			camera.limit_top = 0
			camera.limit_right = 1913
			camera.limit_bottom = 3081
		2:# tunnel
			camera.limit_left = -630
			camera.limit_top = 0
			camera.limit_right = 1986
			camera.limit_bottom = 3081
		3:# 1room
			camera.limit_left = 0
			camera.limit_top = -170
			camera.limit_right = 2039
			camera.limit_bottom = 1295
		4: # tunnelDoParkura
			camera.limit_left = 5
			camera.limit_top = -1800
			camera.limit_right = 1270
			camera.limit_bottom = 1300
		5: # паркур
			camera.limit_left = 0
			camera.limit_top = 230
			camera.limit_right = 3960
			camera.limit_bottom = 2400
		6: # тунель до босса
			camera.limit_left = 0
			camera.limit_top = 0
			camera.limit_right = 6595
			camera.limit_bottom = 1300
		7: #босс
			camera.limit_left = 10
			camera.limit_top = 0
			camera.limit_right = 3245
			camera.limit_bottom = 1400
		8: #тунель от босса
			camera.limit_left = 10
			camera.limit_top = 0
			camera.limit_right = 3200
			camera.limit_bottom = 1200
		9: #тунель вниз
			camera.limit_left = 0
			camera.limit_top = -1650
			camera.limit_right = 1280
			camera.limit_bottom = 2500
		10: #vilage
			camera.limit_left = 0
			camera.limit_top = -350
			camera.limit_right = 7200
			camera.limit_bottom = 1300


func _physics_process(delta: float) -> void:
	if game_over:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("attack"):
		if att == false:
			att = true
			if attack_area:
				attack_area.monitoring = true
				attack_area.monitorable = true
			$AnimatedSprite2D.play("Атака")
			await $AnimatedSprite2D.animation_finished
			if attack_area:
				attack_area.monitoring = false
			att = false


	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if (att == false):
			$AnimatedSprite2D.play("Прыжок")

	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor() and (att == false):
			$AnimatedSprite2D.play("Ходьба")
		elif att == false:
			$AnimatedSprite2D.play("Прыжок")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction == 1:
		$AnimatedSprite2D.flip_h = false 
	elif direction == -1:
		$AnimatedSprite2D.flip_h = true 

	move_and_slide()

func save_position_right(): #для перехода в правой части экрана
	var scene_name = get_tree().current_scene.name
	Global.scene_positions[scene_name] = global_position - Vector2(100,0) 

 
func save_position_back_ParkurTunel(): #для перехода в тунель с паркура
	var scene_name = get_tree().current_scene.name
	Global.scene_positions[scene_name] = global_position - Vector2(3800,3680)
func save_position_ToParkur(): #для перехода в тунель с паркура
	var scene_name = get_tree().current_scene.name
	Global.scene_positions[scene_name] = global_position + Vector2(3800,3750)

func save_position_back_Parkur(): #для перехода в паркур обратно
	var scene_name = get_tree().current_scene.name
	Global.scene_positions[scene_name] = global_position - Vector2(-100,900)
func save_position_ToBossTun(): #для перехода в тунель до босса
	var scene_name = get_tree().current_scene.name
	Global.scene_positions[scene_name] = global_position + Vector2(-100,900)

func save_position_left(): #для перехода в левой части экрана
	var scene_name = get_tree().current_scene.name
	Global.scene_positions[scene_name] = global_position + Vector2(100,0)
func save_position_ToBoss(): #для перехода в левой части экрана
	var scene_name = get_tree().current_scene.name
	Global.scene_positions[scene_name] = global_position - Vector2(6400,-180)

func save_position_BackTunToBoss(): #для перехода в левой части экрана
	var scene_name = get_tree().current_scene.name
	Global.scene_positions[scene_name] = global_position + Vector2(6400,-100)
func save_position_down(): #для перехода в нижней части экрана
	var scene_name = get_tree().current_scene.name
	Global.scene_positions[scene_name] = global_position - Vector2(0,100)
func save_position_up(): #для перехода в верхней части экрана
	var scene_name = get_tree().current_scene.name
	Global.scene_positions[scene_name] = global_position + Vector2(0,100)

func save_position_BackToBoss(): #для перехода в левой части экрана
	var scene_name = get_tree().current_scene.name
	Global.scene_positions[scene_name] = global_position + Vector2(3050,100)
func save_position_ToTunFromBos(): #для перехода в левой части экрана
	var scene_name = get_tree().current_scene.name
	Global.scene_positions[scene_name] = global_position - Vector2(3050,100)

func save_position_ToTunToVil(): #для перехода в левой части экрана
	var scene_name = get_tree().current_scene.name
	Global.scene_positions[scene_name] = global_position - Vector2(1850,2880)
func save_position_ToVillage(): #для перехода в левой части экрана
	var scene_name = get_tree().current_scene.name
	Global.scene_positions[scene_name] = global_position - Vector2(-180 ,2925)
	
func _on_шипы_большие_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		get_tree().reload_current_scene()	

func _on_шипы_малые_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		get_tree().reload_current_scene()

func _ready():
	collision_layer = 1
	collision_mask = 1
	# Отключаем столкновение с боссом (слой 2)
	set_collision_mask_value(2, false)
	if attack_area:
		attack_area.collision_mask = 2
		attack_area.body_entered.connect(_on_boss_hit)

	change_cam(Global.scen)
	var scene_name = get_tree().current_scene.name
	if Global.scene_positions.has(scene_name):
		global_position = Global.scene_positions[scene_name]
	else:
		# Можно оставить позицию по умолчанию или задать стартовую (Комент нейронки, я не чаю что это значит)
		pass

func _on_boss_hit(body):
	if body.name == "Boss" and att == true:
		
		body.hit()
func take_damage(amount: int = 1):
	if game_over:
		return
	
	current_health -= amount
	
	# Визуальный эффект (вспышка красным)
	modulate = Color(1, 0.3, 0.3)
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if current_health <= 0:
		die()

func die():
	if game_over:
		return
	game_over = true
	show_game_over("ВЫ ПРОИГРАЛИ!")



func hit():
	take_damage(1)


func show_game_over(message: String):
	# Быстрая перезагрузка через 0.5 секунды
	await get_tree().create_timer(0.2).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_tp_to_tunnel_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		Global.scen = 2
		change_cam(Global.scen)
		save_position_right()
		get_tree().change_scene_to_file.bind("res://tunel.tscn").call_deferred()

func _on_tp_to_prolog_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		Global.scen = 1
		change_cam(Global.scen)
		save_position_left()
		get_tree().change_scene_to_file.bind("res://prolog.tscn").call_deferred()

func _on_tp_tp_1_room_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		Global.scen = 3
		change_cam(Global.scen)
		save_position_right()
		get_tree().change_scene_to_file.bind("res://1_room.tscn").call_deferred()	

func _on_tp_to_tunnel_back_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		Global.scen = 2
		change_cam(Global.scen)
		save_position_left()
		get_tree().change_scene_to_file.bind("res://tunel.tscn").call_deferred()


func _on_tp_to_vert_tun_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		Global.scen = 4
		change_cam(Global.scen)
		save_position_up()
		get_tree().change_scene_to_file.bind("res://TunToParkur.tscn").call_deferred()


func _on_room_back_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		Global.scen = 3
		change_cam(Global.scen)
		#save_position_down()
		get_tree().change_scene_to_file.bind("res://1_room.tscn").call_deferred()


func _on_to_parkur_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		Global.scen = 5
		change_cam(Global.scen)
		save_position_ToParkur()
		get_tree().change_scene_to_file.bind("res://Parkur.tscn").call_deferred()
		print('Переход на паркур, лвл - ', + Global.scen)


func _on_back_to_vert_tunnel_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		Global.scen = 4
		change_cam(Global.scen)
		save_position_back_ParkurTunel()
		get_tree().change_scene_to_file.bind("res://TunToParkur.tscn").call_deferred()


func _on_to_tunnel_to_boss_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		Global.scen = 6
		change_cam(Global.scen)
		save_position_ToBossTun()
		get_tree().change_scene_to_file.bind("res://TunToBoss.tscn").call_deferred()


func _on_back_parkur_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		Global.scen = 5
		change_cam(Global.scen)
		save_position_back_Parkur()
		get_tree().change_scene_to_file.bind("res://Parkur.tscn").call_deferred()


func _on_to_boss_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		Global.boss_defeated = false
		Global.scen = 7
		change_cam(Global.scen)
		save_position_ToBoss()
		get_tree().change_scene_to_file.bind("res://BossRoom.tscn").call_deferred()


func _on_back_tun_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and Global.boss_defeated == true:
		Global.scen = 6
		change_cam(Global.scen)
		save_position_BackTunToBoss()
		get_tree().change_scene_to_file.bind("res://TunToBoss.tscn").call_deferred()


func _on_back_to_boss_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		Global.boss_defeated = false
		Global.scen = 7
		change_cam(Global.scen)
		save_position_BackToBoss()
		get_tree().change_scene_to_file.bind("res://BossRoom.tscn").call_deferred()


func _on_forfard_tun_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and Global.boss_defeated == true:
		Global.scen = 8
		change_cam(Global.scen)
		save_position_ToTunFromBos()
		get_tree().change_scene_to_file.bind("res://TunFromBoss.tscn").call_deferred()


func _on_to_tun_to_vil_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		Global.scen = 9
		change_cam(Global.scen)
		save_position_ToTunToVil()
		get_tree().change_scene_to_file.bind("res://TunToVil.tscn").call_deferred()


func _on_to_village_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		Global.scen = 10
		change_cam(Global.scen)
		save_position_ToVillage()
		get_tree().change_scene_to_file.bind("res://Village.tscn").call_deferred()

extends CharacterBody2D

@export var speed: Vector2 = Vector2(300, 200)
@export var shoot_delay: float = 1.2
@export var max_health: int = 10 # 10 жизней

var bullet_scene = preload("res://BOSS/player_bullet.tscn")
var player_ref = null
var game_over = false
var bullets_on_screen = 0
var max_bullets = 2
var current_health: int

func _ready():
	collision_layer = 2
	collision_mask = 1
	# Отключаем столкновение с игроком (слой 1)
	set_collision_mask_value(1, false)
	
	current_health = max_health
	create_health_bar()
	
	var random_direction = Vector2(
		choose([-1, 1]),
		choose([-1, 1])
	)
	velocity = speed * random_direction
	start_shooting()
	

func create_health_bar():
	var health_bar = ProgressBar.new()
	health_bar.name = "HealthBar"
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar.min_value = 0
	health_bar.size = Vector2(100, 15)
	health_bar.position = Vector2(-50, -70)
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.2, 0.2, 0.2)
	health_bar.add_theme_stylebox_override("bg", style)
	
	var fill_style = StyleBoxFlat.new()
	fill_style.bg_color = Color.RED
	health_bar.add_theme_stylebox_override("fill", fill_style)
	
	add_child(health_bar)

func update_health_bar():
	if has_node("HealthBar"):
		$HealthBar.value = current_health

func _physics_process(delta):
	if game_over:
		return
	
	var screen_size = get_viewport_rect().size
	var sprite_texture = $Sprite2D.texture
	#var half_width = (sprite_texture.get_width() * $Sprite2D.scale.x) / 2
	#var half_height = (sprite_texture.get_height() * $Sprite2D.scale.y) / 2
	var half_width = (sprite_texture.get_width() * $Sprite2D.scale.x) / 2
	var half_height = (sprite_texture.get_height() * $Sprite2D.scale.y) / 2
	
	if position.x - half_width <= 0 and velocity.x < 0:
		velocity.x = -velocity.x
		bounce_animation()
		position.x = half_width
	if position.x + half_width >= screen_size.x and velocity.x > 0:
		velocity.x = -velocity.x
		bounce_animation()
		position.x = screen_size.x - half_width
	if position.y - half_height <= 0 and velocity.y < 0:
		velocity.y = -velocity.y
		bounce_animation()
		position.y = half_height
	if position.y + half_height >= screen_size.y and velocity.y > 0:
		velocity.y = -velocity.y
		bounce_animation()
		position.y = screen_size.y - half_height
	
	move_and_slide()
	
	# Обновляем позицию полоски здоровья
	if has_node("HealthBar"):
		$HealthBar.position = Vector2(-50, -half_height - 20)
	
	if player_ref == null:
		player_ref = get_tree().current_scene.get_node_or_null("player")

func start_shooting():
	var timer = Timer.new()
	timer.wait_time = shoot_delay
	timer.autostart = true
	timer.timeout.connect(_on_shoot_timeout)
	add_child(timer)

func _on_shoot_timeout():
	if game_over:
		return
	shoot_at_player()

func shoot_at_player():
	if game_over:  # ← ДОБАВЬТЕ ЭТУ ПРОВЕРКУ
		return
	if player_ref == null:
		return
	if bullets_on_screen >= max_bullets:
		return
	if player_ref == null:
		return
	if bullets_on_screen >= max_bullets:
		return
	
	var direction_to_player = (player_ref.position - position).normalized()
	var spread = 0.15
	var random_offset = Vector2(randf_range(-spread, spread), randf_range(-spread, spread))
	var final_direction = (direction_to_player + random_offset).normalized()
	
	var new_bullet = bullet_scene.instantiate()
	new_bullet.position = position
	new_bullet.shooter = "boss"
	new_bullet.direction = final_direction
	new_bullet.speed = 500
	get_tree().current_scene.add_child(new_bullet)
	
	bullets_on_screen += 1
	await new_bullet.tree_exited
	bullets_on_screen -= 1

func bounce_animation():
	if $AnimationPlayer.has_animation("bounce"):
		$AnimationPlayer.play("bounce")

func hit():
	
	
	if game_over:
		return
	
	current_health -= 1
	update_health_bar()
	
	# Вспышка красным
	modulate = Color(1, 0.3, 0.3)
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if current_health <= 0:
		die()


func die():
	if game_over:
		return
	game_over = true
	Global.boss_defeated = true
	
	
	# Добавляем эффект исчезновения (опционально)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	await tween.finished
	
	# Удаляем босса
	queue_free()
	
	

func choose(array):
	array.shuffle()
	return array.front()

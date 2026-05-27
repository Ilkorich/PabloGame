extends Area2D

var speed = 800
var direction = Vector2.RIGHT
var shooter = ""

func _ready():
	body_entered.connect(_on_body_entered)
	
	# Автоматическое исчезновение через 3 секунды
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	# Игнорируем создателя пули
	if (shooter == "boss" and body.name == "Boss") or (shooter == "player" and body.name == "player"):
		return
	
	# Пуля босса попадает в игрока → поражение
	if shooter == "boss" and body.name == "player":
		if body.has_method("hit"):
			body.hit()
		queue_free()
		return
	
	# Пуля игрока попадает в босса → НЕ НАНОСИТ УРОН (только визуальный эффект)
	if shooter == "player" and body.name == "Boss":
		print("💥 Пуля попала в босса, но урон не нанесён! Нужен удар молотом.")
		# Можно добавить визуальный эффект (вспышку)
		flash_boss(body)
		queue_free()
		return
	
	# Попадание в другие объекты
	queue_free()

func flash_boss(boss):
	# Временная вспышка на боссе (опционально)
	var original_color = boss.modulate
	boss.modulate = Color(1, 0.5, 0.5)  # Розоватая вспышка
	await get_tree().create_timer(0.1).timeout
	boss.modulate = original_color

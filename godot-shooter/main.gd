extends Node2D
## Главная сцена: создаёт игрока, спавнит врагов, проверяет столкновения.

var player: Player
var label: Label
var spawn_timer: Timer
var score := 0
var game_over := false


func _ready() -> void:
	player = Player.new()
	player.position = get_viewport_rect().size / 2.0
	player.shoot.connect(_on_player_shoot)
	add_child(player)

	var ui := CanvasLayer.new()
	label = Label.new()
	label.position = Vector2(10, 10)
	label.add_theme_font_size_override("font_size", 24)
	ui.add_child(label)
	add_child(ui)

	spawn_timer = Timer.new()
	spawn_timer.wait_time = 1.2
	spawn_timer.timeout.connect(_spawn_enemy)
	add_child(spawn_timer)
	spawn_timer.start()
	_update_label()


func _unhandled_key_input(event: InputEvent) -> void:
	if game_over and event is InputEventKey and event.pressed and event.keycode == KEY_R:
		get_tree().reload_current_scene()


func _on_player_shoot(pos: Vector2, dir: Vector2) -> void:
	var b := Bullet.new()
	b.position = pos
	b.dir = dir
	add_child(b)


func _spawn_enemy() -> void:
	var size := get_viewport_rect().size
	var p := Vector2.ZERO
	match randi() % 4:
		0: p = Vector2(randf() * size.x, -20)
		1: p = Vector2(randf() * size.x, size.y + 20)
		2: p = Vector2(-20, randf() * size.y)
		3: p = Vector2(size.x + 20, randf() * size.y)
	var e := Enemy.new()
	e.position = p
	e.target = player
	e.speed = 90.0 + minf(score * 3.0, 150.0)  # со временем враги быстрее
	add_child(e)
	spawn_timer.wait_time = maxf(0.35, spawn_timer.wait_time * 0.98)


func _physics_process(_delta: float) -> void:
	if game_over:
		return
	for e in get_tree().get_nodes_in_group("enemies"):
		if e.position.distance_to(player.position) < Enemy.RADIUS + Player.RADIUS:
			_end_game()
			return
		for b in get_tree().get_nodes_in_group("bullets"):
			if b.is_queued_for_deletion():
				continue
			if e.position.distance_to(b.position) < Enemy.RADIUS + Bullet.RADIUS:
				b.queue_free()
				if e.hit():
					e.queue_free()
					score += 1
					_update_label()
				break


func _end_game() -> void:
	game_over = true
	spawn_timer.stop()
	player.set_process(false)
	label.text = "Игра окончена! Счёт: %d\nНажми R для рестарта" % score


func _update_label() -> void:
	label.text = "Счёт: %d" % score


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), Color(0.1, 0.13, 0.1))

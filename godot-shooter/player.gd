class_name Player
extends Node2D
## Игрок: движение WASD/стрелки, прицел мышью, стрельба ЛКМ.

signal shoot(pos: Vector2, dir: Vector2)

const SPEED := 300.0
const FIRE_DELAY := 0.15
const RADIUS := 16.0

var cooldown := 0.0


func _process(delta: float) -> void:
	var v := Vector2.ZERO
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP): v.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN): v.y += 1
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): v.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): v.x += 1
	position += v.normalized() * SPEED * delta
	var size := get_viewport_rect().size
	position = position.clamp(Vector2(RADIUS, RADIUS), size - Vector2(RADIUS, RADIUS))

	look_at(get_global_mouse_position())

	cooldown -= delta
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cooldown <= 0.0:
		cooldown = FIRE_DELAY
		shoot.emit(position + Vector2.RIGHT.rotated(rotation) * 26.0, Vector2.RIGHT.rotated(rotation))


func _draw() -> void:
	draw_circle(Vector2.ZERO, RADIUS, Color(0.3, 0.8, 0.3))
	draw_line(Vector2.ZERO, Vector2(28, 0), Color.WHITE, 6.0)

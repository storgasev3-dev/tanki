class_name Bullet
extends Node2D
## Пуля летит по прямой и удаляется за экраном.

const SPEED := 700.0
const RADIUS := 4.0

var dir := Vector2.RIGHT


func _ready() -> void:
	add_to_group("bullets")


func _process(delta: float) -> void:
	position += dir * SPEED * delta
	if not get_viewport_rect().grow(50).has_point(position):
		queue_free()


func _draw() -> void:
	draw_circle(Vector2.ZERO, RADIUS, Color.YELLOW)

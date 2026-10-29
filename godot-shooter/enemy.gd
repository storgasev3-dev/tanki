class_name Enemy
extends Node2D
## Враг преследует игрока. Умирает от нескольких попаданий.

const RADIUS := 14.0

var target: Node2D
var speed := 100.0
var hp := 2


func _ready() -> void:
	add_to_group("enemies")


func _process(delta: float) -> void:
	if is_instance_valid(target):
		position += (target.position - position).normalized() * speed * delta


func hit() -> bool:
	## Возвращает true, если враг убит.
	hp -= 1
	queue_redraw()
	return hp <= 0


func _draw() -> void:
	var c := Color(0.9, 0.2, 0.2) if hp > 1 else Color(0.9, 0.55, 0.55)
	draw_circle(Vector2.ZERO, RADIUS, c)

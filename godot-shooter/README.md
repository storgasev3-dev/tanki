# Шутер на Godot 4 (вид сверху)

Управление: **WASD / стрелки** — движение, **мышь** — прицел, **ЛКМ** — огонь, **R** — рестарт после проигрыша.

## Как запустить
1. Скачай Godot 4.2+ (https://godotengine.org/download).
2. В Project Manager нажми **Import** и выбери `godot-shooter/project.godot`.
3. Нажми **F5** (запуск проекта).

## Как это сделано (пошагово, если делать с нуля)

1. **Новый проект.** Project Manager → New Project, рендерер Compatibility/Forward+.
   Размер окна: Project Settings → Display → Window → 960×640.
2. **Главная сцена.** Создай сцену с корневым `Node2D`, назови `Main`, сохрани как `main.tscn`,
   Project Settings → Application → Run → Main Scene. Прикрепи скрипт `main.gd`.
3. **Игрок (`player.gd`).** Скрипт на базе `Node2D` с `class_name Player`.
   - Движение: опрашиваем клавиши в `_process`, складываем вектор, `normalize()`, умножаем на скорость и `delta`.
   - Прицел: `look_at(get_global_mouse_position())`.
   - Стрельба: при зажатой ЛКМ и истёкшем кулдауне испускаем сигнал `shoot(pos, dir)`.
   - Рисование: `_draw()` рисует круг и «ствол». Позже можно заменить на `Sprite2D`.
4. **Пуля (`bullet.gd`).** Движется по `dir * SPEED * delta`, удаляется через `queue_free()` за экраном.
   Добавляется в группу `bullets`.
5. **Враг (`enemy.gd`).** Каждый кадр двигается к `target` (игроку). Имеет `hp`; метод `hit()` отнимает жизнь.
   Группа `enemies`.
6. **Логика (`main.gd`).**
   - В `_ready` создаём игрока, `Label` на `CanvasLayer` (счёт) и `Timer` для спавна врагов.
   - Игрок испускает `shoot` → `main` создаёт `Bullet`.
   - Таймер → `_spawn_enemy()`: враг появляется за случайным краем экрана; интервал спавна и скорость растут (сложность).
   - В `_physics_process` проверяем расстояния: враг–игрок (проигрыш), пуля–враг (урон, +1 очко).
   - `R` → `get_tree().reload_current_scene()`.

Все объекты создаются кодом (`Player.new()` и т.д.), поэтому сцена одна и ассеты не нужны.

## Что улучшить дальше
- Заменить круги на спрайты (`Sprite2D`) и добавить звуки (`AudioStreamPlayer`).
- Использовать `CharacterBody2D` и `Area2D` + `CollisionShape2D` вместо ручной проверки расстояний.
- Разные типы врагов, бонусы (скорострельность, здоровье), волны, меню и сохранение рекорда (`FileAccess`/`ConfigFile`).
- Экспорт: Project → Export (Windows, Linux, Web, Android).

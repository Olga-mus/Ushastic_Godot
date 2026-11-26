extends Node2D

# ============================================================
# НАСТРОЙКИ ПЕРСОНАЖА (настраиваются в инспекторе)
# ============================================================
@export var eyelid_color: Color = Color(0.683, 0.521, 0.329, 1.0)  # оранжевый по умолчанию
@onready var blink: AnimationPlayer = $Blink
@onready var blink_timer: Timer = $BlinkTimer
@onready var eyelid: Sprite2D = $Eyelid

@onready var pupil: Sprite2D = $EyesBlack #зрачок
# Запоминаем начальную позицию зрачка (чтобы уметь возвращать его в центр)
@onready var pupil_start_pos = pupil.position

@export_group("Blink Timing")
@export var blink_interval_min: float = 0.5
@export var blink_interval_max: float = 2.0

func _ready():
	print(pupil)
	#при старте сцены красит веки в цвет eyelid_color
	_apply_eyelid_color()
	blink_timer.wait_time = randf_range(blink_interval_min, blink_interval_max)
	blink_timer.timeout.connect(_on_blink_timeout)
	blink_timer.start()
	print(eyelid_color)

func _on_blink_timeout():
	blink.play("blink")
	blink_timer.wait_time = randf_range(blink_interval_min, blink_interval_max)
	blink_timer.start()
	
#красит веко 
func _apply_eyelid_color():
	eyelid.modulate = eyelid_color
	
# ============================================================
# ⭐ ФУНКЦИИ ВЗГЛЯДА
# ============================================================

# Посмотреть налево (на Мишку)
func look_left():
	var tween = create_tween()
	# Двигаем зрачок влево и немного вниз
	tween.tween_property(pupil, "position", pupil_start_pos + Vector2(-8, -1), 0.3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

# Посмотреть направо (на Птичку)
func look_right():
	var tween = create_tween()
	# Двигаем зрачок вправо и немного вверх
	tween.tween_property(pupil, "position", pupil_start_pos + Vector2(7, -1), 0.3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

# Посмотреть в центр (вернуться в исходное положение)
func look_center():
	var tween = create_tween()
	tween.tween_property(pupil, "position", pupil_start_pos, 0.3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

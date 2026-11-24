extends Node2D

@onready var anim: AnimationPlayer = $Walk
var breath_tween: Tween
var base_y: float

func _ready():
	base_y = position.y # Запоминаем исходную высоту стояния на земле
	anim.play("walk")
	start_breathing_animation()

func start_breathing_animation():
	if breath_tween:
		breath_tween.kill()
		
	breath_tween = create_tween().set_loops()
	breath_tween.tween_property(self, "position:y", base_y + 8.0, 1.2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	breath_tween.tween_property(self, "position:y", base_y, 1.2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

func jump_ushastic():
	# Останавливаем дыхание на время прыжка, чтобы не было конфликта координат
	if breath_tween:
		breath_tween.kill()
		
	var tween = create_tween()
	# Прыгаем вверх от исходной точки base_y
	tween.tween_property(self, "position:y", base_y - 150.0, 0.18)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
	# Возвращаемся строго на землю (base_y)
	tween.tween_property(self, "position:y", base_y, 0.18)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
		
	await tween.finished
	
	# Снова запускаем спокойное дыхание
	start_breathing_animation()

func play_fail():
	await play_fail_times(2)
	anim.play("walk") # Возвращаем ходьбу после покачивания головой

func play_fail_times(count: int):
	for i in range(count):
		anim.play("fail")
		await anim.animation_finished

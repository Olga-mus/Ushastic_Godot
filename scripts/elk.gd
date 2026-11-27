extends Node2D
@onready var anim: AnimationPlayer = $AnimationPlayer

func play_shake():
	# Запускаем анимацию 
	await play_shake_times(2)

# Универсальная функция для повтора анимации нужное количество раз
func play_shake_times(count: int):
	for i in range(count):
		anim.play("shake")
		await anim.animation_finished
		
	# ⭐ Анимация: Олень увеличивается (с эффектом пружинки)
func animate_grow():
	# 1. Запоминаем ИСХОДНЫЙ масштаб (какой бы он ни был в редакторе)
	var base_scale = scale 
	# 2. Вычисляем масштаб для увеличения (на 30% больше исходного)
	var target_scale = base_scale * 1.3 
	
	var tween = create_tween()
	# Увеличиваем до target_scale
	tween.tween_property(self, "scale", target_scale, 0.2)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	# Возвращаем ровно к base_scale (исходному размеру)
	tween.tween_property(self, "scale", base_scale, 0.3)\
		.set_trans(Tween.TRANS_SINE)
	await tween.finished # ⭐ Ждем окончания анимации
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	pass

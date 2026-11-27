extends Node2D
@onready var anim: AnimationPlayer = $AnimationPlayer

func play_wag():
	# Запускаем анимацию 
	await play_wag_times(2)

# Универсальная функция для повтора анимации нужное количество раз
func play_wag_times(count: int):
	for i in range(count):
		anim.play("wag")
		await anim.animation_finished
		
func animate_shrink():
	# 1. Запоминаем ИСХОДНЫЙ масштаб
	var base_scale = scale 
	# 2. Вычисляем масштаб для уменьшения (на 30% меньше исходного)
	var target_scale = base_scale * 0.7 
	
	var tween = create_tween()
	# Уменьшаем до target_scale
	tween.tween_property(self, "scale", target_scale, 0.2)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	# Возвращаем ровно к base_scale
	tween.tween_property(self, "scale", base_scale, 0.3)\
		.set_trans(Tween.TRANS_SINE)
		
	await tween.finished # ⭐ Ждем окончания анимации
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	pass

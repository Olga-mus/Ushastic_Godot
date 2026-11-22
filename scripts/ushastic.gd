extends Node2D


@onready var walk: AnimationPlayer = $Walk

func _ready():
# --- Ходьба (зациклена и играет постоянно) ---
	walk.play("walk")
	# Запускаем бесконечную анимацию дыхания
	start_breathing_animation()
	
func start_breathing_animation():
	# Создаем твин и говорим ему повторяться бесконечно (set_loops)
	var tween = create_tween().set_loops()
	
	# 1. Плавно смещаем Ушастика вниз на 8 пикселей от его текущей позиции
	# Используем "position:y" вместо "offset:y"
	tween.tween_property(self, "position:y", position.y + 8.0, 1.2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	
	# 2. Так же плавно возвращаем его в исходную точку за те же 1.2 секунды
	tween.tween_property(self, "position:y", position.y, 1.2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

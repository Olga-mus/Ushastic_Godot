extends Button

var tween: Tween

func _ready() -> void:
	# 1. Задаем точные размеры кнопки (Ширина 300, Высота 80)
	custom_minimum_size = Vector2(600, 100)
	
	# Ждем, пока Godot применит размеры и обновит контейнеры
	await get_tree().process_frame
	
	# 2. Теперь жестко фиксируем точку опоры (Pivot) ровно по центру кнопки
	pivot_offset = Vector2(300, 60) # Ровно половина 
	
	# 3. Замораживаем цвета (копируем стиль Normal в остальные состояния)
	var normal_style = get_theme_stylebox("normal")
	if normal_style:
		add_theme_stylebox_override("pressed", normal_style)
		add_theme_stylebox_override("hover", normal_style)
		add_theme_stylebox_override("focus", normal_style)
	
	# 4. Подключаем сигналы для тапов по экрану телефона
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

func _on_button_down() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	# Плавное сжатие до 93% при нажатии пальцем
	tween.tween_property(self, "scale", Vector2(0.93, 0.93), 0.08)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_button_up() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	# Возврат к исходному масштабу 100%
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

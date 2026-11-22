extends HBoxContainer
@onready var start_button: Button = $"../StartContainer/StartButton"
@onready var materials_button: Button = $"../MaterialsContainer/MaterialsButton"

@onready var rus_button: Button = $RusButton
@onready var eng_button: Button = $EngButton

# Цвета для фонда
var color_selected: Color = Color("#34c759")   # Зеленый
var color_unselected: Color = Color("#ffffff") # Белый

# Цвета для обводки
var border_selected: Color = Color("#ffff00")   # Желтый / Темно-зеленая обводка
var border_unselected: Color = Color("#34c759") # Серая обводка для белой кнопки

# Цвета для ТЕКСТА
var text_selected: Color = Color("#ffff00")    # Желтый текст
var text_unselected: Color = Color("#000000")  # Черный текст

# Цвета для ТЕНИ
var shadow_color_selected: Color = Color(0, 0, 0, 0.3)   # Темная тень (30% видимости) для зеленой
var shadow_color_unselected: Color = Color(0, 0, 0, 0.15) # Мягкая тень (15% видимости) для белой

var tween: Tween

func _ready() -> void:
	# 1. Отключаем автоматический перевод текста ИМЕННО на этих кнопках, 
	# чтобы они не ломали системный TranslationServer
	rus_button.auto_translate = false
	eng_button.auto_translate = false
	
		# 2. Делаем стили уникальными и НАГЛУХО задаем круглые углы
	var style_ru = rus_button.get_theme_stylebox("normal").duplicate() as StyleBoxFlat
	var style_en = eng_button.get_theme_stylebox("normal").duplicate() as StyleBoxFlat
	
	# Прописываем скругление 100 пикселей (половина от размера 200) для всех 4 углов
	style_ru.set_corner_radius_all(100)
	style_en.set_corner_radius_all(100)
	
	# СБРАСЫВАЕМ внутренние отступы стиля, чтобы текст не улетал вниз
	style_ru.set_content_margin_all(0)
	style_en.set_content_margin_all(0)
	
	for state in ["normal", "pressed", "hover", "focus"]:
		rus_button.add_theme_stylebox_override(state, style_ru)
		eng_button.add_theme_stylebox_override(state, style_en)
	
		# 3. Размеры, точка опоры и центрирование текста
	for btn in [rus_button, eng_button]:
		btn.custom_minimum_size = Vector2(200, 200)
		btn.pivot_offset = Vector2(100, 100)
		
		# Запрещаем кнопкам растягиваться по горизонтали в HBoxContainer
		btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		
		# Оставляем только горизонтальное выравнивание (оно у кнопок есть!)
		btn.alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER

	# 4. Анимация нажатия
	rus_button.button_down.connect(func(): _animate_scale(rus_button, 0.93))
	rus_button.button_up.connect(func(): _animate_scale(rus_button, 1.0))
	eng_button.button_down.connect(func(): _animate_scale(eng_button, 0.93))
	eng_button.button_up.connect(func(): _animate_scale(eng_button, 1.0))
	
	# 5. Нажатия на кнопки
	rus_button.pressed.connect(_select_russian)
	eng_button.pressed.connect(_select_english)
	
	# 6. Старт по умолчанию (Русский)
	_select_russian()

func _select_russian() -> void:
	# Настройка стиля для РУС (Активна)
	var s_ru = rus_button.get_theme_stylebox("normal") as StyleBoxFlat
	s_ru.bg_color = color_selected
	s_ru.set_border_width_all(2) 
	s_ru.border_color = border_selected
	_set_button_text_color(rus_button, text_selected)
	_set_button_shadow(s_ru, shadow_color_selected, 6, Vector2(0, 4))
	
	# Настройка стиля для ENG (Не активна)
	var s_en = eng_button.get_theme_stylebox("normal") as StyleBoxFlat
	s_en.bg_color = color_unselected
	s_en.set_border_width_all(2)
	s_en.border_color = border_unselected
	_set_button_text_color(eng_button, text_unselected)
	_set_button_shadow(s_en, shadow_color_unselected, 4, Vector2(0, 3))
	
	# Смена локализации всей игры на "ru"
	TranslationServer.set_locale("ru")
	
	# 2. ПРИНУДИТЕЛЬНО пишем русский текст с эмодзи на главные кнопки
	start_button.text = "Начать приключения"
	materials_button.text = "Материалы для родителей"
	
	# Ставим эмодзи
	rus_button.text = "🇷🇺"
	eng_button.text = "🇬🇧" # Здесь ваша пишущая ручка или флаг "🇬🇧"
	
	rus_button.queue_redraw()
	eng_button.queue_redraw()

func _select_english() -> void:
	# Настройка стиля для РУС (Не активна)
	var s_ru = rus_button.get_theme_stylebox("normal") as StyleBoxFlat
	s_ru.bg_color = color_unselected
	s_ru.set_border_width_all(2)
	s_ru.border_color = border_unselected
	_set_button_text_color(rus_button, text_unselected)
	_set_button_shadow(s_ru, shadow_color_unselected, 4, Vector2(0, 3))
	
	# Настройка стиля для ENG (Активна)
	var s_en = eng_button.get_theme_stylebox("normal") as StyleBoxFlat
	s_en.bg_color = color_selected
	s_en.set_border_width_all(2)
	s_en.border_color = border_selected
	_set_button_text_color(eng_button, text_selected)
	_set_button_shadow(s_en, shadow_color_selected, 6, Vector2(0, 4))
	
	# Смена локализации всей игры на "en"
	TranslationServer.set_locale("en")
	
	# 2. ПРИНУДИТЕЛЬНО пишем английский текст с эмодзи на главные кнопки
	start_button.text = "Start adventure"
	materials_button.text = "Materials for parents"
	
	# Ставим эмодзи
	rus_button.text = "🇷🇺"
	eng_button.text = "🇬🇧" # Здесь ваша пишущая ручка или флаг "🇬🇧"
	
	rus_button.queue_redraw()
	eng_button.queue_redraw()

# Вспомогательная функция для быстрой настройки цвета текста
func _set_button_text_color(button: Button, color: Color) -> void:
	for state in ["font_color", "font_pressed_color", "font_hover_color", "font_focus_color"]:
		button.add_theme_color_override(state, color)

# Вспомогательная функция для настройки теней
func _set_button_shadow(style: StyleBoxFlat, shadow_color: Color, size: int, offset: Vector2) -> void:
	style.shadow_color = shadow_color
	style.shadow_size = size
	style.shadow_offset = offset

func _animate_scale(button: Button, target_scale: float) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(button, "scale", Vector2(target_scale, target_scale), 0.08)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

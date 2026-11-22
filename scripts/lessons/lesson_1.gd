extends Control

@onready var start_button: Button = $MarginContainer/CustomButtom
@onready var voice_player: AudioStreamPlayer = $VoicePlayer
@onready var bear_button: Button = $MarginContainer/VBoxContainer/PersonsContainer/BearButton
@onready var bird_button: Button = $MarginContainer/VBoxContainer/PersonsContainer/BirdButton

func _ready():
	# Подключаем нажатие на кнопку
	start_button.pressed.connect(_on_start_button_pressed)
	
	# ⭐ БЛОКИРУЕМ ПЕРСОНАЖЕЙ В САМОМ НАЧАЛЕ
	bear_button.set_process_input(false) 
	bird_button.set_process_input(false) 
	
	# Затемняем обе кнопки
	bear_button.modulate = Color(0.5, 0.5, 0.5)
	bird_button.modulate = Color(0.5, 0.5, 0.5)

# Вынесенная функция паузы
func pause_between_replica():
	await get_tree().create_timer(1.0).timeout 

func _on_start_button_pressed():
	start_button.disabled = true
	start_button.hide() 
	
	# ==========================================
	# 1. РЕПЛИКА 1Ru
	# ==========================================
	voice_player.play()
	await voice_player.finished 
	
	# ⭐ Вызываем паузу ПРАВИЛЬНО (с await)
	await pause_between_replica()
	
	# ==========================================
	# 2. РЕПЛИКА 2Ru
	# ==========================================
	voice_player.stream = load("res://assets/sounds/lesson1/2Ru.mp3")
	voice_player.play()
	await voice_player.finished 
	
	# ==========================================
	# 3. ЗВУК ПТИЧКИ 1bird
	# ==========================================
	voice_player.stream = load("res://assets/sounds/lesson1/task/1bird.mp3")
	voice_player.play()
	
	# Ждем, пока птичка полностью допоет
	await voice_player.finished 
	
	#  РАЗБЛОКИРОВАЕМ ПТИЧКУ (и цвет, и клик) в один момент
	bird_button.modulate = Color(1, 1, 1) 
	bird_button.set_process_input(true)
	
	# (Всё, никаких лишних await в конце!)

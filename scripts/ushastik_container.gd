extends Control

@onready var ushastik = $Ushastic

func _ready():
	# Ждем, пока интерфейс рассчитает размеры
	await get_tree().process_frame
	# Ставим Ушастика ровно в центр контейнера
	ushastik.position = Vector2(size.x / 2, size.y)

extends Node3D

# Mouse duyarlılığı
@export var mouse_sensitivity := 0.003

# Dikey açı sınırları
var rotation_x := 0.0
var rotation_y := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_x -= event.relative.y * mouse_sensitivity
		
		# Dikey dönüşü sınırlıyoruz (kamera ters dönmesin)
		rotation_x = clamp(rotation_x, deg_to_rad(-60), deg_to_rad(60))
		
		# Kamerayı döndür
		rotation_degrees = Vector3(rad_to_deg(rotation_x), rad_to_deg(rotation_y), 0)

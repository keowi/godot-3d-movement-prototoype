extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var anim_player: AnimationPlayer
var current_anim := ""

var turn_speed: float = 10.0

func _ready():
	anim_player = get_node("character-male-a2/AnimationPlayer")

func play_anim(anim_name: String) -> void:
	if current_anim == anim_name:
		return
	current_anim = anim_name
	anim_player.play(anim_name)

func _physics_process(delta: float) -> void:
		# Kameranın Y eksenindeki dönüşünü al
	var target_y: float = $Camera_Controller.rotation.y
	
	# Karakteri kameranın baktığı yöne döndür
	rotation.y = lerp_angle(rotation.y, target_y, delta * turn_speed)
	
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		play_anim("jump")

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y))

	if direction.length() > 0.01:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		var model = get_node("character-male-a2")
		model.look_at(global_position + (-direction), Vector3.UP) # ✅ yön düzeltildi

		if is_on_floor():
			play_anim("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if is_on_floor():
			play_anim("idle")

	if not is_on_floor():
		play_anim("jump")

	move_and_slide()

	$Camera_Controller.position = lerp($Camera_Controller.position, position, 1)
	

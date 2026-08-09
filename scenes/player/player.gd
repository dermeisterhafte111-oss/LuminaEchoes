extends CharacterBody3D
class_name PlayerController

## Signal emitted when the player interacts with an object
signal interacted(target: Node)
## Signal emitted when lantern input is pressed
signal lantern_toggled

@export_group("Movement Parameters")
@export float SPEED: float = 5.0
@export float SPRINT_SPEED: float = 8.5
@export float JUMP_VELOCITY: float = 4.5
@export float MOUSE_SENSITIVITY: float = 0.002
@export float ACCELERATION: float = 12.0
@export float DECELERATION: float = 16.0

@export_group("Interaction Setup")
@export float INTERACT_DISTANCE: float = 3.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var interact_raycast: RayCast3D = $Head/Camera3D/InteractRayCast
@onready var lantern: Node3D = $Head/Camera3D/SpectrumLantern

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_locked: bool = false # Used during dialogue/cutscenes
var hud: HUD

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if interact_raycast:
		interact_raycast.target_position = Vector3(0, 0, -INTERACT_DISTANCE)
		
	hud = get_tree().root.find_child("HUD", true, false)

func _unhandled_input(event: InputEvent) -> void:
	if is_locked or get_tree().paused:
		return
		
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-85), deg_to_rad(85))

func _physics_process(delta: float) -> void:
	if is_locked or get_tree().paused:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
		velocity.z = move_toward(velocity.z, 0, DECELERATION * delta)
		move_and_slide()
		return

	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle Sprint
	var current_speed = SPRINT_SPEED if Input.is_action_pressed("sprint") else SPEED

	# Get input direction
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (head.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = move_toward(velocity.x, direction.x * current_speed, ACCELERATION * delta * current_speed)
		velocity.z = move_toward(velocity.z, direction.z * current_speed, ACCELERATION * delta * current_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
		velocity.z = move_toward(velocity.z, 0, DECELERATION * delta)

	move_and_slide()
	
	# Raycast check for reticle highlight
	_update_reticle_highlight()
	
	# Handle Actions
	if Input.is_action_just_pressed("interact"):
		_handle_interaction()
		
	if Input.is_action_just_pressed("toggle_lantern"):
		lantern_toggled.emit()
		if SoundManager: SoundManager.play_sfx_type("lantern_shift")
		if lantern and lantern.has_method("toggle_spectrum"):
			lantern.call("toggle_spectrum")
			if hud and lantern.get("current_spectrum") != null:
				var is_b = (lantern.get("current_spectrum") == 1) # Spectrum.SPECTRUM_B
				hud.update_spectrum_indicator(is_b)

func _update_reticle_highlight() -> void:
	if not hud:
		hud = get_tree().root.find_child("HUD", true, false)
	if hud and interact_raycast:
		var has_target = interact_raycast.is_colliding()
		hud.set_reticle_highlight(has_target)

func _handle_interaction() -> void:
	if interact_raycast and interact_raycast.is_colliding():
		var collider = interact_raycast.get_collider()
		if collider:
			interacted.emit(collider)
			if SoundManager: SoundManager.play_sfx_type("interact")
			if collider.has_method("interact"):
				collider.call("interact", self)

func lock_movement(lock: bool) -> void:
	is_locked = lock
	if lock:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

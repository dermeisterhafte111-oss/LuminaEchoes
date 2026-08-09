extends Node3D
class_name PerspectivePuzzle

signal alignment_started
signal alignment_completed
signal alignment_lost

@export var target_camera_position: Node3D
@export var target_view_direction: Node3D
@export float_range(0.85, 0.999) var alignment_threshold: float = 0.97
@export float var position_threshold_distance: float = 1.5
@export float var required_hold_time: float = 1.2

@export var puzzle_id: String = "puzzle_01"

var current_hold_time: float = 0.0
var is_solved: bool = false
var is_aligning: bool = false

@onready var mesh_shards: Node3D = $MeshShards

func _process(delta: float) -> void:
	if is_solved:
		return

	var camera = get_viewport().get_camera_3d()
	if not camera:
		return

	if _check_alignment(camera):
		if not is_aligning:
			is_aligning = true
			alignment_started.emit()
			
		current_hold_time += delta
		_on_aligning_progress(current_hold_time / required_hold_time)
		
		if current_hold_time >= required_hold_time:
			_solve_puzzle()
	else:
		if is_aligning:
			is_aligning = false
			current_hold_time = 0.0
			_on_aligning_progress(0.0)
			alignment_lost.emit()

func _check_alignment(camera: Camera3D) -> bool:
	if not target_camera_position or not target_view_direction:
		return false

	# 1. Distance check
	var dist = camera.global_position.distance_to(target_camera_position.global_position)
	if dist > position_threshold_distance:
		return false

	# 2. Angle/Vector dot product check
	var cam_dir = -camera.global_transform.basis.z.normalized()
	var target_dir = (target_view_direction.global_position - target_camera_position.global_position).normalized()

	var dot_prod = cam_dir.dot(target_dir)
	return dot_prod >= alignment_threshold

func _on_aligning_progress(progress: float) -> void:
	# Subtle visual feedback (assembling puzzle shards)
	if mesh_shards:
		mesh_shards.rotation.y = lerp(0.0, float(TAU), progress)
		mesh_shards.scale = Vector3.ONE * lerp(0.8, 1.0, progress)

func _solve_puzzle() -> void:
	is_solved = true
	alignment_completed.emit()
	
	# Visual assembly effect
	if mesh_shards:
		var tween = create_tween().set_parallel(true)
		tween.tween_property(mesh_shards, "scale", Vector3.ONE * 1.2, 0.4)
		tween.tween_property(mesh_shards, "rotation:y", TAU * 2.0, 0.4)

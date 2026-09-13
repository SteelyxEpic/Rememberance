extends Line2D

@export var max_length: float = 2000.0

func _physics_process(_delta):
	var current_pos = global_position
	var current_dir = Vector2.RIGHT
	
	clear_points()
	add_point(to_local(current_pos))
	
	var remaining_length = max_length
	var space_state = get_world_2d().direct_space_state

	while true:
		var target_pos = current_pos + (current_dir * remaining_length)
		
		var query = PhysicsRayQueryParameters2D.create(current_pos, target_pos)
		var result = space_state.intersect_ray(query)
		
		if result:
			var hit_pos = result.position
			var hit_normal = result.normal
			var incoming = current_dir
			add_point(to_local(hit_pos))
			
			if result.collider.name == "mirror":
				current_dir = incoming.bounce(hit_normal)
				current_pos = hit_pos + hit_normal * 0.1
			else:
				break
		else:
			add_point(to_local(target_pos))
			break

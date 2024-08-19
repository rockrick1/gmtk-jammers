extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	
	$"../HUD/EndScreen".open("ESCAKED!🍰", body.total_hunts)

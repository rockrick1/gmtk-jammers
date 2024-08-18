extends BaseAnimal

func _ready():
	$StateMachine/Attacking.attacked.connect(_on_attacked)
	super._ready()

func _on_attacked():
	for body in $DamageArea.get_overlapping_bodies():
		if body is not Player:
			continue
		
		body.cc.take_damage(cc.base_damage)

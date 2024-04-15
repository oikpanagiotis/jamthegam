extends Control

@export var max_soulbits: int = 4
var player_ref: Player = null


var soulbits

func _ready() -> void:
	assert(player_ref != null, "Pass player node to soulbar")
	soulbits = max_soulbits
	GameEvents.connect("minion_killed", _on_minion_killed)


func _physics_process(delta: float) -> void:
	soulbits -= delta
	
	if soulbits <= 0:
		emit_souls_depleted()
	
	var soulbits_left_percentage = (soulbits / max_soulbits) * 100
	self.value = soulbits_left_percentage


func emit_souls_depleted() -> void:
	GameEvents.emit_signal("player_died")

func _on_minion_killed() -> void:
	reset()

func reset() -> void:
	soulbits = max_soulbits

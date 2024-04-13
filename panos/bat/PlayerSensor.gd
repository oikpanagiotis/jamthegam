extends Area2D


# TODO: Constraint type hint to player
@export
var player_node: Node


# Parent must implement on_player_seen
func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		var agent = get_parent()
		assert(agent.is_in_group("agent"), "Parent of sensor is not in agent group")
		if agent.has_method("on_player_seen"):
			agent.on_player_seen(body.global_position)
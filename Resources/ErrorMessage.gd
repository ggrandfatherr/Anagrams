extends Control

onready var move_tween = $Tween
onready var label = $CanvasLayer/Control/MarginContainer/Label
onready var lbl_marg = $CanvasLayer/Control/MarginContainer

var blink = false
var text = ""

func _ready():
	if blink:
		$AnimationPlayer.play("blink")
	else:
		label.modulate = Color(1,1,1,1)
	label.text = text
	move_tween.interpolate_property(lbl_marg,"rect_position",null,lbl_marg.rect_position + Vector2(0,-70),1)
	move_tween.interpolate_property(lbl_marg,"modulate",null,Color(1,1,1,0),1.1)
	move_tween.start()


func _on_Timer_timeout():
	queue_free()

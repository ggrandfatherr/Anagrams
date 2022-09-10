extends Control

onready var timer = $Timer

onready var label = $Label

var hours = 0
var minutes = 0
var seconds = 0
var time = 8274

var clocking = true
	
	
	
func give_time():
	time = 450998
	seconds = time%60
	if time > 3600:
		hours = (time - seconds)/3600
	else:
		hours = floor((time - seconds)/3600)
	if (time-seconds)/60 >=60:
		minutes = ((time - seconds)/60)%60
	else:
		minutes = (time - seconds)/60
		
	return str(str(hours).pad_zeros(2),":",str(minutes).pad_zeros(2),":",str(seconds).pad_zeros(2))

func get_time():
	if timer.time_left >= 60:
		minutes  = timer.time_left/60


func _on_Button_pressed():
	$Label.text = give_time()


func _on_CheckBox_pressed():
	if clocking:
		timer.paused = true
		clocking = false
	else:
		timer.paused = false
		clocking = true

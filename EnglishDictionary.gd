extends Node

export(bool) var pc = true


var high_score = 0
var high_score_six = 0

var small_dict = {
	
}
var word_warehouse : Dictionary = {
	
}
var six_dict = {
	
}

func _ready():
	get_highscore()
	get_six_highscore()

func set_highscore(score):
	var file = File.new()
	file.open("user://highscore.txt",File.WRITE)
#	print("Old score: %s, New High Score: %s!!" % [high_score,score])
	high_score = score
	file.store_32(high_score)
	file.close()
	
func get_highscore():
	var file = File.new()
	if not file.file_exists("user://highscore.txt"):
		return
	
	file.open("user://highscore.txt",File.READ)
	high_score = file.get_32()
	file.close()
#	print("New Score: ",high_score)
	return high_score

func set_six_highscore(score):
	var file = File.new()
	file.open("user://six_highscore.txt",File.WRITE)
#	print("Old score: %s, New High Score: %s!!" % [high_score_six,score])
	high_score_six = score
	file.store_32(high_score_six)
	file.close()
	
func get_six_highscore():
	var file = File.new()
	if not file.file_exists("user://six_highscore.txt"):
		return
	file.open("user://six_highscore.txt",File.READ)
	high_score_six = file.get_32()
	file.close()
#	print("Six Score: ",high_score_six)
	return high_score_six


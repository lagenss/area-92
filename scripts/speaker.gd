extends AudioStreamPlayer3D

var phrases = {
	"docs_please": preload("res://assets/sounds/speaker/papers.wav"),
	"go_work": preload("res://assets/sounds/speaker/go_work.wav"),
	"wrong_way": preload("res://assets/sounds/speaker/wrong_way.wav"),
	"read_docs_p1": preload("res://assets/sounds/speaker/docs1.wav"),
	"read_docs_p2": preload("res://assets/sounds/speaker/docs2.wav"),
	"read_docs_p3": preload("res://assets/sounds/speaker/docs3.wav"),
	"capsules_lever": preload("res://assets/sounds/speaker/capsules_lever.wav"),
	"pressure_fluids": preload("res://assets/sounds/speaker/pressure_fluids.wav"),
	"gl": preload("res://assets/sounds/speaker/gl.wav"),
	
	"on_lose_1": preload("res://assets/sounds/speaker/on_lose_1.wav"),
	"on_lose_2": preload("res://assets/sounds/speaker/on_lose_2.wav"),
	"on_lose_3": preload("res://assets/sounds/speaker/on_lose_3.wav"),
	
	"capsule_stuck": preload("res://assets/sounds/speaker/capsule_stuck.wav"),
	
	"code_red": preload("res://assets/sounds/speaker/code_red.wav"),
	
	"on_win_1": preload("res://assets/sounds/speaker/on_win_1.wav"),
	"on_win_2": preload("res://assets/sounds/speaker/on_win_2.wav"),
	"on_win_3": preload("res://assets/sounds/speaker/on_win_3.wav"),
}

var subtitles = {
	"docs_please": "Citizen, present your papers at the designated area.",
	"go_work": "You can get started.",
	"wrong_way": "Wrong way!",
	"read_docs_p1": "Your current objective is to familiarize yourself with the provided documentation.",
	"read_docs_p2": "All necessary files are located on the desk.",
	"read_docs_p3": "Upon completion, proceed to your workstation immediately.",
	"capsules_lever": "Now insert the capsules into the unit and pull the lever by the front door.",
	"pressure_fluids": "After startup, watch the pressure gauges and ensure timely fluid replacement.",
	"gl": "[shake]GOOD LUCK!",
	
	"on_lose_1": "[color=#8b4400]TASK FAILED.[/color]",
	"on_lose_2": "But don't worry...",
	"on_lose_3": "[color=#8b0000][shake]YOUR BIOMASS WILL BE VERY USEFUL IN A DIFFERENT FORM.",
	
	"capsule_stuck": "[color=#993300]Capsule stuck! Stand by!",
	
	"code_red": "[color=#ff2222][shake]Code Red! Press the red button!",
	
	"on_win_1": "Congratulations. You have passed the test.",
	"on_win_2": "Return to your living quarters.",
	"on_win_3": "[shake]See you tomorrow."
}

func _ready() -> void:
	StoryManager.new_stage.connect(_on_new_stage)
	SignalManager.wrong_way.connect(_on_wrong_way)
	SignalManager.capsule_stuck.connect(_on_capsule_stuck)

func speaking(phrase):
	if is_playing(): 
		stop()
	stream = phrases[phrase]
	SignalManager.speak.emit(subtitles[phrase])
	play()
	await finished
	SignalManager.speak.emit("")
	

func _on_new_stage(stage):
	match stage:
		StoryManager.LevelProgress.S2_DOCUMENTS:
			speaking("docs_please")

		StoryManager.LevelProgress.S2_5_DOCUMENTS_CHECKED:
			speaking("go_work")
			await finished
			StoryManager.set_stage(StoryManager.LevelProgress.S3_DOCUMENTS_PASSED)
		StoryManager.LevelProgress.S4_WORK:
			speaking("read_docs_p1")
			await finished
			await get_tree().create_timer(0.4).timeout
			speaking("read_docs_p2")
			await finished
			await get_tree().create_timer(0.4).timeout
			speaking("read_docs_p3")
			await finished
			StoryManager.set_stage(StoryManager.LevelProgress.S5_LEARN_DOCS)
		StoryManager.LevelProgress.S6_GET_STARTED:
			await get_tree().create_timer(0.4).timeout
			speaking("capsules_lever")
			await finished
			await get_tree().create_timer(0.2).timeout
			speaking("pressure_fluids")
			await finished
			await get_tree().create_timer(0.2).timeout
			speaking("gl")
		StoryManager.LevelProgress.LOSE:
			await get_tree().create_timer(1).timeout
			speaking("on_lose_1")
			await finished
			await get_tree().create_timer(1.4).timeout
			speaking("on_lose_2")
			await finished
			var normal_pitch = pitch_scale
			pitch_scale = 0.74
			await get_tree().create_timer(0.6).timeout
			speaking("on_lose_3")
			SignalManager.trigger_camera_shake.emit(32.0, 3.36)
			SignalManager.panik.emit()
			await finished
			pitch_scale = normal_pitch
			await get_tree().create_timer(0.6).timeout
			Engine.get_main_loop().change_scene_to_file("res://scenes/LoseMenu.tscn")
		StoryManager.LevelProgress.PREWIN:
			await get_tree().create_timer(0.4).timeout
			speaking("code_red")
			StoryManager.set_stage(StoryManager.LevelProgress.BUTTON_AWAIT)
		StoryManager.LevelProgress.WIN:
			await get_tree().create_timer(0.2).timeout
			speaking("on_win_1")
			await finished
			await get_tree().create_timer(0.4).timeout
			speaking("on_win_2")
			await finished
			await get_tree().create_timer(0.6).timeout
			speaking("on_win_3")
			await finished
			await get_tree().create_timer(2).timeout
			Engine.get_main_loop().change_scene_to_file("res://scenes/WinMenu.tscn")

func _on_wrong_way():
	speaking("wrong_way")
		
func _on_capsule_stuck():
	speaking("capsule_stuck")

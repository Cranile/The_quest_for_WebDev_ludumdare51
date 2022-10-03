extends Node

var rng = RandomNumberGenerator.new()

const time = 10
export var timeLeft = time
export var disablecoding = true;

var currentMilestone = -1
var maxMilestone = 25

var lastpopup = 0;
var currentCode = "1234"
const numbers = [0,1,2,3,4,5,6,7,8,9,10]
var sections = ["one","two","three","four"]
var milestonesUnlocked = false
var dialogue = [
	"So you want to become a web developer?",
	"Thats nice!",
	"But the way to the top is not easy!",
	"You will have to learn a bunch of different Programming languages and frameworks while keeping yourself updated with the latest trends on the web!. . .",
	"But dont despair !! you can start slow and easy, by writing some code on your 'superb text editor TM'",
	"Before writing any code think that, failure is a part of learning, so if something doesnt go as expected, try again!",
	"And most importantly one must start SMALL and then go to the BIGGER part of the code",
	"Go on, try writing, let's say, like FOUR chunks of code ;)"
]
var dialogue2 = [
	"Very good! if you keep advancing like this you will get a job in no time",
	"But just that amount of code isn't enough, you need, let's say . . .",
	". . .",
	"At least 30 essential things to learn, here. . .",
	"I will leave this counter for you, when you complete it your skills will be quite good, or at least, good enough to get you a job",
	"Oh ! and also this . . .",
	"A timer so you don't get side tracked, you have to keep a constant flow of knowledge coming in, so you don't drown on a sea of technologies and stuff to learn, but no pressure you have plenty of time left",
	"It's not like, let's say, a new Javascript framework will come out every ten seconds",
	". . .",
	"wait a second, i got a call . . .",
	"WHAT ! ! !",
	"Well, it seems that against all odds, the frameworks factory is enraged and pumping out new tecnologies every 10 seconds (exactly)",
	"You must, out run the whole tech industry if you really want that job",
	"Before you go, it's dangerous to go alone! Take this",
	"Tip: Sometimes one can get distracted by the internet, on those situations remember the path of the wise. . .",
	"And close the window. There is a button on the top right, it has a little 'X', can't miss it",
	". . . What ? Where you expecting me to give you a sword or something?!, go coding already !"
]
var enddialogue = ["No way. . .",
"You made it. . .",
"you must be the chosen one",
"in all of my years of trolling fools with faulty software, obnoxious ads, and absurd DLC costs. . .",
"You, YOU of all people have passed my test",
"unbelievable",
". . .",
"Le-let me give you a little something",
"have this "]
var tutorialProgress = 0;
var inDialogue = false;
var currentDialogue = -1;

func _ready():
	rng.randomize()
	tutorial()


func tutorial():
	inDialogue = true;
	mageAnim()
	mageVoice()
	if(currentDialogue == dialogue.size() -1):
		disablecoding = false;
		tutorialProgress = 1
		inDialogue = false;
		currentDialogue = -1
		mageAnim()
		toggleChat()
		$ColorRect/codeEditor/AnimationPlayer.play("highlight");
		return;
	currentDialogue += 1;
	$HUD/mageDialogue/content.text = dialogue[currentDialogue]

func tutorial2():
	if(!inDialogue):
		disablecoding = true;
		toggleChat()
	inDialogue = true;
	mageAnim()
	mageVoice()
	
	if(currentDialogue == dialogue2.size() -1):
		disablecoding = false;
		tutorialProgress = 2
		inDialogue = false;
		currentDialogue = 0
		mageAnim()
		toggleChat()
		tutorialEnd()
		return;
	
	currentDialogue += 1
	$HUD/mageDialogue/content.text = dialogue2[currentDialogue]
	if(currentDialogue == 4):
		$HUD/milestones.show()
		print("milestones unlocked")
	if(currentDialogue == 5):
		$HUD/timer.show()
		print("timer unlocked")
	if(currentDialogue == 9):
		$HUD/Mage/AnimationPlayer.play("offscreen")
	if(currentDialogue == 10):
		$HUD/timer.text = "Time: To panic"
		$HUD/Mage/AnimationPlayer.play("inscreen")
	pass

func toggleChat():
	if(!$HUD/mageDialogue.visible):
		$HUD/mageDialogue.show()
	else:
		$HUD/mageDialogue.hide()
func mageVoice():
	pass
func mageAnim():
	if(inDialogue):
		$HUD/Mage/AnimatedSprite.animation = "talk"
	else:
		$HUD/Mage/AnimatedSprite.animation = "idle"

func tutorialEnd():
	updateMilestone()
	updatePrompt()
	$countdown.start()

func checkPuzzle():
	print($HUD.inputText)
	if(currentCode == $HUD.inputText):
		updatePrompt()
		print("succes")
	else:
		print("wrong", currentCode , "!=", $HUD.inputText)
	$HUD/puzzleContainer/puzzleMain/codeContainer/title.text = ""
	$HUD.inputText = ""

func gameOver():
	$countdown.stop()
	print("Game Over")

func updateMilestone():
	$HUD/milestones.text = "Milestone: " + str(currentMilestone) + "/"+ str(maxMilestone);

func updatePrompt():
	currentMilestone += 1
	
	updateMilestone()
	if(!milestonesUnlocked):
		milestonesUnlocked = true;
		tutorial2()

	if(currentMilestone >= maxMilestone ):
		print("you win")
		$countdown.stop()
		return;
	
	currentCode = "";
	var tempNumbers = numbers.duplicate(true);
	
	var tempCode = [];
	
	for number in range(1,5):
		var rand = rng.randi_range(0,tempNumbers.size() - 1)
		
		get_node("HUD/puzzleContainer/puzzleMain/codeContainer/" + sections[number - 1] + "/number").text = str(tempNumbers[rand])
		tempCode.append(tempNumbers[rand])
		tempNumbers.remove(rand)
	
	tempCode.sort()
	for number in range(0,tempCode.size()):
		currentCode += str(tempCode[number])
	

func _on_countdown_timeout():
	timeLeft -= 1
	lastpopup -= 1
	$HUD/timer.text = "Time left: " + str(timeLeft)
	if(lastpopup <= 0 && currentMilestone >= 9 ):
		var rand = rng.randi_range(0,25)
		if(rand >= 0 && rand < 3):
			print("popup")
			lastpopup = 4;
			$HUD/popup.show()
	
	if(currentMilestone >= 16):
		var rand = rng.randi_range(0,25)
		if(rand >= 0 && rand < 3 && $HUD/puzzleContainer/puzzleMain.visible == true):
			print("hide code")
			$HUD/puzzleContainer/puzzlePlaceholder/AnimationPlayer.play("fadeout")
		
	if(timeLeft == 0):
		timeLeft = time
		maxMilestone += 1
		updateMilestone()

func _on_HUD_submit():
	checkPuzzle()
	
func _on_HUD_keyboard():
	if !$effectPlayer.playing:
		$effectPlayer.play()


func _on_musicToggle_pressed():
	if !$musicPlayer.playing:
		$musicPlayer.play()
	else:
		$musicPlayer.stop()


func _on_HUD_nextDialogue():
	if(tutorialProgress == 0):
		tutorial()
	elif(tutorialProgress == 1):
		tutorial2()


func _on_editorToggle_pressed():
	$HUD/puzzleContainer/puzzlePlaceholder/AnimationPlayer.play("fadein")
	##$HUD/puzzleContainer/puzzleMain.show()

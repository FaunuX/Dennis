extends Node

var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _collect_coin(body):
	coins += 1
	$CanvasLayer/GUI/Label.text = str(coins)


func _on_level_child_entered_tree(node):
	node.connect("body_entered", self._collect_coin)

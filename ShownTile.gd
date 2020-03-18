extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var texture

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = ImageTexture.new()
	texture = load("res://Asset/Tile/DropTileBottom.png")
	
func show_tiles(tiles):
	for suit in tiles:
		if(suit["shown_type"]==Message.player_action.CHOW):
			pass
		elif(suit["shown_type"]==Message.player_action.PONG):
			pass
		elif(suit["shown_type"]==Message.player_action.EXPOSED_KONG):
			pass
		elif(suit["shown_type"]==Message.player_action.CONCEALED_KONG):
			pass
		elif(suit["shown_type"]==Message.player_action.ADDED_KONG):
			pass				

func get_tile_instance(suit, number):
	var tile = Sprite.new()
	tile.texture = texture
	tile.centered = false
	tile.vframes = 7
	tile.hframes = 9
	tile.frame_coords = Vector2(number-1, suit)
	return tile

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

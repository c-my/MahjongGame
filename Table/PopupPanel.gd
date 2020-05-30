extends PopupPanel


var hand_texture
var shown_texture

onready var max_label_width = 200
onready var nickname_labels = [$Nickname0, $Nickname1, $Nickname2, $Nickname3]

# Called when the node enters the scene tree for the first time.
func _ready():
	hand_texture = ImageTexture.new()
	hand_texture = load("res://Asset/Tile/HandinTilesSheet.png")
	shown_texture = ImageTexture.new()
	shown_texture = load("res://Asset/Tile/DropTileBottom.png")
	
	
func show_result(msg):
	for i in range(4):
		show_line(i, msg)
	popup_centered(Vector2(950, 550))
	

func show_line(row, msg):
	var x = 0
	var y = row*(Constants.Tile.RESULT_HAND_HEIGHT+Constants.Tile.RESULT_VERTICALL_GAP)
	y += Constants.Tile.RESULT_VERTICALL_GAP*2
	var nickname = msg["user_list"][row]["nickname"]
	var hand = msg["player_tile"][row]["hand_tiles"]
	var shown = msg["player_tile"][row]["shown_tiles"]
	
	var nickname_label = nickname_labels[row]
	nickname_label.text = nickname
	nickname_label.rect_position = Vector2(x, y)
	x = max_label_width
	for h in hand:
		var tile = get_hand_instance(h["suit"], h["number"])
		add_child(tile)
		tile.position = Vector2(x, y)
		x += Constants.Tile.RESULT_HAND_WIDTH
	if shown == null:
		return
	x += Constants.Tile.RESULT_HAND_WIDTH
	for s in shown:
		for t in s["tiles"]:
			var tile = get_shown_instance(t["suit"], t["number"])
			add_child(tile)
			tile.position = Vector2(x, y)
			x += Constants.Tile.RESULT_SHOWN_WIDTH
		x += Constants.Tile.RESULT_SHOWN_WIDTH
	
	
func get_hand_instance(suit, number):
	var tile = Sprite.new()
	tile.centered = false
	tile.texture = hand_texture
	tile.vframes = 5
	tile.hframes = 9
	tile.frame_coords = Vector2(number-1, suit)
	tile.scale = Vector2(Constants.Tile.RESULT_SCALE, Constants.Tile.RESULT_SCALE)
	return tile
	
func get_shown_instance(suit, number):
	var tile = Sprite.new()
	tile.centered = false
	tile.texture = shown_texture
	tile.vframes = 5
	tile.hframes = 9
	tile.frame_coords = Vector2(number-1, suit)
	tile.scale = Vector2(Constants.Tile.RESULT_SCALE, Constants.Tile.RESULT_SCALE)
	return tile
	
	
func get_avatar_path(gender):
	var path = ""
	if gender == Message.gender.FEMALE:
		path = "res://Asset/Avatar/Female.png"
	elif gender == Message.gender.MALE:
		path = "res://Asset/Avatar/Male.png"

func clear_tiles():
	for tile in get_children():
		remove_child(tile)
		tile.queue_free()



extends PopupPanel


var hand_texture
var shown_texture

onready var first_nickname = $Container/First/Label
onready var second_nickname = $Container/Second/Label
onready var third_nickname = $Container/Third/Label
onready var fourth_nickname = $Container/Fourth/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	hand_texture = ImageTexture.new()
	hand_texture = load("res://Asset/Tile/HandinTilesSheet.png")
	shown_texture = Image.new()
	shown_texture = load("res://Asset/Tile/DropTileBottom.png")
	
	
func show_result(msg):
	set_first(msg)
	set_second(msg)
	set_third(msg)
	set_fourth(msg)
	popup_centered()
		
func set_first(msg):
	first_nickname.text = msg["user_list"][0]["nickname"]
	var hand = msg["player_tile"][0]["hand_tiles"]
	var shown = msg["player_tile"][0]["shown_tiles"]
	var tile_pos = first_nickname.rect_size.x
	for h in hand:
		var tile = get_hand_instance(h["suit"], h["number"])
		tile.position = Vector2(tile_pos, 0)
		$Container/First.add_child(tile)
		tile_pos += Constants.Tile.RESULT_HAND_WIDTH
	if shown == null:
		return
	tile_pos += Constants.Tile.RESULT_HAND_WIDTH
	for s in shown:
		for t in s["tiles"]:
			var tile = get_shown_instance(t["suit"], t["number"])
			tile.position = Vector2(tile_pos, 0)
			$Container/First.add_child(tile)
			tile_pos += Constants.Tile.RESULT_SHOWN_WIDTH
		tile_pos += Constants.Tile.RESULT_SHOWN_WIDTH
	var winner = msg["winner"]
	if winner == 0:
		pass
			

func set_second(msg):
	var y = 1 * Constants.Tile.RESULT_HEIGHT
	second_nickname.text = msg["user_list"][1]["nickname"]
	var hand = msg["player_tile"][1]["hand_tiles"]
	var shown = msg["player_tile"][1]["shown_tiles"]
	var tile_pos = 0
	for h in hand:
		var tile = get_hand_instance(h["suit"], h["number"])
		tile.position = Vector2(tile_pos, y)
		$Container/Second.add_child(tile)
		tile_pos += Constants.Tile.RESULT_HAND_WIDTH
	if shown == null:
		return
	tile_pos += Constants.Tile.RESULT_HAND_WIDTH
	for s in shown:
		for t in s["tiles"]:
			var tile = get_shown_instance(t["suit"], t["number"])
			tile.position = Vector2(tile_pos, y)
			$Container/Second.add_child(tile)
			tile_pos += Constants.Tile.RESULT_SHOWN_WIDTH
		tile_pos += Constants.Tile.RESULT_SHOWN_WIDTH
	var winner = msg["winner"]
	if winner == 1:
		pass

func set_third(msg):
	var y = 2 * Constants.Tile.RESULT_HEIGHT
	third_nickname.text = msg["user_list"][2]["nickname"]
	var hand = msg["player_tile"][2]["hand_tiles"]
	var shown = msg["player_tile"][2]["shown_tiles"]
	var tile_pos = 0
	for h in hand:
		var tile = get_hand_instance(h["suit"], h["number"])
		tile.position = Vector2(tile_pos, y)
		$Container/Third.add_child(tile)
		tile_pos += Constants.Tile.RESULT_HAND_WIDTH
	if shown == null:
		return
	tile_pos += Constants.Tile.RESULT_HAND_WIDTH
	for s in shown:
		for t in s["tiles"]:
			var tile = get_shown_instance(t["suit"], t["number"])
			tile.position = Vector2(tile_pos, y)
			$Container/Third.add_child(tile)
			tile_pos += Constants.Tile.RESULT_SHOWN_WIDTH
		tile_pos += Constants.Tile.RESULT_SHOWN_WIDTH
	var winner = msg["winner"]
	if winner == 2:
		pass
		
func set_fourth(msg):
	var y = 3 * Constants.Tile.RESULT_HEIGHT
	fourth_nickname.text = msg["user_list"][3]["nickname"]
	var hand = msg["player_tile"][3]["hand_tiles"]
	var shown = msg["player_tile"][3]["shown_tiles"]
	var tile_pos = 0
	for h in hand:
		var tile = get_hand_instance(h["suit"], h["number"])
		tile.position = Vector2(tile_pos, y)
		$Container/Fourth.add_child(tile)
		tile_pos += Constants.Tile.RESULT_HAND_WIDTH
	if shown == null:
		return
	tile_pos += Constants.Tile.RESULT_HAND_WIDTH
	for s in shown:
		for t in s["tiles"]:
			var tile = get_shown_instance(t["suit"], t["number"])
			tile.position = Vector2(tile_pos, y)
			$Container/Fourth.add_child(tile)
			tile_pos += Constants.Tile.RESULT_SHOWN_WIDTH
		tile_pos += Constants.Tile.RESULT_SHOWN_WIDTH
	var winner = msg["winner"]
	if winner == 3:
		pass
	
func get_hand_instance(suit, number):
	var tile = Sprite.new()
	tile.texture = hand_texture
	tile.vframes = 5
	tile.hframes = 9
	tile.frame_coords = Vector2(number-1, suit)
	tile.scale = Vector2(Constants.Tile.RESULT_SCALE, Constants.Tile.RESULT_SCALE)
	return tile
	
func get_shown_instance(suit, number):
	var tile = Sprite.new()
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




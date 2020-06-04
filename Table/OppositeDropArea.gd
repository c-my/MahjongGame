extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var texture


# Called when the node enters the scene tree for the first time.
func _ready():
	texture = ImageTexture.new()
	texture = load("res://Asset/Tile/DropTileBottom.png")
	
func add_tile(suit, number):
	var tile = get_tile_instance(suit, number)
	add_child(tile)


func get_tile_instance(suit, number):
	var tile = Sprite.new()
	tile.texture = texture
	tile.centered = false
	tile.vframes = 5
	tile.hframes = 9
	tile.frame_coords = Vector2(number-1, suit)
	return tile

func show_tiles():
	var row = -1
	for i in range(get_children().size()):
		if i % 14 == 0:
			row += 1
		get_children()[i].position = Vector2(-(i%14)*Constants.Tile.OPPOSITE_DROP_WIDTH, row*(Constants.Tile.OPPOSITE_DROP_HEIGHT-Constants.Tile.OPPOSITE_DROP_THICK))

func clear_tiles():
	for tile in get_children():
		remove_child(tile)
		tile.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends HBoxContainer

signal buy_pressed(item: ItemData)

@onready var icon = $Icon
@onready var name_label = $VBoxContainer/NameLabel
@onready var description_label = $VBoxContainer/DescriptionLabel
@onready var price_label = $VBoxContainer/PriceLabel
@onready var buy_button = $BuyButton

var item: ItemData

func setup(item_data: ItemData):
	item = item_data
	icon.texture = item.icon
	name_label.text = item.name
	description_label.text = item.description
	price_label.text = "Preço: " + str(item.price)
	buy_button.connect("pressed", Callable(self, "_on_buy_pressed"))

func _on_buy_pressed():
	emit_signal("buy_pressed", item)

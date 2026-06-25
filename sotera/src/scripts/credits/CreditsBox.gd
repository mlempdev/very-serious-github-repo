extends VBoxContainer

class_name CreditsBox

func set_data(color: Color,
		  name: String,
  discord_name: String,
		 roles: String) -> void:
	var ln: Label = $Name
	ln.modulate = color
	ln.text = name
	
	var dn: Label = $"Discord Name"
	dn.modulate = color
	dn.text = discord_name
	
	var r: Label = $Roles
	r.modulate = color
	r.text = roles

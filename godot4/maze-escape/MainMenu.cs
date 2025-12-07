using Godot;

public partial class MainMenu : CanvasLayer
{
	public override void _Ready()
	{
		GetNode<Button>("MarginContainer/VBoxContainer/Start").Pressed += OnStartPressed;
		GetNode<Button>("MarginContainer/VBoxContainer/Exit").Pressed += OnExitPressed;
	}

	private void OnStartPressed()
	{
		GetTree().ChangeSceneToFile("res://scenes/Main.tscn");
	}

	private void OnExitPressed()
	{
		GetTree().Quit();
	}
}

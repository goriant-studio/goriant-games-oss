using Godot;

namespace MazeEscape;

public partial class GameManager : Node
{
	public static GameManager Instance { get; private set; }

	public override void _EnterTree()
	{
		Instance = this;
	}

	public override void _Ready()
	{
		GD.Print("GameManager started");
	}
}

using Godot;
using System;

public partial class MainMenu : Node
{
    [Export] public Button StartButton { get; set; }
    [Export] public Button QuitButton { get; set; }

    public override void _Ready()
    {
        // Kiểm tra null trước khi subscribe
        if (StartButton != null)
            StartButton.Pressed += OnStartPressed;
        else
            GD.PrintErr("StartButton is not assigned!");
            
        if (QuitButton != null)
            QuitButton.Pressed += OnQuitPressed;
        else
            GD.PrintErr("QuitButton is not assigned!");
    }

    public override void _Input(InputEvent @event)
    {
        if (@event.IsActionPressed("ui_accept"))
        {
            // Gọi pressed của nút đang focus
            var focusOwner = GetViewport().GuiGetFocusOwner();
            if (focusOwner is Button btn)
            {
                btn.EmitSignal(Button.SignalName.Pressed);
            }
        }
    }

    private void OnStartPressed()
    {
        // Unsubscribe trước khi chuyển scene để tránh memory leak
        if (StartButton != null)
            StartButton.Pressed -= OnStartPressed;
        if (QuitButton != null)
            QuitButton.Pressed -= OnQuitPressed;
            
        GetTree().ChangeSceneToFile("res://Main.tscn");
    }

    private void OnQuitPressed()
    {
        GetTree().Quit();
    }
    
    // Clean up khi node bị xóa
    public override void _ExitTree()
    {
        if (StartButton != null)
            StartButton.Pressed -= OnStartPressed;
        if (QuitButton != null)
            QuitButton.Pressed -= OnQuitPressed;
    }
}
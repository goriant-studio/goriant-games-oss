using Godot;

public partial class Player : CharacterBody2D
{
    [Export] public float Speed = 150f;

    public override void _PhysicsProcess(double delta)
    {
        Vector2 input = Vector2.Zero;

        input.X = Input.GetAxis("ui_left", "ui_right");
        input.Y = Input.GetAxis("ui_up", "ui_down");

        Velocity = input.Normalized() * Speed;
        MoveAndSlide();
    }
}
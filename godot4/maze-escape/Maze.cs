using Godot;

public partial class Maze : Node2D
{
    [Export] public int TileSize { get; set; } = 32;

    private Node2D wallsParent;
    private Texture2D wallTexture;

    private int[,] maze10x10 = new int[,]
    {
        {1,1,1,1,1,1,1,1,1,1},
        {1,0,0,1,0,0,0,0,0,1},
        {1,0,1,1,0,1,1,1,0,1},
        {1,0,1,0,0,1,0,1,0,1},
        {1,0,1,0,1,1,0,1,0,1},
        {1,0,0,0,0,0,0,1,0,1},
        {1,1,1,1,1,1,0,1,0,1},
        {1,0,0,0,0,0,0,1,0,1},
        {1,0,1,1,1,1,1,1,0,1},
        {1,1,1,1,1,1,1,1,1,1},
    };

    public override void _Ready()
    {
        wallsParent = GetNodeOrNull<Node2D>("Walls");
        if (wallsParent == null)
        {
            wallsParent = new Node2D();
            wallsParent.Name = "Walls";
            AddChild(wallsParent);
        }

        wallTexture = CreateSolidColorTexture(TileSize, TileSize, Colors.Black);

        GenerateWalls(maze10x10);
    }

    private void GenerateWalls(int[,] grid)
    {
        foreach (var child in wallsParent.GetChildren())
            child.QueueFree();

        int h = grid.GetLength(0);
        int w = grid.GetLength(1);

        for (int y = 0; y < h; y++)
        {
            for (int x = 0; x < w; x++)
            {
                if (grid[y, x] == 1)
                {
                    CreateWall(x, y);
                }
            }
        }
    }

    private void CreateWall(int col, int row)
    {
        Vector2 pos = new Vector2(
            col * TileSize + TileSize / 2f,
            row * TileSize + TileSize / 2f
        );

        var wall = new StaticBody2D();
        wall.Position = pos;

        var shape = new CollisionShape2D();
        var rect = new RectangleShape2D();
        rect.Size = new Vector2(TileSize, TileSize);
        shape.Shape = rect;

        var sprite = new Sprite2D();
        sprite.Texture = wallTexture;
        sprite.Position = Vector2.Zero;

        wall.AddChild(shape);
        wall.AddChild(sprite);

        wallsParent.AddChild(wall);
    }


    // --------------------------
    // GODOT 4.5 API CORRECTED
    // --------------------------
    private Texture2D CreateSolidColorTexture(int width, int height, Color color)
    {
        var img = Image.CreateEmpty(width, height, false, Image.Format.Rgba8);

        for (int y = 0; y < height; y++)
        {
            for (int x = 0; x < width; x++)
            {
                img.SetPixelv(new Vector2I(x, y), color);
            }
        }

        return ImageTexture.CreateFromImage(img);
    }
}

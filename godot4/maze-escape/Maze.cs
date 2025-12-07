using Godot;

public partial class Maze : Node2D
{
    private TileMapLayer map;

    // Maze 10×10 (1 = wall, 0 = path)
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
        // Lấy TileMapLayer
        map = GetNode<TileMapLayer>("TileMap/Layer0");

        DrawMaze(maze10x10);

        GD.Print("Maze 10x10 loaded!");
    }

    private void DrawMaze(int[,] grid)
    {
        int width = grid.GetLength(0);
        int height = grid.GetLength(1);

        for (int x = 0; x < width; x++)
        {
            for (int y = 0; y < height; y++)
            {
                // grid[x,y] = 0 hoặc 1 → tile ID
                map.SetCell(new Vector2I(x, y), grid[x, y]);
            }
        }
    }
}
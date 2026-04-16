using UnityEngine;

public class ColorTintModifier : MonoBehaviour
{
    public bool isScannerActive;
    public Color color;
    public Texture2D customAlbedo;

    private void Start()
    {
        if (isScannerActive)
            Shader.EnableKeyword("_ISSCANNERENABLED");
        else
            Shader.DisableKeyword("_ISSCANNERENABLED");

        GetComponent<Renderer>().material.SetTexture("MyAlbedo", customAlbedo);
    }

    void Update()
    {
        Shader.SetGlobalColor("_ColorTint", color);
    }
}

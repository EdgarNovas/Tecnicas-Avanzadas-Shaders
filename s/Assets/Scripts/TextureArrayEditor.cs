using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using System.IO;

public class TextureArrayBuilder
{
    [MenuItem("Tools/Build Texture2D Array From Selection")]
    static void BuildTextureArray()
    {
        Object[] selection = Selection.objects;

        List<Texture2D> textures = new List<Texture2D>();

        foreach (var obj in selection)
        {
            if (obj is Texture2D tex)
            {
                textures.Add(tex);
            }
        }

        if (textures.Count == 0)
        {
            Debug.LogError("No textures selected.");
            return;
        }

        // Use first texture as reference
        Texture2D refTex = textures[0];

        int width = refTex.width;
        int height = refTex.height;
        TextureFormat format = refTex.format;
        int mipCount = refTex.mipmapCount;

        // Validate all textures
        foreach (var tex in textures)
        {
            if (tex.width != width || tex.height != height)
            {
                Debug.LogError($"Texture {tex.name} size mismatch.");
                return;
            }

            if (tex.format != format)
            {
                Debug.LogError($"Texture {tex.name} format mismatch.");
                return;
            }

            if (tex.mipmapCount != mipCount)
            {
                Debug.LogError($"Texture {tex.name} mipmap mismatch.");
                return;
            }

            if (!tex.isReadable)
            {
                Debug.LogError($"Texture {tex.name} is not readable. Enable Read/Write in import settings.");
                return;
            }
        }

        // Create Texture2DArray
        Texture2DArray textureArray = new Texture2DArray(
            width,
            height,
            textures.Count,
            format,
            mipCount > 1,
            false
        );

        textureArray.wrapMode = refTex.wrapMode;
        textureArray.filterMode = refTex.filterMode;
        textureArray.anisoLevel = refTex.anisoLevel;

        // Copy textures into array
        for (int i = 0; i < textures.Count; i++)
        {
            for (int mip = 0; mip < mipCount; mip++)
            {
                Graphics.CopyTexture(textures[i], 0, mip, textureArray, i, mip);
            }
        }

        // Save asset
        string path = EditorUtility.SaveFilePanelInProject(
            "Save Texture Array",
            "NewTextureArray",
            "asset",
            "Select location to save the texture array."
        );

        if (string.IsNullOrEmpty(path))
            return;

        AssetDatabase.CreateAsset(textureArray, path);
        AssetDatabase.SaveAssets();

        Debug.Log("Texture2DArray created at: " + path);
    }
}
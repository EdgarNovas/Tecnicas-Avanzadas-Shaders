Shader "Custom/MyFirstShaderLab"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalMap ("Normal", 2D) = "bump" {}
        _MaskMap ("Mask Map", 2D) = "black" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NormalMap;
        sampler2D _MaskMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float2 uv_MaskMap;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 albedoColor = tex2D (_MainTex, IN.uv_MainTex);
            fixed3 normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            fixed4 masks = tex2D(_MaskMap, IN.uv_MaskMap);

            o.Albedo = albedoColor.rgb;
            o.Normal = normal.rgb;
            o.Metallic = masks.r;
            o.Smoothness = masks.g;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

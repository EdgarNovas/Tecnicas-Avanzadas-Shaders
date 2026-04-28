Shader "Custom/CustomLightning"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _AmbientColor ("Ambient color", Color) = (1,1,1,1)
        _Specular ("Specular", Float) = 0
        _Displacement ("Displacement", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:myVert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        #include "UnityPBSLighting.cginc"

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 vertexColor;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float4 _AmbientColor;
        float _Specular;
        float _DisAmount;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        half4 LightingMyStandart(SurfaceOutputStandard s, half3 lightDir, half atten)
        {
            half lightIntensity = saturate(dot(s.Normal,lightDir)); //Saturate == clamp //clamp(x,0,1) //max (0,x)
            half specularIntensity = pow(lightIntensity, 128 ) * _Specular;

            half3 albedoColor = s.Albedo * lightIntensity * atten * _LightColor0.rgb;
            half3 specularColor = specularIntensity * _LightColor0.rgb;

            half3 color = albedoColor + _AmbientColor.rgb + specularColor ;
            return half4(color , 1);
        }


        void myVert(inout appdata_full v) 
        {
            v.vertex.g += _SinTime * _DisAmount;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

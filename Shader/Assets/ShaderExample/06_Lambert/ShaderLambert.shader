Shader "KCH/06_Lambert"
{
    // 조명계산을 직접함

    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("NormalMap", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Test 

        sampler2D _MainTex;
		sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			o.Alpha = c.a;
        }

		float4 LightingTest (SurfaceOutput s, float3 lightDir, float atten) {
			float ndotl = saturate(dot(s.Normal, lightDir));
			float4 final;
			final.rgb = ndotl * s.Albedo * _LightColor0.rgb * atten;
			final.a = s.Alpha;
			return final;
		}

        ENDCG

		//struct SurfaceOutput
		//{
		//	half3 Albedo;		// 기본 색상
		//	half3 Normal;		// Normal Map
		//	half3 Emission;		// 빛의 영향을 받지않는 색상
		//	half Specular;		// 반사광
		//	half Gloss;			// Specular의 강도
		//	half Alpha;			// 알파
		//};
    }
    FallBack "Diffuse"
}

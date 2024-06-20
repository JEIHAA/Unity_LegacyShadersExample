Shader "KCH/10_DiffuseWarping"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RampTex ("RampTex", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf Warp noambient

		sampler2D _MainTex;
		sampler2D _RampTex;

		struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
        }

		float4 LightingWarp(SurfaceOutput s, float3 lightDir, float atten)
		{
			float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
			float4 ramp = tex2D(_RampTex, float2(ndotl, 0.5)); // 텍스쳐의 u는 계산하고 (ndotl) v는 중간값으로
            // 명암을 텍스쳐의 uv가져와서 찍음
            // 텍스쳐에 uv애니메이션을 넣거나 마스킹을 사용하면 아주 독특하게 만들수있음
			return ramp;
		}
        ENDCG
    }
    FallBack "Diffuse"
}

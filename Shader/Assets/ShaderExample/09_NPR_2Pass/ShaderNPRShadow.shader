Shader "KCH/09_NPRShadow"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf Toon noambient

		sampler2D _MainTex;

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

		float4 LightingToon(SurfaceOutput s, float3 lightDir, float atten)
		{
			float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
            // 조명의 밝기. 내적한 결과.

			if(ndotl > 0.5) ndotl = 1;
			else ndotl = 0.1;
            // 밝기가 일정 이상이면 1 일정 이하면 0.3

			//ndotl = ndotl * 5;
			//ndotl = ceil(ndotl) / 5;

			return ndotl;
		}
        ENDCG
    }
    FallBack "Diffuse"
}

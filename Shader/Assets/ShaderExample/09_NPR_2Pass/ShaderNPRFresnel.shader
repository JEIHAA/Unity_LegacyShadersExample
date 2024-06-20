Shader "KCH/09_NPRFresnel"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
		
		CGPROGRAM
		#pragma surface surf Toon noambient alpha:fade

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

		float4 LightingToon(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
		{
			float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;

			if(ndotl > 0.5) ndotl = 1;
			else ndotl = 0.3;

			float rim = abs(dot(s.Normal, viewDir));
			if (rim > 0.3) rim = 1;
			else rim = -1;

			float4 final;
			final.rgb = s.Albedo * ndotl * _LightColor0.rgb * rim;
			final.a = 0.1;//s.Alpha;
			return final;
		}
        ENDCG
    }
    FallBack "Diffuse"
}

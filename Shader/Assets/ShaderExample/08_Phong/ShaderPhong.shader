Shader "KCH/08_Phong"
{
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
        #pragma surface surf Test noambient

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

		float4 LightingTest (SurfaceOutput s,
		                     float3 lightDir,
							 float3 viewDir,
							 float atten) {
			// Specular
			float3 H = normalize(lightDir + viewDir);
			float spec = saturate(dot(H, s.Normal));
			spec = pow(spec, 5);
            // 뒤의 숫자가 클 수록 빛의 밀도가 높아짐.
            // 빛나야하는 부분만 빛남.
			return spec;
		}

        ENDCG
    }
    FallBack "Diffuse"
}

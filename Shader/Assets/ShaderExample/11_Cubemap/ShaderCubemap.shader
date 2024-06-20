Shader "KCH/11_Cubemap"
{
	// 메탈릭이나 스무스니스처럼 물기 연산 기반이 아님
	// 실제로 비치는게 아니라 비친 것처럼 보이게 하는 것

    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("NormalMap", 2D) = "bump" {}
		_Cube ("CubeMap", Cube) = "" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf Lambert noambient

		sampler2D _MainTex;
		sampler2D _BumpMap;
		samplerCUBE _Cube;

		struct Input
        {
            float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 worldRefl;
			INTERNAL_DATA
			// 월드 반사 벡터
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			float4 re = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));
			o.Albedo = c.rgb * 0.5;
			o.Emission = re.rgb * 0.5;
			o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

Shader "KCH/13_AlphaBlending"
{
    // 카메라에 가까운 녀석이 위에 그려지는 문제가 있음
    // 비슷한 문제로 z-fighing이 있음 (같은 거리에 있을 때 얼룩져서 같이 보이는 거)

    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		cull off
		zwrite off

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

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
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}

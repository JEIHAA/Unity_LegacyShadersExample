Shader "KCH/13_AlphaCutout"
{
    // 알파가 일정 이하면 그냥 안그려버림
    // fade방식은 풀만 보여도 그림자는 박스모양으로 나오는데
    // cutout은 그림자도 풀 모양으로 보임
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
    }
    SubShader {
        Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest" }

        CGPROGRAM
        #pragma surface surf Lambert alphatest:_Cutoff
        // 알파 테스트 방식 키워드 Cutoff임 cutcout아님

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
    FallBack "Transparent/Cutout/Diffuse"
}

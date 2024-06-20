Shader "KCH/03_FireEffect"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MainTex2 ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        // 옵션을 정하는 느낌
        // RenderType을 ㅆTransparent로 하겠다. (반투명)
        // RenderType 그리는 타입
        // Queue, RenderQueue. 그리는 순서를 큐에 넣어놓고 순서대로 그림
        // 그리는 순서를 정함
		Tags { "RenderType" = "Transparent" "Queue" = "Transparent" } //"Transparent+1" 하면 순서 바꿀 수 있음

        CGPROGRAM
        #pragma surface surf Standard alpha:fade
        // alpha:fade 안하면 알파값이 들어있는 텍스쳐여도 반투명 안됨

        sampler2D _MainTex;
        sampler2D _MainTex2;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex); // 불 이미지
            fixed4 c2 = tex2D (_MainTex2, float2(IN.uv_MainTex.x, IN.uv_MainTex.y - _Time.y *0.5)); // 일렁일렁 이미지 // uv를 애니메이션화해주는 부분
            // v값에 y를 시간에 따라 이동시킴 _Time 유니티에서 쉐이더에서 쓸 수 있게 빌트인으로 만들어줌
            // 타임스케일
            // _Time(t/20, t, t*2, t*3), _SinTime(t/8, t/4, t/2, t), _CosTime(t/8, t/4, t/2, t), unity_DeltaTime(dt, 1/dt, smoothDt, 1/smoothDt)
            o.Emission = c.rgb * c2.rgb;
			o.Alpha = c.a * c2.a;
            // 픽셀 당 알파 값
        }
        ENDCG
    }
    FallBack "Diffuse"
}

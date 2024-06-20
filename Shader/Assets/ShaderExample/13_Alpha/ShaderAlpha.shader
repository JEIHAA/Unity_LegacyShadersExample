Shader "KCH/13_Alpha"
{
    SubShader {
        Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf Lambert noambient noshadow

		sampler2D _CameraDepthTexture;
		// 카메라가 찍은 깊이버퍼를 텍스쳐로 가져옴


		struct Input {
			float4 screenPos;
			// 스크린에서 어디에 찍히느냐
        };

        void surf (Input IN, inout SurfaceOutput o) {
			float2 sPos = float2(IN.screenPos.x, IN.screenPos.y) / IN.screenPos.w;
			// 지금 찍으려는 픽셀이 스크린에서 어디에 있는지 계산
			// 호모지니어스 좌표계/동차 좌표계
			float4 Depth = tex2D(_CameraDepthTexture, sPos);
			o.Emission = Depth.r;
        }
        ENDCG
    }
    FallBack off
}

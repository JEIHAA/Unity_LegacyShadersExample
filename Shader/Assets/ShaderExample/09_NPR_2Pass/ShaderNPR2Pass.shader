Shader "KCH/09_NPR2Pass"
{
    // 모델을 두번 그리는데 파이프라인을 두번 가는건 아니고
    // 쉐이더에서 픽셀을 두번 찍는것
    // 한번은 크게 그려서 컬링을 반대로 해서 바깥쪽에
    // 한번은 작게 그려서 컬링을 제대로 해서 안쪽에 그린다
    // 바깥쪽을 그릴 때 크기만 설정하면 아웃라인의 두께를 조절할 수 있음
    // 셀 셰이딩(카툰렌더링)에서는 사용 못함, 오로지 외곽만 그려짐
    // 안쪽 디테일은 따로 알고리즘 사용해서 그려야함
    // Depth Buffer 사용하면 깊이에 따라 아웃라인 그려짐 깔끔함 디테일함. ex)워킹데드

    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

		cull front // front를 컬링

		// Pass 1
        CGPROGRAM
        #pragma surface surf Nolight vertex:vert noshadow noambient
        // surface에서 조명 처리를 안하고 램버트로 직접하기 위해 Nolight라는 이름으로 함수만듦
        // 크기를 키워서 픽셀을 찍어야하기 때문에 버텍스가 있어야함 vertex:vert
        // 아웃라인은 그림자가 생기면 안되고 주변광의 영향을 받으면 안됨 noshadow noambient

		void vert(inout appdata_full v) { // appdata 파이프라인에 들어오는 정보 _full 전부 를 다루는 용으로 있는 구조체 appdata_full
			v.vertex.xyz += v.normal.xyz * 0.002;
            // 정점의 위치를 이동시킴
            // 각 정점를 옮기는거기 때문에 닿아있던 부분이 떨어져서 아웃라인이 쪼개지는 문제가 발생할 수 있음
            // 처음에 모델을 잘 만들어야함
		}

        struct Input { float4 color:COLOR; };

        void surf (Input IN, inout SurfaceOutput o) {}

		float4 LightingNolight (SurfaceOutput s, float3 lightDir, float atten) {
			return float4(0.8, 0.7, 0.8, 1);
		}
		ENDCG

        // 두번째 pass 시작

		cull back // back을 컬링

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;

		struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = float3 (0.9,0.5,0.9);//c.rgb;
			o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

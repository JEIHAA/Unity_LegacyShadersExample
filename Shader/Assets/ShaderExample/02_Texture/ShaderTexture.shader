Shader "KCH/02_ShaderTexture"
{
    Properties
    {
        // 텍스쳐 가져오는 기본 폼
        _MainTex ("Albedo (RGB)", 2D) = "black" {}
        // 텍스쳐를 가져올 때 반드시 한장은 _MainTex라는 이름으로 가져와야 함
        // 2D . Texture2D를 2D로 쓰면 됨
        _MainTexTo ("Albedo (RGB)", 2D) = "black" {}

        _ratio ("Raito", Range(0, 1)) = 0
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        // fullforwardshadows는 옵션. 그림자 관련 옵션
        // 어떤 것들을 쓸지 뒤에 쭉 써줘야함. surface에서 자동으로 해주지만 어떤 것들을 사용할지는 알려줘야함
        // URP는 체크박스로 껐다켰다가 가능해서 뒤에 옵션 쭉 적어주는거 안해도 됨

        // UV를 기준으로 스테이지에서 데이터를 가져오는 애가 sampler, 그 과정을 sampling이라고 함
        // 텍스쳐를 찍을 때 픽셀 하나 찍는 게 sampler가 가져다 준 데이터를 찍는 것
        sampler2D _MainTex;
        sampler2D _MainTexTo;

        half _ratio;

        struct Input
        {
            // 버텍스 하나당 uv가 여러개 들어갈 수 있음
            // 텍스쳐가 여러개일 수 있어서.
            // 얼굴을 언랩했을 때 통채로 하나만 찍어도 되면 uv도 하나면 됨
            // 그런데 눈 색깔만 바꾸거나 머리카락 색깔이 바뀌는 경우 다른 곳에 빼놔야함
            // = uv도 바뀌어야함 = uv가 여러개여야함
            float2 uv_MainTex;
            // 첫번째 uv를 가져올 때는 반드시 이 이름이여야 함
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // 픽셀 당 돌아가는 거임. 텍스쳐에서 uv에서 픽셀 하나 가져와서 화면에 픽셀 하나를 찍는 과정임
            // 픽셀 수 만큼 돌아감.

            //텍스쳐 두 장의 색을 가져오는 중
			float4 texColor = tex2D (_MainTex, IN.uv_MainTex); // uv 위치가 계산돼서 들어오는 것
			float4 texToColor = tex2D (_MainTexTo, IN.uv_MainTex);

			//o.Albedo = texColor.rgg;
            // rbg의 자리를 바꿀 수 있음. r자리에 g, b자리에 r넣으면 그렇게 들어가서 색이 바뀜. swizzling 기법
            // 이상한 거 먹고 색이 막 바뀌는 효과 같은거는 swizzling임.
            // 텍스쳐를 계속 바꾸는건 너무너무 비효율적임. rgb 순서만 바꾸면 바인딩할 필요도 없고 아주 효율적
            
            //o.Emission = texColor.r * 0.2989 + texColor.g * 0.5870 + texColor.b * 0.1140; 
            // 포토샵에서 그레이스케일 만드는 공식. r g b를 각각 해당 비율로 섞으면 rrr, ggg, bbb같은 것보다 이쁜 회색이 나옴.
            // Albedo는 조명까지 계산해서 발산되는 색. Emission은 물체의 원래 색.
			o.Emission = lerp(texColor.rgb, texToColor.rgb, _ratio);
            // 각 텍스쳐의 rgb를 보간. 0.5는 각자 반반 보간
            // 두장을 겹치는데 반투명한게 아니라 픽셀 하나 찍을 때 텍스쳐 두개 보간해서 찍는거임
            // 한장을 그리는 거임

            //if (texColor.a > 0) // 알파 값이 0보다 크다면 = 투명이 아니라면.
            //    o.Emission = texColor.rgb;
            //else
            //   o.Emission = texToColor.rgb;

            //if (texColor.g > 0.7 &&  texColor.r < 0.5 && texColor.b < 0.5) // 녹색이 0.5보다 크면. 녹색이 많이 들어간 곳은
            //    o.Emission = half3(1,0,1);
            //else if (texColor.g > 0.6 &&  texColor.r < 0.5 && texColor.b < 0.5)
            //    o.Emission = half3(0.7,0,0.7);
            //else if (texColor.g > 0.4 &&  texColor.r < 0.5 && texColor.b < 0.5)
            //    o.Emission = half3(0.5,0,0.5);
            //else if (texColor.g > 0.3 &&  texColor.r < 0.5 && texColor.b < 0.5)
            //    o.Emission = half3(0.3,0,0.3);
            //else
                o.Emission = texColor.rgb;

        }
        ENDCG
    }
    FallBack "Diffuse"
}

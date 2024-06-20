Shader "KCH/07_Hologram"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("NormalMap", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

        CGPROGRAM
        #pragma surface surf Lambert noambient alpha:fade
        // no ambient 주변광을 사용하지 않겠다. 주변광에 영향을 받으면 안됨.

        sampler2D _MainTex;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
			float3 viewDir;
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            //o.Albedo = c.rgb;
			//o.Emission = float3(0, 1, 0);
            //o.Emission = IN.worldPos.rgb;
            o.Emission = IN.worldPos.g;
            o.Emission = frac(IN.worldPos.g);
            o.Emission = pow(frac(IN.worldPos.g),30);
            o.Emission = pow(frac(IN.worldPos.g*3),30);
            o.Emission = pow(frac(IN.worldPos.g*3 - _Time.y),30) * float3(0,1,0);

            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			float rim = saturate(dot(o.Normal, IN.viewDir));
			rim = pow(1 - rim, 3);
            o.Alpha = rim;
            //o.Alpha = 1;

            //o.Alpha = rim*(sin(_Time.y)*0.5+0.5);
            //o.Alpha = rim*sin(_Time.y);
            //o.Alpha = rim*abs(sin(_Time.y)); // 절대값
        }
        ENDCG
    }
    FallBack "Diffuse"
    // 짜둔 코드가 지원되지 않을 경우 대신 돌릴 것
}

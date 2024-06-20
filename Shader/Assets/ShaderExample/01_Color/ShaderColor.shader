// https://docs.unity3d.com/Manual/SL-SurfaceShaders.html

Shader "LHE/01_Color" // 머티리얼에서 쉐이더를 고를 때 보이는 파일명
{
	Properties // 속성 값 지정
	{
		_colorR ("Color R", Range(0, 1)) = 1
		// _colorR 변수는 아님. 값을 저장하지 않음. 외부와 내부의 중간쯤 있는 변수같은 거
		// _미들네임("인스펙터 창에 보여질 이름", 자료형) = Default
		_colorG ("Color G", Range(0, 1)) = 1
		_colorB ("Color B", Range(0, 1)) = 1

		_Metallic ("Metallic", Range(0, 1)) = 1
		_Glossiness ("Glossiness", Range(0, 1)) = 1
	}

	SubShader
	{
		CGPROGRAM // CG. 엔비디아에서 만듦 CGPROGRAM 부터 ENDCG까지는 CG기반의 코드이다 라는 의미

		// #pragma surface surfaceFunction lightModel [optionalparams]
		#pragma surface surf Standard // #pragma. 전처리. 컴파일러 설정
		// surface를 사용하겠다. 유니티에서 고정 함수를 자동으로 적용시켜주는 기능을 사용하겠다
		// surface 쉐이더의 surf함수를 사용하겠다. Standard로 만들겠다
		// 유니티의 가장 기본적인 쉐이더를 사용하겠다
		// 기본 쉐이더 = 풀옵션
		// 물리 기반 연산을 모두 함. 무거움

		struct Input // 어떤 정보를 가지고 올 것인가
		{
			// 버텍스 당 컬러
			float4 color : COLOR; // float 몇개짜리 쓸거냐, 4개짜리. (R G B A) color라는 이름으로
			// : COLOR . Sementic. 해당 변수가 쉐이더에서 색상 정보를 나타낸다는 것을 나타냄
			// Semantic(의미론적)은 쉐이더 프로그래밍에서 변수나 구조체의 사용 목적이나 의미를 나타내는 지시어. 
			// 쉐이더 코드를 해석하고 실행하는 데 필요한 정보를 제공함
		};


		// 실제 변수 선언, 미들네임이랑 같게 만듦
		//쉐이더는 실수만 처리함. 쉐이더는 특이하게 부호비트 포함해서 11비트임
		fixed _colorR;
		fixed _colorG;
		fixed _colorB;
		// 텍스쳐빼고 뭐 빼고 가장 기본적으로 가지고 있는 색상
		// 버텍스 위치, UV, 노멀, 컬러 중 컬러를 담당

		half _Metallic;
		half _Glossiness;
		// half가 엔비디아 기준 두배 빠름
		// int랑 비슷. 엔비디아는 half를 기준으로 연산하게 만들었기 때문

		// Standard 쉐이더 만들고 있기 때문에 SurfaceOutput'Standard' 구조체를 불러와서 필요한 내용을 바꾸는것
		// 다른 구조체를 불러오면 에러남

		// SurfaceOutputStandard 내용
		/*struct SurfaceOutputStandard
		  {
			fixed3 Albedo;      // 반사되는 색
			fixed3 Normal;      // 법선
			half3 Emission;		// 발산되는 색
			half Metallic;      // 0=메탈 영향 없음, 1=메탈
			half Smoothness;    // 0=거칠게, 1=부드럽게
			half Occlusion;     // 차폐로 인한 환경광의 영향도 (기본 1)
			fixed Alpha;        // 투명도
		};*/

		void surf(Input In, inout SurfaceOutputStandard o)
		{
			o.Albedo = float3(_colorR, _colorG, _colorB); // 여기는 fixed나 half나 속도차이 안남
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness; // 같은거임 용어 다른데 헷갈리면 안됨
		}

		ENDCG
	}
}
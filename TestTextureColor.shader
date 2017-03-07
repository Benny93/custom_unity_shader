Shader "Custom/TestTextureColor" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}		
	}
	SubShader {
		Pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		
		fixed4 _Color;
		sampler2D _MainTex;
		
		struct v2f {
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
		};
		
		float4 _MainTex_ST;
		
		v2f vert (appdata_base v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
			return o;
		}
		
		fixed4 frag (v2f i): SV_Target
		{
			fixed4 texcol = tex2D(_MainTex, i.uv);
			return texcol * _Color;
		}

	
		ENDCG
		}
	} 	
}

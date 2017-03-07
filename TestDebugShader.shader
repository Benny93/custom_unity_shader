Shader "Custom/TestDebugShader" {	
	SubShader {
		  Pass {

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 color : COLOR0;
            };

            v2f vert (appdata_base v)
            {
                v2f o; //vertex to fragment                             
                //o.pos = mul(UNITY_MATRIX_MVP, float4(v.vertex, 1.0));
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.color = v.normal * 0.5 + 0.5;
                return o; //o.pos = UnityObjectToClipPos(v.vertex);  
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4 (i.color, 1);
            }
            ENDCG

        }
	} 	
}

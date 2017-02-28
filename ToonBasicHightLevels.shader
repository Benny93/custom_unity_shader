//Author: Benjamin Vollmer
Shader "Custom/ToonBasicHightLevels" {
	Properties {
		_Color ("Main Color", Color) = (.5,.5,.5,1)
		_ColorSea ("Color Sealevel", Color) = (0.5,0.8,1,1)
     	_ColorBeach ("Color BeachLevel", Color) = (1,0.9,0.7,1)
     	_ColorVeg ("Color Vegetation Level", Color) = (0.25,0.5,0.1,1)
     	_ColorMountain ("Color Mountain Level", Color) = (0.7,0.7,0.7,1)
     	
		_HeightSea ("Height Sealevel", Float) = 0
     	_HeightBeach ("Height Beach", Float) = 2
     	_HeightVeg ("Height Vegetation", Float) = 3  
     	
     	_SmoothDistance("Smooth Distance", Range (.1, 2)) = 1  	
		
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_CliffTex ("Cliff Texture", 2D) = "grey" {}
		_ToonShade ("ToonShader Cubemap(RGB)", CUBE) = "" { }  
		_CliffDot("Cliff Factor Steepness", Range(0,1)) = 0.8	
     	_VecRight ("Right Vector ", Vector) = (0,1,0,0)
	}


	SubShader {
		Tags { "RenderType"="Opaque" }
		Pass {
			Name "BASE"
			Cull Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members NtoR)
#pragma exclude_renderers d3d11 xbox360
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			sampler2D _MainTex;			
			samplerCUBE _ToonShade;
			sampler2D _CliffTex;
			float4 _MainTex_ST;
			float4 _CliffTex_ST;
			float4 _Color;
			
     
     		fixed4 _ColorSea;
     		fixed4 _ColorBeach;
     		fixed4 _ColorVeg;
     		fixed4 _ColorMountain;
     
		    float _HeightSea;
		    float _HeightBeach;
		    float _HeightVeg;
		    float _SmoothDistance;
		    
		    float4 _VecRight;
		    float _CliffDot;
     

			struct appdata {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordCliff : TEXCOORD1;
				float3 normal : NORMAL;
			};
			
			struct v2f {
				
				float4 pos : SV_POSITION;
				float2 texcoord : TEXCOORD0;				
				float3 cubenormal : TEXCOORD1;
				float4 worldPos : TEXCOORD2;
				float2 texcoordCliff : TEXCOORD3;
				float NtoR;
				UNITY_FOG_COORDS(2)
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.worldPos = mul(_Object2World, v.vertex);				
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.texcoordCliff = TRANSFORM_TEX(v.texcoord, _CliffTex);
				o.cubenormal = mul (UNITY_MATRIX_MV, float4(v.normal,0));
				o.NtoR = abs( dot(v.normal, _VecRight));
				UNITY_TRANSFER_FOG(o,o.pos);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{			       
       			
      			fixed4 tintColor = _ColorSea;
      			if(i.worldPos.y > _HeightSea){
      				//tintColor = _ColorBeach;
      				float maxHeight = _HeightSea+ _SmoothDistance;
      				float h = (maxHeight-i.worldPos.y) / (maxHeight-_HeightSea);
      				tintColor = lerp(_ColorBeach.rgba, _ColorSea.rgba, h);
      				if(i.worldPos.y > maxHeight){
      					tintColor = _ColorBeach;
      				}      				
      			}
      			if(i.worldPos.y > _HeightBeach){
      				//tintColor = _ColorVeg;
      				float maxHeight = _HeightBeach+ _SmoothDistance;
      				float h = (maxHeight-i.worldPos.y) / (maxHeight-_HeightBeach);
      				tintColor = lerp(_ColorVeg.rgba, _ColorBeach.rgba, h);
      				if(i.worldPos.y > maxHeight){
      					tintColor = _ColorVeg;
      				}
      			}
      			if(i.worldPos.y > _HeightVeg){
					//tintColor = _ColorMountain;
					float maxHeight = _HeightVeg+ _SmoothDistance;
      				float h = (maxHeight-i.worldPos.y) / (maxHeight-_HeightVeg);
      				if(h > 1 ) h = 1;
      				tintColor = lerp(_ColorMountain.rgba, _ColorVeg.rgba, h);
      				if(i.worldPos.y > maxHeight){
      					tintColor = _ColorMountain;
      				}
				}			
				
				fixed4 col =_Color * tintColor * tex2D(_MainTex, i.texcoord).rgba;									
				float t = (1- i.NtoR)/(_CliffDot);					
				if(t > 1 ) t = 1;
				if(t < _CliffDot ) t = 0;					
				col = lerp(col.rgba, (_Color  * tex2D(_CliffTex, i.texcoordCliff)).rgba,t);	
				
				fixed4 cube = texCUBE(_ToonShade, i.cubenormal);
				fixed4 c = fixed4(2.0f * cube.rgb * col.rgb, col.a);
				UNITY_APPLY_FOG(i.fogCoord, c);
				return c;
			}
			ENDCG			
		}
	} 

	Fallback "VertexLit"
}

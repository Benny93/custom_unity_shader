Shader "Custom/TestCelShader"
{
	Properties
	{
		_Color ("Main Color", Color) = (1,0.5,0.5,1)
		_SpecColor("Spec Color", Color) = (1,1,1,1)
		_Emission ( "Emisive Color", Color)=(0,0,0,0)
		_Shininess("Shininess", Range(0.01,1))=0.7
		_MainTex("Base (RGB)", 2D) = "white" {}
	}
	SubShader
	{
		Pass{
			Material{
				Diffuse [_Color]
				Ambient [_Color]
				Shininess [_Shininess]
				Specular [_SpecColor]
				Emission[_Emission]
			}
			Lighting On
			SeparateSpecular On
			SetTexture[_MainTex]{
			constantColor[_Color]
			Combine texture * primary DOUBLE, texture * constant
			}
		}
		
	}
}

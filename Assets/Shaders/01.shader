Shader "hqr/001 Shader" {
	Properties {
		_Color("Color",Color)=(0,0,0,0)
		_Vector("Vertor",Vector)=(0,0,0,0)
		_Float("Float",Float)=4.5
		_2D("Texture",2D) = "red"{}
		_Cube("Cube",Cube) = "white"{}
	}
		SubShader{
			Pass{
				CGPROGRAM

				float4 _Color;
				float4 _Vector;
				float _Float;
				sampler2D _2D;
				samplerCube _Cube;

				//float 32位浮点数
				//half 16位浮点数
				//fixed 11位浮点数

			ENDCG
		}
	}
	FallBack "Diffuse"
}

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "hqr/003 Shader"{
	SubShader{
		Pass{
		CGPROGRAM

#pragma vertex vert
#pragma fragment frag

		struct a2v {
			float4 vertex : POSITION; //告诉Unity把模型空间下的顶点坐标填充给vertex
			float3 normal : NORMAL;	//告诉Unity把模型空间下的法线方向填充给normal
			float4 texcoord : TEXCOORD0; //告诉Unity把第一套纹理坐标填充给texcoord
		};

		float4 vert(a2v v) : SV_POSITION {
			return UnityObjectToClipPos(v.vertex);
		}

		fixed4 frag() : SV_Target {
			return fixed4(.5,1,1,1);
		}

	ENDCG
	}
	}

		Fallback "Diffuse"
}
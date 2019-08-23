// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "hqr/003 Shader"{
	SubShader{
		Pass{
		CGPROGRAM

#pragma vertex vert
#pragma fragment frag

		//application to vert
		struct a2v {
			float4 vertex : POSITION; //告诉Unity把模型空间下的顶点坐标填充给vertex
			float3 normal : NORMAL;	//告诉Unity把模型空间下的法线方向填充给normal
			float4 texcoord : TEXCOORD0; //告诉Unity把第一套纹理坐标填充给texcoord
		};

		struct v2f {
			float4 position : SV_POSITION;
			float3 tmp : COLOR0;
		};

		v2f vert(a2v v) {
			v2f f;
			f.position = UnityObjectToClipPos(v.vertex);
			f.tmp = v.normal;
			return f;
		}

		fixed4 frag(v2f f) : SV_Target {
			return fixed4(f.tmp,1);
		}

	ENDCG
	}
	}

		Fallback "Diffuse"
}
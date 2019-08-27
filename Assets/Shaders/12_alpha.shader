// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "hqr/012 Shader"{
	Properties{
		_Color("Texture Color",Color) = (1,1,1,1)
		_MainTex("Main Texture",2D) = "white"{}
		_NormalTex("Normal Texture",2D) = "bump"{}
		_BumpScale("Bump Scale",Float) = 1
		_AlphaScale("Alpha Scale",Range(0,1)) = 1
	}

		SubShader{
			Tags{ "Queue"="Transparent" "IngnoreProjector"="False" "Render"="Transparent" }
			Pass{
		Tags{"LightMode" = "ForwardBase"}

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
		#include "Lighting.cginc" 
		#pragma vertex vert
		#pragma fragment frag

		fixed4 _Color;
		sampler2D _MainTex;
		float4 _MainTex_ST;
		sampler2D _NormalTex;
		float4 _NormalTex_ST;
		float _BumpScale;
		half _AlphaScale;

		struct a2v {
			float4 vertex : POSITION; //告诉Unity把模型空间下的顶点坐标填充给vertex
			float3 normal : NORMAL;	//告诉Unity把模型空间下的法线方向填充给normal
			float4 tangent : TANGENT; //tangent.w是用来确定切线空间中坐标轴的方向的 
			float4 texcoord : TEXCOORD0;
		};

		struct v2f {
			float4 position : SV_POSITION;
			float3 lightDir : TEXCOORD0;
			float4 uv : TEXCOORD1;
		};

		v2f vert(a2v v) {
			v2f f;
			f.position = UnityObjectToClipPos(v.vertex);
			//x和y是缩放，z和w是偏移
			f.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			f.uv.zw = v.texcoord.xy * _NormalTex_ST.xy + _NormalTex_ST.zw;

			TANGENT_SPACE_ROTATION;//调用这个后之后，会得到一个矩阵 rotation 这个矩阵用来把模型空间下的方向转换成切线空间下

			//ObjSpaceLightDir(v.vertex)//得到模型空间下的平行光方向 
			f.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex));

			return f;
		}

		fixed4 frag(v2f f) : SV_Target {

			fixed4 normalColor = tex2D(_NormalTex,f.uv.zw);
						
			fixed3 tangentNormal = UnpackNormal(normalColor);
			tangentNormal.xy = tangentNormal.xy*_BumpScale;
			tangentNormal =	normalize(tangentNormal);

			fixed3 lightDir = normalize(f.lightDir);

			fixed3 texColor = tex2D(_MainTex, f.uv.xy)*_Color.rgb;

			//环境光与贴图颜色融合
			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * texColor;

			//切线空间下的法线与光线的余弦值
			float3 halfLambert = dot(tangentNormal, lightDir) * 0.5 + 0.5;
			fixed3 diffuse = _LightColor0.rgb*halfLambert*texColor;

			fixed3 color = diffuse + ambient;

			return fixed4(color,_AlphaScale);
		}

	ENDCG
	}
	}

		Fallback "Diffuse"
}
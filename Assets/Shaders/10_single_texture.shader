// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "hqr/010 Shader"{
	Properties{
		_Color("Texture Color",Color) = (1,1,1,1)
		_MainTex("Main Texture",2D) = "white"{}
		_SpecularColor("Specular Color",Color) = (1,1,1,1)
		_Gloss("Gloss",Range(8,200)) = 10
	}

		SubShader{
			Pass{
		//只有定义了正确的LightMode才能得到一些Unity的内置光照变量
		Tags{"LightMode" = "ForwardBase"}
		CGPROGRAM
		//包含unity的内置的文件，才可以使用unity内置的一些变量
		//_LightColor0 取得第一个直射光的颜色
		//_WorldSpaceLightPos0 第一个直射光的位置，对于直射光而言，直射光的位置就是直射光的方向
		#include "Lighting.cginc" 
		#pragma vertex vert
		#pragma fragment frag
		fixed4 _Color;
		sampler2D _MainTex;
		float4 _MainTex_ST;
		fixed4 _SpecularColor;
		half _Gloss;

		struct a2v {
			float4 vertex : POSITION; //告诉Unity把模型空间下的顶点坐标填充给vertex
			float3 normal : NORMAL;	//告诉Unity把模型空间下的法线方向填充给normal
			float4 texcoord : TEXCOORD0;
		};

		struct v2f {
			float4 position : SV_POSITION;
			float3 worldNormal : TEXCOORD0;
			float4 worldVertex : TEXCOORD1;
			float2 uv : TEXCOORD2;
		};

		v2f vert(a2v v) {
			v2f f;
			f.position = UnityObjectToClipPos(v.vertex);
			f.worldNormal = UnityObjectToWorldNormal(v.normal);
			f.worldVertex = mul(v.vertex, unity_WorldToObject);
			f.uv = v.texcoord.xy * _MainTex_ST.xy +_MainTex_ST.zw;
			return f;
		}

		fixed4 frag(v2f f) : SV_Target {

			fixed3 texColor = tex2D(_MainTex, f.uv.xy)*_Color.rgb;

			//环境光与贴图颜色融合
			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * texColor;

			//漫反射
			fixed3 normalDir = normalize(f.worldNormal); 
			fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
			float3 halfLambert = dot(normalDir, lightDir) * 0.5 + 0.5;
			fixed3 diffuse = _LightColor0.rgb*halfLambert*texColor;

			//高光反射
			fixed3 viewDir = normalize(UnityWorldSpaceViewDir(f.worldVertex));
			fixed3 halfDir = normalize(lightDir + viewDir);
			fixed3 specular = _LightColor0.rgb * pow(max(dot(normalDir, halfDir), 0), _Gloss) *_SpecularColor.rgb;

			fixed3 color = diffuse + ambient + specular;


			return fixed4(color,1);
		}

	ENDCG
	}
	}

		Fallback "Diffuse"
}
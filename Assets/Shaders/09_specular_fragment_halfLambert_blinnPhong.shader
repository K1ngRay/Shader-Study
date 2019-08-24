// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "hqr/009 Shader"{
	Properties{
		_DiffuseColor("Diffuse Color",Color) = (1,1,1,1)
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
		fixed4 _DiffuseColor;
		fixed4 _SpecularColor;
		half _Gloss;

		struct a2v {
			float4 vertex : POSITION; //告诉Unity把模型空间下的顶点坐标填充给vertex
			float3 normal : NORMAL;	//告诉Unity把模型空间下的法线方向填充给normal
		};

		struct v2f {
			float4 position : SV_POSITION;
			float3 worldNormal : TEXCOORD0;
			float4 worldVertex : TEXCOORD1;
		};

		v2f vert(a2v v) {
			v2f f;
			f.position = UnityObjectToClipPos(v.vertex);
			//f.worldNormal = mul(v.normal, (float3x3) unity_WorldToObject);
			f.worldNormal = UnityObjectToWorldNormal(v.normal);
			f.worldVertex = mul(v.vertex, unity_WorldToObject);

			return f;
		}

		fixed4 frag(v2f f) : SV_Target {

			//环境光
			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

			//漫反射
			fixed3 normalDir = normalize(f.worldNormal); //unity_WorldToObject 用于装换为世界坐标的四维矩阵
			fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
			float3 halfLambert = dot(normalDir, lightDir) * 0.5 + 0.5;
			fixed3 diffuse = _LightColor0.rgb*halfLambert*_DiffuseColor.rgb;

			//高光反射
			//fixed3 reflectDir = normalize(reflect(-lightDir, normalDir));
			//fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - f.worldVertex);
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
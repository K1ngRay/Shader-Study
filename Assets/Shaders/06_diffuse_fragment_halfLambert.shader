﻿// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "hqr/006 Shader"{
	Properties{
		_Color("Color",Color) = (1,1,1,1)
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
				fixed4 _Color = fixed4(1,1,1,1);
				struct a2v {
					float4 vertex : POSITION; //告诉Unity把模型空间下的顶点坐标填充给vertex
					float3 normal : NORMAL;	//告诉Unity把模型空间下的法线方向填充给normal
				};

				struct v2f {
					float4 position : SV_POSITION;
					float3 worldNormal : COLOR0;
				};

				v2f vert(a2v v) {
					v2f f;
					f.position = UnityObjectToClipPos(v.vertex);
					f.worldNormal = mul(v.normal, (float3x3) unity_WorldToObject);

					return f;
				}

				fixed4 frag(v2f f) : SV_Target {

					fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

					fixed3 normalDir = normalize(f.worldNormal); //unity_WorldToObject 用于装换为世界坐标的四维矩阵
					fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
					float3 halfLambert = dot(normalDir, lightDir)*0.5 + 0.5;
					fixed3 diffuse = _LightColor0.rgb*halfLambert*_Color.rgb;
					fixed3 tempColor = diffuse + ambient;
					return fixed4(tempColor,1);
				}

			ENDCG
			}
	}

		Fallback "Diffuse"
}
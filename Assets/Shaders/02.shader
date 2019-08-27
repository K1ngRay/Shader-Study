// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "hqr/002 Shader"{
	SubShader{
		Pass{
		CGPROGRAM

		/*
		*·顶点函数 申明函数名 每个顶点的都会通过这个函数
		*·主要作用是 完成顶点坐标从模型空间转换到剪裁空间（从游戏环境转换到相机屏幕上
		*·主要控制 顶点坐标
		*/
#pragma vertex vert

		/*
		*·片元函数 申明函数名 模型的每一个像素都会通过这个函数
		*·主要作用是 返回模型在屏幕上的每一个像素的颜色值
		*·主要控制 像素颜色
		*/
#pragma fragment frag
		/*
		*·POSITION和SV_POSITION都是Shader的语义系统可以识别的语义参数
		*·POSITION是告诉系统我需要顶点坐标，而 float4 v : POSITION 则是告诉系统把顶点坐标赋值给 v
		*·SV_POSITION 用来解释说明返回值，意思是告诉系统返回值是剪裁空间下的顶点坐标				
		*/
		float4 vert(float4 v : POSITION) : SV_POSITION {
			//UNITY_MATRIX_MVP 是Unity3D专门用来从模型空间转换到剪裁空间的矩阵
			return UnityObjectToClipPos(v);
		}

		fixed4 frag() : SV_Target {
			return fixed4(.5,1,1,1);
		}

		ENDCG
		}
	}

	Fallback "Diffuse"
}
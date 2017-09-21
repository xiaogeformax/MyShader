Shader "rxjh/roleDiffuse" {
	Properties{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Base (RGB)", 2D) = "white" {}
		_NoiseTex("Noise Texture",2D) = "white"{}
		_LightStrength("Lighting Strength",Range(0,2)) = 1.0
		_RefTexture("RefTexture",2D) = "black"{}
		_MoveSpeed("Move Speed",range(-2,2)) = 0.1
		_HeatForce("Heat Force",range(0,0.1)) = 0.1
		_FlowLightStrenth("Flow Light Strength" ,range(0,1)) = 0.5

	}
		SubShader{
			Tags { "RenderType" = "Opaque" "Queue" = "Geometry+100" }
			LOD 200

			Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			sampler2D _RefTexture;
			sampler2D _NoiseTex;
			float4 _MainTex_ST;
			float _MoveSpeed;
			float4 _Color;
			float _LightStrength;
			float _HeatForce;
			float _FlowLightStrenth;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{

				float2 uvmain = i.uv;
				fixed4 col = tex2D(_MainTex, i.uv) * _Color * _LightStrength;
				half4 offsetColor1 = tex2D(_NoiseTex, uvmain + _Time.xz );
				half4 offsetColor2 = tex2D(_NoiseTex, uvmain - _Time.yx);
				// use the r values from the noise texture lookups and combine them for x offset
				// use the g values from the noise texture lookups and combine them for y offset
				// use minus one to shift the texture back to the center
				// scale with distortion amount
				uvmain.x += ((offsetColor1.r + offsetColor2.r)-1 ) * _HeatForce + _Time.y * _MoveSpeed;
				uvmain.y += ((offsetColor1.g + offsetColor2.g) -1) * _HeatForce + _Time.y * _MoveSpeed;
				fixed4 oncol = tex2D(_RefTexture, uvmain);
				col += oncol * _FlowLightStrenth;
				return col ;
			}


			ENDCG
		}
		}
			FallBack "Legacy Shaders/Self-Illumin/Diffuse"
}

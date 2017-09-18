/*
 xiaogeformax@gmail.com
*/

Shader "Custom/VolumetricSphere"
{
    Properties
    {
        _Center ("Center", vector) = (0.0, 0.0, 0.0)
        _ColorCube ("Color cube", Color) = (1, 1, 1, 1)
        _ColorSphere ("Color sphere", Color) = (1, 1, 1, 1)
        _Radius ("Radius", float) = 2.0
        _StepNumber ("Step Number", int) = 10.0
        _StepVal ("Step Val", float) = 0.1
    }
    SubShader
    {
        Pass
        {      
            Blend SrcAlpha OneMinusSrcAlpha
 
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
 
            #include "UnityCG.cginc"
 
            struct v2f {
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };
 
            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                //世界坐标
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                return o;
            }
 
            int _StepNumber;
            float _StepVal;
            float3 _Center;
            float _Radius;
            fixed4 _ColorCube;
            fixed4 _ColorSphere;
 
            fixed4 raymarch(float3 worldPos, float3 viewDirection) {
              for(int i = 0; i < _StepNumber; i++) 
                if(distance(worldPos,_Center)<_Radius)
                    return _ColorSphere;
                    worldPos += viewDirection * _StepVal;
                }

                return _ColorCube;
            }
 
            fixed4 frag(v2f i) : SV_Target {
                float3 viewDirection = normalize(i.worldPos - _WorldSpaceCameraPos);
                return raymarch(i.worldPos, viewDirection);
            }
 
            ENDCG
        }
    }
}
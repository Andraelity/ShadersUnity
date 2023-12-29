Shader "Hidden/Shapes/Trebol"
{
	Properties
	{
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" "DisableBatching" ="true" }
		LOD 100

		Pass
		{
		    ZWrite Off
		    Cull off
		    Blend SrcAlpha OneMinusSrcAlpha
		    
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
            #pragma multi_compile_instancing
			
			#include "UnityCG.cginc"

			struct vertexPoints
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct pixel
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            UNITY_INSTANCING_BUFFER_START(CommonProps)
                UNITY_DEFINE_INSTANCED_PROP(fixed4, _FillColor)
                UNITY_DEFINE_INSTANCED_PROP(float, _AASmoothing)
            UNITY_INSTANCING_BUFFER_END(CommonProps)

            
			pixel vert (vertexPoints v)
			{
				pixel o;
				
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.vertex.xy;
				return o;
			}
			
			fixed4 frag (pixel i) : SV_Target
			{
			
			    UNITY_SETUP_INSTANCE_ID(i);
			    
			    float aaSmoothing = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _AASmoothing);
			    fixed4 fillColor = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _FillColor);
			    
			    i.uv -= float2(0, 0);

			    float2 q = 0.6 * (2.0* i.uv.xy);

			    float iTime = _Time.y; 

			    float a = atan( q );
			    float r = length( q );
			    float s = 0.50001 + 0.5*sin( 3.0*a + iTime );
			    float g = sin( 1.57+3.0*a+iTime );
			    float d = 0.15 + 0.3*sqrt(s) + 0.15*g*g;
			    float h = clamp( r/d, 0.0, 1.0 );
			    float f = 1.0-smoothstep( 0.95, 1.0, h );
			    
			    h *= 1.0-0.5*(1.0-h)*smoothstep( 0.95+0.05*h, 1.0, sin(3.0*a+iTime) );
				
				float3 bcol = float3(0.9+0.1*q.y, 1.0, 0.9-0.1*q.y);
				bcol *= 1.0 - 0.5*r;
			    float3 col = lerp( bcol, 1.2 * float3(0.65*h, 0.25+0.5*h, 0.0), f );

			    float4 color = float4(col, 1.0);
			    return color;
			}

			ENDCG
		}
	}
}

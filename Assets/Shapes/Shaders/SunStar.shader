Shader "Hidden/Shapes/SunStar"
{
	Properties
	{
		_TextureChannel0 ("Texture", 2D) = "gray" {}
		_TextureChannel1 ("Texture", 2D) = "gray" {}
		_TextureChannel2 ("Texture", 2D) = "gray" {}
		_TextureChannel3 ("Texture", 2D) = "gray" {}


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
                // UNITY_DEFINE_INSTANCED_PROP(sampler2D, _TextureFocus)
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
            
            sampler2D _TextureChannel0;
            sampler2D _TextureChannel1;
            sampler2D _TextureChannel2;
            sampler2D _TextureChannel3;
			

			// #define SHAPE 0
			// #define IMPLEMENTATION 1 
            float segm(float a, float b, float c, float x)
            {
            	return smoothstep(a-c,a,x) - smoothstep(b, b+c, x);
            }

			fixed4 frag (pixel i) : SV_Target
			{
			
			    UNITY_SETUP_INSTANCE_ID(i);
			    
			    float aaSmoothing = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _AASmoothing);
			    fixed4 fillColor = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _FillColor);
			   

				float2 variable = i.uv + 1;
    			
    			float2 coordinateScale = variable.xy/float2(2, 2);
			    
			    float2 coordinate = i.uv;

    			// fixed4 col = tex2D(_TextureChannel0, 0.5 + 0.5 * coordinate);
				

				// float4 col = float4(variable.xy,0,1);
				// float4 col = float4(coordinate,0,1);

				// col = float4(variable,0,1);

				float a = atan2(coordinate.x, coordinate.y);
				float r = length(coordinate);

				float s = 0.2 + 0.5 * sin(a*17.0 + 1.5 * _Time.y);
				float d = 0.5 + 0.2 * pow(s, 1.0);
				float h = r/d;

				float f = 1.0 - smoothstep(0.92, 1.0, h);

				float b = pow(0.5 + 0.5*sin(3.0 * _Time.y), 500.0);

				float2 e = float2(abs(coordinate.x) - 0.15, (coordinate.y - 0.1) * (1.0 + 10.0 * b));
				float g = 1.0 - (segm(0.06, 0.09, 0.01, length(e))) * step(0.0, e.y);

				float t = 0.5 + 0.5 * sin(12.0 * _Time.y);
				float2 m = float2(coordinate.x, (coordinate.y + 0.15) * (1.0 + 10.0 * t));
				g *= 1.0 - (segm(0.06, 0.09, 0.01, length(m)));

				float3 bcol = float3( 0.2 + 0.7 * coordinateScale.y, 0.6 + 0.4 * coordinateScale.y, 1.0);
				bcol *= 0.85 + 0.15 * coordinateScale.x * coordinateScale.y;
				bcol *= 0.5 + 0.5 * pow(16.0 * coordinateScale.x * coordinateScale.y * (1.0 - coordinateScale.x) * (1.0 - coordinateScale.y), 0.25);

				float4 col = float4(lerp(bcol, float3(1.0,0.85,0.0) * g, f), 1.0); 

				return col;
				

			}
			ENDCG
		}
	}
}

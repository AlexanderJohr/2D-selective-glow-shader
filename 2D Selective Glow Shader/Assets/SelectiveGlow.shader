Shader "AlexShaders/SelectiveGlow"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Saturation("saturation", Range(0,1)) = 0.0
		_SelectionColor1("Selection Color 1", Color) = (1,1,1,1)
		_SelectionColor2("Selection Color 2", Color) = (1,1,1,1)

		_GlowColor("Glow Color", Color) = (1,1,1,1)
	}
		SubShader{

			Tags{
			"Queue" = "Transparent"
		}

			CGPROGRAM

			#pragma surface surf Lambert alpha:fade

			sampler2D _MainTex;

float _Saturation;
float4 _GlowColor;

float4 _SelectionColor1;
float4 _SelectionColor2;

			struct Input {
				float2 uv_MainTex;
			};

			void surf(Input IN, inout SurfaceOutput o) {
				fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

				if (c.r > _SelectionColor1.r   && c.r < _SelectionColor2.r &&
					c.g > _SelectionColor1.g   && c.g < _SelectionColor2.g &&
					c.b > _SelectionColor1.b   && c.b < _SelectionColor2.b
					) {
					o.Albedo = c.rgb * (1 - _Saturation) + _GlowColor.rgb * _Saturation;
				}
				else {
					o.Albedo = c.rgb;
				}

				o.Alpha = c.a;
			}
			ENDCG
		}
			FallBack "Diffuse"
}
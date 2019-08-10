Shader "AlexShaders/SelectiveGlowUnlit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

 		_GlowIntensity("Glow Intensity", Range(0,1)) = 0.0

					_Tolerance("Tolerance", Range(0.01,2)) = 0.1

		_SelectionColor("Selection Color", Color) = (1,1,1,1)

		_GlowColor("Glow Color", Color) = (1,1,1,1)

 

		_OriginalColor("Original Color", Color) = (1,1,1,1)


			
    }
    SubShader
    {
	 Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}		Cull Off
 		ZWrite Off
	 Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

			float4 _SelectionColor;

			float4 _GlowColor;

			float4 _OriginalColor;
			
			float _GlowIntensity;
			float _Tolerance;
			float _MaxDist;

			

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
 
                fixed4 c = tex2D(_MainTex, i.uv);
			
				float dist = distance(c.rgba, _SelectionColor.rgba);

				if (dist < _Tolerance) {
					c = (_OriginalColor * (1 - _GlowIntensity) + _GlowColor  * _GlowIntensity) ;
				}

                UNITY_APPLY_FOG(i.fogCoord, c);
                return c;
            }
            ENDCG
        }
    }
}

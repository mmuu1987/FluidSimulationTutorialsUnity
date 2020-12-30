Shader "Unlit/01Learn"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
            float _TexelNumber;
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
                float	_Temprature = 0.0f;
                float	_TexelSize = 1.0f / _TexelNumber;
                if (i.uv.x < _TexelSize)//左边界条件
                  _Temprature = 0.7f;
                else if (i.uv.x >= 1 - _TexelSize)//右边界条件
                 _Temprature = 0.3f;
                else {
                     float2	leftuv = float2(i.uv.x - _TexelSize, i.uv.y);
                     float	leftT = tex2D(_MainTex, leftuv).g;
                     float2	rightuv = float2(i.uv.x + _TexelSize, i.uv.y);
                     float	rightT = tex2D(_MainTex, rightuv).g;
                     _Temprature = (leftT + rightT) / 2.0f;

                }

                return(float4(1.0f, _Temprature, 0.0f, 1.0f));

                //// sample the texture
                //fixed4 col = tex2D(_MainTex, i.uv);
                //// apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                //return col;
            }
            ENDCG
        }
    }
}

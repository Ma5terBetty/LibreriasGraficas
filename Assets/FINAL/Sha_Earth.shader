// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sha_Earth"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_RotationSpeed("Rotation Speed", Range( 0 , 0.5)) = 0
		_Float1("Float 1", Range( 0 , 1)) = 0.57
		_Float3("Float 3", Range( 0 , 10)) = 0.57
		_Float0("Float 0", Float) = 6.82
		_Float2("Float 2", Float) = 6.82
		_Float4("Float 4", Float) = 518.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _Float0;
		uniform float _Float1;
		uniform float _Float2;
		uniform float _Float3;
		uniform sampler2D _TextureSample0;
		uniform float _RotationSpeed;
		uniform float _Float4;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float mulTime18 = _Time.y * _Float1;
			float SinLines39 = sin( ( ( ase_vertex3Pos.y * -_Float0 ) + mulTime18 ) );
			float mulTime48 = _Time.y * _Float3;
			float SinReducedLines51 = sin( ( ( ase_vertex3Pos.y * -_Float2 ) + ( 1.0 - mulTime48 ) ) );
			float4 color25 = IsGammaSpace() ? float4(0.03404236,0.4811321,0.09215384,0) : float4(0.002634858,0.196991,0.008848016,0);
			float2 uv_TexCoord4 = i.uv_texcoord + ( _Time.y * float2( 1,0 ) * _RotationSpeed );
			float temp_output_11_0 = (tex2D( _TextureSample0, uv_TexCoord4 )).r;
			o.Emission = saturate( ( saturate( ( SinLines39 + SinReducedLines51 ) ) * color25 * temp_output_11_0 * _Float4 ) ).rgb;
			float Opacity21 = saturate( ( temp_output_11_0 * ( SinReducedLines51 + SinLines39 ) ) );
			o.Alpha = Opacity21;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;535;1465;464;2592.902;80.91836;1.561765;True;True
Node;AmplifyShaderEditor.RangedFloatNode;44;-3218.452,-473.8197;Inherit;False;Property;_Float3;Float 3;3;0;Create;True;0;0;0;False;0;False;0.57;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-3235.509,-102.203;Inherit;False;Property;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;6.82;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-3225.416,-560.1596;Inherit;False;Property;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;6.82;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;48;-2925.06,-474.8933;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;46;-3130.882,-710.3195;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;16;-3088.286,-104.3214;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-3232.546,-16.86314;Inherit;False;Property;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;0.57;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;12;-3140.975,-252.3629;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;45;-3078.192,-562.278;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;54;-2776.148,-552.1254;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-2889.06,-654.453;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-2899.153,-196.4964;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;18;-2935.153,-16.93673;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;8;-3798.107,563.2382;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;7;-3826.565,489.248;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-2669.253,-655.7614;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-2679.347,-197.8048;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-3830.832,692.7206;Inherit;False;Property;_RotationSpeed;Rotation Speed;1;0;Create;True;0;0;0;False;0;False;0;0.054;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;20;-2541.253,-200.7465;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;50;-2531.159,-658.7031;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-3520.645,567.5068;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-2410.621,-205.5844;Inherit;False;SinLines;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-3280.179,445.1385;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-2400.528,-663.541;Inherit;False;SinReducedLines;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-3055.64,415.6006;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;bfe0b7cbdb6e54a4fb69c7f5b8fbcf81;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;42;-1950.933,776.0964;Inherit;False;39;SinLines;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;-1942.086,696.763;Inherit;False;51;SinReducedLines;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-2048.075,5.670547;Inherit;False;51;SinReducedLines;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-2006.947,-74.13841;Inherit;False;39;SinLines;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;11;-2703.195,509.0282;Inherit;True;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-1748.443,736.3603;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-1676.195,-70.1917;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1493.472,657.0624;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;25;-2047.839,85.6506;Inherit;False;Constant;_Color0;Color 0;4;0;Create;True;0;0;0;False;0;False;0.03404236,0.4811321,0.09215384,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;65;-1671.461,284.5346;Inherit;False;Property;_Float4;Float 4;6;0;Create;True;0;0;0;False;0;False;518.1;6.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;59;-1554.195,-63.1917;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;38;-1256.693,654.0795;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1410.901,36.44878;Inherit;True;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-967.5991,630.5336;Inherit;True;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;31;-977.3234,74.8782;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-219.3464,245.5889;Inherit;False;21;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Sha_Earth;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;48;0;44;0
WireConnection;16;0;14;0
WireConnection;45;0;43;0
WireConnection;54;0;48;0
WireConnection;47;0;46;2
WireConnection;47;1;45;0
WireConnection;13;0;12;2
WireConnection;13;1;16;0
WireConnection;18;0;19;0
WireConnection;49;0;47;0
WireConnection;49;1;54;0
WireConnection;17;0;13;0
WireConnection;17;1;18;0
WireConnection;20;0;17;0
WireConnection;50;0;49;0
WireConnection;9;0;7;0
WireConnection;9;1;8;0
WireConnection;9;2;10;0
WireConnection;39;0;20;0
WireConnection;4;1;9;0
WireConnection;51;0;50;0
WireConnection;2;1;4;0
WireConnection;11;0;2;0
WireConnection;60;0;52;0
WireConnection;60;1;42;0
WireConnection;58;0;40;0
WireConnection;58;1;55;0
WireConnection;37;0;11;0
WireConnection;37;1;60;0
WireConnection;59;0;58;0
WireConnection;38;0;37;0
WireConnection;24;0;59;0
WireConnection;24;1;25;0
WireConnection;24;2;11;0
WireConnection;24;3;65;0
WireConnection;21;0;38;0
WireConnection;31;0;24;0
WireConnection;0;2;31;0
WireConnection;0;9;23;0
ASEEND*/
//CHKSM=DCE7459A982A315C2E1E273AFB6B5037C2199A47
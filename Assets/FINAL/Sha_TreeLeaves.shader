// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sha_TreeLeaves"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_MainTex1("Branches Texture", 2D) = "white" {}
		_LeavesColor("Leaves Color", Color) = (1,1,1,0)
		_SwingFrequency("Swing Frequency", Range( 0 , 20)) = 0
		_SwingSpeed("Swing Speed", Range( 0 , 0.5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TreeTransparentCutout"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _SwingFrequency;
		uniform float _SwingSpeed;
		uniform float4 _LeavesColor;
		uniform sampler2D _MainTex1;
		uniform float4 _MainTex1_ST;
		uniform float _Cutoff = 0.5;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult9 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 panner13 = ( _Time.y * float2( 0.1,0.1 ) + appendResult9);
			float simplePerlin2D12 = snoise( panner13*_SwingFrequency );
			simplePerlin2D12 = simplePerlin2D12*0.5 + 0.5;
			float VertexOffset17 = ( simplePerlin2D12 * ( _SwingSpeed / 4.0 ) );
			float3 temp_cast_0 = (VertexOffset17).xxx;
			v.vertex.xyz += temp_cast_0;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_MainTex1 = i.uv_texcoord * _MainTex1_ST.xy + _MainTex1_ST.zw;
			float4 tex2DNode2 = tex2D( _MainTex1, uv_MainTex1 );
			o.Albedo = ( _LeavesColor * tex2DNode2 ).rgb;
			float temp_output_4_0 = 0.0;
			float3 temp_cast_1 = (temp_output_4_0).xxx;
			o.Specular = temp_cast_1;
			o.Smoothness = temp_output_4_0;
			o.Alpha = 1;
			clip( tex2DNode2.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;535;1465;464;895.9836;-66.96803;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;25;-1602.872,934.9279;Inherit;False;1259.344;429.2836;Leaves Movement;10;6;9;14;13;23;19;12;24;22;17;Vertex Offset;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;6;-1552.872,993.7362;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;14;-1332.869,1086.547;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-1339.702,988.5569;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;13;-1142.235,990.45;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1233.444,1248.212;Inherit;False;Property;_SwingSpeed;Swing Speed;4;0;Create;True;0;0;0;False;0;False;0;0.2760774;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1232.906,1167.121;Inherit;False;Property;_SwingFrequency;Swing Frequency;3;0;Create;True;0;0;0;False;0;False;0;4.093075;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;24;-855.4437,1087.212;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;12;-917.6467,984.9279;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-710.4437,989.2113;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-436.7571,-107.5414;Float;False;Property;_LeavesColor;Leaves Color;2;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.6026406,0.8018868,0.3971609,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-567.5273,985.3122;Inherit;False;VertexOffset;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-519.7571,75.45862;Inherit;True;Property;_MainTex1;Branches Texture;1;0;Create;False;0;0;0;False;0;False;-1;None;1d49d1e2d8a2b97478e3e0355dbf3a07;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-183.7571,-0.5413818;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-219.5322,314.4593;Inherit;False;17;VertexOffset;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-185.7571,104.4586;Float;False;Constant;_Float1;Float 1;0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Sha_TreeLeaves;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;TreeTransparentCutout;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;6;1
WireConnection;9;1;6;3
WireConnection;13;0;9;0
WireConnection;13;1;14;0
WireConnection;24;0;23;0
WireConnection;12;0;13;0
WireConnection;12;1;19;0
WireConnection;22;0;12;0
WireConnection;22;1;24;0
WireConnection;17;0;22;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;0;0;3;0
WireConnection;0;3;4;0
WireConnection;0;4;4;0
WireConnection;0;10;2;4
WireConnection;0;11;18;0
ASEEND*/
//CHKSM=895C7F2BC8D7E5D431BEAA549629DCCDF9D9F8AA
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sha_Grass"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		[Header(Player Position)]_PlayerPos("PlayerPos", Vector) = (0,0,0,0)
		[Header(Waves Properties)]_Wave1Direction("Wave 1 Direction", Vector) = (0,0,0,0)
		_Wave2Direction("Wave 2 Direction", Vector) = (0,0,0,0)
		_WaveLenght("WaveLenght", Float) = 0
		_Speed("Speed", Float) = 0
		_Range("Range", Range( 0 , 1)) = 2
		_GrassColor("Grass Color", Color) = (0,0,0,0)
		_Vector0("Vector 0", Vector) = (0,10,0,0)
		_GrassColorIntensity("Grass Color Intensity", Float) = 1
		_Aplitude("Aplitude", Float) = 0
		_WavesAmount("Waves Amount", Float) = 0
		_Steepness("Steepness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float3 _PlayerPos;
		uniform float _Range;
		uniform float3 _Wave1Direction;
		uniform float _WaveLenght;
		uniform float _Speed;
		uniform float _Aplitude;
		uniform float _Steepness;
		uniform float _WavesAmount;
		uniform float3 _Wave2Direction;
		uniform float3 _Vector0;
		uniform float4 _GrassColor;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _GrassColorIntensity;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 temp_output_3_0_g44 = _Wave1Direction;
			float dotResult12_g45 = dot( temp_output_3_0_g44 , ase_worldPos );
			float temp_output_3_0_g45 = _WaveLenght;
			float temp_output_7_0_g45 = sqrt( ( 9.8 * ( 6.28318548202515 / temp_output_3_0_g45 ) ) );
			float temp_output_20_0_g44 = ( ( dotResult12_g45 * temp_output_7_0_g45 ) + ( _Speed * ( 2.0 / temp_output_3_0_g45 ) * _Time.y ) );
			float temp_output_7_0_g44 = cos( temp_output_20_0_g44 );
			float3 break10_g44 = temp_output_3_0_g44;
			float temp_output_9_0_g44 = _Aplitude;
			float temp_output_19_0_g44 = ( temp_output_9_0_g44 * ( _Steepness / ( temp_output_7_0_g45 * temp_output_9_0_g44 * _WavesAmount ) ) );
			float3 appendResult2_g44 = (float3(( temp_output_7_0_g44 * break10_g44.x * temp_output_19_0_g44 ) , ( sin( temp_output_20_0_g44 ) * temp_output_9_0_g44 ) , ( temp_output_7_0_g44 * break10_g44.z * temp_output_19_0_g44 )));
			float3 temp_output_3_0_g42 = _Wave2Direction;
			float dotResult12_g43 = dot( temp_output_3_0_g42 , ase_worldPos );
			float temp_output_3_0_g43 = _WaveLenght;
			float temp_output_7_0_g43 = sqrt( ( 9.8 * ( 6.28318548202515 / temp_output_3_0_g43 ) ) );
			float temp_output_20_0_g42 = ( ( dotResult12_g43 * temp_output_7_0_g43 ) + ( _Speed * ( 2.0 / temp_output_3_0_g43 ) * _Time.y ) );
			float temp_output_7_0_g42 = cos( temp_output_20_0_g42 );
			float3 break10_g42 = temp_output_3_0_g42;
			float temp_output_9_0_g42 = _Aplitude;
			float temp_output_19_0_g42 = ( temp_output_9_0_g42 * ( _Steepness / ( temp_output_7_0_g43 * temp_output_9_0_g42 * _WavesAmount ) ) );
			float3 appendResult2_g42 = (float3(( temp_output_7_0_g42 * break10_g42.x * temp_output_19_0_g42 ) , ( sin( temp_output_20_0_g42 ) * temp_output_9_0_g42 ) , ( temp_output_7_0_g42 * break10_g42.z * temp_output_19_0_g42 )));
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 GerstnerMasked26 = ( saturate( ( appendResult2_g44 + appendResult2_g42 ) ) * ase_vertex3Pos.y );
			float3 ifLocalVar23 = 0;
			if( distance( _PlayerPos , ase_worldPos ) > _Range )
				ifLocalVar23 = GerstnerMasked26;
			else if( distance( _PlayerPos , ase_worldPos ) < _Range )
				ifLocalVar23 = ( GerstnerMasked26 - _Vector0 );
			v.vertex.xyz += ifLocalVar23;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode1 = tex2D( _TextureSample0, uv_TextureSample0 );
			o.Albedo = saturate( ( _GrassColor * ( ( tex2DNode1.r + tex2DNode1.g + tex2DNode1.b ) / 3.0 ) * _GrassColorIntensity ) ).rgb;
			o.Smoothness = 0.0;
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			o.Alpha = tex2D( _TextureSample1, uv_TextureSample1 ).a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows noshadow vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
653;477;722;534;1289.409;-169.722;2.224414;True;False
Node;AmplifyShaderEditor.RangedFloatNode;28;-2437.839,94.6751;Inherit;False;Property;_Steepness;Steepness;18;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2336.838,-206.3252;Inherit;False;Property;_WaveLenght;WaveLenght;10;0;Create;True;0;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;27;-2338.646,-527.3331;Inherit;False;Property;_Wave1Direction;Wave 1 Direction;8;1;[Header];Create;True;1;Waves Properties;0;0;False;0;False;0,0,0;1,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;31;-2308.838,-132.3253;Inherit;False;Property;_Speed;Speed;11;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2356.838,17.67519;Inherit;False;Property;_WavesAmount;Waves Amount;17;0;Create;True;0;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;29;-2339.84,-369.3081;Inherit;False;Property;_Wave2Direction;Wave 2 Direction;9;0;Create;True;0;0;0;False;0;False;0,0,0;-1,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;32;-2329.022,-57.45639;Inherit;False;Property;_Aplitude;Aplitude;16;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;34;-2044.097,-334.3817;Inherit;False;Gerstner;-1;;42;07c54fb8a509f764baf97a0ed50f1bd2;0;6;16;FLOAT;1;False;17;FLOAT;0;False;3;FLOAT3;1,0,0;False;4;FLOAT;10;False;5;FLOAT;1;False;9;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;35;-2042.161,-520.5322;Inherit;False;Gerstner;-1;;44;07c54fb8a509f764baf97a0ed50f1bd2;0;6;16;FLOAT;1;False;17;FLOAT;0;False;3;FLOAT3;1,0,0;False;4;FLOAT;10;False;5;FLOAT;1;False;9;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1696.328,-520.5538;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;37;-1579.442,-520.2341;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;38;-1694.522,-422.8211;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1442.167,-519.9208;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1;-1352.722,-97.78923;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;None;4e364662e65fd2d4a995a4efe45af277;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-1315.45,-523.3469;Inherit;False;GerstnerMasked;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;13;-1245.422,422.5542;Inherit;False;1019.283;537.4576;Affecting only on Y axis;9;62;23;17;16;15;24;40;41;53;Trodden Grass;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-1064.682,-68.34335;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;62;-881.8713,777.8988;Inherit;False;Property;_Vector0;Vector 0;14;0;Create;True;0;0;0;False;0;False;0,10,0;0,5,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;64;-1031.93,-239.6072;Inherit;False;Property;_GrassColor;Grass Color;13;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,1,0.3541882,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;68;-951.6821,-71.34335;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-923.7881,694.1418;Inherit;False;26;GerstnerMasked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-1047.227,58.87903;Inherit;False;Property;_GrassColorIntensity;Grass Color Intensity;15;0;Create;True;0;0;0;False;0;False;1;2.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;16;-1160.402,620.7906;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;15;-1203.011,468.6783;Inherit;False;Property;_PlayerPos;PlayerPos;7;1;[Header];Create;True;1;Player Position;0;0;False;0;False;0,0,0;-1.496,-0.73,4.771;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;17;-977.4322,473.5453;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-795.1727,539.1486;Inherit;False;Property;_Range;Range;12;0;Create;True;0;0;0;False;0;False;2;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;40;-691.0389,700.1349;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-756.2213,614.7076;Inherit;False;26;GerstnerMasked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-770.5326,-161.302;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-154.5494,78.05225;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;23;-450.1353,467.5519;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;67;-216.7958,-63.86231;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-324.6031,175.8856;Inherit;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;0;False;0;False;-1;None;4e364662e65fd2d4a995a4efe45af277;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;12;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Sha_Grass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;34;16;33;0
WireConnection;34;17;28;0
WireConnection;34;3;29;0
WireConnection;34;4;30;0
WireConnection;34;5;31;0
WireConnection;34;9;32;0
WireConnection;35;16;33;0
WireConnection;35;17;28;0
WireConnection;35;3;27;0
WireConnection;35;4;30;0
WireConnection;35;5;31;0
WireConnection;35;9;32;0
WireConnection;36;0;35;0
WireConnection;36;1;34;0
WireConnection;37;0;36;0
WireConnection;39;0;37;0
WireConnection;39;1;38;2
WireConnection;26;0;39;0
WireConnection;72;0;1;1
WireConnection;72;1;1;2
WireConnection;72;2;1;3
WireConnection;68;0;72;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;40;0;53;0
WireConnection;40;1;62;0
WireConnection;65;0;64;0
WireConnection;65;1;68;0
WireConnection;65;2;73;0
WireConnection;23;0;17;0
WireConnection;23;1;24;0
WireConnection;23;2;41;0
WireConnection;23;4;40;0
WireConnection;67;0;65;0
WireConnection;12;0;67;0
WireConnection;12;4;5;0
WireConnection;12;9;4;4
WireConnection;12;11;23;0
ASEEND*/
//CHKSM=69EA95EF595268DB028022141343E85F807AA5C2
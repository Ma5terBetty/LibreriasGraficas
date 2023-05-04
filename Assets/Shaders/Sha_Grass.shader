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
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
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
			float temp_output_17_0 = distance( _PlayerPos , ase_worldPos );
			float Distance14 = temp_output_17_0;
			float3 temp_output_3_0_g28 = _Wave1Direction;
			float dotResult12_g29 = dot( temp_output_3_0_g28 , ase_worldPos );
			float temp_output_3_0_g29 = _WaveLenght;
			float temp_output_7_0_g29 = sqrt( ( 9.8 * ( 6.28318548202515 / temp_output_3_0_g29 ) ) );
			float temp_output_20_0_g28 = ( ( dotResult12_g29 * temp_output_7_0_g29 ) + ( _Speed * ( 2.0 / temp_output_3_0_g29 ) * _Time.y ) );
			float temp_output_7_0_g28 = cos( temp_output_20_0_g28 );
			float3 break10_g28 = temp_output_3_0_g28;
			float temp_output_9_0_g28 = _Aplitude;
			float temp_output_19_0_g28 = ( temp_output_9_0_g28 * ( _Steepness / ( temp_output_7_0_g29 * temp_output_9_0_g28 * _WavesAmount ) ) );
			float3 appendResult2_g28 = (float3(( temp_output_7_0_g28 * break10_g28.x * temp_output_19_0_g28 ) , ( sin( temp_output_20_0_g28 ) * temp_output_9_0_g28 ) , ( temp_output_7_0_g28 * break10_g28.z * temp_output_19_0_g28 )));
			float3 temp_output_3_0_g26 = _Wave2Direction;
			float dotResult12_g27 = dot( temp_output_3_0_g26 , ase_worldPos );
			float temp_output_3_0_g27 = _WaveLenght;
			float temp_output_7_0_g27 = sqrt( ( 9.8 * ( 6.28318548202515 / temp_output_3_0_g27 ) ) );
			float temp_output_20_0_g26 = ( ( dotResult12_g27 * temp_output_7_0_g27 ) + ( _Speed * ( 2.0 / temp_output_3_0_g27 ) * _Time.y ) );
			float temp_output_7_0_g26 = cos( temp_output_20_0_g26 );
			float3 break10_g26 = temp_output_3_0_g26;
			float temp_output_9_0_g26 = _Aplitude;
			float temp_output_19_0_g26 = ( temp_output_9_0_g26 * ( _Steepness / ( temp_output_7_0_g27 * temp_output_9_0_g26 * _WavesAmount ) ) );
			float3 appendResult2_g26 = (float3(( temp_output_7_0_g26 * break10_g26.x * temp_output_19_0_g26 ) , ( sin( temp_output_20_0_g26 ) * temp_output_9_0_g26 ) , ( temp_output_7_0_g26 * break10_g26.z * temp_output_19_0_g26 )));
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 GerstnerMasked26 = ( saturate( ( appendResult2_g28 + appendResult2_g26 ) ) * ase_vertex3Pos.y );
			float3 appendResult20 = (float3(0.0 , ( ( 1.0 - temp_output_17_0 ) * 1.2 ) , 0.0));
			float3 ifLocalVar23 = 0;
			if( Distance14 > _Range )
				ifLocalVar23 = GerstnerMasked26;
			else if( Distance14 < _Range )
				ifLocalVar23 = ( GerstnerMasked26 - ( ase_vertex3Pos.y * appendResult20 ) );
			v.vertex.xyz += ( ifLocalVar23 * float3(0,5,0) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			o.Albedo = tex2D( _TextureSample0, uv_TextureSample0 ).rgb;
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
0;531;1465;460;946.5835;-398.4049;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;30;-2336.838,-206.3252;Inherit;False;Property;_WaveLenght;WaveLenght;10;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;13;-1832.233,422.5542;Inherit;False;1601.645;735.9476;Affecting only on Y axis;16;14;15;16;17;18;19;20;21;22;23;24;25;40;41;53;62;Trodden Grass;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2308.838,-132.3253;Inherit;False;Property;_Speed;Speed;11;0;Create;True;0;0;0;False;0;False;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2329.022,-57.45639;Inherit;False;Property;_Aplitude;Aplitude;13;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;29;-2339.84,-369.3081;Inherit;False;Property;_Wave2Direction;Wave 2 Direction;9;0;Create;True;0;0;0;False;0;False;0,0,0;-1,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;33;-2356.838,17.67519;Inherit;False;Property;_WavesAmount;Waves Amount;14;0;Create;True;0;0;0;False;0;False;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-2437.839,94.6751;Inherit;False;Property;_Steepness;Steepness;15;0;Create;True;0;0;0;False;0;False;0;0.774;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;27;-2338.646,-527.3331;Inherit;False;Property;_Wave1Direction;Wave 1 Direction;8;1;[Header];Create;True;1;Waves Properties;0;0;False;0;False;0,0,0;1,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;15;-1807.313,840.4646;Inherit;False;Property;_PlayerPos;PlayerPos;7;1;[Header];Create;True;1;Player Position;0;0;False;0;False;0,0,0;-2.42,-0.37,2.68;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;16;-1803.39,983.5276;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;35;-2042.161,-520.5322;Inherit;False;Gerstner;-1;;28;07c54fb8a509f764baf97a0ed50f1bd2;0;6;16;FLOAT;1;False;17;FLOAT;0;False;3;FLOAT3;1,0,0;False;4;FLOAT;10;False;5;FLOAT;1;False;9;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;34;-2044.097,-334.3817;Inherit;False;Gerstner;-1;;26;07c54fb8a509f764baf97a0ed50f1bd2;0;6;16;FLOAT;1;False;17;FLOAT;0;False;3;FLOAT3;1,0,0;False;4;FLOAT;10;False;5;FLOAT;1;False;9;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1696.328,-520.5538;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DistanceOpNode;17;-1581.734,845.3316;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;37;-1579.442,-520.2341;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;18;-1395.6,845.9495;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;38;-1694.522,-422.8211;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1442.167,-519.9208;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1203.617,846.9746;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-1037.422,820.9466;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-1315.45,-523.3469;Inherit;False;GerstnerMasked;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;21;-1093.859,684.5876;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-1394.518,727.7082;Inherit;False;Distance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-923.7881,694.1418;Inherit;False;26;GerstnerMasked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-889.6644,759.4453;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-756.2213,614.7076;Inherit;False;26;GerstnerMasked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-795.1727,539.1486;Inherit;False;Property;_Range;Range;12;0;Create;True;0;0;0;False;0;False;2;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;40;-714.8784,699.1306;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-677.0557,466.4917;Inherit;False;14;Distance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;23;-454.6665,481.0786;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;62;-427.3949,654.9399;Inherit;False;Constant;_Vector0;Vector 0;13;0;Create;True;0;0;0;False;0;False;0,5,0;0,4.91,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-172.1949,481.3399;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1;-522.1286,-75.96614;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;None;4e364662e65fd2d4a995a4efe45af277;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-324.6031,175.8856;Inherit;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;0;False;0;False;-1;None;4e364662e65fd2d4a995a4efe45af277;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-154.5494,78.05225;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;12;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Sha_Grass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;35;16;33;0
WireConnection;35;17;28;0
WireConnection;35;3;27;0
WireConnection;35;4;30;0
WireConnection;35;5;31;0
WireConnection;35;9;32;0
WireConnection;34;16;33;0
WireConnection;34;17;28;0
WireConnection;34;3;29;0
WireConnection;34;4;30;0
WireConnection;34;5;31;0
WireConnection;34;9;32;0
WireConnection;36;0;35;0
WireConnection;36;1;34;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;37;0;36;0
WireConnection;18;0;17;0
WireConnection;39;0;37;0
WireConnection;39;1;38;2
WireConnection;19;0;18;0
WireConnection;20;1;19;0
WireConnection;26;0;39;0
WireConnection;14;0;17;0
WireConnection;22;0;21;2
WireConnection;22;1;20;0
WireConnection;40;0;53;0
WireConnection;40;1;22;0
WireConnection;23;0;25;0
WireConnection;23;1;24;0
WireConnection;23;2;41;0
WireConnection;23;4;40;0
WireConnection;58;0;23;0
WireConnection;58;1;62;0
WireConnection;12;0;1;0
WireConnection;12;4;5;0
WireConnection;12;9;4;4
WireConnection;12;11;58;0
ASEEND*/
//CHKSM=07EBB2DAF1D0C95D26FD5CECBFA4DEA8B5A43D5E
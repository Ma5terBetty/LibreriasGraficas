// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sha_Ocean"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 6.9
		[Header(Waves Direction)]_DirectionA("Direction A", Vector) = (0,0,0,0)
		_DirectionB("Direction B", Vector) = (0,0,0,0)
		_DirectionC("Direction C", Vector) = (0,0,0,0)
		_DirectionD("Direction D", Vector) = (0,0,0,0)
		_WaterColor("Water Color", Color) = (0.4380563,0.6561054,0.8679245,0)
		[Header(Waves Properties)]_WavesThickness("Waves Thickness", Range( 1 , 8)) = 0
		_WaveLenght("Wave Lenght", Range( 0.1 , 50)) = 1
		_Steepness("Steepness", Range( 0 , 0.4)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 1.31
		_Speed("Speed", Float) = 1
		_Amplitude("Amplitude", Float) = 0.5
		[Header(Foam Properties)]_FoamScale("Foam Scale", Float) = 0
		_FoamMaskScale("Foam Mask Scale", Range( 1 , 10)) = 0
		_FoamHeight("Foam Height", Range( 0 , 10)) = 1
		_FoamIntensity("Foam Intensity", Range( 0.01 , 20)) = 0
		_CrestOpacity("Crest Opacity", Range( 0 , 1)) = 0
		_DepthDistance("Depth Distance", Range( 1 , 5)) = 0
		_CoastSmoothness("Coast Smoothness", Range( 1 , 10)) = 0
		[Header(Normals Properties)]_NormalsSpeed("Normals Speed", Vector) = (0,0,0,0)
		_NormalsA("Normals A", 2D) = "white" {}
		_NormalsB("Normals B", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard alpha:fade keepalpha noshadow exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float3 _DirectionA;
		uniform float _WaveLenght;
		uniform float _Speed;
		uniform float _Amplitude;
		uniform float _Steepness;
		uniform float _WavesThickness;
		uniform float3 _DirectionB;
		uniform float3 _DirectionC;
		uniform float3 _DirectionD;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _CoastSmoothness;
		uniform sampler2D _NormalsA;
		uniform float2 _NormalsSpeed;
		uniform sampler2D _NormalsB;
		uniform float4 _WaterColor;
		uniform float _FoamIntensity;
		uniform float _FoamScale;
		uniform float _FoamMaskScale;
		uniform float _FoamHeight;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _CrestOpacity;
		uniform float _DepthDistance;
		uniform float _EdgeLength;


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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 temp_output_3_0_g53 = _DirectionA;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float dotResult12_g54 = dot( temp_output_3_0_g53 , ase_worldPos );
			float temp_output_3_0_g54 = _WaveLenght;
			float temp_output_7_0_g54 = sqrt( ( 9.8 * ( 6.28318548202515 / temp_output_3_0_g54 ) ) );
			float temp_output_20_0_g53 = ( ( dotResult12_g54 * temp_output_7_0_g54 ) + ( _Speed * ( 2.0 / temp_output_3_0_g54 ) * _Time.y ) );
			float temp_output_7_0_g53 = cos( temp_output_20_0_g53 );
			float3 break10_g53 = temp_output_3_0_g53;
			float temp_output_9_0_g53 = _Amplitude;
			float temp_output_19_0_g53 = ( temp_output_9_0_g53 * ( _Steepness / ( temp_output_7_0_g54 * temp_output_9_0_g53 * _WavesThickness ) ) );
			float3 appendResult2_g53 = (float3(( temp_output_7_0_g53 * break10_g53.x * temp_output_19_0_g53 ) , ( sin( temp_output_20_0_g53 ) * temp_output_9_0_g53 ) , ( temp_output_7_0_g53 * break10_g53.z * temp_output_19_0_g53 )));
			float3 temp_output_3_0_g55 = _DirectionB;
			float dotResult12_g56 = dot( temp_output_3_0_g55 , ase_worldPos );
			float temp_output_3_0_g56 = _WaveLenght;
			float temp_output_7_0_g56 = sqrt( ( 9.8 * ( 6.28318548202515 / temp_output_3_0_g56 ) ) );
			float temp_output_20_0_g55 = ( ( dotResult12_g56 * temp_output_7_0_g56 ) + ( _Speed * ( 2.0 / temp_output_3_0_g56 ) * _Time.y ) );
			float temp_output_7_0_g55 = cos( temp_output_20_0_g55 );
			float3 break10_g55 = temp_output_3_0_g55;
			float temp_output_9_0_g55 = _Amplitude;
			float temp_output_19_0_g55 = ( temp_output_9_0_g55 * ( _Steepness / ( temp_output_7_0_g56 * temp_output_9_0_g55 * _WavesThickness ) ) );
			float3 appendResult2_g55 = (float3(( temp_output_7_0_g55 * break10_g55.x * temp_output_19_0_g55 ) , ( sin( temp_output_20_0_g55 ) * temp_output_9_0_g55 ) , ( temp_output_7_0_g55 * break10_g55.z * temp_output_19_0_g55 )));
			float3 temp_output_3_0_g59 = _DirectionC;
			float dotResult12_g60 = dot( temp_output_3_0_g59 , ase_worldPos );
			float temp_output_30_0 = ( _WavesThickness * 2.0 );
			float temp_output_3_0_g60 = temp_output_30_0;
			float temp_output_7_0_g60 = sqrt( ( 9.8 * ( 6.28318548202515 / temp_output_3_0_g60 ) ) );
			float temp_output_31_0 = ( _Speed * 2.0 );
			float temp_output_20_0_g59 = ( ( dotResult12_g60 * temp_output_7_0_g60 ) + ( temp_output_31_0 * ( 2.0 / temp_output_3_0_g60 ) * _Time.y ) );
			float temp_output_7_0_g59 = cos( temp_output_20_0_g59 );
			float3 break10_g59 = temp_output_3_0_g59;
			float temp_output_45_0 = ( _Amplitude / 2.0 );
			float temp_output_9_0_g59 = temp_output_45_0;
			float temp_output_19_0_g59 = ( temp_output_9_0_g59 * ( _Steepness / ( temp_output_7_0_g60 * temp_output_9_0_g59 * _WavesThickness ) ) );
			float3 appendResult2_g59 = (float3(( temp_output_7_0_g59 * break10_g59.x * temp_output_19_0_g59 ) , ( sin( temp_output_20_0_g59 ) * temp_output_9_0_g59 ) , ( temp_output_7_0_g59 * break10_g59.z * temp_output_19_0_g59 )));
			float3 temp_output_3_0_g57 = _DirectionD;
			float dotResult12_g58 = dot( temp_output_3_0_g57 , ase_worldPos );
			float temp_output_3_0_g58 = temp_output_30_0;
			float temp_output_7_0_g58 = sqrt( ( 9.8 * ( 6.28318548202515 / temp_output_3_0_g58 ) ) );
			float temp_output_20_0_g57 = ( ( dotResult12_g58 * temp_output_7_0_g58 ) + ( temp_output_31_0 * ( 2.0 / temp_output_3_0_g58 ) * _Time.y ) );
			float temp_output_7_0_g57 = cos( temp_output_20_0_g57 );
			float3 break10_g57 = temp_output_3_0_g57;
			float temp_output_9_0_g57 = temp_output_45_0;
			float temp_output_19_0_g57 = ( temp_output_9_0_g57 * ( _Steepness / ( temp_output_7_0_g58 * temp_output_9_0_g57 * _WavesThickness ) ) );
			float3 appendResult2_g57 = (float3(( temp_output_7_0_g57 * break10_g57.x * temp_output_19_0_g57 ) , ( sin( temp_output_20_0_g57 ) * temp_output_9_0_g57 ) , ( temp_output_7_0_g57 * break10_g57.z * temp_output_19_0_g57 )));
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth200 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_LOD( _CameraDepthTexture, float4( ase_screenPosNorm.xy, 0, 0 ) ));
			float distanceDepth200 = abs( ( screenDepth200 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _CoastSmoothness ) );
			float3 Gerstner24 = ( ( appendResult2_g53 + appendResult2_g55 + appendResult2_g59 + appendResult2_g57 ) * saturate( distanceDepth200 ) );
			v.vertex.xyz += Gerstner24;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_output_125_0 = ( _Time.y * _NormalsSpeed );
			float2 uv_TexCoord120 = i.uv_texcoord * ( float2( 1,1 ) * -2.0 ) + temp_output_125_0;
			float2 uv_TexCoord138 = i.uv_texcoord * ( ( 1.0 - -2.0 ) * float2( 1,1 ) ) + ( temp_output_125_0 * _NormalsSpeed );
			float4 Normals132 = saturate( ( tex2D( _NormalsA, uv_TexCoord120 ) * tex2D( _NormalsB, uv_TexCoord138 ) ) );
			o.Normal = Normals132.rgb;
			float4 color111 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float3 ase_worldPos = i.worldPos;
			float2 temp_output_67_0 = (ase_worldPos).xz;
			float temp_output_90_0 = ( _Time.y / 1.0 );
			float simplePerlin2D66 = snoise( (temp_output_67_0*1.0 + ( float3(0,-0.5,0) * temp_output_90_0 ).xy)*_FoamScale );
			simplePerlin2D66 = simplePerlin2D66*0.5 + 0.5;
			float simplePerlin2D71 = snoise( (temp_output_67_0*1.0 + ( float3(0,0.5,0) * temp_output_90_0 ).xy)*_FoamMaskScale );
			simplePerlin2D71 = simplePerlin2D71*0.5 + 0.5;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 lerpResult62 = lerp( _WaterColor , color111 , ( 1.0 - step( ( ( _FoamIntensity * simplePerlin2D66 * simplePerlin2D71 ) * ase_vertex3Pos.y ) , _FoamHeight ) ));
			float4 Albedo107 = lerpResult62;
			o.Albedo = Albedo107.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth175 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth175 = abs( ( screenDepth175 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthDistance ) );
			float Opacity168 = ( ( 1.0 - ( saturate( ase_vertex3Pos.y ) * _CrestOpacity ) ) * saturate( distanceDepth175 ) );
			o.Alpha = Opacity168;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;535;1465;464;2343.956;-61.92368;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;147;-3368.412,-1192.477;Inherit;False;2600.954;818.9703;Ocean and Foam Colors;25;107;62;64;111;110;65;73;146;66;71;104;72;69;95;96;67;103;88;102;70;90;78;160;161;162;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;78;-3318.412,-979.0435;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;90;-3154.885,-978.7241;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;102;-3033.585,-769.2706;Inherit;False;Constant;_Vector1;Vector 1;12;0;Create;True;0;0;0;False;0;False;0,0.5,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;70;-3200.955,-856.3846;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;88;-3192.864,-1131.533;Inherit;False;Constant;_Vector0;Vector 0;12;0;Create;True;0;0;0;False;0;False;0,-0.5,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-2847.032,-999.2225;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;148;-1270.34,-104.4975;Inherit;False;1601.566;573.019;Normal Map;17;132;151;141;117;139;120;138;140;164;166;125;121;136;165;163;126;130;Normals;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-2804.188,-763.7416;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;67;-2896.308,-857.762;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;163;-1256.623,87.55468;Inherit;False;Constant;_NormalsScale;Normals Scale;21;0;Create;True;0;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-2771.888,-641.7078;Inherit;False;Property;_FoamMaskScale;Foam Mask Scale;18;0;Create;True;0;0;0;False;0;False;0;10;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;95;-2672.791,-1044.969;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;130;-1243.251,193.2477;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;126;-1251.277,316.6327;Inherit;False;Property;_NormalsSpeed;Normals Speed;24;1;[Header];Create;True;1;Normals Properties;0;0;False;0;False;0,0;0,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScaleAndOffsetNode;104;-2655.08,-810.4492;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-2647.788,-923.023;Inherit;False;Property;_FoamScale;Foam Scale;17;1;[Header];Create;True;1;Foam Properties;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;121;-1259.804,-56.44841;Inherit;False;Constant;_TilingNormals;Tiling Normals;16;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;179;-3348.076,-94.92345;Inherit;False;1225.388;411.4221;Apliying on Borders and Crests;10;170;174;171;177;175;173;172;176;178;168;Opacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;136;-838.3564,171.6587;Inherit;False;Constant;_Tiling;Tiling;15;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;165;-841.6703,97.57775;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;54;-3363.301,567.1472;Inherit;False;2272.892;965.2883;Gerstner Effect by Nvidia Documentation;22;24;199;202;25;53;50;52;51;200;15;46;47;45;203;49;31;14;48;30;16;13;17;Gerstner Effect;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;71;-2456.146,-814.5765;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-2444.827,-1142.477;Inherit;False;Property;_FoamIntensity;Foam Intensity;20;0;Create;True;0;0;0;False;0;False;0;17.5;0.01;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;66;-2450.289,-1050.375;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;-1027.365,192.2637;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-2137.351,-1135.493;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-2894.381,865.9502;Inherit;False;Property;_Speed;Speed;15;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-834.9764,299.4057;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-3034.707,617.1472;Inherit;False;Property;_WavesThickness;Waves Thickness;10;1;[Header];Create;True;1;Waves Properties;0;0;False;0;False;0;8;1;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;170;-3298.076,-44.92339;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-2902.381,945.9502;Inherit;False;Property;_Amplitude;Amplitude;16;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;-1025.224,-46.84537;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;166;-681.4271,171.9688;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;65;-2131.467,-982.564;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;162;-1900.098,-1021.004;Inherit;False;Property;_FoamHeight;Foam Height;19;0;Create;True;0;0;0;False;0;False;1;1.24;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;203;-2020.244,1221.931;Inherit;False;Property;_CoastSmoothness;Coast Smoothness;23;0;Create;True;0;0;0;False;0;False;0;7.6;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;171;-2985.344,-1.384995;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;48;-3310.619,964.1703;Inherit;False;Property;_DirectionC;Direction C;7;0;Create;True;0;0;0;False;0;False;0,0,0;0.05,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;14;-3041.007,700.447;Inherit;False;Property;_Steepness;Steepness;12;0;Create;True;0;0;0;False;0;False;0;0.338;0;0.4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-3273.641,183.499;Inherit;False;Property;_DepthDistance;Depth Distance;22;0;Create;True;0;0;0;False;0;False;0;1;1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-2549.806,1193.951;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2556.942,1085.098;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;120;-822.9254,-26.76138;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-1908.83,-1134.875;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2923.381,792.9503;Inherit;False;Property;_WaveLenght;Wave Lenght;11;0;Create;True;0;0;0;False;0;False;1;50;0.1;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;46;-3310.782,664.722;Inherit;False;Property;_DirectionA;Direction A;5;1;[Header];Create;True;1;Waves Direction;0;0;False;0;False;0,0,0;-0.16,0,0.5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;49;-3316.26,1127.765;Inherit;False;Property;_DirectionD;Direction D;8;0;Create;True;0;0;0;False;0;False;0,0,0;-0.01,0,0.4;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;47;-3310.947,816.4661;Inherit;False;Property;_DirectionB;Direction B;6;0;Create;True;0;0;0;False;0;False;0,0,0;0.1,0,0.2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;174;-3119.341,77.39998;Inherit;False;Property;_CrestOpacity;Crest Opacity;21;0;Create;True;0;0;0;False;0;False;0;0.456;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;45;-2551.937,1308.681;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;138;-522.569,259.6527;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;53;-2340.547,1083.821;Inherit;False;Gerstner;-1;;59;07c54fb8a509f764baf97a0ed50f1bd2;0;6;16;FLOAT;1;False;17;FLOAT;0;False;3;FLOAT3;1,0,0;False;4;FLOAT;10;False;5;FLOAT;1;False;9;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;160;-1611.408,-1138.896;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;4.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;200;-1751.244,1204.931;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;51;-2339.549,680.2012;Inherit;False;Gerstner;-1;;53;07c54fb8a509f764baf97a0ed50f1bd2;0;6;16;FLOAT;1;False;17;FLOAT;0;False;3;FLOAT3;1,0,0;False;4;FLOAT;10;False;5;FLOAT;1;False;9;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;139;-282.5939,119.9167;Inherit;True;Property;_NormalsB;Normals B;26;0;Create;True;0;0;0;False;0;False;-1;None;b45ed0dc40c73bb4b8febc3a3d05cd60;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;117;-605.8676,-54.49723;Inherit;True;Property;_NormalsA;Normals A;25;1;[Header];Create;True;0;0;0;False;0;False;-1;None;b45ed0dc40c73bb4b8febc3a3d05cd60;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;50;-2342.708,1289.088;Inherit;False;Gerstner;-1;;57;07c54fb8a509f764baf97a0ed50f1bd2;0;6;16;FLOAT;1;False;17;FLOAT;0;False;3;FLOAT3;1,0,0;False;4;FLOAT;10;False;5;FLOAT;1;False;9;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;173;-2812.593,40.95189;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;175;-3009.139,181.4988;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;52;-2342.708,887.1967;Inherit;False;Gerstner;-1;;55;07c54fb8a509f764baf97a0ed50f1bd2;0;6;16;FLOAT;1;False;17;FLOAT;0;False;3;FLOAT3;1,0,0;False;4;FLOAT;10;False;5;FLOAT;1;False;9;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;161;-1493.754,-1137.16;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;202;-1519.244,1204.931;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;64;-2133.477,-824.5714;Inherit;False;Property;_WaterColor;Water Color;9;0;Create;True;0;0;0;False;0;False;0.4380563,0.6561054,0.8679245,0;0.1543254,0.4001522,0.6415094,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;111;-2129.983,-633.9133;Inherit;False;Constant;_Color0;Color 0;12;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;176;-2777.434,182.0987;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;29.78852,-50.34831;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;172;-2680.662,42.33211;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-1842.273,961.0515;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;62;-1276.327,-1130.134;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;-1511.244,965.9308;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;-2507.74,37.88551;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;151;179.9048,-47.17032;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;168;-2369.456,37.32626;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;204;-1991.756,-87.60299;Inherit;False;623.7239;581.7991;Output;7;115;26;169;152;133;108;0;Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-1339.377,962.2396;Inherit;False;Gerstner;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;107.8856,78.69371;Inherit;False;Normals;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-1109.101,-1136.756;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-1844.886,-37.603;Inherit;False;107;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;-1839.524,65.87952;Inherit;False;132;Normals;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-1941.756,137.8284;Inherit;False;Property;_Metallic;Metallic;14;0;Create;True;0;0;0;False;0;False;1.31;0.58;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;169;-1845.706,297.9096;Inherit;False;168;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-1846.544,378.1961;Inherit;False;24;Gerstner;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;152;-1940.171,210.901;Inherit;False;Property;_Smoothness;Smoothness;13;0;Create;True;0;0;0;False;0;False;0;0.911;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1623.033,6.350471;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Sha_Ocean;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;6.9;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;90;0;78;0
WireConnection;96;0;88;0
WireConnection;96;1;90;0
WireConnection;103;0;102;0
WireConnection;103;1;90;0
WireConnection;67;0;70;0
WireConnection;95;0;67;0
WireConnection;95;2;96;0
WireConnection;104;0;67;0
WireConnection;104;2;103;0
WireConnection;165;0;163;0
WireConnection;71;0;104;0
WireConnection;71;1;72;0
WireConnection;66;0;95;0
WireConnection;66;1;69;0
WireConnection;125;0;130;0
WireConnection;125;1;126;0
WireConnection;73;0;146;0
WireConnection;73;1;66;0
WireConnection;73;2;71;0
WireConnection;140;0;125;0
WireConnection;140;1;126;0
WireConnection;164;0;121;0
WireConnection;164;1;163;0
WireConnection;166;0;165;0
WireConnection;166;1;136;0
WireConnection;171;0;170;2
WireConnection;31;0;16;0
WireConnection;30;0;13;0
WireConnection;120;0;164;0
WireConnection;120;1;125;0
WireConnection;110;0;73;0
WireConnection;110;1;65;2
WireConnection;45;0;17;0
WireConnection;138;0;166;0
WireConnection;138;1;140;0
WireConnection;53;16;13;0
WireConnection;53;17;14;0
WireConnection;53;3;48;0
WireConnection;53;4;30;0
WireConnection;53;5;31;0
WireConnection;53;9;45;0
WireConnection;160;0;110;0
WireConnection;160;1;162;0
WireConnection;200;0;203;0
WireConnection;51;16;13;0
WireConnection;51;17;14;0
WireConnection;51;3;46;0
WireConnection;51;4;15;0
WireConnection;51;5;16;0
WireConnection;51;9;17;0
WireConnection;139;1;138;0
WireConnection;117;1;120;0
WireConnection;50;16;13;0
WireConnection;50;17;14;0
WireConnection;50;3;49;0
WireConnection;50;4;30;0
WireConnection;50;5;31;0
WireConnection;50;9;45;0
WireConnection;173;0;171;0
WireConnection;173;1;174;0
WireConnection;175;0;177;0
WireConnection;52;16;13;0
WireConnection;52;17;14;0
WireConnection;52;3;47;0
WireConnection;52;4;15;0
WireConnection;52;5;16;0
WireConnection;52;9;17;0
WireConnection;161;0;160;0
WireConnection;202;0;200;0
WireConnection;176;0;175;0
WireConnection;141;0;117;0
WireConnection;141;1;139;0
WireConnection;172;0;173;0
WireConnection;25;0;51;0
WireConnection;25;1;52;0
WireConnection;25;2;53;0
WireConnection;25;3;50;0
WireConnection;62;0;64;0
WireConnection;62;1;111;0
WireConnection;62;2;161;0
WireConnection;199;0;25;0
WireConnection;199;1;202;0
WireConnection;178;0;172;0
WireConnection;178;1;176;0
WireConnection;151;0;141;0
WireConnection;168;0;178;0
WireConnection;24;0;199;0
WireConnection;132;0;151;0
WireConnection;107;0;62;0
WireConnection;0;0;108;0
WireConnection;0;1;133;0
WireConnection;0;3;115;0
WireConnection;0;4;152;0
WireConnection;0;9;169;0
WireConnection;0;11;26;0
ASEEND*/
//CHKSM=2CB5473397F726B51BFF3C50F22CC91488B4735F
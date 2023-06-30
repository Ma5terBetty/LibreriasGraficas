// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sha_EntranceDoor"
{
	Properties
	{
		[Header(Lines Properties)]_MainLinesScale("Main Lines Scale", Float) = 0
		_MainLinesSpeed("Main Lines Speed", Float) = 0
		_SecondaryLinesScale("Secondary Lines Scale", Float) = 0
		_ThinLinesSpeed("Thin Lines Speed", Float) = 0
		[Header(Colors)]_MainLinesColor("Main Lines Color", Color) = (0.9433962,0,0,0)
		_SecondaryLinesColor("Secondary Lines Color", Color) = (0.1597267,1,0,0)
		_DoorFrameColor("Door Frame Color", Color) = (0.6037736,0.1794233,0.1794233,0)
		_DoorFrameIntensity("Door Frame Intensity", Range( 1 , 20)) = 0
		_DoorFrameColorIntensity("Door Frame Color Intensity", Range( 0 , 1)) = 0
		[Header(Opacity)]_Opacity("Opacity", Range( 0 , 1)) = 0
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

		uniform float _MainLinesScale;
		uniform float _MainLinesSpeed;
		uniform float4 _MainLinesColor;
		uniform float _SecondaryLinesScale;
		uniform float _ThinLinesSpeed;
		uniform float4 _SecondaryLinesColor;
		uniform float _DoorFrameIntensity;
		uniform float4 _DoorFrameColor;
		uniform float _DoorFrameColorIntensity;
		uniform float _Opacity;


		float2 voronoihash116( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi116( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash116( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float mulTime14 = _Time.y * _MainLinesSpeed;
			float SinLines131 = sin( ( ( ase_vertex3Pos.z * -_MainLinesScale ) + mulTime14 ) );
			float mulTime186 = _Time.y * _ThinLinesSpeed;
			float ThinnerLines190 = sin( ( ( ase_vertex3Pos.z * -_SecondaryLinesScale ) + mulTime186 ) );
			float time116 = 0.0;
			float2 coords116 = i.uv_texcoord * 1.0;
			float2 id116 = 0;
			float2 uv116 = 0;
			float voroi116 = voronoi116( coords116, time116, id116, uv116, 0 );
			float DoorHaloFrame130 = ( voroi116 * _DoorFrameIntensity );
			float4 temp_output_221_0 = saturate( ( DoorHaloFrame130 * _DoorFrameColor * _DoorFrameColorIntensity ) );
			float4 Emision138 = ( saturate( ( ( saturate( ( SinLines131 * _MainLinesColor ) ) + saturate( ( ThinnerLines190 * _SecondaryLinesColor ) ) ) - temp_output_221_0 ) ) + temp_output_221_0 );
			o.Emission = Emision138.rgb;
			float4 Opacity164 = saturate( ( ( 1.0 - Emision138 ) * _Opacity ) );
			o.Alpha = Opacity164.r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;497;1550;494;3332.562;0.1445522;2.484672;True;False
Node;AmplifyShaderEditor.CommentaryNode;145;-2062.767,581.5059;Inherit;False;1058.6;351.926;Lines;9;55;131;3;20;14;4;56;46;5;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;202;-2066.521,1002.374;Inherit;False;1082;406.526;Thinner Lines;9;182;184;183;185;187;186;188;189;190;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2012.768,771.8418;Inherit;False;Property;_MainLinesScale;Main Lines Scale;0;1;[Header];Create;True;1;Lines Properties;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-2056.822,1189.11;Inherit;False;Property;_SecondaryLinesScale;Secondary Lines Scale;2;0;Create;True;0;0;0;False;0;False;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;184;-1899.461,1272.099;Inherit;False;Property;_ThinLinesSpeed;Thin Lines Speed;3;0;Create;True;0;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;56;-1836.142,773.4697;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-1899.609,848.6322;Inherit;False;Property;_MainLinesSpeed;Main Lines Speed;1;0;Create;True;0;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;183;-1824.086,1052.374;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;46;-1820.333,631.5059;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;185;-1839.895,1194.338;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;-1682.07,801.3451;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1646.514,705.4885;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;186;-1685.823,1222.213;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;-1650.267,1126.357;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;188;-1517.397,1126.417;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-1513.644,705.5493;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;144;-2064.586,1428.214;Inherit;False;890.5881;220.1124;Door Frame;4;130;117;118;116;;1,1,1,1;0;0
Node;AmplifyShaderEditor.VoronoiNode;116;-2039.285,1478.927;Inherit;False;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SinOpNode;189;-1398.952,1127.411;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;3;-1395.199,706.5432;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-1863.172,1544.932;Inherit;False;Property;_DoorFrameIntensity;Door Frame Intensity;7;0;Create;True;0;0;0;False;0;False;0;16.72332;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-1584.639,1478.214;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;131;-1204.768,702.7199;Inherit;False;SinLines;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;146;-2050.128,-269.868;Inherit;False;1691.957;767.0676;Combination between door frame and lines;18;221;220;228;219;218;138;227;226;225;198;128;127;120;40;137;136;122;8;Emision;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;190;-1280.52,1121.988;Inherit;False;ThinnerLines;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;-2015.335,-141.1307;Inherit;False;Property;_MainLinesColor;Main Lines Color;4;1;[Header];Create;True;1;Colors;0;0;False;0;False;0.9433962,0,0,0;0.1338398,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;137;-2013.421,42.08493;Inherit;False;190;ThinnerLines;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;122;-2010.395,130.302;Inherit;False;Property;_SecondaryLinesColor;Secondary Lines Color;5;0;Create;True;0;0;0;False;0;False;0.1597267,1,0,0;0,0.5471698,0.04897206,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;130;-1372.196,1483.463;Inherit;False;DoorHaloFrame;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;136;-1979.521,-218.8296;Inherit;False;131;SinLines;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-1789.899,43.66883;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-1784.758,-215.5524;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-1643.704,380.9111;Inherit;False;Property;_DoorFrameColorIntensity;Door Frame Color Intensity;8;0;Create;True;0;0;0;False;0;False;0;0.6420224;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;219;-1584.167,200.8019;Inherit;False;Property;_DoorFrameColor;Door Frame Color;6;0;Create;True;0;0;0;False;0;False;0.6037736,0.1794233,0.1794233,0;0,0.6267071,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;218;-1584.516,114.546;Inherit;False;130;DoorHaloFrame;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;128;-1575.134,40.90362;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;220;-1333.615,120.568;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;127;-1553.852,-212.4813;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;221;-1115.948,120.1591;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;198;-1393.495,-214.3382;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;225;-1157.163,-210.8861;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;226;-1007.33,-211.1941;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;227;-839.0508,-212.2768;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;138;-701.9302,-206.5924;Inherit;False;Emision;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;217;-926.6801,1173.864;Inherit;False;883.955;253.9343;Opacity;6;216;164;214;215;238;203;Opacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;203;-867.6801,1223.14;Inherit;False;138;Emision;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;238;-695.5747,1229.238;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;216;-889.2667,1320.275;Inherit;False;Property;_Opacity;Opacity;9;1;[Header];Create;True;1;Opacity;0;0;False;0;False;0;0.5493171;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;215;-557.749,1223.159;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;214;-409.4212,1227.503;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;164;-250.4519,1223.864;Inherit;False;Opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;147;-922.4915,592.0277;Inherit;False;603.3738;502.8038;Main Output;3;0;143;165;Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;165;-842.8317,909.7216;Inherit;False;164;Opacity;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-840.6911,665.1309;Inherit;False;138;Emision;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-578.7787,649.6385;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Sha_EntranceDoor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;56;0;5;0
WireConnection;185;0;182;0
WireConnection;14;0;55;0
WireConnection;4;0;46;3
WireConnection;4;1;56;0
WireConnection;186;0;184;0
WireConnection;187;0;183;3
WireConnection;187;1;185;0
WireConnection;188;0;187;0
WireConnection;188;1;186;0
WireConnection;20;0;4;0
WireConnection;20;1;14;0
WireConnection;189;0;188;0
WireConnection;3;0;20;0
WireConnection;117;0;116;0
WireConnection;117;1;118;0
WireConnection;131;0;3;0
WireConnection;190;0;189;0
WireConnection;130;0;117;0
WireConnection;120;0;137;0
WireConnection;120;1;122;0
WireConnection;40;0;136;0
WireConnection;40;1;8;0
WireConnection;128;0;120;0
WireConnection;220;0;218;0
WireConnection;220;1;219;0
WireConnection;220;2;228;0
WireConnection;127;0;40;0
WireConnection;221;0;220;0
WireConnection;198;0;127;0
WireConnection;198;1;128;0
WireConnection;225;0;198;0
WireConnection;225;1;221;0
WireConnection;226;0;225;0
WireConnection;227;0;226;0
WireConnection;227;1;221;0
WireConnection;138;0;227;0
WireConnection;238;0;203;0
WireConnection;215;0;238;0
WireConnection;215;1;216;0
WireConnection;214;0;215;0
WireConnection;164;0;214;0
WireConnection;0;2;143;0
WireConnection;0;9;165;0
ASEEND*/
//CHKSM=9AF21E1F7CC215CF9E8341A80511DAEDC6D0B01B
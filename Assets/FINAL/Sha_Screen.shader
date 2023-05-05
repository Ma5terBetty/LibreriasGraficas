// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sha_Screen"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_Color0("Color 0", Color) = (0.1480744,0.2264151,0.07155571,0)
		_Float0("Float 0", Range( 0 , 5)) = 0
		_Float3("Float 3", Float) = 56.76
		_Vector0("Vector 0", Vector) = (0,100,0,0)
		_Float4("Float 4", Range( 0 , 2)) = 0
		_Float1("Float 1", Float) = 1920
		_Float2("Float 2", Float) = 1080
		_WebcamRT("WebcamRT", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _WebcamRT;
		uniform float _Float1;
		uniform float _Float2;
		uniform float _Float3;
		uniform float2 _Vector0;
		uniform float _Float4;
		uniform float4 _Color0;
		uniform float _Float0;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float pixelWidth49 =  1.0f / _Float1;
			float pixelHeight49 = 1.0f / _Float2;
			half2 pixelateduv49 = half2((int)(i.uv_texcoord.x / pixelWidth49) * pixelWidth49, (int)(i.uv_texcoord.y / pixelHeight49) * pixelHeight49);
			float4 tex2DNode1 = tex2D( _WebcamRT, pixelateduv49 );
			float2 temp_cast_0 = (_Float3).xx;
			float2 uv_TexCoord68 = i.uv_texcoord * temp_cast_0 + ( _Time.y * _Vector0 );
			float temp_output_67_0 = sin( uv_TexCoord68.y );
			float temp_output_81_0 = ( 1.0 - temp_output_67_0 );
			o.Emission = saturate( ( ( tex2DNode1 * temp_output_81_0 * _Float4 ) + ( tex2DNode1 * ( _Color0 * _Float0 ) * saturate( temp_output_67_0 ) * temp_output_81_0 ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;584;1465;407;2132.772;-352.2921;1;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;70;-1469.036,507.4742;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;71;-1491.03,618.7376;Inherit;False;Property;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0,100;0,-20;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;69;-1365.732,409.1484;Inherit;False;Property;_Float3;Float 3;7;0;Create;True;0;0;0;False;0;False;56.76;300;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-1287.91,563.106;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1465.285,-59.0881;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-1406.643,137.2396;Inherit;False;Property;_Float2;Float 2;11;0;Create;True;0;0;0;False;0;False;1080;32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1404.643,61.2396;Inherit;False;Property;_Float1;Float 1;10;0;Create;True;0;0;0;False;0;False;1920;64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;68;-1157.243,384.5669;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;64;-1174.739,270.2451;Inherit;False;Property;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;0;2.16;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;67;-934.4545,429.6372;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCPixelate;49;-1213.364,-59.33801;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;60;-1107.066,96.09386;Inherit;False;Property;_Color0;Color 0;5;0;Create;True;0;0;0;False;0;False;0.1480744,0.2264151,0.07155571,0;1,0.9204537,0.8349056,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-842.7421,102.6117;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;81;-785.5869,218.9458;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1000.772,-89.02353;Inherit;True;Property;_WebcamRT;WebcamRT;12;0;Create;True;0;0;0;False;0;False;-1;None;a23454a9a5fd2244c94a5d88ef3125b1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;84;-782.9871,308.6456;Inherit;False;Property;_Float4;Float 4;9;0;Create;True;0;0;0;False;0;False;0;0.9857824;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;80;-586.4973,404.4359;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-409.7609,-74.39185;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-402.9872,208.8863;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-234.183,-6.216863;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;62;-37.02547,14.54483;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;350.6941,-46.80847;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;Sha_Screen;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;72;0;70;0
WireConnection;72;1;71;0
WireConnection;68;0;69;0
WireConnection;68;1;72;0
WireConnection;67;0;68;2
WireConnection;49;0;10;0
WireConnection;49;1;52;0
WireConnection;49;2;53;0
WireConnection;65;0;60;0
WireConnection;65;1;64;0
WireConnection;81;0;67;0
WireConnection;1;1;49;0
WireConnection;80;0;67;0
WireConnection;82;0;1;0
WireConnection;82;1;81;0
WireConnection;82;2;84;0
WireConnection;59;0;1;0
WireConnection;59;1;65;0
WireConnection;59;2;80;0
WireConnection;59;3;81;0
WireConnection;83;0;82;0
WireConnection;83;1;59;0
WireConnection;62;0;83;0
WireConnection;0;2;62;0
ASEEND*/
//CHKSM=0452F52FA9A5BF6E3B37D3898661E91B2F45FF77
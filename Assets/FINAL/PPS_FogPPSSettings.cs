// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( PPS_FogPPSRenderer ), PostProcessEvent.AfterStack, "PPS_Fog", true )]
public sealed class PPS_FogPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Distance" )]
	public FloatParameter _Distance = new FloatParameter { value = 30f };
	[Tooltip( "Blending" )]
	public FloatParameter _Blending = new FloatParameter { value = 50f };
	[Tooltip( "Fog Color" )]
	public ColorParameter _FogColor = new ColorParameter { value = new Color(0.6132076f,0.5858546f,0.1937967f,0f) };
}

public sealed class PPS_FogPPSRenderer : PostProcessEffectRenderer<PPS_FogPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "PPS_Fog" ) );
		sheet.properties.SetFloat( "_Distance", settings._Distance );
		sheet.properties.SetFloat( "_Blending", settings._Blending );
		sheet.properties.SetColor( "_FogColor", settings._FogColor );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif

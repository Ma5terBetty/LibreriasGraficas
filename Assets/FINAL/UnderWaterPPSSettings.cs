// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( UnderWaterPPSRenderer ), PostProcessEvent.AfterStack, "UnderWater", true )]
public sealed class UnderWaterPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "UnderWater Color" )]
	public ColorParameter _UnderWaterColor = new ColorParameter { value = new Color(0.4811321f,0.07489321f,0.08307241f,0f) };
}

public sealed class UnderWaterPPSRenderer : PostProcessEffectRenderer<UnderWaterPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "UnderWater" ) );
		sheet.properties.SetColor( "_UnderWaterColor", settings._UnderWaterColor );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif

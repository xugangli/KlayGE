float4x4 matMVP : WorldViewProjection;

float exposureLevel;

sampler2D FullSampler;
sampler2D BlurSampler;

struct VS_OUT
{
	float4 Pos:	POSITION;
	float2 Tex:	TEXCOORD0;
};

VS_OUT ToneMappingVS(float4 inPos: POSITION, float2 inTex: TEXCOORD0)
{
	VS_OUT OUT;

	// Output the transformed vertex
	OUT.Pos = mul(inPos, matMVP);

	// Output the texture coordinates
	OUT.Tex = inTex;

	return OUT;
}

float4 ToneMappingPS(float2 inTex: TEXCOORD0,
			uniform sampler2D Full,
			uniform sampler2D Blur) : COLOR0
{
	float4 original = tex2D(Full, inTex);
	float4 blur		= tex2D(Blur, inTex);

	float4 color	= lerp(original, blur, 0.4);
	color		   *= exposureLevel;

	return pow(color, 0.55);
}

technique Technique0
{
	pass Pass0
	{
		VertexShader = compile vs_2_0 ToneMappingVS();
		PixelShader  = compile ps_2_0 ToneMappingPS(FullSampler, BlurSampler);
	}
}

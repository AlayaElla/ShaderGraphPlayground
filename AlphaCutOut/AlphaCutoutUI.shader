Shader "Shader Graphs/AlphaCutoutUI"
{
    Properties
    {
        [NoScaleOffset]_MainTex("_MainTex", 2D) = "white" {}
        _Color("_Color", Color) = (1, 1, 1, 1)
        _Offset("Offset", Range(0, 1)) = 0.5
        _Speed("Speed", Float) = 1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255
        _ColorMask ("Color Mask", Float) = 15
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalUnlitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                // LightMode: <None>
            }
			
        // Render State
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest [unity_GUIZTestMode]
        ZWrite Off
        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        ColorMask [_ColorMask]       
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            #pragma multi_compile_fragment _ DEBUG_DISPLAY
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SPRITEUNLIT
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.color = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float4 _Color;
        float _Offset;
        float _Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
        
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
        
            // Graph Functions
            
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
            #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_13563c53b7c042cb9fe8b1bd0e663fb3_Out_0 = _Color;
            UnityTexture2D _Property_b8de82bf65984a7aa92763f800c4abe6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float _Property_b5d91d898181453b92526c82a07b9ebd_Out_0 = _Speed;
            float _Multiply_57c1e9d8e5404ffaba4aeba27134e014_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_b5d91d898181453b92526c82a07b9ebd_Out_0, _Multiply_57c1e9d8e5404ffaba4aeba27134e014_Out_2);
            float2 _Vector2_eac14aea52a34653a379b39d0bea05a4_Out_0 = float2(0, _Multiply_57c1e9d8e5404ffaba4aeba27134e014_Out_2);
            float2 _TilingAndOffset_be616ca17959423db4856a7f2840a76a_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Vector2_eac14aea52a34653a379b39d0bea05a4_Out_0, _TilingAndOffset_be616ca17959423db4856a7f2840a76a_Out_3);
            float4 _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b8de82bf65984a7aa92763f800c4abe6_Out_0.tex, _Property_b8de82bf65984a7aa92763f800c4abe6_Out_0.samplerstate, _Property_b8de82bf65984a7aa92763f800c4abe6_Out_0.GetTransformedUV(_TilingAndOffset_be616ca17959423db4856a7f2840a76a_Out_3));
            float _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_R_4 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0.r;
            float _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_G_5 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0.g;
            float _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_B_6 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0.b;
            float _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_A_7 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0.a;
            float _Split_e0b1332f2f9848acacf2593dc5f61923_R_1 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0[0];
            float _Split_e0b1332f2f9848acacf2593dc5f61923_G_2 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0[1];
            float _Split_e0b1332f2f9848acacf2593dc5f61923_B_3 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0[2];
            float _Split_e0b1332f2f9848acacf2593dc5f61923_A_4 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0[3];
            float _OneMinus_af752909feae4f69980f9c7674b2c942_Out_1;
            Unity_OneMinus_float(_Split_e0b1332f2f9848acacf2593dc5f61923_G_2, _OneMinus_af752909feae4f69980f9c7674b2c942_Out_1);
            float _Property_c72d28b1e298490fa29eb5229bd8bd6b_Out_0 = _Offset;
            float4 _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0 = IN.uv0;
            float _Split_31f0203e3f674906a003e4a3e5a9e5f1_R_1 = _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0[0];
            float _Split_31f0203e3f674906a003e4a3e5a9e5f1_G_2 = _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0[1];
            float _Split_31f0203e3f674906a003e4a3e5a9e5f1_B_3 = _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0[2];
            float _Split_31f0203e3f674906a003e4a3e5a9e5f1_A_4 = _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0[3];
            float _Add_63044d05f1694c7281463821932035f8_Out_2;
            Unity_Add_float(_Property_c72d28b1e298490fa29eb5229bd8bd6b_Out_0, _Split_31f0203e3f674906a003e4a3e5a9e5f1_G_2, _Add_63044d05f1694c7281463821932035f8_Out_2);
            float _Subtract_842237693e5c4c8e8fd161dec1cd8538_Out_2;
            Unity_Subtract_float(_OneMinus_af752909feae4f69980f9c7674b2c942_Out_1, _Add_63044d05f1694c7281463821932035f8_Out_2, _Subtract_842237693e5c4c8e8fd161dec1cd8538_Out_2);
            float _Clamp_30d58990c59044ed8c8cf0fa1ec8047d_Out_3;
            Unity_Clamp_float(_Subtract_842237693e5c4c8e8fd161dec1cd8538_Out_2, 0, 1, _Clamp_30d58990c59044ed8c8cf0fa1ec8047d_Out_3);
            float _Ceiling_f00f005ae92f47c48a8ab2b01b27e44e_Out_1;
            Unity_Ceiling_float(_Clamp_30d58990c59044ed8c8cf0fa1ec8047d_Out_3, _Ceiling_f00f005ae92f47c48a8ab2b01b27e44e_Out_1);
            float4 _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2;
            Unity_Multiply_float4_float4(_Property_13563c53b7c042cb9fe8b1bd0e663fb3_Out_0, (_Ceiling_f00f005ae92f47c48a8ab2b01b27e44e_Out_1.xxxx), _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2);
            float _Split_d27f71d4d1734d3da2aeada05b03f4f3_R_1 = _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2[0];
            float _Split_d27f71d4d1734d3da2aeada05b03f4f3_G_2 = _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2[1];
            float _Split_d27f71d4d1734d3da2aeada05b03f4f3_B_3 = _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2[2];
            float _Split_d27f71d4d1734d3da2aeada05b03f4f3_A_4 = _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2[3];
            surface.BaseColor = (_Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2.xyz);
            surface.Alpha = _Split_d27f71d4d1734d3da2aeada05b03f4f3_A_4;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.uv0 =                                        input.texCoord0;
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteUnlitPass.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
            // Render State
            Cull Off
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        
        #define _ALPHATEST_ON 1
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float4 _Color;
        float _Offset;
        float _Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
        
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
        
            // Graph Functions
            
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
            #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_13563c53b7c042cb9fe8b1bd0e663fb3_Out_0 = _Color;
            UnityTexture2D _Property_b8de82bf65984a7aa92763f800c4abe6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float _Property_b5d91d898181453b92526c82a07b9ebd_Out_0 = _Speed;
            float _Multiply_57c1e9d8e5404ffaba4aeba27134e014_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_b5d91d898181453b92526c82a07b9ebd_Out_0, _Multiply_57c1e9d8e5404ffaba4aeba27134e014_Out_2);
            float2 _Vector2_eac14aea52a34653a379b39d0bea05a4_Out_0 = float2(0, _Multiply_57c1e9d8e5404ffaba4aeba27134e014_Out_2);
            float2 _TilingAndOffset_be616ca17959423db4856a7f2840a76a_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Vector2_eac14aea52a34653a379b39d0bea05a4_Out_0, _TilingAndOffset_be616ca17959423db4856a7f2840a76a_Out_3);
            float4 _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b8de82bf65984a7aa92763f800c4abe6_Out_0.tex, _Property_b8de82bf65984a7aa92763f800c4abe6_Out_0.samplerstate, _Property_b8de82bf65984a7aa92763f800c4abe6_Out_0.GetTransformedUV(_TilingAndOffset_be616ca17959423db4856a7f2840a76a_Out_3));
            float _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_R_4 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0.r;
            float _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_G_5 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0.g;
            float _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_B_6 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0.b;
            float _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_A_7 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0.a;
            float _Split_e0b1332f2f9848acacf2593dc5f61923_R_1 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0[0];
            float _Split_e0b1332f2f9848acacf2593dc5f61923_G_2 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0[1];
            float _Split_e0b1332f2f9848acacf2593dc5f61923_B_3 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0[2];
            float _Split_e0b1332f2f9848acacf2593dc5f61923_A_4 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0[3];
            float _OneMinus_af752909feae4f69980f9c7674b2c942_Out_1;
            Unity_OneMinus_float(_Split_e0b1332f2f9848acacf2593dc5f61923_G_2, _OneMinus_af752909feae4f69980f9c7674b2c942_Out_1);
            float _Property_c72d28b1e298490fa29eb5229bd8bd6b_Out_0 = _Offset;
            float4 _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0 = IN.uv0;
            float _Split_31f0203e3f674906a003e4a3e5a9e5f1_R_1 = _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0[0];
            float _Split_31f0203e3f674906a003e4a3e5a9e5f1_G_2 = _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0[1];
            float _Split_31f0203e3f674906a003e4a3e5a9e5f1_B_3 = _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0[2];
            float _Split_31f0203e3f674906a003e4a3e5a9e5f1_A_4 = _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0[3];
            float _Add_63044d05f1694c7281463821932035f8_Out_2;
            Unity_Add_float(_Property_c72d28b1e298490fa29eb5229bd8bd6b_Out_0, _Split_31f0203e3f674906a003e4a3e5a9e5f1_G_2, _Add_63044d05f1694c7281463821932035f8_Out_2);
            float _Subtract_842237693e5c4c8e8fd161dec1cd8538_Out_2;
            Unity_Subtract_float(_OneMinus_af752909feae4f69980f9c7674b2c942_Out_1, _Add_63044d05f1694c7281463821932035f8_Out_2, _Subtract_842237693e5c4c8e8fd161dec1cd8538_Out_2);
            float _Clamp_30d58990c59044ed8c8cf0fa1ec8047d_Out_3;
            Unity_Clamp_float(_Subtract_842237693e5c4c8e8fd161dec1cd8538_Out_2, 0, 1, _Clamp_30d58990c59044ed8c8cf0fa1ec8047d_Out_3);
            float _Ceiling_f00f005ae92f47c48a8ab2b01b27e44e_Out_1;
            Unity_Ceiling_float(_Clamp_30d58990c59044ed8c8cf0fa1ec8047d_Out_3, _Ceiling_f00f005ae92f47c48a8ab2b01b27e44e_Out_1);
            float4 _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2;
            Unity_Multiply_float4_float4(_Property_13563c53b7c042cb9fe8b1bd0e663fb3_Out_0, (_Ceiling_f00f005ae92f47c48a8ab2b01b27e44e_Out_1.xxxx), _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2);
            float _Split_d27f71d4d1734d3da2aeada05b03f4f3_R_1 = _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2[0];
            float _Split_d27f71d4d1734d3da2aeada05b03f4f3_G_2 = _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2[1];
            float _Split_d27f71d4d1734d3da2aeada05b03f4f3_B_3 = _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2[2];
            float _Split_d27f71d4d1734d3da2aeada05b03f4f3_A_4 = _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2[3];
            surface.Alpha = _Split_d27f71d4d1734d3da2aeada05b03f4f3_A_4;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.uv0 =                                        input.texCoord0;
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
            // Render State
            Cull Off
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        
        #define _ALPHATEST_ON 1
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float4 _Color;
        float _Offset;
        float _Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
        
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
        
            // Graph Functions
            
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
            #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_13563c53b7c042cb9fe8b1bd0e663fb3_Out_0 = _Color;
            UnityTexture2D _Property_b8de82bf65984a7aa92763f800c4abe6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float _Property_b5d91d898181453b92526c82a07b9ebd_Out_0 = _Speed;
            float _Multiply_57c1e9d8e5404ffaba4aeba27134e014_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_b5d91d898181453b92526c82a07b9ebd_Out_0, _Multiply_57c1e9d8e5404ffaba4aeba27134e014_Out_2);
            float2 _Vector2_eac14aea52a34653a379b39d0bea05a4_Out_0 = float2(0, _Multiply_57c1e9d8e5404ffaba4aeba27134e014_Out_2);
            float2 _TilingAndOffset_be616ca17959423db4856a7f2840a76a_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Vector2_eac14aea52a34653a379b39d0bea05a4_Out_0, _TilingAndOffset_be616ca17959423db4856a7f2840a76a_Out_3);
            float4 _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b8de82bf65984a7aa92763f800c4abe6_Out_0.tex, _Property_b8de82bf65984a7aa92763f800c4abe6_Out_0.samplerstate, _Property_b8de82bf65984a7aa92763f800c4abe6_Out_0.GetTransformedUV(_TilingAndOffset_be616ca17959423db4856a7f2840a76a_Out_3));
            float _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_R_4 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0.r;
            float _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_G_5 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0.g;
            float _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_B_6 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0.b;
            float _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_A_7 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0.a;
            float _Split_e0b1332f2f9848acacf2593dc5f61923_R_1 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0[0];
            float _Split_e0b1332f2f9848acacf2593dc5f61923_G_2 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0[1];
            float _Split_e0b1332f2f9848acacf2593dc5f61923_B_3 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0[2];
            float _Split_e0b1332f2f9848acacf2593dc5f61923_A_4 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0[3];
            float _OneMinus_af752909feae4f69980f9c7674b2c942_Out_1;
            Unity_OneMinus_float(_Split_e0b1332f2f9848acacf2593dc5f61923_G_2, _OneMinus_af752909feae4f69980f9c7674b2c942_Out_1);
            float _Property_c72d28b1e298490fa29eb5229bd8bd6b_Out_0 = _Offset;
            float4 _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0 = IN.uv0;
            float _Split_31f0203e3f674906a003e4a3e5a9e5f1_R_1 = _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0[0];
            float _Split_31f0203e3f674906a003e4a3e5a9e5f1_G_2 = _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0[1];
            float _Split_31f0203e3f674906a003e4a3e5a9e5f1_B_3 = _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0[2];
            float _Split_31f0203e3f674906a003e4a3e5a9e5f1_A_4 = _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0[3];
            float _Add_63044d05f1694c7281463821932035f8_Out_2;
            Unity_Add_float(_Property_c72d28b1e298490fa29eb5229bd8bd6b_Out_0, _Split_31f0203e3f674906a003e4a3e5a9e5f1_G_2, _Add_63044d05f1694c7281463821932035f8_Out_2);
            float _Subtract_842237693e5c4c8e8fd161dec1cd8538_Out_2;
            Unity_Subtract_float(_OneMinus_af752909feae4f69980f9c7674b2c942_Out_1, _Add_63044d05f1694c7281463821932035f8_Out_2, _Subtract_842237693e5c4c8e8fd161dec1cd8538_Out_2);
            float _Clamp_30d58990c59044ed8c8cf0fa1ec8047d_Out_3;
            Unity_Clamp_float(_Subtract_842237693e5c4c8e8fd161dec1cd8538_Out_2, 0, 1, _Clamp_30d58990c59044ed8c8cf0fa1ec8047d_Out_3);
            float _Ceiling_f00f005ae92f47c48a8ab2b01b27e44e_Out_1;
            Unity_Ceiling_float(_Clamp_30d58990c59044ed8c8cf0fa1ec8047d_Out_3, _Ceiling_f00f005ae92f47c48a8ab2b01b27e44e_Out_1);
            float4 _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2;
            Unity_Multiply_float4_float4(_Property_13563c53b7c042cb9fe8b1bd0e663fb3_Out_0, (_Ceiling_f00f005ae92f47c48a8ab2b01b27e44e_Out_1.xxxx), _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2);
            float _Split_d27f71d4d1734d3da2aeada05b03f4f3_R_1 = _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2[0];
            float _Split_d27f71d4d1734d3da2aeada05b03f4f3_G_2 = _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2[1];
            float _Split_d27f71d4d1734d3da2aeada05b03f4f3_B_3 = _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2[2];
            float _Split_d27f71d4d1734d3da2aeada05b03f4f3_A_4 = _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2[3];
            surface.Alpha = _Split_d27f71d4d1734d3da2aeada05b03f4f3_A_4;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.uv0 =                                        input.texCoord0;
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "Sprite Unlit"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
            // Render State
            Cull Off
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            ZTest [unity_GUIZTestMode]
            ZWrite Off
            Stencil
            {
                Ref [_Stencil]
                Comp [_StencilComp]
                Pass [_StencilOp]
                ReadMask [_StencilReadMask]
                WriteMask [_StencilWriteMask]
            }

            ColorMask [_ColorMask]   
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            #pragma multi_compile_fragment _ DEBUG_DISPLAY
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SPRITEFORWARD
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.color = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float4 _Color;
        float _Offset;
        float _Speed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
        
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
        
            // Graph Functions
            
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
            #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_13563c53b7c042cb9fe8b1bd0e663fb3_Out_0 = _Color;
            UnityTexture2D _Property_b8de82bf65984a7aa92763f800c4abe6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float _Property_b5d91d898181453b92526c82a07b9ebd_Out_0 = _Speed;
            float _Multiply_57c1e9d8e5404ffaba4aeba27134e014_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_b5d91d898181453b92526c82a07b9ebd_Out_0, _Multiply_57c1e9d8e5404ffaba4aeba27134e014_Out_2);
            float2 _Vector2_eac14aea52a34653a379b39d0bea05a4_Out_0 = float2(0, _Multiply_57c1e9d8e5404ffaba4aeba27134e014_Out_2);
            float2 _TilingAndOffset_be616ca17959423db4856a7f2840a76a_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Vector2_eac14aea52a34653a379b39d0bea05a4_Out_0, _TilingAndOffset_be616ca17959423db4856a7f2840a76a_Out_3);
            float4 _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b8de82bf65984a7aa92763f800c4abe6_Out_0.tex, _Property_b8de82bf65984a7aa92763f800c4abe6_Out_0.samplerstate, _Property_b8de82bf65984a7aa92763f800c4abe6_Out_0.GetTransformedUV(_TilingAndOffset_be616ca17959423db4856a7f2840a76a_Out_3));
            float _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_R_4 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0.r;
            float _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_G_5 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0.g;
            float _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_B_6 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0.b;
            float _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_A_7 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0.a;
            float _Split_e0b1332f2f9848acacf2593dc5f61923_R_1 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0[0];
            float _Split_e0b1332f2f9848acacf2593dc5f61923_G_2 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0[1];
            float _Split_e0b1332f2f9848acacf2593dc5f61923_B_3 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0[2];
            float _Split_e0b1332f2f9848acacf2593dc5f61923_A_4 = _SampleTexture2D_05d6aca7bd5846c8b118f85d8d4deb69_RGBA_0[3];
            float _OneMinus_af752909feae4f69980f9c7674b2c942_Out_1;
            Unity_OneMinus_float(_Split_e0b1332f2f9848acacf2593dc5f61923_G_2, _OneMinus_af752909feae4f69980f9c7674b2c942_Out_1);
            float _Property_c72d28b1e298490fa29eb5229bd8bd6b_Out_0 = _Offset;
            float4 _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0 = IN.uv0;
            float _Split_31f0203e3f674906a003e4a3e5a9e5f1_R_1 = _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0[0];
            float _Split_31f0203e3f674906a003e4a3e5a9e5f1_G_2 = _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0[1];
            float _Split_31f0203e3f674906a003e4a3e5a9e5f1_B_3 = _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0[2];
            float _Split_31f0203e3f674906a003e4a3e5a9e5f1_A_4 = _UV_a55f0564fe38479e8bf8e6c83b4d432c_Out_0[3];
            float _Add_63044d05f1694c7281463821932035f8_Out_2;
            Unity_Add_float(_Property_c72d28b1e298490fa29eb5229bd8bd6b_Out_0, _Split_31f0203e3f674906a003e4a3e5a9e5f1_G_2, _Add_63044d05f1694c7281463821932035f8_Out_2);
            float _Subtract_842237693e5c4c8e8fd161dec1cd8538_Out_2;
            Unity_Subtract_float(_OneMinus_af752909feae4f69980f9c7674b2c942_Out_1, _Add_63044d05f1694c7281463821932035f8_Out_2, _Subtract_842237693e5c4c8e8fd161dec1cd8538_Out_2);
            float _Clamp_30d58990c59044ed8c8cf0fa1ec8047d_Out_3;
            Unity_Clamp_float(_Subtract_842237693e5c4c8e8fd161dec1cd8538_Out_2, 0, 1, _Clamp_30d58990c59044ed8c8cf0fa1ec8047d_Out_3);
            float _Ceiling_f00f005ae92f47c48a8ab2b01b27e44e_Out_1;
            Unity_Ceiling_float(_Clamp_30d58990c59044ed8c8cf0fa1ec8047d_Out_3, _Ceiling_f00f005ae92f47c48a8ab2b01b27e44e_Out_1);
            float4 _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2;
            Unity_Multiply_float4_float4(_Property_13563c53b7c042cb9fe8b1bd0e663fb3_Out_0, (_Ceiling_f00f005ae92f47c48a8ab2b01b27e44e_Out_1.xxxx), _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2);
            float _Split_d27f71d4d1734d3da2aeada05b03f4f3_R_1 = _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2[0];
            float _Split_d27f71d4d1734d3da2aeada05b03f4f3_G_2 = _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2[1];
            float _Split_d27f71d4d1734d3da2aeada05b03f4f3_B_3 = _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2[2];
            float _Split_d27f71d4d1734d3da2aeada05b03f4f3_A_4 = _Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2[3];
            surface.BaseColor = (_Multiply_55b6f8dff29e41778dd73afc185b0645_Out_2.xyz);
            surface.Alpha = _Split_d27f71d4d1734d3da2aeada05b03f4f3_A_4;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.uv0 =                                        input.texCoord0;
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteUnlitPass.hlsl"
        
            ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}
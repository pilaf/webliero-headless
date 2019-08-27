# Headless WebLiero

## Headless Chromium setup

In a `screen` session in remote machine:

```
$ chromium --headless --remote-debugging-port=9222 --disable-gpu --disable-audio https://www.webliero.com
```

In local machine:

```
$ ssh -L 9222:localhost:9222 %REMOTE_ADDRESS%
```

Then in a local Chrome access http://localhost:9222

## Dummy WebGL Script

In remote debugging console paste:

```js
(function() {
    'use strict';

    var pkg = { name: "NoGl", version: 1 };
    var extend = Object.assign;
    var constants = {};

    function NoGL (opts) {
        if (!(this instanceof NoGL)) return new NoGL(opts);
    }

    var gl = NoGL.prototype;

    extend(gl, constants, {
        items: {},
        id: 0,
        getExtension: function () { return 0 },
        createBuffer: function () {
            var id = this.id++;
            this.items[id] = {
                which: 'buffer',
            };
            return id;
        },
        deleteBuffer: function (){},
        bindBuffer: function (){},
        bufferData: function (){},
        getParameter: function (pname) {
            switch(pname) {
                case gl.MAX_TEXTURE_MAX_ANISOTROPY_EXT: return 16;
                case gl.MAX_TEXTURE_IMAGE_UNITS_NV: return 16;

                case gl.ELEMENT_ARRAY_BUFFER_BINDING:
                case gl.ARRAY_BUFFER_BINDING:
                case gl.FRAMEBUFFER_BINDING:
                case gl.CURRENT_PROGRAM:
                case gl.RENDERBUFFER_BINDING:
                    return 0;

                    return 0;
                    return this._activeFramebuffer
                    return this._activeRenderbuffer
                case gl.TEXTURE_BINDING_2D:
                case gl.TEXTURE_BINDING_CUBE_MAP:
                    return null

                case gl.VERSION:
                    return pkg.version
                case gl.VENDOR:
                    return pkg.name
                case gl.RENDERER:
                    return pkg.name + '-renderer'
                case gl.SHADING_LANGUAGE_VERSION:
                    return 'WebGL GLSL ES 1.0 ' + pkg.name

                case gl.COMPRESSED_TEXTURE_FORMATS:
                    return new Uint32Array(0)

                    // Int arrays
                case gl.MAX_VIEWPORT_DIMS:
                case gl.SCISSOR_BOX:
                case gl.VIEWPORT:
                    return new Int32Array([0, 0, 2048, 2048])

                    // Float arrays
                case gl.ALIASED_LINE_WIDTH_RANGE:
                case gl.ALIASED_POINT_SIZE_RANGE:
                case gl.DEPTH_RANGE:
                    return new Float32Array([0, 5])
                case gl.BLEND_COLOR:
                case gl.COLOR_CLEAR_VALUE:
                    return new Float32Array([0, 0, 0, 0])

                case gl.COLOR_WRITEMASK:
                    return 0

                case gl.DEPTH_CLEAR_VALUE:
                case gl.LINE_WIDTH:
                case gl.POLYGON_OFFSET_FACTOR:
                case gl.POLYGON_OFFSET_UNITS:
                case gl.SAMPLE_COVERAGE_VALUE:
                    return 1

                case gl.BLEND:
                case gl.CULL_FACE:
                case gl.DEPTH_TEST:
                case gl.DEPTH_WRITEMASK:
                case gl.DITHER:
                case gl.POLYGON_OFFSET_FILL:
                case gl.SAMPLE_COVERAGE_INVERT:
                case gl.SCISSOR_TEST:
                case gl.STENCIL_TEST:
                case gl.UNPACK_FLIP_Y_WEBGL:
                case gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL:
                    return false;

                case gl.MAX_TEXTURE_SIZE:
                case gl.MAX_CUBE_MAP_TEXTURE_SIZE:
                    return 16384;

                case gl.MAX_VERTEX_UNIFORM_VECTORS:
                case gl.MAX_FRAGMENT_UNIFORM_VECTORS:
                    return 4096;

                case gl.MAX_VARYING_VECTORS:
                case gl.MAX_TEXTURE_IMAGE_UNITS:
                case gl.MAX_COMBINED_TEXTURE_IMAGE_UNITS:
                case gl.MAX_VERTEX_TEXTURE_IMAGE_UNITS:
                    return 32;

                case gl.MAX_RENDERBUFFER_SIZE:
                    return 2048;

                case gl.ACTIVE_TEXTURE:
                case gl.ALPHA_BITS:
                case gl.BLEND_DST_ALPHA:
                case gl.BLEND_DST_RGB:
                case gl.BLEND_EQUATION_ALPHA:
                case gl.BLEND_EQUATION_RGB:
                case gl.BLEND_SRC_ALPHA:
                case gl.BLEND_SRC_RGB:
                case gl.BLUE_BITS:
                case gl.CULL_FACE_MODE:
                case gl.DEPTH_BITS:
                case gl.DEPTH_FUNC:
                case gl.FRONT_FACE:
                case gl.GENERATE_MIPMAP_HINT:
                case gl.GREEN_BITS:
                case gl.MAX_VERTEX_ATTRIBS:
                case gl.PACK_ALIGNMENT:
                case gl.RED_BITS:
                case gl.SAMPLE_BUFFERS:
                case gl.SAMPLES:
                case gl.STENCIL_BACK_FAIL:
                case gl.STENCIL_BACK_FUNC:
                case gl.STENCIL_BACK_PASS_DEPTH_FAIL:
                case gl.STENCIL_BACK_PASS_DEPTH_PASS:
                case gl.STENCIL_BACK_REF:
                case gl.STENCIL_BACK_VALUE_MASK:
                case gl.STENCIL_BACK_WRITEMASK:
                case gl.STENCIL_BITS:
                case gl.STENCIL_CLEAR_VALUE:
                case gl.STENCIL_FAIL:
                case gl.STENCIL_FUNC:
                case gl.STENCIL_PASS_DEPTH_FAIL:
                case gl.STENCIL_PASS_DEPTH_PASS:
                case gl.STENCIL_REF:
                case gl.STENCIL_VALUE_MASK:
                case gl.STENCIL_WRITEMASK:
                case gl.SUBPIXEL_BITS:
                case gl.UNPACK_ALIGNMENT:
                case gl.UNPACK_COLORSPACE_CONVERSION_WEBGL:
                    return 0;

                default:
                    return 0;
            }
        },
        getSupportedExtensions: function () {
            return ["OES_texture_float", "OES_standard_derivatives", "EXT_texture_filter_anisotropic", "MOZ_EXT_texture_filter_anisotropic", "MOZ_WEBGL_lose_context", "MOZ_WEBGL_compressed_texture_s3tc", "MOZ_WEBGL_depth_texture"];
        },
        createShader: function (type) {
            var id = this.id++;
            this.items[id] = {
                which: 'shader',
                type: type,
            };
            return id;
        },
        getShaderParameter: function (shader, pname) {
            switch(pname) {
                case gl.SHADER_TYPE: return this.items[shader].type;
                case gl.COMPILE_STATUS: return true;
                //default: throw 'getShaderParameter ' + pname;
                default: return true;
            }
        },
        shaderSource: function (){},
        compileShader: function (){},
        createProgram: function () {
            var id = this.id++;
            this.items[id] = {
                which: 'program',
                shaders: [],
            };
            return id;
        },
        attachShader: function (program, shader) {
            this.items[program].shaders.push(shader);
        },
        bindAttribLocation: function (){},
        linkProgram: function (){},
        getProgramParameter: function (program, pname) {
            switch(pname) {
                case gl.LINK_STATUS: return true;
                case gl.ACTIVE_UNIFORMS: return 4;
                case gl.ACTIVE_ATTRIBUTES: return 0;
                case gl.ACTIVE_UNIFORMS: return 0;
                case gl.DELETE_STATUS: return false;
                case gl.VALIDATE_STATUS: return true;
                case gl.ATTACHED_SHADERS: return 2;
                //default: throw 'getProgramParameter ' + pname;
                default: return true;
            }
        },
        deleteShader: function (){},
        deleteProgram: function (){},
        viewport: function (){},
        clearColor: function (){},
        clearDepth: function (){},
        depthFunc: function (){},
        enable: function (){},
        disable: function (){},
        frontFace: function (){},
        cullFace: function (){},
        activeTexture: function (){},
        createTexture: function () {
            var id = this.id++;
            this.items[id] = {
                which: 'texture',
            };
            return id;
        },
        deleteTexture: function (){},
        boundTextures: {},
        bindTexture: function (target, texture) {
            this.boundTextures[target] = texture;
        },
        texParameterf: function (){},
        texParameteri: function (){},
        pixelStorei: function (){},
        texImage2D: function (){},
        texSubImage2D: function (){},
        compressedTexImage2D: function (){},
        useProgram: function (){},
        getUniformLocation: function () {
            return null;
        },
        getActiveUniform: function (program, index) {
            return {
                size: 1,
                type: gl.INT_VEC3,
                name: 'activeUniform' + index,
            };
        },
        getActiveAttrib: function (program, index) {
            return {
                size: 1,
                type: gl.FLOAT,
                name: 'activeAttrib' + index
            };
        },
        clear: function (){},
        uniform1f: function (){},
        uniform1fv: function (){},
        uniform1i: function (){},
        uniform1iv: function (){},
        uniform2f: function (){},
        uniform2fv: function (){},
        uniform2i: function (){},
        uniform2iv: function (){},
        uniform3f: function (){},
        uniform3fv: function (){},
        uniform3i: function (){},
        uniform3iv: function (){},
        uniform4f: function (){},
        uniform4fv: function (){},
        uniform4i: function (){},
        uniform4iv: function (){},
        uniformMatrix2fv: function (){},
        uniformMatrix3fv: function (){},
        uniformMatrix4fv: function (){},
        getAttribLocation: function () { return 1 },
        vertexAttribPointer: function (){},
        enableVertexAttribArray: function (){},
        disableVertexAttribArray: function (){},
        drawElements: function (){},
        drawArrays: function (){},
        depthMask: function (){},
        depthRange: function (){},
        bufferSubData: function (){},
        blendFunc: function (){},
        createFramebuffer: function () {
            var id = this.id++;
            this.items[id] = {
                which: 'framebuffer',
                shaders: [],
            };
            return id;
        },
        bindFramebuffer: function (){},
        framebufferTexture2D: function (){},
        checkFramebufferStatus: function () {
            return gl.FRAMEBUFFER_COMPLETE;
        },
        deleteFramebuffer: function (){},
        createRenderbuffer: function () {
            var id = this.id++;
            this.items[id] = {
                which: 'renderbuffer',
                shaders: [],
            };
            return id;
        },
        bindRenderbuffer: function (){},
        deleteRenderbuffer: function (){},
        renderbufferStorage: function (){},
        framebufferRenderbuffer: function (){},
        scissor: function (){},
        colorMask: function (){},
        lineWidth: function (){},
        vertexAttrib1f: function (){},
        vertexAttrib1fv: function (){},
        vertexAttrib2f: function (){},
        vertexAttrib2fv: function (){},
        vertexAttrib3f: function (){},
        vertexAttrib3fv: function (){},
        vertexAttrib4f: function (){},
        vertexAttrib4fv: function (){},
        validateProgram: function (){},
        generateMipmap: function (){},
        isContextLost: function (){return false;},
        drawingBufferWidth: function (){return 1024},
        drawingBufferHeight: function (){return 1024},
        blendColor: function (){},
        blendEquation: function (){},
        blendEquationSeparate: function (){},
        blendFuncSeparate: function (){},
        clearStencil: function (){},
        compressedTexSubImage2D: function (){},
        copyTexImage2D: function (){},
        copyTexSubImage2D: function (){},
        detachShader: function (){},
        finish: function (){},
        flush: function (){},
        getError: function (){return 0;},
        polygonOffset: function (){},
        readPixels: function (){},
        sampleCoverage: function (){},
        stencilFunc: function (){},
        stencilFuncSeparate: function (){},
        stencilMask: function (){},
        stencilMaskSeparate: function (){},
        stencilOp: function (){},
        stencilOpSeparate: function (){},
    });

    var getContext = window.HTMLCanvasElement.prototype.getContext;
    window.HTMLCanvasElement.prototype.getContext = function(context) {
        if (context === "webgl" || context === "experimental-webgl") {
            return new NoGL();
        }
        return getContext.call(this, context);
    }
})();
```

## Set nickname, server name and player limit

Copy/paste from local machine is not possible, so if you want to use emoji in
the nickname you need to do:

```js
document.querySelector("[placeholder=Nickname]").value = "Hi I'm a server 🖥️"
```

For server name:

```js
document.querySelector("[data-hook=name]").value = "𝕆𝕡𝕖𝕟 𝟚𝟜／𝟟"
```

For player limit focus on dropdown and use the up/down arrowss.

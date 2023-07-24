#iChannel0"https://s2.loli.net/2023/03/20/5jmPqdJW7EL2a4X.jpg"

// https://github.com/Jam3/glsl-fast-gaussian-blur
vec4 blur5(sampler2D image,vec2 uv,vec2 resolution,vec2 direction){
    vec4 color=vec4(0.);
    vec2 off1=vec2(1.3333333333333333)*direction;
    color+=texture(image,uv)*.29411764705882354;
    color+=texture(image,uv+(off1/resolution))*.35294117647058826;
    color+=texture(image,uv-(off1/resolution))*.35294117647058826;
    return color;
}

vec4 blur9(sampler2D image,vec2 uv,vec2 resolution,vec2 direction){
    vec4 color=vec4(0.);
    vec2 off1=vec2(1.3846153846)*direction;
    vec2 off2=vec2(3.2307692308)*direction;
    color+=texture(image,uv)*.2270270270;
    color+=texture(image,uv+(off1/resolution))*.3162162162;
    color+=texture(image,uv-(off1/resolution))*.3162162162;
    color+=texture(image,uv+(off2/resolution))*.0702702703;
    color+=texture(image,uv-(off2/resolution))*.0702702703;
    return color;
}

vec4 blur13(sampler2D image,vec2 uv,vec2 resolution,vec2 direction){
    vec4 color=vec4(0.);
    vec2 off1=vec2(1.411764705882353)*direction;
    vec2 off2=vec2(3.2941176470588234)*direction;
    vec2 off3=vec2(5.176470588235294)*direction;
    color+=texture(image,uv)*.1964825501511404;
    color+=texture(image,uv+(off1/resolution))*.2969069646728344;
    color+=texture(image,uv-(off1/resolution))*.2969069646728344;
    color+=texture(image,uv+(off2/resolution))*.09447039785044732;
    color+=texture(image,uv-(off2/resolution))*.09447039785044732;
    color+=texture(image,uv+(off3/resolution))*.010381362401148057;
    color+=texture(image,uv-(off3/resolution))*.010381362401148057;
    return color;
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    vec4 col=blur5(iChannel0,uv,iResolution.xy,vec2(1.,1.));
    fragColor=col;
}
#iChannel0"https://s2.loli.net/2023/03/20/5jmPqdJW7EL2a4X.jpg"

float sum(vec4 v){
    return v.x+v.y+v.z+v.w;
}

// https://www.shadertoy.com/view/WsyXWc
vec4 erosion(sampler2D tex,vec2 st,vec2 pixel,int radius){
    float invKR=1./float(radius);
    vec4 acc=vec4(1.);
    float w=0.;
    for(int i=-radius;i<=radius;++i)
    for(int j=-radius;j<=radius;++j){
        vec2 rxy=vec2(ivec2(i,j));
        vec2 kst=rxy*invKR;
        vec2 texOffset=st+rxy*pixel;
        float kernel=clamp(1.-dot(kst,kst),0.,1.);
        vec4 t=texture(tex,texOffset);
        vec4 v=t-kernel;
        if(sum(v)<sum(acc)){
            acc=v;
            w=kernel;
        }
    }
    return acc+w;
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    vec4 col=erosion(iChannel0,uv,1./iResolution.xy,5);
    fragColor=col;
}
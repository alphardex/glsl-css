const float PI=3.14159265359;

// rotate
mat2 rotation2d(float angle){
    float s=sin(angle);
    float c=cos(angle);
    
    return mat2(
        c,-s,
        s,c
    );
}

vec2 rotate(vec2 v,float angle){
    return rotation2d(angle)*v;
}

float blendScreen(float base,float blend){
    return 1.-((1.-base)*(1.-blend));
}

vec3 blendScreen(vec3 base,vec3 blend){
    return vec3(blendScreen(base.r,blend.r),blendScreen(base.g,blend.g),blendScreen(base.b,blend.b));
}

float circle(vec2 uv,vec2 p,float r,float blur)
{
    float d=length(uv-p);
    float c=smoothstep(r,r-blur,d);
    return c;
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    
    float offset=.01;
    float speed=5.;
    float stagger=2.;
    float radius=.25;
    float blur=.005;
    float t=iTime*speed;
    
    vec2 p1=uv;
    p1-=.5;
    p1-=offset;
    p1=rotate(p1,t);
    p1+=offset;
    float c1=circle(p1,vec2(0.),radius,blur);
    vec3 col1=mix(vec3(1.,0.,0.),vec3(0.),1.-c1);
    
    vec2 p2=uv;
    p2-=.5;
    p2-=offset;
    p2=rotate(p2,t+stagger);
    p2+=offset;
    float c2=circle(p2,vec2(0.),radius,blur);
    vec3 col2=mix(vec3(0.,1.,0.),vec3(0.),1.-c2);
    
    vec2 p3=uv;
    p3-=.5;
    p3-=offset;
    p3=rotate(p3,t+stagger*2.);
    p3+=offset;
    float c3=circle(p3,vec2(0.),radius,blur);
    vec3 col3=mix(vec3(0.,0.,1.),vec3(0.),1.-c3);
    
    vec3 c=col1;
    c=blendScreen(c,col2);
    c=blendScreen(c,col3);
    
    fragColor=vec4(c,1.);
}
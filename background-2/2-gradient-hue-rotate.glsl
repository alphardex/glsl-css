const float PI=3.14159265359;

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

vec3 rgb2hsv(in vec3 c){
    vec4 K=vec4(0.,-.33333333333333333333,.6666666666666666666,-1.);
    
    vec4 p=mix(vec4(c.bg,K.wz),vec4(c.gb,K.xy),step(c.b,c.g));
    vec4 q=mix(vec4(p.xyw,c.r),vec4(c.r,p.yzx),step(p.x,c.r));
    
    float d=q.x-min(q.w,q.y);
    float e=1.e-10;
    return vec3(abs(q.z+(q.w-q.y)/(6.*d+e)),d/(q.x+e),q.x);
}

vec3 hsv2rgb(in vec3 hsb){
    vec3 rgb=clamp(abs(mod(hsb.x*6.+vec3(0.,4.,2.),6.)-3.)-1.,0.,1.);
    rgb=rgb*rgb*(3.-2.*rgb);
    return hsb.z*mix(vec3(1.),rgb,hsb.y);
}

vec3 hueShift(in vec3 color,in float amount){
    vec3 hsv=rgb2hsv(color);
    hsv.r+=amount;
    return hsv2rgb(hsv);
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    vec3 col1=vec3(.373,.867,.800);
    vec3 col2=vec3(1.,0.,.302);
    uv-=.5;
    uv=rotate(uv,PI/4.);
    uv+=.5;
    vec3 col12=mix(col1,col2,uv.x);
    vec3 col=hueShift(col12,fract(iTime*.1));
    fragColor=vec4(col,1.);
}
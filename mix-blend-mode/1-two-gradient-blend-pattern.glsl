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

vec3 blendMultiply(vec3 base,vec3 blend){
    return base*blend;
}

vec3 getGrad(vec2 uv){
    vec3 col1=vec3(.969,.639,.482);
    vec3 col2=vec3(1.,.871,.659);
    vec3 col3=vec3(.816,.894,.690);
    vec3 col4=vec3(.486,.773,.816);
    vec3 col5=vec3(0.,.635,.882);
    vec3 col6=vec3(0.,.522,.784);
    vec3 c=col1;
    float ratio=1./6.;
    c=mix(c,col2,step(ratio*1.,uv.y));
    c=mix(c,col3,step(ratio*2.,uv.y));
    c=mix(c,col4,step(ratio*3.,uv.y));
    c=mix(c,col5,step(ratio*4.,uv.y));
    c=mix(c,col6,step(ratio*5.,uv.y));
    return c;
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    
    vec2 p1=uv;
    p1-=.5;
    p1=rotate(p1,-PI/4.);
    p1+=.5;
    p1=fract(p1*4.);
    vec3 col1=getGrad(p1);
    
    vec2 p2=uv;
    p2-=.5;
    p2=rotate(p2,PI/4.);
    p2+=.5;
    p2=fract(p2*4.);
    vec3 col2=getGrad(p2);
    
    // vec3 c=col1;
    // vec3 c=col2;
    vec3 c=blendMultiply(col1,col2);
    
    fragColor=vec4(c,1.);
}
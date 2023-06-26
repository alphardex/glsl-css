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

float sdCircle(vec2 p,float r)
{
    return length(p)-r;
}

float opUnion(float d1,float d2)
{
    return min(d1,d2);
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    
    vec2 p1=uv;
    p1=rotate(p1,PI/4.);
    float d1=sdCircle(p1,.125);
    
    vec2 p2=uv;
    p2.y-=1.;
    p2=rotate(p2,PI/4.);
    float d2=sdCircle(p2,.125);
    
    vec2 p3=uv;
    p3.x-=1.;
    p3=rotate(p3,PI/4.);
    float d3=sdCircle(p3,.125);
    
    vec2 p4=uv;
    p4.x-=1.;
    p4.y-=1.;
    p4=rotate(p4,PI/4.);
    float d4=sdCircle(p4,.125);
    
    float d=1e4;
    d=opUnion(d,d1);
    d=opUnion(d,d2);
    d=opUnion(d,d3);
    d=opUnion(d,d4);
    
    float mask=1.-step(.0,d);
    
    vec2 p5=uv;
    p5-=.5;
    p5=rotate(p5,PI/4.);
    p5+=.5;
    vec3 col=mix(vec3(.129,.475,.961),vec3(.914,.118,.388),p5.x);
    
    vec3 c=mix(col,vec3(1.),mask);
    
    fragColor=vec4(c,1.);
}
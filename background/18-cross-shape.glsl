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

float sdBox(in vec2 p,in vec2 b)
{
    vec2 d=abs(p)-b;
    return length(max(d,0.))+min(max(d.x,d.y),0.);
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    
    vec2 p1=uv;
    float d1=sdBox(p1,vec2(.25));
    float mask1=1.-step(0.,d1);
    
    vec2 p2=uv;
    p2.y-=1.;
    float d2=sdBox(p2,vec2(.25));
    float mask2=1.-step(0.,d2);
    
    vec2 p3=uv;
    p3.x-=1.;
    float d3=sdBox(p3,vec2(.25));
    float mask3=1.-step(0.,d3);
    
    vec2 p4=uv;
    p4.x-=1.;
    p4.y-=1.;
    float d4=sdBox(p4,vec2(.25));
    float mask4=1.-step(0.,d4);
    
    float mask=mask1+mask2+mask3+mask4;
    
    vec3 c=mix(vec3(0.),vec3(1.),mask);
    
    fragColor=vec4(c,1.);
}
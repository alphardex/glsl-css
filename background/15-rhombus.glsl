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

float sdBox(in vec2 p,in vec2 b)
{
    vec2 d=abs(p)-b;
    return length(max(d,0.))+min(max(d.x,d.y),0.);
}

float opUnion(float d1,float d2)
{
    return min(d1,d2);
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    
    vec2 p1=uv;
    p1-=.5;
    p1=rotate(p1,PI/4.);
    p1+=.5;
    float d1=sdBox(p1,vec2(.5));
    float mask1=step(0.,d1);
    
    vec2 p2=uv;
    p2.y=1.-p2.y;
    p2-=.5;
    p2=rotate(p2,PI/4.);
    p2+=.5;
    float d2=sdBox(p2,vec2(.5));
    float mask2=step(0.,d2);
    
    float mask=opUnion(mask1,mask2);
    
    vec3 col=vec3(1.)*mask;
    
    fragColor=vec4(col,1.);
}
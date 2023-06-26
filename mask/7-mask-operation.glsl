float sdCircle(vec2 p,float r)
{
    return length(p)-r;
}

float opUnion(float d1,float d2)
{
    return min(d1,d2);
}

float opIntersection(float d1,float d2)
{
    return max(d1,d2);
}

float opSubtraction(float d1,float d2)
{
    return max(-d1,d2);
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    
    vec2 p1=uv;
    p1-=.5;
    p1.x+=.5;
    p1.y-=.5;
    float d1=sdCircle(p1,1.);
    float mask1=step(0.,d1);
    
    vec2 p2=uv;
    p2-=.5;
    p2.x-=.5;
    p2.y-=.5;
    float d2=sdCircle(p2,1.);
    float mask2=step(0.,d2);
    
    // float mask=opUnion(mask1,mask2);
    // float mask=opIntersection(mask1,mask2);
    // float mask=opSubtraction(mask1,mask2);
    float mask=mask1+mask2;
    
    vec3 col=vec3(1.);
    col*=mask;
    
    fragColor=vec4(col,1.);
}
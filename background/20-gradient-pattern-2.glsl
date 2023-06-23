const float PI=3.14159265359;

float getTheta(vec2 st){
    return atan(st.y,st.x);
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    uv-=.5;
    
    float a=getTheta(uv);
    a=sin(a*900.);
    
    vec3 col=vec3((1.-a));
    
    fragColor=vec4(col,1.);
}
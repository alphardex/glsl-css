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

float getTheta(vec2 st){
    return atan(st.y,st.x);
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    vec2 st=.5-uv;
    
    st=rotate(st,PI/2.);
    
    float a=getTheta(st);
    
    vec3 col=vec3((a+PI)/(PI*2.));
    
    fragColor=vec4(col,1.);
}
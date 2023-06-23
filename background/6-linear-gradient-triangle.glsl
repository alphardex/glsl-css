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

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    uv-=.5;
    uv=rotate(uv,-PI/4.);
    uv+=.5;
    vec3 c=mix(vec3(1.),vec3(1.,0.,0.),1.-step(.5,uv.y));
    fragColor=vec4(c,1.);
}
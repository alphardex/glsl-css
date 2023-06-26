#iChannel0"https://s2.loli.net/2023/03/20/5jmPqdJW7EL2a4X.jpg"
#iChannel1"https://s2.loli.net/2023/03/20/AgKHd6cZkUE9rGO.jpg"

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

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    vec2 p1=uv;
    p1.x=1.-p1.x;
    vec3 tex1=texture(iChannel0,p1).xyz;
    vec2 p2=uv;
    vec3 tex2=texture(iChannel1,p2).xyz;
    vec2 p3=uv;
    p3-=.5;
    p3=rotate(p3,-PI/8.);
    p3+=.5;
    vec3 col=mix(tex1,tex2,smoothstep(.4,.6,p3.x));
    fragColor=vec4(col,1.);
}
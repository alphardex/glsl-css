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

vec4 getFromColor(vec2 uv){
    return texture(iChannel0,uv);
}

vec4 getToColor(vec2 uv){
    return texture(iChannel1,uv);
}

vec4 transition(vec2 uv){
    float progress=iMouse.x/iResolution.x;
    
    float ratio=iResolution.x/iResolution.y;
    
    vec2 p1=uv;
    p1.x=1.-p1.x;
    
    vec2 p2=uv;
    
    vec2 p3=uv;
    p3-=.5;
    p3=rotate(p3,-PI/8.);
    p3+=.5;
    
    float pr=progress*1.4;
    
    return mix(
        getFromColor(p1),
        getToColor(p2),
        1.-smoothstep(pr-.3,pr-.1,p3.x)
    );
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    
    vec4 col=transition(uv);
    
    fragColor=col;
}
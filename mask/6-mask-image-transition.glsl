#iChannel0"https://s2.loli.net/2023/03/20/5jmPqdJW7EL2a4X.jpg"
#iChannel1"https://s2.loli.net/2023/03/20/AgKHd6cZkUE9rGO.jpg"

vec4 getFromColor(vec2 uv){
    return texture(iChannel0,uv);
}

vec4 getToColor(vec2 uv){
    return texture(iChannel1,uv);
}

vec4 transition(vec2 uv){
    float progress=iMouse.x/iResolution.x;
    
    float ratio=iResolution.x/iResolution.y;
    
    return mix(
        getFromColor(uv),
        getToColor(uv),
        1.-step(progress,uv.x)
    );
}

void mainImage(out vec4 fragColor,in vec2 fragCoord)
{
    vec2 uv=fragCoord/iResolution.xy;
    
    vec4 col=transition(uv);
    
    fragColor=col;
}
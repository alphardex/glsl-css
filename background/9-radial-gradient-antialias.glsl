float circle(vec2 uv,vec2 p,float r,float blur)
{
    float d=length(uv-p);
    float c=smoothstep(r,r-blur,d);
    return c;
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    uv-=.5;
    float c=circle(uv,vec2(0.),.3,.01);
    vec3 col=mix(vec3(1.,.922,.231),vec3(.612,.153,.690),c);
    fragColor=vec4(col,1.);
}
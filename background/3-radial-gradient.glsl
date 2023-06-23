void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    uv-=.5;
    float d=length(uv);
    float c=smoothstep(sqrt(.5),0.,d);
    fragColor=vec4(vec3(c),1.);
}
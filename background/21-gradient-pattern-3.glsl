void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    uv-=.5;
    
    float a=length(uv);
    a=sin(a*200.);
    
    vec3 col=mix(vec3(.937,.965,.957),vec3(.945,.169,.937),a);
    
    fragColor=vec4(col,1.);
}
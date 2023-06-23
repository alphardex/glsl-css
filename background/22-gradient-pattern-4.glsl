void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    uv-=.5;
    
    float a=length(uv);
    
    vec3 col=vec3(1.);
    col=mix(col,vec3(.294,.604,.949),sin(a*100.));
    col=mix(col,vec3(.251,.529,.894),sin(a*1000.));
    
    fragColor=vec4(col,1.);
}
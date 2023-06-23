void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    uv.x+=sin(uv.y*20.)*.05;
    vec3 col=mix(vec3(.957,.592,.078),vec3(1.),step(.9,uv.x));
    fragColor=vec4(col,1.);
}
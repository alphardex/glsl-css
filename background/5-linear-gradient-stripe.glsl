void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    vec3 c=mix(vec3(1.),vec3(1.,0.,0.),1.-step(.5,uv.y));
    fragColor=vec4(c,1.);
}
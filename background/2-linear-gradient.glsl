void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    fragColor=vec4(vec3(uv.y),1.);
}
#iChannel0"https://s2.loli.net/2023/03/20/5jmPqdJW7EL2a4X.jpg"

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    vec3 tex=texture(iChannel0,uv).xyz;
    vec3 col=mix(vec3(1.),tex,uv.x);
    fragColor=vec4(col,1.);
}
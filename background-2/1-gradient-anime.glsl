void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    vec3 col1=vec3(1.,.780,0.);
    vec3 col2=vec3(.914,.118,.118);
    vec3 col3=vec3(.435,.153,.690);
    vec3 col12=mix(col1,col2,uv.x);
    vec3 col23=mix(col2,col3,uv.x);
    vec3 col=mix(col12,col23,abs(sin(iTime*.5)));
    fragColor=vec4(col,1.);
}
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    uv.y+=sin(uv.x*6.)*.4;
    uv=fract(uv*16.);
    vec3 col=vec3(.1608,.9765,.0196);
    float lineWidth=.3;
    float lineOpacity=.5;
    vec3 lineColor=vec3(1.,1.,1.);
    vec3 stripe=mix(col,lineColor,1.-step(lineWidth,uv.y));
    col+=stripe*lineOpacity;
    fragColor=vec4(col,1.);
}
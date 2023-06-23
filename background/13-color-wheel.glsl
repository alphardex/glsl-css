const float PI=3.14159265359;

vec3 hsv2rgb(in vec3 hsb){
    vec3 rgb=clamp(abs(mod(hsb.x*6.+vec3(0.,4.,2.),6.)-3.)-1.,0.,1.);
    rgb=rgb*rgb*(3.-2.*rgb);
    return hsb.z*mix(vec3(1.),rgb,hsb.y);
}

float circle(vec2 uv,vec2 p,float r,float blur)
{
    float d=length(uv-p);
    float c=smoothstep(r,r-blur,d);
    return c;
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    uv-=.5;
    float angle=atan(uv.y,uv.x);
    float hueShift=((angle-PI/2.)*-1.)/(2.*PI);
    vec3 col=hsv2rgb(vec3(hueShift,1.,1.));
    
    float c=circle(uv,vec2(0.),.4,.01);
    col=mix(vec3(1.),col,c);
    
    fragColor=vec4(col,1.);
}
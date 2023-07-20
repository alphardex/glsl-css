#define AASIZE 2.
#define BGCOUNT 7

const float PI=3.14159265359;

// utils
// rotate
mat2 rotation2d(float angle){
    float s=sin(angle);
    float c=cos(angle);
    
    return mat2(
        c,-s,
        s,c
    );
}

vec2 rotate(vec2 v,float angle){
    return rotation2d(angle)*v;
}

float getTheta(vec2 st){
    return atan(st.y,st.x);
}

float sdBox(in vec2 p,in vec2 b)
{
    vec2 d=abs(p)-b;
    return length(max(d,0.))+min(max(d.x,d.y),0.);
}

float opUnion(float d1,float d2)
{
    return min(d1,d2);
}

vec3 rgb2hsv(in vec3 c){
    vec4 K=vec4(0.,-.33333333333333333333,.6666666666666666666,-1.);
    
    vec4 p=mix(vec4(c.bg,K.wz),vec4(c.gb,K.xy),step(c.b,c.g));
    vec4 q=mix(vec4(p.xyw,c.r),vec4(c.r,p.yzx),step(p.x,c.r));
    
    float d=q.x-min(q.w,q.y);
    float e=1.e-10;
    return vec3(abs(q.z+(q.w-q.y)/(6.*d+e)),d/(q.x+e),q.x);
}

vec3 hsv2rgb(in vec3 hsb){
    vec3 rgb=clamp(abs(mod(hsb.x*6.+vec3(0.,4.,2.),6.)-3.)-1.,0.,1.);
    rgb=rgb*rgb*(3.-2.*rgb);
    return hsb.z*mix(vec3(1.),rgb,hsb.y);
}

vec3 hueShift(in vec3 color,in float amount){
    vec3 hsv=rgb2hsv(color);
    hsv.r+=amount;
    return hsv2rgb(hsv);
}

vec3 blendMultiply(vec3 base,vec3 blend){
    return base*blend;
}

float blendScreen(float base,float blend){
    return 1.-((1.-base)*(1.-blend));
}

vec3 blendScreen(vec3 base,vec3 blend){
    return vec3(blendScreen(base.r,blend.r),blendScreen(base.g,blend.g),blendScreen(base.b,blend.b));
}

float circle(vec2 uv,vec2 p,float r,float blur)
{
    float d=length(uv-p);
    float c=smoothstep(r,r-blur,d);
    return c;
}

highp float random(vec2 co)
{
    highp float a=12.9898;
    highp float b=78.233;
    highp float c=43758.5453;
    highp float dt=dot(co.xy,vec2(a,b));
    highp float sn=mod(dt,3.14);
    return fract(sin(sn)*c);
}

float remap(float a,float b,float c,float d,float t)
{
    return clamp((t-a)/(b-a),0.,1.)*(d-c)+c;
}

// raymarching
float sdSphere(vec3 p,float s)
{
    return length(p)-s;
}

float sdCappedTorus(vec3 p,vec2 sc,float ra,float rb)
{
    p.x=abs(p.x);
    float k=(sc.y*p.x>sc.x*p.y)?dot(p.xy,sc):length(p.xy);
    return sqrt(dot(p,p)+ra*ra-2.*ra*k)-rb;
}

vec2 opUnion(vec2 d1,vec2 d2)
{
    return(d1.x<d2.x)?d1:d2;
}

float opSmoothUnion(float d1,float d2,float k)
{
    float h=max(k-abs(d1-d2),0.);
    return min(d1,d2)-h*h*.25/k;
}

float opIntersection(float d1,float d2)
{
    return max(d1,d2);
}

float opSmoothIntersection(float d1,float d2,float k)
{
    float h=max(k-abs(d1-d2),0.);
    return max(d1,d2)+h*h*.25/k;
}

float opSubtraction(float d1,float d2)
{
    return max(-d1,d2);
}

float opSmoothSubtraction(float d1,float d2,float k)
{
    float h=max(k-abs(-d1-d2),0.);
    return max(-d1,d2)+h*h*.25/k;
}

float diffuse(vec3 n,vec3 l){
    float diff=clamp(dot(n,l),0.,1.);
    return diff;
}

float specular(vec3 n,vec3 l,float shininess){
    float spec=pow(clamp(dot(n,l),0.,1.),shininess);
    return spec;
}

float fresnel(float bias,float scale,float power,vec3 I,vec3 N)
{
    return bias+scale*pow(1.+dot(I,N),power);
}

const float gamma=2.2;

float toGamma(float v){
    return pow(v,1./gamma);
}

vec2 toGamma(vec2 v){
    return pow(v,vec2(1./gamma));
}

vec3 toGamma(vec3 v){
    return pow(v,vec3(1./gamma));
}

vec4 toGamma(vec4 v){
    return vec4(toGamma(v.rgb),v.a);
}

// functions
vec3 getGrad(vec2 uv){
    vec3 col1=vec3(.969,.639,.482);
    vec3 col2=vec3(1.,.871,.659);
    vec3 col3=vec3(.816,.894,.690);
    vec3 col4=vec3(.486,.773,.816);
    vec3 col5=vec3(0.,.635,.882);
    vec3 col6=vec3(0.,.522,.784);
    vec3 c=col1;
    float ratio=1./6.;
    c=mix(c,col2,step(ratio*1.,uv.y));
    c=mix(c,col3,step(ratio*2.,uv.y));
    c=mix(c,col4,step(ratio*3.,uv.y));
    c=mix(c,col5,step(ratio*4.,uv.y));
    c=mix(c,col6,step(ratio*5.,uv.y));
    return c;
}

// bgs
vec4 bg1(vec2 uv){
    uv-=.5;
    uv=rotate(uv,-PI/4.);
    uv+=.5;
    uv=fract(uv*16.);
    vec3 c=mix(vec3(1.),vec3(.941,.416,.055),1.-step(.5,uv.y));
    return vec4(c,1.);
}

vec4 bg2(vec2 uv){
    vec2 st=.5-uv;
    
    st=rotate(st,PI/2.);
    
    float a=getTheta(st);
    
    vec3 col=mix(vec3(.604,.804,.196),vec3(1.,.078,.576),(a+PI)/(PI*2.));
    
    return vec4(col,1.);
}

vec4 bg3(vec2 uv){
    uv=fract(uv*5.);
    
    vec2 p1=uv;
    p1-=.5;
    p1=rotate(p1,PI/4.);
    p1+=.5;
    float d1=sdBox(p1,vec2(.5));
    
    vec2 p2=uv;
    p2.y=1.-p2.y;
    p2-=.5;
    p2=rotate(p2,PI/4.);
    p2+=.5;
    float d2=sdBox(p2,vec2(.5));
    
    float d=opUnion(d1,d2);
    
    float mask=step(0.,d);
    
    vec3 col=vec3(1.)*mask;
    
    return vec4(col,1.);
}

vec4 bg4(vec2 uv){
    vec2 st=.5-uv;
    
    st=rotate(st,PI/2.);
    
    float a=getTheta(st);
    a=mod(a,PI/6.);
    
    vec3 col=mix(vec3(.604,.804,.196),vec3(1.,.078,.576),step(1./24.,(a)/(PI*2.)));
    
    return vec4(col,1.);
}

vec4 bg5(vec2 uv){
    uv-=.5;
    
    float a=length(uv);
    a=sin(a*200.);
    
    vec3 col=mix(vec3(.937,.965,.957),vec3(.945,.169,.937),a);
    
    return vec4(col,1.);
}

vec4 bg6(vec2 uv){
    vec3 col1=vec3(.373,.867,.800);
    vec3 col2=vec3(1.,0.,.302);
    uv-=.5;
    uv=rotate(uv,PI/4.);
    uv+=.5;
    vec3 col12=mix(col1,col2,uv.x);
    vec3 col=hueShift(col12,fract(iTime*.1));
    return vec4(col,1.);
}

vec4 bg7(vec2 uv){
    vec2 p1=uv;
    p1-=.5;
    p1=rotate(p1,-PI/4.);
    p1+=.5;
    p1=fract(p1*4.);
    vec3 col1=getGrad(p1);
    
    vec2 p2=uv;
    p2-=.5;
    p2=rotate(p2,PI/4.);
    p2+=.5;
    p2=fract(p2*4.);
    vec3 col2=getGrad(p2);
    
    // vec3 c=col1;
    // vec3 c=col2;
    vec3 c=blendMultiply(col1,col2);
    
    return vec4(c,1.);
}

// main
vec4 getBg(vec2 uv,int frame){
    if(frame==0){
        return bg1(uv);
    }else if(frame==1){
        return bg2(uv);
    }else if(frame==2){
        return bg3(uv);
    }else if(frame==3){
        return bg4(uv);
    }else if(frame==4){
        return bg5(uv);
    }else if(frame==5){
        return bg6(uv);
    }else if(frame==6){
        return bg7(uv);
    }
}

vec4 getRandBg(vec2 uv){
    // float ratio=iResolution.x/iResolution.y;
    // uv.x*=ratio;
    
    int frame=int(iTime);
    
    int currentFrame=0;
    currentFrame=frame%BGCOUNT;
    vec4 randBg=getBg(uv,currentFrame);
    return randBg;
}

// raymarching
vec2 map(vec3 p){
    vec2 d=vec2(1e10,0.);
    
    float bounce=abs(sin(iTime*PI));
    float y=-bounce+.5;
    p.y+=y;
    
    float scaleX=remap(0.,1.,1.25,1.,bounce);
    p.x/=scaleX;
    
    float scaleY=remap(0.,1.,.75,1.,bounce);
    p.y/=scaleY;
    
    vec3 p1=p;
    
    float d1=sdSphere(p1,.5)*scaleX*scaleY;
    d=opUnion(d,vec2(d1,1.));
    
    vec3 p2=p;
    p2+=vec3(.15,-.2,.34);
    float d2=sdSphere(p2,.1);
    d=opUnion(d,vec2(d2,2.));
    
    vec3 p3=p;
    p3+=vec3(-.15,-.2,.34);
    float d3=sdSphere(p3,.1);
    d=opUnion(d,vec2(d3,2.));
    
    vec3 p4=p;
    p4.y*=-1.;
    p4+=vec3(0.,.15,.45);
    float angle=PI/4.;
    float d4=sdCappedTorus(p4,vec2(sin(angle),cos(angle)),.4,.025);
    d=opUnion(d,vec2(d4,2.));
    
    return d;
}

vec3 calcNormal(vec3 pos,float eps){
    const vec3 v1=vec3(1.,-1.,-1.);
    const vec3 v2=vec3(-1.,-1.,1.);
    const vec3 v3=vec3(-1.,1.,-1.);
    const vec3 v4=vec3(1.,1.,1.);
    
    return normalize(v1*map(pos+v1*eps).x+
    v2*map(pos+v2*eps).x+
    v3*map(pos+v3*eps).x+
    v4*map(pos+v4*eps).x);
}

vec3 calcNormal(vec3 pos){
    return calcNormal(pos,.002);
}

float softshadow(in vec3 ro,in vec3 rd,in float mint,in float tmax)
{
    float res=1.;
    float t=mint;
    for(int i=0;i<16;i++)
    {
        float h=map(ro+rd*t).x;
        res=min(res,8.*h/t);
        t+=clamp(h,.02,.10);
        if(h<.001||t>tmax)break;
    }
    return clamp(res,0.,1.);
}

vec3 material(vec3 col,vec3 normal,float m){
    col=vec3(1.);
    
    if(m==1.){
        col=vec3(1.,.6824,0.);
    }
    
    if(m==2.){
        col=vec3(.1137,.0588,.0039);
    }
    
    return col;
}

vec3 lighting(in vec3 col,in vec3 pos,in vec3 rd,in vec3 nor){
    vec3 lin=vec3(0.);
    
    // reflection
    vec3 ref=reflect(rd,nor);
    
    // ao
    float occ=1.;
    
    // sun
    {
        // pos
        vec3 lig=normalize(vec3(-.5,.4,-.6));
        // dir
        vec3 hal=normalize(lig-rd);
        // diffuse
        float dif=diffuse(nor,lig);
        // softshadow
        dif*=softshadow(pos,lig,.02,2.5);
        // specular
        float spe=specular(nor,hal,16.);
        spe*=dif;
        // fresnel
        spe*=fresnel(.04,.96,5.,-lig,hal);
        // apply
        lin+=col*2.20*dif*vec3(1.30,1.,.70);
        lin+=5.*spe;
    }
    // sky
    {
        // diffuse
        float dif=sqrt(clamp(.5+.5*nor.y,0.,1.));
        // ao
        dif*=occ;
        // specular
        float spe=smoothstep(-.2,.2,ref.y);
        spe*=dif;
        // fresnel
        spe*=fresnel(.04,.96,5.,rd,nor);
        // softshadow
        spe*=softshadow(pos,ref,.02,2.5);
        // apply
        lin+=col*.60*dif;
        lin+=2.*spe;
    }
    // back
    {
        // diff
        float dif=diffuse(nor,normalize(vec3(.5,0.,.6)))*clamp(1.-pos.y,0.,1.);
        // ao
        dif*=occ;
        // apply
        lin+=col*.55*dif;
    }
    // sss
    {
        // fresnel
        float dif=fresnel(0.,1.,2.,rd,nor);
        // ao
        dif*=occ;
        // apply
        lin+=col*.25*dif;
    }
    
    return lin;
}

vec2 raycast(vec3 ro,vec3 rd){
    vec2 res=vec2(-1.,-1.);
    
    float depth=0.;
    for(int i=0;i<128;i++){
        vec3 p=ro+rd*depth;
        
        vec2 t=map(p);
        float d=t.x;
        float m=t.y;
        
        // hit
        if(d<.0001){
            res=vec2(depth,m);
            break;
        }
        
        depth+=d;
    }
    
    return res;
}

vec3 render(vec3 ro,vec3 rd,vec2 uv){
    vec3 col=vec3(0.);
    
    vec2 res=raycast(ro,rd);
    float d=res.x;
    float m=res.y;
    
    // skybox
    // col=vec3(.4,.7,1.)-(rd.y*.7);
    col=getRandBg(uv).xyz;
    
    if(m>-.5){
        vec3 p=ro+d*rd;
        
        vec3 nor=calcNormal(p);
        col=material(col,nor,m);
        col=lighting(col,p,normalize(-ro),nor);
        col=toGamma(col);
    }
    
    return col;
}

vec3 getSceneColor(vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    
    // uv (0,1) -> (-1,1)
    vec2 p=uv;
    p=2.*p-1.;
    p.x*=iResolution.x/iResolution.y;
    
    // camera
    vec3 ca=vec3(0.,0.,-5.);
    float z=4.;
    vec3 rd=normalize(vec3(p,z));
    
    // raymarch
    vec3 col=render(ca,rd,uv);
    
    return col;
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec3 tot=vec3(0.);
    
    float AA_size=AASIZE;
    float count=0.;
    for(float aaY=0.;aaY<AA_size;aaY++)
    {
        for(float aaX=0.;aaX<AA_size;aaX++)
        {
            tot+=getSceneColor(fragCoord+vec2(aaX,aaY)/AA_size);
            count+=1.;
        }
    }
    tot/=count;
    
    fragColor=vec4(tot,1.);
}

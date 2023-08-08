#iChannel0"https://s2.loli.net/2023/03/20/5jmPqdJW7EL2a4X.jpg"

mat2 rotation2d(float angle){
    float s=sin(angle);
    float c=cos(angle);
    
    return mat2(
        c,-s,
        s,c
    );
}

mat4 rotation3d(vec3 axis,float angle){
    axis=normalize(axis);
    float s=sin(angle);
    float c=cos(angle);
    float oc=1.-c;
    
    return mat4(
        oc*axis.x*axis.x+c,oc*axis.x*axis.y-axis.z*s,oc*axis.z*axis.x+axis.y*s,0.,
        oc*axis.x*axis.y+axis.z*s,oc*axis.y*axis.y+c,oc*axis.y*axis.z-axis.x*s,0.,
        oc*axis.z*axis.x-axis.y*s,oc*axis.y*axis.z+axis.x*s,oc*axis.z*axis.z+c,0.,
        0.,0.,0.,1.
    );
}

vec2 rotate(vec2 v,float angle){
    return rotation2d(angle)*v;
}

vec3 rotate(vec3 v,vec3 axis,float angle){
    return(rotation3d(axis,angle)*vec4(v,1.)).xyz;
}

float sdBox(in vec2 p,in vec2 b)
{
    vec2 d=abs(p)-b;
    return length(max(d,0.))+min(max(d.x,d.y),0.);
}

float sdBox(vec3 p,vec3 b)
{
    vec3 q=abs(p)-b;
    return length(max(q,0.))+min(max(q.x,max(q.y,q.z)),0.);
}

float opUnion(float d1,float d2)
{
    return min(d1,d2);
}

vec2 opUnion(vec2 d1,vec2 d2)
{
    return(d1.x<d2.x)?d1:d2;
}

vec2 map(vec3 p){
    vec2 d=vec2(1e10,0.);
    
    vec2 m=(iMouse.xy-iResolution.xy*.5)/iResolution.xy;
    vec3 p1=p;
    p1.z-=.2;
    float tilt=.5;
    p1=rotate(p1,vec3(0.,1.,0.),m.x*tilt);
    p1=rotate(p1,vec3(1.,0.,0.),m.y*tilt);
    float d1=sdBox(p1,vec3(.4,.4,.001));
    d=opUnion(d,vec2(d1,1.));
    vec3 p2=p;
    float d2=sdBox(p2,vec3(1.,1.,.001));
    d=opUnion(d,vec2(d2,2.));
    return d;
}

vec3 calcNormal(in vec3 p)
{
    const float h=.0001;
    const vec2 k=vec2(1,-1);
    return normalize(k.xyy*map(p+k.xyy*h).x+
    k.yyx*map(p+k.yyx*h).x+
    k.yxy*map(p+k.yxy*h).x+
    k.xxx*map(p+k.xxx*h).x);
}

float gaussian(vec2 d,float sigma){
    return exp(-(d.x*d.x+d.y*d.y)/(2.*sigma*sigma));
}

vec4 gaussianBlur2D(in sampler2D tex,in vec2 st,in vec2 offset,const int kernelSize){
    vec4 accumColor=vec4(0.);
    
    #define GAUSSIANBLUR2D_KERNELSIZE 20
    float kernelSizef=float(kernelSize);
    
    float accumWeight=0.;
    const float k=.15915494;// 1 / (2*PI)
    vec2 xy=vec2(0.);
    for(int j=0;j<GAUSSIANBLUR2D_KERNELSIZE;j++){
        if(j>=kernelSize)
        break;
        xy.y=-.5*(kernelSizef-1.)+float(j);
        for(int i=0;i<GAUSSIANBLUR2D_KERNELSIZE;i++){
            if(i>=kernelSize)
            break;
            xy.x=-.5*(kernelSizef-1.)+float(i);
            float weight=(k/kernelSizef)*gaussian(xy,kernelSizef);
            accumColor+=weight*texture(tex,st+xy*offset);
            accumWeight+=weight;
        }
    }
    return accumColor/accumWeight;
}

vec3 render(vec2 uv){
    vec3 col=vec3(0.);
    
    vec4 tex=texture(iChannel0,uv);
    vec4 blurTex=gaussianBlur2D(iChannel0,uv,1./iResolution.xy,10);
    
    uv=(uv-.5)*2.;
    
    vec3 ro=vec3(0.,0.,1.);
    vec3 rd=normalize(vec3(uv,0.)-ro);
    
    float depth=0.;
    for(int i=0;i<64;i++){
        vec3 p=ro+rd*depth;
        vec2 t=map(p);
        float d=t.x;
        float m=t.y;
        depth+=d;
        
        if(d<.01){
            // col=vec3(1.);
            vec3 normal=calcNormal(p);
            
            vec3 objectColor=vec3(1.);
            if(m==1.){
                objectColor=blurTex.xyz;
            }else if(m==2.){
                objectColor=tex.xyz;
            }
            vec3 lightColor=vec3(1.,1.,1.);
            
            if(m==1.){
                float ambIntensity=.1;
                vec3 ambient=lightColor*ambIntensity;
                col+=ambient*objectColor;
                
                // diffuse
                vec3 lightPos=vec3(20.);
                vec3 lightDir=normalize(lightPos-p);
                float diff=dot(normal,lightDir);
                diff=max(diff,0.);
                vec3 diffuse=lightColor*diff;
                col+=diffuse*objectColor;
                
                // specular
                vec3 reflectDir=reflect(-lightDir,normal);
                vec3 viewDir=normalize(ro-p);
                // float spec=dot(viewDir,reflectDir);
                vec3 halfVec=normalize(lightDir+viewDir);
                float spec=dot(normal,halfVec);
                spec=max(spec,0.);
                float shininess=32.;
                spec=pow(spec,shininess);
                vec3 specular=lightColor*spec;
                col+=specular*objectColor;
            }else if(m==2.){
                // ambient
                // float ambIntensity=.2;
                float ambIntensity=1.;
                vec3 ambient=lightColor*ambIntensity;
                col+=ambient*objectColor;
            }
            
            break;
        }
    }
    
    return col;
}

vec3 getSceneColor(vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    vec3 col=render(uv);
    return col;
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec3 tot=vec3(0.);
    
    float AA_size=2.;
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
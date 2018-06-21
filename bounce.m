clear;
clf;
subplot(1,2,1)
N=200;
R=10;
size=500;
rec_size=size-R;
axis equal
axis([0,size,0,size])
dt=0.01;
velocity =80;

%set V direction
vec_v(N,2)=0;
for k=1:N
    theta = 2*pi*rand();
    vec_v(k,:)=velocity*[cos(theta),sin(theta)];
end

%set rectangle position
pos(1,:)=(rec_size)*rand(1,2);   %first ball
index=1;
while index<N  
    temp=rec_size*rand(1,2);
    
    for k=1:index;
        
        if sum((temp-pos(k,:)).^2,2)>R^2
            test=true;
        else
            test=false;
            break
        end  
    end
    if test==true
        index=index+1;
        pos(index,:)=temp;
        
    end 
end

%draw initial poisoition
ball(1:N,1)=0;
for k=1:N 
    ball(k)=rectangle('Position',[pos(k,1),pos(k,2),R,R],...
        'Curvature',[1,1],...
        'Facecolor','r',...
        'LineStyle','none');
end

%update position
tt=0;
while true
    t=tic();
    
    for k=1:N
        set(ball(k),'Position',[pos(k,1),pos(k,2),R,R]);
    end
    
    %ball to wall
    for k=1:N 
        
        if pos(k,1)>rec_size
            vec_v(k,1)=-vec_v(k,1);
            pos(k,1)=rec_size;
        elseif pos(k,1)<0
            vec_v(k,1)=-vec_v(k,1);
            pos(k,1)=0;
            
        elseif pos(k,2) >rec_size 
            vec_v(k,2)=-vec_v(k,2);
            pos(k,2)=rec_size;
        elseif pos(k,2)<0
            vec_v(k,2)=-vec_v(k,2);
            pos(k,2)=0;
        end
    end
    
    %ball to ball
    for i=1:N-1
        for j=1+i:N
            %test for whather ball_i collide to ball_j
            vec_s=pos(j,:)-pos(i,:);
            S=sqrt(sum(vec_s.^2));
            
            if S <= R 
                
                V_is=dot(vec_v(i,:),vec_s)/S;
                V_js=dot(vec_v(j,:),vec_s)/S;
                
                % velocity value in line of center direction. (abbr.V_s)
                % if V_is bigger than V_js 
                % then ball_i collide to ball_j
                if V_is>V_js
                    unit_s = vec_s/S;
                    vec_vis = V_is*unit_s;
                    vec_vjs = V_js*unit_s;
                           
                    vec_v(i,:) = vec_v(i,:) - vec_vis + vec_vjs;
                    vec_v(j,:) = vec_v(j,:) - vec_vjs + vec_vis;
                end
            end
        end
    end
   
    pos=pos+ vec_v*dt;
    
   
    subplot(1,2,2);
    V=sqrt(sum(vec_v.^2,2));
    p=0:2:250;
    hist(V,p);
    ylim([0 18])
    xlim([0 250])

    pause(0.001)
    
    tt=toc(t)
    
end



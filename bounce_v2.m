%%
clear;
N=200; % Number of the ball
D=15;  % Diameter
R=D/2; % Radius
Size=500; % box size
Sep_x= 10; % the classify function is on beta 
Sep_y= 10; % have better let sep_x sep_y in same
dt=0.01;
velocity =80;

%set V direction
vec_v(N,2)=0;
for k=1:N
    theta = 2*pi*rand();
    vec_v(k,:)=velocity*[cos(theta),sin(theta)];
end

%set rectangle position
rec_size=Size-D;
pos(1,:)=(rec_size)*rand(1,2);   %first ball
index=1;
while index<N  
    temp=rec_size*rand(1,2);
    
    for k=1:index
       
        if sum((temp-pos(k,:)).^2,2)>D^2
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

%shift positions to center of balls
for k=1:N
    pos(k,:)=pos(k,:)+R;
end


%draw initial poisoition
clf;
subplot(1,2,1)
axis equal
axis([0,Size,0,Size])
ball(N,1)=0;
for k=1:N 
    ball(k)=rectangle('Position',[pos(k,1)-R,pos(k,2)-R,D,D],...
        'Curvature',[1,1],...
        'Facecolor','r',...
        'LineStyle','none');
end

%test for correction of blocks
blocks = classify(Size,Size,Sep_x,Sep_y,pos,R);

%%

%update positions
while true
    t=tic();
    
    for k=1:N
        set(ball(k),'Position',[pos(k,1)-R,pos(k,2)-R,D,D]);
    end
    
    pos = pos+ vec_v*dt;
    
    %collide to wall first 
    %in order to prevent exceed the block cells
    for k=1:N
        if pos(k,1)+R >= Size
            vec_v(k,1)= -vec_v(k,1);
            pos(k,1)= Size-R;
        elseif pos(k,1)-R <= 0
            vec_v(k,1)= -vec_v(k,1);
            pos(k,1)= R ;
        end
        
        if pos(k,2)+R >= Size
            vec_v(k,2)= -vec_v(k,2);
            pos(k,2)= Size-R;
        elseif pos(k,2)-R <= 0
            vec_v(k,2)= -vec_v(k,2);
            pos(k,2)= R;
        end
    end
    
    %classify balls into different blocks
    blocks = classify(Size,Size,Sep_x,Sep_y,pos,R);
    
    for k = 1:Sep_x
        for m =1:Sep_y
           %detect collision in block{k,m}
           group = blocks{k,m};
           num = length(group);
           for index = 1:num-1
               i= group(index);
               
               for jndex = 1+index :num
                   j= group(jndex);
                   
                   vec_s = pos(j,:)-pos(i,:);
                   S=sqrt(sum(vec_s.^2));
                   
                   if S <= D
                       V_is = dot(vec_v(i,:),vec_s)/S;
                       V_js = dot(vec_v(j,:),vec_s)/S;
                       
                       if V_is > V_js
                           unit_s = vec_s/S;
                           vec_vis = V_is*unit_s;
                           vec_vjs = V_js*unit_s;
                           
                           vec_v(i,:) = vec_v(i,:) - vec_vis + vec_vjs;
                           vec_v(j,:) = vec_v(j,:) - vec_vjs + vec_vis;
                       end
                   end
               end
           end
        end
    end

    subplot(1,2,2);
    V=sqrt(sum(vec_v.^2,2));
    p=0:2:250;
    hist(V,p);
    ylim([0 18])
    xlim([0 250])
    
    
    pause(0.001)
    tt=toc(t)
end

function blocks = classify(size_x,size_y,sep_x,sep_y,pos,R)
N=length(pos);
k_x= size_x/sep_x;
k_y= size_y/sep_y;
blocks = cell(sep_x,sep_y);  

for i= 1:N
    room_x = ceil(pos(i,1)/k_x);
    room_y = ceil(pos(i,2)/k_y);
    blocks{room_x ,room_y} = [ blocks{room_x ,room_y} , i];
    % big bracket for indexing cell
    
    
% the folling algorithm only works as k_x or k_y > 2R
% this constraint prevent a ball from crossing the line in one direction twice 
    room_x_plus = ceil( (pos(i,1)+R) /k_x );
    room_x_minus =ceil( (pos(i,1)-R) /k_x ); 
    room_y_plus = ceil( (pos(i,2)+R) /k_y );
    room_y_minus =ceil( (pos(i,2)-R) /k_y );
    
    inc_x =0;  
    inc_y =0;
    %if x direction cross the line
    if room_x_plus ~= room_x && room_x ~= sep_x
        inc_x =1;
        blocks{room_x+inc_x ,room_y} = [ blocks{room_x+inc_x ,room_y} ,i];
    elseif room_x_minus ~= room_x && room_x ~= 1
        inc_x=-1;
        blocks{room_x+inc_x ,room_y} = [ blocks{room_x+inc_x ,room_y} ,i];
    end
    
    
    %if y direction cross the line
    if room_y_plus ~= room_y && room_y ~=sep_y
        inc_y=1;
        blocks{room_x ,room_y+inc_y} = [ blocks{room_x ,room_y+inc_y} ,i];
    elseif room_y_minus ~=room_y && room_y ~=1
        inc_y=-1;
        blocks{room_x ,room_y+inc_y} = [ blocks{room_x ,room_y+inc_y} ,i];
    end
        
    if inc_x~=0 && inc_y~=0
        blocks{room_x+inc_x ,room_y+inc_y} = [ blocks{room_x+inc_x ,room_y+inc_y} ,i];
    end
     
end
blocks = blocks'; 


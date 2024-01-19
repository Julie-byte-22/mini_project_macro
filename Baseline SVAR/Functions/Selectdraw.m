% Select the median-target draw:

resp_median=prctile(candidateirf,50,4);

distance_med=zeros(n,n,hor,drawfin);

for h=1:hor
    
   for k=1:drawfin
       
       for variable=1:n
           
           for shock=1:n
       
       distance_med(variable,shock,h,k)=((candidateirf(variable,shock,h,k)-resp_median(variable,shock,h))/nanstd(squeeze(candidateirf(variable,shock,h,:)))).^2;
          
           end
           
       end
   end
   
end

distance=squeeze(nansum(sum(nansum(distance_med(1:n,1:n,:,:),1),2),3));

for k=1:drawfin
    
if distance(k)==0
    distance(k)=NaN;
end

end

distance_min=mink(distance,1);

solution=find(distance==min(distance_min)); % Median-target draw
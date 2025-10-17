

---- Created By Shailesh ---

create proc GetRateNameMapList  
as   
begin  
  
 select Id,  RateCode+ ' - '+ Label as RateName from Hotel_RateCode_Master    
  
  
end  
  
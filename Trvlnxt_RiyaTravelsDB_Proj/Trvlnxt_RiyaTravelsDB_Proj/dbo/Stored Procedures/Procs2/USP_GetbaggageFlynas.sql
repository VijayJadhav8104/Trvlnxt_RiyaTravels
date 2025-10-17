  
 CREATE procedure USP_GetbaggageFlynas                                          
 @Carrier varchar(10)
 as                        
begin                    
 begin          
 select * from tblbaggagedetails                        
  where IsActive=0 and Carrier=@Carrier                
 end                          
end 
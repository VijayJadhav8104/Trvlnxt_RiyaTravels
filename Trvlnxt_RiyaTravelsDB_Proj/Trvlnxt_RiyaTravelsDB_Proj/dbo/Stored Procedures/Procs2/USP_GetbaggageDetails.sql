                                                
 CREATE procedure USP_GetbaggageDetails                          
 @Travelfrom nvarchar(20),                              
 @Travelto nvarchar(20) ,                            
 @Carrier varchar(10),    
 @DepartureDate varchar(30) = null  
 as                              
begin                              
                             
declare @FromCountryCode nvarchar(20)                              
declare @ToCountryCode nvarchar(20)                              
set @FromCountryCode=(select Country from tblAirportCity where code=@Travelfrom)                              
set @ToCountryCode=(select Country from tblAirportCity where code=@Travelto)                              
                           
declare @checksector varchar(10) = ''                        
if(@FromCountryCode='IN')-- AND @ToCountryCode='IN')      --commented by dhanraj                    
begin                        
 SET @checksector = 'IN'                        
end                        
                        
if(@FromCountryCode='IN' and @ToCountryCode='IN' and @Carrier !='XY')                              
 begin                              
  select *,@checksector as checksector from tblbaggagedetails                             
  where FromSector ='Domestic' and Tosector='Domestic'                            
  and IsActive=1 and Carrier=@Carrier                            
 end                              
 else if(@Carrier !='XY' and @Carrier!='SG')                           
 begin                              
  select  *,@checksector as checksector from tblbaggagedetails                              
  where FromCountry =@FromCountryCode                            
  and ToCountry=@ToCountryCode                             
  and IsActive=1 and Carrier=@Carrier                            
 end          
 else IF @Carrier ='SG'      
 begin      
 if @FromCountryCode !='IN' and @ToCountryCode != 'IN'      
 begin                              
  select  *,@checksector as checksector from tblbaggagedetails                              
  where FromSector ='International'                           
  and Tosector ='International'      
  and IsActive=1 and Carrier=@Carrier                            
 end             
 else if @FromCountryCode !='IN'      
 begin          
 if @Travelfrom='DXB' and convert(date ,@DepartureDate) < '2025-07-16'  
 begin  
  select '25 Kg' as 'Weight',@checksector as checksector   
  --from tblbaggagedetails                              
  --where FromSector =@Travelfrom                            
  --and ToCountry=@ToCountryCode                             
  --and IsActive=1 and Carrier=@Carrier                            
 end   
 else  
 begin  
 select  *,@checksector as checksector from tblbaggagedetails                              
 where FromSector =@Travelfrom                            
 and ToCountry=@ToCountryCode                             
 and IsActive=1 and Carrier=@Carrier   
 end  
 end  
 else if @FromCountryCode ='IN'      
 begin                              
  select  *,@checksector as checksector from tblbaggagedetails                              
  where FromCountry =@FromCountryCode                            
  and Tosector=@Travelto                             
  and IsActive=1 and Carrier=@Carrier                            
 end           
 end      
if(@Carrier ='XY')                
 begin                
 select *,@checksector as checksector from tblbaggagedetails                              
  where FromSector =@Travelfrom                            
  and Tosector=@Travelto                             
  and IsActive=1 and Carrier=@Carrier                  
  and ProductClass in(select ProductClass from mFareTypeByAirline where Airline=@Carrier)                
 end                                
end 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_GetbaggageDetails] TO [rt_read]
    AS [dbo];


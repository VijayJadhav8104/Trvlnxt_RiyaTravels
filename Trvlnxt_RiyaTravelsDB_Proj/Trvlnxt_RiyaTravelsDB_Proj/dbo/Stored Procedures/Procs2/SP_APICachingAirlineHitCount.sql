    
CREATE procedure SP_APICachingAirlineHitCount                
@Origin varchar(50)                  
,@Destination varchar(50)                   
,@OfficeID varchar(50)                  
,@Caching bit    
,@Environment varchar(100) = ''
,@TrackID varchar(MAX) = ''
as                      
begin                      
                                         
  insert into APICachingAirlineHitCount (Origin,Destination,OfficeID,Caching,Environment,TrackID)                    
  Values (@Origin,@Destination,@OfficeID,@Caching,@Environment,@TrackID)                    
               
End
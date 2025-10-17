CREATE procedure SP_APIGetSessionToken  -- SP_APIGetSessionToken '20240724174346086891_fc48c817-1183-4ab4-af39-36ef71f54028','S20240724174514071057_ffdbb1fe-2ecd-46b1-a538-b57d78a296f5'            
@TrackID varchar(255) = ''    
,@SellKey varchar(255) = ''      
as                
begin              
    
if(@SellKey = '' OR @SellKey = 'null' or @SellKey is null)  
 begin  
  select top 1 SessionToken,AgentID,FlightKey From APIBookingAuthentication where TrackID = @TrackID           
 end  
 else  
   
 begin  
  select  top 1 APIBook_Internal.SessionToken,APIBook.AgentID,APIBook_Internal.FlightKey  
  From APIBookingAuthentication as APIBook inner join APIBookingAuthentication_Internal as APIBook_Internal   
  on APIBook.Id = APIBook_Internal.APIBookingRefID  
  where APIBook.TrackID = @TrackID and APIBook_Internal.SellKey = @SellKey  
 end    
End
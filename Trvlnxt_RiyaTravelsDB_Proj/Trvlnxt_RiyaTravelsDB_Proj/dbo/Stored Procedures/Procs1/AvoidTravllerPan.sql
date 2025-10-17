
CREATE PROCEDURE AvoidTravllerPan    
    @AgentId INT=0,    
    @getstatus varchar(200)='',    
    @TravallerPancard BIT=0    
     
AS    
BEGIN    
       
   if(@getstatus='Get')    
   begin    
   select IsPanRequiredForHotel from B2BRegistration where PKID=@AgentId    
   end    
    
   else    
   begin    
    
    UPDATE B2BRegistration    
    SET IsPanRequiredForHotel = @TravallerPancard    
    WHERE PKID = @AgentId;    
 end    
    
     
END; 
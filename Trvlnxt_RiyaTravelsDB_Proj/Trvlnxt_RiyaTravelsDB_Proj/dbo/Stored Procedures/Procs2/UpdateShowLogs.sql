

CREATE PROCEDURE UpdateShowLogs  
    @AgentId INT,  
 @getstatus varchar(200)='',  
    @ShowLogs BIT  
   
AS  
BEGIN  
     
   if(@getstatus='Get')  
   begin  
   select ShowHotelLogs from B2BRegistration where PKID=@AgentId  
   end  
  
   else  
   begin  
  
    UPDATE B2BRegistration  
    SET ShowHotelLogs = @ShowLogs  
    WHERE PKID = @AgentId;  
 end  
  
   
END;  
  
  

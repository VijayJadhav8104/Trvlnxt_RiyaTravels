-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE SetStatusHoldtoCancel  
 -- Add the parameters for the stored procedure here  
 @pkid int=0,  
 @AgentId varchar(500)=null,
 @MainAgentId varchar(50)=null,
 @MethodName varchar(500)=null
  
  
AS  
BEGIN  

	update Hotel_BookMaster set CurrentStatus='Cancelled' where pkId=@pkid
  
 DECLARE @Id AS INT  
 set @Id = (select Id from Hotel_Status_History where FKHotelBookingId=@pkid and IsActive=1)  
  
 if(@Id is not null)  
 BEGIN  
    insert into Hotel_Status_History(FKHotelBookingId,   
          FkStatusId,
		  MainAgentId,
          CreatedBy,  
          IsActive,
		  MethodName)   
  
         values(@pkid,  
          7,
		  @MainAgentId,
          @AgentId,  
          1,
		  @MethodName)  
  
     update Hotel_Status_History   
     set ModifiedDate=GETDATE(),  
         ModifiedBy=@AgentId,
		 MainAgentId=@MainAgentId,
         IsActive=0   
     where Id=@Id  
 End  
END 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SetStatusHoldtoCancel] TO [rt_read]
    AS [dbo];


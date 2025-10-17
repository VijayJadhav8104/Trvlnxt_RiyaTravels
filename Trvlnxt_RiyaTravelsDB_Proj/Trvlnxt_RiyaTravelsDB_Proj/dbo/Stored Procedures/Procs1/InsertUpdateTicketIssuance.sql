  
CREATE PROCEDURE [dbo].[InsertUpdateTicketIssuance]  
 -- Add the parameters for the stored procedure here    
  @OrderID varchar(30) = null,  
  @GDSPNR varchar(30)=null,  
  @RiyaPNR varchar(30)=null,  
  @Remark varchar(1000)=null,  
  @UserID varchar(30)=null,  
  @BookingStatus int  
AS  
BEGIN  
  DECLARE @Error_msg varchar(500)=null  
    
  BEGIN  
   IF(@BookingStatus =3)--PendingTicket  
   BEGIN  
    BEGIN TRY  
     exec [dbo].UpdateBookingStatus @GDSPNR,  @BookingStatus, @UserID,'','',@RiyaPNR     
  
     INSERT INTO AgentHistory  
     (  
      orderID,  
      GDSPNR,  
      UserID,  
      Remark,  
      InsertDate,  
      B2BAgent  
     )  
     VALUES  
     (  
      @orderID,  
      @GDSPNR,  
      @UserID,        
      @Remark,        
      GETDATE(),  
      1  
     )  
    END TRY  
    BEGIN CATCH  
     SET @Error_msg=ERROR_MESSAGE()  
     RAISERROR(@Error_msg,16,1)  
    END CATCH  
   END  
  
   ELSE IF(@BookingStatus =1) --issue ticket   
   BEGIN   
   exec [dbo].UpdateBookingStatus @GDSPNR,  @BookingStatus, @UserID,'','',@RiyaPNR  
   INSERT INTO AgentHistory  
     (  
      orderID,  
      GDSPNR,  
      UserID,  
      Remark,  
      InsertDate,  
      B2BAgent  
     )  
     VALUES  
     (  
      @orderID,  
      @GDSPNR,  
      @UserID,        
      @Remark,        
      GETDATE(),  
      1  
     )  

	 declare @Country varchar(10);  
	 Declare @utcdate Datetime;  
	 Declare @Id int  
  
	select @Country=i.Country,@Id=i.pkId,  
	@utcdate =(case i.Country when 'US' THEN DATEADD(MINUTE,-570,getdate()) 
	when 'CA' THEN  DATEADD(MINUTE,-750,getdate()) 
	when 'AE' THEN DATEADD(MINUTE,-90,getdate())  ELSE  GETDATE() END) from tblBookMaster i;   
  
  
	 UPDATE tblBookMaster  
     SET  
     inserteddate=@utcdate,
	 inserteddate_old = GETDATE()
     WHERE   
      orderId=@OrderID  
   
   END  
  
  
   ELSE IF(@BookingStatus =4 or @BookingStatus =5 or @BookingStatus =8 or @BookingStatus =9 or @BookingStatus =15)--cancel 4 ,Close 5  
   BEGIN   
   exec [dbo].UpdateBookingStatus @GDSPNR,  @BookingStatus, @UserID,'','',@RiyaPNR    
   INSERT INTO AgentHistory  
     (  
      orderID,  
      GDSPNR,  
      UserID,  
      Remark,  
      InsertDate,  
      B2BAgent  
     )  
     VALUES  
     (  
      @orderID,  
      @GDSPNR,  
      @UserID,        
      @Remark,        
      GETDATE(),  
      1  
     )  
   UPDATE tblBookMaster  
     SET  
     AgentAction=1  
     WHERE   
      orderId=@OrderID  
  
   END  
  
  
  
  END   
    
END  
  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertUpdateTicketIssuance] TO [rt_read]
    AS [dbo];


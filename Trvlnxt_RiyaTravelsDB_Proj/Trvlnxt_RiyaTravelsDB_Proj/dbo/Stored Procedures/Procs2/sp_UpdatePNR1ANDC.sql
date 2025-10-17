CREATE PROCEDURE [dbo].[sp_UpdatePNR1ANDC]  
 @OrderId varchar(30),  
 @GDSPNR varchar(200),  
 @AirlinePNR varchar(200),  
 @AirlineBookingRef varchar(500)=null,  
 @Bookingstatus varchar(150)=null,  
 @AgentId bigint  
   
AS  
BEGIN  
 declare @isGDS varchar(10)=''  
 select @isGDS=GDSPNR from tblBookMaster where orderId=@OrderId  
   
if @Bookingstatus ='Hold'
begin
UPDATE tblBookMaster SET GDSPNR = @GDSPNR,IsBooked=0,BookingStatus=2,IssueBy=@AgentId,IssueDate=GETDATE()  
   WHERE orderId = @OrderId  
end
else
begin
 if @isGDS is null or @isGDS=''  
   
   begin  
  if(@GDSPNR<>'')  
  begin  
   UPDATE tblBookMaster SET GDSPNR = @GDSPNR,IsBooked=1,BookingStatus=1,IssueBy=@AgentId,IssueDate=GETDATE()  
   WHERE orderId = @OrderId  
   end  
   else  
   begin  
    UPDATE tblBookMaster SET GDSPNR = @GDSPNR,IsBooked=0,BookingStatus=0,IssueBy=@AgentId,IssueDate=GETDATE()  
   WHERE orderId = @OrderId  
   end  
  end  
  else
  begin
  if(@GDSPNR<>'')  
  begin  
   UPDATE tblBookMaster SET GDSPNR = @GDSPNR,IsBooked=1,BookingStatus=1,IssueBy=@AgentId,IssueDate=GETDATE()  
   WHERE orderId = @OrderId  
   end 

  end
  end 
   
   
 UPDATE tblBookItenary SET airlinePNR = @AirlinePNR   
 WHERE orderId = @OrderId   
END  
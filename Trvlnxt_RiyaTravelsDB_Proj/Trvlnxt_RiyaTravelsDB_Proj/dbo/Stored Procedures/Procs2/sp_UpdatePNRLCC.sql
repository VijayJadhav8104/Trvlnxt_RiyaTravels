CREATE PROCEDURE [dbo].[sp_UpdatePNRLCC]    
 @OrderId varchar(30),    
 @PNR varchar(200),    
 @flightNo varchar(10),    
 @Carrier Varchar(10) ,
 @AirlinePNR varchar(10)='',
 @Trackid varchar(100)=''
     
AS    
BEGIN    
 declare @isGDS varchar(10)=''    
 select @isGDS=GDSPNR from tblBookMaster where orderId=@OrderId AND airCode = @Carrier AND flightNo=@flightNo  
     
 if @isGDS is null or @isGDS=''    
 begin    
  if(@Carrier ='FZ')    
  begin    
	UPDATE tblBookMaster SET GDSPNR = 'NA'    
	WHERE orderId = @OrderId AND airCode = @Carrier AND flightNo=@flightNo    
  end    
  else    
  begin    
   UPDATE tblBookMaster SET GDSPNR = @PNR  ,APITrackID=@Trackid  
   WHERE orderId = @OrderId AND airCode = @Carrier AND flightNo=@flightNo    
  end    
 end    
     if(@Carrier ='EK')    
  begin 
 UPDATE tblBookItenary SET airlinePNR = @AirlinePNR     
 WHERE orderId = @OrderId AND airCode = @Carrier AND flightNo=@flightNo   
 end
 else
 begin 
 UPDATE tblBookItenary SET airlinePNR = @PNR     
 WHERE orderId = @OrderId AND airCode = @Carrier AND flightNo=@flightNo   
 end

END    
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UpdatePNRLCC] TO [rt_read]
    AS [dbo];


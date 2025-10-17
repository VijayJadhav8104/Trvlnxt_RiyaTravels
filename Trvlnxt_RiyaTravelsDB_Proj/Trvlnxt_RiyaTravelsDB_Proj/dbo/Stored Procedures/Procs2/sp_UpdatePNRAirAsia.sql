  
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
Create PROCEDURE [dbo].[sp_UpdatePNRAirAsia]  
 @OrderId varchar(30),  
 @PNR varchar(200),  
 @flightNo varchar(10),  
 @Carrier Varchar(10)  
   
AS  
BEGIN  
 begin  
   UPDATE tblBookMaster SET GDSPNR = @PNR  
   WHERE orderId = @OrderId AND airCode = @Carrier AND flightNo=@flightNo  

   
 UPDATE tblBookItenary SET airlinePNR = @PNR   
 WHERE orderId = @OrderId AND airCode = @Carrier AND flightNo=@flightNo 
  
 end  
    
END  
  
  
  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UpdatePNRAirAsia] TO [rt_read]
    AS [dbo];


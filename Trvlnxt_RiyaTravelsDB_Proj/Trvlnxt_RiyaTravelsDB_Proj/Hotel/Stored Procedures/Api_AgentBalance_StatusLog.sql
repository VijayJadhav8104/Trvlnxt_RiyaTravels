CREATE PROC [Hotel].[Api_AgentBalance_StatusLog]  
(  
 @TransactionType VARCHAR(10),  
 @OrderId VARCHAR(50),  
 @BookingStatus VARCHAR(50)  
)  
AS  
BEGIN  
 DECLARE @TransactionPkId INT    
 SELECT TOP 1 @TransactionPkId= Pkid FROM tblAgentBalance WHERE BookingRef=@OrderId AND TransactionType=@TransactionType ORDER BY CreatedOn DESC  
 INSERT INTO hotel.Agentbalance_StatusLog(FKtransactionID,BookingStatus) VALUES (@TransactionPkId,@BookingStatus)  
END  
  
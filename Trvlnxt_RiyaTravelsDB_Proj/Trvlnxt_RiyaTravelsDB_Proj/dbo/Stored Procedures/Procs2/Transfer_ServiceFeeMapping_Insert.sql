CREATE PROCEDURE [dbo].[Transfer_ServiceFeeMapping_Insert]  
 @AgentID INT,  
 @ServiceFeeTypeDomestic INT,  
 @ServiceFeeDomestic DECIMAL(18,2),  
 @ServiceFeeTypeInternational INT,  
 @ServiceFeeInternational DECIMAL(18,2)  
AS  
BEGIN  
   
 IF NOT EXISTS (SELECT * FROM [dbo].[Transfer_AgentServiceFeeMapping] WHERE AgentID = @AgentID)  
 BEGIN  
  INSERT INTO [dbo].[Transfer_AgentServiceFeeMapping](AgentID,  
   ServiceFeeTypeDomestic , ServiceFeeDomestic,  
   ServiceFeeTypeInternational , ServiceFeeInternational,  
   CreateDate, ModifyDate)  
  VALUES(@AgentID, @ServiceFeeTypeDomestic, @ServiceFeeDomestic,   
   @ServiceFeeTypeInternational, @ServiceFeeInternational,  
   GETDATE(), GETDATE())  
 END  
 ELSE   
 BEGIN  
  UPDATE  [dbo].[Transfer_AgentServiceFeeMapping] SET       
   ServiceFeeTypeDomestic = @ServiceFeeTypeDomestic,  
   ServiceFeeDomestic = @ServiceFeeDomestic,  
   ServiceFeeTypeInternational = @ServiceFeeTypeInternational,  
   ServiceFeeInternational = @ServiceFeeInternational,  
   [ModifyDate] = GETDATE()  
  WHERE   
   AgentID= @AgentID  
 END  
  
  
END  
  
  
  
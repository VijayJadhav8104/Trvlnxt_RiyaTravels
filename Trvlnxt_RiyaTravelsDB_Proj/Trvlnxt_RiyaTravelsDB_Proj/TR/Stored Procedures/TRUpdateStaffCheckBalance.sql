CREATE PROCEDURE [TR].[TRUpdateStaffCheckBalance]                 
  @UserId INT =null                         
 ,@OrderId VARCHAR(50)=null                    
 ,@Balance DECIMAL(18, 2) =null                         
 ,@TransactionType VARCHAR(10) =null                           
 ,@Country VARCHAR(5) =null                          
 ,@CreatedBy int =null          
  ,@producttype varchar(50)=null         
                
AS                
BEGIN                
 DECLARE @CountryId INT                
                
 SELECT @CountryId = ID                
 FROM mCountry                
 WHERE CountryCode = @Country                
                
 DECLARE @Amt DECIMAL(18, 2) = 0                
                
 BEGIN                
  SELECT @Amt = AgentBalance                
  FROM mUserCountryMapping                
  WHERE UserID = @UserId                
   AND  CountryId = @CountryId                
 END                
                
 IF (@TransactionType = 'Debit')                
 BEGIN                
          
   insert into tblSelfBalance(userid,BookingRef,OpenBalance,TranscationAmount,CloseBalance,CreatedBy,TransactionType,ProductType)                
   values(@UserId,@OrderId,@Amt,@Balance,@Amt-@Balance,@CreatedBy,@TransactionType,@producttype)            
            
  UPDATE mUserCountryMapping                
  SET AgentBalance = (@Amt - @Balance)  WHERE UserID = @UserId                
   AND  CountryId = @CountryId                
 END                
                
  IF (@TransactionType = 'Credit')                      
 BEGIN                      
                    
   insert into tblSelfBalance(userid,BookingRef,OpenBalance,TranscationAmount,CloseBalance,CreatedBy,TransactionType,ProductType,CreatedOn)                    
   values(@UserId,@OrderId,@Amt,@Balance,@Balance+@Amt,@CreatedBy,@TransactionType,'B2BSTransfer',GETDATE())                    
                      
  UPDATE mUserCountryMapping                      
  SET AgentBalance = (@Amt + @Balance)                      
  WHERE UserID = @UserId                      
   AND CountryId = @CountryId                      
 END                      
                
 SELECT  AgentBalance                
 FROM mUserCountryMapping                
 WHERE UserID = @UserId                
  AND  CountryId = @CountryId                
END
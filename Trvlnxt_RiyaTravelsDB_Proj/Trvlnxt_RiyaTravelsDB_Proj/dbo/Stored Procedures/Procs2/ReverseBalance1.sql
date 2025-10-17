CREATE Procedure ReverseBalance1    
  @UserId int,    
  @Country varchar(10) = null,    
  @RiyaPnr varchar(10)     
 as    
 Declare @Amt decimal(18,2)=0,    
  @PaymentMode varchar(15),    
   @CountryId INT,    
   @MainAgentId INT    
 SELECT @CountryId=ID FROM mCountry WHERE CountryCode=@Country    
  select top 1 @Amt=  p.amount, @PaymentMode=payment_mode,@MainAgentId=ISNULL( MainAgentId,0) from Paymentmaster p  join tblBookMaster b on p.order_id =b.orderid     
  where b.riyaPNR = @RiyaPnr    
    
    
  If(@PaymentMode = 'Check')    
  BEGIN    
  UPDATE AgentLogin SET AgentBalance=(AgentBalance + @Amt) WHERE UserID=@UserId    
    
  SELECT  AgentBalance FROM AgentLogin where UserID=@UserId     
  END    
  ELSE If(@PaymentMode = 'Self Balance')    
  BEGIN    
      
  UPDATE mUserCountryMapping SET AgentBalance=(AgentBalance + @Amt)  WHERE UserID=@UserId and  CountryId = @CountryId     
      
  SELECT  AgentBalance FROM mUserCountryMapping WHERE UserID=@UserId and  CountryId = @CountryId     
      
  END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[ReverseBalance1] TO [rt_read]
    AS [dbo];


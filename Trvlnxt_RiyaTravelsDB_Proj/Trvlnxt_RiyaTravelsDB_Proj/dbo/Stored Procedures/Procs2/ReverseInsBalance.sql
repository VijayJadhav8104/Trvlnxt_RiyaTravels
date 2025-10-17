CREATE Procedure [dbo].[ReverseInsBalance]  
  @UserId int,  
  @Country varchar(10) = null,  
  @orderNumber varchar(50)   
 as  
	Declare @Amt decimal(18,2)=0,  
	@PaymentMode varchar(15),  
	@CountryId INT

	SELECT @CountryId=ID FROM mCountry WHERE CountryCode=@Country  
	select top 1 @Amt=  p.amount, @PaymentMode=payment_mode from Paymentmaster p  join tblInsBookMaster b on p.order_id =b.orderid   
	where b.riyaPNR = @orderNumber  
  
  
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
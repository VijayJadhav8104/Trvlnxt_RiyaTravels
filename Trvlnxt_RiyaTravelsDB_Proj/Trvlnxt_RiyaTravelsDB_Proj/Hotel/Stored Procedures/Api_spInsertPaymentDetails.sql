            
CREATE proc [Hotel].[Api_spInsertPaymentDetails]           
            
            @order_id varchar(30)            
           ,@tracking_id varchar(50)=null            
           ,@bank_ref_no varchar(max)=null            
           ,@order_status varchar(30)=null            
           ,@failure_message varchar(max)=null            
           ,@payment_mode varchar(250)=null          
     ,@payment_gatewaymode varchar(50)=null         
           ,@card_name varchar(max)=null            
           ,@status_code varchar(10)=null            
           ,@status_message varchar(150)=null            
           ,@currency char(3)=null            
           ,@amount varchar(30)=null            
           ,@billing_name varchar(60)=null            
           ,@billing_address varchar(150)=null            
           ,@billing_city varchar(30)=null            
           ,@billing_state varchar(30)=null            
           ,@billing_zip varchar(15)=null            
           ,@billing_country varchar(50)=null            
           ,@billing_tel varchar(20)=null            
           ,@billing_email varchar(70)=null            
           ,@vault char(1)=null            
           ,@offer_type varchar(9)=null            
           ,@offer_code varchar(30)=null            
           ,@discount_value varchar(30)=null            
           ,@mer_amount varchar(30)=null            
           ,@eci_value varchar(30)=null            
           ,@retry char(1)=null            
           ,@response_code varchar(30)=null            
          -- ,@inserteddt datetime            
           ,@riyaPNR varchar(20)=null            
           ,@billing_notes varchar(max)=null            
           ,@getway_name varchar(50)=null            
     ,@type varchar(10)='Flight'            
     ,@card_number  varchar(50)=null            
     ,@ExpDate varchar(50)=null            
     ,@CVV varchar(50)=null            
     ,@CardType varchar(50)=null            
     ,@Country varchar(50)=null            
     ,@Paymentgateway varchar(50)=null            
     ,@Encardnumber  varchar(max)=null            
     ,@EnExpDate  varchar(max)=null            
     ,@EnCVV  varchar(max)=null            
  ,@AuthCode varchar(50)=null          
      ,@MerchantId varchar(50)=null    
   ,@BankAccountNumber varchar(20)=null    
as            
begin            
            
BEGIN TRY            
BEGIN TRANSACTION            
IF NOT EXISTS(SELECT PKID FROM [Paymentmaster] WHERE order_id=@order_id)            
BEGIN            
declare @MaskCardNumber varchar(50)=''            
            
IF(@card_number IS NOT NULL OR @card_number!='')            
BEGIN            
set @MaskCardNumber=('XXXXXXXXXXXX'  + SUBSTRING(@card_number,len(@card_number)-3,len(@card_number)))            
END            
            
IF(@card_number IS NOT NULL OR @card_number!='') AND (@payment_mode='passThrough')            
BEGIN            
select @card_number=('XXXXXXXXXXXX'  + SUBSTRING(@card_number,len(@card_number)-3,len(@card_number)))            
END            
            
             
                 
  INSERT INTO [dbo].[Paymentmaster]            
           ([order_id]            
           ,[tracking_id]            
           ,[bank_ref_no]            
           ,[order_status]            
           ,[failure_message]            
           ,[payment_mode]         
     ,[payment_gatewaymode]          
           ,[card_name]            
           ,[status_code]            
           ,[status_message]            
           ,[currency]            
           ,[amount]            
           ,[billing_name]            
           ,[billing_address]            
           ,[billing_city]            
           ,[billing_state]            
           ,[billing_zip]            
           ,[billing_country]            
           ,[billing_tel]            
           ,[billing_email]            
           ,[vault]            
           ,[offer_type]            
           ,[offer_code]            
           ,[discount_value]            
           ,[mer_amount]            
           ,[eci_value]            
           ,[retry]            
           ,[response_code]            
           ,[riyaPNR]            
           ,[billing_notes]            
           ,[getway_name]              
     ,Type            
     ,Country            
     ,PaymentGateway            
     ,CardNumber            
     ,ExpiryDate            
     ,CVV            
     ,CardType            
     ,OriginalStatus        
     ,EnCardNumber            
   ,EnExpiryDate            
   ,EnCVV            
   ,MaskCardNumber            
   ,AuthCode         
   ,[MerchantId]      
   ,[BankAccountNo]    
               
     )            
     VALUES            
           (@order_id            
           ,@tracking_id            
           ,@bank_ref_no            
           ,@order_status            
           ,@failure_message            
           ,@payment_mode            
     ,@payment_gatewaymode         
           ,@card_name            
           ,@status_code            
           ,@status_message            
           ,@currency            
           ,@amount            
           ,@billing_name            
           ,@billing_address            
           ,@billing_city            
  ,@billing_state            
           ,@billing_zip            
           ,@billing_country            
           ,@billing_tel            
           ,@billing_email            
           ,@vault            
           ,@offer_type            
           ,@offer_code            
           ,@discount_value            
           ,@mer_amount            
           ,@eci_value            
           ,@retry            
           ,@response_code            
           ,@riyaPNR            
           ,@billing_notes            
           ,@getway_name            
     ,@type            
     ,@Country            
      ,@Paymentgateway            
     ,''            
     ,@ExpDate             
     ,@CVV            
     ,@CardType             
     ,@order_status            
     ,@Encardnumber            
     ,@EnExpDate            
     ,@EnCVV            
     ,@MaskCardNumber           
  ,@AuthCode          
         ,@MerchantId      
   ,@BankAccountNumber    
     )            
   insert into [dbo].[Paymentissuance]([Tracking_Id],[Amount],[OrderId],[Status],Type)             
                           values(@tracking_id,@amount,@order_id,@order_status,@type)            
END            
ELSE            
BEGIN            
 Update Paymentmaster set order_status =  @order_status WHERE order_id=@order_id            
 insert into [dbo].[Paymentissuance]([Tracking_Id],[Amount],[OrderId],[Status],Type)             
                           values(@tracking_id,@amount,@order_id,@order_status,@type)            
END            
  COMMIT TRANSACTION;            
END TRY            
begin catch            
DECLARE             
        @ErrorMessage NVARCHAR(4000),            
        @ErrorSeverity INT,            
        @ErrorState INT;            
 SELECT             
        @ErrorMessage = ERROR_MESSAGE(),            
        @ErrorSeverity = ERROR_SEVERITY(),            
        @ErrorState = ERROR_STATE();            
    RAISERROR (            
        @ErrorMessage,            
        @ErrorSeverity,            
       @ErrorState                
        );            
    ROLLBACK TRANSACTION            
end catch            
end            
            
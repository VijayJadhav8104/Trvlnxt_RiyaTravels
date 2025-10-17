          
CREATE proc [dbo].[spUpdateHoldPaymentDetails]          
 @order_id varchar(30)         
 ,@payment_mode varchar(250)=null        
 ,@card_number  varchar(50)=null          
 ,@ExpDate varchar(50)=null          
 ,@CVV varchar(50)=null          
 ,@CardType varchar(50)=null          
 ,@amount varchar(50)=null  
 ,@Encardnumber varchar(50)=null
 ,@EnExpDate varchar(50)=null
 ,@EnCVV varchar(50)=null
 ,@ParentOrderId varchar(100)=null   
as          
begin          
          
BEGIN TRY          
BEGIN TRANSACTION       


declare @MaskCardNumber varchar(50)=''   
IF(@card_number IS NOT NULL OR @card_number!='')              
BEGIN        
set @MaskCardNumber=(REPLICATE('X', len(@card_number)-4)  + SUBSTRING(@card_number,len(@card_number)-3,len(@card_number)))  
--set @MaskCardNumber=('XXXXXXXXXXXX'  + SUBSTRING(@card_number,len(@card_number)-3,len(@card_number)))              
END              
              
IF(@card_number IS NOT NULL OR @card_number!='') AND (@payment_mode='passThrough')              
BEGIN      
select @card_number=(REPLICATE('X', len(@card_number)-4)  + SUBSTRING(@card_number,len(@card_number)-3,len(@card_number)))  
--select @card_number=('XXXXXXXXXXXX'  + SUBSTRING(@card_number,len(@card_number)-3,len(@card_number)))              
END 
        
 Update Paymentmaster set amount=@amount,mer_amount=@amount,payment_mode = @payment_mode,CardNumber = @card_number        
 ,ExpiryDate = @ExpDate,CVV = @CVV,CardType = @CardType,IsHold = 0,ParentOrderId = @ParentOrderId
 ,EnCardNumber=@Encardnumber,EnCVV=@EnCVV,EnExpiryDate=@EnExpDate,MaskCardNumber=@MaskCardNumber WHERE order_id = @order_id        
           
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
          
          
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spUpdateHoldPaymentDetails] TO [rt_read]
    AS [dbo];


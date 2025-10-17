

CREATE proc [dbo].[spUpdatePaymentDetails]

          
		   @order_id varchar(50),
           @tracking_id varchar(50)=null
		   ,@response_code varchar(30)=null
		   ,@billing_tel varchar(20)=null
           ,@billing_email varchar(70)=null
		   ,@card_name varchar(max)=null
		   ,@currency char(3)=null
		   ,@failure_message varchar(max)=null
		   ,@CardType varchar(50)=null
		   ,@Country varchar(50)=null
		   ,@Paymentgateway varchar(50)=null
		   ,@order_status varchar(30)=null


as
begin


     Update Paymentmaster
          set 
           [tracking_id] = @tracking_id
		    ,[response_code] = @response_code
			  ,[billing_tel]= @billing_tel
           ,[billing_email]=@billing_email
		    ,[card_name]=@card_name
			 ,[currency]= @currency
			 ,[failure_message]=@failure_message
			 ,CardType= @CardType
			  ,Country=@Country
		   ,PaymentGateway=@Paymentgateway
		   ,[order_status]= @order_status

		   where order_id = @order_id

end


           




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spUpdatePaymentDetails] TO [rt_read]
    AS [dbo];


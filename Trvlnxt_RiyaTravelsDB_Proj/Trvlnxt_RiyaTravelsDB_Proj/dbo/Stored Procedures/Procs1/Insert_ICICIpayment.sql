


CREATE procedure [dbo].[Insert_ICICIpayment]

@TrackingID varchar(50)=null,
@Orderstatus varchar(50)=null,
@riyaPNR varchar(50)=null,
@RS int=0,
@Country varchar(50)=null,
@Name varchar(100)=null,
@ContactNo varchar(50)=null,

@InterchangeValue varchar(50)=null,
@TDR varchar(50)=null,
@payment_mode varchar(50)=null,
@SubMerchantId varchar(50),
@TPS varchar(50)=null,
@RSV varchar(max)=null

as
begin

insert into Paymentmaster 
(
order_id,
order_status,
riyaPNR,
amount,
mer_amount,
Type,
PaymentGateway,
inserteddt,
billing_country,
billing_name,
billing_tel,

InterchangeValue,
TDR,
payment_mode,
SubMerchantId,
TPS,
RSV
)
values
(
@TrackingID,
@Orderstatus,
@riyaPNR,
@RS,
@RS,
'Hotel',
'ICICI',
GETDATE(),
@Country,
@Name,
@ContactNo,

@InterchangeValue,
@TDR,
@payment_mode ,
@SubMerchantId ,
@TPS ,
@RSV 
)


end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Insert_ICICIpayment] TO [rt_read]
    AS [dbo];


create procedure [Visa].[Insert_VisaPayment]
(
	@FK_appId int NULL,
	@CreatedBy int NULL,
	@VisaFees float NULL,
	@VFSFees float NULL,
	@GST float NULL,
	@ServiceCharges float NULL,
	@Markup float NULL,
	@Discount float NULL,
	@TotalAmount float NULL,
	@OrderId nvarchar(100) NULL,
	@PaymentStatus [int] NULL,
	@PaymentStatusText nvarchar(20) NULL,
	@PaymentMode int NULL,
	@PaymentModeText nvarchar(20) NULL
	)
	as
	begin

	insert into [Visa].[ApplicationPayment](fk_AppId,CreatedBy,CreatedDate,VisaFees ,
	VFSFees ,
	GST ,
	ServiceCharges ,
	Markup,
	Discount ,
	TotalAmount ,
	OrderId ,
	PaymentStatus ,
	PaymentStatusText ,
	PaymentMode ,
	PaymentModeText )
	values(@FK_appId,@CreatedBy,getdate(),@VisaFees ,
	@VFSFees ,
	@GST ,
	@ServiceCharges ,
	@Markup,
	@Discount ,
	@TotalAmount ,
	@OrderId ,
	@PaymentStatus ,
	@PaymentStatusText ,
	@PaymentMode ,
	@PaymentModeText )
	
	end

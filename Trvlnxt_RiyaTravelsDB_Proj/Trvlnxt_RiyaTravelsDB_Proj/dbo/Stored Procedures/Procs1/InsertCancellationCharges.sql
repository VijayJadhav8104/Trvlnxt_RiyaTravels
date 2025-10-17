


CREATE PROCEDURE [dbo].[InsertCancellationCharges]
@GDSPNR				varchar(10),
@RiyaPNR			varchar(10),
@Panelty			int,
@Markup				int,
@RefundAmount		int = null,
@Remark				varchar(500),
@UpdatedBy			int,
@FlagType			varchar(50),
@RefundId			varchar(30)=null

AS BEGIN
	
	DECLARE @OrderId			varchar(30)
	DECLARE @RemainingRefund	int

	DECLARE @Totalrefund	int

	SET @Totalrefund = (SELECT top 1 RefundAmount FROM BookMaster where RiyaPNR =@RiyaPNR AND GDSPNR =@GDSPNR)

	--SET @RemainingRefund = @Totalrefund - (@Panelty+ @Markup+ @RefundAmount)

	SELECT top 1 @OrderId =   OrderId FROM BookMaster WHERE RiyaPNR =@RiyaPNR AND GDSPNR =@GDSPNR
	UPDATE CancellationHistory SET IsActive =0
	WHERE OrderId = @OrderId AND RiyaPNR = @RiyaPNR

	INSERT INTO CancellationHistory(Markup, OrderId, Panelty, Remark, RiyaPNR, UpdatedBy,FlagType, RefundAmount,RefundId)
				VALUES(@Markup, @OrderId, @Panelty, @Remark, @RiyaPNR, @UpdatedBy,@FlagType, @RefundAmount,@RefundId)

	if(@Totalrefund is not null and @RefundAmount is not null)
	BEGIN
		SET @RefundAmount = @Totalrefund + @RefundAmount;
	END
	update [dbo].[BookMaster] set updated_by=@UpdatedBy,
	[cancellationpanelty]=@panelty,[cancellationremark]=@remark,[servicecharge]=@Markup,Iscancelled=@FlagType,
	RefundAmount = @RefundAmount
	where RiyaPNR =@RiyaPNR AND GDSPNR =@GDSPNR

	if(@FlagType = 'RF')
	BEGIN
	update [dbo].[BookMaster] set IsRefunded = 1
	where RiyaPNR =@RiyaPNR AND GDSPNR =@GDSPNR
	END
END







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertCancellationCharges] TO [rt_read]
    AS [dbo];


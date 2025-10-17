
/****** Object:  StoredProcedure [dbo].[insertCancellCharges]    Script Date: 5/4/2017 5:05:49 PM ******/
CREATE PROCEDURE [dbo].[insertTaxDetails]
	-- Add the parameters for the stored procedure here
	@taxtype varchar(20)='',	
	@taxpercent decimal(10,1)=null,
	@disID bigint,
	@adminID bigint,
	@opr int = 0
	
AS
BEGIN
--set nocount on;


if(@opr=0)	
Begin
IF NOT EXISTS(SELECT * FROM [Taxdetails] WHERE [TaxType] = @taxtype  )
begin
  INSERT INTO [dbo].[Taxdetails]
           ([TaxType]
           ,[taxPercent]
           ,[insert_date]
           ,[userId]
           
           ,[Status])
     VALUES
	 (@taxtype         , @taxpercent ,
	getdate(),
	@adminID ,'A')

	select 1;
	end
	else
	begin

	UPDATE [dbo].[Taxdetails]
   SET status = 'D',[modifiedDate]=GETDATE(),ModifiedBy=@adminID
   where [TaxType] = @taxtype



	INSERT INTO [dbo].[Taxdetails]
           ([TaxType]
           ,[taxPercent]
           ,[insert_date]
           ,[userId]
           
           ,[Status])
     VALUES
	 (@taxtype         , @taxpercent ,
	getdate(),
	@adminID ,'A')

	select 1;
	end
End
Else
Begin
	
	UPDATE [dbo].[Taxdetails]
   --SET [TaxType] = @taxtype
   --   ,[taxPercent] = @taxpercent
	SET [modifiedDate] = getdate()
      ,ModifiedBy = @adminID
      ,[Status] = 'D'
	WHERE Pk_Id=@disID

	select 4
End	




END











GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[insertTaxDetails] TO [rt_read]
    AS [dbo];


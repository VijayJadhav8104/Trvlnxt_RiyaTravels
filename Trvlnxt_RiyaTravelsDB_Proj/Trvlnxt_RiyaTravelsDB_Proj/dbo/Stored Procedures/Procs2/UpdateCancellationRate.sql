create PROCEDURE [dbo].[UpdateCancellationRate]
	-- Add the parameters for the stored procedure here
	
	@Id int,
	@CancellationCharge nvarchar(max)=null,
	@CancellationRemark nvarchar(500)=null
	

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	update Hotel_BookMaster set Post_addCancellationCharges=@CancellationCharge,
	Post_addCancellationRemarks=@CancellationRemark
	where pkId=@Id
	
END

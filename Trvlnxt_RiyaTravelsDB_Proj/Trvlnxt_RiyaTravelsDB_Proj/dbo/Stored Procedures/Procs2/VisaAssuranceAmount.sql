-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VisaAssuranceAmount]
	-- Add the parameters for the stored procedure here
	@Id	 int = 0,
	@ActualCost decimal = 0,
	@DiscountedCost	decimal = 0,	
	@AddedBy int = 0,
	@IsActive bit = 0 ,
	@Action varchar(200)=null
	--@UserId int = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		if(@Action='GetData')
		Begin
			select *
			from tblVisaAssuranceAmount VA
			--where @UserId = VA.AddedBy
			order by CreateDate desc 

		End

		else if(@Action='Add')
		Begin
			update tblVisaAssuranceAmount set IsActive=0 
			where IsActive=1
			
			-- Get Big Promo Code
			declare @BigPromoCodeVal decimal = 0;
			set @BigPromoCodeVal = (select top 1 Discount 
									from  tblVisaPromoCode 
									where IsActive=1
									order by Discount desc)
			if(@DiscountedCost > @BigPromoCodeVal OR @BigPromoCodeVal is null)
			  Begin
					insert into tblVisaAssuranceAmount (ActualCost,
												DiscountedCost,
												AddedBy)

										 values(@ActualCost,
												@DiscountedCost,
												@AddedBy)
					return 1;
			   End
			else
			   Begin
			      return -1;
			   End
		End
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[VisaAssuranceAmount] TO [rt_read]
    AS [dbo];


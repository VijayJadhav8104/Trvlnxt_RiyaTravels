-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE UpdateB2BBranch
	-- Add the parameters for the stored procedure here
  @id int,
  @BranchName        nvarchar(200)='',
  @BranchCountry	   nvarchar(200)='',
  @BranchCity		   nvarchar(200)='',
  @AccountantEmail   nvarchar(200)='',
  @Phone			   nvarchar(200)='',
  @Location		   nvarchar(500)='',
  @Address		   nvarchar(max)='',
  @BankDetails	   nvarchar(max)='',
  @Active			   bit,
  @ReciveBookingEmail bit
AS
BEGIN
	
	update B2BHotelBranch set 
  BranchName  = @BranchName ,     
  BranchCountry	= @BranchCountry,	 
  BranchCity = @BranchCity,		 
  AccountantEmail = @AccountantEmail ,  
  Phone	= @Phone	,		 
  Location = @Location	,	     
  Address = @Address,		     
  BankDetails = @BankDetails	,     
  Active = @Active	,		 
  ReciveBookingEmail = @ReciveBookingEmail

  where Id=@id

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateB2BBranch] TO [rt_read]
    AS [dbo];


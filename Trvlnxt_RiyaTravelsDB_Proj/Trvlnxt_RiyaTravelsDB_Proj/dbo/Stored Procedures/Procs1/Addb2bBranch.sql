
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Addb2bBranch
	-- Add the parameters for the stored procedure here
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
	
	DECLARE @RequestStatus INTEGER
	if not exists(select BranchName from B2BHotelBranch where BranchName=@BranchName and BranchCountry=@BranchCountry and BranchCity=@BranchCity)
	
	 begin
		insert into B2BHotelBranch (
								 [BranchName]
								,[BranchCountry]
								,[BranchCity]
								,[AccountantEmail]
								,[Phone]
								,[Location]
								,[Address]
								,[BankDetails]
								,[Active]
								,[ReciveBookingEmail]
								) 
					values(      @BranchName
								,@BranchCountry
								,@BranchCity
								,@AccountantEmail
								,@Phone
								,@Location
								,@Address
								,@BankDetails
								,@Active
								,@ReciveBookingEmail
						 )
		set @RequestStatus = 1
		return @RequestStatus 
	  end

    else if exists(select BranchName from B2BHotelBranch where BranchName=@BranchName and BranchCountry=@BranchCountry and BranchCity=@BranchCity)
	  begin
	  set @RequestStatus = 0
	     return @RequestStatus
	  end
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Addb2bBranch] TO [rt_read]
    AS [dbo];


-- =============================================
-- Author:	#Gajanan
-- Create date: 18-Jully-2018
-- Description: This sp is used for fetch registerd user details.
-- =============================================
CREATE PROCEDURE [dbo].[spFetchBookHotelDetails]
	-- Add the parameters for the stored procedure here
	
	@gmailId varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	

	select b.orderId,b.PassengerEmail,p.order_id,p.billing_email  from Hotel_BookMaster b join Paymentmaster p on
	 b.orderId=p.order_id 
	
--	if exists(select LeaderFirstName,LeaderLastName,CountryName,PassengerEmail,PassengerPhone from Hotel_BookMaster)
    if exists(select LeaderFirstName,LeaderLastName,CountryName,PassengerEmail,PassengerPhone, b.orderId,b.PassengerEmail,p.order_id,p.billing_email  from Hotel_BookMaster b join Paymentmaster p on
	 b.orderId=p.order_id where PassengerEmail=@gmailId)
	begin
	select LeaderFirstName,LeaderLastName,CountryName,PassengerEmail,PassengerPhone, b.orderId,b.PassengerEmail,p.order_id,p.billing_email  from Hotel_BookMaster b join Paymentmaster p on
	 b.orderId=p.order_id where PassengerEmail=@gmailId
	select 1
	end
	else
	begin
	select 2
	end
	
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spFetchBookHotelDetails] TO [rt_read]
    AS [dbo];


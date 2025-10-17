-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Rail].[GetBookingDetailsById]
@Id varchar(200)   	
AS
BEGIN


	select  
	 b2b.AgencyName,  
	 (bk.AmountPaidbyAgent - ((bk.AmountPaidbyAgent)/((PGM.Charges/100) + 1))) as PaymentGatewayCharge ,
	  b2b.Icast As ICust
	 ,bk.*  
	 from rail.Bookings bk  
	 LEFT JOIN B2BRegistration b2b ON bk.AgentId = b2b.FKUserID  
	 Left join PaymentGatewayMode PGM on bk.PaymentMode = PGM.Mode  
	 where bk.Id = @Id and (PGM.PGID = 2 or PGM.PGID is null) 

END




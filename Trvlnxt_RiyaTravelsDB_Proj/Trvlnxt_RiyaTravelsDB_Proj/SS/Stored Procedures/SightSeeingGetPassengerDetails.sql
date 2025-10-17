-- [SS].[SightSeeingGetPassengerDetails] 'icm@riya.travel','09812345810'

CREATE PROCEDURE [SS].[SightSeeingGetPassengerDetails] 
	@Email varchar(50),
	@Phone Varchar(50)
AS                                                                                                                
BEGIN   
	
	SELECT DISTINCT SPD.Titel, SPD.Name, SPD.Surname, BM.PassengerPhone, BM.PassengerEmail
	FROM SS.SS_PaxDetails  SPD WITH(NOLOCK)
	INNER JOIN SS.SS_BookingMaster BM WITH(NOLOCK) ON BM.BookingId = SPD.BookingId 
		AND (BM.PassengerPhone LIKE '%' + @Phone + '%' OR BM.PassengerEmail LIKE '%' + @Email + '%')
END

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Cruise].[GetBookingDetailsByBookingId]
	@BookingId bigint
AS
BEGIN
	
	
Declare @Adult int
Declare @Child int
Declare @Infant int

set @Adult = (Select Count(*) from Cruise.BookedPaxDetails where FkBookingId = @BookingId and PaxType = 'ADULT')
set @Child = (Select Count(*) from Cruise.BookedPaxDetails where FkBookingId = @BookingId and PaxType = 'CHILD')
set @Infant = (Select Count(*) from Cruise.BookedPaxDetails where FkBookingId = @BookingId and PaxType = 'INFANT')

select 
b.Id as BookingId,
b.BookingReferenceid as BookingReferenceId,
CONCAT(p.FirstName, ' ', p.LastName) as [GuestName],
p.Phone as ContactNo,
p.Email as Email,
Case 
	when (@Child > 0 and @Infant > 0)
	Then CONCAT(@Adult, ' Adults, ', @Child, ' Childs and ', @Infant, ' Infants')
	when (@Child > 0)
	Then CONCAT(@Adult, ' Adults and ', @Child, ' Childs')
	when (@Infant > 0)
	Then CONCAT(@Adult, ' Adults and ', @Infant, ' Infants')
	Else CONCAT(@Adult, ' Adults')
	END as NoOfGuests,
i.Ship as Ship,
b.CreatedOn as BookingDate,
Case 
	when (b.IsConfirmed = 1)
	Then 'CONFIRMED'
	when (b.IsCancelled = 1)
	Then 'CANCELLED'
	Else ''
	END as [Status]
from Cruise.Bookings b
join Cruise.BookedPaxDetails p on b.Id = p.FkBookingId and p.IsPrimaryPax = 1
join Cruise.BookedItineraries i on b.Id = i.FkBookingId
where b.Id = @BookingId

END

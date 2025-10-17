-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [SS].[BBActivityReversalStatusUpdate]
	
	@Id int=0,
	@BookingRefrence varchar(200)
AS
BEGIN
	
	update SS.SS_BookingMaster set ReversalStatus = 1 
	where BookingId = @Id and BookingRefId = @BookingRefrence

END

-- =============================================
-- Author:		Hardik Deshani
-- Create date: 25.06.2024
-- Description:	Insert Search Details
-- =============================================
CREATE PROCEDURE SearchSellBookDetails_Insert
	@StaffID Int = NULL
	,@AgentID Int = NULL
	,@SubUserID Int = NULL
	,@Origin Varchar(10)
	,@Destination Varchar(10)
	,@DepartureDate DateTime = NULL
	,@ArrivalDate DateTime = NULL
	,@Country Varchar(10)
	,@BookFrom Varchar(20)
	,@SearchDate DateTime
	,@JounrneyType Varchar(30)
	,@TrackID Uniqueidentifier = NULL
	,@TrackingID Varchar(100) = NULL
	,@Environment Varchar(30)
	,@OUTVAL Varchar(10) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO tblSearchSellBookDetails (StaffID
	,AgentID
	,SubUserID
	,Origin
	,Destination
	,DepartureDate
	,ArrivalDate
	,Country
	,Status
	,BookFrom
	,SearchDate
	,JounrneyType
	,Environment
	,TrackID
	,TrackingID)
	VALUES (@StaffID
	,@AgentID
	,@SubUserID
	,@Origin
	,@Destination
	,@DepartureDate
	,@ArrivalDate
	,@Country
	,'Search'
	,@BookFrom
	,@SearchDate
	,@JounrneyType
	,@Environment
	,@TrackID
	,@TrackingID)

	SET @OUTVAL = 'OK'
END
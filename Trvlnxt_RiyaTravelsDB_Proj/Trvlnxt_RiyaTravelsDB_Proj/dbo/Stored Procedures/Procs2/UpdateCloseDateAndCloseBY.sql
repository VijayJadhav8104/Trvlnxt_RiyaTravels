CREATE PROCEDURE [dbo].[UpdateCloseDateAndCloseBY]   	

	@OrderID varchar(50) = null,
	@UserID varchar(50) = null,
	@DiffUTCMinutes int= 0
AS
BEGIN  
 
 Update tblBookMaster set ClosedDate = DATEADD(MINUTE, @DiffUTCMinutes,getdate()) ,ClosedBy=@UserID
		where orderId =  @OrderID
 
END 
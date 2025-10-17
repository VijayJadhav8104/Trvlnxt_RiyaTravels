CREATE PROCEDURE [dbo].[UpdateBookingDate] --exec UpdateTicketNo 433762 , '0983906290519C1' , '','','0' ,'1'  	

	@RiyaPnr varchar(10),
	@DiffUTCMinutes int= 0
AS
BEGIN  
 declare @sTempTime varchar(8)=''

 SELECT @sTempTime=CONVERT(VARCHAR(8),issuedate,108) from  tblBookMaster where riyapnr=  @RiyaPnr
 if @sTempTime='00:00:00'
 begin
 Update tblBookMaster set BookingDate = DATEADD(MINUTE, @DiffUTCMinutes,getdate()) 
		where riyapnr=  @RiyaPnr
 
 end
 else
 begin
 Update tblBookMaster set BookingDate = DATEADD(MINUTE, @DiffUTCMinutes,issuedate) 
		where riyapnr=  @RiyaPnr
 end
 --declare @issuedate  datetime
 --set @bookingdate = (select top 1 DATEADD(hh, @DiffUTCMinutes,issuedate) from  tblBookMaster where riyapnr=  @RiyaPnr)
 --set @issuedate = (select top 1 issuedate from  tblBookMaster where riyapnr=  @RiyaPnr)
 --print 'test1'
 --print @issuedate
 --print @bookingdate
 --print 'test2'

 
	
END 
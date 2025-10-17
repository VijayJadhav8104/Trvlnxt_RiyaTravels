CREATE procedure [dbo].[UpdateBookingRecords] --UpdateBookingRecords 
@PKID int
,@GDSPNR nvarchar(10)=''
,@Remark nvarchar(500)=''
,@TicketNum nvarchar(50)=''
,@AirlinePNR nvarchar(10)=''

AS 
  BEGIN 
   declare @newticketno varchar(50)
      IF @GDSPNR != '' 
        BEGIN 
            UPDATE tblbookmaster 
            SET    gdspnr = @GDSPNR,Remarks=@Remark,IsBooked=1,BookingStatus=6
            WHERE  pkid = @PKID 
        END 

     else IF @TicketNum != '' 
        BEGIN
			if(len(@ticketNum) > 20)       
			begin       
			   set @newticketno=SUBSTRING(@ticketNum,9,10)       
			end      
			else if(len(@ticketNum)=15 or len(@ticketNum)=13)       
			begin       
				set @newticketno=SUBSTRING(@ticketNum,4,10)       
				set @ticketNum=SUBSTRING(@ticketNum,4,10)       
			end      
			else if(len(@ticketNum)=14)       
			begin       
				set @newticketno=SUBSTRING(@ticketNum,5,10)          
			end      
			else      
			begin      
				set @newticketno=@ticketNum      
			end
			
			UPDATE tblpassengerbookdetails 
            SET    ticketnum = @TicketNum ,TicketNumber=@newticketno
            WHERE  pid = @PKID 
        END 

     else IF @AirlinePNR != '' 
        BEGIN 
            UPDATE tblbookitenary 
            SET    airlinepnr = @AirlinePNR 
            WHERE  pkid = @PKID 
        END 


Declare @Vendor_No nvarchar(50)
Declare @IATA nvarchar(50)
Declare @airCode nvarchar(50)

SELECT @airCode=airCode FROM tblBookMaster WHERE GDSPNR=@GDSPNR

IF(@airCode ='6E' OR @airCode ='SG' OR @airCode ='G8')
BEGIN
SELECT  @IATA=(case when airCode='6E' then 'OTC018' when airCode='G8' then 'RYASUB02' when airCode='SG' then 'RTSHPA4949' end)  
FROM tblBookMaster WHERE GDSPNR=@GDSPNR
END
ELSE
BEGIN
     SELECT @IATA=IATA FROM tblBookMaster WHERE GDSPNR=@GDSPNR 
END

select @Vendor_No=Vendor_No from VendorMaster where IATA=@IATA

if(@Vendor_No !='')
begin
UPDATE tblBookMaster SET Vendor_No=@Vendor_No WHERE GDSPNR=@GDSPNR 
end
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateBookingRecords] TO [rt_read]
    AS [dbo];


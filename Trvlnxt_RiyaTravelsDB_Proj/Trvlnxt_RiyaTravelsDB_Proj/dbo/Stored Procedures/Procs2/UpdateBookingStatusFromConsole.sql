CREATE proc [dbo].[UpdateBookingStatusFromConsole]--[dbo].[UpdateBookingStatusFromConsole] 'DEL','DXB','5YIZKB'                    
@GDSPNR varchar(50) = null                  
,@BookingStatus varchar(10) = null                  
,@riyapnr varchar(20) = null            
,@orderid varchar(20) = null      
,@IsBooked varchar(10) = null  
,@MainAgentID varchar(20) = ''  
      
                    
as                    
begin
	if(@MainAgentID = null OR @MainAgentID = '')
	begin
		Update tblBookMaster set BookingStatus = @BookingStatus,IsBooked = @IsBooked              
		Where riyaPNR = @riyapnr and orderId = @orderid and GDSPNR = @GDSPNR  
	end
	else
	begin
		Update tblBookMaster set BookingStatus = @BookingStatus,IsBooked = @IsBooked,MainAgentId = @MainAgentID              
		Where riyaPNR = @riyapnr and orderId = @orderid and GDSPNR = @GDSPNR
	end
end 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateBookingStatusFromConsole] TO [rt_read]
    AS [dbo];


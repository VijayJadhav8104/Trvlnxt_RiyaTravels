CREATE procedure API_ReissueUpdate      
@Orderid varchar(100),      
@ParentOrderid varchar(100),      
@RiyaPNR varchar(20),    
@TripType varchar(5) = ''    
    
as      
begin      
      
  if @TripType = 'RO'    
  begin    
 update tblBookMaster set BookingStatus = '18' where orderId = @ParentOrderid and returnFlag = 0 and riyaPNR = @RiyaPNR     
  end    
  else if @TripType = 'RR'    
  begin    
    update tblBookMaster set BookingStatus = '18' where orderId = @ParentOrderid and returnFlag = 1 and riyaPNR = @RiyaPNR     
  end    
  else     
  begin    
 update tblBookMaster set BookingStatus = '18' where orderId != @Orderid and riyaPNR = @RiyaPNR     
  end    
end 
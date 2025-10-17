CREATE procedure Transfer_RetrivalAPICAll    
@Type varchar(50) = '',
@DriverFirstName varchar(50) = '',
@DriverLastName varchar(50) = '',
@DriverMobileNo varchar(50) = '',
@ProviderConfirmationNumber varchar(50) = ''
As     
Begin   
	if(@Type='Select')
		Begin
			 Select AgentId, ProviderConfirmationNumber, CorrelationId FROM TR.TR_BookingMaster WHERE         
    
			 -- Condition 1: CreationDate is at least 1 minute old and IsRetrieveAPI = 0         
    
			 (IsRetrieveAPI = 0 AND CreationDate <= DATEADD(MINUTE, -1, GETDATE()))       
    
			 OR         
    
			 -- Condition 2: BookingDate & BookingTime are exactly 24 hours away and IsRetrieveAPI = 1         
      
			 (IsRetrieveAPI = 1 AND DATEADD(HOUR, 24, GETDATE()) >= CAST(TripStartDate AS DATETIME) + CAST(TripStartTime AS DATETIME));     
		End;
	if(@Type='Insert')
		Begin
			update TR.TR_BookingMaster set DriverFirstName = @DriverFirstName, 
			DriverLastName = @DriverLastName, DriverMobileNo = @DriverMobileNo
			where ProviderConfirmationNumber = @ProviderConfirmationNumber
		End;
End;
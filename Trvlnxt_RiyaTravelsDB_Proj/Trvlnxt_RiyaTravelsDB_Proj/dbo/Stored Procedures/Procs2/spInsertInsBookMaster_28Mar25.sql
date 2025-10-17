create proc [dbo].[spInsertInsBookMaster_28Mar25]                 
            @orderID varchar(30),                
			@planId  varchar(50), 
			@planName  varchar(50)=null,             
			@RiyaPNR  varchar(50)=null,              
			@totalfare decimal(18, 2),             
			@optionalCoveragesTotal varchar(50)=null,               
			@address1  varchar(250)=null,            
			@address2  varchar(250)=null,              
			@postalCode varchar(50)=null,                
			@cityName varchar(50)=null,
			@cityCode varchar(50)=null,
			@stateName varchar(50)=null,
			@stateCode varchar(50)=null,
			@countryName varchar(50)=null,
			@countryCode varchar(50)=null,
			@phoneNumber varchar(50)=null,
			@emailAddress varchar(50)=null,
			@contactType varchar(50)=null,
			@effectiveDate datetime=null,
			@expirationDate datetime=null,
			@depositDate datetime=null,
			@totalTripCost decimal(18, 2)=null,
			@insertdate datetime=null,
			@Bookingstatus int=0,
			@userID varchar(50)=null,
			@AgentROE decimal(18, 2)=null,
			@ROE decimal(18, 2)=null,
			@AgentID varchar(50)=null,
			@NoofDays int=null,
			@Noofpax  int=null,
			@IssueBy varchar(50)=null,
			@TotalMarkupAmt decimal(18,2)=0,
			@MarkupFlat decimal(18,2)=0,
			@MarkupPerc decimal(18,2)=0,
			@BookingType int,
			@VendorName varchar(25),
			@token nvarchar(max)=null,
			@AgentCurrency varchar(30)=null,
			@VendorCurrency varchar(30)=null,
			@VendorLoginID varchar(50)=null


			
as                
begin                
    
    
    
	INSERT INTO [dbo].[tblInsBookMaster]                
	(
			orderID,                
			planId                
			,totalfare                
			,optionalCoveragesTotal                
			,address1                
			,address2                
			,postalCode                
			, cityName
			, cityCode
			, stateName
			, stateCode
			, countryName
			, countryCode
			, phoneNumber
			, emailAddress
			, contactType
			, effectiveDate
			, expirationDate
			, depositDate
			, totalTripCost
			, insertedDate
			, Bookingstatus
			, userID
			, AgentROE
			, ROE
			, AgentID
			, NoofDays
			, Noofpax
			,planName
			,RiyaPNR
			,BookedBy
			,ManagementFees
			,ManagementMarkupFlat
			,ManagementMarkupPerc
			,ManagementMarkupBookingType
			,token 
			,VendorName
			,AgentCurrency
			,VendorCurrency
			,VendorLoginID

	)                
	VALUES                
	(
			@orderID,                
			@planId                
			,@totalfare                
			,@optionalCoveragesTotal                
			,@address1                
			,@address2                
			,@postalCode                
			, @cityName
			, @cityCode
			, @stateName
			, @stateCode
			, @countryName
			, @countryCode
			, @phoneNumber
			, @emailAddress
			, @contactType
			, @effectiveDate
			, @expirationDate
			, @depositDate
			, @totalTripCost
			, getdate()
			, @Bookingstatus
			, @userID
			, @AgentROE
			, @ROE
			, @AgentID
			, @NoofDays
			, @Noofpax  
			,@planName
			,@RiyaPNR
    ,@IssueBy
    ,@TotalMarkupAmt
    ,@MarkupFlat
    ,@MarkupPerc
	,@BookingType
	,@token
	,@VendorName
	,@AgentCurrency
	,@VendorCurrency
	,@VendorLoginID
	)                
                 
  select SCOPE_IDENTITY();                
                   
end 
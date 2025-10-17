CREATE proc [dbo].[spInsertInsBookPassenger]              
            @fkInsBookmaster bigint=null,              
            @paxTitle varchar(10)=null, 
            @paxFname varchar(50)=null,
            @paxMname varchar(50)=null,
            @paxLname varchar(50)=null,
            @paxDOB varchar(50)=null,
            @address1 varchar(50)=null,  
            @address2 varchar(50)=null,
            @postalCode varchar(50)=null, 
            @cityName varchar(50)=null,
            @cityCode varchar(50)=null,              
            @stateName varchar(50)=null,
            @stateCode varchar(50)=null,  
            @CountryName varchar(50)=null,
            @CountryCode varchar(50)=null,  
            @insertedDate varchar(50) =null,  
            @BookingStatus int=null,
            @individualTripCost decimal(18, 2)=null,
			@basePremium decimal(18, 2)=null,
			@serviceTax decimal(18, 2)=null,			
            @totalFare decimal(18, 2) ,
			@orderNumber varchar(50)=null,
			@orderID varchar(50)=null,
			@PassportFileNo varchar(50)=null,  
			@MarkupPerc decimal(18,2)=0,
			@MarkupAmt decimal(18,2)=0,
			@servicefee decimal(18,2)=0,
			@gst decimal(18,2)=0,
			@discount varchar(50)=null,  
			-- @age int=null,  
			@PaxStatus int=null,
			@paxType varchar(10)=null,
			@age int
			

AS              
BEGIN              
 --     set @passPortIssueCountry= (select top 1 country from Country with(nolock) where A1 = @PassportIssueCountryCode)            
 --set @nationality= (select top 1 country from Country with(nolock) where A1 = @NationaltyCode)            
        
INSERT INTO [dbo].[tblInsPassengerDetails]              
           (
				fkInsBookmaster              
				,paxTitle              
				,paxFname              
				,paxMname              
				,paxLname              
				,paxDOB              
				,insertedDate             
				,BookingStatus             
				,individualTripCost              
				,basePremium
				,serviceTax
				,totalFare				
				,orderNumber
      ,orderID
      ,ManagementMarkupAmt
	  ,servicefee 
	  ,gst
	  ,discount 
	  ,PaxStatus
	  ,PassportNo 
	 ,paxType
		,age
	  )
     --End              
     VALUES              
           (              
     @fkInsBookmaster              
				,@paxTitle              
				,@paxFname              
				,@paxMname              
				,@paxLname              
				,@paxDOB              
				,GETDATE()            
				,@BookingStatus             
				,@individualTripCost
				,@basePremium
				,@serviceTax
				,@totalFare  
				,@orderNumber
				,@orderID
				,@MarkupAmt
			,@servicefee
			,@gst 
			,@discount
				,@PaxStatus
				,@PassportFileNo 
				,@paxType
				,@age 
     --End              
     )              
select SCOPE_IDENTITY();              
          
end 
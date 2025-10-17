CREATE proc [dbo].[FetchFlightQuatation] --'10/14/2021 12:00:00 AM','10/14/2021 12:00:00 AM','IN','D','ALL','Marine','1220','','','','','','','Y'          
	@Travelfrom datetime
	,@Travelto datetime
	,@Marketpoint varchar(5)
	,@AirportType varchar(5)
	,@AirlineType nvarchar(100)
	,@UserType VARCHAR(10)
	,@AgencyNames VARCHAR (MAX)=NULL
	,@RBDValue VARCHAR (10)=NULL
	,@FareBasisValue VARCHAR (10)=NULL
	,@FlightSeriesValue VARCHAR (10)=NULL
	,@OriginValue VARCHAR (10)=NULL
	,@DestinationValue VARCHAR (10)=NULL
	,@FlightNoValue VARCHAR (10)=NULL
	,@Cabin VARCHAR (50) = NULL   
AS
BEGIN
	
	DECLARE @rowcount AS INT        
      
	DECLARE @ParentID INT          
	
	SELECT @ParentID = ParentAgentID FROM AgentLogin(nolock) WHERE cast(UserID as varchar(100)) = @AgencyNames        
 
	IF(@ParentID IS NOT NULL)      
	BEGIN      
		SET @AgencyNames=@ParentID      
	END      
          
	select @rowcount=count(tbl_ServiceFee_GST_QuatationDetails.Id)          
	FROM tbl_ServiceFee_GST_QuatationDetails          
	LEFT OUTER JOIN mCommon on tbl_ServiceFee_GST_QuatationDetails.Quatation=mCommon.ID          
	WHERE @TravelFrom >=TravelValidityFrom and @TravelFrom <=TravelValidityTo 
	and @Travelto >=TravelValidityFrom 
	and @Travelto <=TravelValidityTo  
	AND SaleValidityFrom <=  CONVERT(DATE,GETDATE()) and SaleValidityTo  >= CONVERT(DATE,GETDATE())  
	AND MarketPoint = @Marketpoint           
	--AND (UserType='B2C' OR  (UserType=@UserType AND (agencyid like '%' + @AgencyNames + '%'))) and (AirportType = @AirportType OR AirportType = 'B')          
	AND (UserType='B2C' OR  (UserType=@UserType AND (@AgencyNames IN (SELECT Split.a.value('.', 'NVARCHAR(MAX)') DATA FROM( SELECT CAST('<X>'+REPLACE(agencyid, ',', '</X><X>')+'</X>' AS XML) AS String) AS A CROSS APPLY String.nodes('/X') AS Split(a) ))))  
	and (AirportType = @AirportType OR AirportType = 'B')          
	AND Flag=1           
          
	IF(@rowcount>0)          
	BEGIN          
		PRINT 1
	
		SELECT RBD,RBDValue,FlightSeries,FlightSeriesValue,FareBasis,FareBasisValue,Origin,OriginValue,Destination,DestinationValue,          
		FlightNo,ServiceFee,GST,mCommon.value as Quatation,AirportType,AirlineType,Cabin,isnull(BookingType,0) as BookingType     
		,AvailabilityPCC,Currency,UserType  
		,(case when AgencyId='' then '0' else AgencyId end) as AgencyId
		FROM  tbl_ServiceFee_GST_QuatationDetails          
		left outer join mCommon on tbl_ServiceFee_GST_QuatationDetails.Quatation=mCommon.ID          
		WHERE @TravelFrom >=TravelValidityFrom and @TravelFrom <=TravelValidityTo and          
		@Travelto >=TravelValidityFrom and @Travelto <=TravelValidityTo  AND          
		SaleValidityFrom <=  CONVERT(DATE,GETDATE()) and SaleValidityTo  >= CONVERT(DATE,GETDATE())  AND          
		MarketPoint = @Marketpoint           
		--AND (UserType='B2C' OR  (UserType=@UserType AND (agencyid like '%' + @AgencyNames + '%')))  and (AirportType = @AirportType OR AirportType = 'B')          
		AND (UserType='B2C' OR  (UserType=@UserType AND (@AgencyNames IN (SELECT Split.a.value('.', 'NVARCHAR(MAX)') DATA FROM( SELECT CAST('<X>'+REPLACE(agencyid, ',', '</X><X>')+'</X>' AS XML) AS String) AS A CROSS APPLY String.nodes('/X') AS Split(a) ))))  
		and (AirportType = @AirportType OR AirportType = 'B')          
		AND Flag=1           
		ORDER BY InsertedDate DESC    
	END          
	ELSE          
	BEGIN      
		PRINT 2

		select 2 as test, RBD,RBDValue,FlightSeries,FlightSeriesValue,FareBasis,FareBasisValue,Origin,OriginValue,Destination,DestinationValue,          
		FlightNo,ServiceFee,GST,mCommon.value as Quatation,AirportType,AirlineType,Cabin,isnull(BookingType,0) as BookingType      
		,AvailabilityPCC
		,Currency,UserType    
		,(case when AgencyId='' then '0' else AgencyId end) as AgencyId
		FROM  tbl_ServiceFee_GST_QuatationDetails          
		left outer join mCommon on tbl_ServiceFee_GST_QuatationDetails.Quatation=mCommon.ID          
		WHERE @TravelFrom >=TravelValidityFrom and @TravelFrom <=TravelValidityTo and          
		@Travelto >=TravelValidityFrom and @Travelto <=TravelValidityTo  AND          
		SaleValidityFrom <=  CONVERT(DATE,GETDATE()) and SaleValidityTo  >= CONVERT(DATE,GETDATE())  AND          
		MarketPoint = @Marketpoint           
		AND (UserType='B2C' OR  (UserType=@UserType AND (agencyid='0')))  and (AirportType = @AirportType OR AirportType = 'B')          
		AND Flag=1           
		ORDER BY InsertedDate DESC          
	END          
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchFlightQuatation] TO [rt_read]
    AS [dbo];


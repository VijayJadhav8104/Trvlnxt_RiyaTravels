CREATE PROC [dbo].[UPDATE_B2BREGICAST]
@ID int,
@ICust varchar(50),
@UpdatedBy varchar(50),
@CreditLimit decimal(18,4)=null,
@Status int=null,
@SalesPersonName nvarchar(100)=null,
@AutoTicketing bit=0,
@IssueTicket bit=null,
@amadeusCrypticCmd bit=null,
@saberCrypticCmd bit=null,
@Airline bit=null,
@Hotel bit=null,
@AirlineStartDate datetime=null,
@AirlineCreditday int=null,
@HotelCreditDay int=null,
@LocationCode nvarchar(100)=null


AS
BEGIN
		Declare @stat varchar(800)=null
		UPDATE B2BRegistration
		SET ICAST= @ICust , 
			UPDATEDBY=@UpdatedBy, 
			updatedDate= GETDATE() , 
			CreditLimit=@CreditLimit,
			SalesPersonName=@SalesPersonName,
			Status=@Status,

			--commented by bhavika
--,AutoTicketing=@AutoTicketing,IssueTicket=@IssueTicket,
			--AmadeusCrypticCmd=@AmadeusCrypticCmd,
			--SaberCrypticCmd=@saberCrypticCmd,
			--Airline=@Airline,
			--Hotel=@Hotel,
			--AirlineStartDate=@AirlineStartDate,
			--AirlineCreditday=@AirlineCreditday,
			--HotelCreditDay=@HotelCreditDay,
			--///////////////

			LocationCode=@LocationCode

			where PKID= @ID

	

			insert into Agent_CreditHistory
			(
				UserId
,

				AgentId,
				CreditLimit,
				UpdatedDate,
				Status
			)
			values
			(
				@UpdatedBy,
				@ID,
				@CreditLimit,
				GETDATE(),			
					(CASE 
	
					when 
							@Status=0 
								THEN 
									'Pending' 
						when 
							@Status=1 
								
								THEN 
									'
Approved' 
						when 
							@Status=2 
								THEN 
									'Rejected' 
						when 
							@Status=3
								THEN 
									'
Blocked' 
						End
					)					
				)		
				
				

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UPDATE_B2BREGICAST] TO [rt_read]
    AS [dbo];


                 
CREATE procedure [dbo].[API_DisplayDynamicInfraAmount] -- [API_DisplayDynamicInfraAmount] 'AE','D','SG','','',''
@Country Varchar(10)=null,                  
@AirportType Varchar(10)=null,                  
@Airline varchar(15)=null,                  
@CheckFormSector varchar(20)=null,                 
@travelFrom varchar(20)=null ,                 
@travelTo varchar(20)=null 

As 
BEGIN               
Declare @Amount decimal(18,2)     

   if(@Airline='6E' OR @Airline='IX' OR @Airline='I5' OR @Airline='QP')  
   begin

    Select @Amount=Amount from tbl_DynamicInfraAmount WITH (NOLOCK) WHERE Country=@Country AND AirportType=@AirportType AND Airline=@Airline                  
    Select @Amount AS Amount

   end
   else if(@Airline='SG')  
   begin
   
    IF exists(select * from sectors where [Country Code]='IN' AND Code= @travelFrom)   
	BEGIN                                           
		Select @Amount=Amount from tbl_DynamicInfraAmount WITH (NOLOCK) WHERE  Country=@Country AND AirportType=@AirportType AND Airline=@Airline AND CheckFormSector='IN'                  
		Select @Amount AS Amount                 
		return                  
	END                  
	ELSE                  
		BEGIN                                  
		Select @Amount=Amount from tbl_DynamicInfraAmount WITH (NOLOCK) WHERE  Country=@Country AND AirportType=@AirportType AND Airline=@Airline --AND CheckFormSector=''                  
		Select @Amount AS Amount            
	END    
   end
END


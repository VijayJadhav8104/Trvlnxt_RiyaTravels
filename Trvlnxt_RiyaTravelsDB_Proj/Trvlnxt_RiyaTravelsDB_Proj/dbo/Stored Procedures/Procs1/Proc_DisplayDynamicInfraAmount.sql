--Created By:- Ketan Marade                
--Date:- 28-03-2022                
CREATE procedure [dbo].[Proc_DisplayDynamicInfraAmount]                
@UserType varchar(15)=null,                
@Country Varchar(10)=null,                
@AirportType Varchar(10)=null,                
@Airline varchar(15)=null,                
@CheckFormSector varchar(20)=null,                
@OneWay int=NULL,                
@AgentCurrency varchar(20)=null,                
@travelFrom varchar(20)=null ,               
@travelTo varchar(20)=null ,
@Version int=0

As                
Declare @SETCurrency VARCHAR(20)                
Declare @Amount decimal(18,2)                
SET @SETCurrency='INR'                
Begin                
 if(@Airline='6E')                
 BEGIN                
 if ((@UserType = 'B2B' OR @UserType = 'RBT') OR (@UserType = 'MN' AND @AgentCurrency = 'AED'))                
 BEGIN                
 SELECT @SETCurrency = 'AED'                
 END                
 if (@UserType = 'B2B' AND @AgentCurrency = 'INR') OR (@UserType = 'RBT' AND (@AgentCurrency = 'USD' or @AgentCurrency='GBP' or @AgentCurrency = 'CAD'))                      
 BEGIN                
 SELECT @SETCurrency = 'INR'                
 END                
 Select @Amount=Amount from tbl_DynamicInfraAmount WITH (NOLOCK) WHERE UserType=@UserType AND Country=@Country AND AirportType=@AirportType AND Airline=@Airline                
 Select @Amount AS Amount, @SETCurrency AS Currency                 
 return                
 END 

 IF(@Airline='SG' and @Version=1)                
 BEGIN                
                
  IF exists(select * from sectors where [Country Code]='IN' AND Code= @travelFrom) 
  BEGIN                               
  SELECT @SETCurrency = @AgentCurrency                
  Select @Amount=Amount from tbl_DynamicInfraAmount WITH (NOLOCK) WHERE  Country=@Country AND AirportType=@AirportType AND Airline=@Airline AND CheckFormSector='IN'                
  Select @Amount AS Amount, @SETCurrency AS Currency                 
  return                
  END                
  ELSE                
  BEGIN                
         SELECT @SETCurrency = @AgentCurrency                
		Select @Amount=Amount from tbl_DynamicInfraAmount WITH (NOLOCK) WHERE  Country=@Country AND AirportType=@AirportType AND Airline=@Airline AND CheckFormSector=''                
		Select @Amount AS Amount, @SETCurrency AS Currency           
 END  
 END
 IF(@Airline='SG')                
 BEGIN                
                
  IF((@CheckFormSector='IN') AND @OneWay=1)                
  BEGIN                
  if ((@UserType = 'B2B' OR @UserType = 'RBT') OR (@UserType = 'MN' AND @AgentCurrency = 'AED'))                
  BEGIN                
  SELECT @SETCurrency = 'AED'                
  END                
  if (@UserType = 'B2B' AND @AgentCurrency = 'INR') OR (@UserType = 'RBT' and (@AgentCurrency = 'USD' or @AgentCurrency='GBP' or @AgentCurrency = 'CAD'))           
  BEGIN                
  SELECT @SETCurrency = 'INR'                
  END                
  Select @Amount=Amount from tbl_DynamicInfraAmount WITH (NOLOCK) WHERE UserType=@UserType AND Country=@Country AND AirportType=@AirportType AND Airline=@Airline AND CheckFormSector=@CheckFormSector                
  Select @Amount AS Amount, @SETCurrency AS Currency                 
  return                
  END                
  ELSE                
  BEGIN                
  if ((@UserType = 'B2B' OR @UserType = 'RBT') OR (@UserType = 'MN' AND @AgentCurrency = 'AED'))                
  BEGIN                
  SELECT @SETCurrency = 'AED'                
  END                
  if (@UserType = 'B2B' AND @AgentCurrency = 'INR')  OR (@UserType = 'RBT' AND (@AgentCurrency = 'USD' or @AgentCurrency='GBP' or @AgentCurrency = 'CAD'))             
  BEGIN                
  SELECT @SETCurrency = 'INR'                
  END                
  Select  @Amount=Amount from tbl_DynamicInfraAmount WITH (NOLOCK) WHERE UserType=@UserType AND Country=@Country AND AirportType=@AirportType AND Airline=@Airline AND CheckFormSector =@CheckFormSector                
  Select @Amount AS Amount, @SETCurrency AS Currency                 
  return                
  END                
 END 
 

 

 if(@Airline='G8')                
 BEGIN                
 if ((@UserType = 'B2B' OR @UserType = 'RBT') OR (@UserType = 'MN' AND @AgentCurrency = 'AED'))                
  BEGIN                
  SELECT @SETCurrency = 'AED'                
  END                
  if (@UserType = 'B2B' AND @AgentCurrency = 'INR')  OR (@UserType = 'RBT' AND (@AgentCurrency = 'USD' or @AgentCurrency='GBP' or @AgentCurrency = 'CAD'))                    
  BEGIN                
  SELECT @SETCurrency = 'INR'                
  END                
 Select @Amount=Amount from tbl_DynamicInfraAmount WITH (NOLOCK) WHERE UserType=@UserType AND Country=@Country AND AirportType=@AirportType AND Airline=@Airline                
 Select @Amount AS Amount, @SETCurrency AS Currency                 
 return             
 END                
    
 if(@Airline='IX')      
 BEGIN      
  if (@UserType = 'B2B' AND @AgentCurrency = 'AED')      
  BEGIN      
   Select @Amount=Amount from tbl_DynamicInfraAmount WITH (NOLOCK) WHERE UserType=@UserType AND Country=@Country AND Airline=@Airline      
   Select @Amount AS Amount, @SETCurrency AS Currency       
   return         
  END      
 END    
    
 if(@Airline='I5')      
   BEGIN      
     if ((@UserType = 'B2B' OR @UserType = 'RBT') OR (@UserType = 'MN' AND @AgentCurrency = 'AED'))      
     BEGIN      
       SELECT @SETCurrency = 'AED'      
     END      
     if (@UserType = 'B2B' AND(@AgentCurrency = 'INR' or @AgentCurrency ='USD'))      
     BEGIN      
       SELECT @SETCurrency = 'INR'      
     END      
        Select @Amount=Amount from tbl_DynamicInfraAmount WITH (NOLOCK) WHERE UserType=@UserType AND Country=@Country AND AirportType=@AirportType AND Airline=@Airline      
        Select @Amount AS Amount, @SETCurrency AS Currency       
     return      
   END      
  if(@Airline='QP')      
   BEGIN              
       SELECT @SETCurrency = 'INR'      
        Select @Amount=Amount from tbl_DynamicInfraAmount WITH (NOLOCK)   
  WHERE  AirportType=@AirportType AND Airline=@Airline      
        Select @Amount AS Amount, @SETCurrency AS Currency       
     return      
   END      
End 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Proc_DisplayDynamicInfraAmount] TO [rt_read]
    AS [dbo];


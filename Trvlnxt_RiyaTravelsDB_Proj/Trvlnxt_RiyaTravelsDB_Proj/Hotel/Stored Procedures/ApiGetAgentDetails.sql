 CREATE  Proc [Hotel].ApiGetAgentDetails
 @Agentid int
 AS 
 BEGIN
 select 
 isnull(BookingCountry,'') as 'BookingCountry',
 isnull(UserTypeID,0) as 'TypeId',
 ISNULL(CC.CurrencyCode ,'') as 'Currency'
 from AgentLogin AL
 left join mCountryCurrency CC on AL.BookingCountry=CC.CountryCode
 where UserID=@Agentid 


 END
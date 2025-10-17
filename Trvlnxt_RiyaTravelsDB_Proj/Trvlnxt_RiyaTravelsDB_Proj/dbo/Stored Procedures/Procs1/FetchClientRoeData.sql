-- =============================================    
-- Author:  <Dhanraj Bendale>    
-- Create date: <2024-09-25 16:14:08.850>    
-- Description: <Fetch Client roe data    
-- =============================================    
CREATE PROCEDURE FetchClientRoeData    
     
AS    
BEGIN    
              
declare @officeid varchar(20)='DXBAD3359',@LOCALTIME TIME,@COUNTRY VARCHAR(20)='AE'              
SET @LOCALTIME=(select cast(GETDATE() as time))              
--if  @LOCALTIME BETWEEN '00:59:00.0000000' AND  '01:30:00.0000000'       
--if  @LOCALTIME BETWEEN '00:59:00.0000000' AND  '23:30:00.0000000'              
--begin              
-- set @officeid='BOMI22114'              
-- set @COUNTRY='IN'              
--end              
----US DATE              
--if @LOCALTIME BETWEEN '12:15:00.0000000' AND '12:29:00.0000000'              
--begin              
-- set @officeid='DFW1S212A'              
-- set @COUNTRY='US'              
--end              
----UK DATE              
--if @LOCALTIME BETWEEN '06:29:00.0000000' AND '07:00:00.0000000'               
--begin              
-- set @officeid='LONTK3116'              
-- set @COUNTRY='UK'              
--end              
--UAE TIME              
if @LOCALTIME BETWEEN '02:29:00.0000000' AND '03:00:00.0000000'               
begin              
 set @officeid='DXBAD3359'              
 set @COUNTRY='AE'              
end              
--CAD TIME              
--if @LOCALTIME BETWEEN '12:30:00.0000000' AND '12:45:00.0000000'               
--begin              
-- set @officeid='YWGC4211G'              
-- set @COUNTRY='CA'              
--END       
    
 SELECT C.CurrencyCode AS 'fromCountry',A.Currency AS 'ToCountry',@officeid as OfficeId,A.ID,AgencyID,ROE,UserType from mAgentROE A     
 inner join mCountryCurrency C on A.Country = C.CountryCode where A.Country=@COUNTRY    
    
END 
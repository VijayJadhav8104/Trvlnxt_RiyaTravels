CREATE Proc [dbo].FetchClientROEDataMails                    
                    
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
  
  SELECT distinct C.CurrencyCode AS 'fromCountry',Cn.CountryName as 'CountryName',A.Currency AS 'ToCountry',    
  @officeid as OfficeId,A.ID,A.AgencyID,A.ROE as ClientROE,A.UserType ,H.ROE as OldROE,    
  (select STRING_AGG(CustomerCOde,',')  from B2BRegistration where PKID in(select Item from SplitString(a.AgencyID,','))) as 'Customers'    
  from mAgentROE A    inner join mCountryCurrency C on A.Country = C.CountryCode    
 inner join mCountry Cn on A.Country = Cn.CountryCode     
 inner join mAgentROEHistory H on A.ID = H.ROEId     
 where A.Country=@COUNTRY      and A.UserType !='Marine' and A.UserType !='B2C'      
            
END            
          
--select * from mAgentROEHistory r where Flag=1 and ProductId=224 and UserTypeId=5   order by ModifiedOn desc    
    
--select STRING_AGG(CustomerCOde,',') as 'tt' from B2BRegistration where PKID in(1,2)    
--select ((select STRING_AGG(CustomerCOde,',')  from B2BRegistration where PKID in(select value from string_split('1,2,3,',',')))) as 'Customers'
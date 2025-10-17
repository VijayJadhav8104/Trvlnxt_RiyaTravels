CREATE Proc [dbo].[FetchROEDataMails]                                
                                
AS                                 
BEGIN                                
                        
                        
declare @officeid varchar(20)='BOMI22114',@LOCALTIME TIME,@COUNTRY VARCHAR(20)='India'                    
SET @LOCALTIME=(select cast(GETDATE() as time))          
        
if  @LOCALTIME BETWEEN '00:59:00.0000000' AND  '01:30:00.0000000'                    
begin                    
 set @officeid='BOMI22114'                    
 set @COUNTRY='India'                    
end   
--TH Thailand
if  @LOCALTIME BETWEEN '22:30:00.0000000' AND  '23:00:00.0000000'                    
begin                    
 set @officeid='BKKOK25CL'                    
 set @COUNTRY='Thailand'                    
end   
--US DATE                    
if @LOCALTIME BETWEEN '12:15:00.0000000' AND '12:29:00.0000000'                    
begin                    
 set @officeid='DFW1S212A'                    
 set @COUNTRY='USA'                    
end                    
--UK DATE                    
if @LOCALTIME BETWEEN '06:29:00.0000000' AND '07:00:00.0000000'                     
--if @LOCALTIME BETWEEN '12:55:00.0000000' AND '13:30:00.0000000'      
begin                    
 set @officeid='LONTK3116'                    
 set @COUNTRY='United Kingdom'                    
end                    
--UAE TIME                    
if @LOCALTIME BETWEEN '02:29:00.0000000' AND '03:00:00.0000000'                     
begin                    
 set @officeid='DXBAD3359'                    
 set @COUNTRY='UAE'                    
end                    
--CAD TIME                    
if  @LOCALTIME BETWEEN '12:30:00.0000000' AND '12:45:00.0000000'                     
begin                    
 set @officeid='YWGC4211G'                    
 set @COUNTRY='Canada'                    
END                    
--SAR TIME (Saudi)       
if @LOCALTIME BETWEEN '03:30:00.0000000' AND '03:45:00.0000000'                     
begin                    
 set @officeid='RUHS22539'                    
 set @COUNTRY='Saudi Arabia'                    
END      
        
select    r.ID, m.Value AS [fromCountry] ,                      
m1.Value AS [ToCountry],ROE as 'Final ROE',                        
r.VendorROE,U.Value AS UserType,                      
v.VendorName,c.CountryName ,r.MarkupAmount,r.MarkupType,r.MarkupData,                      
case when r.IsAddSubtract=1 then '+'                      
else '-' end as IsAddSubtract,r.OfficeIdText,isnull(r.IsROEMarkup,0) as IsROEMarkup,                      
(select TOP 1 OldROE from mROEHistoryAir where ROEId=r.ID order by HistoryId desc) as OldROE                      
from mROEUpdation r                          
inner join mCommon m on m.ID=r.BaseCurrencyId                          
inner join mCommon m1 on m1.ID=r.ToCurrencyId                          
inner join mCommon U on u.ID =r.UserTypeId and U.Category='UserType'                      
inner join mVendor v on v.ID=r.VendorId  and v.ID != 75 and v.VendorName != 'Scoot NDC'                                      
inner join mCountry c on c.ID=r.CountryId                        
where ProductId=224 and (UserTypeId=5 or UserTypeId=2 or UserTypeId=4)  and c.CountryName=@COUNTRY            
--where Flag=1 and ProductId=224 and UserTypeId=5  and c.CountryName=@COUNTRY        Flag=1 and         -- and GDSTypeID=217                 
        order by UserTypeId asc                
END                        
                      
--select IsROEMarkup,* from mROEUpdation r where Flag=1 and ProductId=224 and UserTypeId=5   order by ModifiedOn desc



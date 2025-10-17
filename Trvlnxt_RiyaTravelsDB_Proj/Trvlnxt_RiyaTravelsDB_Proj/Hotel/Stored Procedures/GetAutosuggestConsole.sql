--use RiyaTravels    
    
    
--- Created By: Aman Wagde  ---    
---  Created Date : 05/06/2024 ---    
    
CREATE Procedure Hotel.GetAutosuggestConsole    
@Type varchar(100)='',    
@AutosuggestValue varchar(500)=''    
    
    
as     
    
Begin    
    
if(@Type ='username')    
begin    
select top 10  ID as 'AutosuggestValue' ,UserName +' - '+ FullName as 'AutosuggestName' from mUser  where (UserName LIKE '%'+@AutosuggestValue +'%' or  FullName LIKE '%'+@AutosuggestValue +'%')     
end    
else if(@Type='branch')    
begin    
    
 select  distinct top 10 BranchCode  as 'AutosuggestValue', BranchCode +' - ' +Name as  'AutosuggestName'  from mBranch                   
 where Division = 'RTT' and BranchCode like 'BRH%'           
     
 and    (BranchCode LIKE '%'+@AutosuggestValue +'%' or  [Name] LIKE '%'+@AutosuggestValue +'%')     
    
 order by AutosuggestName asc      
    
end    
    
else if(@Type='country')    
begin    
    
 select top 10  CountryCode as 'AutosuggestValue',CountryName as  'AutosuggestName' from Hotel_CountryMaster     
     
 where (CountryName LIKE '%'+@AutosuggestValue +'%')     
 order by CountryName asc                        
    
end    
    
else if(@Type='city')    
begin    
    
 select top 10 ID as 'AutosuggestValue',CityName as  'AutosuggestName' from Hotel_City_Master    
 where (CityName LIKE '%'+@AutosuggestValue +'%')     
 order by CityName asc                        
    
end    
End
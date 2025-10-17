
Create Procedure Hotel.GetAutoCompleteData
@Type varchar(50)='',
@UserName varchar(500)='',
@Branch varchar(500)='',
@Country varchar(500)='',
@City varchar(500)=''
as 

begin 

if(@Type='UserName')
Begin
select top 10 Id,UserName,FullName  from mUser        
 where     
        
    (UserName LIKE '%'+@UserName +'%' or  FullName LIKE '%'+@UserName +'%')
End

else if(@Type='Branch')
Begin
 select distinct BranchCode as Id,[Name] as BranchName  from mBranch             
 where                      
        
    (BranchCode LIKE '%'+@Branch +'%' or  [Name] LIKE '%'+@Branch +'%')
	and Division = 'RTT' and BranchCode like 'BRH%'
	order by BranchName asc
End

else if(@Type='Country')
Begin
 select top 10 CountryCode as 'id',CountryName from Hotel_CountryMaster         
 where     
        
    (CountryName LIKE '%'+@Country +'%')
	order by CountryName asc
End

else if(@Type='City')
Begin
select top 10 ID,RealCityName,* from Hotel_City_Master        
 where     
        
    (RealCityName LIKE '%'+@City +'%')
	order by CityName asc
End

End
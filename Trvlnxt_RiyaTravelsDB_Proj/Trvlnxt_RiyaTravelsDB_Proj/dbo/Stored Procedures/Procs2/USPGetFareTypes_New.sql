 CREATE procedure USPGetFareTypes_New
  @Carrier varchar(5)='',
  @OfficeId varchar(50)=''
as  
begin  
 select * from tblFareTypeFilter where IsActive=0 and OfficeId=@OfficeId and Carrier=@Carrier and ProductClass is not null  
end
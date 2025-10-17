CREATE procedure SelectDataFromAPI  
@APIOrderID nvarchar(50)  
as  
begin  
  
if exists(select apidata from [AllAppLogs].[dbo].APIDataStoreHotel where APIOrderID=@APIOrderID)  
begin  
  
 select apidata,HotelMergeModel,TypeOfExec,FL from [AllAppLogs].[dbo].APIDataStoreHotel where APIOrderID=@APIOrderID  
  
 --delete from APIDataStoreHotel where APIOrderID=@APIOrderID  
  
  
end  
  
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SelectDataFromAPI] TO [rt_read]
    AS [dbo];


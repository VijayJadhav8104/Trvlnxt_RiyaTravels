CREATE procedure InsertAPIData  
@APIOrderID nvarchar(50),  
@APIData nvarchar(max),  
@HotelMergeModel nvarchar(max),  
@TypeOfExec nvarchar(50)=null,  
@FL nvarchar(max)=null  
as  
begin  
  
insert into [AllAppLogs].[dbo].APIDataStoreHotel (APIOrderID,apidata,portal,HotelMergeModel,TypeOfExec,FL,CreatedDate)    
values(@APIOrderID,@APIData,'B2C',@HotelMergeModel,@TypeOfExec,@FL,SWITCHOFFSET(SYSDATETIMEoffset(),'+05:30'))  
  
end 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertAPIData] TO [rt_read]
    AS [dbo];


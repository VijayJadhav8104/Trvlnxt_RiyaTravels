CREATE Procedure [dbo].[Proc_RetriveHotelReconSchedularInfo]
@MethodName Varchar(50)=null,
@Status varchar(50)=null
As
Begin

 declare @lastSuccess datetime= null  
 set @lastSuccess=(select top 1   insertedDate  from RetriveHotelReconSchedularInfo     
 where Status='Success' and MethodName='RetriveHotelReconInfo'   
 order by inserteddate desc  
 )  
 if(datediff(MI,cast(@lastSuccess as datetime),cast(GETDATE() as datetime))>480)            
 Begin 
insert into RetriveHotelReconSchedularInfo(MethodName,Status,InsertedDate)
values(@MethodName,@Status,GETDATE())
End

End
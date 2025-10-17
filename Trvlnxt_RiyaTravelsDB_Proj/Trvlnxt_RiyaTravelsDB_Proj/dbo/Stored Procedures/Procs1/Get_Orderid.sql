CREATE proc Get_Orderid  
@pkid int=null  
As  
Begin  
  Select top 1 orderId, * from Hotel_BookMaster where pkid=@pkid;   
End
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Get_Orderid] TO [rt_read]
    AS [dbo];


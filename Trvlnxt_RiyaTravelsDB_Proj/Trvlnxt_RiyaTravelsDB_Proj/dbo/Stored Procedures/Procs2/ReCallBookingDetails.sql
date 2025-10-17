                
CREATE PROCEDURE ReCallBookingDetails                  
                   
 @OrderId varchar(200)=null                  
                  
As                  
Begin                  
                  
  declare @PkId int=0;                
                
  set @PkId = (select pkId from Hotel_BookMaster where orderId=@OrderId )                
                
  select  HM.orderId,                  
          HM.QutechHotelId,                  
          HM.QutechSearchUniqueId,                  
          HM.QutechSectionUniqueId,                  
          HM.SupplierUsername,                  
          HM.SupplierPassword, 
		  HM.pkId,
		  HM.RiyaAgentID,
		  HM.CancellationDeadLine,
		  HM.B2BPaymentMode,
    HM.LocalHotelId,        
    HM.HotelName,             
    HM.SupplierName,      
 hbm.Id AS SupplierId,      
    RM.RoomTypeDescription as 'RoomType',    
 HM.Meal     
                   
  from Hotel_BookMaster HM                
  join Hotel_Room_master RM on RM.book_fk_id=@PkId           
  LEFT JOIN B2BHotelSupplierMaster HBM on HBM.SupplierName=HM.SupplierName      
  where HM.orderId=@OrderId                  
                  
                  
END 


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[ReCallBookingDetails] TO [rt_read]
    AS [dbo];


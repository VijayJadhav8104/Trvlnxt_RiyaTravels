 /*     Procedure Owner: Prakash Suryawanshi  Created On: 10 Feb 2024  Purpose: Get USER Modified History from [Hotel].[HotelBookingModifyDetails]     Parameters: book_fk_id   Modified By:   Modified On:      */  
  
--EXEC [Hotel].[RiyaTravels_Hotel_ModifyHotelBookingDetailsGetHistory] 67771, 18184  
  
CREATE PROCEDURE [Hotel].[RiyaTravels_Hotel_ModifyHotelBookingDetailsGetHistory]  
 @book_fk_id int = 0                               ,  
 @pax_fk_id int = 0  
AS                            
BEGIN   
 SELECT ROW_NUMBER() OVER (ORDER BY HBM.ID DESC) AS row_num, HBM.ModifiedOn, mu.FullName as UserName   
 FROM mUser mu    
 INNER JOIN [Hotel].[HotelBookingModifyDetails] HBM ON  
 HBM.ModifiedBy=mu.ID  
 WHERE   
  HBM.book_fk_id=@book_fk_id  
  AND HBM.pax_fk_id=@pax_fk_id  
 ORDER BY   
  HBM.ModifiedOn DESC  
END
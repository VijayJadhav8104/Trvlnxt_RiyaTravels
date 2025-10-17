      
      
-- =============================================          
-- Author:  <Author,,Name>          
-- Create date: <Create Date,,>          
-- Description: <Description,,>          
-- GetAllMealMapping 'ROOM ONLY'        
-- =============================================          
CREATE PROCEDURE GetAllMealMapping          
           
          
 @Meal varchar(100)=null          
          
AS          
BEGIN          
           
 declare @MealPkId int=0;          
 --set @MealPkId=(select RiyaMeal_Id from Riya_Meal where Meal in(SELECT Element FROM func_Split('BREAKFAST,ROOM ONLY', ',')))          
 -- select  @MealPkId        
        
 select VM.Meal as Vmeal,          
     VM.VendorMeal_Id ,
	 RM.Meal as RMeal
               
 from Vendor_Meal VM          
 join MealMapping MM on mm.VendorMeal_Id=VM.VendorMeal_Id     
 join Riya_Meal RM on mm.RiyaMeal_Id=RM.RiyaMeal_Id
 where RM.Meal in(SELECT Element FROM func_Split(@Meal, ','))
          
          
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAllMealMapping] TO [rt_read]
    AS [dbo];


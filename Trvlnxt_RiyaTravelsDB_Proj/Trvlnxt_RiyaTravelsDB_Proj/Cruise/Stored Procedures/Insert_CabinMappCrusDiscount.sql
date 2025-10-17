
-- 
CREATE proc [Cruise].[Insert_CabinMappCrusDiscount]  
(  
   
 @FK_CrusId int NULL,  
 @FK_CabinId int NULL  
 )  
 as  
  BEGIN
 insert into CabinMappCrusDiscount(FK_CrusID,FK_CabinId) values(@FK_CrusID,@FK_CabinId) 
  END
   
-- 

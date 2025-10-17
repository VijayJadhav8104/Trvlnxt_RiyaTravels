CREATE proc [Cruise].[Insert_DiscountMappCrusDiscount]  
(  
   
 @FK_CrusId int NULL,  
 @FK_Discount int NULL  
 )  
 as  
 begin  
 insert into DiscountMappCrusDiscount(FK_CrusID,FK_Discount) values(@FK_CrusID,@FK_Discount)  
 end

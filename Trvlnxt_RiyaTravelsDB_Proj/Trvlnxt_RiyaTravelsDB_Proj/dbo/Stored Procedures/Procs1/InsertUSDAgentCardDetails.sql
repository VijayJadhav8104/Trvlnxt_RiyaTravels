CREATE procedure InsertUSDAgentCardDetails  
@FkBookId int=0,  
@CardFullName varchar(400)='',  
@CardNumber varchar(400)='',  
@CardExpiryDate varchar(50)='',
@ProductType varchar(50)='Hotel'
As  
Begin  
insert into USDAgentCardDetails(FKBookId,InsertedDate,CardFullName,CardNumber,CardExpiryDate,ProductType)   
values(@FkBookId,getdate(),@CardFullName,@CardNumber,@CardExpiryDate,@ProductType)  
END
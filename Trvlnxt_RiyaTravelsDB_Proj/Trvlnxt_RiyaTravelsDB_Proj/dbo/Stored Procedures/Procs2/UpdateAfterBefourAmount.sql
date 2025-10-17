CREATE procedure UpdateAfterBefourAmount  
@FkBookId int=0,  
@AmountBeforeCommission decimal(18,2)=0,  
@AmountWithCommission decimal(18,2)=0,
@PanCardNumber varchar(100)='',  
@DoumentsURL varchar(700)='',  
@PanName varchar(100)=''  
As  
Begin  
	--update Hotel_BookMaster Set AmountBeforePgCommission=@AmountBeforeCommission,AmountAfterPgCommision=@AmountWithCommission Where pkId=@FkBookId  

 update Hotel_BookMaster Set AmountBeforePgCommission=@AmountBeforeCommission,AmountAfterPgCommision=@AmountWithCommission,PanCardURL=@DoumentsURL Where pkId=@FkBookId  
 Update Hotel_Pax_master Set Pancard=@PanCardNumber,PanCardName=@PanName where book_fk_id=@FkBookId and IsLeadPax=1  
End
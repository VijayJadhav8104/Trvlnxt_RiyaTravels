CREATE proc updateVCCCardStatus    
@CanceledBy varchar(100)= null    
                    ,@CardNo  varchar(4)= null    
                   ,@reissueToEmail  varchar(max)= null    
                   ,@reissueCCEmail  varchar(100)= null    
                   ,@TransactionID varchar(100),    
       @vccCardStatus varchar(20)= null ,  
    @remark varchar(max)= null,    
    @response varchar(max)= null,  
    @ModifiedBy int=0  
as    
begin     
    
update hotel.tblapicreditcarddeatils     
set    
vccCardStatus=case @vccCardStatus when'cancel'then 'Cancelled' when'reissue'then 'Reissue' else null end,    
VCCCancelDate= case @vccCardStatus when'cancel'then GETDATE() else null end,    
VCCReissueDate=case @vccCardStatus when'reissue'then GETDATE() else null end,     
VCCModifiedBy=@CanceledBy    
  ,remark=@remark,  
  response=@response  
  
where bookingid=@TransactionID    
    
  insert into Hotel_UpdatedHistory             
  (fkbookid,FieldName ,FieldValue,InsertedDate,InsertedBy,UpdatedType)            
  select pkId,'VCC Cancelled',  
  CONCAT_WS(',', @CardNo,@vccCardStatus,@CanceledBy,@remark),  
    
        
  GETDATE(),  
  @ModifiedBy,'vccCanReissue'   
  from Hotel_BookMaster where BookingReference = @TransactionID                
  
End  
--alter table  
-- hotel.tblapicreditcarddeatils   
-- add remark varchar(max) null,  
-- response varchar(max) null
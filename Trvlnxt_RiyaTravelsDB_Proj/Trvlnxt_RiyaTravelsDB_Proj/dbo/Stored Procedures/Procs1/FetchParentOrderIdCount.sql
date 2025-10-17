CREATE proc FetchParentOrderIdCount    
@OrderId varchar(20)    
as begin     
    
select count(*) from Paymentmaster where order_id=@OrderId  or ParentOrderId=@OrderId  
    
end 
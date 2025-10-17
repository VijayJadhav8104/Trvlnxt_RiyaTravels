CREATE proc FetchUniqueOrderID   
@TrvlnxtRiyaPNR varchar(50)    
as begin     
    
select Count(Orderid) from tblBookMaster where riyaPNR = @TrvlnxtRiyaPNR
    
end 
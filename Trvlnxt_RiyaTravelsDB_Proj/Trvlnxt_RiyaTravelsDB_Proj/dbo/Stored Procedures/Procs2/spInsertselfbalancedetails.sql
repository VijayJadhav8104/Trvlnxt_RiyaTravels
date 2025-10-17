CREATE proc [dbo].[spInsertselfbalancedetails]           
            @UserId int=null      
           ,@OrderId varchar(50) = null          
           ,@OpenBalance money =null         
           ,@TransactionAmount money=null         
           ,@CloseBalance money =null        
           ,@createdBy int  =null        
           ,@TransactionType varchar(255)=null          
           ,@Remark varchar(255)=null    
     ,@ProductType varchar(50) = null   
        
as          
begin    



--INSERT INTO [dbo].[tblSelfBalance]          
--           (UserID          
--    ,BookingRef          
--    ,OpenBalance          
--    ,TranscationAmount          
--    ,CloseBalance       
-- ,CreatedBy      
--    ,TransactionType          
--    ,Remark    
-- ,ProductType  
--   )          
--     VALUES          
--           (@UserId         
--     ,@OrderId          
--     ,@OpenBalance          
--     ,@TransactionAmount          
--     ,@CloseBalance       
--  ,@createdBy      
--     ,@TransactionType          
--     ,@Remark   
--  ,@ProductType  
--     )          
           
--  select SCOPE_IDENTITY();     


---  updated query--
BEGIN
    SET NOCOUNT ON;

    DECLARE @NewUserId INT;

    SET @NewUserId = (SELECT TOP 1 UserID 
                      FROM tblSelfBalance 
                      WHERE BookingRef = @OrderId AND TransactionType = 'Debit' 
                      ORDER BY PKID DESC);

    INSERT INTO [dbo].[tblSelfBalance] (          
        UserID,          
        BookingRef,          
        OpenBalance,          
        TranscationAmount,          
        CloseBalance,       
        CreatedBy,      
        TransactionType,          
        Remark,    
        ProductType  
    ) VALUES (          
        @NewUserId,   
        @OrderId,          
        @OpenBalance,          
        @TransactionAmount,          
        @CloseBalance,       
        @CreatedBy,      
        @TransactionType,          
        @Remark,   
        @ProductType  
    );          

    SELECT SCOPE_IDENTITY() AS NewInsertedId;   
END;
             
end 




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertselfbalancedetails] TO [rt_read]
    AS [dbo];


    
      
CREATE PROCEDURE [Hotel].[RiyaTravels_Hotel_ModifyHotelBookingDetails]      
    @book_fk_id INT = NULL,      
    @room_fk_id INT = NULL,      
    @pax_fk_id INT = NULL,      
    @Title VARCHAR(10) = NULL,      
    @FName VARCHAR(100) = NULL,      
    @LName VARCHAR(100) = NULL,      
    @RoomType VARCHAR(500) = NULL,      
    @RoomMealBasis VARCHAR(500) = NULL,      
    @ModifiedBy INT = NULL,      
    @ModifiedName VARCHAR(500) = NULL,      
    @IsLeadPax BIT = NULL ,  
 @RoomInclusion nvarchar(700)=NULL  
AS      
BEGIN      
    SET NOCOUNT ON;    
    
    -- Step 1: Deactivate existing record if found    
    IF EXISTS (    
        SELECT 1     
        FROM [Hotel].[HotelBookingModifyDetails]     
        WHERE book_fk_id = @book_fk_id     
          AND room_fk_id = @room_fk_id     
          AND pax_fk_id = @pax_fk_id     
          AND IsActive = 1    
    )    
    BEGIN    
        UPDATE [Hotel].[HotelBookingModifyDetails]    
        SET IsActive = 0    
        WHERE book_fk_id = @book_fk_id    
          AND room_fk_id = @room_fk_id    
          AND pax_fk_id = @pax_fk_id    
          AND IsActive = 1;    
    END    
    
    -- Step 2: Insert new record as active    
    INSERT INTO [Hotel].[HotelBookingModifyDetails]     
       ( book_fk_id, room_fk_id, pax_fk_id,    
        Title, FName, LName,    
        RoomType, RoomMealBasis,    
        IsActive, ModifiedBy, ModifiedByName, ModifiedOn, IsLeadPax,RoomInclusion )   
        
    VALUES (    
        @book_fk_id, @room_fk_id, @pax_fk_id,    
        @Title, @FName, @LName,    
        @RoomType, @RoomMealBasis,    
        1, @ModifiedBy, @ModifiedName, GETDATE(), @IsLeadPax ,@RoomInclusion   
    );    
END; 
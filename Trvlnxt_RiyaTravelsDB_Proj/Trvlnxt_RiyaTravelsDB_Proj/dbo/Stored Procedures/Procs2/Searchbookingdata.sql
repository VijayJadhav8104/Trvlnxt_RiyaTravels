--exec [dbo].[Searchbookingdata]   '2024-03-19','2024-03-20',0,11, ''
CREATE PROCEDURE [dbo].[Searchbookingdata]   
 -- Add the parameters for the stored procedure here    
 @FROMDate Date= null,    
 @ToDate Date= null,
 @Start int=null,  
 @Pagesize int=null, 
 @RecordCount INT OUTPUT 
 As  
 Begin  
 
  SET @FROMDate = CONVERT(DATE, @FROMDate, 105); -- 105 is the style code for 'yyyy-mm-dd'
    SET @ToDate = CONVERT(DATE, @ToDate, 105);
	print @FROMDate 

 SELECT @RecordCount = COUNT(*)
    FROM tblB2CTrackingDetails  
    WHERE (CONVERT(DATE, CreatedDate) >= @FROMDate)  
      AND (CONVERT(DATE, CreatedDate) <= @ToDate);
	  --WHERE (@FROMDate IS NULL OR CONVERT(DATE, CreatedDate) >= @FROMDate)  
	  --AND (@ToDate IS NULL OR CONVERT(DATE, CreatedDate) <= @ToDate);

 select * from tblB2CTrackingDetails  

 WHERE (CONVERT(DATE, CreatedDate) >= @FROMDate)  
      AND (CONVERT(DATE, CreatedDate) <= @ToDate)  
 ORDER BY  CreatedDate desc  
 OFFSET @Start ROWS  
 FETCH NEXT @Pagesize ROWS ONLY 
 End  
  


  
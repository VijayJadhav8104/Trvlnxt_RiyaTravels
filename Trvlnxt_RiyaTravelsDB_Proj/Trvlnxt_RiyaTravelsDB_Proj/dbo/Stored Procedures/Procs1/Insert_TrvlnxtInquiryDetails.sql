
        
 CREATE PROCEDURE [dbo].[Insert_TrvlnxtInquiryDetails]                  
  @Name varchar(50)=Null,                     
  @EmailID varchar(50)=null,                      
  @MobileNo varchar(50)=Null,                      
  @Message varchar(500)=Null   
     
  AS                       
  BEGIN                     
                
    Insert Into tblTrvlnxtInquiry (                       
      Name 
	 ,EmailID
	 ,MobileNo
	 ,Message
	 ,CreatedDate
	 )
	 Values( 
	  @Name
	 ,@EmailID
	 ,@MobileNo
	 ,@Message
	 ,GETDATE()
     )
              
  END 

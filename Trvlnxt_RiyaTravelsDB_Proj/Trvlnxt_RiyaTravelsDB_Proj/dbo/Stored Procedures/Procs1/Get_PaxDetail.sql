CREATE Procedure  [dbo].[Get_PaxDetail]  
   @fkbookmaster nvarchar(50)
As    
Begin    
 
 select pid,isreturn  from tblPassengerBookDetails where  fkBookMaster=@fkbookmaster  
 
End

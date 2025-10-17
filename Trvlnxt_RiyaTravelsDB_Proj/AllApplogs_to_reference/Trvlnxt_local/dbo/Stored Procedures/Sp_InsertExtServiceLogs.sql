--exec [dbo].[Sp_InsertExtServiceLogs] 'Test','http://test.me/','<inputString test=\"Value\" />','<outputString test="OUT">','Method','2024-08-02 12:34:40.7942','2024-08-02 12:34:40.7942'
  
create procedure [dbo].[Sp_InsertExtServiceLogs]    
    
@ReferenceKey varchar(50)= null,    
           @requestURL varchar(max)=null,    
           @inputStringNew varchar(max)=null,    
           @outputString varchar(max)=null,    
           @MethodName varchar(50)= null,    
           @startTime datetime=null,    
           @endTime datetime=null    
as     
Begin    
INSERT INTO dbo.ExtServicelogs    
           (ReferenceKey    
           ,requestURL    
           ,inputString    
           ,outputString    
           ,MethodName    
           ,startTime    
           ,endTime    
     )    
     VALUES    
           (    
     @ReferenceKey,    
           @requestURL ,    
           @inputStringNew,    
           @outputString,    
           @MethodName,    
         @startTime ,    
          @endTime    
 )    
    End    
    


    
    
    
    

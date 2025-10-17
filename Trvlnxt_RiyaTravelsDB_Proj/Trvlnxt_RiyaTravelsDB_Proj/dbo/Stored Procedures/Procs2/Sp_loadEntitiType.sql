--sp_helptext Sp_loadEntitiName

CREATE procedure Sp_loadEntitiType -- 'Intercompany'  

As     
Begin    

 select distinct upper(ltrim(rtrim( Value))) 'EntityType',ID 'Id'    
    
 from mCommon--(nolock)    
 where 
 Category='EntityType'
 order by 1 asc    
  
End


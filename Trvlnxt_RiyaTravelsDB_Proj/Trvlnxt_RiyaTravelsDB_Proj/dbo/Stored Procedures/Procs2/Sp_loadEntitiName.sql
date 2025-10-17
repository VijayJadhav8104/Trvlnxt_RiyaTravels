--select * from dbo.fn_split(   ,','  )
--exec Sp_loadEntitiName '265'
CREATE procedure [dbo].[Sp_loadEntitiName] -- ''--
@EntityType varchar(max)= null    
As     
Begin    

 select distinct ltrim(rtrim( EntityName)) 'EntityName',EntityNameID 'Id' ,EntityType   
    
 from b2bregistration(nolock)    
 where 
  isnull(ltrim(rtrim(EntityName)) ,'')!=''and 
 (
 cast(EntityTypeID as varchar)in (select [value] from dbo.fn_split( @EntityType,','  )) 
 or isnull(@EntityType,'')='')

 order by 1 asc    
   
End
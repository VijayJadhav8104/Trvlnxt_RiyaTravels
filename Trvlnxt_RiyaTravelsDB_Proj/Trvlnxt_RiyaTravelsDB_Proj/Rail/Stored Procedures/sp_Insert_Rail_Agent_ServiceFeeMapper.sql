
CREATE PROCEDURE [Rail].[sp_Insert_Rail_Agent_ServiceFeeMapper] (    
  @Id INT NULL    
 ,@FK_ServiceFeeId INT NULL    
 ,@Fk_ProductListMasterId INT NULL    
 ,@Currency VARCHAR(50) NULL    
 ,@Commission DECIMAL(8, 2)    
 ,@AdditionAmount DECIMAL(8, 2)   
 ,@GST_on_base_Commission DECIMAL(8, 2)   
 ,@TDS_on_Part_commission DECIMAL(8, 2)   
 ,@CreadtedBy VARCHAR(30) = NULL    
 )    
AS    
BEGIN    
 IF (@Id = 0)    
 BEGIN    
  INSERT INTO [Rail].[Agent_ServiceFee_Mapper] (    
   FK_ServiceFeeId    
   ,Fk_ProductListMasterId    
   ,Currency    
   ,Commission    
   ,AdditionAmount  
   ,GST_on_base_Commission  
   ,TDS_on_Part_commission  
   ,CreatedDate    
   ,CreatedBy    
   )    
  VALUES (    
   @FK_ServiceFeeId    
   ,@Fk_ProductListMasterId    
   ,@Currency    
   ,@Commission    
   ,@AdditionAmount   
   ,@GST_on_base_Commission  
   ,@TDS_on_Part_commission  
   ,getDate()    
   ,@CreadtedBy    
   )    
 END    
END

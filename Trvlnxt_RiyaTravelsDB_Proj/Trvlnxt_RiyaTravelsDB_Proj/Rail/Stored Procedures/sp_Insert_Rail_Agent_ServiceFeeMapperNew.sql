          
CREATE PROCEDURE [Rail].[sp_Insert_Rail_Agent_ServiceFeeMapperNew] (          
  @Id INT NULL          
 ,@FK_ServiceFeeId INT NULL          
 ,@Fk_ProductListMasterId INT NULL            
 ,@ServiceFees DECIMAL(8, 2)         
 ,@ServiceFeesParcent DECIMAL(8, 2)    
 ,@Gst_on_Service_Fees DECIMAL(8, 2)    
 ,@CreadtedBy VARCHAR(30) = NULL          
 )          
AS          
BEGIN          
 IF (@Id = 0)          
 BEGIN          
  INSERT INTO [Rail].[Agent_ServiceFee_MapperNew] (          
   FK_ServiceFeeId          
   ,Fk_ProductListMasterId          
   ,ServiceFees  
   ,ServiceFeesParcent  
   ,Gst_on_Service_Fees  
   ,CreatedDate          
   ,CreatedBy          
   )          
  VALUES (          
   @FK_ServiceFeeId          
   ,@Fk_ProductListMasterId          
   ,@ServiceFees  
   ,@ServiceFeesParcent  
  , @Gst_on_Service_Fees  
   ,getDate()          
   ,@CreadtedBy          
   )          
 END          
END
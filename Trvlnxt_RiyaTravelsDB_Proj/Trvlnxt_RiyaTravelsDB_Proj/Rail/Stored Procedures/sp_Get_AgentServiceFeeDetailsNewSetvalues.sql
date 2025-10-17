-- =============================================      
-- Author:  <Author,,Name>      
-- Create date: <Create Date,,>      
-- Description: <Description,,>      
-- =============================================      
create PROCEDURE [Rail].[sp_Get_AgentServiceFeeDetailsNewSetvalues]      
@Id varchar(20)=Null, 
@Bookingtype varchar(20)=Null
AS          
BEGIN          
        
         
select * from rail.tbl_ServiceFeeNew sf       
inner join rail.Agent_ServiceFee_MapperNew ASF      
ON sf.Id = ASF.FK_ServiceFeeId      
where sf.Id = @Id  and sf.ServiceFeesType=@Bookingtype     
      
      
select * from  rail.ProductListMaster where Fk_SupplierMasterId = 1       
--and ProductType in      
--(select sf.ProductType from rail.tbl_ServiceFee sf where sf.Id = 54 )      
      
END 
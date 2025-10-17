-- ================================================    
-- Template generated from Template Explorer using:    
-- Create Procedure (New Menu).SQL    
-- =============================================    
-- Author:  Javed Bloch    
-- Description: to get api indicator list
-- =============================================    
Create PROCEDURE [dbo].[spGetIsNDC]   ---exec  spGetIsNDC "aegeanairlines",0

  
@supplierName varchar(100),
@IsNDC int OUTPUT

AS
 
begin
     select @IsNDC=IsNDC from TravelFusionSupplierList where SupplierName=@supplierName
  

 end
 
 
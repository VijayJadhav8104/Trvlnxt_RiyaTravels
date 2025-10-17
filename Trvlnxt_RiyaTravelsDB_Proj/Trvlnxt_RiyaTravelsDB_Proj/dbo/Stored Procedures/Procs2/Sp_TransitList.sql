-- ================================================    
-- Template generated from Template Explorer using:    
-- Create Procedure (New Menu).SQL    
-- =============================================    
-- Author:  Javed Bloch    
-- Description: to get api indicator list
-- =============================================    
CREATE PROCEDURE [dbo].[Sp_TransitList]  
AS    
 

 select * from tblTransitPoints order by TransitPoint asc

 
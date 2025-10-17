
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[ServiceFeeMapping_Insert]
	@AgentID int,
	@AirportType varchar(10),
	@AirlineCategory varchar(50),
	@AirlineName varchar(100),
	@AirlineCode varchar(10),
	@AdultServiceFee decimal(10,2),
	@ChildServiceFee decimal(10,2),
	@InfantServiceFee decimal(10,2)
AS
BEGIN

INSERT INTO tblAgentServiceFeeMapping
(AgentID 
,AirportType
,AirlineCategory
,AirlineName
,AirlineCode
,AdultServiceFee
,ChildServiceFee
,InfantServiceFee
,InsertedDate)
VALUES(@AgentID
,@AirportType 
,@AirlineCategory
,@AirlineName
,@AirlineCode
,@AdultServiceFee
,@ChildServiceFee
,@InfantServiceFee
,getdate())

END








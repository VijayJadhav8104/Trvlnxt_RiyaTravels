-- [SS].[SP_Insert_QuestionAnswer] 21,16,0,'Special requirements','SPECIAL_REQUIREMENTS','carrybag',null
CREATE PROCEDURE [SS].[SP_Insert_QuestionAnswer]
		@ActivityId int= null, 
		@BookingId int= null, 
		@PaxID int= null, 
		@label varchar(50)= null, 
		@questionCode varchar(50)= null, 
		@answer varchar(50)=null, 
		@unit varchar(50)=null
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @QuestionAnswerId INT 

	INSERT INTO [SS].[SS_QuestionAnswer]
           (ActivityId, BookingId, PaxID, label, questionCode, answer, unit)
     VALUES
           (@ActivityId, @BookingId, @PaxID, @label, @questionCode, @answer, @unit)

	SET @QuestionAnswerId  =(select  SCOPE_IDENTITY())  

	SELECT @QuestionAnswerId
END

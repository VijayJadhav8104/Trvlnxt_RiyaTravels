




CREATE PROCEDURE [dbo].[InsertFeedback] 
@Name			varchar(50),
@Email			varchar(100),
@Feedback		varchar(1000),
@IP				varchar(50),
@Browser	    varchar(50),
@TravelDate		datetime = null,
@IntrestIn	    varchar(50) = null

AS BEGIN
	INSERT INTO Feedback(Name,Email,Feedback,IP,Browser,IntrestIn) VALUES(@Name,@Email,@Feedback,@IP,@Browser,@IntrestIn)
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertFeedback] TO [rt_read]
    AS [dbo];


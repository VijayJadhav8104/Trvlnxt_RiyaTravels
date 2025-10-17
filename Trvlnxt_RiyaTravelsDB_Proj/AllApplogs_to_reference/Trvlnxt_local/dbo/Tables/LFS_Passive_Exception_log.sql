CREATE TABLE [dbo].[LFS_Passive_Exception_log] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [Product_Type]   VARCHAR (MAX) NULL,
    [ExceptionType]  VARCHAR (MAX) NULL,
    [Message]        VARCHAR (MAX) NULL,
    [StackTrace]     VARCHAR (MAX) NULL,
    [ExceptionDate]  DATETIME      NULL,
    [InnerException] VARCHAR (MAX) NULL,
    CONSTRAINT [PK__LFS_Pass__3214EC2733048414] PRIMARY KEY CLUSTERED ([ID] ASC)
);


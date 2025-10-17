CREATE TABLE [dbo].[mUserOfficeIdMapping] (
    [ID]        INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserId]    INT           NULL,
    [OfficeId]  VARCHAR (MAX) NULL,
    [FKmVendor] INT           NULL,
    [CreatedOn] DATETIME      NULL,
    [IsActive]  BIT           NULL,
    CONSTRAINT [PK_mUserOfficeIdMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);


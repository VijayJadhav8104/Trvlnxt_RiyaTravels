CREATE TABLE [dbo].[mAgentGroup] (
    [ID]        INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [GroupName] VARCHAR (MAX) NULL,
    [CreatedOn] DATETIME2 (7) CONSTRAINT [DF_mAgentGroup_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy] INT           NULL,
    [IsActive]  BIT           NULL,
    [ToEmail]   VARCHAR (MAX) NULL,
    [UserType]  VARCHAR (50)  NULL,
    [CcEmail]   VARCHAR (MAX) NULL,
    CONSTRAINT [PK_mAgentGroup] PRIMARY KEY CLUSTERED ([ID] ASC)
);


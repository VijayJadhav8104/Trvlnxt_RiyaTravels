CREATE TABLE [dbo].[CMS_JobListing] (
    [Id]             INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Location]       VARCHAR (MAX)  NULL,
    [JobDescription] NVARCHAR (MAX) NULL,
    [CreatedBy]      VARCHAR (800)  NULL,
    [CreatedDate]    DATETIME       NULL,
    [UpdatedDate]    DATETIME       NULL,
    [UpdatedBy]      VARCHAR (800)  NULL,
    [IsActive]       BIT            NULL,
    [JobTitle]       NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


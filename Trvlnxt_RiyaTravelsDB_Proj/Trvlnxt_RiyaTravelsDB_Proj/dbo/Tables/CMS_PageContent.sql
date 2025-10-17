CREATE TABLE [dbo].[CMS_PageContent] (
    [Id]          INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PageName]    VARCHAR (500)  NULL,
    [Content]     NVARCHAR (MAX) NULL,
    [Country]     VARCHAR (200)  NULL,
    [CreatedDate] DATETIME       NULL,
    [IsActive]    BIT            NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


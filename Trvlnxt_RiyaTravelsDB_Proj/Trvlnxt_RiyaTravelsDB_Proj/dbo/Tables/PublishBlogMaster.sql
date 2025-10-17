CREATE TABLE [dbo].[PublishBlogMaster] (
    [PId]            INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Country]        NVARCHAR (MAX) NULL,
    [BlogOrder]      NVARCHAR (MAX) NULL,
    [BlogTDImage]    NVARCHAR (MAX) NULL,
    [BlogTDImageUrl] NVARCHAR (MAX) NULL,
    [Tags]           NVARCHAR (MAX) NULL,
    [CreateDate]     DATETIME       NULL,
    [ActiveFlag]     NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_PublishBlogMaster] PRIMARY KEY CLUSTERED ([PId] ASC)
);


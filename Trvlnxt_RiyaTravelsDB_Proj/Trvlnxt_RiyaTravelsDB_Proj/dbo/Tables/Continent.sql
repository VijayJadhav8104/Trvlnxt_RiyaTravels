CREATE TABLE [dbo].[Continent] (
    [Id]               INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ContinentName]    VARCHAR (50)   NULL,
    [Adjective]        NVARCHAR (MAX) NULL,
    [Description]      NVARCHAR (MAX) NULL,
    [Url]              NVARCHAR (MAX) NULL,
    [MetaTitle]        NVARCHAR (MAX) NULL,
    [MetaDescription]  NVARCHAR (MAX) NULL,
    [Keywords]         NVARCHAR (MAX) NULL,
    [CoverImage]       NVARCHAR (MAX) NULL,
    [Date]             DATETIME       NULL,
    [IsActive]         BIT            NULL,
    [GoogleAnalytics]  NVARCHAR (MAX) NULL,
    [UserId]           NVARCHAR (MAX) NULL,
    [U_id]             INT            NULL,
    [CurrentTimeStamp] DATETIME       NULL,
    [LastModifiedDate] DATETIME       NULL,
    [ModifiedBy]       INT            NULL,
    [AltTag]           NVARCHAR (MAX) NULL,
    [BannerImage]      NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Continent] PRIMARY KEY CLUSTERED ([Id] ASC)
);


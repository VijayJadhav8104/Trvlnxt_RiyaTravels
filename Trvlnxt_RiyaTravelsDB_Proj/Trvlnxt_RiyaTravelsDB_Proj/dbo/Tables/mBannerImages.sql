CREATE TABLE [dbo].[mBannerImages] (
    [ID]         INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CotentType] VARCHAR (10)    NULL,
    [ImageByte]  VARBINARY (MAX) NULL,
    [BannerId]   INT             NULL,
    [ImageOrder] INT             NULL,
    [URL]        VARCHAR (MAX)   NULL,
    [IsActive]   BIT             CONSTRAINT [DF_mBannerImages_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifiedOn] DATETIME2 (7)   NULL,
    [ModifiedBy] INT             NULL,
    [CreatedBy]  INT             NULL,
    [CreatedOn]  DATETIME2 (7)   CONSTRAINT [DF_mBannerImages_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [ImageName]  VARCHAR (500)   NULL,
    CONSTRAINT [PK_mBannerImages] PRIMARY KEY CLUSTERED ([ID] ASC)
);


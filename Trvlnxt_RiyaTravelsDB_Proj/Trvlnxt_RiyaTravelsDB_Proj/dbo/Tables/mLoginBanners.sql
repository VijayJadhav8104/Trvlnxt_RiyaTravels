CREATE TABLE [dbo].[mLoginBanners] (
    [ID]             INT             IDENTITY (1, 1) NOT NULL,
    [ImageName]      VARCHAR (500)   NULL,
    [ImageByte]      VARBINARY (MAX) NULL,
    [BannerLink]     VARCHAR (MAX)   NULL,
    [BannerPosition] INT             NULL,
    [IsActive]       BIT             CONSTRAINT [DF_mLoginBanners_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifiedOn]     DATETIME2 (7)   NULL,
    [ModifiedBy]     INT             NULL,
    [CreatedBy]      INT             NULL,
    [CreatedOn]      DATETIME2 (7)   CONSTRAINT [DF_mLoginBanners_CreatedOn] DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


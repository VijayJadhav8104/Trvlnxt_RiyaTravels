CREATE TABLE [dbo].[CMS_BackgroundBanner] (
    [PKID]        INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BannerName]  VARCHAR (MAX)  NULL,
    [BannerURL]   NVARCHAR (200) NULL,
    [FromDate]    DATETIME       NULL,
    [ExpiryDate]  DATETIME       NULL,
    [CreatedDate] DATETIME       NULL,
    [BannerOrder] INT            NULL,
    [Country]     VARCHAR (500)  NULL,
    [IsActive]    BIT            NULL,
    [Flag]        VARCHAR (50)   NULL,
    PRIMARY KEY CLUSTERED ([PKID] ASC)
);


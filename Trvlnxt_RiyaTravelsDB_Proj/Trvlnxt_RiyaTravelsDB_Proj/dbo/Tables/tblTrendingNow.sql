CREATE TABLE [dbo].[tblTrendingNow] (
    [PKID]              BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BannerType]        SMALLINT       NULL,
    [ImagePath]         NVARCHAR (500) NULL,
    [Heading]           NVARCHAR (100) NULL,
    [Description]       NVARCHAR (MAX) NULL,
    [ImageButtonText]   NVARCHAR (100) NULL,
    [ImageButtonURL]    NVARCHAR (100) NULL,
    [SpecialBannerDesc] NVARCHAR (MAX) NULL,
    [CreatedDate]       DATETIME       CONSTRAINT [DF_tblTrendingNow_CreatedDate] DEFAULT (getdate()) NULL,
    [IsActive]          BIT            CONSTRAINT [DF_tblTrendingNow_IsActive] DEFAULT ((1)) NULL,
    [StartDate]         DATETIME       NULL,
    [EndDate]           DATETIME       NULL,
    [Country]           VARCHAR (2)    NULL,
    [BannerOrder]       INT            NULL,
    CONSTRAINT [PK_tblTrendingNow] PRIMARY KEY CLUSTERED ([PKID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0-Normal Banner 1-Special Banner', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblTrendingNow', @level2type = N'COLUMN', @level2name = N'BannerType';


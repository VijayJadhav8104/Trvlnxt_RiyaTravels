CREATE TABLE [dbo].[CMS_DealsBanner] (
    [PKID]         INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BannerName]   VARCHAR (100) NULL,
    [BannerURL]    VARCHAR (100) NULL,
    [FromDate]     DATETIME      NULL,
    [ExpiryDate]   DATETIME      NULL,
    [InsertedDate] DATETIME      CONSTRAINT [DF_DealsBanner_InsertedDate] DEFAULT (getdate()) NULL,
    [BannerOrder]  INT           NULL,
    [Country]      VARCHAR (50)  NULL,
    [IsActive]     BIT           CONSTRAINT [DF_CMS_DealsBanner_IsActive] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_DealsBanner] PRIMARY KEY CLUSTERED ([PKID] ASC)
);


CREATE TABLE [dbo].[CMS_SocialRelease] (
    [PKID_in]       BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [title_vc]      VARCHAR (100) NOT NULL,
    [img_vc]        VARCHAR (MAX) NOT NULL,
    [thumbimg_vc]   VARCHAR (MAX) NULL,
    [date_dt]       VARCHAR (50)  NULL,
    [order_in]      INT           NOT NULL,
    [des_vc]        VARCHAR (500) NULL,
    [briefdes_vc]   TEXT          NULL,
    [type_ch]       CHAR (1)      NOT NULL,
    [status_ch]     CHAR (1)      CONSTRAINT [DF_SocialRelease_status_ch] DEFAULT ('A') NOT NULL,
    [inserteddt_dt] DATE          CONSTRAINT [DF_SocialRelease_inserteddt_dt] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_SocialRelease] PRIMARY KEY CLUSTERED ([PKID_in] ASC)
);


CREATE TABLE [dbo].[CMS_CardRates] (
    [PKID_int]       BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [occupytype_ch]  VARCHAR (100) NOT NULL,
    [aircost_vc]     VARCHAR (100) NULL,
    [landcost_vc]    VARCHAR (100) NULL,
    [basicprice_int] VARCHAR (100) NOT NULL,
    [inserteddt_dt]  DATE          CONSTRAINT [DF_CMS_CardRates_inserteddt_dt] DEFAULT (getdate()) NOT NULL,
    [lastupdated_dt] DATE          CONSTRAINT [DF_CMS_CardRates_lastupdated_dt] DEFAULT (getdate()) NOT NULL,
    [status_ch]      CHAR (2)      CONSTRAINT [DF_CMS_CardRates_status_ch] DEFAULT ('ac') NOT NULL,
    CONSTRAINT [PK_CMS_CardRates] PRIMARY KEY CLUSTERED ([PKID_int] ASC)
);


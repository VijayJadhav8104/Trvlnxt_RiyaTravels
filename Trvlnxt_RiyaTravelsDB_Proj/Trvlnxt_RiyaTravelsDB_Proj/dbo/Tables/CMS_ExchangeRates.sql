CREATE TABLE [dbo].[CMS_ExchangeRates] (
    [PKID_int]        BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [currencyname_vc] VARCHAR (50) NULL,
    [currencycode_vc] VARCHAR (30) NULL,
    [salerate_ft]     FLOAT (53)   NULL,
    [buyrate_ft]      FLOAT (53)   NULL,
    [inserteddt_dt]   DATE         CONSTRAINT [DF_ExchangeRates_inserteddt_dt] DEFAULT (getdate()) NULL,
    [updateddt_dt]    DATETIME     NULL,
    [status]          BIT          CONSTRAINT [DF_ExchangeRates_status_ch] DEFAULT ((1)) NULL,
    [createdOn]       DATETIME     CONSTRAINT [DF_CMS_ExchangeRates_createdOn] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_ExchangeRates] PRIMARY KEY CLUSTERED ([PKID_int] ASC)
);


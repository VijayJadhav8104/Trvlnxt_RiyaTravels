CREATE TABLE [dbo].[ExchangeRates] (
    [PKID_int]        BIGINT       NOT NULL,
    [currencyname_vc] VARCHAR (50) NOT NULL,
    [currencycode_vc] VARCHAR (30) NOT NULL,
    [salerate_ft]     FLOAT (53)   NOT NULL,
    [buyrate_ft]      FLOAT (53)   NOT NULL,
    [inserteddt_dt]   DATE         CONSTRAINT [DF_ExchangeRates_inserteddt_dt_1] DEFAULT (getdate()) NOT NULL,
    [updateddt_dt]    DATE         CONSTRAINT [DF_ExchangeRates_updateddt_dt] DEFAULT (getdate()) NOT NULL,
    [status_ch]       CHAR (2)     CONSTRAINT [DF_ExchangeRates_status_ch_1] DEFAULT ('ac') NOT NULL,
    CONSTRAINT [PK_ExchangeRates_1] PRIMARY KEY CLUSTERED ([PKID_int] ASC)
);


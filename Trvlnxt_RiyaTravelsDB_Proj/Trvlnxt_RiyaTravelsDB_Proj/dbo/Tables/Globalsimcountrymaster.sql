CREATE TABLE [dbo].[Globalsimcountrymaster] (
    [PKID_int]       BIGINT        NOT NULL,
    [countryname_vc] VARCHAR (100) NOT NULL,
    [status_ch]      CHAR (1)      CONSTRAINT [DF_Globalsimcountrymaster_status_ch] DEFAULT ('A') NOT NULL,
    [inserteddt_dt]  DATE          CONSTRAINT [DF_Globalsimcountrymaster_inserteddt_dt] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Globalsimcountrymaster] PRIMARY KEY CLUSTERED ([PKID_int] ASC)
);


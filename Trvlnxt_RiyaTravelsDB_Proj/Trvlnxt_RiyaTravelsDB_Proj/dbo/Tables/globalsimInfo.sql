CREATE TABLE [dbo].[globalsimInfo] (
    [PKID_int]        BIGINT        NOT NULL,
    [Fkcountry_int]   BIGINT        NOT NULL,
    [providername_vc] VARCHAR (200) NOT NULL,
    [incomingcall_ft] FLOAT (53)    NULL,
    [localcall_ft]    FLOAT (53)    NULL,
    [indiacall_ft]    FLOAT (53)    NULL,
    [wordcall_ft]     FLOAT (53)    NULL,
    [currency_ch]     CHAR (3)      NULL,
    [smscharge_ft]    FLOAT (53)    NULL,
    [datacharge_ft]   FLOAT (53)    NULL,
    [inserteddt_dt]   DATE          NULL,
    [status_ch]       CHAR (1)      NULL,
    [updateddt_dt]    DATE          CONSTRAINT [DF_globalsimInfo_updateddt_dt] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_globalsimInfo] PRIMARY KEY CLUSTERED ([PKID_int] ASC)
);


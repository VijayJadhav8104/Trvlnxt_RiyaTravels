CREATE TABLE [dbo].[BlockAirlinelist] (
    [intID]          INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [vcrAirline]     VARCHAR (50) NULL,
    [btStatus]       BIT          NULL,
    [dtInsertedDate] DATETIME     CONSTRAINT [DF_BlockAirlinelist_dtInsertedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_BlockAirlinelist] PRIMARY KEY CLUSTERED ([intID] ASC)
);


CREATE TABLE [dbo].[BlockedAirlinelistB2B] (
    [intID]          INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [vcrAirline]     VARCHAR (50) NULL,
    [btStatus]       BIT          NULL,
    [dtInsertedDate] DATETIME     CONSTRAINT [DF_BlockedAirlinelistB2B_dtInsertedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_BlockedAirlinelistB2B] PRIMARY KEY CLUSTERED ([intID] ASC)
);


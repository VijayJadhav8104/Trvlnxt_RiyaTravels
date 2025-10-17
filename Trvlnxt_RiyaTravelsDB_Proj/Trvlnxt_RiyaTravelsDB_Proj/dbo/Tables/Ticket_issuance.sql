CREATE TABLE [dbo].[Ticket_issuance] (
    [Ticket_id]         BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PNR]               VARCHAR (20) NOT NULL,
    [order_id]          VARCHAR (30) NULL,
    [ValidatingCarrier] VARCHAR (10) NULL,
    [issuedate]         DATETIME     NULL,
    [inserteddate]      DATETIME     CONSTRAINT [DF_Ticket_issuance_inserteddate] DEFAULT (getdate()) NOT NULL,
    [status]            CHAR (1)     CONSTRAINT [DF_Ticket_issuance_status] DEFAULT ('F') NOT NULL,
    CONSTRAINT [PK_Ticket_issuance] PRIMARY KEY CLUSTERED ([Ticket_id] ASC)
);


CREATE TABLE [dbo].[tbl_AmendmentRequest] (
    [ID]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [AmendmentRef]   VARCHAR (50)   NULL,
    [Type]           VARCHAR (50)   NULL,
    [RequestBy]      VARCHAR (50)   NULL,
    [RiyaPNR]        VARCHAR (50)   NULL,
    [Inserteddate]   DATETIME       NULL,
    [BookMasterId]   VARCHAR (50)   NULL,
    [ItenaryId]      VARCHAR (50)   NULL,
    [PassengerId]    VARCHAR (50)   NULL,
    [Status]         INT            NULL,
    [AbortedBy]      INT            NULL,
    [AbortedDate]    DATETIME       NULL,
    [Remarks]        VARCHAR (1000) NULL,
    [RescheduleDate] DATETIME       NULL,
    [IsBooked]       INT            NULL,
    [Cabin]          VARCHAR (50)   NULL,
    [IsReSchedule]   BIT            NULL,
    CONSTRAINT [PK_tbl_AmendmentRequest] PRIMARY KEY CLUSTERED ([ID] ASC)
);


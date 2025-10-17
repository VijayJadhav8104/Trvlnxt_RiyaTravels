CREATE TABLE [dbo].[APIAuthenticationMaster_Internal] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [APIKey]       VARCHAR (255) NULL,
    [IPAddress]    VARCHAR (255) NULL,
    [AgentID]      VARCHAR (50)  NULL,
    [InsertedDate] VARCHAR (50)  NULL,
    [Status]       BIT           NULL,
    [CreatedBy]    INT           NULL,
    [UpdatedBy]    INT           NULL,
    [UpdatedOn]    DATETIME      NULL,
    [Availability] BIT           NULL,
    [Sell]         BIT           NULL,
    [Booking]      BIT           NULL,
    [AllBlock]     BIT           NULL
);


CREATE TABLE [dbo].[APIAuthenticationMasterHistory] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [pkid]         INT           NULL,
    [APIKey]       VARCHAR (255) NULL,
    [IPAddress]    VARCHAR (255) NULL,
    [AgentID]      VARCHAR (50)  NULL,
    [InsertedDate] DATETIME      NULL,
    [Status]       BIT           NULL,
    [CreatedBy]    INT           NULL,
    [UpdatedBy]    INT           NULL,
    [UpdatedOn]    DATETIME      NULL,
    [IsInternal]   INT           NULL,
    [Availability] BIT           NULL,
    [Sell]         BIT           NULL,
    [Booking]      BIT           NULL,
    [AllBlock]     BIT           NULL,
    CONSTRAINT [PK_APIAuthenticationMasterHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);


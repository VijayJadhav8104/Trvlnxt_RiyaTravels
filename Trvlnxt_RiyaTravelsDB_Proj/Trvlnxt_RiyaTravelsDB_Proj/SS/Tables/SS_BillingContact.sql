CREATE TABLE [SS].[SS_BillingContact] (
    [PKid]       INT           NOT NULL,
    [BookingId]  INT           NOT NULL,
    [Type]       VARCHAR (50)  NULL,
    [Title]      VARCHAR (50)  NULL,
    [FirstName]  VARCHAR (50)  NULL,
    [LastName]   VARCHAR (50)  NULL,
    [MiddleName] VARCHAR (50)  NULL,
    [Age]        VARCHAR (50)  NULL,
    [Suffix]     NVARCHAR (50) NULL,
    CONSTRAINT [PK_SS_BillingContact] PRIMARY KEY CLUSTERED ([PKid] ASC)
);


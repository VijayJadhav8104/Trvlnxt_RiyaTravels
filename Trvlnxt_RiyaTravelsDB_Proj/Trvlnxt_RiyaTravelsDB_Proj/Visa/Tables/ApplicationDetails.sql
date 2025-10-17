CREATE TABLE [Visa].[ApplicationDetails] (
    [Id]                     BIGINT         IDENTITY (1, 1) NOT NULL,
    [fk_AppId]               BIGINT         NULL,
    [CreatedBy]              BIGINT         NULL,
    [CreatedDate]            DATETIME       NULL,
    [PaymentBy]              BIGINT         NULL,
    [PaymentDate]            DATETIME       NULL,
    [AgentID]                INT            NULL,
    [AgentICust]             NVARCHAR (50)  NULL,
    [FK_VisaCountryMasterId] INT            NULL,
    [RiyaVisaPNR]            NVARCHAR (20)  NULL,
    [PassengerName]          NVARCHAR (150) NULL,
    [PassportNo]             NVARCHAR (20)  NULL,
    [AgencyName]             NVARCHAR (200) NULL,
    [TravelDate]             DATETIME       NULL,
    CONSTRAINT [Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


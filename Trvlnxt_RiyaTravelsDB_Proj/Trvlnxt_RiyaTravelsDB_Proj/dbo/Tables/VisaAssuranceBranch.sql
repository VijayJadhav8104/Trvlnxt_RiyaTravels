CREATE TABLE [dbo].[VisaAssuranceBranch] (
    [id]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Branch]       VARCHAR (50)  NULL,
    [State]        VARCHAR (50)  NULL,
    [IsActive]     BIT           NULL,
    [Address]      VARCHAR (300) NULL,
    [LocationLink] VARCHAR (300) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


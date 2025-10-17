CREATE TABLE [SS].[SS_PaxDetails] (
    [PKId]                   INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ActivityId]             INT          NULL,
    [BookingId]              INT          NULL,
    [Titel]                  VARCHAR (10) NULL,
    [Name]                   VARCHAR (50) NULL,
    [Surname]                VARCHAR (50) NULL,
    [Age]                    VARCHAR (50) NULL,
    [Type]                   VARCHAR (50) NULL,
    [PancardNo]              VARCHAR (50) NULL,
    [PassportNumber]         VARCHAR (50) NULL,
    [PassportExpirationDate] DATETIME     NULL,
    [DateOfBirth]            DATETIME     NULL,
    [PassportIssueDate]      DATETIME     NULL,
    [Nationality]            INT          NULL,
    [IssuingCountry]         INT          NULL,
    [LeadPax]                INT          NULL,
    [totalPax]               INT          DEFAULT ((0)) NULL,
    [PanCardName]            VARCHAR (50) NULL,
    CONSTRAINT [PK_SS_PaxDetails] PRIMARY KEY CLUSTERED ([PKId] ASC)
);


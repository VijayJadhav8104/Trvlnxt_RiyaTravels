CREATE TABLE [dbo].[bkp_mPassengerProfile_05052022beforedelete] (
    [PkID]                     INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PaxType]                  NVARCHAR (50) NULL,
    [PaxFname]                 NVARCHAR (50) NULL,
    [PaxLname]                 NVARCHAR (50) NULL,
    [PassportNum]              NVARCHAR (50) NULL,
    [PassportIssueCountry]     NVARCHAR (50) NULL,
    [PassExp]                  NVARCHAR (50) NULL,
    [Title]                    NVARCHAR (50) NULL,
    [DateOfBirth]              NVARCHAR (50) NULL,
    [Nationality]              NVARCHAR (50) NULL,
    [Gender]                   NVARCHAR (50) NULL,
    [ContactNo]                NVARCHAR (50) NULL,
    [Email]                    NVARCHAR (50) NULL,
    [InsertedDate]             DATETIME      NULL,
    [PassportIssueCountryCode] VARCHAR (20)  NULL,
    [NationaltyCode]           VARCHAR (20)  NULL
);


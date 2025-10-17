CREATE TABLE [dbo].[AirlineConfiguration] (
    [AirlineIDP]           INT          IDENTITY (1, 1) NOT NULL,
    [AirlineName]          VARCHAR (50) NULL,
    [AirlineCode]          VARCHAR (50) NULL,
    [AirlineFilterName]    VARCHAR (50) NULL,
    [AirlineAPITimeoutSec] INT          NULL,
    [IsActive]             BIT          NULL,
    CONSTRAINT [PK_AirlineConfiguration] PRIMARY KEY CLUSTERED ([AirlineIDP] ASC)
);


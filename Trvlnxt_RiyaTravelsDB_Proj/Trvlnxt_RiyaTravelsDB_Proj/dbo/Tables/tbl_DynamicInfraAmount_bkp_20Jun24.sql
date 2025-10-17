CREATE TABLE [dbo].[tbl_DynamicInfraAmount_bkp_20Jun24] (
    [ID]              BIGINT          NOT NULL,
    [UserType]        VARCHAR (20)    NOT NULL,
    [Country]         VARCHAR (20)    NOT NULL,
    [AirportType]     VARCHAR (10)    NOT NULL,
    [Amount]          DECIMAL (18, 2) NULL,
    [Airline]         VARCHAR (10)    NOT NULL,
    [CheckFormSector] VARCHAR (20)    NULL,
    [isActive]        BIT             NULL
);


CREATE TABLE [Hotel].[tblAmedeousPnr] (
    [Id]                             INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PnrNo]                          NVARCHAR (50)   NULL,
    [BookingDate]                    DATETIME        NULL,
    [TASNumber]                      VARCHAR (100)   NULL,
    [EntityCode]                     VARCHAR (100)   NULL,
    [EmployeeID]                     VARCHAR (100)   NULL,
    [EmployeeFirstName]              VARCHAR (100)   NULL,
    [EmployeeSurname]                VARCHAR (100)   NULL,
    [EmployeeName]                   VARCHAR (100)   NULL,
    [TravelPlan]                     VARCHAR (100)   NULL,
    [EmployeeBand]                   VARCHAR (100)   NULL,
    [CityName]                       VARCHAR (100)   NULL,
    [HotelBookedCountry]             VARCHAR (100)   NULL,
    [HotelBookedCity]                VARCHAR (80)    NULL,
    [CheckIndate]                    DATETIME        NULL,
    [CheckOutdate]                   DATETIME        NULL,
    [RoomNight]                      NVARCHAR (50)   NULL,
    [HotelName]                      VARCHAR (200)   NULL,
    [HotelAddress]                   VARCHAR (MAX)   NULL,
    [HotelConfirmationNumber]        VARCHAR (100)   NULL,
    [BookedCurrency]                 NCHAR (10)      NULL,
    [BookedRatePerNightIncTax]       DECIMAL (18, 3) NULL,
    [BookedRatePerNightExTax]        DECIMAL (18, 3) NULL,
    [FullTrnAmountIncTax]            DECIMAL (18, 3) NULL,
    [AgentSignature]                 VARCHAR (50)    NULL,
    [Internet]                       VARCHAR (50)    NULL,
    [Breakfast]                      VARCHAR (50)    NULL,
    [Deviation]                      BIT             NULL,
    [ErrorMessage]                   VARCHAR (300)   NULL,
    [InsertedDate]                   DATETIME        NULL,
    [RoomType]                       VARCHAR (150)   NULL,
    [RateType]                       VARCHAR (150)   NULL,
    [RoeRateBookingDate]             FLOAT (53)      NULL,
    [AmadeusConfId]                  INT             NULL,
    [DeviationApprover]              VARCHAR (200)   NULL,
    [ConcurId]                       VARCHAR (100)   NULL,
    [EmployeesBilliableToClient]     VARCHAR (50)    NULL,
    [TravelCostReimbursableByClient] VARCHAR (50)    NULL,
    [PartialInfo]                    BIT             DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblAmedeousPnr] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ__tblAmede__0FA22DC466142981] UNIQUE NONCLUSTERED ([PnrNo] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20230905-213816]
    ON [Hotel].[tblAmedeousPnr]([BookingDate] ASC);


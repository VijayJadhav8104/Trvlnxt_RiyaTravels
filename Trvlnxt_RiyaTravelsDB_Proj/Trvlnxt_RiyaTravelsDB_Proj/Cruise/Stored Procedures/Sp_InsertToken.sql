create Procedure Cruise.Sp_InsertToken
@Token varchar(1000)
As
begin
INSERT INTO cruise.CordilaCruiseToken
              (CruiseToken)
       VALUES
              (@Token)
end
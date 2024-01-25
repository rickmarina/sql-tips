

CREATE FUNCTION [dbo].[minDecimal]
(
	@num1 decimal(18,2),
	@num2 decimal(18,2)
)
RETURNS DECIMAL(18,2)
WITH SCHEMABINDING, RETURNS NULL ON NULL INPUT -- perfomance tip when is a scalar function
AS
BEGIN
	RETURN CASE WHEN @num1< @num2 THEN @num1 ELSE @num2 END
END
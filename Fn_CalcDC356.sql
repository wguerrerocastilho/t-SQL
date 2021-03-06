USE [FnDB]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_CalcDC356]    Script Date: 18/02/2020 17:57:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[Fn_CalcDC356](@tCode VARCHAR(20) )
/* ==========================================================================================
   Author      : Waldemar Guerrero
   Create date : 
   Description : Calculo do digito de controle para agencia e contas corrente 
                 do banco 356 Banco Real

   Formato
	             AAAACCCCCCC

				 AAAA     - Quatro digitos para numero da agência
				 CCCCCCC  - Numero da conta corrente em 6 posições
                 D        - Dígito de controle;
			 
			 PRINT dbo.Fn_CalcDC356('18355711460') + ' = ' + '9'

			 PRINT dbo.Fn_CalcDC356('12340123456') + ' = ' + '1'
			 PRINT dbo.Fn_CalcDC356('43210654321') + ' = ' + '0'
			 PRINT dbo.Fn_CalcDC356('43210172839') + ' = ' + '8'
			 PRINT dbo.Fn_CalcDC356('43210938274') + ' = ' + '9'

   ========================================================================================== */

RETURNS CHAR(01)

AS
BEGIN
	-- Declare the return variable here
	DECLARE @tDC CHAR(01);
    
    DECLARE @tMlt VARCHAR(20) = '81472259395';
    DECLARE @nSoma SMALLINT   = 0;
    DECLARE @nLen SMALLINT    = 0;
    DECLARE @nI SMALLINT      = 0;
    DECLARE @nDCalc SMALLINT  = 0;

	-- Adiciona zeros a esquerda, para sincronizar com a string do multiplicador
	SET @tCode = REPLICATE('0', 11 - LEN(@tCode)) + @tCode;

    SET @nLen = LEN(@tCode);
	WHILE @nI <= @nLen
	BEGIN
        SET @nSoma += CAST(SUBSTRING(@tCode, @nI, 1) AS SMALLINT) * CAST(SUBSTRING(@tMlt, @nI,1) AS SMALLINT);
	    SET @nI += 1;
	END

    -- Cálculo do DC
	-- Se o Resto for maior que 1 então DV = 11 - Resto
    -- Se o Resto for igual a 1 então DIGITO = 0
    -- Se o Resto for igual a 0 então DIGITO = 1

	SET @nDCalc = 11 - (@nSoma % 11);

    IF @nDCalc = 10
	BEGIN
        SET @nDCalc = 0;
    END
    ELSE IF @nDCalc = 11
	BEGIN
        SET @nDCalc = 1;
    END

	SET @tDC = CAST(@nDCalc AS CHAR(01));
    
	RETURN @tDC;

END

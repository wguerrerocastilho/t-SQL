USE [FnDB]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_CalcDC399]    Script Date: 18/02/2020 17:57:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[Fn_CalcDC399](@tCode VARCHAR(20) )
/* ==========================================================================================
   Author      : Waldemar Guerrero
   Create date : 
   Description : Calculo do digito de controle para agencia e contas corrente 
                 do banco 399 Banco HSBC (antigo) / KIRTON BANK

	Formato
				 AAAACCCCCC

				 AAAA     - Quatro digitos para numero da agência
				 CCCCCC   - Numero da conta corrente em 6 posições
                 D        - Digito de controle;
             
			 PRINT dbo.Fn_CalcDC399('2589456789') + ' = ' + '1'
			 PRINT dbo.Fn_CalcDC399('3928987654') + ' = ' + '6'
			 PRINT dbo.Fn_CalcDC399('3928123456') + ' = ' + '1'
			 PRINT dbo.Fn_CalcDC399('1598741329') + ' = ' + '3'

   ========================================================================================== */

RETURNS CHAR(01)

AS
BEGIN
	-- Declare the return variable here
	DECLARE @tDC CHAR(01);
    
    DECLARE @tMlt VARCHAR(20) = '8923456789';
    DECLARE @nSoma SMALLINT   = 0;
    DECLARE @nLen SMALLINT    = 0;
    DECLARE @nI SMALLINT      = 0;
    DECLARE @nDCalc SMALLINT  = 0;

	-- Adiciona zeros a esquerda, para sincronizar com a string do multiplicador
	SET @tCode = REPLICATE('0', 10 - LEN(@tCode)) + @tCode;

    SET @nLen = LEN(@tCode);
	WHILE @nI <= @nLen
	BEGIN
        SET @nSoma += CAST(SUBSTRING(@tCode, @nI, 1) AS SMALLINT) * CAST(SUBSTRING(@tMlt, @nI,1) AS SMALLINT);
	    SET @nI += 1;
	END

    -- Cálculo do DC
	SET @nDCalc = (@nSoma % 11);

    IF @nDCalc = 10
	BEGIN
        SET @nDCalc = 0;
    END

	SET @tDC = CAST(@nDCalc AS CHAR(01));
    
	RETURN @tDC;

END

DO $$
BEGIN
    -- Verificar si la tabla Pais existe y si tiene la columna Moneda
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_name = 'pais'
    ) AND EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'pais'
            AND column_name = 'moneda'
    )
    THEN
        -- Crear la tabla Moneda
        CREATE TABLE Moneda (
            Id SERIAL PRIMARY KEY,
            Nombre VARCHAR(100) NOT NULL,
            Sigla VARCHAR(5) NOT NULL DEFAULT 'N/A',
            Imagen BYTEA NULL
        );

        -- Insertar los tipos de moneda distintos de la tabla Pais
        INSERT INTO Moneda (Nombre)
        SELECT DISTINCT Moneda
        FROM Pais;

        -- Agregar las columnas IdMoneda, Mapa y Bandera a la tabla Pais
        ALTER TABLE Pais
        ADD COLUMN IdMoneda INTEGER DEFAULT 1 NOT NULL,
        ADD COLUMN Mapa BYTEA NULL,
        ADD COLUMN Bandera BYTEA NULL;

        -- Crear la restricción de clave foránea para IdMoneda
        ALTER TABLE Pais
        ADD CONSTRAINT foregingkey_Pais_Idmoneda FOREIGN KEY (IdMoneda) REFERENCES Moneda(Id);

        -- Actualizar el campo IdMoneda en la tabla Pais
        UPDATE Pais
        SET IdMoneda = m.Id
        FROM Moneda m
        WHERE Pais.Moneda = m.Nombre;

        -- Eliminar la columna Moneda de la tabla Pais
        ALTER TABLE Pais
        DROP COLUMN Moneda;
    END IF;
END $$;
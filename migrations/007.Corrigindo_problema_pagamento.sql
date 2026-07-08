ALTER TABLE pagamento 
    ADD COLUMN id_entrega INT UNIQUE,
    ADD CONSTRAINT fk_pagamento_entrega 
    FOREIGN KEY (id_entrega) REFERENCES entrega(id_entrega);

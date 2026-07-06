ALTER TABLE pagamento 
    ADD COLUMN id_entrega INT,
    ADD CONSTRAINT fk_pagamento_entrega 
    FOREIGN KEY (id_entrega) REFERENCES entrega(id_entrega);

drop table tcharge;
drop TABLE tcash;
drop table tcreditcard;
drop table tvoucher;
drop table tpaymentmean;
drop table tsubstitution;
drop TABLE tintervention ;
drop table tworkorder;
drop table tmechanic;

drop table tvehicle;
drop table tvehicletype;


DROP TABLE tsparepart;
drop TABLE tinvoice;

drop  TABLE tclient;

CREATE TABLE tmechanic (
    dni      VARCHAR2(255) NOT NULL constraint tmechanic_pk PRIMARY KEY,
    name     VARCHAR2(255) NOT NULL,
    surname  VARCHAR2(255) NOT NULL
);

CREATE TABLE tsparepart (
    code         VARCHAR2(255) NOT NULL constraint tsparepart_pk PRIMARY KEY,
    description  VARCHAR2(255) NOT NULL,
    price        NUMBER NOT NULL,
    stock        INTEGER NOT NULL,
    maxstock     INTEGER NOT NULL,
    minstock     INTEGER NOT NULL,
    quantity     INTEGER NOT NULL,
    delivery_term     TIMESTAMP NOT NULL
);

CREATE TABLE tprovider (
    nif          VARCHAR2(255) NOT NULL constraint tprovider_pk PRIMARY KEY,
    name         VARCHAR2(255) NOT NULL,
    mail         VARCHAR2(255) NOT NULL,
    phone        VARCHAR2(255) NOT NULL,
    numorders    INTEGER NOT NULL
);

CREATE TABLE tpadministrator (
	nif_provider      VARCHAR2(255) NOT NULL,
    code_sparepart    VARCHAR2(255) NOT NULL ,
    price             NUMBER NOT NULL,
    delivery_term     TIMESTAMP NOT NULL,
    CONSTRAINT PK_ADMINISTRATOR PRIMARY KEY (nif_provider, code_sparepart),
    CONSTRAINT FK_ADMINISTRATOR_PROVIDER FOREIGN KEY (nif_provider) REFERENCES tprovider (nif),
    CONSTRAINT FK_ADMINISTRATOR_SPAREPART FOREIGN KEY (code_sparepart) REFERENCES tsparepart (code_sparepart)
);

CREATE TABLE torder (
    code_order       VARCHAR2(255) NOT NULL constraint torder_pk PRIMARY KEY,
    nif_proveedor    VARCHAR2(255) NOT NULL,
    ordered_date     TIMESTAMP NOT NULL,
    reception_date   TIMESTAMP NOT NULL,
    status           VARCHAR2(255) NOT NULL,
    price            NUMBER NOT NULL,
    CONSTRAINT CK_ORDER_STATUS CHECK (status IN ('PENDING' , 'RECEIVED'))
);

CREATE TABLE tgenerate (
	nif_provider      VARCHAR2(255) NOT NULL,
    code              VARCHAR2(255) NOT NULL ,
    CONSTRAINT PK_GENERATE PRIMARY KEY (nif_provider, code),
    CONSTRAINT FK_GENERATE_PROVIDER FOREIGN KEY (nif_provider) REFERENCES tprovider (nif),
    CONSTRAINT FK_GENERATE_ORDER FOREIGN KEY (code) REFERENCES torder (code_order)
);

CREATE TABLE tvehicle (
    platenumber     VARCHAR2(255) NOT NULL constraint tvehicle_pk PRIMARY KEY,
	brand           VARCHAR2(255) NOT NULL,
    model           VARCHAR2(255) NOT NULL,
    client_dni      VARCHAR2(255),
    vehicletype_name  VARCHAR2(255)
);

CREATE TABLE tvehicletype (
    name          VARCHAR2(255) NOT NULL constraint tvehicletype_pk PRIMARY KEY,
    priceperhour  NUMBER NOT NULL
);

CREATE TABLE tsubstitution (

	wo_date  TIMESTAMP NOT NULL,
	vehicle_pn VARCHAR2(255) NOT NULL,
    mechanic_dni VARCHAR2(255) NOT NULL,
    inter_date TIMESTAMP NOT NULL,
    sparepart_code     VARCHAR2(255) NOT NULL,
	quantity         INTEGER NOT NULL,
        CONSTRAINT tsubstitution_pk PRIMARY KEY ( wo_date,vehicle_pn,mechanic_dni,inter_date,
                                             sparepart_code ),
    CONSTRAINT tsubstitution_tsparepart_fk FOREIGN KEY ( sparepart_code )
        REFERENCES tsparepart ( code )
);

CREATE TABLE tpaymentmean (
    id           VARCHAR2(255) NOT NULL constraint tpaymentmean_pk PRIMARY KEY,
    type        VARCHAR2(31) NOT NULL,
    accumulated  NUMBER NOT NULL,
    client_dni    VARCHAR2(255)
);

CREATE TABLE tvoucher (
    id           VARCHAR2(255) NOT NULL constraint tvoucher_pk PRIMARY KEY,
    available    NUMBER NOT NULL,
    code         VARCHAR2(255) NOT NULL,
    description  VARCHAR2(255) NOT NULL,
    CONSTRAINT tvoucher_code_uk UNIQUE ( code ),
    CONSTRAINT tvoucher_tpayments_fk FOREIGN KEY ( id )
        REFERENCES tpaymentmean ( id )
);

CREATE TABLE tcharge (
    invoice_numb      NUMBER NOT NULL,
    paymentmean_id  VARCHAR2(255) NULL,
    amount          NUMBER NOT NULL,
    CONSTRAINT  tcharge_pk PRIMARY KEY( invoice_numb,
                                       paymentmean_id ),
    CONSTRAINT tcharge_tpaymentmean_fk FOREIGN KEY ( paymentmean_id )
        REFERENCES tpaymentmean ( id )
);

CREATE TABLE tcreditcard (
    id         VARCHAR2(255) NOT NULL constraint tcreditcard_pk PRIMARY KEY,
    numb       VARCHAR2(255) NOT NULL,
    type       VARCHAR2(255) NOT NULL,
    validthru  DATE NOT NULL,
    CONSTRAINT tcreditcard_uk UNIQUE ( numb ),
    CONSTRAINT tcreditcard_tpymentmeans_fk FOREIGN KEY ( id )
        REFERENCES tpaymentmean ( id )
);

CREATE TABLE tworkorder (
    wo_date  TIMESTAMP NOT NULL,
	vehicle_pn     VARCHAR2(255) NOT NULL,
	amount         NUMBER,
    description    VARCHAR2(255) NOT NULL,
    status         VARCHAR2(255) NOT NULL,
    invoice_numb    NUMBER,
    mechanic_dni    VARCHAR2(255) NOT NULL,
    CONSTRAINT  tworkorder_pk PRIMARY KEY ( wo_date,
                                          vehicle_pn ),
    CONSTRAINT tworkorder_tvehicle_fk FOREIGN KEY ( vehicle_pn )
        REFERENCES tvehicle ( platenumber ),
    CONSTRAINT tworkorder_tmechanic_fk FOREIGN KEY ( mechanic_dni )
        REFERENCES tmechanic ( dni ),		
    CONSTRAINT TWORKORDER_STATUS_CK CHECK (STATUS in ('OPEN','ASSIGNED','FINISHED','INVOICED'))
);

CREATE TABLE tinvoice (
    numb     NUMBER NOT NULL constraint tinvoice_pk PRIMARY KEY,
    amount   NUMBER NOT NULL,
    in_date  DATE NOT NULL,
    status   VARCHAR2(255) NOT NULL,
    vat      NUMBER NOT NULL,
	CONSTRAINT TINVOICE_STATUS_CK CHECK (STATUS in ('PAID','NOT_YET_PAID'))	
);

CREATE TABLE tcash (
    id VARCHAR2(255) NOT NULL constraint tcash_pk PRIMARY KEY,
    CONSTRAINT tcash_tpaymentmean_fk FOREIGN KEY ( id )
        REFERENCES tpaymentmean ( id )
);

CREATE TABLE tintervention (
    wo_date    TIMESTAMP not null,
	vehicle_pn VARCHAR2(255) NOT NULL,
    mechanic_dni   VARCHAR2(255) NOT NULL,
	inter_date          TIMESTAMP NOT NULL,
    minutes       INTEGER NOT NULL,
    CONSTRAINT tintervention_pk PRIMARY KEY ( wo_date,vehicle_pn,
                                             mechanic_dni,
                                             inter_date ),
    CONSTRAINT tintervention_tmechanic_fk FOREIGN KEY ( mechanic_dni )
        REFERENCES tmechanic ( dni ),
    CONSTRAINT fk_tintervention_tworkorder_fk FOREIGN KEY ( wo_date,vehicle_pn )
        REFERENCES tworkorder ( wo_date,vehicle_pn )
);

CREATE TABLE tclient (
    dni      VARCHAR2(50) NOT NULL constraint tclient_pk PRIMARY KEY,
    email    VARCHAR2(50),
    name     VARCHAR2(50) NOT NULL,
    phone    VARCHAR2(50),
    surname  VARCHAR2(50) NOT NULL,
    city     VARCHAR2(255),
    street   VARCHAR2(255),
    zipcode  VARCHAR2(15)
);

ALTER TABLE tvehicle
    ADD CONSTRAINT tvehicle_tvehicletype_fk FOREIGN KEY ( vehicletype_name )
        REFERENCES tvehicletype ( name );

ALTER TABLE tvehicle
    ADD CONSTRAINT tvehicle_tclient_fk FOREIGN KEY ( client_dni )
        REFERENCES tclient ( dni );

ALTER TABLE tsubstitution
    ADD CONSTRAINT tsubstitution_tinterven_fk FOREIGN KEY (  wo_date,vehicle_pn,
                                             mechanic_dni,
                                             inter_date )
        REFERENCES tintervention (  wo_date,vehicle_pn,
                                             mechanic_dni,
                                             inter_date );

ALTER TABLE tpaymentmean
    ADD CONSTRAINT tpaymentmean_tclient_fk FOREIGN KEY ( client_dni )
        REFERENCES tclient ( dni );

ALTER TABLE tcharge
    ADD CONSTRAINT tcharge_tinvoice_fk FOREIGN KEY ( invoice_numb )
        REFERENCES tinvoice ( numb );

ALTER TABLE tworkorder
    ADD CONSTRAINT tworkorder_tinvoice_fk FOREIGN KEY ( invoice_numb )
        REFERENCES tinvoice ( numb );
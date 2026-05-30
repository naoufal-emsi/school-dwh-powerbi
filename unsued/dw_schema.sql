-- ============================================================
-- DATA WAREHOUSE — École (Star Schema)
-- Compatible : PostgreSQL 16
-- Run: psql -U dw_user -d dw_ecole -f dw_schema.sql
-- Order: dimensions first, facts after (FK dependencies)
-- ============================================================

-- ============================================================
-- DIMENSIONS
-- ============================================================

CREATE TABLE IF NOT EXISTS DIM_DEPARTEMENT (
    sk_departement  INT          NOT NULL,
    nom_departement VARCHAR(100) NOT NULL,
    CONSTRAINT pk_departement PRIMARY KEY (sk_departement)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS DIM_TEMPS (
    sk_date       INT         NOT NULL,  -- format YYYYMMDD
    date_complete DATE        NOT NULL,
    jour          INT         NOT NULL,
    nom_jour      VARCHAR(10) NOT NULL,  -- Lundi … Dimanche
    mois          INT         NOT NULL,
    nom_mois      VARCHAR(10) NOT NULL,  -- Janvier … Décembre
    trimestre     INT         NOT NULL,
    annee         INT         NOT NULL,
    semestre_univ VARCHAR(10) NOT NULL,  -- ex: 2023-2024
    semaine_iso   VARCHAR(10) NOT NULL,  -- ex: 2023-S42
    CONSTRAINT pk_temps PRIMARY KEY (sk_date)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS DIM_ANNEE_UNIV (
    sk_annee            INT         NOT NULL,
    annee_universitaire VARCHAR(10) NOT NULL,
    annee_debut         INT         NOT NULL,
    annee_fin           INT         NOT NULL,
    CONSTRAINT pk_annee_univ PRIMARY KEY (sk_annee)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS DIM_ETUDIANT (
    sk_etudiant       INT          NOT NULL,
    id_etudiant       INT          NOT NULL,
    sexe              VARCHAR(1)   NOT NULL,
    ville_origine     VARCHAR(100),
    region            VARCHAR(100),
    type_bac          VARCHAR(50),
    mention_bac       VARCHAR(20),
    boursier          BOOLEAN      NOT NULL,
    statut            VARCHAR(20)  NOT NULL,
    filiere           VARCHAR(100),
    niveau_actuel     VARCHAR(5),
    annee_inscription INT,
    age               INT,
    CONSTRAINT pk_etudiant PRIMARY KEY (sk_etudiant)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS DIM_PROFESSEUR (
    sk_professeur     INT          NOT NULL,
    id_professeur     INT          NOT NULL,
    grade             VARCHAR(10),
    sk_departement    INT          NOT NULL,
    specialite        VARCHAR(100),
    charge_prevue_h   INT,
    nb_publications   INT,
    annee_recrutement INT,
    CONSTRAINT pk_professeur PRIMARY KEY (sk_professeur),
    CONSTRAINT fk_prof_dept FOREIGN KEY (sk_departement) REFERENCES DIM_DEPARTEMENT(sk_departement)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS DIM_MODULE (
    sk_module         INT          NOT NULL,
    id_module         INT          NOT NULL,
    nom_module        VARCHAR(100),
    filiere           VARCHAR(100),
    niveau            VARCHAR(5),
    sk_departement    INT          NOT NULL,
    credits_ects      INT,
    heures_prevues    INT,
    CONSTRAINT pk_module PRIMARY KEY (sk_module),
    CONSTRAINT fk_module_dept FOREIGN KEY (sk_departement) REFERENCES DIM_DEPARTEMENT(sk_departement)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS DIM_SALLE (
    sk_salle  INT         NOT NULL,
    id_salle  INT         NOT NULL,
    nom_salle VARCHAR(50),
    capacite  INT,
    type      VARCHAR(20),
    batiment  VARCHAR(50),
    CONSTRAINT pk_salle PRIMARY KEY (sk_salle)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS DIM_STAFF (
    sk_staff          INT         NOT NULL,
    id_staff          INT         NOT NULL,
    role              VARCHAR(50),
    sk_departement    INT         NOT NULL,
    annee_recrutement INT,
    CONSTRAINT pk_staff PRIMARY KEY (sk_staff),
    CONSTRAINT fk_staff_dept FOREIGN KEY (sk_departement) REFERENCES DIM_DEPARTEMENT(sk_departement)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS DIM_CLUB (
    sk_club        INT          NOT NULL,
    id_club        INT          NOT NULL,
    nom_club       VARCHAR(100),
    type           VARCHAR(20),
    annee_creation INT,
    CONSTRAINT pk_club PRIMARY KEY (sk_club)
);

-- ============================================================
-- FACTS
-- ============================================================

CREATE TABLE IF NOT EXISTS FACT_NOTE (
    sk_note     INT          NOT NULL,
    sk_etudiant INT          NOT NULL,
    sk_module   INT          NOT NULL,
    sk_annee    INT          NOT NULL,
    note        DECIMAL(4,2),
    admis_bool  BOOLEAN,
    session     VARCHAR(20),
    mention     VARCHAR(20),
    CONSTRAINT pk_note          PRIMARY KEY (sk_note),
    CONSTRAINT fk_note_etudiant FOREIGN KEY (sk_etudiant) REFERENCES DIM_ETUDIANT(sk_etudiant),
    CONSTRAINT fk_note_module   FOREIGN KEY (sk_module)   REFERENCES DIM_MODULE(sk_module),
    CONSTRAINT fk_note_annee    FOREIGN KEY (sk_annee)    REFERENCES DIM_ANNEE_UNIV(sk_annee)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS FACT_SEANCE (
    sk_seance             INT     NOT NULL,
    id_seance             INT     NOT NULL,  -- clé dégénérée
    sk_module             INT     NOT NULL,
    sk_professeur         INT     NOT NULL,
    sk_salle              INT     NOT NULL,
    sk_date               INT     NOT NULL,
    effectuee             BOOLEAN,
    retard_minutes        INT,
    nb_etudiants_presents INT,
    duree_minutes         INT,
    CONSTRAINT pk_seance        PRIMARY KEY (sk_seance),
    CONSTRAINT fk_seance_module FOREIGN KEY (sk_module)     REFERENCES DIM_MODULE(sk_module),
    CONSTRAINT fk_seance_prof   FOREIGN KEY (sk_professeur) REFERENCES DIM_PROFESSEUR(sk_professeur),
    CONSTRAINT fk_seance_salle  FOREIGN KEY (sk_salle)      REFERENCES DIM_SALLE(sk_salle),
    CONSTRAINT fk_seance_date   FOREIGN KEY (sk_date)       REFERENCES DIM_TEMPS(sk_date)
);

-- ------------------------------------------------------------
-- id_seance is a degenerate key — no FK to FACT_SEANCE
-- sk_module / sk_date / sk_salle denormalized from SEANCE_COURS at ETL time

CREATE TABLE IF NOT EXISTS FACT_PRESENCE (
    sk_presence INT     NOT NULL,
    sk_etudiant INT     NOT NULL,
    id_seance   INT     NOT NULL,  -- clé dégénérée, pas de FK
    sk_module   INT     NOT NULL,
    sk_date     INT     NOT NULL,
    sk_salle    INT     NOT NULL,
    present     BOOLEAN,
    justifiee   BOOLEAN,
    CONSTRAINT pk_presence          PRIMARY KEY (sk_presence),
    CONSTRAINT fk_presence_etudiant FOREIGN KEY (sk_etudiant) REFERENCES DIM_ETUDIANT(sk_etudiant),
    CONSTRAINT fk_presence_module   FOREIGN KEY (sk_module)   REFERENCES DIM_MODULE(sk_module),
    CONSTRAINT fk_presence_date     FOREIGN KEY (sk_date)     REFERENCES DIM_TEMPS(sk_date),
    CONSTRAINT fk_presence_salle    FOREIGN KEY (sk_salle)    REFERENCES DIM_SALLE(sk_salle)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS FACT_SATISFACTION (
    sk_enquete          INT          NOT NULL,
    sk_etudiant         INT          NOT NULL,
    sk_professeur       INT          NOT NULL,
    sk_module           INT          NOT NULL,
    sk_annee            INT          NOT NULL,
    score_clarte        INT,
    score_disponibilite INT,
    score_pedagogie     INT,
    score_equite        INT,
    score_admin         INT,
    score_vie_etudiante INT,
    score_charge        INT,
    score_finances      INT,
    score_global        DECIMAL(3,2),
    score_prof_pondere  DECIMAL(3,2),
    nps                 INT,
    CONSTRAINT pk_satisfaction PRIMARY KEY (sk_enquete),
    CONSTRAINT fk_sat_etudiant FOREIGN KEY (sk_etudiant)   REFERENCES DIM_ETUDIANT(sk_etudiant),
    CONSTRAINT fk_sat_prof     FOREIGN KEY (sk_professeur) REFERENCES DIM_PROFESSEUR(sk_professeur),
    CONSTRAINT fk_sat_module   FOREIGN KEY (sk_module)     REFERENCES DIM_MODULE(sk_module),
    CONSTRAINT fk_sat_annee    FOREIGN KEY (sk_annee)      REFERENCES DIM_ANNEE_UNIV(sk_annee)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS FACT_INSERTION (
    sk_insertion          INT           NOT NULL,
    sk_etudiant           INT           NOT NULL,
    sk_annee              INT           NOT NULL,
    sk_date_diplome       INT           NOT NULL,
    sk_date_emploi        INT,                     -- NULL si pas d'emploi
    salaire_embauche      DECIMAL(10,2),
    secteur               VARCHAR(100),
    type_poursuite        VARCHAR(20),
    delai_insertion_jours INT,
    CONSTRAINT pk_insertion        PRIMARY KEY (sk_insertion),
    CONSTRAINT fk_ins_etudiant     FOREIGN KEY (sk_etudiant)     REFERENCES DIM_ETUDIANT(sk_etudiant),
    CONSTRAINT fk_ins_annee        FOREIGN KEY (sk_annee)        REFERENCES DIM_ANNEE_UNIV(sk_annee),
    CONSTRAINT fk_ins_date_diplome FOREIGN KEY (sk_date_diplome) REFERENCES DIM_TEMPS(sk_date),
    CONSTRAINT fk_ins_date_emploi  FOREIGN KEY (sk_date_emploi)  REFERENCES DIM_TEMPS(sk_date)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS FACT_FRAIS_SCOLARITE (
    sk_frais          INT           NOT NULL,
    sk_etudiant       INT           NOT NULL,
    sk_annee          INT           NOT NULL,
    sk_date_paiement  INT           NOT NULL,
    montant_du        DECIMAL(10,2),
    montant_paye      DECIMAL(10,2),
    statut            VARCHAR(20),
    taux_recouvrement DECIMAL(5,4),
    CONSTRAINT pk_frais          PRIMARY KEY (sk_frais),
    CONSTRAINT fk_frais_etudiant FOREIGN KEY (sk_etudiant)      REFERENCES DIM_ETUDIANT(sk_etudiant),
    CONSTRAINT fk_frais_annee    FOREIGN KEY (sk_annee)         REFERENCES DIM_ANNEE_UNIV(sk_annee),
    CONSTRAINT fk_frais_date     FOREIGN KEY (sk_date_paiement) REFERENCES DIM_TEMPS(sk_date)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS FACT_DEMANDE_ADMIN (
    sk_demande             INT     NOT NULL,
    sk_etudiant            INT     NOT NULL,
    sk_staff               INT     NOT NULL,
    sk_date_soumission     INT     NOT NULL,
    type_demande           VARCHAR(50),
    resolu_premier_contact BOOLEAN,
    satisfaction_service   INT,
    delai_jours            INT,
    CONSTRAINT pk_demande      PRIMARY KEY (sk_demande),
    CONSTRAINT fk_dem_etudiant FOREIGN KEY (sk_etudiant)        REFERENCES DIM_ETUDIANT(sk_etudiant),
    CONSTRAINT fk_dem_staff    FOREIGN KEY (sk_staff)           REFERENCES DIM_STAFF(sk_staff),
    CONSTRAINT fk_dem_date     FOREIGN KEY (sk_date_soumission) REFERENCES DIM_TEMPS(sk_date)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS FACT_CHARGE_ETUDIANT (
    sk_charge         INT          NOT NULL,
    sk_etudiant       INT          NOT NULL,
    sk_date           INT          NOT NULL,  -- lundi de la semaine
    heures_cours      DECIMAL(4,1),
    heures_devoirs    DECIMAL(4,1),
    heures_projets    DECIMAL(4,1),
    heures_temps_mort DECIMAL(4,1),
    charge_totale     DECIMAL(5,1),
    CONSTRAINT pk_charge          PRIMARY KEY (sk_charge),
    CONSTRAINT fk_charge_etudiant FOREIGN KEY (sk_etudiant) REFERENCES DIM_ETUDIANT(sk_etudiant),
    CONSTRAINT fk_charge_date     FOREIGN KEY (sk_date)     REFERENCES DIM_TEMPS(sk_date)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS FACT_BUDGET (
    sk_budget           INT           NOT NULL,
    sk_departement      INT           NOT NULL,
    annee               INT           NOT NULL,
    budget_prevu        DECIMAL(12,2),
    budget_execute      DECIMAL(12,2),
    type_depense        VARCHAR(50),
    taux_execution      DECIMAL(5,4),
    financement_externe DECIMAL(12,2),
    CONSTRAINT pk_budget      PRIMARY KEY (sk_budget),
    CONSTRAINT fk_budget_dept FOREIGN KEY (sk_departement) REFERENCES DIM_DEPARTEMENT(sk_departement)
);

-- ------------------------------------------------------------
-- Summary table — aggregated per student x year for dashboard Page 7

CREATE TABLE IF NOT EXISTS FACT_VIE_ETUDIANTE (
    sk_etudiant      INT           NOT NULL,
    sk_annee         INT           NOT NULL,
    nb_clubs         INT,
    aide_accordee    BOOLEAN,
    montant_aide     DECIMAL(10,2),
    nb_signalements  INT,
    en_mobilite      BOOLEAN,
    nb_visites_sante INT,
    CONSTRAINT pk_vie_etudiante PRIMARY KEY (sk_etudiant, sk_annee),
    CONSTRAINT fk_vie_etudiant  FOREIGN KEY (sk_etudiant) REFERENCES DIM_ETUDIANT(sk_etudiant),
    CONSTRAINT fk_vie_annee     FOREIGN KEY (sk_annee)    REFERENCES DIM_ANNEE_UNIV(sk_annee)
);

-- ------------------------------------------------------------
-- Detail tables — kept for drill-down queries

CREATE TABLE IF NOT EXISTS FACT_PARTICIPATION_CLUB (
    sk_participation INT         NOT NULL,
    sk_etudiant      INT         NOT NULL,
    sk_club          INT         NOT NULL,
    sk_annee         INT         NOT NULL,
    role             VARCHAR(30),
    CONSTRAINT pk_participation PRIMARY KEY (sk_participation),
    CONSTRAINT fk_part_etudiant FOREIGN KEY (sk_etudiant) REFERENCES DIM_ETUDIANT(sk_etudiant),
    CONSTRAINT fk_part_club     FOREIGN KEY (sk_club)     REFERENCES DIM_CLUB(sk_club),
    CONSTRAINT fk_part_annee    FOREIGN KEY (sk_annee)    REFERENCES DIM_ANNEE_UNIV(sk_annee)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS FACT_AIDE_SOCIALE (
    sk_aide         INT           NOT NULL,
    sk_etudiant     INT           NOT NULL,
    sk_date_demande INT           NOT NULL,
    type_aide       VARCHAR(50),
    statut          VARCHAR(20),
    montant_mad     DECIMAL(10,2),
    CONSTRAINT pk_aide          PRIMARY KEY (sk_aide),
    CONSTRAINT fk_aide_etudiant FOREIGN KEY (sk_etudiant)     REFERENCES DIM_ETUDIANT(sk_etudiant),
    CONSTRAINT fk_aide_date     FOREIGN KEY (sk_date_demande) REFERENCES DIM_TEMPS(sk_date)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS FACT_SIGNALEMENT (
    sk_signalement INT         NOT NULL,
    sk_etudiant    INT         NOT NULL,
    sk_date        INT         NOT NULL,
    type           VARCHAR(50),
    gravite        VARCHAR(20),
    statut         VARCHAR(20),
    CONSTRAINT pk_signalement  PRIMARY KEY (sk_signalement),
    CONSTRAINT fk_sig_etudiant FOREIGN KEY (sk_etudiant) REFERENCES DIM_ETUDIANT(sk_etudiant),
    CONSTRAINT fk_sig_date     FOREIGN KEY (sk_date)     REFERENCES DIM_TEMPS(sk_date)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS FACT_MOBILITE (
    sk_mobilite           INT          NOT NULL,
    sk_etudiant           INT          NOT NULL,
    sk_date_debut         INT          NOT NULL,
    sk_date_fin           INT,
    type                  VARCHAR(20),
    pays_destination      VARCHAR(100),
    universite_partenaire VARCHAR(200),
    programme             VARCHAR(50),
    CONSTRAINT pk_mobilite       PRIMARY KEY (sk_mobilite),
    CONSTRAINT fk_mob_etudiant   FOREIGN KEY (sk_etudiant)   REFERENCES DIM_ETUDIANT(sk_etudiant),
    CONSTRAINT fk_mob_date_debut FOREIGN KEY (sk_date_debut) REFERENCES DIM_TEMPS(sk_date),
    CONSTRAINT fk_mob_date_fin   FOREIGN KEY (sk_date_fin)   REFERENCES DIM_TEMPS(sk_date)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS FACT_VISITE_SANTE (
    sk_visite    INT          NOT NULL,
    sk_etudiant  INT          NOT NULL,
    sk_date      INT          NOT NULL,
    type_service VARCHAR(50),
    motif        VARCHAR(100),
    CONSTRAINT pk_visite          PRIMARY KEY (sk_visite),
    CONSTRAINT fk_visite_etudiant FOREIGN KEY (sk_etudiant) REFERENCES DIM_ETUDIANT(sk_etudiant),
    CONSTRAINT fk_visite_date     FOREIGN KEY (sk_date)     REFERENCES DIM_TEMPS(sk_date)
);

-- ============================================================
-- CONFIG TABLES (direct copy from Excel, no transformation)
-- ============================================================

CREATE TABLE IF NOT EXISTS POIDS_LEVIER_SATISFACTION (
    id_poids            INT          NOT NULL,
    annee_universitaire VARCHAR(10)  NOT NULL,
    levier              VARCHAR(50)  NOT NULL,
    poids               DECIMAL(4,2) NOT NULL,
    CONSTRAINT pk_poids PRIMARY KEY (id_poids)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS SEUIL_ALERTE (
    id_seuil     INT           NOT NULL,
    kpi          VARCHAR(100)  NOT NULL,
    seuil_alerte DECIMAL(10,4) NOT NULL,
    niveau       VARCHAR(20)   NOT NULL,
    message      VARCHAR(200),
    CONSTRAINT pk_seuil PRIMARY KEY (id_seuil)
);

-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS KPIs_Synthese (
    id_kpi INT          GENERATED ALWAYS AS IDENTITY,
    page   VARCHAR(100),
    kpi    VARCHAR(200),
    valeur VARCHAR(100),
    CONSTRAINT pk_kpi PRIMARY KEY (id_kpi)
);

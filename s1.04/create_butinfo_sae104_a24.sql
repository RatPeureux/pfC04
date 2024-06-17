drop schema if exists programme_but cascade;
create schema programme_but;
set schema 'programme_but';

create table _parcours (
  code_p CHAR(6),
  libelle_parcours VARCHAR(41),
  nbre_gpe_td_p INTEGER,
  nbre_gpe_tp_p INTEGER,
  constraint _parcours_pk primary key(code_p)
);

create table _sae (
  code_sae VARCHAR(41),
  lib_sae VARCHAR(41),
  nb_h_td_enc INTEGER,
  nb_h_td_projet_autonomie INTEGER,
  constraint _sae_pk primary key(code_sae)
);

create table _competences (
  lib_competence VARCHAR(41),
  constraint _competences_pk primary key(lib_competence)
);

create table _activites (
  lib_activite VARCHAR(41),
  constraint _activites_pk primary key(lib_activite)
);

create table _niveau (
  numero_n INTEGER,
  constraint _niveau_pk primary key(numero_n)
);

create table _semestre (
  numero_sem VARCHAR(41),
  constraint _semestre_pk primary key(numero_sem)
);

create table _ue (
  code_ue VARCHAR(41),
  constraint _ue_pk primary key(code_ue)
);

create table _ressources (
  code_r VARCHAR(41),
  lib_r VARCHAR(41),
  nb_h_cm_pn INTEGER,
  nb_h_td_pn INTEGER,
  nb_h_tp_pn INTEGER,
  constraint _ressources_pk primary key(code_r)
);

create table _est_enseignee (
    code_r VARCHAR(41),
    code_p CHAR(6),
    constraint _est_enseignee_pk primary key(code_r, code_p),
    constraint _est_enseignee_fk1 foreign key (code_r)
        references _ressources(code_r),
    constraint _est_enseignee_fk2 foreign key (code_p)
        references _parcours(code_p)
);

create table _comprend_r (
  code_r VARCHAR(41),
  code_sae VARCHAR(41),
  nb_h_td_c INTEGER,
  nb_h_tp_c INTEGER,
  constraint comprend_r_pk primary key (code_r, code_sae),
  constraint _comprend_r_fk1 foreign key (code_r)
        references _ressources(code_r),
  constraint _comprend_r_fk2 foreign key (code_sae)
        references _sae(code_sae)
);

create table _correspond (
    code_p CHAR(6),
    lib_activite VARCHAR(41),
    numero_n INTEGER,
    constraint _correspond_pk primary key (code_p, lib_activite, numero_n),
    constraint _correspond_fk1 foreign key (code_p)
        references _parcours(code_p),
    constraint _activites_fk2 foreign key (lib_activite)
        references _activites(lib_activite),
    constraint _niveau_fk3 foreign key (numero_n)
        references _niveau(numero_n)
);

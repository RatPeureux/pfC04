-- consignes à respecter :
-- Les noms des schémas seront définis en minuscules.
-- Les relations (tables) seront définies au sein d'un schéma nommé colleges.
-- Les noms des relations de base seront définis en minuscules et préfixés par _. Exemples : _departement, _region.
-- Les contraintes seront nommées explicitement.
-- Les noms d'attributs seront définis en minuscules et reproduiront les variables d'instance ou noms de rôle (au singulier) du diagramme de classes.
-- RENDU FICHIER : 24/05/2023 à 18h00 

drop schema if exists colleges cascade;
create schema colleges;

set schema 'colleges';

create table _academie(
  code_academie integer primary key,
  lib_academie varchar(29),
  unique(lib_academie)
);

create table _region(
  code_region varchar(3) primary key,
  libelle_region varchar(29),
  unique(libelle_region)
);

create table _departement(
  code_du_departement varchar(4) primary key,
  nom_departement varchar(29),
  unique(nom_departement),
  code_region varchar(3),
  constraint _inclut_fk foreign key (code_region)
    references _region(code_region)
);

create table _commune(
  code_insee_de_la_commune varchar(6) primary key,
  nom_de_la_commune varchar(29),
  unique(nom_de_la_commune),
  code_du_departement varchar(4),
  constraint _se_situe_fk foreign key (code_du_departement)
    references _departement(code_du_departement)
);

create table _quartier_prioritaire(
  code_quartier_prioritaire varchar(10) primary key,
  nom_quartier_prioritaire varchar(29)
);

create table _type(
  code_nature varchar(19),
  libelle_nature varchar(29),
  constraint _type_pk primary key(code_nature, libelle_nature)
);

create table _etablissement(
  uai varchar(9) primary key,
  nom_etablissement varchar(29),
  secteur varchar(19),
  code_postal varchar(6),
  lattitude float,
  longitude float,
  code_academie integer,
  code_insee_de_la_commune varchar(6),
  code_nature varchar(19),
  libelle_nature varchar(29),
  constraint _depend_de_fk foreign key (code_academie)
    references _academie(code_academie),
  constraint _est_localise_dans_fk foreign key (code_insee_de_la_commune)
    references _commune(code_insee_de_la_commune),
  constraint _etablissement_fk_type foreign key (code_nature, libelle_nature)
    references _type(code_nature, libelle_nature)
    
);

create table _annee(
  annee_scolaire varchar(10) primary key
);

create table _classe(
  id_classe varchar(5) primary key
);

create table _est_a_proximite_de(
  uai varchar(9),
  code_quartier_prioritaire varchar(10),
  constraint _est_a_proximite_de_pk primary key(uai, code_quartier_prioritaire),
  constraint _est_a_proximite_de_fk_etablissement foreign key (uai)
    references _etablissement(uai),
  constraint _est_a_proximite_de_fk_quartier_prioritaire foreign key (code_quartier_prioritaire)
    references _quartier_prioritaire(code_quartier_prioritaire)
);

create table _caracteristiques_tout_etablissement(
  uai varchar(9),
  annee_scolaire varchar(10),
  effectifs integer,
  ips float,
  ecart_type_de_l_ips float,
  ep varchar(5),
  constraint _caracteristiques_tout_etablissement_pk primary key(uai, annee_scolaire),
  constraint _caracteristiques_tout_etablissement_fk_etablissement foreign key (uai)
    references _etablissement(uai),
  constraint _caracteristiques_tout_etablissement_fk_annnee foreign key (annee_scolaire)
    references _annee(annee_scolaire)
);

create table _caracteristiques_college(
  uai varchar(9),
  annee_scolaire varchar(10),
  nbre_eleves_hors_segpa_hors_ulis integer,
  nbre_eleves_segpa integer,
  nbre_eleves_ulis integer,
  constraint _caracteristiques_college_pk primary key(uai, annee_scolaire),
  constraint _caracteristiques_college_fk_etablissement foreign key (uai)
    references _etablissement(uai),
  constraint _caracteristiques_college_fk_annee foreign key (annee_scolaire)
    references _annee(annee_scolaire)
);

create table _caracteristiques_selon_classe(
  uai varchar(9),
  annee_scolaire varchar(10),
  id_classe varchar(5),
  nbre_eleves_hors_segpa_hors_ulis_selon_niveau integer,
  nbre_eleves_segpa_selon_niveau integer,
  nbre_eleves_ulis_selon_niveau integer,
  effectif_filles integer, 
  effectif_garçons integer,
  constraint _caracteristiques_selon_classe_pk primary key(uai, annee_scolaire, id_classe),
  constraint _caracteristiques_selon_classe_fk_etablissement foreign key (uai)
    references _etablissement(uai),
  constraint _caracteristiques_selon_classe_fk_annee foreign key (annee_scolaire)
    references _annee(annee_scolaire),
  constraint _caracteristiques_selon_classe_fk_classe foreign key (id_classe)
    references _classe(id_classe)
);

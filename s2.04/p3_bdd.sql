drop schema if exists colleges2 cascade;

create schema colleges2;
set schema 'colleges2';

drop table if exists _temp_fr_en_indicateurs_valeur_ajoutee_colleges;
create table _temp_fr_en_indicateurs_valeur_ajoutee_colleges(
  session                               char(9),
  uai                                   char(8),
  nom_de_l_etablissement                varchar(87)   not null,
  commune                               varchar(32)   not null,
  departement                           varchar(21)   not null,
  academie                              varchar(16)   not null,
  secteur                               char(2)       not null,
  nb_candidats_g                        numeric       default 0,
  taux_de_reussite_g                    numeric(5,1),
  va_du_taux_de_reussite_g              numeric(5,1),
  nb_candidats_p                        numeric       default 0,
  taux_de_reussite_p                    numeric(5,1),
  note_a_l_ecrit_g                      numeric(4,1),
  va_de_la_note_g                       numeric(4,1),
  note_a_l_ecrit_p                      numeric(4,1),
  taux_d_acces_6eme_3eme                numeric(5,1),
  part_presents_3eme_ordinaire_total    numeric(5,1),
  part_presents_3eme_ordinaire_g        numeric(5,1),
  part_presents_3eme_ordinaire_p        numeric(5,1),
  part_presents_3eme_segpa_total        numeric(5,1),
  nb_mentions_ab_g                      numeric       default 0,
  nb_mentions_b_g                       numeric       default 0,
  nb_mentions_tb_g                      numeric       default 0,
  nb_mentions_global_g                  numeric       default 0,
  constraint indicateurs_valeur_ajoutee_pk primary key (uai, session)
);

drop function if exists ftg_maj_secteur();
create or replace function ftg_maj_secteur() returns trigger as $$
declare 
    secteur   integer;
begin
    if new.secteur = 'PU' then
        new.secteur := 0;
    elsif new.secteur = 'PR' then
        new.secteur := 1;
    end if;
    return new;
end;
$$ language plpgsql;

drop trigger if exists tg_maj_secteur on _temp_fr_en_indicateurs_valeur_ajoutee_colleges;
create trigger tg_maj_secteur
before insert or update of secteur
on _temp_fr_en_indicateurs_valeur_ajoutee_colleges
for each row
execute procedure ftg_maj_secteur(); 

delete from _temp_fr_en_indicateurs_valeur_ajoutee_colleges;
WbImport -file=./fr-en-indicateurs-valeur-ajoutee-colleges.csv
         -header=true
         -delimiter=';'
         -quoteChar='"' 
         -table=_temp_fr_en_indicateurs_valeur_ajoutee_colleges
         -schema=colleges2
         -mode=insert, update -- car il y a des doublons (toute la ligne)
         -filecolumns=session,uai,nom_de_l_etablissement,commune,departement,academie,secteur,nb_candidats_g,taux_de_reussite_g,va_du_taux_de_reussite_g,nb_candidats_p,taux_de_reussite_p,note_a_l_ecrit_g,va_de_la_note_g,note_a_l_ecrit_p,taux_d_acces_6eme_3eme,part_presents_3eme_ordinaire_total,part_presents_3eme_ordinaire_g,part_presents_3eme_ordinaire_p,part_presents_3eme_segpa_total,nb_mentions_ab_g,nb_mentions_b_g,nb_mentions_tb_g,nb_mentions_global_g
         -importColumns=session,uai,nom_de_l_etablissement,commune,departement,academie,secteur,nb_candidats_g,taux_de_reussite_g,va_du_taux_de_reussite_g,nb_candidats_p,taux_de_reussite_p,note_a_l_ecrit_g,va_de_la_note_g,note_a_l_ecrit_p,taux_d_acces_6eme_3eme,part_presents_3eme_ordinaire_total,part_presents_3eme_ordinaire_g,part_presents_3eme_ordinaire_p,part_presents_3eme_segpa_total,nb_mentions_ab_g,nb_mentions_b_g,nb_mentions_tb_g,nb_mentions_global_g
         -keyColumns=session,uai;

drop table if exists _temp_fr_en_etablissements_ep cascade;
create table _temp_fr_en_etablissements_ep(
  uai                     char(8) primary key,
  ep_2022_2023            varchar(7),
  nom_etablissement       varchar(108),
  type_etablissement      varchar(39),
  statut_public_prive     varchar(18), 
  libelle_academie        varchar(16),
  libelle_departement     varchar(23),
  nom_commune             varchar(45),
  libelle_region          varchar(34),
  uai_tete_de_reseau      char(8),     
  qp_a_proximite_o_n      char(16),   
  qp_a_proximite          char(8),    
  nom_du_qp               varchar(85), 
  nombre_d_eleves         integer,   
  code_postal             char(5),  
  code_commune            char(5),
  code_departement        char(3),   
  code_academie           char(2),     
  code_region             char(2), 
  libelle_nature          varchar(39), 
  code_nature             char(3),     
  latitude                numeric,
  longitude               numeric
);

delete from _temp_fr_en_etablissements_ep;
WbImport -file=./fr-en-etablissements-ep.csv
         -header=true
         -delimiter=';'
         -quoteChar='"' 
         -table=_temp_fr_en_etablissements_ep
         -schema=colleges2
         -mode=insert, update
         -filecolumns=uai,ep_2022_2023,nom_etablissement,type_etablissement,statut_public_prive,libelle_academie,libelle_departement,nom_commune,libelle_region,uai_tete_de_reseau,qp_a_proximite_o_n,qp_a_proximite,nom_du_qp,nombre_d_eleves,code_postal,code_commune,code_departement,code_academie,code_region,libelle_nature,code_nature,$wb_skip$,latitude,longitude
         -importColumns=uai,ep_2022_2023,nom_etablissement,type_etablissement,statut_public_prive,libelle_academie,libelle_departement,nom_commune,libelle_region,uai_tete_de_reseau,qp_a_proximite_o_n,qp_a_proximite,nom_du_qp,nombre_d_eleves,code_postal,code_commune,code_departement,code_academie,code_region,libelle_nature,code_nature,latitude,longitude
         -keyColumns=uai;

update _temp_fr_en_etablissements_ep
set libelle_departement = upper(libelle_departement);

-- Problématique :
-- Parmi les données de notre fichier, certaines peuvent-elles permettre d'expliquer ce qui favorise la mention au brevet des généraux dans les différents collèges ?
-- variable endogène : nb_mentions_global_g
-- variable explicatives : nb_candidats_g, taux_de_reussite_g, note_a_l_ecrit_g, nb_mentions_b_g, departement, secteur (public ou privé)

drop view if exists stats_mentions_g;
create view stats_mentions_g as
  select distinct nb_mentions_global_g, nb_candidats_g, taux_de_reussite_g, note_a_l_ecrit_g, nb_mentions_b_g, secteur, code_departement
  from _temp_fr_en_indicateurs_valeur_ajoutee_colleges left outer join _temp_fr_en_etablissements_ep
  on _temp_fr_en_indicateurs_valeur_ajoutee_colleges.departement = _temp_fr_en_etablissements_ep.libelle_departement
  where nb_mentions_global_g is not null and secteur is not null and nb_candidats_g is not null and taux_de_reussite_g is not null and note_a_l_ecrit_g is not null and nb_mentions_b_g is not null and code_departement is not null and code_departement != '02A' and code_departement != '02B';

WbExport -file=stats_mentions_g.csv
         -outputDir=.
         -type=text
         -sourceTable=stats_mentions_g
         -schema=colleges2
         -delimiter=';'
         -header=true
         -keyColumns=nb_mentions_global_g,secteur,nb_candidats_g,taux_de_reussite_g,note_a_l_ecrit_g,nb_mentions_b_g,departement
         -dateFormat='d/M/y'
         -timestampFormat='d/M/y H:m:s'
         ;

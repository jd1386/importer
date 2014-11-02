require 'json'

data = [
  [
    {
      "pub_date"=> "– 30 nov 2014",
      "series"=> "Collana: Feltrinelli Kids",
      "author"=> "di Aaron Becker (Autore)",
      "isbn"=> "ISBN-13: 978-8807922435",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Feltrinelli (30 novembre 2014)",
      "page"=> "Copertina flessibile: 40 pagine",
      "title"=> "Viaggio",
      "category"=> "Libri > Libri per bambini e ragazzi > Letteratura e narrativa"
    }
  ],
  [
    {
      "pub_date"=> "– 13 nov 2014",
      "author"=> "di Jeff Kinney (Autore)",
      "isbn"=> "ISBN-13: 978-8880338949",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Il Castoro (13 novembre 2014)",
      "page"=> "Copertina rigida: 224 pagine",
      "title"=> "Diario di una schiappa. Sfortuna nera",
      "category"=> "Libri > Libri per bambini e ragazzi > Letteratura e narrativa"
    }
  ],
  [
    {
      "pub_date"=> "– 13 nov 2014",
      "series"=> "Collana: Le Gabbianelle",
      "author"=> "di Luis Sepúlveda (Autore)",
      "isbn"=> "ISBN-13: 978-8823511002",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Guanda (13 novembre 2014)",
      "page"=> "Copertina flessibile: 360 pagine",
      "title"=> "Trilogia dell'amicizia",
      "category"=> "Libri > Letteratura e narrativa > Narrativa contemporanea"
    }
  ],
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "series"=> "Collana: Panini Books",
      "isbn"=> "ISBN-13: 978-8891206633",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Panini Comics (12 novembre 2014)",
      "page"=> "Copertina rigida: 168 pagine",
      "title"=> "Harry Potter. La magia dei film. Ediz. deluxe",
      "category"=> "Libri > Libri per bambini e ragazzi > Fantascienza, Horror e Fantasy > Fantasy Libri > Libri per bambini e ragazzi > Giochi, giocattoli e attività ricreativa"
    }
  ],
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "series"=> "Collana: Collezione 100% Panini Comics",
      "author"=> "di Martin Olson (Autore)",
      "isbn"=> "ISBN-13: 978-8891207272",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Panini Comics (12 novembre 2014)",
      "page"=> "Copertina rigida: 160 pagine",
      "title"=> "Adventure time. Enciclopedia",
      "category"=> "Libri > Libri per bambini e ragazzi > Fumetti e manga Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "author"=> "di Raphael Baud (Autore), Aurélie Neyret (Autore)",
      "isbn"=> "ISBN-13: 978-8897870319",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Valentina Edizioni (12 novembre 2014)",
      "page"=> "Copertina rigida: 32 pagine",
      "title"=> "Le vacanze del signor Rino",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 30 nov 2014",
      "series"=> "Collana: Tascabili Giunti",
      "author"=> "di Jennifer Armentrout (Autore), S. Reggiani (Traduttore)",
      "isbn"=> "ISBN-13: 978-8809798069",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Giunti Editore (30 novembre 2014)",
      "page"=> "Copertina flessibile",
      "title"=> "Shadows",
      "category"=> "Libri > Fantascienza, Horror e Fantasy > Fantasy Libri > Libri per bambini e ragazzi > Fantascienza, Horror e Fantasy > Fantasy"
    }
  ],
  [
    {
      "pub_date"=> "– 30 nov 2014",
      "series"=> "Collana: Tascabili Giunti",
      "author"=> "di Jennifer Armentrout (Autore), S. Reggiani (Traduttore)",
      "isbn"=> "ISBN-13: 978-8809798052",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Giunti Editore (30 novembre 2014)",
      "page"=> "Copertina flessibile",
      "title"=> "Onyx",
      "category"=> "Libri > Fantascienza, Horror e Fantasy > Fantasy Libri > Libri per bambini e ragazzi > Fantascienza, Horror e Fantasy > Fantasy"
    }
  ],
  [
    {
      "pub_date"=> "– 30 nov 2014",
      "series"=> "Collana: Tascabili Giunti",
      "author"=> "di Jennifer Armentrout (Autore), S. Reggiani (Traduttore)",
      "isbn"=> "ISBN-13: 978-8809798045",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Giunti Editore (30 novembre 2014)",
      "page"=> "Copertina flessibile",
      "title"=> "Obsidian",
      "category"=> "Libri > Fantascienza, Horror e Fantasy > Fantasy Libri > Libri per bambini e ragazzi > Fantascienza, Horror e Fantasy > Fantasy"
    }
  ],
  [
    {
      "pub_date"=> "– 30 nov 2014",
      "series"=> "Collana: Y",
      "author"=> "di Jennifer Armentrout (Autore), S. Reggiani (Traduttore)",
      "isbn"=> "ISBN-13: 978-8809783546",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Giunti Editore (30 novembre 2014)",
      "page"=> "Copertina rigida: 368 pagine",
      "title"=> "Opal",
      "category"=> "Libri > Fantascienza, Horror e Fantasy > Fantasy Libri > Libri per bambini e ragazzi > Fantascienza, Horror e Fantasy > Fantasy"
    }
  ],
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "series"=> "Collana: Rizzoli best",
      "author"=> "di Lauren Kate (Autore)",
      "isbn"=> "ISBN-13: 978-8817077187",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Rizzoli (12 novembre 2014)",
      "page"=> "Copertina flessibile: 368 pagine",
      "title"=> "Waterfall",
      "category"=> "Libri > Fantascienza, Horror e Fantasy > Horror"
    }
  ],
  null,
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "author"=> "di Enrico Cerni (Autore), Francesca Gambino (Autore), M. Distefano (Illustratore) & 0 altro",
      "isbn"=> "ISBN-13: 978-8898346288",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Coccole Books (12 novembre 2014)",
      "page"=> "Copertina rigida: 108 pagine",
      "title"=> "La divina avventura",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "author"=> "di Antoine De Saint-Exupéry (Autore)",
      "isbn"=> "ISBN-13: 978-8845276187",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Bompiani (12 novembre 2014)",
      "page"=> "Copertina rigida",
      "title"=> "Tanti auguri. Microlibro"
    }
  ],
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "author"=> "di Antoine De Saint-Exupéry (Autore)",
      "isbn"=> "ISBN-13: 978-8845277849",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Bompiani (12 novembre 2014)",
      "page"=> "Copertina rigida",
      "title"=> "Saggezze di vita. Microlibro"
    }
  ],
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "author"=> "di Antoine De Saint-Exupéry (Autore)",
      "isbn"=> "ISBN-13: 978-8845276217",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Bompiani (12 novembre 2014)",
      "page"=> "Copertina rigida",
      "title"=> "Amicizia. Microlibro"
    }
  ],
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "author"=> "di Antoine De Saint-Exupéry (Autore)",
      "isbn"=> "ISBN-13: 978-8845277832",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Bompiani (12 novembre 2014)",
      "page"=> "Copertina rigida",
      "title"=> "Coraggio! Microlibro"
    }
  ],
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "author"=> "di Antoine De Saint-Exupéry (Autore)",
      "isbn"=> "ISBN-13: 978-8845276194",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Bompiani (12 novembre 2014)",
      "page"=> "Copertina rigida",
      "title"=> "Buona fortuna. Microlibro"
    }
  ],
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "author"=> "di Lewis Carroll (Autore), I. De Paoli (Illustratore)",
      "isbn"=> "ISBN-13: 978-8897926078",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Comicout (12 novembre 2014)",
      "page"=> "Copertina flessibile: 24 pagine",
      "title"=> "Alice nel paese delle meraviglie",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "series"=> "Collana: Nidi",
      "author"=> "di Piret Raud (Autore)",
      "isbn"=> "ISBN-13: 978-8876092862",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Sinnos (12 novembre 2014)",
      "page"=> "Copertina rigida: 40 pagine",
      "title"=> "Voglio tutto rosa",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "series"=> "Collana: Album",
      "author"=> "di Raymond Briggs (Autore)",
      "isbn"=> "ISBN-13: 978-8817077835",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Rizzoli (12 novembre 2014)",
      "page"=> "Copertina flessibile: 32 pagine",
      "title"=> "Babbo Natale va in vacanza",
      "category"=> "Libri > Libri per bambini e ragazzi"
    }
  ],
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "series"=> "Collana: Best BUR",
      "author"=> "di Maggie Stiefvater (Autore)",
      "isbn"=> "ISBN-13: 978-8817077811",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: BUR Biblioteca Univ. Rizzoli (12 novembre 2014)",
      "page"=> "Copertina flessibile",
      "title"=> "Raven boys",
      "category"=> "Libri > Fantascienza, Horror e Fantasy > Horror Libri > Gialli e Thriller Libri > Libri per bambini e ragazzi > Fantascienza, Horror e Fantasy > Horror"
    }
  ],
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "author"=> "di Anne Fine (Autore)",
      "isbn"=> "ISBN-13: 978-8871067568",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Sonda (12 novembre 2014)",
      "page"=> "Copertina flessibile: 96 pagine",
      "title"=> "Molla quel libro, gatto killer!",
      "category"=> "Libri > Libri per bambini e ragazzi > Letteratura e narrativa"
    }
  ],
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "author"=> "di Laura Grassi Guida (Autore)",
      "isbn"=> "ISBN-13: 978-8897870395",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Valentina Edizioni (12 novembre 2014)",
      "page"=> "Copertina flessibile: 40 pagine",
      "title"=> "Bauhamas. La storia di Miles",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 12 nov 2014",
      "author"=> "di Guido Conti (Autore)",
      "isbn"=> "ISBN-13: 978-8817078672",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Rizzoli (12 novembre 2014)",
      "page"=> "Copertina rigida",
      "title"=> "Il volo felice delle cicogna nullou"
    }
  ],
  [
    {
      "pub_date"=> "– 5 nov 2014",
      "author"=> "di Rodman Philbrick (Autore)",
      "isbn"=> "ISBN-13: 978-8817076432",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: BUR Biblioteca Univ. Rizzoli (5 novembre 2014)",
      "page"=> "Copertina flessibile",
      "title"=> "Basta guardare il cielo",
      "category"=> "Libri > Letteratura e narrativa > Narrativa contemporanea"
    }
  ],
  [
    {
      "pub_date"=> "– 5 nov 2014",
      "isbn"=> "ISBN-13: 978-8858012383",
      "format"=> "Cartonato",
      "publisher"=> "Editore: Gribaudo (5 novembre 2014)",
      "page"=> "Cartonato: 12 pagine",
      "title"=> "I cuccioli. Libri da toccare",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  [
    {
      "pub_date"=> "– 5 nov 2014",
      "isbn"=> "ISBN-13: 978-8858012406",
      "format"=> "Cartonato",
      "publisher"=> "Editore: Gribaudo (5 novembre 2014)",
      "page"=> "Cartonato: 12 pagine",
      "title"=> "La nanna. Libri da toccare",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  [
    {
      "pub_date"=> "– 5 nov 2014",
      "isbn"=> "ISBN-13: 978-8858012376",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Gribaudo (5 novembre 2014)",
      "page"=> "Copertina rigida: 12 pagine",
      "title"=> "La fattoria. Libri da toccare",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  [
    {
      "pub_date"=> "– 5 nov 2014",
      "isbn"=> "ISBN-13: 978-8858012390",
      "format"=> "Cartonato",
      "publisher"=> "Editore: Gribaudo (5 novembre 2014)",
      "page"=> "Cartonato: 12 pagine",
      "title"=> "Il coniglietto. Libri da toccare",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  [
    {
      "pub_date"=> "– 5 nov 2014",
      "series"=> "Collana: Giochi creativi",
      "author"=> "di Daniel Lipkowitz (Autore)",
      "isbn"=> "ISBN-13: 978-8858012666",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Gribaudo (5 novembre 2014)",
      "page"=> "Copertina rigida: 200 pagine",
      "title"=> "Lego. Infinite idee per giocare",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  [
    {
      "pub_date"=> "– 5 nov 2014",
      "series"=> "Collana: Giochi creativi",
      "author"=> "di Catherine Saunders (Autore)",
      "isbn"=> "ISBN-13: 978-8858012642",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Gribaudo (5 novembre 2014)",
      "page"=> "Copertina rigida: 176 pagine",
      "title"=> "La guida completa con tutti i personaggi. Lego friends. Con gadget",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  [
    {
      "pub_date"=> "– 5 nov 2014",
      "isbn"=> "ISBN-13: 978-8858012659",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Gribaudo (5 novembre 2014)",
      "page"=> "Copertina flessibile: 96 pagine",
      "title"=> "Lego city. Gioca e disegna. Disegna e crea. Con adesivi",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  [
    {
      "pub_date"=> "– 5 nov 2014",
      "series"=> "Collana: Feltrinelli Kids",
      "author"=> "di Chiara Frugoni (Autore), Felice Feltracco (Autore)",
      "isbn"=> "ISBN-13: 978-8807922428",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Feltrinelli (5 novembre 2014)",
      "page"=> "Copertina flessibile: 32 pagine",
      "title"=> "San Francesco e la notte di Natale",
      "category"=> "Libri > Libri per bambini e ragazzi > Religione"
    }
  ],
  null,
  [
    {
      "pub_date"=> "– 5 nov 2014",
      "series"=> "Collana: Classici illustrati",
      "author"=> "di Frances H. Burnett (Autore)",
      "isbn"=> "ISBN-13: 978-8817077750",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Rizzoli (5 novembre 2014)",
      "page"=> "Copertina flessibile",
      "title"=> "Il giardino segreto",
      "category"=> "Libri > Libri per bambini e ragazzi > Letteratura e narrativa > Classici"
    }
  ],
  [
    {
      "pub_date"=> "– 5 nov 2014",
      "series"=> "Collana: Classici illustrati",
      "author"=> "di Mary M. Dodge (Autore)",
      "isbn"=> "ISBN-13: 978-8817077743",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Rizzoli (5 novembre 2014)",
      "page"=> "Copertina flessibile",
      "title"=> "Pattini d'argento",
      "category"=> "Libri > Libri per bambini e ragazzi > Letteratura e narrativa > Classici"
    }
  ],
  [
    {
      "pub_date"=> "– 5 nov 2014",
      "series"=> "Collana: Classici illustrati",
      "author"=> "di L. Frank Baum (Autore)",
      "isbn"=> "ISBN-13: 978-8817077774",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Rizzoli (5 novembre 2014)",
      "page"=> "Copertina flessibile",
      "title"=> "Il mago di Oz",
      "category"=> "Libri > Libri per bambini e ragazzi > Letteratura e narrativa > Classici"
    }
  ],
  [
    {
      "pub_date"=> "– 5 nov 2014",
      "series"=> "Collana: Classici illustrati",
      "author"=> "di James M. Barrie (Autore)",
      "isbn"=> "ISBN-13: 978-8817077767",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Rizzoli (5 novembre 2014)",
      "page"=> "Copertina flessibile",
      "title"=> "Peter Pan",
      "category"=> "Libri > Libri per bambini e ragazzi > Letteratura e narrativa > Classici"
    }
  ],
  [
    {
      "pub_date"=> "– 5 nov 2014",
      "series"=> "Collana: Storie della fattoria",
      "author"=> "di Heather Amery (Autore), Stephen Cartwright (Autore), G. Guarnieri (Traduttore), E. Ranzoni (Traduttore) & 1 altro",
      "isbn"=> "ISBN-13: 978-1409571612",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Usborne Publishing (5 novembre 2014)",
      "page"=> "Copertina rigida: 328 pagine",
      "title"=> "Il grande libro delle Storie della fattoria",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 5 nov 2014",
      "series"=> "Collana: I lapislazzuli",
      "author"=> "di Emilio Urberuaga (Autore)",
      "isbn"=> "ISBN-13: 978-8878743717",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Lapis (5 novembre 2014)",
      "page"=> "Copertina rigida: 32 pagine",
      "title"=> "Animali e animali",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "author"=> "di Aa.Vv (Autore)",
      "isbn"=> "ISBN-13: 978-8868371050",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Crealibri (30 ottobre 2014)",
      "page"=> "Copertina rigida: 52 pagine",
      "title"=> "Io sono Max Steel!",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "series"=> "Collana: Scopri chi è",
      "author"=> "di Cristina Mesturini (Autore), Giovanna Mantegazza (Autore)",
      "isbn"=> "ISBN-13: 978-8875489557",
      "format"=> "Cartonato",
      "publisher"=> "Editore: La Coccinella (30 ottobre 2014)",
      "page"=> "Cartonato: 12 pagine",
      "title"=> "Scopri chi è il cane",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri interattivi Libri > Libri per bambini e ragazzi > Primo apprendimento Libri > Libri per bambini e ragazzi > Scienze, natura e tecnologia"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "series"=> "Collana: Scopri chi è",
      "author"=> "di Cristina Mesturini (Autore), Giovanna Mantegazza (Autore)",
      "isbn"=> "ISBN-13: 978-8875489564",
      "format"=> "Cartonato",
      "publisher"=> "Editore: La Coccinella (30 ottobre 2014)",
      "page"=> "Cartonato: 12 pagine",
      "title"=> "Scopri chi è il gatto",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri interattivi Libri > Libri per bambini e ragazzi > Primo apprendimento Libri > Libri per bambini e ragazzi > Scienze, natura e tecnologia"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "series"=> "Collana: Come? Dove? Perché?",
      "author"=> "di Angela Weinhold (Autore)",
      "isbn"=> "ISBN-13: 978-8868900281",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: La Coccinella (30 ottobre 2014)",
      "page"=> "Copertina rigida: 24 pagine",
      "title"=> "Tutti i bambini del mondo",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "series"=> "Collana: Libro giocattolo",
      "author"=> "di Elena Gornati (Autore)",
      "isbn"=> "ISBN-13: 978-8868900342",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: La Coccinella (30 ottobre 2014)",
      "page"=> "Copertina flessibile: 20 pagine",
      "title"=> "La casetta delle bambole. Con adesivi",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "series"=> "Collana: Libri illustrati",
      "author"=> "di Yoko Maryuama (Autore), M. Barigazzi (Traduttore)",
      "isbn"=> "ISBN-13: 978-8865263679",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Nord-Sud (30 ottobre 2014)",
      "page"=> "Copertina rigida: 32 pagine",
      "title"=> "La casa nel bosco",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "author"=> "di Beatrice Masini (Autore), Annalisa Beghelli (Autore)",
      "isbn"=> "ISBN-13: 978-8895443911",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Carthusia (30 ottobre 2014)",
      "page"=> "Copertina rigida: 28 pagine",
      "title"=> "Insieme più speciali",
      "category"=> "Libri > Libri per bambini e ragazzi > Letteratura e narrativa"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "author"=> "di Amy Hest (Autore), Helen Oxenbury (Autore), P. Gallerani (Traduttore) & 0 altro",
      "isbn"=> "ISBN-13: 978-8897737513",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Officina Libraria (30 ottobre 2014)",
      "page"=> "Copertina rigida: 32 pagine",
      "title"=> "Io e Charlie",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "series"=> "Collana: Albi illustrati",
      "author"=> "di Chiara Nocentini (Autore), Franca Trabacchi (Autore)",
      "isbn"=> "ISBN-13: 978-8861887916",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Ape Junior (30 ottobre 2014)",
      "page"=> "Copertina rigida: 357 pagine",
      "title"=> "Il grande libro delle fiabe",
      "category"=> "Libri > Libri per bambini e ragazzi > Letteratura e narrativa > Classici Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "series"=> "Collana: Albi illustrati",
      "author"=> "di Lodovica Cima (Autore), Sara Benecino (Autore)",
      "isbn"=> "ISBN-13: 978-8861887930",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Ape Junior (30 ottobre 2014)",
      "page"=> "Copertina rigida: 155 pagine",
      "title"=> "Storie della buonanotte",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 27 ott 2014",
      "isbn"=> "ISBN-13: 978-8898128648",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Chiara Edizioni (27 ottobre 2014)",
      "language"=> "Lingua: Italiano",
      "page"=> "Copertina flessibile: 24 pagine",
      "title"=> "La mia valigetta da colorare. Con adesivi",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  [
    {
      "pub_date"=> "– 27 ott 2014",
      "isbn"=> "ISBN-13: 978-8898128655",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Chiara Edizioni (27 ottobre 2014)",
      "language"=> "Lingua: Italiano",
      "page"=> "Copertina flessibile: 24 pagine",
      "title"=> "La mia borsetta da colorare. Con adesivi",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  null,
  [
    {
      "pub_date"=> "– 27 ott 2014",
      "isbn"=> "ISBN-13: 978-8898128679",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Chiara Edizioni (27 ottobre 2014)",
      "language"=> "Lingua: Italiano",
      "page"=> "Copertina flessibile: 24 pagine",
      "title"=> "La mia valigetta da colorare. Con adesivi",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "series"=> "Collana: Alta definizione",
      "author"=> "di Gianluca Barbera (Autore)",
      "isbn"=> "ISBN-13: 978-8861457669",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Gallucci (30 ottobre 2014)",
      "page"=> "Copertina flessibile: 170 pagine",
      "title"=> "Finis mundi",
      "category"=> "Libri > Letteratura e narrativa > Narrativa contemporanea"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "series"=> "Collana: Bambini",
      "author"=> "di Agnès de Lestrade (Autore), Valeria Docampo (Autore), R. Dalla Rosa (Traduttore) & 0 altro",
      "isbn"=> "ISBN-13: 978-8861893115",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Terre di Mezzo (30 ottobre 2014)",
      "page"=> "Copertina rigida: 40 pagine",
      "title"=> "Domani inventerò",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "author"=> "di Guido Van Genechten (Autore), Giovanna Mantegazza (Autore)",
      "isbn"=> "ISBN-13: 978-8868900823",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: La Coccinella (30 ottobre 2014)",
      "page"=> "Copertina rigida: 40 pagine",
      "title"=> "Chi sono io?",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  null,
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "isbn"=> "ISBN-13: 978-9462446779",
      "format"=> "Cartonato",
      "publisher"=> "Editore: Yoyo Books (30 ottobre 2014)",
      "page"=> "Cartonato: 14 pagine",
      "title"=> "La natura. Che suono è? Libro sonoro",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "isbn"=> "ISBN-13: 978-9462446786",
      "format"=> "Cartonato",
      "publisher"=> "Editore: Yoyo Books (30 ottobre 2014)",
      "page"=> "Cartonato: 14 pagine",
      "title"=> "Musica! Che suono è? Libro sonoro",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "isbn"=> "ISBN-13: 978-9462446793",
      "format"=> "Cartonato",
      "publisher"=> "Editore: Yoyo Books (30 ottobre 2014)",
      "page"=> "Cartonato: 14 pagine",
      "title"=> "Buonanotte! Che suono è? Libro sonoro",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "isbn"=> "ISBN-13: 978-9462446809",
      "format"=> "Cartonato",
      "publisher"=> "Editore: Yoyo Books (30 ottobre 2014)",
      "page"=> "Cartonato: 14 pagine",
      "title"=> "In campagna. Che suono è? Libro sonoro",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati Libri > Libri per bambini e ragazzi > Libri interattivi"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "isbn"=> "ISBN-13: 978-8852219054",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Walt Disney Company Italia (30 ottobre 2014)",
      "page"=> "Copertina flessibile: 48 pagine",
      "title"=> "Aladdin. Sogni d'oro",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "isbn"=> "ISBN-13: 978-8852219061",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Walt Disney Company Italia (30 ottobre 2014)",
      "page"=> "Copertina flessibile: 48 pagine",
      "title"=> "Robin Hood. Sogni d'oro",
      "category"=> "Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "isbn"=> "ISBN-13: 978-8852219221",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Walt Disney Company Italia (30 ottobre 2014)",
      "page"=> "Copertina flessibile: 57 pagine",
      "title"=> "Crea la moda. Real life",
      "category"=> "Libri > Libri per bambini e ragazzi > Hobby e tempo libero"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "series"=> "Collana: Disney Golden Edition",
      "isbn"=> "ISBN-13: 978-8852219245",
      "format"=> "Copertina flessibile",
      "publisher"=> "Editore: Walt Disney Company Italia (30 ottobre 2014)",
      "page"=> "Copertina flessibile: 328 pagine",
      "title"=> "La saga della spada di ghiaccio",
      "category"=> "Libri > Libri per bambini e ragazzi > Fumetti e manga Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "series"=> "Collana: I fumetti di Disney club",
      "isbn"=> "ISBN-13: 978-8852219092",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Walt Disney Company Italia (30 ottobre 2014)",
      "page"=> "Copertina rigida: 368 pagine",
      "title"=> "Le più belle storie mostruose",
      "category"=> "Libri > Libri per bambini e ragazzi > Fumetti e manga Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "series"=> "Collana: I fumetti di Disney club",
      "isbn"=> "ISBN-13: 978-8852219108",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Walt Disney Company Italia (30 ottobre 2014)",
      "page"=> "Copertina rigida: 368 pagine",
      "title"=> "Le più belle storie festose",
      "category"=> "Libri > Libri per bambini e ragazzi > Fumetti e manga Libri > Libri per bambini e ragazzi > Libri illustrati"
    }
  ],
  [
    {
      "pub_date"=> "– 30 ott 2014",
      "series"=> "Collana: Nuova narrativa Newton",
      "author"=> "di Adam J. Epstein (Autore), Andrew Jacobson (Autore), D. Phillips (Illustratore), B. Francese (Traduttore) & 1 altro",
      "isbn"=> "ISBN-13: 978-8854171367",
      "format"=> "Copertina rigida",
      "publisher"=> "Editore: Newton Compton (30 ottobre 2014)",
      "page"=> "Copertina rigida: 251 pagine",
      "title"=> "Il palazzo dei sogni. The Familiars",
      "category"=> "Libri > Libri per bambini e ragazzi > Fantascienza, Horror e Fantasy > Fantasy"
    }
  ]
]

puts data.size
puts data[0][0].nil?
puts data[79][0].nil?
i = 0
data_cleaned = []

until i == data.size
  if data[i] == "null"
    data_cleaned << 'emptyyy'
  else
    data_cleaned << data[i][0]['title']
  end
  i += 1
end

puts data_cleaned
"""Tests automatises de velos-api.

Ces tests tournent SANS base de donnees : ils utilisent le jeu de secours
en memoire (DATABASE_URL non definie), ce qui les rend rapides et
independants de tout service externe.
"""

from app import app


def test_sante_repond_ok():
    """La route /sante doit repondre 200 avec un statut ok."""
    with app.test_client() as client:
        reponse = client.get("/sante")
        assert reponse.status_code == 200
        assert reponse.get_json()["statut"] == "ok"


def test_alertes_filtre_les_stations_en_dessous_du_seuil():
    """La route /alertes ne doit renvoyer que les stations
    avec 2 velos disponibles ou moins (jeu de secours en memoire).
    """
    with app.test_client() as client:
        reponse = client.get("/alertes")
        assert reponse.status_code == 200
        donnees = reponse.get_json()
        assert donnees["source"] == "memoire"
        for station in donnees["stations"]:
            assert station["velos_disponibles"] <= 2


def test_stations_renvoie_le_bon_nombre_de_stations():
    """Le jeu de secours contient exactement 4 stations."""
    with app.test_client() as client:
        reponse = client.get("/stations")
        assert reponse.status_code == 200
        donnees = reponse.get_json()
        assert donnees["source"] == "memoire"
        assert len(donnees["stations"]) == 999

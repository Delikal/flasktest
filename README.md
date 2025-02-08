Níže je krátké bodové zadání:
	•	Vytvoř Dockerfile:
	•	Vycházej z image python:3.10-slim.
	•	Nastav pracovní adresář na /app.
	•	Definuj environment variable:
ENV MESSAGE="Hello World from Flask"
	•	Nainstaluj Flask přes pip.
	•	Zkopíruj obsah složky app/ do /app.
	•	Exponuj port 8000.
	•	Spusť Flask server (na hostu 0.0.0.0 a portu 8000).
	•	Vytvoř složku app a v ní soubor app.py:
	•	V app.py vytvoř jednoduchou Flask aplikaci, která na kořenové URL (/) vrací hodnotu proměnné MESSAGE.
	•	Při spuštění kontejneru:
	•	Namountuj lokální složku app do /app v kontejneru.
	•	Pojmenuj kontejner dencapod (např. pomocí volby --name dencapod v příkazu docker run).

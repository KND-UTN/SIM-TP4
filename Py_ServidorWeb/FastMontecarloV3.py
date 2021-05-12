import json
import datetime
import pandas as pd
import numpy as np
from numba import jit, prange


@jit(nopython=True)
def procesarMontecarlo(inicial: int, q: int, r: int, ko: float, km: float, ks: float, desde: int, hasta: int, n: int):
    # Iniciamos la fila anterior (estado inicial)
    antReloj = 0
    antLlegada = 0
    antStock = inicial
    antCTAC = .0

    relojes = []
    demandasrnd = []
    demandas = []
    demorasrnd = []
    demoras = []
    pedidos = []
    llegadas = []
    disponibles = []
    stocks = []
    kos = []
    kms = []
    kss = []
    cts = []
    ctsac = []

    # Loop de procesamiento de cada fila individual
    for a in prange(n):
        # TODO: Checkear si con PRANGE(n) multinucleo funciona bien
        reloj = antReloj + 1
        rndDemanda = np.random.random_sample()
        if 0 <= rndDemanda < 0.06:
            demanda = 3
        elif 0.06 <= rndDemanda < 0.19:
            demanda = 4
        elif 0.19 <= rndDemanda < 0.40:
            demanda = 5
        elif 0.40 <= rndDemanda < 0.67:
            demanda = 6
        else:
            demanda = 7

        # Verificamos si ha llegado el pedido
        if antLlegada == reloj:
            disponible = q
        else:
            disponible = 0

        # Calculamos el stock actual
        if antStock + disponible - demanda >= 0:
            stock = antStock + disponible - demanda
        else:
            stock = 0

        # Checkeamos si hay que hacer un nuevo pedido y si asi es el caso, calculamos la demora
        if stock <= r and (antLlegada == 0 or antLlegada == reloj):
            pedido = True
            rndDemora = np.random.random_sample()
            if 0 <= rndDemora < 0.43:
                demora = 1
            elif 0.43 <= rndDemora < 0.75:
                demora = 2
            else:
                demora = 3
        else:
            pedido = False
            rndDemora = 0
            demora = 0

        # Calculamos la llegada del pedido y el costo de orden
        if pedido == True:
            costoOrden = ko
            llegada = reloj + demora
        else:
            costoOrden = 0
            if antLlegada == reloj:
                llegada = 0
            else:
                llegada = antLlegada

        # Calculamos costos
        costoMantenimiento = stock * km
        if antStock + disponible < demanda:
            costoStockOut = (demanda - antStock - disponible) * ks
        else:
            costoStockOut = 0
        costoTotal = costoOrden + costoMantenimiento + costoStockOut
        costoAcumulado = antCTAC + costoTotal

        # Checkeamos si hay que mostrar la fila
        if (desde <= reloj <= hasta) or reloj == n:
            relojes.append(reloj)
            demandasrnd.append(rndDemanda)
            demandas.append(demanda)
            demorasrnd.append(rndDemora)
            demoras.append(demora)
            pedidos.append(pedido)
            llegadas.append(llegada)
            disponibles.append(disponible)
            stocks.append(stock)
            kos.append(costoOrden)
            kms.append(costoMantenimiento)
            kss.append(costoStockOut)
            cts.append(costoTotal)
            ctsac.append(costoAcumulado)

        # Intercambiamos las filas para la siguiente iteracion
        antReloj = reloj
        antLlegada = llegada
        antStock = stock
        antCTAC = costoAcumulado

    return relojes, demandasrnd, demandas, demorasrnd, demoras, pedidos, llegadas, disponibles, stocks, kos, kms, kss, cts, ctsac


def resultado_Json(relojes: [], demandasrnd: [], demandas: [], demorasrnd: [], demoras: [], pedidos: [], llegadas: [],
                   disponibles: [], stocks: [], kos: [], kms: [], kss: [], cts: [], ctsac: []):
    debugging = False
    matriz = np.array(
        [relojes, demandasrnd, demandas, demorasrnd, demoras, pedidos, llegadas, disponibles, stocks, kos, kms, kss,
         cts, ctsac])
    transversa = np.transpose(matriz)
    df = pd.DataFrame(transversa,
                      columns=["Reloj", "RND Demanda", "Demanda", "RND Demora", "Demora", "Pedido", "Llegada",
                               "Disponible", "Stock", "Ko", "Km", "Ks", "Costo Total", "Costo AC"])
    df[['Reloj', 'Demanda', 'Demora', 'Llegada', 'Disponible', 'Stock']] = df[
        ['Reloj', 'Demanda', 'Demora', 'Llegada', 'Disponible', 'Stock']].astype(int)
    df[['Pedido']] = df[
        ['Pedido']].astype(bool)

    retornar = json.loads(df.to_json(orient='table'))['data']

    if debugging:
        jsonResultante = json.dumps(json.loads(df.to_json(orient='table'))['data'], indent=4)
        with open('Resultado.json', 'w') as salida:
            json.dump(json.loads(df.to_json(orient='table'))['data'], salida)
        jsonGenerado = pd.read_json(jsonResultante)
        jsonGenerado.to_excel('Resultado.xlsx')
        print(jsonResultante)

    return retornar


def procesar(inicial: int, q: int, r: int, ko: float, km: float, ks: float, desde: int, hasta: int, n: int):
    relojes, demandasrnd, demandas, demorasrnd, demoras, pedidos, llegadas, disponibles, stocks, kos, kms, kss, cts, ctsac = procesarMontecarlo(
        inicial, q, r, ko, km, ks, desde, hasta, n)
    return resultado_Json(relojes, demandasrnd, demandas, demorasrnd, demoras, pedidos, llegadas, disponibles, stocks,
                          kos, kms, kss, cts, ctsac)


if __name__ == "__main__":
    antes = datetime.datetime.now()
    relojes, demandasrnd, demandas, demorasrnd, demoras, pedidos, llegadas, disponibles, stocks, kos, kms, kss, cts, ctsac = procesarMontecarlo(
        15, 15, 10, 50, 5, 8, 5000, 5100, 200000)
    resultado_Json(relojes, demandasrnd, demandas, demorasrnd, demoras, pedidos, llegadas, disponibles, stocks, kos,
                   kms, kss, cts, ctsac)
    despues = datetime.datetime.now()
    print('Tiempo de ejecución: ' + str(despues - antes))

import datetime

import numpy
import json
import pandas


def procesarMontecarlo(inicial: int, q: int, r: int, ko: float, km: float, ks: float, desde: int, hasta: int, n: int):
    """
    Se encarga de procesar todas las fila elegidas y devolver un Json con el resultado de la simulación de Montecarlo.
    Ejemplo:
        Si se tomó
            desde = 20.000
            hasta = 25.000
            n = 100.000
        Entonces se van a calcular 100.000 filas, pero solo se van a retornar las filas 20.000 a 25.000, y también
        la fila 100.000 (la última)

    Args:
        inicial: Stock inicial
        q: Tamaño del lote
        r: Punto de reposición
        ko: Costo de pedido.
        km: Costo de mantinimiento.
        ks: Costo de stock out.
        desde: Desde que fila mostrar los datos
            (a partir de esta fila se comenzará a acumular en la lista a retornar como JSON).
        hasta: Hasta que fila mostrar los datos
            (hasta esta fila se comenzará a acumular en la lista a retornar como JSON).
        n: Punto final de la simulacion (tambien simboliza a la ultima fila)

    Returns:
        JSON: Un Json con todas las filas que se eligieron mostrar.
    """
    # Si la variable es True, la ejecucion va a tirar como resultado algunos valores por pantalla y archivos utiles
    debugging = True

    # En la siguiente variable se van a guardar las filas que hay que mostrar
    filasMostrar = []

    # Iniciamos los diccionarios de probabilidades de demanda y demora
    probabilidadDemanda = {
        7: .67,
        6: .4,
        5: .19,
        4: .06,
        3: 0
    }
    probabilidadDemora = {
        3: .75,
        2: .43,
        1: 0
    }

    # Iniciamos la fila anterior (estado inicial)
    filaAnterior = {
        'Reloj': 0,
        'RND Demanda': .0,
        'Demanda': 0,
        'RND Demora': .0,
        'Demora': None,
        'Pedido': False,
        'Llegada': None,
        'Disponible': 0,
        'Stock': inicial,
        'Ko': 0.0,
        'Km': 0.0,
        'Ks': 0.0,
        'Costo Total': .0,
        'Costo AC': .0
    }

    # Loop de procesamiento de cada fila individual
    for a in range(n):
        # TODO: Checkear si con PRANGE(n) multinucleo funciona bien
        reloj = filaAnterior["Reloj"] + 1
        rndDemanda = numpy.random.random_sample()
        demanda = lookup(rndDemanda, probabilidadDemanda)

        # Verificamos si ha llegado el pedido
        if filaAnterior['Llegada'] == reloj:
            disponible = q
        else:
            disponible = 0

        # Calculamos el stock actual
        if filaAnterior["Stock"] + disponible - demanda >= 0:
            stock = filaAnterior["Stock"] + disponible - demanda
        else:
            stock = 0

        # Checkeamos si hay que hacer un nuevo pedido y si asi es el caso, calculamos la demora
        if stock <= r and (filaAnterior["Llegada"] is None or filaAnterior["Llegada"] == reloj):
            pedido = True
            rndDemora = numpy.random.random_sample()
            demora = lookup(rndDemora, probabilidadDemora)
        else:
            pedido = False
            rndDemora = None
            demora = None

        # Calculamos la llegada del pedido y el costo de orden
        if pedido == True:
            costoOrden = ko
            llegada = reloj + demora
        else:
            costoOrden = 0
            if filaAnterior["Llegada"] == reloj:
                llegada = None
            else:
                llegada = filaAnterior["Llegada"]

        # Calculamos costos
        costoMantenimiento = stock * km
        if filaAnterior["Stock"] + disponible < demanda:
            costoStockOut = (demanda - filaAnterior["Stock"] - disponible) * ks
        else:
            costoStockOut = 0
        costoTotal = costoOrden + costoMantenimiento + costoStockOut
        costoAcumulado = filaAnterior["Costo AC"] + costoTotal

        # Ya tenemos todas las variables de la fila actual calculadas. Generamos el diccionario
        filaActual = {
            'Reloj': reloj,
            'RND Demanda': rndDemanda,
            'Demanda': demanda,
            'RND Demora': rndDemora,
            'Demora': demora,
            'Pedido': pedido,
            'Llegada': llegada,
            'Disponible': disponible,
            'Stock': stock,
            'Ko': costoOrden,
            'Km': costoMantenimiento,
            'Ks': costoStockOut,
            'Costo Total': costoTotal,
            'Costo AC': costoAcumulado
        }

        # Checkeamos si hay que mostrar la fila
        if (desde <= reloj <= hasta) or reloj == n:
            filasMostrar.append(filaActual)

        # Intercambiamos las filas para la siguiente iteracion
        filaAnterior = filaActual

    resultJson = json.dumps(filasMostrar, indent=4)

    if debugging:
        with open('Resultado.json', 'w') as salida:
            json.dump(filasMostrar, salida)
        jsonGenerado = pandas.read_json(resultJson)
        jsonGenerado.to_excel('Resultado.xlsx')
        print(resultJson)
        parametrosEntrada = {
            'Stock inicial': inicial,
            'Tamano del lote': q,
            'Punto de reposicion': r,
            'Costo de ordenamiento': ko,
            'Costo de mantenimiento': km,
            'Costo de stockOut': ks,
            'Desde': desde,
            'Hasta': hasta,
            'Filas a procesar': n
        }
        print(json.dumps(parametrosEntrada, indent=4))

    # Retornamos el Json
    return resultJson


def lookup(rnd, probabilidades):
    """Basado en un numero random que ingresa como parametro, devuelve la demora que le corresponde"""
    for demora in probabilidades:
        if rnd >= probabilidades[demora]:
            # Probabilidades[demora] es la probabilidad que tiene de ocurrencia una demora determinada
            # Por ejemplo, la demora 5 tiene una probabilidad acumulada de ocurrencia de 0.4
            return demora


if __name__ == "__main__":
    antes = datetime.datetime.now()
    result = procesarMontecarlo(15, 15, 6, 50, 5, 8, 5000, 5050, 5100)
    despues = datetime.datetime.now()
    print('Tiempo de ejecución: ' + str(despues - antes))

import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression as lr
import numpy.linalg as la
from sklearn.metrics import r2_score

CollegesDF=pd.read_csv("stats_mentions_g_up.csv")

CollegesDF = CollegesDF.dropna()
CollegesAr = CollegesDF.to_numpy()

def CentreReduire(T):
    T = np.array(T,dtype = np.float64)
    (n,p) = T.shape
    res = np.zeros((n,p))
    TMoy = np.mean(T,axis = 0)
    TEcart = np.std(T,axis = 0)
    for j in range(p):
        res[:,j] = (T[:,j] - TMoy[j]) / TEcart[j]
    return res

CollegesAR0=CollegesAr
CollegesAR0_CR=CentreReduire(CollegesAR0)
df = pd.DataFrame(data=CollegesAR0_CR)

def Abscisses(Colonne):
    Colonne = Colonne.tolist()
    l = []
    for v in Colonne:
        if v not in l:
            l.append(v)
    return l

def Effectifs(Colonne):
    Colonne = Colonne.tolist()
    d = {}
    l = []
    for v in Colonne:
        if v in d:
            d[v] += 1
        else:
            d[v] = 1
    for cle in d:
        l.append(d[cle])
    return l

def DiagBatons(Colonne):
    plt.figure(figsize=(10, 6))
    compte_axis = Abscisses(Colonne)
    compte = Effectifs(Colonne)
    plt.xlabel('Valeurs')
    plt.ylabel('Fréquence')
    plt.title("Diagramme en bâtons des moyennes des notes à l'écrit")
    plt.bar(compte_axis,compte)
    plt.show()
DiagBatons(CollegesAr[:,4])
    
#CollegeCo2 = np.corrcoef(CollegesAR0_CR[:,0],CollegesAR0_CR[:,1])  # nb_candidat_g
CollegeCo5 = np.corrcoef(CollegesAR0_CR[:,0],CollegesAR0_CR[:,2])   # pourcent_mention_par_candidat_g
CollegeCo4 = np.corrcoef(CollegesAR0_CR[:,0],CollegesAR0_CR[:,3])   # taux_reussite_g
CollegeCo5 = np.corrcoef(CollegesAR0_CR[:,0],CollegesAR0_CR[:,4])   # note_a_l_ecrit_g
#CollegeCo1 = np.corrcoef(CollegesAR0_CR[:,0],CollegesAR0_CR[:,5])  # nb_mentions_b_g
CollegeCo5 = np.corrcoef(CollegesAR0_CR[:,0],CollegesAR0_CR[:,6])   # pourcent_mentions_b_g
CollegeCo3 = np.corrcoef(CollegesAR0_CR[:,0],CollegesAR0_CR[:,7])   # secteur
CollegeCo5 = np.corrcoef(CollegesAR0_CR[:,0],CollegesAR0_CR[:,8])   # code_departement

ar_endogene =  CollegesAr[:, [0]]
ar_explicative = CollegesAR0_CR[:, [2,3,4,6,7,8]]

linear_regression = lr()
linear_regression.fit(ar_explicative,ar_endogene)
a = linear_regression.coef_

print("On obtient la matrice suivante : ")
print(np.cov(CollegesAR0_CR,rowvar=False))

print("On obtient les paramétres :\na0 = ",a[:,0]," \na1 = ",a[:,1]," \na2 = ",a[:,2]," \na3 = ",a[:,3]," \na4 = ",a[:,4]," \na5 = ",a[:,5]) 

a0=a[:,0]
a1=a[:,1]
a2=a[:,2]
a3=a[:,3]
a4 = a[:,4]
a5 =a[:,5]

r2 = linear_regression.score(ar_explicative,ar_endogene)
print("coefficient de corrélation multiple :\n ",r2)
import numpy as np
from math import floor
from random import uniform
from random import randint
import networkx as nx

#exercice 1
def graph_rand_edges(p,q,nb_nodes=400,nb_clusters=4):

    # p,  proba of linking 2 nodes in the same cluster
    #  q,  proba of linking 2 nodes in different clusters
    # nb_nodes,  number of nodes 
    # nb_clusters,  number of clusters
    
    # Define clusters
    true_comm = []
    for j in range(nb_clusters):
        true_comm +=[j for i in range(int(np.floor(nb_nodes/nb_clusters)))]
      
    # Create random edges
    # with probability p if nodes in the same community
    # with probabitliy q otherwise
    edges = []
    for node_1 in range(nb_nodes):
        for node_2 in range(node_1+1,nb_nodes):
            r = uniform(0.0,1.0) #random value, uniform between 0 and 1
            
            # If nodes are in the same cluster link them with probability p
            if true_comm[node_1]==true_comm[node_2]: 
                if r < p:   
                    edges.append((node_1,node_2))

            else : #if nodes in different clusters link them with probability q
                if r < q:
                    edges.append((node_1,node_2))
    
    # Create networkx graph object
    Gr= nx.Graph()
    Gr.add_nodes_from(range(nb_nodes))
    Gr.add_edges_from(edges)
    
    return Gr,true_comm


#exercice 3
def preprocess_communities(pathToData):
    return [int(line.replace('\t',' ').replace('\n',' ').split()[1])-1 for line in open(pathToData+"community.dat").readlines()]

def preprocess_edges(pathToData):
    # Reformat the string
    temp = [line.replace('\t',' ').replace('\n',' ').split() for line in open(pathToData+"network.dat").readlines()]     # Convert to tuples of integers and return
    return [(int(a)-1,int(b)-1) for a,b,c in temp[1:]]
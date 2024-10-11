#%%

import numpy as np

# Create random integer array between [0,2^4) of shape (50,8)
acts = np.random.randint(0,2**4,(50,8))

# Create random integer array between [0,2^1) of shape (8,8)  
weights = np.random.randint(0,2**1,(8,8))

# Matmul Acts X Weights
outs = acts @ weights

# Take 4 MSBs
outs_b = (outs & 0b1111000) >> 3

print(outs.max())
print(outs_b.max())
#%%

np.savetxt('outs.csv',outs,fmt='%i')
np.savetxt('outs_b.csv',outs_b,fmt='%i')
np.savetxt('acts.csv',acts,fmt='%i')
np.savetxt('weights.csv',weights,fmt='%i')

#%%

import seaborn as sns

sns.histplot(outs.flatten())
sns.histplot(acts.flatten())


# %%

outs = np.loadtxt('outs.csv',dtype=int)
acts = np.loadtxt('acts.csv',dtype=int)
weights = np.loadtxt('weights.csv',dtype=int)
# Keep upper 4 bits

def upper4bit(num):
    (outs[0] & 0b111100) // 2**2


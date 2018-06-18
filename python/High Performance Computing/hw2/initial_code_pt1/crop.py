import numpy as np
def crop(F, T = 0.0, B = 0.0, L = 0.0, R = 0.0):
   """Crop image represented by matrix F. T,B,L,R indicate 
how much of the image should be removed from the top, bottom,
left, and right of the original image.
"""
def onecrop(F = np.zeros((3,3,3)), T = 0.0, B = 0.0, L = 0.0, R = 0.0):
   """Crop image represented by matrix F. T,B,L,R indicate 
how much of the image should be removed from the top, bottom,
left, and right of the original image.
"""
   assert (0<=T<1), 'Error: T must be in [0,1)'
   assert (0<=B<1), 'Error: B must be in [0,1)'
   assert (0<=L<1), 'Error: L must be in [0,1)'
   assert (0<=R<1), 'Error: R must be in [0,1)' 
   assert (T+B<1), 'Error: Ensure T + B < 1'
   assert (L+R<1), 'Error: Ensure L+R<1'
   m, n, k = F.shape
   Rt = np.floor(T*m)
   Rb = np.floor(B*m)
   Rl = np.floor(L*n)
   Rr = np.floor(R*n)
   F = F[ Rt : m-Rb , Rl : n-Rr, :]
   return F
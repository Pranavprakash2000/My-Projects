#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
import pandas as pd


# In[2]:


df=pd.read_csv(r'C:/Users/DELL/Downloads/heart.csv')
df


# In[3]:


df.shape


# In[4]:


df.describe()


# In[5]:


print(df.isna().sum())


# In[10]:


x=df.iloc[:,:-1].values
x
y=df.iloc[:,-1].values
y


# In[11]:


from sklearn.model_selection import train_test_split
x_train,x_test,y_train,y_test=train_test_split(x,y,test_size=0.30,random_state=1)
x_train
x_test
y_train
y_test


# In[12]:


from sklearn.preprocessing import StandardScaler
scaler=StandardScaler()
scaler.fit(x_train)
x_train=scaler.transform(x_train)
x_test=scaler.transform(x_test)
x_train
x_test


# In[14]:


from sklearn.neighbors import KNeighborsClassifier
classifier=KNeighborsClassifier()
classifier.fit(x_train,y_train)
y_pred=classifier.predict(x_test)
y_pred


# In[15]:


from sklearn.metrics import confusion_matrix,accuracy_score,classification_report
print(classification_report(y_test,y_pred))
result=confusion_matrix(y_test,y_pred)
result
score=accuracy_score(y_test,y_pred)
score


# In[ ]:





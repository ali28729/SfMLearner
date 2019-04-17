from __future__ import division
%pylab inline
import os
import numpy as np
import PIL.Image as pil
import tensorflow as tf
from SfMLearner import SfMLearner
from utils import normalize_depth_for_display
import cv2
import glob
import gc



def saveGraph(path, ckpt_file, img_height, img_width):
    tf.reset_default_graph()
    fh = open(path, 'rb')
    I = pil.open(fh)
    I = I.resize((img_width, img_height), pil.ANTIALIAS)
    I = np.array(I)
    sfm = SfMLearner()
    sfm.setup_inference(img_height,
                        img_width,
                        mode='depth')
    saver = tf.train.Saver([var for var in tf.model_variables()]) 
    with tf.Session() as sess:
        saver.restore(sess, ckpt_file)
        pred = sfm.inference(I[None,:,:,:], sess, mode='depth')
        figure(figsize=(15,15))
        
    fig = plt.figure(figsize=(15, 13))
    # prep (x,y) for extra plotting
    xs = np.linspace(0, 2*np.pi, 60)  # from 0 to 2pi
    ys = np.abs(np.sin(xs))           # absolute of sine
    ax = []
    # create subplot and append to ax
    ax.append( fig.add_subplot(1, 2, 1) )
    plt.imshow(I, alpha=1)
    # create subplot and append to ax
    ax.append( fig.add_subplot(1, 2, 2) )
    plt.imshow(normalize_depth_for_display(pred['depth'][0,:,:,0]), alpha=1)
    plt.savefig(os.path.join('DepthMask',path))  # finally, render the plot
    # Clear the current axes.
    plt.cla() 
    # Clear the current figure.
    plt.clf() 
    # Closes all the figure windows.
    plt.close('all')
    fh.close()



ckpt_file = 'models/model-190532'
path = '10fpsAll_dataset/2011_09_28'
subfolders = [f.path for f in os.scandir(path) if f.is_dir()]    



for folder in subfolders:
    try:
        os.makedirs(os.path.join('DepthMask',folder,'image_02/data'))
    except OSError as e:
        if e.errno != errno.EEXIST:
            raise
            
    for file in glob.glob(os.path.join(folder,'image_02/data/*png')):
        saveGraph(file, ckpt_file, 312, 416)   


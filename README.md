# HMR2300-Magnetometer-MATLAB
A MATLAB library for working with the HMR2300 Magnetometer from Honeywell.

I am uploading here some of the codes I used to work with the HMR2300 3-axis magnetometer manufactured by Honeywell.

The functions are reasonably well commented, so I will leave this readme as small as possible by now. When I have some time, I will update here a cool readme. 

###########################################

Electrical connection:

If you have bought the standalone sensor - as I did - and thought that using it would be as easy as connecting the sensor to a serial-to-USB converter, and then to your PC, then you might be wrong.

The datasheet of the sensor indicates that it is necessary a 9V DC source between two pins of the serial connector, otherwise the sensor will not turn on. If you are getting no response from the sensor, then this comment is a clue. Also the following command may be useful if you want to test communication:
#aaaaaaaaaaaaaaaaaaaaaaaaaaaa
The response must be "Re-enter". It works with any combinations of characters not recognizable as a valid command or with 10 or more characters after the asterisk.

###########################################

Testing the sensor outside MATLAB:
A good software to test the sensor outside the MATLAB environment is Termite. Termite must be configured with the settings in the image below.

<IMAGE HERE>

Note: If the sensor is connected to Termite, it will not respond to commands in MATLAB. In order to use it in MATLAB, you must disconnect the sensor from Termite. The same occurs if you migrate from MATLAB to Termite: you must close and clear the sensor serial objects constructed into MATLAB before working with Termite.

###########################################

Some tags to facilitate searchs: HMR2300, HMR 2300, 3-axis magnetometer, MATLAB, data acquisition, Darth Vader, Obi-Wan Kennobi

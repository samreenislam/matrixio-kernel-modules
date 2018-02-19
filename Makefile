DTC=dtc

snd-soc-matrixio-objs := matrixio-codec.o
snd-pcm-matrixio-objs := matrixio-pcm-capture.o

obj-m += matrixio-core.o
obj-m += matrixio-uart.o
obj-m += matrixio-everloop.o
obj-m += snd-soc-matrixio.o
obj-m += matrixio-codec.o
obj-m += matrixio-pcm-capture.o
obj-m += matrixio-gpio.o
obj-m += matrixio-env.o
obj-m += matrixio-imu.o

all:	matrixio.dtbo
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

matrixio.dtbo: matrixio-overlay.dts
	$(DTC) -W no-unit_address_vs_reg -@ -I dts -O dtb -o matrixio.dtbo matrixio-overlay.dts

install: matrixio.dtbo
	sudo cp matrixio.dtbo /boot/overlays
	sudo cp matrixio*.ko /lib/modules/$(shell uname -r)/kernel/drivers/mfd
	sudo cp snd-*-matrixio.ko /lib/modules/$(shell uname -r)/kernel/sound/soc/codecs
	sudo depmod -a

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	sudo rm /lib/modules/$(shell uname -r)/kernel/sound/soc/codecs/*matrixio*
	rm *.dtbo
